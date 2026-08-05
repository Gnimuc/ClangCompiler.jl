# ClangCompiler.jl Copilot Guide

## Scope

- Work only on Julia code, primarily in `test/` and then `src/`.
- Never modify `deps/ClangExtra/**`, including its C++ sources, headers, CMake files, or build
  configuration. Do not run its build or regenerate bindings.
- If a request needs a new or changed C++ shim API, identify that dependency and leave its
  implementation out of scope.

Read [CLAUDE.md](CLAUDE.md) for the detailed Julia architecture, test strategy, formatting, and
local test diagnostics.

## Julia Boundaries

- `src/` is the hand-written Julia API. Objects owning C++ resources require explicit `dispose`.
- `test/` mirrors the production-layer layout. Add new test files to [test/runtests.jl](test/runtests.jl).
- `lib/<LLVM major>/LibClangEx.jl` and generated node maps are generated; never hand-edit them.
  The hand-maintained exception is [lib/LibClang.jl](lib/LibClang.jl).

## Route By Task

- Before editing `src/clang/**`, read [src/clang/CLAUDE.md](src/clang/CLAUDE.md). This layer owns
  the type-safety boundary, carrier construction, and C++ inheritance pivots.
- For iterator-heavy tests or test-suite effectiveness work, follow
  [.claude/skills/suite-audit/SKILL.md](.claude/skills/suite-audit/SKILL.md).

## Build And Test

```bash
julia --project -e 'using Pkg; Pkg.test()'
```

Run focused tests before the full suite. Tests should assert Clang-observable behavior or
invariants, rather than wrapper-determined type shapes.

## Important Pitfalls

- `TestEnv.activate()` does not retain `LocalPreferences.toml`; use the standalone-test procedure
  documented in [CLAUDE.md](CLAUDE.md) before loading `ClangCompiler`.
- Follow [CONTRIBUTING.md](CONTRIBUTING.md) for C/Julia naming and [README.md](README.md) for
  public-facing usage examples.