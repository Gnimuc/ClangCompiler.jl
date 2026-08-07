# CLAUDE.md — test (what makes this suite evidence)

Guidance for writing and reading tests here. The repo-root CLAUDE.md covers the package and
the commands; `src/clang/CLAUDE.md` and `deps/ClangExtra/CLAUDE.md` cover the two layers under
test. This file covers the one thing this suite exists to do: **fail when a wrapper is wrong.**

A green suite is not evidence on its own. An assertion can fail to run, or run and be incapable
of failing — measured on this repo, 16.7% of assertions once restated the wrapper's own return
type, which no defect can violate. The `suite-audit` skill has the tools that find such sites
and the measurements for why each rule below earns its place.

## The four rules

`test/lint.jl` and `test/tautologies.jl` enforce the middle two, and CI runs both.

- **A loop whose body is the only thing asserting proves nothing when the loop is empty.**
  Construct the state that makes the assertion run, or assert the empty case explicitly.
- **Never assert a type the wrapper's own return expression already fixes** — `isa Bool` on a
  `::Bool` ccall restates this repo's source, not anything Clang decided, so it cannot tell a
  correct shim from one returning a null or another argument's payload. Assert what Clang
  decided: a value, a round trip, or a relationship the shim could get wrong. (Whether
  carriers wrap at all is `test/abi.jl`'s job, not each test's.)
- **When the value genuinely is not assertable, mark the site `# shape-only` with its reason.**
  Four reasons are legitimate and no others: the host decides the value (triple, ABI,
  mangling, path, size, alignment), it varies across the objects the test walks, it is an
  integer the target chooses, or nothing decides it because the read is of uninitialised
  memory. That last one is not a softer version of the first — "the host decides it" says a
  machine chose a real value, while "nothing decides it" says nobody wrote the memory, and
  every site in the second class was once labelled with the first, which read as though
  someone had checked. `tautologies.jl` rejects a marker whose text names none of them,
  so the reason cannot decay back into decoration — but it checks only that a category was
  *named*, never that the claim is true. `getLine` marked "the target chooses this value"
  passes the linter and is still false, because a line number is decided by the source. Only
  reading the site catches that, so write the reason you can defend. The marker belongs at the
  site — a baseline file recording the same thing goes stale the moment a file is cleaned up
  and makes two branches conflict over a generated artifact. The remaining markers are a
  ratchet, not a backlog: converting one requires finding something Clang decided, which is
  not a mechanical edit.
- **Prefer an invariant that holds over any AST to a pinned value.** A pin catches drift away
  from today's answer but freezes the bug if today's answer has always been wrong; invariants
  (`test/clang/invariants.jl`) need no captured values and no per-platform care. They have
  their own ceiling — a *consistently* wrong shim satisfies them — which is what the
  independent oracle in `test/clang/differential.jl` closes. When you add an invariant, add
  the mutant it kills to the catalogue in `.claude/skills/suite-audit/`.

## Who decides the value — the three cases behind rule 3

Reaching for `# shape-only` is almost always premature. Ask what decides the value first,
because two of the three answers are assertable and only one is not.

**The target decides it** — sizes and alignments, ABI-specific layout offsets, mangled names,
endianness, integer widths. These are *not* unassertable, only unpinned. Build the interpreter
with `create_interpreter(...; triple="x86_64-linux-gnu")` and every one becomes an equality
that reads the same on all three runners; `test/clang/pinned_target.jl` is the worked example.
Only parsing and AST inspection can cross-target — the JIT still emits for the host — and
pinning downloads that target's GCC shard, so keep it to one target and one file rather than
pinning at every site.

**Nothing decides it** — module provenance (`isPartOfFramework`) and a hand-built `Module`'s
availability, including the `markUnavailable` transition whose gating predicate reads bits a
synthetic module never had a module map to set. These read uninitialized memory. Pinning a
triple does not help and would only make the answer look trustworthy; restate the precondition
instead, or leave the site `# shape-only` with that as its reason.

Before accepting that, check whether the state can simply be *initialized*. A `Driver`'s LTO
mode used to be the worked example here: asked of a driver that never processed arguments it
is a read of uninitialized memory, and the site was marked accordingly. But `BuildCompilation`
is what initializes it, so building one first turns the same call into an ordinary assertion —
`-flto` gives true and `-fsyntax-only` gives false, which is a partition rather than a pin.
Reaching for the marker is premature whenever a constructor or a setup call the test could
make would give the field a value. A wrapper whose value comes back outside its own enum (Julia prints
`<invalid #N>`) is this case — a UB precondition to restate, not a flaky test.

**The host decides it, and neither of the above applies** — a sysroot, an executable path.
This is the one that genuinely takes a shape assertion: `isa Bool`, `isa Integer`, or a round
trip of a value the test itself set.

## Three platforms, one local run

CI runs macOS, Linux and Windows on x86_64, and an equality assertion on something the runner
decides turns into a red CI on a platform you did not run locally. This class of bug is
invisible to a local single-platform run and to `-fsyntax-only`; only the per-file test run
against real AST state catches it, so never skip it before committing.

A C type whose *width* is platform-dependent is the sharpest version, because a mismatch is a
misread register rather than an error. `time_t` is 64 bits on every target but is `long long`
on mingw where the other two spell `long`, so the entry points taking one spell `int64_t` and
no alias tracks it — `const time_t = Clong` is what this package used to say, and it read half
a value on Windows alone. `shim_type_width` asks the shim its own widths and `test/abi.jl`
asserts them, so a toolchain flag change fails a test instead of corrupting a value. The
linking half of that story — why `off_t` needs `_FILE_OFFSET_BITS=64` — is in
`deps/ClangExtra/CLAUDE.md`, since the fix is a compile flag rather than an assertion.

## Layout

Test files are plain `@testset` files included by `test/runtests.jl`, laid out to mirror the
source tree: whole-package checks in `test/*.jl` (`lint.jl` and `abi.jl` are the meta guards),
middle-layer helpers in `test/clang/*.jl`, thin wrappers in `test/clang/api/**` alongside the
file they exercise. **A new test file must be added to `test/runtests.jl` by hand** — nothing
discovers them, so one that is never registered passes forever by not running.

Objects wrapping C++ resources need explicit `dispose(x)`; tests follow create → use → dispose.

## Reading a run

The root CLAUDE.md has the commands, including the `TestEnv` preference-copy needed to run one
file against a local build. Two traps when reading the result:

- **Piping hides failures.** `julia ... 2>&1 | tail -20; echo $?` reports *tail's* status.
  Redirect to a file (`julia ... > log 2>&1; echo $?`) and grep the log.
- **Grep for crashes, not just failures.** A segfault prints `signal 11 (2): Segmentation
  fault` (or `EXCEPTION_ACCESS_VIOLATION` on Windows) and never the word "Fail"; a libstdc++
  assertion prints `SIGABRT`. Include `signal|Segmentation|SIGABRT|EXCEPTION` in triage greps.
- A test file can pass standalone and still crash inside the full suite, because earlier files
  leave different AST state behind. Always run `Pkg.test()` before committing.
