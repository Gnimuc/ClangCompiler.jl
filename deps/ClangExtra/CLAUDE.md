# CLAUDE.md — ClangExtra (libclangex)

Guidance for working on the hand-written C API shim over Clang's C++ API. The repo-root
CLAUDE.md covers the overall package; this file covers the C/C++ wrapper conventions.
Everything compiles into one shared target `clangex` (C++17, `-fPIC -fno-rtti`, links the
monolithic `LLVM` + `clang-cpp` shared libs). Format C++ with clang-format (LLVM style,
ColumnLimit 92 — narrower than the Julia code's 120), but always pass
`--sort-includes=false`: reordering the includes in a CX header changes the order the
binding generator walks declarations, and one moved `#include` rewrites ~8,000 lines of
`lib/18/LibClangEx.jl` for no semantic gain.

## The governing axiom

This C API has exactly one client: the Julia thin wrapper in `src/clang/`. It is not a
public C library — nothing else, C or C++, ever calls it directly. Every other rule in this
file derives from that single fact, and the choices that look unsafe in isolation are
principled because of it:

- **Handles are distinct incomplete struct pointers** (`typedef struct CXFooImpl *CXFoo`),
  so the compiler rejects a handle passed where another class is wanted. What it still
  cannot see is the *hierarchy*: `CXIfStmt` and `CXStmt` are unrelated to it, so every
  base/derived crossing is a `reinterpret_cast` the compiler takes on trust. Clang's class
  hierarchy and its multiple-inheritance pivots are reproduced one layer up, in Julia.
- **Payload downcasts are unchecked, not `dyn_cast`.** The wrapper has already
  established the receiver's dynamic type before it calls, so the cast's precondition holds
  by construction.
- **No null checks, no validation, no error codes cross the boundary** (see Error handling).
  Preconditions are the caller's contract, and there is exactly one caller.

The safety this discards is re-established entirely in the Julia thin wrapper, which is the
**sole safety boundary**. Two invariants there make every `reinterpret_cast` in this library
valid — they are specified and must be preserved in `../../src/clang/CLAUDE.md`:

1. **Faithful carriers** — a Julia carrier's type always reflects its pointee's true dynamic
   C++ class, because a carrier is only ever built from a pointer whose dynamic class is already
   established — see `../../src/clang/CLAUDE.md` for the three routes, only one of which is a
   checked cast.
2. **Correctly-leveled receivers** — each wrapper types its receiver at the abstract
   supertype of the C++ class that declares the method, so multiple dispatch rejects a
   mistyped receiver before the ccall is emitted.

Corollary for writing C here: never add defensive code to protect a hypothetical direct
caller — there isn't one. Keep the shim dumb and total; the type-checking intelligence lives
in Julia.

Corollary for *choosing* what to wrap: read the method in the pinned artifact header before
adding a shim for it. Two things are only visible there — access (`setParams` looks like
ordinary API but is private in clang 18, and the shim will not compile) and partiality
(methods reaching a subobject via `castAs<>`, `->getDecl()`, or `*optional` are UB on the
wrong input). Wrap the partial ones anyway, but say so in a header comment so the Julia
wrapper can restate the precondition as an `@assert`; that is Invariant 3 in
`../../src/clang/CLAUDE.md`. Never write a signature from memory — the compiler catches
arity drift, but nothing catches a precondition you did not notice.

A third thing the header does not tell you: whether the symbol is actually **exported** from
the monolithic `clang-cpp` this library links against. A method declared in an installed
header can still be defined in a translation unit whose symbol does not reach the shared
lib — `clang::CFGImplicitDtor::isNoReturn` is one. Such a wrapper compiles cleanly and fails
only at link time, after the whole tree has built. When a link error names a `clang::`
symbol, the fix is to drop that wrapper (leave a placeholder comment in header and .cpp
saying it is not exported), not to hunt for a missing library.

A fourth: a `virtual` whose in-class body is `llvm_unreachable` may have **no override at
all** in this LLVM version, which makes every call to it abort the process (SIGILL,
`Unreachable reached at 0x...`). `TargetInfo::getCPUSpecificTuneName` is one — X86 overrides
its two siblings `validateCPUSpecificCPUDispatch` and `CPUSpecificManglingCharacter` but not
it, so the sibling gate looks like a valid precondition and is not. Settle it against the
shipped library, not the header:

```bash
nm -gU -C <artifact>/lib/libclang-cpp.dylib | grep '::<method>('
```

Use `-gU` (external, defined): a symbol can be PRESENT but file-local, which links nowhere.
`Sema::CheckBitwiseOperands` and `CheckLogicalOperands` are `t` while their sibling
`CheckAdditionOperands` is `T`, so a plain `nm -C` finds all three and only one of them is
linkable. No external symbol back means the method is dead — drop the wrapper with a
placeholder comment. When overrides do exist, the gate must be the flag that selects those targets
(`hasIbm128Type` for `getIbm128Mangling`, which only PPC implements), asserted in Julia.

A fifth, and the one that looks least like our problem: **a C type's width is part of the
mangled name of every C++ function taking one**, and on Windows the two sides of that name come
from different toolchains — this library is compiled on the runner by msys2's mingw gcc, while
`clang-cpp` arrives prebuilt from BinaryBuilder. `getVirtualFileRef(StringRef, off_t, time_t)`
linked on macOS and Linux and failed on Windows alone for exactly that reason: mingw's `off_t`
is `long` under LLP64, 32 bits, where the prebuilt library had 64. No signature on our side
fixes it, because the mangling comes from clang's own declaration; the two have to be made to
agree, which `CMakeLists.txt` does with `_FILE_OFFSET_BITS=64`. `time_t` never had the problem
— the `addFile` call in `createFileManagerWithVOFS4PCH` takes one and always linked — which is
what isolated the cause to `off_t` rather than to the toolchains in general.

The Julia side of the same fact: `time_t` is 64 bits on every target but is `long long` on
mingw where the other two spell `long`, so entry points taking one spell `int64_t` and no alias
tracks it. `shim_type_width` asks this library its own widths and `test/abi.jl` asserts them, so
a toolchain flag change fails a test instead of corrupting a value.

## The rule that prevents disasters

**Header and .cpp must change in lockstep.** The Julia bindings are generated from the
headers alone, and `extern "C"` sits on the declaration only — so a definition whose signature
has drifted is a separate C++-linkage overload rather than a redeclaration, and neither the
compiler nor the linker says so. The failure surfaces at Julia runtime as a `dlsym` error,
never at build time.
Corollaries:

- A function defined only in the .cpp but missing from the header never reaches Julia.
- A .cpp missing from its `CMakeLists.txt` compiles into nothing — the symbol is missing
  only when Julia first calls it (the shared lib has no link-time consumer of its own
  symbols).
- Renaming any existing symbol is an ABI change: the regenerated bindings, the Julia callers
  and the shipped binary all have to move together, so a rename is only correct as a
  deliberate, self-contained commit — never as a drive-by inside a change about something
  else, which silently widens what that change requires to ship.

  *Which* names may be renamed follows from Naming below: the segments copied from Clang track
  Clang, oddities included, so "correcting" one desynchronises the shim from the header it
  wraps. Only the invented spellings are ours, and a defect in one of those is ours to fix.

## Layout and registration

- One header/impl pair per wrapped Clang header, in the directory mirroring the Clang
  source tree: `include/clang-ex/<Dir>/CX<Header>.h` + `lib/<Dir>/CX<Header>.cpp`
  (e.g. `clang/AST/DeclBase.h` → `AST/CXDeclBase.{h,cpp}`).
- Wrapper declarations/definitions keep the same order as methods in the Clang class.
  Unwrapped methods are left as `// methodName` placeholder comments, mirrored in header
  and .cpp (most files keep both sides in sync; a few are header-only); rejected
  experiments stay as commented-out code. Preserve this discipline — it makes diffing
  against upstream after LLVM bumps possible.
- A bare `// methodName` line means exactly one thing: **that method is not wrapped**. Never
  write one directly above the wrapper it names — the declaration already says the name, and
  a marker that sometimes means "absent" and sometimes means "here it is" cannot be read or
  counted. A `// ClassName` line heading a block of that class's wrappers is the one other
  use, and it names a class rather than a method.
- ALL opaque handles are `typedef struct CX<ClangClassName>Impl *CX<ClangClassName>;` in the
  central `include/clang-ex/CXTypes.h`, grouped under `// <Library>` / `// <ClangHeader>`
  comments in upstream declaration order. The five node families (Stmt, Decl, Attr, Type,
  TypeLoc) are the exception: their handles are stamped from the vendored .inc at the top of
  that file, so never add one by hand for a class the .inc already names — an LLVM bump
  should add the handle and its stamped cast together, or they drift. Don't typedef handles in per-class headers (one legacy
  stray exists: `CXFunctionDecl_DefaultedFunctionInfo` in AST/CXDecl.h — search beyond
  CXTypes.h when checking for an existing typedef; `CXTemplateSpecializationType` is
  already duplicated inside CXTypes.h itself). A typedef existing does not mean wrapper
  functions exist.
- On a name collision with libclang, the **type** gets a trailing underscore; function names
  never do. Using the un-underscored name in a new signature silently binds to libclang's
  unrelated type in the generated bindings, so check which spelling a type has before writing
  it rather than trusting a list here — this bullet said "exactly six" while the headers
  carried more, and the omitted ones are precisely the ones a contributor re-declares:

  ```bash
  grep -rhoE 'CX[A-Za-z0-9]+_;' include/clang-ex | sed 's/;//' | sort -u
  ```

  `test/lint.jl`'s guard against the bare spellings is derived from that same set, so the two
  cannot drift apart.
- Header skeleton: guard `LLVM_CLANG_C_EXTRA_<NAME>_H` (watch for copy-paste guard
  collisions — a colliding guard silently drops the header from the generated bindings); include
  `clang-ex/CXTypes.h`, `clang-c/ExternC.h`, `clang-c/Platform.h` (+ `clang-c/CXString.h`
  only if CXString appears, + `llvm-c/...` only if `LLVM*Ref` appears); wrap everything in
  `LLVM_CLANG_C_EXTERN_C_BEGIN/END`; zero-arg functions are `(void)`.
- .cpp skeleton: own clang-ex header first, then `"utils.h"` if producing strings, then
  clang/llvm C++ headers. `lib/` is on the include path, so `#include "utils.h"` works
  unqualified. `utils.h` is private — never include it from `include/clang-ex/`.
- CMake: add `target_sources(clangex PRIVATE ${CMAKE_CURRENT_LIST_DIR}/<file>)` lines —
  the .cpp in `lib/<Dir>/CMakeLists.txt` (**load-bearing**) and the .h in
  `include/clang-ex/<Dir>/CMakeLists.txt` (convention; headers install via the directory
  glob regardless). New subsystem dirs need `add_subdirectory` in both parents
  (alphabetical). Never create a second target, and never add visibility/dllexport
  attributes — export-everything is configured globally.

## Naming

- `clang_<ClassName>_<methodName>` with the C++ method name copied **verbatim including
  case** (`getDiagnostics`, but `ExecuteAction`, `Parse`, `CreateTargetInfo`). Static
  member functions keep the class segment and take no receiver; namespace-level free
  functions use the namespace as the class segment (`clang_CodeGen_convertTypeForMemory`)
  or drop it entirely (`clang_ParseAST`).
- First parameter is the receiver, named with the class-initial abbreviation (FD, DC, CI…).
- Only invented names are lowercase `_create`/`_dispose`, and `castTo<Derived>` helpers.
- Composite convenience wrappers (not 1:1 with a Clang method) are allowed; give them an
  intent-revealing name (`clang_CompilerInstance_setTargetAndLangOpts`,
  `clang_EnumConstantDecl_getEnumConstantDeclValue` — the latter marked `// helper` in
  its header).

## Marshalling

The trivial shapes are below. For value types, iterator ranges, arbitrary-precision numbers,
and other out-of-band results that a plain handle accessor can't carry, follow the playbook in
`MARSHALLING.md` (APValue/APSInt/APFloat, `std::string`→CXString, count+fill vs count+index for
ranges, exposing aggregate fields, discriminated unions, opaque navigation handles) — extend
that file rather than inventing a one-off scheme.

- Handle → C++: `reinterpret_cast<clang::T *>(h)`. It cannot be `static_cast`: a handle is its
  own incomplete struct type, unrelated by inheritance to the Clang class it stands for, and
  `static_cast` between unrelated pointer types is ill-formed — the compiler rejects it.
  Never `dynamic_cast`/`typeid` (built with `-fno-rtti`), never C-style casts. `T&` returns →
  `return &...;` const returns → `const_cast` (the C surface is all non-const handles).
  Reference params → deref a pointer arg.
- Downcasts: `clang_<Base>_castTo<Derived>` = `llvm::dyn_cast_or_null<clang::Derived>(...)`
  (null-safe, nullptr on wrong kind), **returning `CX<Derived>` rather than the base handle**
  so the Julia carrier it feeds is checked against it, placed under a `// <Base> Cast` comment at the end
  of that class's section (files hold several classes; casts close each section, not the
  file). Decl ↔ DeclContext cross-casts go through Clang's static
  `Decl::castToDeclContext`/`castFromDeclContext` or `dyn_cast` — never a plain pointer
  cast of the handle (multiple inheritance shifts the pointer).
- Value types cross by encoding, never as object pointers: `SourceLocation` ↔
  `.getPtrEncoding()` / `SourceLocation::getFromPtrEncoding()` (a `CXSourceLocation_` is
  the encoding itself — casting it to `SourceLocation*` and dereferencing is wrong);
  `QualType`/`DeclarationName`/`DeclGroupRef` ↔ `getAsOpaquePtr`/`getFromOpaquePtr`;
  `TemplateName` ↔ `getAsVoidPointer`/`getFromVoidPointer`. `SourceRange` returns by value
  as `CXSourceRange_{b.getPtrEncoding(), e.getPtrEncoding()}`; SourceRange parameters are
  passed as `CXSourceRange_` by value (`clang_TagDecl_setBraceRange`,
  `clang_CXXConstructExpr_setParenOrBraceRange`, `clang_ASTUnit_mapRangeToPreamble`). Pass
  one that way rather than decomposing it into two `CXSourceLocation_` args — no entry point
  here takes that shape, so a new one would be alone in the library.
- Strings out: computed/temporary → `extra::makeCXString(std::string)` from `utils.h`
  (strdup + CXS_Malloc; empty string is a static unmanaged ""; Julia frees via libclang's
  `clang_disposeString` — libclangex ships no string-free functions). Stable Clang-owned
  storage → borrowed `const char*` (`StringRef.data()`). The third pattern is the two-call
  length+fill protocol (`GetResourcesPathLength` + fill) — note it copies exactly N bytes
  with **no NUL terminator**. Strings in: `const char*` → `llvm::StringRef`, or an
  explicit `(const char*, size_t)` pair when length matters.
- Arrays: `ArrayRef` returns → `CXArrayRef{arr.data(), arr.size()}` (borrowed view into
  AST-owned memory, element type implied by the function, never freed); or the
  `getNum*()` + `get*(unsigned i)` index pair; or count+fill into a caller buffer. Array
  inputs are `(ptr, count)` rebuilt with `llvm::ArrayRef`.
- LLVM (non-Clang) objects cross as LLVM-C types (`LLVMModuleRef`, `LLVMOrcLLJITRef`,
  `LLVMOrcExecutorAddress`…) converted with `llvm::wrap`/`llvm::unwrap` where llvm-c
  exposes them (Module, Context, MemoryBuffer, Type). Where llvm-c has no public
  wrap/unwrap, the established pattern is `reinterpret_cast` — currently the
  `LLVMGenericValueRef ↔ llvm::GenericValue*` bridge for APSInt values and the
  `LLVMOrcLLJITRef` return in `clang_Interpreter_getExecutionEngine`. **Never mint a
  parallel `CX` type for something llvm-c or LLVM.jl's libLLVMExtra already exposes** (APInt,
  APFloat, Value, Type, Module, …); reuse the LLVM-C handle, and if an accessor is missing add
  it to libLLVMExtra in llvm-c style so it stays upstreamable. See `MARSHALLING.md` §0.

## The stamped Stmt layer (AST/CXStmt.h)

The Stmt hierarchy's classification surface is NOT hand-written: `CXStmtClass`
and the `clang_Stmt_castTo*`/`clang_Stmt_is*` families are stamped by X-macro
from the vendored `include/clang-ex/AST/StmtNodes.inc` (a verbatim copy of the
pinned LLVM version's TableGen output — vendored because the binding generator
drops declarations expanded from `-isystem` paths). Rules: never edit the
vendored .inc (re-copy it on an LLVM bump; the static_assert tables in
CXStmt.cpp fail the build if it goes stale); stamped symbols are
version-following per LLVM major, exempt from the frozen-ABI rule; per-class
payload accessors are hand-written in the normal per-header files, NOT stamped.
gen/generator.jl auto-ignorelists the .inc's transient per-class macros and
emits explicit Julia source under src/ (StmtAbstractGen.jl, StmtCarriers.jl, StmtWrappers.jl,
StmtClassMap.jl — the Julia layer stamps from no runtime table) — both
regenerate with the bindings.

## Enums

- Every mirrored enum MUST have an ENUM_SYNC table in lib/Basic/CXEnumSync.cpp
  covering every enumerator — a partial mirror silently ships missing enumerators
  and wrong numbering.
- CXEnumSync.cpp ends with a single `#undef ENUM_SYNC`; new tables go **before**
  it (appending past it expands `ENUM_SYNC` as an undeclared identifier), and the
  file needs both the new `clang-ex/...` header and the clang header that defines
  the enum — it includes each explicitly rather than relying on transitivity.
- Alias enumerators (`First*`/`Last*`/`*_BEGIN`/`NumKinds`) are deliberately
  omitted from mirrors: they duplicate values, which Julia's `@enum` rejects.
  Omitting them does not shift numbering, since they are `=` assignments.
- Mirror as `typedef enum CX<ClangEnumName> { CX<ClangEnumName>_<EnumeratorVerbatim>, ... }`
  in the subsystem header matching the Clang header the enum lives in (shared clang/Basic
  enums → `include/clang-ex/Basic/*.h`; class-local enums inline in the class's CX header).
  CXTypes.h's lone `CXTranslationUnitKind` is a legacy exception, not the pattern.
  Place a class-local enum **before the first accessor that returns it** — C requires the
  enum defined ahead of its use, and a later batch adding `getFoo() -> CXFooKind` will not
  compile if the enum sits further down the header. `-fsyntax-only` catches this; the design
  agent cannot, since it only sees its own additions, not where a prior batch put the enum.
- Copy Clang's explicit underlying type when it has one (`: unsigned char` → Julia
  `@enum ...::UInt8`); the default maps to UInt32. The one type NOT to copy is
  `signed char`/`int8_t` (`llvm::RoundingMode`): the binding generator dies on it with
  "Unknown EnumConstantDecl type: CXType_SChar" — Clang.jl reads `CXType_Char_S` but not
  `CXType_SChar`. Mirror those with no explicit underlying type and say why in a comment;
  the value crosses by value through a `static_cast`, never by pointer and never inside a
  struct, so the widths need not agree.
- Conversion is a blind `static_cast` in both directions — **order and values must match
  the pinned LLVM version's header exactly**, verified against the actual artifact header
  (`~/.julia/artifacts/<LLVM_full_jll>/include/clang/...`), not memory. A mirror that lags
  the pinned LLVM version's numbering returns values shifted from what callers expect.
- Pure-enum headers get no .cpp and are registered only in the include-side CMakeLists.
  The six Basic ones (CXLinkage.h, CXSpecifiers.h, CXLambda.h, CXPragmaKinds.h,
  CXVisibility.h, CXExceptionSpecificationType.h) contain no #includes at all and must be
  included after a header that already provides the extern-C macros;
  AST/CXOperationKinds.h instead includes ExternC.h/Platform.h itself and is
  self-sufficient — the latter is the safer style for new enum headers.
- Two-state enum-class params (e.g. `ImplicitTypenameContext`) are exposed as `bool` and
  bridged with a ternary.

## Ownership

The only reliable way to tell ownership is to read the impl; these are the rules to write
new code by:

- Caller-owned: a heap-allocating `_create` = `std::make_unique<T>(...).release()` with a
  matching `_dispose` = `delete reinterpret_cast<T*>(h)` declared in the same header (creates
  that return a value encoding, like `clang_DeclarationName_create`, allocate nothing and
  have no dispose). Subclass creates return the BASE-class handle and share the base
  `_dispose` (`clang_TextDiagnosticPrinter_create` → `CXDiagnosticConsumer`,
  `clang_DiagnosticConsumer_dispose`).
- Borrowed: `get*` accessors normally return interior pointers — no dispose exists, and
  disposing a handle obtained from a getter is a double free even when the same handle
  type has a `_dispose` (`getInvocation` vs `clang_CompilerInvocation_create`). The
  exceptions are getters forced to heap-box a by-value C++ return —
  `clang_FileManager_getFileRef` (→ `clang_FileEntryRef_dispose`),
  `clang_SourceManager_getMainFileID` (→ `clang_FileID_dispose`) — and
  `clang_FileManager_getBufferForFile`, which hands the caller an owned
  `LLVMMemoryBufferRef`.
- **Adoption overrides dispose.** Once an object is handed to an owning Clang API, its
  `_dispose` becomes a double free: `clang_Interpreter_create` consumes the
  CompilerInstance (even on failure); `setInvocation`/`setPreprocessor` wrap the raw
  handle in a fresh `shared_ptr`; `setASTConsumer` in a `unique_ptr`;
  `clang_DiagnosticsEngine_create` adopts the IDs/Options (and the consumer iff
  `ShouldOwnClient`); `clang_TargetInfo_CreateTargetInfo` absorbs the TargetOptions;
  `createFileIDFromMemoryBuffer`/`overrideFileContents`/`createFileManagerWithVOFS4PCH`
  consume the `LLVMMemoryBufferRef`.
- C++ objects returned **by value** with no pointer encoding (FileEntryRef, FileID,
  TemplateArgument) are heap-boxed with make_unique/release and get an explicit dispose —
  flag this in a header comment. Most AST wrappers hand back ASTContext-arena memory and have
  no dispose, but do not read that as "AST handles are never owned" — the rule is that an
  AST-area handle gets a dispose exactly when the shim heap-boxes a by-value C++ object or
  `new`s one itself, and a good many do. Ask rather than assume:

  ```bash
  grep -rhoE 'clang_[A-Za-z0-9_]+_dispose' include/clang-ex/AST | sort -u
  ```

  `clang_ASTContext_createMangleContext` and its device twin forward to a clang factory
  that `new`s — `clang_MangleContext_dispose` is the matching release, and `clang::MangleContext`
  has a virtual destructor, so deleting through the base runs the subclass's.
- Lifetime traps documented in code, keep them true: `clang_SourceManager_create` stores
  references (dispose SourceManager before its FileManager/DiagnosticsEngine);
  `clang_Interpreter_Parse` returns a pointer into the interpreter's PTU list (invalidated
  by `Undo`); `SetCompilerArgs` stores only the char pointers (strings must outlive the
  builder until `Create*`); a Parser from `clang_Interpreter_getParser` is borrowed while
  `clang_Parser_create`'s is owned.

## Error handling

- Nothing crosses the C boundary: no exceptions and no error codes — checks happen
  on the Julia side. Fallible calls (`llvm::Expected`/`ErrorOr`/`llvm::Error`) are
  unwrapped in the shim: log to `llvm::errs()` and return a sentinel (nullptr for
  pointers, 0 for `LLVMOrcExecutorAddress`); void wrappers log the same way but give the
  caller no failure signal. Always consume the `Error` (`toString(std::move(E))`) — a
  destroyed-unconsumed Error aborts under LLVM assertion builds, which build_local.jl
  supports. The `"LIBCLANGEX ERROR: "` prefix is the Interpreter-file convention; other
  files log unprefixed messages — match the local file.
- Most wrappers deliberately have zero checks (the Clang methods can't fail); don't add
  ad-hoc validation. Null/precondition checking is the Julia layer's job (`@check_ptrs`,
  `@assert hasX`).
- One known anti-pattern not to copy: `clang_Interpreter_getExecutionEngine` dereferences
  an `Expected` without checking.

## upstream/ — private-header hacks

`upstream/` holds verbatim copies of Clang headers edited ONLY to change member access
(inserting `public:`/`private:`) so wrappers can reach private members (currently
`Interpreter::IncrParser` and `IncrementalParser::P`). It's on the include path as
`CLANG_SRC`, so `#include "Interpreter/Interpreter.h"` gets the hacked copy while
`#include "clang/Interpreter/Interpreter.h"` gets the real one — CXInterpreter.cpp uses
the hacked copies, CXValue.cpp the real header; this ODR tightrope is safe only because
the class layout stays byte-identical. Rules: never reorder/add/remove data members, only
access-specifier edits (and deleting declarations); `IncrementalParser.h` comes from
`clang/lib/Interpreter/` in the llvm-project **source tree** (it is not installed in any
artifact); on an LLVM bump both files must be re-copied and re-hacked, and the Interpreter
internals changed after 18, so `getCodeGen`/`getParser` will need rework. These headers
are never installed.

## After any change here

1. Rebuild: `julia --project=deps deps/build_local.jl` (writes LocalPreferences.toml to
   point at the local build; pass a directory as ARGS[1] for incremental rebuilds,
   otherwise every run recompiles everything in a fresh tempdir). Delete
   LocalPreferences.toml to fall back to libclangex_jll.
2. Regenerate bindings: `julia --project=gen gen/generator.jl` (needs network). Headers
   are auto-discovered — no gen-side registration — EXCEPT: a new LLVM-C/libc type in a
   signature needs an import in gen/prologue.jl (required — the module won't load
   without it) plus, by convention, an `@add_def` line in gen/generator.jl (most existing
   types have both; the Orc refs get by on prologue-only); a new helper macro (X-macro
   tables etc.) must go in `output_ignorelist` in gen/option.toml or it becomes a junk
   binding.
3. Commit the header, .cpp, CMakeLists, and regenerated `lib/18/LibClangEx.jl` together —
   deterministic symbol mode keeps the lib diff minimal. The `bindings` CI job reruns the
   generator and fails on any diff under `lib/`, and the test suite enforces the rest:
   test/abi.jl (every binding's symbol resolves), test/lint.jl (layout/guards/CMake
   parity/collision names, every binding wrapped or stamped, and every
   `clang_*` reference in src/ resolving to a binding).
4. Note: any commit touching deps/ClangExtra makes every CI job compile libclangex from
   source (build_ci.jl timestamp check), and a ClangCompiler.jl release then requires a
   libclangex_jll rebuild on Yggdrasil + a compat bump in the top-level Project.toml —
   the shim itself carries no version number in this repo (CMake declares none); the
   Project.toml compat entry is the only reference to the JLL's version.
