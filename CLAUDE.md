# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

ClangCompiler.jl is a Julia interface to the Clang C++ API (declaration lookup, AST traversal, parsing, and JIT compilation/execution of C++ code via Clang's incremental interpreter). It requires Julia 1.13+ and is tied to the LLVM version Julia itself is built against (currently LLVM 20 — see `lib/20/`).

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

## Writing a test here

A green suite is not evidence on its own — an assertion can fail to run, or run and be
incapable of failing. **See [`test/CLAUDE.md`](test/CLAUDE.md) for the four rules that keep
this one evidence, what decides a value you are tempted to mark `# shape-only`, and the
layout — read it before adding or changing a test.** `test/lint.jl` and `test/tautologies.jl`
enforce two of the rules, so CI catches those; the rest is on the author.

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
  assertion prints `SIGABRT`. But an abort reaching `Pkg.test()` is reported as
  `ERROR: Package ClangCompiler errored during testing (received signal: 6)` -- the word
  SIGABRT never appears, and neither does "Fail", so a run that aborted reads as a clean one
  with fewer testsets. Include
  `signal|Segmentation|SIGABRT|EXCEPTION|received signal|Assertion failed` in triage greps,
  and check the testset count against the previous run.
- A test file can pass standalone and still crash inside the full suite (different AST state from
  earlier files). Always run `Pkg.test()` before committing.

## Formatting

JuliaFormatter, YAS style. **Two margins, and which one applies is decided by directory:**

- **`src/clang/**` — margin 1000** (`src/clang/.JuliaFormatter.toml`). This is the only place
  that earns it. The files are thin wrappers that copy Clang's own method names verbatim, so
  a signature is one run of long camelCase identifiers with no good break point; the
  formatter's choices there were worse than a hand-placed break, and a wrapper on one line
  stays diffable against the header it mirrors. The cost is local to this directory: a few
  dozen lines over 300 characters, the worst near 900 where a `for (cls, T) in [...]`
  dispatch table sits on one line.
- **everything else — margin 120** (the repo-root `.JuliaFormatter.toml`). Ordinary Julia,
  formatted like ordinary Julia. Nothing outside `src/clang` has signatures that cannot be
  broken sensibly, so nothing outside it gets the wide margin.

JuliaFormatter uses the **nearest** config it finds rather than merging with the parent, so
`src/clang/.JuliaFormatter.toml` has to repeat every setting it wants — including its own
`ignore` list, since the root one does not reach inside.

Excluded from formatting entirely: `lib/` and `examples/` (generated / vendored), the
generated `src/` files named in the two `ignore` entries, and `gen/prologue.jl`. That last one
is excluded for a reason one step removed — `gen/option.toml` names it as
`prologue_file_path`, so the generator copies it *verbatim* into `lib/<v>/LibClangEx.jl`, and
formatting it changes bytes in a file that is itself excluded. The "regenerated bindings match
`lib/`" CI check then fails on whitespace alone.

`join_lines_based_on_source=false` is set in both. YAS turns it *on* by default, which means
"keep whatever breaks the source already had" — with it on, the margin only removes the
obligation to split and never asks the formatter to join. Off, the layout is derived from the
margin alone, so the output is canonical rather than a record of where someone pressed return.

Where a table is meant to be read vertically and the margin still collapses it, fence it
rather than widening the margin back:

```julia
#! format: off
... the table ...
#! format: on
```

At margin 120 this is rarely needed — a two-column table generally stays one row per line on
its own — and the tree currently has no fences at all.

Nothing in CI runs the formatter, so none of this happens on its own. Adding a CI gate would
need the JuliaFormatter version pinned first; unpinned, a formatter release turns CI red on a
commit that changed nothing.

## Architecture

There are three layers, from C++ up to user-facing Julia:

1. **`deps/ClangExtra/`** — C++ sources for `libclangex`, a hand-written C API shim over Clang's C++ API (the parts libclang doesn't expose: Interpreter, Sema, Parser, CodeGen, etc.). Built with CMake against `LLVM_full_jll`, and distributed as `libclangex_jll`. Changing anything here requires (a) rebuilding locally with `deps/build_local.jl`, (b) regenerating the Julia bindings with `gen/generator.jl`, and (c) a `libclangex_jll` version bump before a ClangCompiler.jl release (CI warns about this). **See `deps/ClangExtra/CLAUDE.md` for the C/C++ wrapper conventions (naming, marshalling, ownership, enum mirroring, the upstream/ header hacks) — read it before touching any C++ code.**

2. **`lib/`** — auto-generated raw bindings; never hand-edit — with one exception: `lib/LibClang.jl` is a small hand-maintained excerpt of libclang bindings (CXString/CXStringSet with their accessor and dispose functions, plus `clang_toggleCrashRecovery`), not generator output.
   - `lib/LibClang.jl`: bindings to `libclang` from `Clang_jll`.
   - `lib/<llvm_major>/LibClangEx.jl`: bindings to `libclangex`, generated from the ClangExtra headers by `gen/generator.jl` (Clang.jl generator, config in `gen/option.toml`). The version directory to load is picked at runtime from `Base.libllvm_version` in `src/ClangCompiler.jl`. Each CX handle is its own phantom pointer type (`const CXDecl = Ptr{CXDeclImpl}`), so passing a `CXStmt` where a `CXDecl` is wanted is a `MethodError` rather than a reinterpreted pointer — but only because `src/clang/handles.jl` refuses `Ptr`'s permissive conversions, which would otherwise bitcast between any two pointer types silently. What the raw layer still cannot see is the *hierarchy*: `Ptr{CXIfStmtImpl}` and `Ptr{CXStmtImpl}` are unrelated to Julia however Clang's classes are related, so every widening goes through the abstract types and `src/clang/core/converts.jl` in the hand-written layer. CI never regenerates bindings; commit the regenerated file together with the header change.

3. **`src/`** — hand-written Julia layer.
   - `src/clang/core/`: Julia types mirroring Clang's C++ classes; Clang's inheritance hierarchy is reproduced with abstract types and subtyping.
   - `src/clang/api/`: Julia wrapper functions for the C API.
   - `src/clang/*.jl` (ast.jl, sema.jl, qualtype.jl, ...): higher-level helpers over the raw API.
   - **See `src/clang/CLAUDE.md` for the thin-wrapper conventions** (the single-client axiom, the two type-safety invariants, and how C++ subtyping/multiple-inheritance are reproduced in Julia) — read it before touching any wrapper code, since this layer is the only safety boundary in front of a C shim that is check-free by design and blind to Clang's class hierarchy.
   - `src/compiler/`: the user-facing API — four drivers, one per file, over a taxonomy and a
     shared helper file that come first because everything else depends on them.
     `types.jl` holds every abstract type (`AbstractClangCompiler` and the four
     `Abstract<Driver>` supertypes); `utils.jl` holds what more than one driver needs
     (`SOURCE_LANGUAGES` and its two validators). Then
     `CxxInterpreter`/`create_interpreter` (interpreter.jl) and
     `IncrementalParser`/`create_parser` (parser.jl), the incremental pair, and
     `IRGenerator`/`create_irgenerator` (irgen.jl) and `CxxCompiler`/`create_compiler`
     (compiler.jl), the batch pair. Plus the verbs: `parse`/`execute`/`compile`,
     `take_module`, `get_function_pointer`. The abstract types are taxonomy, not extension
     points: nothing dispatches on them, exactly as with `AbstractFinder` in `src/lookup.jl`,
     so each driver's accessors are written against its concrete type.
   - The include order in `src/ClangCompiler.jl` is load-bearing and not alphabetical.
     `types.jl` precedes every driver because each subtypes it; `utils.jl` precedes
     `parser.jl` and `irgen.jl` because their docstrings interpolate `SOURCE_LANGUAGES` at
     include time; and `irgen.jl` precedes `compiler.jl` because `CxxCompiler` has an
     `IRGenerator` field, which is why the supertype cannot simply live with the compiler.
   - `src/compiler/irgen.jl` + `compiler.jl` are the batch half: one `EmitLLVMOnlyAction`
     over a whole translation unit, so the result is a single `LLVM.Module` rather than one
     per increment, and `take_module` hands it over before anything JITs it. That gap is the
     reason the pair exists — it is where an optimisation pipeline or a hand-built function
     goes, and `compile(cc, mod)` takes the module back. The cost is the other side of the
     same trade: the frontend runs to completion inside the constructor, so
     `FrontendAction::EndSourceFile` has already dropped the `ASTContext` and there is no AST
     to traverse afterwards.
   - `src/compiler/parser.jl` reimplements clang's incremental parse loop over a **single**
     `TranslationUnitDecl`. Clang's own `Interpreter` starts a new one per increment, and
     because C's unqualified lookup does not cross the chain that makes, C and Objective-C
     there cannot see anything declared in an earlier increment — `clang-repl --Xcc -xc`
     fails the same way, so it is upstream rather than this package's flags. Driving the
     loop directly is what makes all four languages work; it parses and does not execute.
   - `src/platform/JLLEnvs.jl` + `src/env.jl`: resolve cross-compilation "shard" artifacts (GCC sysroots, system includes) from the top-level `Artifacts.toml` to build the default compiler flags (`get_default_args`) — the interpreter runs with `-nostdinc`/`-nostdlib` and JLL-provided include paths, not the host toolchain's.
   - The `libclangex` library path can be overridden via the `"libclangex"` Preferences key (this is what `deps/build_local.jl` sets in `LocalPreferences.toml`).

## Adding a new wrapper API (end-to-end)

The full step-by-step workflow (core type → API wrapper → registration → lifetime/dispose → resolve-chain) lives in the `add-wrapper-api` skill (`.claude/skills/add-wrapper-api/SKILL.md`) — invoke it when wrapping a new Clang class or method. The C-side steps come first and are covered in `deps/ClangExtra/CLAUDE.md`.

## Naming conventions

Quick reference. `CONTRIBUTING.md` states these fully; `src/clang/CLAUDE.md` covers the carrier and inheritance rules behind them.

- C API (`libclangex`): types prefixed `CX`, functions named `clang_<ClassName>_<methodName>` with both segments copied from Clang verbatim including case. On a name collision with libclang, the libclangex symbol gets a trailing underscore (e.g. `CXToken_`).
- Julia types drop the `CX` prefix and keep the Clang class name (`CXInterpreter` → `Interpreter`), except where that would collide with Base — those take a trailing underscore (`Expr_`, `Type_`), and `CXToken_` becomes `Token`. Every class gets a carrier and a per-class abstract, abstract C++ bases included, except one clang itself names `Abstract*`: that mirror would need the name its own subclass has, so the class is not mirrored and its children hang off its parent.
- Julia wrappers drop both the `clang_` prefix and the class name: `clang_CompilerInstance_hasDiagnostics` → `hasDiagnostics`. So most wrapper functions intentionally use Clang's camelCase C++ method names, not Julia style.
- Crossing the hierarchy has one spelling, the carrier's own constructor. `FunctionDecl(d)` is C++'s `cast<T>` — checked against clang's `classof`, raising `CastError` on another class — and `isFunctionDecl(d)` beside it is `isa<T>`; both are generated per class from the vendored `*.inc` files. **Widening is not spelled at all**: marshalling is keyed on the abstract types, so a `CXXRecordDecl` reaches every `AbstractDecl` wrapper directly. And most code needs neither: `resolve(x)` returns the concrete carrier, after which `x isa AbstractFunctionDecl` *is* `isa<FunctionDecl>` and dispatch on the abstract is the check. See `src/clang/casts.jl`.
- The file hierarchy in `src/clang/core/` and `src/clang/api/` mirrors the LLVM/Clang source tree — put new wrappers in the file matching the Clang header the class lives in.
- Only the extra convenience helpers (e.g. in `src/compiler/`, `src/lookup.jl`) use YAS-style snake_case naming.

## Notes

- The package uses `public` declarations (Julia 1.11+) rather than `export` for its API
  surface — see `src/ClangCompiler.jl`. **The hard rule is that a public name reads as Julia**:
  snake_case functions, CamelCase types. That is what keeps the thin wrapper layer out of the
  surface, and it is not a judgment call — the wrappers copy Clang's C++ method names verbatim,
  camelCase included (see Naming conventions above), which is exactly what makes them diffable
  against Clang's headers and exactly what disqualifies them from being public. `getFields` and
  `getASTRecordLayout` are not names this package may put its name to.

  So exposing something new to users is never a `public` line on a wrapper; it is a snake_case
  helper over that wrapper, in `src/clang/*.jl` or the high-level files (`src/compiler/`,
  `src/lookup.jl`, `src/highlevel.jl`, `src/types.jl`). `get_record_layout` and `field_offsets`
  are what `getASTRecordLayout` and `getFieldOffset` would be named if they were surface, and
  `children` is what `getChildren` would be.

  **Nothing in `src/clang/` is public**, and the rule now has no exceptions: the four
  camelCase names that used to be grandfathered — `getStmtClass`, `getChildren`, `getKind`,
  `getAttrs` — are not public either. They went with the rest of that layer, for a reason
  bigger than naming, recorded at the head of the `# clang` block in `src/ClangCompiler.jl`:
  `public` is a promise to keep a name working, and an audit found most of that layer unable
  to keep one across an LLVM major bump, because the values are TableGen line ordinals, the
  type names are clang's AST class names, and the generated unions change membership.

  What survives as public is the layer above: the drivers in `src/compiler/`, and the
  snake_case helpers in `src/lookup.jl`, `src/highlevel.jl`, `src/types.jl`, `src/template.jl`.
  Everything under `src/clang/` stays reachable as `ClangCompiler.name` — it is what the
  package is built on — but carries no promise. Add a `public` line when a downstream package
  asks for a specific name, and write down what that name can promise across a bump when you
  do.
- Objects wrapping C++ resources need explicit `dispose(x)`; tests and examples follow a create → use → dispose pattern.
- **CI runs macOS, Linux and Windows on x86_64**, and an equality assertion on something the
  runner decides turns into a red CI on a platform you did not run locally — invisible to a
  local single-platform run and to `-fsyntax-only`. What that means for an assertion is in
  [`test/CLAUDE.md`](test/CLAUDE.md); what it means for a C type's width, and why a mangled
  name can make a wrapper link everywhere but Windows, is in
  [`deps/ClangExtra/CLAUDE.md`](deps/ClangExtra/CLAUDE.md).
