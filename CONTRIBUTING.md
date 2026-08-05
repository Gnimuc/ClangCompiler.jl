# Contributing

ClangCompiler.jl wraps the parts of the Clang C++ API that `libclang` does not expose. Because
those parts have no C ABI, the package is three layers, and which layer you are editing decides
almost everything about how to change it.

## The three layers

| layer | what it is | edit by hand? |
|---|---|---|
| `deps/ClangExtra/` | `libclangex`, a hand-written C shim over Clang's C++ API | yes |
| `lib/<llvm_major>/LibClangEx.jl` | raw Julia bindings, generated from those headers | **no** — regenerate |
| `src/clang/` | the hand-written Julia wrapper | yes |

`src/compiler/` sits on top of `src/clang/` and is the user-facing API (`create_interpreter`,
`parse`, `execute`, `get_function_pointer`).

`lib/LibClang.jl` is the one exception to "never hand-edit `lib/`": it is a small hand-maintained
excerpt of `libclang` bindings, not generator output.

The C shim is deliberately **type-erased** (every handle is `void *`) and **check-free** (plain
`static_cast`, no null checks, no error codes). All of that erased safety is re-established in
`src/clang/`, which is therefore the only safety boundary in the package. Do not push validation
down into C, and do not expect C to check anything.

## Getting set up

```bash
# Run the full suite. Do this before every commit — a test file can pass standalone and still
# crash in the suite, because earlier files leave different AST state behind.
julia --project -e 'using Pkg; Pkg.test()'

# Rebuild the C shim after editing deps/ClangExtra. Writes LocalPreferences.toml so the package
# loads your build instead of libclangex_jll. Pass a directory to keep an incremental tree.
julia --project=deps deps/build_local.jl [build_dir]

# Regenerate the raw bindings after changing any ClangExtra header.
julia --project=gen gen/generator.jl
```

Each test file is self-contained, but running one on its own needs the test environment, and
`TestEnv.activate()` switches to a temp directory that has no `LocalPreferences.toml` — so the
package would silently load the released `libclangex_jll` instead of your build, and new symbols
would fail at call time looking like C-side bugs. Copy the preference across first:

```bash
julia --project -e 'using TestEnv; TestEnv.activate();
  cp("LocalPreferences.toml", joinpath(dirname(Base.active_project()), "LocalPreferences.toml"); force=true);
  include("test/lookup.jl")'
```

Two things about reading a run: piping to `tail` reports *tail's* exit status, so redirect to a
file and grep it; and a crash never prints the word "Fail" — a segfault prints `signal 11 (2):
Segmentation fault` (or `EXCEPTION_ACCESS_VIOLATION`), a libstdc++ assertion prints `SIGABRT`.

## Changing the C shim

A C-side change is not finished when it compiles. It is finished when all of this has happened:

1. the header **and** the `.cpp` have moved together — the signatures are `extern "C"` over
   `void *`, so neither the compiler nor the linker catches drift between declaration and
   definition, and the failure surfaces at Julia runtime as corruption or a `dlsym` error;
2. any new `.cpp` is registered in the `CMakeLists.txt` of its own directory under
   `deps/ClangExtra/lib/` — an unregistered file builds to nothing, and the symbol goes missing
   only when Julia first calls it;
3. the regenerated bindings are **committed alongside the header change** — CI never regenerates,
   it only checks that the committed file is what the generator produces;
4. a Julia wrapper exists — `test/lint.jl` fails on a binding that is neither wrapped nor
   explicitly stamped;
5. a release also needs a `libclangex_jll` version bump, since that is the build users load.

Before wrapping a method at all, check it exists in the *shipped* library rather than only in the
header. Clang declares methods that no target implements, and calling one aborts the process:

```bash
nm -gU -C <llvm_artifact>/lib/libclang-cpp.dylib | grep '::<method>('
```

`-gU` means external **and** defined. A symbol can be present but file-local, which links
nowhere: `Sema::CheckBitwiseOperands` is local while its sibling `CheckAdditionOperands` is
external, and a plain `nm -C` finds both. No external symbol means the method is dead — do not
wrap it.

For anything whose signature does not fit through a `void *` — value types, iterator ranges,
arbitrary-precision numbers, optionals — follow `deps/ClangExtra/MARSHALLING.md` rather than
inventing a scheme. Extend that file if your case is new.

## Naming

### C API (`libclangex`)

* Types are prefixed `CX`, as in `libclang`.
* Functions are `clang_<ClassName>_<methodName>`, with **both segments copied from Clang
  verbatim, including case**. That is what lets a symbol be grepped straight against the Clang
  header it wraps — and a mis-cased class segment hides the entire class from tooling that
  matches on the prefix.
* Only invented names depart from that: `_create` / `_dispose`, the `castTo<Derived>` helpers,
  and composite convenience wrappers that are not 1:1 with a Clang method.
* On a name collision with `libclang`, the `libclangex` symbol takes a trailing underscore —
  `libclang` exposes `CXToken`, so this shim exposes `CXToken_`.
* Renaming an existing symbol moves the bindings, the Julia callers and the shipped binary at
  once, so it belongs in a commit of its own. Whether a name *may* be renamed depends on whose
  it is: segments copied from Clang track Clang and must not be "corrected"; invented spellings
  are ours to fix.

### Julia API

The goal is to stay as close to Clang's own C++ API as the language allows, which is why most
wrappers keep Clang's camelCase method names rather than Julia style.

* Each wrapped Clang class gets a carrier struct named after the class with the `CX` dropped.
  Names that would collide with `Base` take a trailing underscore (`Expr` → `Expr_`, `Type` →
  `Type_`); `CXToken_` becomes `Token`. **Every** class gets one, abstract C++ bases included —
  `Stmt`, `Expr_` and `Decl` are all abstract in C++ and all carry, because a base-typed handle
  has to land somewhere before the caller resolves it.
* One name cannot be both a carrier and an abstract type, and `Abstract` + `X` collides
  wherever clang also has a class literally named `AbstractX` — both want that spelling, and
  only one can have it. Such a class is **not mirrored**: no carrier, no abstract type, and its
  children hang off its parent, so the subclass keeps the natural name. What the dropped class
  declared is written out on each of its children, whose receivers then name classes clang
  actually builds.
* Clang's **single** inheritance is reproduced with abstract types and subtyping, class for
  class: the derived→primary-base conversion is a no-op, so one `unsafe_convert` per carrier is
  correct for every base method it reaches.
* Its **multiple** inheritance cannot be, because the second base's conversion is not a no-op.
  A `NamespaceDecl`'s `DeclContext*` sits 48 bytes past its `Decl*`, a `TagDecl`'s 64, a
  `TranslationUnitDecl`'s 40 — and a carrier has one `ptr`. Julia's abstract types are
  single-inheritance too, so no carrier can subtype both hierarchies. They stay disjoint and
  are crossed by the pivot casts, which call the C functions that apply the adjustment.
* What *can* be expressed is the **set**. `DeclNodes.inc` marks each dual-role class
  `DECL_CONTEXT`, and `AbstractDeclContextDecl` is a generated `Union` over exactly those, so a
  decl may be passed straight to the `DeclContext` API — `isNamespace(ns)` rather than
  `isNamespace(castToDeclContext(ns))`. The forwarding applies the pivot before the ccall, and
  a decl that is not a context fails at dispatch rather than at the pivot's assert.
  Two things this does **not** license: the cast cannot move into the C entry points, since a
  `void *` there cannot tell a `Decl *` from a real `DeclContext *`; and a name declared on both
  `Decl` and `DeclContext` is left unforwarded, because the `Union` is the more specific
  signature and would shadow the `Decl` one (`getDeclKindName` is the case, and that call is
  ambiguous in C++ too).
* Wrappers drop both the `clang_` prefix and the class segment, so
  `clang_CompilerInstance_hasDiagnostics` becomes `hasDiagnostics`. The receiver becomes the
  first argument, typed at the abstract supertype of the class that *declares* the method and no
  looser — that typing is what makes multiple dispatch reject a mistyped receiver before the
  ccall, so it is load-bearing rather than decorative.
* The file trees under `src/clang/core/` and `src/clang/api/` mirror the LLVM/Clang source tree.
  Put a wrapper in the file matching the Clang header its class lives in.
* Helpers that are not 1:1 with a Clang method — `src/compiler/`, `src/lookup.jl` — use ordinary
  snake_case, following [YASGuide](https://github.com/jrevels/YASGuide).
* The package uses `public` rather than `export`; add a line in `src/ClangCompiler.jl` for any
  user-facing name.

## Writing a wrapper

A wrapper is three lines long and each one is doing a job. The C `static_cast` behind it is only
valid because of these:

```julia
function getRetValue(x::AbstractReturnStmt)
    @check_ptrs x                                    # every pointer argument: assert non-NULL
    return Expr_(clang_ReturnStmt_getRetValue(x))    # wrap the return in its carrier
end
```

* **A carrier's Julia type must match its pointee's real dynamic C++ class.** Construct a
  concrete carrier only from `resolve(x)`, from a `castTo<Derived>` (null-safe, NULL carrier on
  the wrong kind), or from a getter whose C++ return type *is* statically that class. When a C
  method hands back a base handle, wrap it at that base and let the caller refine — a carrier
  that lies makes the next `static_cast` in C undefined behaviour while Julia dispatch looks
  perfectly happy.
* **Type the receiver at the class that declares the method**, as in the naming section above.
* **Restate the C++ method's preconditions as `@assert`.** Many Clang accessors are partial: they
  reach a subobject through an unchecked `castAs<>()` or dereference a `getAs*()` that can return
  null. On the wrong input that is undefined behaviour, not a null return — and it is
  platform-dependent, so it can pass on macOS and Linux and fault only on Windows CI. Reading the
  method's body in the Clang header tells you which; `castAs<>`, `->getDecl()`, `*optional` and
  `assert(...)` are all signals.

Never return a raw `Ptr` from a wrapper. `CXString` returns go through `get_string` (which
disposes them — a plain `unsafe_string` leaks); `const char *` through `unsafe_string`; bools,
integers and enums come back bare.

Objects holding a C++ resource need an explicit `dispose(x)`. Tests and examples follow
create → use → dispose, and new ones should too.

## What CI enforces

Three test files are mechanical gates rather than feature tests. Knowing what they catch saves a
round trip:

* **`test/lint.jl`** — duplicate typedefs, colliding include guards (a collision silently drops a
  header from the generated bindings), unregistered `.cpp` files, declared-but-undefined
  functions, bindings that are neither wrapped nor stamped, and unguarded `getType` reads on an
  arbitrary `Expr`.
* **`test/abi.jl`** — that every bound symbol resolves in the shipped library, that carriers are
  single-field structs carrying their converts, that no carrier accepts a foreign handle, and —
  by inferring every method in the package — that no wrapper can *never* return. A body that
  always throws infers to `Union{}`, which is the shape a latent wrapper bug takes once handles
  have distinct types, and it is the only check here that sees code no test exercises.
* **`test/tautologies.jl`** — assertions that cannot fail. `@test f(x) isa Bool` on a `::Bool`
  ccall restates this repo's own source rather than anything Clang decided.
* **the `Examples run` CI job** — every script under `examples/`. They rotted silently once,
  referencing an API generation removed years earlier, because nothing ran them. If you change a
  public API and that job reddens, the example is telling you the change reached users.

CI runs macOS, Linux and Windows on x86_64, and an assertion on something the *runner* decides —
an integer width, a mangled name, a layout offset — passes locally and reddens on a platform you
never ran. Most of those are not unassertable, only unpinned: build with
`create_interpreter(...; triple="x86_64-linux-gnu")` and every one becomes an equality that reads
the same everywhere. `test/clang/pinned_target.jl` is the worked example. Only parsing and AST
inspection cross-target — the JIT still emits for the host — and pinning downloads that target's
GCC shard, so keep it to one target in one file rather than pinning at every site.

## Tests

New code needs a test that could fail if the code were wrong, which is less automatic than it
sounds. Three rules, the first two enforced by `test/lint.jl` and `test/tautologies.jl`:

* **A loop whose body is the only thing asserting proves nothing when the loop is empty.**
  Construct the state that makes the assertion run, or assert the empty case explicitly.
* **Never assert a type the wrapper's own return expression already fixes.** `@test f(x) isa Bool`
  on a `::Bool` ccall restates this repo's source, not anything Clang decided, so it cannot tell
  a correct shim from one returning a null or another argument's payload. Assert a value, a round
  trip, or a relationship the shim could get wrong. Where the value genuinely is not assertable,
  mark the site `# shape-only` with the reason.
* **Prefer an invariant that holds over any AST to a pinned value** — a parent's source range
  contains its children's, a binary operator's two operands are distinct nodes. A pin catches
  drift from today's answer but freezes the bug if today's answer has always been wrong. See
  `test/clang/invariants.jl`, and `test/clang/differential.jl` for the oracle that checks the
  shim against clang's own `-ast-dump` rather than against itself.

Test files mirror the source tree, and a new one must be added to `test/runtests.jl` by hand.

Format with JuliaFormatter, YAS style, margin 1000 (`.JuliaFormatter.toml`); `lib/` and
`examples/` are excluded. The margin sits past the longest line in the repo, so the formatter
never splits one — but it will still *join* anything that now fits, hand-placed breaks
included, so don't run it over the tree. Match the file you are editing.
