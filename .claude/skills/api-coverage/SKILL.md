---
name: api-coverage
description: Measure which clang-cpp APIs this package does not wrap yet, and decide which of them are worth wrapping. Use when planning a wrapper batch, when asked "what is still missing", or before claiming any coverage number.
---

# Measuring the clang-cpp API gap

Two scripts. `gapmap.jl` extracts the public method surface of the pinned Clang headers with
libclang; `gapdiff.jl` diffs that against what this package actually reaches and ranks the
remainder.

```bash
julia .claude/skills/api-coverage/gapmap.jl /tmp/gap.json
julia .claude/skills/api-coverage/gapdiff.jl /tmp/gap.json
julia .claude/skills/api-coverage/gapdiff.jl /tmp/gap.json --class Sema   # names, per class
```

`gapmap.jl` activates its own temp environment and needs network on first run. Regenerate the
map after landing wrappers — the diff is only as current as the map.

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
