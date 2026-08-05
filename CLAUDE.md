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

# Fail on assertions that cannot fail (also run from test/lint.jl, so CI enforces it)
julia test/tautologies.jl
```

### Rules for writing a test here

A green suite is not evidence on its own — an assertion can fail to run, or run and be
incapable of failing. These four rules are what keep it evidence; `test/lint.jl` and
`test/tautologies.jl` enforce the middle two. The `suite-audit` skill has the tools that find
violations, and the measurements for why each rule earns its place.

- **A loop whose body is the only thing asserting proves nothing when the loop is empty.**
  Construct the state that makes the assertion run, or assert the empty case explicitly.
- **Never assert a type the wrapper's own return expression already fixes** — `isa Bool` on a
  `::Bool` ccall restates this repo's source, not anything Clang decided, so it cannot tell a
  correct shim from one returning a null or another argument's payload. Assert what Clang
  decided: a value, a round trip, or a relationship the shim could get wrong. (Whether
  carriers wrap at all is `test/abi.jl`'s job, not each test's.)
- **When the value genuinely is not assertable, mark the site `# shape-only` with its reason.**
  Three reasons are legitimate and no others: the host decides the value (triple, ABI,
  mangling, path, size, alignment), it varies across the objects the test walks, or it is an
  integer the target chooses. The marker belongs at the site — a baseline file recording the
  same thing goes stale the moment a file is cleaned up and makes two branches conflict over a
  generated artifact. The remaining markers are a ratchet, not a backlog: converting one
  requires finding something Clang decided, which is not a mechanical edit.
- **Prefer an invariant that holds over any AST to a pinned value.** A pin catches drift away
  from today's answer but freezes the bug if today's answer has always been wrong; invariants
  (`test/clang/invariants.jl`) need no captured values and no per-platform care. They have
  their own ceiling — a *consistently* wrong shim satisfies them — which is what the
  independent oracle in `test/clang/differential.jl` closes. When you add an invariant, add
  the mutant it kills to the catalogue in `.claude/skills/suite-audit/`.

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

The full step-by-step workflow (core type → API wrapper → registration → lifetime/dispose → resolve-chain) lives in the `add-wrapper-api` skill (`.claude/skills/add-wrapper-api/SKILL.md`) — invoke it when wrapping a new Clang class or method. The C-side steps come first and are covered in `deps/ClangExtra/CLAUDE.md`.

## Naming conventions

Quick reference. `CONTRIBUTING.md` states these fully; `src/clang/CLAUDE.md` covers the carrier and inheritance rules behind them.

- C API (`libclangex`): types prefixed `CX`, functions named `clang_<ClassName>_<methodName>` with both segments copied from Clang verbatim including case. On a name collision with libclang, the libclangex symbol gets a trailing underscore (e.g. `CXToken_`).
- Julia types drop the `CX` prefix and keep the Clang class name (`CXInterpreter` → `Interpreter`), except where that would collide with Base — those take a trailing underscore (`Expr_`, `Type_`), and `CXToken_` becomes `Token`. Every class gets a carrier and a per-class abstract, abstract C++ bases included. One name cannot be both, so where clang has a class named `AbstractX` the carrier keeps the plain name and the abstract takes a trailing underscore: carrier `AbstractConditionalOperator` under `AbstractAbstractConditionalOperator`, with `ConditionalOperator` under `AbstractConditionalOperator_`.
- Julia wrappers drop both the `clang_` prefix and the class name: `clang_CompilerInstance_hasDiagnostics` → `hasDiagnostics`. So most wrapper functions intentionally use Clang's camelCase C++ method names, not Julia style.
- The file hierarchy in `src/clang/core/` and `src/clang/api/` mirrors the LLVM/Clang source tree — put new wrappers in the file matching the Clang header the class lives in.
- Only the extra convenience helpers (e.g. in `src/compiler/`, `src/lookup.jl`) use YAS-style snake_case naming.

## Notes

- The package uses `public` declarations (Julia 1.11+) rather than `export` for its API surface — see `src/ClangCompiler.jl`.
- Objects wrapping C++ resources need explicit `dispose(x)`; tests and examples follow a create → use → dispose pattern.
- Test files are plain `@testset` files included by `test/runtests.jl`, laid out to mirror the source tree: whole-package checks in `test/*.jl` (`lint.jl` and `abi.jl` are the meta guards), middle-layer helpers in `test/clang/*.jl`, thin wrappers in `test/clang/api/**` alongside the file they exercise. A new test file must be added to `test/runtests.jl` by hand.
- CI runs macOS, Linux and Windows on x86_64, and an equality assertion on something the
  runner decides turns into a red CI on a platform you did not run locally. This class of bug
  is invisible to a local single-platform run and to `-fsyntax-only`; only the per-file test
  run against real AST state catches it, so never skip it before committing. The link failure
  that removed `getVirtualFileRef` — `off_t` is `long` on mingw and `long long` elsewhere —
  reached CI exactly this way.

  Two kinds of value hide behind that, and they need opposite treatment:

  - **The target decides it** — sizes and alignments, ABI-specific layout offsets, mangled
    names, endianness, integer widths. These are *not* unassertable, only unpinned. Build the
    interpreter with `create_interpreter(...; triple="x86_64-linux-gnu")` and every one becomes
    an equality that reads the same on all three runners; `test/clang/pinned_target.jl` is the
    worked example. Only parsing and AST inspection can cross-target — the JIT still emits for
    the host — and pinning downloads that target's GCC shard, so keep it to one target and one
    file rather than pinning at every site.
  - **Nothing decides it** — module provenance (`isPartOfFramework`), a `Driver`'s LTO mode
    before argument processing, and a hand-built `Module`'s availability, including the
    `markUnavailable` transition whose gating predicate reads bits a synthetic module never had
    a module map to set. These read uninitialized memory. Pinning a triple does not help and
    would only make the answer look trustworthy; restate the precondition instead, or leave the
    site `# shape-only` with that as its reason. A wrapper whose value comes back outside its
    own enum (Julia prints `<invalid #N>`) is this case — a UB precondition to restate, not a
    flaky test.

  Anything genuinely host-decided that is neither of those — a sysroot, an executable path —
  still takes the shape assertion: `isa Bool`, `isa Integer`, or a round-trip of a value the
  test itself set.
