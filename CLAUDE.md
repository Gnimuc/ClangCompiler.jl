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
# Requires TestEnv installed in the global environment (`julia -e 'using Pkg; Pkg.add("TestEnv")'`):
julia --project -e 'using TestEnv; TestEnv.activate(); include("test/lookup.jl")'

# Build the C++ shim library (libclangex) locally after modifying deps/ClangExtra.
# Writes LocalPreferences.toml so the package loads the local build instead of libclangex_jll.
julia --project=deps deps/build_local.jl

# CI variant: only rebuilds if deps/ClangExtra changed since the last libclangex_jll release
julia --project=deps deps/build_ci.jl

# Regenerate the raw Julia bindings in lib/<llvm_major>/LibClangEx.jl after changing ClangExtra headers
julia --project=gen gen/generator.jl
```

Formatting: JuliaFormatter, YAS style, margin 120 (see `.JuliaFormatter.toml`). `lib/` and `examples/` are excluded from formatting.

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
2. **API wrapper** in `src/clang/api/<Dir>/<ClangHeader>.jl`: `function methodName(x::AbstractFoo, ...)` — type the receiver as the abstract supertype of the class that declares the C++ method so subclasses dispatch; start with `@check_ptrs` on every wrapper argument; wrap pointer returns in their Julia struct — never return a raw `Ptr` (a few legacy wrappers like `getParent(x::DeclContext)` do; don't imitate them); `unsafe_string` for `const char*` returns, `get_string` for `CXString`/`CXStringSet` returns (it disposes them — plain `unsafe_string` leaks), bare returns for Bool/int/enum. `castTo` C functions surface as constructor-shaped methods named after the target type (`CXXRecordDecl(x::DeclContext)`), except the Decl↔DeclContext pivot which keeps its C names `castToDeclContext`/`castFromDeclContext`.
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
- Test files (`test/types.jl`, `parse.jl`, `lookup.jl`, `traversal.jl`, `execution.jl`) are plain `@testset` files included by `test/runtests.jl`.
