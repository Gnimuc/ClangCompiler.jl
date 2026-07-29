# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

ClangCompiler.jl is a Julia interface to the Clang C++ API (declaration lookup, AST traversal, parsing, and JIT compilation/execution of C++ code via Clang's incremental interpreter). It requires Julia 1.12+ and is tied to the LLVM version Julia itself is built against (currently LLVM 18 — see `lib/18/`).

## Commands

```bash
# Run the full test suite
julia --project -e 'using Pkg; Pkg.test()'

# Run a single test file — each test file is self-contained (does its own `using`),
# but needs the test environment (Test/TOML are not deps of the main project).
# Requires TestEnv installed in the global environment (`julia -e 'using Pkg; Pkg.add("TestEnv")'`).
# TestEnv.activate() switches to a temp env whose directory has NO LocalPreferences.toml,
# so ClangCompiler would silently load libclangex_jll instead of your local build (new
# symbols then fail at call time and look like C-side bugs) — copy the preference across
# BEFORE `using ClangCompiler`:
julia --project -e 'using TestEnv; TestEnv.activate();
  cp("LocalPreferences.toml", joinpath(dirname(Base.active_project()), "LocalPreferences.toml"); force=true);
  include("test/lookup.jl")'

# Build the C++ shim library (libclangex) locally after modifying deps/ClangExtra.
# Writes LocalPreferences.toml so the package loads the local build instead of libclangex_jll.
# Pass a directory to keep an incremental build tree; without one every run recompiles
# everything in a fresh tempdir.
julia --project=deps deps/build_local.jl [build_dir]

# CI variant: only rebuilds if deps/ClangExtra changed since the last libclangex_jll release
julia --project=deps deps/build_ci.jl

# Regenerate the raw Julia bindings in lib/<llvm_major>/LibClangEx.jl after changing ClangExtra headers
julia --project=gen gen/generator.jl

# Report @test lines that never executed. A green suite says nothing about assertions that
# did not run, and those read as coverage while proving nothing. Delete stale .cov files
# first — coverage counts accumulate across runs.
find . -name '*.cov' -delete
julia --project -e 'using Pkg; Pkg.test(coverage=true)'
julia .claude/skills/suite-audit/deadtests.jl
```

A dead `@test` is not a cosmetic problem. `DeclIterator` advanced before yielding, so it
dropped the first declaration of every context; the test that should have caught it looped
over the elements the iterator *did* yield, so its assertions passed on a truncated list and
the bug survived. Run the `suite-audit` skill's `deadtests.jl` after adding tests that iterate anything, and either
construct the state that makes the assertion run or assert the empty case explicitly — never
leave a loop whose body is the only thing asserting.

### Assertions that run but cannot fail

```bash
julia test/tautologies.jl
```

`@test f(x) isa T` is worthless when `T` is fixed by the wrapper's own return expression —
`isa Bool` on a `::Bool` ccall, `isa Integer` on `Int(...)`, `isa SomeCarrier` on
`return SomeCarrier(...)`. It restates this repo's source rather than anything Clang decided,
so it cannot tell a correct shim from one returning a null, a stale value, or another
argument's payload. Whether carriers wrap at all is already owned by `test/abi.jl`.

2,235 of these predate the check (16.7% of the suite); 1,698 were converted and 538 remain
because their value genuinely is not assertable. Each of those carries `# shape-only` and its
reason at the site, and `test/lint.jl` fails on any that does not. Three reasons are legitimate
and no others are: the host decides the value (a triple, ABI, mangling, path, size or
alignment), it varies across the objects the test walks, or it is an integer the target
chooses. For anything else, assert what Clang decided — a value, a round trip, or a
relationship the shim could get wrong.

The marker is at the site rather than in a baseline file on purpose. A per-file count recorded
the same information three directories from the code, went stale the moment a file was cleaned
up, and made two branches conflict over a generated artifact.

### Does the suite actually catch anything?

```bash
julia --project .claude/skills/suite-audit/mutants.jl          # break wrappers on purpose, see what goes red
```

Assertion counts measure nothing. The only way to know a suite detects faults is to inject
one. Each mutant redefines a single wrapper — an accessor returning a sibling member, a
predicate inverted, an index ignored — and runs the tests that exercise it. A mutant that
**survives** is a precise gap: some wrapper can return the wrong thing and nothing notices.

The tool reports "caught by an assertion" separately from "crash", because a fault that only
shows up as a clang abort was noticed by luck; a subtler version of it would pass.

Two limits worth knowing. Pinning an observed value catches a *regression* away from what the
shim returns today, but says nothing about whether today's answer is right — if a shim has
always been wrong, the pin freezes the bug. And no `isa` or null check can separate two
results of the same type: `getBeginLoc` returning the end location passes every one of them.

`test/clang/invariants.jl` is the first answer. It asserts relationships that hold over any
AST whatever the values are — a parent's source range contains its children's, a binary
operator's two operands are distinct nodes, distinct argument indices name distinct children
— so it needs no captured values and no per-platform care. Those five testsets took the
mutation score from **28.6% to 85.7%**. Adding an invariant is worth more than adding a
hundred value assertions; when you add one, put the mutant it kills in the catalogue.

Invariants have their own ceiling: they check the shim's answers against each other, so a
*consistently* wrong shim satisfies them. Swap `getBeginLoc` and `getEndLoc` together and
containment still holds, because containment is symmetric — measured, not assumed:
invariants report 0 failures for that mutant and the differential test reports 3.

`test/clang/differential.jl` closes it by comparing against something that is not the shim.
It runs clang's own `-ast-dump` over the same source in a separate process and checks the
signature, parameter count and source lines of every function both readings see. That is the
only guard here able to find a wrapper that has been wrong since the day it was written,
rather than one that has drifted. Compare like with like when extending it: `printAsString`
prints under the context's `PrintingPolicy`, which is what the dump uses, while `getAsString`
uses clang's default and spells an empty parameter list `(void)` where C++ spells it `()`.

Formatting: JuliaFormatter, YAS style, margin 120 (see `.JuliaFormatter.toml`). `lib/` and `examples/` are excluded from formatting.

### Verifying a local build is the one you are testing

`build_local.jl` installs into a **scratchspace shared by every checkout and worktree**
(`~/.julia/scratchspaces/06fc9500-.../build`), and wipes it at the start of each run. A build
started from a different checkout therefore replaces your dylib with one compiled from *its*
sources — silently. The symptom is `test/abi.jl` reporting bound symbols as missing, or a suite
that passed minutes ago failing. Check the exported symbol count (it only ever grows within a
branch) and rebuild from your own worktree if it dropped:

```bash
nm -gU ~/.julia/scratchspaces/06fc9500-c033-43bc-8ca2-e20da63309d9/build/lib/libclangex.dylib | grep -c " _clang_"
```

Two more traps when running these commands:

- **Piping hides failures.** `julia ... 2>&1 | tail -20; echo $?` reports *tail's* status. Redirect
  to a file (`julia ... > log 2>&1; echo $?`) and grep the log.
- **Grep the log for crashes, not just failures.** A segfault prints `signal 11 (2): Segmentation
  fault` (or `EXCEPTION_ACCESS_VIOLATION` on Windows) and never the word "Fail"; a libstdc++
  assertion prints `SIGABRT`. Include `signal|Segmentation|SIGABRT|EXCEPTION` in triage greps.
- A test file can pass standalone and still crash inside the full suite (different AST state from
  earlier files). Always run `Pkg.test()` before committing.

## Architecture

There are three layers, from C++ up to user-facing Julia:

1. **`deps/ClangExtra/`** — C++ sources for `libclangex`, a hand-written C API shim over Clang's C++ API (the parts libclang doesn't expose: Interpreter, Sema, Parser, CodeGen, etc.). Built with CMake against `LLVM_full_jll`, and distributed as `libclangex_jll`. Changing anything here requires (a) rebuilding locally with `deps/build_local.jl`, (b) regenerating the Julia bindings with `gen/generator.jl`, and (c) a `libclangex_jll` version bump before a ClangCompiler.jl release (CI warns about this). **See `deps/ClangExtra/CLAUDE.md` for the C/C++ wrapper conventions (naming, marshalling, ownership, enum mirroring, the upstream/ header hacks) — read it before touching any C++ code.**

2. **`lib/`** — auto-generated raw bindings; never hand-edit — with one exception: `lib/LibClang.jl` is a small hand-maintained excerpt of libclang bindings (CXString/CXStringSet with their accessor and dispose functions, plus `clang_toggleCrashRecovery`), not generator output.
   - `lib/LibClang.jl`: bindings to `libclang` from `Clang_jll`.
   - `lib/<llvm_major>/LibClangEx.jl`: bindings to `libclangex`, generated from the ClangExtra headers by `gen/generator.jl` (Clang.jl generator, config in `gen/option.toml`). The version directory to load is picked at runtime from `Base.libllvm_version` in `src/ClangCompiler.jl`. All CX handles are `Ptr{Cvoid}` aliases, so the raw layer has no type safety — that's the hand-written layer's job. CI never regenerates bindings; commit the regenerated file together with the header change.

3. **`src/`** — hand-written Julia layer.
   - `src/clang/core/`: Julia types mirroring Clang's C++ classes; Clang's inheritance hierarchy is reproduced with abstract types and subtyping.
   - `src/clang/api/`: Julia wrapper functions for the C API.
   - `src/clang/*.jl` (ast.jl, sema.jl, qualtype.jl, ...): higher-level helpers over the raw API.
   - **See `src/clang/CLAUDE.md` for the thin-wrapper conventions** (the single-client axiom, the two type-safety invariants, and how C++ subtyping/multiple-inheritance are reproduced in Julia) — read it before touching any wrapper code, since this layer is the only safety boundary in front of the type-erased C shim.
   - `src/compiler/`: the user-facing API — `CxxInterpreter`, `create_interpreter`, `parse`/`execute`/`compile`, `get_function_pointer`.
   - `src/platform/JLLEnvs.jl` + `src/env.jl`: resolve cross-compilation "shard" artifacts (GCC sysroots, system includes) from the top-level `Artifacts.toml` to build the default compiler flags (`get_default_args`) — the interpreter runs with `-nostdinc`/`-nostdlib` and JLL-provided include paths, not the host toolchain's.
   - The `libclangex` library path can be overridden via the `"libclangex"` Preferences key (this is what `deps/build_local.jl` sets in `LocalPreferences.toml`).

## Adding a new wrapper API (end-to-end)

The C-side steps (header + impl + CMake + typedef in CXTypes.h) are covered in `deps/ClangExtra/CLAUDE.md`. After rebuilding (`deps/build_local.jl`) and regenerating (`gen/generator.jl`), the Julia side is:

1. **Core type** (skip if the class is already wrapped): add `abstract type AbstractFoo <: Abstract<ClangBase> end` mirroring Clang's inheritance — the AST/Type/Frontend hierarchies live in `src/clang/core/abstract.jl`, while Interpreter/CodeGen/Basic classes define their abstract types locally next to the struct (follow whichever the target file already does). Then in `src/clang/core/<Dir>/<ClangHeader>.jl` add `struct Foo <: AbstractFoo; ptr::CXFoo; end` plus `Base.unsafe_convert(::Type{CXFoo}, x::Foo) = x.ptr` and `Base.cconvert(::Type{CXFoo}, x::Foo) = x` (many files stamp sibling classes out in a `for sym in [...] @eval` loop — append to it rather than writing a standalone struct). Docstring format: "Hold a pointer to a `clang::Foo` object." The field must be named `ptr` (`@check_ptrs` depends on it). Underscore-suffixed collision types drop both the `CX` prefix and the underscore in Julia (`CXToken_` → `Token`), unless the bare name clashes with Base (`CXType_` → `Type_`).
2. **API wrapper** in `src/clang/api/<Dir>/<ClangHeader>.jl`: `function methodName(x::AbstractFoo, ...)` — type the receiver as the abstract supertype of the class that declares the C++ method so subclasses dispatch; start with `@check_ptrs` on every wrapper argument; wrap pointer returns in their Julia struct — never return a raw `Ptr` (test/lint.jl cannot catch this class; review for it); `unsafe_string` for `const char*` returns, `get_string` for `CXString`/`CXStringSet` returns (it disposes them — plain `unsafe_string` leaks), bare returns for Bool/int/enum. `castTo` C functions surface as constructor-shaped methods named after the target type (`CXXRecordDecl(x::DeclContext)`), except the Decl↔DeclContext pivot which keeps its C names `castToDeclContext`/`castFromDeclContext`.
3. **Registration**: new files must be added to both include lists by hand — `src/clang/core/core.jl` and `src/clang/api/api.jl` (they are not kept in sync automatically).
4. **Lifetime**: pair every `clang_Foo_create` binding with a Julia constructor and a `dispose(x::Foo) = clang_Foo_dispose(x)` method; there are no finalizers, disposal is always manual (create → use → dispose). Allocating getters carry the docstring sentence "This function allocates and one should call `dispose` to release the resources after using this object."
5. Optionally add a snake_case helper in the matching high-level file (`src/clang/ast.jl`, `basic.jl`, `sema.jl`, …) and a `public` declaration in `src/ClangCompiler.jl` if user-facing. New Clang `Type` subclasses that participate in runtime downcasting also need an `is_foo_type` predicate pair in `src/clang/type.jl` and an entry in the **ordered** `resolve()` chain in `src/types.jl` (sugared types are tested before canonical ones — placement matters).

## Naming conventions (from CONTRIBUTING.md)

- C API (`libclangex`): types prefixed `CX`, functions named `clang_<ClassName>_<methodName>`. On a name collision with libclang, the libclangex symbol gets a trailing underscore (e.g. `CXToken_`).
- Julia types drop the `CX` prefix and keep the Clang class name (`CXInterpreter` → `Interpreter`).
- Julia wrappers drop both the `clang_` prefix and the class name: `clang_CompilerInstance_hasDiagnostics` → `hasDiagnostics`. So most wrapper functions intentionally use Clang's camelCase C++ method names, not Julia style.
- The file hierarchy in `src/clang/core/` and `src/clang/api/` mirrors the LLVM/Clang source tree — put new wrappers in the file matching the Clang header the class lives in.
- Only the extra convenience helpers (e.g. in `src/compiler/`, `src/lookup.jl`) use YAS-style snake_case naming.

## Notes

- The package uses `public` declarations (Julia 1.11+) rather than `export` for its API surface — see `src/ClangCompiler.jl`.
- Objects wrapping C++ resources need explicit `dispose(x)`; tests and examples follow a create → use → dispose pattern.
- Test files are plain `@testset` files included by `test/runtests.jl`, laid out to mirror the source tree: whole-package checks in `test/*.jl` (`lint.jl` and `abi.jl` are the meta guards), middle-layer helpers in `test/clang/*.jl`, thin wrappers in `test/clang/api/**` alongside the file they exercise. A new test file must be added to `test/runtests.jl` by hand.
- CI runs macOS, Linux and Windows on x86_64. Assert the *shape* of anything the host decides
  — `isa Bool`, `isa Integer`, or a round-trip of a value the test itself set. Sizes and
  alignments, mangled names of std-typed signatures, ABI-specific layout offsets, module
  provenance (`isPartOfFramework`), a `Driver`'s LTO mode, and a hand-built `Module`'s
  availability — both its initial value and the `markUnavailable` transition, whose gating
  predicate reads bits a synthetic module never had a module map to set — all differ across
  those runners (or read uninitialized memory), and an equality
  assertion on one of them turns into a red CI on a platform you did not run locally. This class
  of bug is invisible to a local single-platform run and to `-fsyntax-only`; only the per-file
  test run against real AST state catches it, so never skip it before committing. A wrapper
  whose value comes back outside its own enum (Julia prints `<invalid #N>`) is reading a
  member with no initializer — that is a UB precondition to restate, not a flaky test.
