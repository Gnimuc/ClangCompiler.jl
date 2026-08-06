---
name: doc-audit
description: Check whether this repo's prose still describes the code — find claims the tree contradicts, references that no longer resolve, and guidance split across files. Use before merging a branch that changed the architecture, when a doc feels older than the code, or when asked whether the documentation is still true.
---

# Auditing the prose against the tree

Nothing in CI reads a sentence. `test/lint.jl` checks that MARSHALLING.md's anchors resolve and
that the symbols it cites exist in the files it names — real, and it catches nothing below.

**Do not try to fix this with more lint.** A rule per claim does not scale, and a generic rule
over prose is worse than nothing here: green CI would read as "docs verified" when all it
verified is that paths exist. That is a check that cannot fail on the thing that matters, which
is the exact defect `test/tautologies.jl` exists to burn out of the suite. Judging whether a
sentence is true needs reading. This skill is how to read.

## Start with the facts

```bash
julia --project .claude/skills/doc-audit/facts.jl
```

It does only the part that needs no judgement: it counts the quantities the docs assert most
often (handle representation, symbol and binding counts, wrapper and test counts, `public`
names, MARSHALLING.md's actual section numbers, the formatter settings, the CI jobs), it
resolves every cited path, `clang_*` symbol and relative link, and it lists bare constants.
Exits 1 when a reference does not resolve.

A clean run means **no citation is dangling**. It does not mean a single claim is true.
`clang_ASTContext_getNumTypes` can exist while the sentence around it says the opposite of what
it does — which is how the defects below survived a suite that already checks cited symbols.

## The three kinds, each one this branch actually shipped

**A false claim.** Root CLAUDE.md said *"All CX handles are `Ptr{Cvoid}` aliases, so the raw
layer has no type safety."* True before the branch that made every handle its own phantom type,
and afterwards the tree said 0 and 1051 the other way. The same sentence had been copied into
CONTRIBUTING.md and MARSHALLING.md, so fixing one left two.

Hunt universals first — *all, every, never, always, only, none* — and any sentence of the form
"X is a Y". They are the claims a refactor invalidates wholesale, and the ones a reader acts on
without checking. Then hunt the *conclusion* drawn from the claim: "so the raw layer has no type
safety" was the damaging half, because it sends a reader to trust the wrong guard.

**A dangling reference.** `deps/ClangExtra/CLAUDE.md` documented passing a `SourceRange` "either
as `CXSourceRange_` by value or decomposed into two `CXSourceLocation_` args", citing a
clang_Sema_setAnnotationRange that does not exist — and neither does the pattern, since no entry
point in the library takes two locations. Someone following it would have written the only one.
`facts.jl` finds this class; the judgement is what to replace it with.

Note that dead name is written here without backticks. Backticks assert "this is a real
identifier", so a name being quoted *because* it is not one does not get them — which is also
what keeps `facts.jl` from reporting this page as broken.

**Split or misplaced guidance.** The test rules lived in two sections of root CLAUDE.md a
hundred lines apart, with one rule's three legitimate reasons stated in the first and explained
in the second. A formatting discussion sat under a heading reading "Rules for writing a test
here". No script sees either. Read each file's headings as an outline and ask whether the
content under each belongs there, and whether anything under two headings should be under one.

## Verifying without inventing

The failure mode of this audit is the confident false positive. Four traps, all of which have
fired here:

- **`grep -c` prints `file:COUNT`**, which reads exactly like `file:LINENO`. Misreading one led
  to a reported contradiction in CONTRIBUTING.md's `AbstractConditionalOperator` paragraph that
  did not exist — the doc was correct and matched the code.
- **Backticks defeat a phrase grep.** Searching `runtests.jl by hand` finds nothing when the
  prose says ``` `test/runtests.jl` by hand ```. A missing match is not evidence of absence.
- **A sentence describing the old state as history is not a defect.** Much of this repo's prose
  explains what changed and why; "this package used to say `const time_t = Clong`" is correct
  precisely because it is in the past tense.
- **Read the whole paragraph.** A sentence that looks wrong alone is often qualified two lines
  down.

Never report a finding you have not reproduced with a command, and quote the command. When two
docs disagree, the tree decides — not the longer file and not the more recent one.

## Bare constants

`facts.jl` lists every number in prose. Correct today is not the question: nothing updates them,
so each is a defect with a delay. The repo's rule is **compute, don't quote** — delete the
number and give the command that recomputes it. `CLAUDE.md`'s scratchspace symbol-count check is
the pattern to copy.

Treat a *count* differently from a *measurement*. "3300 of 5322 methods wrapped" rots on the
next batch and should become a command. "invariants took the mutation score from 28.6% to 85.7%"
is a historical measurement of a specific change and stays.

## What this cannot catch

- Prose that is true and useless, or true and misleading by omission.
- Advice that was right and has been overtaken by a better approach.
- A claim about something outside the tree — clang's own behaviour, a toolchain's, CI's — which
  can only be settled by running it.
- Whether the *organisation* serves a reader who does not already know the answer. Splitting the
  test rules was found by someone asking "where should this live", not by any check.

So this is a periodic read, not a gate. Run it when the architecture moved.
