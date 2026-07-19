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
- **Reuse LLVM's C types.** Clang sits on LLVM; anything already exposed by the LLVM-C API
  or LLVM.jl's libLLVMExtra (APInt/APFloat/Value/Type/Module/MemoryBuffer/…) crosses as that
  handle, never a parallel `CX` type. Missing LLVM accessors go upstream to libLLVMExtra in
  llvm-c style, not into libclangex. Only genuinely-Clang types get `CX` handles. See
  `MARSHALLING.md` §0.
- **Hybrid strategy.** Uniform machinery (classification, casts, kind enums)
  is stamped from clang's own TableGen tables; payload accessors are
  hand-written under the conventions in CLAUDE.md, because marshalling and
  ownership need per-method judgment. Offline generation of payload stays
  rejected unless bulk demand appears.
- **Vendored .inc tables.** The binding generator drops declarations expanded
  from `-isystem` paths, so TableGen tables are vendored verbatim under
  `include/clang-ex/` (`AST/StmtNodes.inc`, `AST/DeclNodes.inc`,
  `AST/TypeNodes.inc`, `AST/AttrList.inc`). A stale vendored copy cannot ship:
  the impl-side static_assert tables fail the build.
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
      iterator-range, and out-of-band-result wrappers, plus the LLVM-type-reuse
      rule (§0): LLVM-owned values cross as their llvm-c/libLLVMExtra handle.
- [x] Payload/type tail (T1–T5): ASTContext Decl/Type-arg builders and the
      MangleContext/ASTNameGenerator manglers (mangleName); the Expr·Stmt
      enum/pointer/location payload (construction/new/predefined-kind enums,
      sub-node pointer accessors, statement locations); the sugar-type layer
      (carriers, isa predicates, ordered resolve) for all twelve remaining
      Type classes; method/ctor and DeclStmt-decl iteration; and template
      navigation (getTemplateParameters/getTemplatedDecl, param depth/index,
      getSpecializedTemplate/Kind). Skiplist 794 → 220.
- [x] APValue bridge — opaque `CXAPValue` handle (MARSHALLING.md §3) with
      kind-dispatched accessors (getKind + the CXAPValueKind ENUM_SYNC mirror,
      isInt/isFloat/isArray/isStruct, array/struct navigation) and int/float
      leaves crossing as `LLVMGenericValueRef` per the LLVM-reuse rule (§0).
      Two evaluation entry points feed it: `clang_Expr_EvaluateAsRValue`
      (owned result) and `clang_VarDecl_evaluateValue` (borrowed, cached).
- [x] Expr constant-evaluation cluster on the APValue bridge —
      isEvaluatable/isIntegerConstantExpr/isCXX11ConstantExpr predicates and the
      typed EvaluateAsInt (owned CXAPValue), EvaluateAsBooleanCondition (1/0/-1),
      and EvaluateAsFloat (folded bits as LLVMGenericValueRef) entry points, all
      at the strict SE_NoSideEffects policy.
- [x] Mechanical wrapper tail (8 families, parallel-designed + adversarially
      reviewed by subagents, integrated serially). Value-type bridges:
      NestedNameSpecifier navigation (+ SpecifierKind enum), DeclarationNameInfo
      (heap-boxed carrier), TemplateArgumentList / TemplateSpecializationType
      arg indexing. DeclCXX: CXXDeductionGuideDecl, using-decls
      (BaseUsingDecl/UsingShadowDecl/UsingDirectiveDecl), CXXCtorInitializer +
      ctor-init iteration. Iteration: LambdaExpr captures (+ CXLambdaCapture
      carrier), FunctionType/FunctionProtoType params/return/exception-spec/
      calling-conv, IndirectFieldDecl chain, ImportDecl identifier locs, CastExpr
      base path. Payload: StringLiteral, UnaryExprOrTypeTraitExpr getKind (+ UETT
      enum), PredefinedExpr. +61 C bindings, five new ENUM_SYNC-guarded enum
      mirrors, exercised by test/wrappers_tail.jl.
- [x] DeclNodes.inc stamping — the Phase-1 Stmt mechanism applied to the Decl
      hierarchy. Vendored DeclNodes.inc drives a mirror-by-construction CXDeclKind
      enum (with the first/last range markers) + per-class static_assert drift
      table, and X-macro-stamped clang_Decl_castTo*/is* for all ~95 classes
      (ObjC/OMP included) + clang_Decl_getKind. gen/decl_nodes.jl emits
      lib/<major>/DeclNodes.jl; the Julia layer builds DECL_KIND_TO_TYPE and an
      O(1) resolve(::AbstractDecl) from it, replacing the unsafe raw-pointer
      reconstruction with a getKind-checked downcast. +191 C bindings; the three
      superseded hand-written casts and the isTemplateDecl method fold into the
      stamped family.
- [x] TypeNodes.inc stamping — the same mechanism for the Type hierarchy. A
      mirror-by-construction CXTypeClass enum (named to dodge the libclang
      CXTypeKind collision) with per-class static_assert drift + a TypeLast count
      assert, X-macro-stamped clang_Type_castTo<Class>Type for every class, and
      clang_Type_getTypeClass. gen/type_nodes.jl emits lib/<major>/TypeNodes.jl;
      the order-sensitive is_*_type predicate chain in src/types.jl is replaced by
      an O(1) TYPE_CLASS_TO_TYPE lookup off getTypeClass (which resolves straight
      to the concrete leaf — Record/Enum, Proto/NoProto, LValue/RValue,
      Constant/… — subsuming the Tag/Function/Reference/Array sub-resolves). The
      classification predicates stay in the separate clang_isa_ family; only
      downcasts are stamped, since clang_Type_is<Class>Type is reserved for
      clang's sugar-piercing semantic queries. +61 C bindings.
- [x] Attribute classification floor — the fourth .inc-driven family. Vendored
      AttrList.inc drives a mirror-by-construction CXAttrKind enum (396 attrs +
      the category range markers) with a per-attr static_assert drift table, plus
      the Attr base API (getKind/getSpelling/getRange/getLocation/isImplicit/
      isInherited/isPackExpansion) and Decl::getAttrs iteration
      (hasAttrs/getNumAttrs/getAttr). Attributes are now reachable and
      identifiable from Julia (getAttrs -> [Attr], getKind, getSpelling); per-attr
      payload and the castTo/is stamp are deferred (see Attribute payload above).
- [x] TypeLoc floor — an opaque heap-boxed CXTypeLoc handle reached via
      clang_TypeSourceInfo_getTypeLoc, with getType, getBeginLoc/getEndLoc,
      getSourceRange/getLocalSourceRange, getNextTypeLoc (chain walk), isNull, and
      dispose. Makes a declarator's written type and its location chain reachable
      — the source-range floor for rewriting tools.
- [x] Traversal throughput — bulk Stmt subtree extraction. clang_Stmt_getSubtreeSize
      + clang_Stmt_collectSubtree fill parallel node/CXStmtClass buffers in one
      pre-order walk, so subtree(::AbstractStmt) resolves a whole subtree with O(1)
      FFI round-trips (2 ccalls) and no per-node getStmtClass — the fix for the
      per-child round-trip that would not survive whole-function walks.
- [x] Whole-TU Decl traversal — the DeclContext sibling of bulk subtree.
      clang_DeclContext_getRecursiveDeclCount + collectRecursiveDecls fill parallel
      decl/CXDeclKind buffers in one pre-order walk (recursing into nested
      contexts), so decls(::DeclContext) resolves an entire TU with O(1) FFI
      round-trips instead of the per-decl decl_iterator protocol.
- [x] Test-coverage sweep (two subagent workflows). Exercise tests calling the
      read surface (getters/predicates) took src/clang/api function coverage 14%
      -> 86%; then wrapping + round-trip/factory-testing the AST Create*/set*
      surface took it to 89% (skiplist 794-era -> 83). Surfaced + fixed three
      latent wrapper arity/name bugs invisible to abi.jl/coverage.jl
      (isNoDestroy, getTemplateInstantiationPattern, isPure->isPureVirtual).
      test/{coverage_exercise,setter_factory,platform}.jl.
- [x] Acceptance corpus — "full power" demonstrated falsifiably by four real
      static-analysis tools built entirely on the wrapped surface, in
      test/acceptance.jl: a null-safety pointer-dereference finder (subtree +
      UnaryOperator/MemberExpr/ArraySubscriptExpr classification), an
      unused-local-variable linter (DeclStmt/DeclRefExpr cross-referencing), a
      direct-call/call-graph edge lister (CallExpr -> getDirectCallee), and a
      struct-layout dumper (field iteration + QualType resolve). Each proves the
      parse -> find -> traverse -> resolve -> payload path end to end.
- [x] Whole-TU Decl traversal — the DeclContext sibling of bulk subtree.
      clang_DeclContext_getRecursiveDeclCount + collectRecursiveDecls fill parallel
      decl/CXDeclKind buffers in one pre-order walk (recursing into nested
      contexts), so decls(::DeclContext) resolves an entire TU in O(1) FFI
      round-trips.
- [x] Skiplist introspection sweep — wrapped the genuinely-useful accessors still
      parked (FieldDecl bit-width/zero-size, RecordDecl isMsStruct, BlockDecl/
      CapturedDecl params, CStyleCastExpr paren locs, Decl isFunctionOrFunctionTemplate);
      ratchet 219 -> 209. The residue is Create*/set* AST-mutation, parked by design.
- [x] OMP abstract-base payload — OMPExecutableDirective getNumClauses /
      isStandaloneDirective / hasAssociatedStmt / getAssociatedStmt (the base where
      the real API lives; per-directive payload stays on demand).

## Remaining

All of the below is **on-demand payload depth** (per the Hybrid-strategy and
OMP/ObjC standing decisions): the classification, traversal, and bridge
*infrastructure* is complete, so each of these is a bounded add whenever a real
use surfaces. They do not gate anything.

- [ ] **Attribute payload** — per-attribute accessors (AlignedAttr::getAlignment, …)
      + the stamped clang_Attr_castTo/is family, once the ~396-class breadth is
      worth wrapping. Classification floor done; getAttrs/getKind reach any attr.
- [ ] **TypeLoc payload** — per-TypeLoc-class accessors (PointerTypeLoc star loc,
      FunctionTypeLoc param locs, …). The handle + source-range/getNextTypeLoc
      floor is done.
- [ ] **CompilerInstance/frontend mutators** — the interpreter-setup setters
      (setInvocation/setDiagnostics/setFileManager/…) and execution entry points
      (ParseAndExecute/undo/…) still parked in api_skiplist.txt (~83 symbols).
      These can't be round-trip-tested on the live interpreter without corrupting
      it, so they need a throwaway CompilerInstance harness — deferred until a use
      needs them. (The AST Create*/set* surface is now wrapped + covered — below.)
- [ ] **Release train** — libclangex_jll rebuild on Yggdrasil + compat bump
      (this branch adds ~1100 C symbols — the earlier drift fixes, the 90
      CXXRecordDecl traits, the APValue bridge with its Expr eval cluster, the
      8-family mechanical wrapper tail, the DeclNodes/TypeNodes/AttrList.inc
      stamping, and the TypeLoc + bulk-subtree floors — and corrects
      CXCastKind/CXLinkage values).
