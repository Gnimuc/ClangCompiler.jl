---
name: api-coverage
description: Measure which clang-cpp APIs this package does not wrap yet, and decide which of them are worth wrapping. Use when planning a wrapper batch, when asked "what is still missing", or before claiming any coverage number.
---

# Measuring the clang-cpp API gap

**Start with `candidates.jl`.** It uses *this package* to parse clang's own headers, so every
answer comes from a real `clang::CXXMethodDecl` rather than from libclang's cursor model — the
C API this package exists to reach past.

```bash
julia --project .claude/skills/api-coverage/candidates.jl              # sweep the wrapped classes
julia --project .claude/skills/api-coverage/candidates.jl Sema Decl    # named classes
julia --project .claude/skills/api-coverage/candidates.jl --json out.json
julia --project .claude/skills/api-coverage/selfcheck.jl               # is the oracle still right?
```

It answers the question that otherwise waits for a build: **would a wrapper for this LINK.**
Two methods on this branch were written and dropped because libclang-cpp exports neither
(`Sema::CheckBitwiseOperands`, `CheckLogicalOperands`), and `FileManager::getVirtualFileRef`
failed on Windows alone over a mangled name. Both were decidable up front.

Linkability is **not** "is the symbol exported". A method with a body in the header has no
out-of-line symbol at all — `Decl::getLocation` is `{ return Loc; }` — and a shim compiles its
own copy, so it links with nothing exported. The rule is *body-in-header OR exported symbol*,
and `selfcheck.jl` pins it against eight methods whose real outcome this branch already knows.
Run that after any change to the oracle; a tool that says "not linkable" about a working
accessor is worse than no tool.

`gapmap.jl` and `gapdiff.jl` are gone. They drove libclang through a temp environment and a
JSON round trip to produce a worse version of this, and their one distinctive part — the
`blocked` / `parser_action` / `out_of_scope` classifier — was fifteen lines of regex over a
signature string, now `shape_of` in `candidates.jl` running over a real parameter list instead
of text that happened to contain the word.

## Invariant 2 was checked, and does not need a lint

Every wrapper types its receiver at the abstract of the class that *declares* the method. The C
symbol names that class — `clang_NamedDecl_getName` — so it looked checkable, and it was worth
knowing whether the review dimension that keeps coming back clean was actually seeing anything.

**It holds.** Measured over `src/clang/api`: 8651 wrapper blocks, 6554 instance-method
receiver/symbol pairs, **zero mismatches**.

The check itself is not worth keeping, and the reason is the useful part. Four passes each
removed one family of false positives and revealed the next:

| looked like a mismatch | actually |
|---|---|
| `PrintStats(::Type{Decl})` | a static C++ method — no receiver at all; 971 of them |
| `clang_index_generateUSRFor*` | a namespace function, naming no class |
| `LookupResult_Filter` | a nested class, spelled `LookupResultFilter` as a carrier |
| `setCVRQualifiers(::Integer, ::Integer)` | `Qualifiers` is a value type marshalled as its opaque `unsigned` |
| `Decl::castFromDeclContext` | a static crossing the two hierarchies |

Text alone cannot separate these from a real defect; `isStatic` needs the AST. And a version
carrying six exemption families would be one more hand-maintained mirror that nothing pins —
the objection this repo already levelled at a proposed `_base` table. The measurement is the
deliverable; re-run it by hand if the wrapper layer ever changes shape.

## Read the output before believing it

`viable` is **not** a to-do list. It is what remains after five mechanical exclusions, and the
number has been wrong in both directions. Every count below was measured on this repo:

| category | meaning |
|---|---|
| `viable` | no *mechanical* blocker found — still needs judgement |
| `blocked` | C++ types with no C ABI in the signature (`ArrayRef`, `SmallVector`, …) |
| `parser_action` | `ActOn*`, needs an in-flight parse |
| `out_of_scope` | OpenMP / ObjC / code completion — deliberately not carried |
| `covered_otherwise` | real methods that must NOT be wrapped (see below) |

## The traps this measurement has fallen into

Five are handled by the script. Know them anyway, because they explain the classifications:

1. **Case.** One mis-cased class segment hides a whole class — it once hid all 44 of
   `clang::Value`'s methods, every one of which was bound. The compare is case-insensitive
   rather than trusting the shim to spell its own prefixes right.
2. **Stamping.** X-macro (`CXVALUE_ABI_TYPES`) and TableGen `.inc` families never appear as
   text in any header, so header-grepping misses them entirely.
3. **Julia-side classes.** `CharSourceRange` and `FullSourceLoc` are pure aggregates
   reproduced structurally in `src/clang/core/`. They have no `clang_*` symbol and never will.
4. **Base-class coverage.** `clang::Stmt::getBeginLoc` is non-virtual and 120 subclasses shadow
   it; one `getBeginLoc(x::AbstractStmt)` serves all of them. Counting per subclass inflated
   the tail by 682 methods — 53% of it.
5. **A different mechanism.** `classof` is answered by the O(1) `resolve`/`getStmtClass` table,
   not by 288 per-class shims. Classified `covered_otherwise`.

**The sixth is not mechanical and you must check it by hand.** Clang's small nested value types
are wrapped by hoisting their accessors onto the *owner*, so the nested class reports as having
no bindings at all while every question it answers is already reachable:

- `APValue::LValueBase` → 15 `clang_APValue_getLValueBase*`
- `FunctionType::ExtInfo` → `clang_FunctionType_getCallConv`, `_getProducesResult`, …
- `CFGTerminator` → all four are `clang_CFGBlock_getTerminator*`

Before treating any nested or value type in the "no bindings" list as a gap, grep the **owner's**
prefix. All three above were picked as candidates and all three were already covered.

## Deciding what to wrap

A method being `viable` is the start of the question. The bar is:

- **Reachable** — a user of this package can obtain the receiver. This package builds ONE
  incremental interpreter; it never sits inside a parse.
- **Meaningful** — it returns a non-degenerate answer for an object this package constructs.
  `ASTUnit::getASTReader` binds fine and returns null forever; a wrapper for it is a lie.
- **Safe** — any precondition is checkable from Julia, and the answer is not host-dependent.

If you cannot describe concretely how a test obtains the receiver and asserts something
non-degenerate, the answer is reject.

Measured conversion from `viable` to landed, over five adjudicated rounds: **10%, 12%, 12%,
20%, 2.4%**. Sema is the leanest — 264 of its 411 need a live in-flight parse. Plan batches
against that rate, not against the `viable` count.

## Before quoting a number

Re-run `gapmap.jl`, then `gapdiff.jl`. Quoting a stale map has produced wrong figures more than
once. And say which number you mean: "bound symbols" (C functions), "already wrapped" (methods
reachable from Julia) and "viable" are three different things.
