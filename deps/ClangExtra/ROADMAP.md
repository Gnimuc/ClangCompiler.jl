# ROADMAP — toward a fully AI-maintained, full-power Clang C wrapper

Goal (owner-stated): expose Clang-cpp's full power through this C shim and the
Julia layers above it — not a libclang-like scope-limited wrapper — with AI
agents doing the maintenance. This file records the standing decisions and the
remaining phases. Status markers: [x] done, [ ] open.

## Standing decisions

- **Single-client C ABI.** The C shim has exactly one client — the Julia thin wrapper in
  `src/clang/`, which is the sole safety boundary. The C layer stays type-erased (`void *`)
  and check-free by design; subtyping, multiple inheritance, and all type-checking are
  reproduced in Julia. The axiom and its two enforcing invariants live in
  `deps/ClangExtra/CLAUDE.md` and `src/clang/CLAUDE.md`.
- **Hybrid strategy.** Uniform machinery (classification, casts, kind enums)
  is stamped from clang's own TableGen tables; payload accessors are
  hand-written under the conventions in CLAUDE.md, because marshalling and
  ownership need per-method judgment. Offline generation of payload stays
  rejected unless bulk demand appears.
- **Vendored .inc tables.** The binding generator drops declarations expanded
  from `-isystem` paths, so TableGen tables are vendored verbatim under
  `include/clang-ex/` (currently `AST/StmtNodes.inc`). A stale vendored copy
  cannot ship: the impl-side static_assert tables fail the build.
- **Version-following stamped ABI.** Stamped symbols (`CXStmtClass_*`,
  `clang_Stmt_castTo*/is*`) track clang's naming per LLVM major (clang inserts
  and renames nodes between majors; `lib/<major>/` models that). The
  frozen-ABI rule applies to hand-written symbols only.
- **OpenMP/ObjC posture.** All 234 concrete classes get stamped
  classification/casts (free); payload for OMP/ObjC is added on demand, likely
  starting with the two OMP abstract bases (OMPExecutableDirective,
  OMPLoopDirective) where their real API lives.
- **Guardrails precede scale.** Every mechanical drift class is a compile
  error or test failure: -Werror missing-prototypes/-declarations, ENUM_SYNC
  static_assert tables, dlsym parity (test/abi.jl), layout lint
  (test/lint.jl), binding-coverage ratchet (test/coverage.jl +
  api_skiplist.txt), and the regen-no-diff CI job.

## Done

- [x] Guardrail set (all of the above) + fixes for every latent drift bug they
      surfaced (19 mangled-symbol sites, CXLinkage off-by-one, truncated
      CXCastKind, duplicate typedef, guard collisions).
- [x] Phase 1 — stamped Stmt layer: CXStmtClass mirror-by-construction,
      castTo/is for 234 concrete + 15 abstract classes, Stmt base API,
      Expr base API; Julia hierarchy stamped from the same table
      (lib/<major>/StmtNodes.jl), O(1) `resolve(::AbstractStmt)`, `children`.
- [x] Phase 2 (first slice) — payload for the priority classes: core C
      operators/literals/calls/members/casts/control flow, CXX call/construct/
      lambda/new/delete/try/for-range. ~130 new payload functions, all wrapped
      in the Julia api layer and exercised by test/stmt.jl.
- [x] Coverage sweep of the already-bound surface — Julia thin wrappers for the
      accessors parked in the skiplist across Type, Decl, DeclCXX, Expr,
      DeclTemplate, and ASTContext (type builders/comparisons/info/navigation).
      The binding-coverage ratchet dropped 794 → 323.
- [x] CXXRecordDecl class-trait predicates — 90 new C bindings for the
      polymorphism/layout/triviality/special-member/lambda queries, wrapped on
      AbstractCXXRecordDecl.
- [x] CXXBaseSpecifier and ExplicitSpecifier carriers + accessors (base-edge
      and explicit-specifier introspection).
- [x] MARSHALLING.md — the standing playbook for the complex value-type,
      iterator-range, and out-of-band-result wrappers.

## Remaining

- [ ] **Payload tail** (priority order from the measured census): Expr-base
      evaluation cluster (needs APValue bridge), StringLiteral width variants,
      UnaryExprOrTypeTraitExpr (needs a UETT enum mirror from TokenKinds.def),
      remaining top-25 classes (StmtExpr, GenericSelectionExpr, …), then
      breadth-first over the ~95 core classes with ≤2 payload methods.
- [ ] **Member iteration** (count+fill per MARSHALLING.md §6): RecordDecl
      fields, EnumDecl enumerators, CXXRecordDecl bases/methods/ctors, DeclStmt
      decls — the primary remaining traversal gap, all needing C-side shims.
- [ ] **DeclCXX completion** — CXXRecordDecl traits, base iteration, and the
      constructor/conversion/destructor predicate surface are done; the
      deduction-guide class, the using-decls, and the CtorInitializer /
      ExplicitSpecifier-by-value paths (MARSHALLING.md §7) still remain.
- [ ] **Type-system completion** — carriers + `is_*`/resolve entries for the
      remaining sugar types (Atomic, Decltype, Decayed, Adjusted, Deduced,
      InjectedClassName, MacroQualified, UnaryTransform, DependentAddressSpace,
      DependentSizedExtVector, Paren); several need a new `clang_isa_*` C
      predicate first.
- [ ] **Decl/Type .inc treatment** — apply the Phase-1 mechanism to
      DeclNodes.inc (CXDeclKind + castTo/is, replacing string-compare
      getDeclKindName dispatch) and TypeNodes.inc (replacing the ordered
      resolve() predicate chain in src/types.jl).
- [ ] **Decl/Type .inc treatment** — apply the Phase-1 mechanism to
      DeclNodes.inc (CXDeclKind + castTo/is, replacing string-compare
      getDeclKindName dispatch) and TypeNodes.inc (replacing the ordered
      resolve() predicate chain in src/types.jl).
- [ ] **Value-type bridges** that gate full power: APValue,
      DeclarationNameInfo, TemplateArgument lists, NestedNameSpecifier
      navigation. These cause most of Decl's systematic skips.
- [ ] **Attributes** — a third .inc-driven family (Attrs.inc); zero exposure
      today, `Decl::getAttrs` unreachable.
- [ ] **TypeLoc** — at minimum an opaque handle + source-range floor;
      required for rewriting tools.
- [ ] **Traversal throughput** — one FFI round-trip per child won't survive
      whole-TU walks; plan a C-level visitor callback or bulk subtree
      extraction.
- [ ] **OMP abstract-base payload** (per posture above).
- [ ] **Acceptance corpus** — define "full power" falsifiably: a small set of
      real tools (null-check linter, unused-include pass, template
      instantiation dumper) that must be expressible from Julia.
- [ ] **Release train** — libclangex_jll rebuild on Yggdrasil + compat bump
      (this branch adds ~740 C symbols — the earlier drift fixes plus the 90
      CXXRecordDecl traits — and corrects CXCastKind/CXLinkage values).
