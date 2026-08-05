---
name: suite-audit
description: Check whether this package's test suite actually catches bugs — find assertions that never run, and inject faults to see what goes red. Use after adding tests, when a green suite feels unearned, or when asked how good the tests are.
---

# Auditing the test suite

A green suite says nothing on its own. Three separate failures have hidden behind one here, and
each was invisible until the one below it was fixed:

1. a test that passed *because* of the bug it should have caught;
2. assertions that never executed;
3. assertions that executed but could not fail.

`test/tautologies.jl` covers (3). It lives in the suite rather than here because `test/lint.jl`
shells out to it, so it runs in CI on every platform — a test must never depend on `.claude/`,
which is agent configuration and may not be present. The two scripts here cover (2) and the
question underneath all of it.

## Assertions that never run

```bash
find . -name '*.cov' -delete          # counts accumulate across runs — always clear first
julia --project -e 'using Pkg; Pkg.test(coverage=true)'
julia .claude/skills/suite-audit/deadtests.jl
```

Exits 1 when anything is reported.

This is not cosmetic. `DeclIterator` advanced before yielding, so it dropped the first
declaration of every context; the test that should have caught it looped over the elements the
iterator *did* yield, so its assertions passed on a truncated list and the bug survived.

Run it after adding any test that iterates. Then either construct the state that makes the
assertion run, or assert the empty case explicitly — never leave a loop whose body is the only
thing asserting.

## Does the suite detect faults at all?

```bash
julia --project .claude/skills/suite-audit/mutants.jl          # whole catalogue
julia --project .claude/skills/suite-audit/mutants.jl swap     # only matching labels
```

Each mutant redefines a single wrapper — an accessor returning a sibling member, a predicate
inverted, an index ignored — and runs the tests that exercise it. A mutant that **survives** is
a precise gap: some wrapper can return the wrong thing and nothing notices.

Read the two outcomes differently. "Caught by an assertion" is the suite working. "Crash" means
the fault was noticed by luck — a subtler version of the same mutation would pass.

When you add an invariant that kills a mutant, add the mutant to the catalogue.

## What each layer can and cannot prove

Know the ceiling of the thing you are about to rely on:

- **Pinned values** catch regressions away from what the shim returns *today*. They say nothing
  about whether today's answer is right — if a shim has always been wrong, the pin freezes the
  bug.
- **`isa` assertions** cannot separate two results of the same type. `getBeginLoc` returning the
  end location passes every one of them. This is what `test/tautologies.jl` exists to find.
- **Metamorphic invariants** (`test/clang/invariants.jl`) assert relationships that hold over
  any AST — a parent's range contains its children's, a binary operator's operands are distinct
  nodes. They need no captured values and no per-platform care. Five testsets took the mutation
  score from 28.6% to 85.7%; one invariant is worth a hundred value assertions.
- **Invariants still have a ceiling**: they check the shim's answers against each other, so a
  *consistently* wrong shim satisfies them. Swap `getBeginLoc` and `getEndLoc` together and
  containment still holds, because containment is symmetric. Measured: invariants report 0
  failures for that mutant, the differential test reports 3.
- **A differential oracle** (`test/clang/differential.jl`) compares against something that is
  not the shim — clang's own `-ast-dump` in a separate process. It is the only guard here that
  can find a wrapper wrong since the day it was written. Compare like with like when extending
  it: `printAsString` uses the context's `PrintingPolicy`, which is what the dump uses, while
  `getAsString` uses clang's default and spells an empty parameter list `(void)`.

## Reading a run honestly

- **Piping hides failures.** `julia ... | tail` reports *tail's* exit status. Redirect to a file
  and grep it.
- **Grep for crashes, not just failures.** A segfault prints `signal 11 (2): Segmentation fault`
  (or `EXCEPTION_ACCESS_VIOLATION`) and never the word "Fail"; a libstdc++ assertion prints
  `SIGABRT`. Include `signal|Segmentation|SIGABRT|EXCEPTION` in triage greps.
- A file can pass standalone and still crash in the full suite, because earlier files leave
  different AST state. Always run `Pkg.test()` before committing.
