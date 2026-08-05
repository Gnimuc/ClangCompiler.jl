# MARSHALLING.md — patterns for the hard-to-wrap Clang APIs

Most Clang methods marshal trivially (bool/int/enum, a `QualType` opaque pointer, an
AST-node pointer). This file is the playbook for the ones that don't — the value types,
iterator ranges, and out-of-band results that a naive `void *` accessor can't carry. Each
pattern respects the single-client axiom (see `CLAUDE.md`): the C shim stays type-erased and
total; the Julia thin wrapper re-imposes types and checks preconditions.

Pick the lightest pattern that fits. Prefer exposing components over marshalling an aggregate;
prefer a borrowed interior pointer over an owned copy; only heap-box when the value has no
pointer form and the caller genuinely needs it.

The one exception to preferring a borrow: when what the pointer points into is **private** to
the owning class, so the boundary cannot observe that the storage moved, the borrow can be
neither checked nor honestly documented away. Copy instead — see §14.

## 0. Reuse LLVM's own C types — don't reinvent them

Clang is built on LLVM, so many values crossing the boundary are LLVM-owned, not Clang-owned.
For any type already exposed by the **LLVM-C API** or **LLVM.jl's libLLVMExtra**, cross it as
that existing handle and convert with `llvm::wrap`/`llvm::unwrap` (or the established
`reinterpret_cast` where llvm-c has no public wrap) — never mint a parallel `CX` type:

- `llvm::Module`/`Type`/`Value`/`Constant`/`LLVMContext`/`MemoryBuffer` → `LLVMModuleRef`,
  `LLVMTypeRef`, `LLVMValueRef`, `LLVMContextRef`, `LLVMMemoryBufferRef` (the shim already does
  this for CodeGen, PCH buffers, and the Orc `LLVMOrcLLJITRef`/`LLVMOrcExecutorAddress`).
- `llvm::APInt`/`APSInt` → an `llvm::GenericValue*` (its `IntVal`) reinterpreted to
  `LLVMGenericValueRef`, the bridge `clang_IntegerLiteral_getValue` /
  `clang_TemplateArgument_getAsIntegral` already use. `APFloat` rides the same bridge
  (§2). A ConstantInt/ConstantFP `LLVMValueRef` is the alternative when a context is in hand.

Only genuinely-Clang types get a `CX` handle: `Decl`/`Stmt`/`Expr`/`QualType`/`Type`,
`APValue`, `Attr`, `TypeLoc`, `TemplateArgument`, `NestedNameSpecifier`, `DeclarationNameInfo`,
`ASTRecordLayout`, `clang::Module` (`CXModule` — the header-modules type, *not* `llvm::Module`),
`clang::Value` (`CXValue` — the interpreter value). When one of these wraps an LLVM value
(e.g. `APValue`'s integer/float leaves), the wrapper is `CX` but the leaf still crosses as its
LLVM-C handle.

**Upstreamability.** If an LLVM accessor you need is missing from llvm-c/libLLVMExtra, add it
*there*, in llvm-c's own style — `LLVM<Thing>Ref` opaque pointers, `LLVMBool`, out-params,
`LLVMDispose<Thing>` — so it can be contributed to LLVM.jl's libLLVMExtra rather than fossilised
as a one-off Clang-side shim. Reserve libclangex for what is genuinely Clang.

**In the tree.** The CodeGen module and PCH buffers cross as `LLVMModuleRef` /
`LLVMMemoryBufferRef`; the Orc JIT as `LLVMOrcLLJITRef` in
`clang_Interpreter_getExecutionEngine` (`lib/Interpreter/CXInterpreter.cpp`); the
APSInt bridge in `clang_IntegerLiteral_getValue` (`lib/AST/CXExpr.cpp`).

## 1. Arbitrary-precision integers (`APSInt`, `APInt`)

Returned by `IntegerLiteral::getValue`, `EnumConstantDecl::getInitVal`,
`Expr::EvaluateKnownConstInt`, `TemplateArgument::getAsIntegral`, `ConstantExpr::getResultAsAPSInt`.

**Reuse the existing bridge.** The shim already crosses `APSInt` as an
`llvm::GenericValue*` reinterpreted to `LLVMGenericValueRef` (see `clang_IntegerLiteral_getValue`
/ `clang_TemplateArgument_getAsIntegral`). Heap-box the `APSInt` into a `new llvm::GenericValue`,
set `IntVal`, and return the `LLVMGenericValueRef`; the caller owns it (LLVM-C dispose). Do not
invent a second integer-boxing scheme.

**In the tree.** `clang_IntegerLiteral_getValue` (`lib/AST/CXExpr.cpp`),
`clang_TemplateArgument_getAsIntegral` (`lib/AST/CXTemplateBase.cpp`).

## 2. Arbitrary-precision floats (`APFloat`)

Returned by `FloatingLiteral::getValue`.

**Reuse the LLVM-C numeric bridge — `APFloat` is an LLVM type (§0), so no `CXAPFloat`.**
`getValueAsApproximateDouble` covers the common case with a plain `double`. For exactness,
`APFloat::bitcastToAPInt()` gives the raw bit pattern; cross that through the same
`LLVMGenericValueRef` (`GenericValue::IntVal`) bridge as §1, or wrap a ConstantFP as an
`LLVMValueRef`. Never return the `APFloat` by value and never mint a parallel `CX` handle for it.

**In the tree.** `clang_FloatingLiteral_getValueAsApproximateDouble`
(`lib/AST/CXExpr.cpp`) — the plain-`double` path; the exact-bits path rides the
`APValue` `getFloat` bridge (§3).

## 3. Compile-time values (`APValue`)

Returned by `VarDecl::getEvaluatedValue`, `ConstantExpr::getAPValueResult`,
`MaterializeTemporaryExpr::getOrCreateValue`, and the target of `Expr::EvaluateAs*`.

**Opaque handle + kind-dispatched accessors.** Add `CXAPValue` (heap-boxed
`new clang::APValue(...)` with `clang_APValue_dispose`), plus `clang_APValue_getKind` and a
per-kind accessor family (`getInt` via the APSInt bridge, `getFloat`, array/struct element
getters). This is the one genuinely large bridge; everything constant-evaluation depends on it.
For the integer-only common case, a narrow shim (`EvaluateAsInt` → bool + `LLVMGenericValueRef`
out) avoids the full handle.

**In the tree.** The `CXAPValue` family — `clang_APValue_getKind` + the per-kind
getters (`lib/AST/CXAPValue.cpp`); the borrowed entry point
`clang_VarDecl_evaluateValue` (`lib/AST/CXDecl.cpp`).

## 4. Fallible evaluation (`Expr::EvaluateAsInt/AsRValue/AsFloat`)

These fill an `Expr::EvalResult` (an `APValue` + a diagnostics vector) and take `const ASTContext&`.

**bool-return + out-param.** `clang_Expr_EvaluateAsInt(CXExpr, CXASTContext, LLVMGenericValueRef* out)`:
run into a local `EvalResult`, on success box `Result.Val.getInt()` through the APSInt bridge and
return `true`; `false` (leaving `*out` untouched) on non-constant. No exceptions cross.

**In the tree.** `clang_Expr_EvaluateAsInt` / `EvaluateAsBooleanCondition` /
`EvaluateAsFloat` (`lib/AST/CXExpr.cpp`).

**When the status half matters, promote the `EvalResult` to a caller-owned box.**
The bool-return form discards everything in the aggregate except the value —
`hasSideEffects`, `HasUndefinedBehavior`, `isGlobalLValue`. `CXEvalResult` is a
heap-boxed `Expr::EvalResult` (`clang_EvalResult_create` / `_dispose`); the
`...IntoResult` evaluators take it as an in/out parameter and the status is read
back through accessors. `EvaluateCharRangeAsString` cannot be wrapped at all
without it. Two notes: the box's `Val` is *interior* and must never reach
`clang_APValue_dispose`, and because the C surface carries no subtyping, the
`EvalStatus` base-class accessors take the same derived handle. clang does not
clear the flags between evaluations into one result, so use a fresh box whenever
the flags matter.

## 5. Strings built on the C++ side (`std::string`, `raw_ostream` sinks)

`NamedDecl::getQualifiedNameAsString`, `MangleContext::mangleName` (writes a `raw_ostream`),
`printName`/`printQualifiedName`.

**`std::string` → `CXString`.** Build into a `std::string` (via `llvm::raw_string_ostream` for
the streaming APIs), return `extra::makeCXString(s)`; Julia frees it with `get_string`. This is
the same path as the existing `getName`-style returns.

**In the tree.** `clang_MangleContext_mangleName` (`lib/AST/CXMangle.cpp`) via
`extra::makeCXString` (`lib/utils.h`); the borrowed `const char*` variant for
Clang-owned storage is `clang_NamedDecl_getName` (`lib/AST/CXDecl.cpp`).

## 6. Iterator ranges → count + index (random-access) or count + fill (forward-only)

Clang exposes members as C++ ranges, not arrays. Two shapes:

- **Random-access storage** (`CXXRecordDecl::bases`/`vbases`, `CallExpr::arguments`,
  `CXXNewExpr::placement_args`): a `getNum*()` + `get*(unsigned i)` index pair, mirroring the
  existing `CXXConstructExpr::getNumArgs`/`getArg`. Cheapest and preferred where the container
  is contiguous.
- **Forward-only iterators** (`RecordDecl::fields`, `EnumDecl::enumerators`,
  `CXXRecordDecl::methods`/`ctors`, `DeclStmt::decls`, `IndirectFieldDecl::chain`): a two-call
  count + fill — `getNum*()` walks once to count, `get*(buf)` fills a caller `CX*[]` buffer —
  mirroring `Stmt::getNumChildren`/`getChildren`. Avoid a `getNum + getAt(i)` pair here: each
  `getAt` re-walks from `begin`, making iteration O(n²).

State the count semantics in a header comment (slots may be null; count is exact).

**In the tree.** Count+index — `clang_CXXRecordDecl_getNumBases` / `getBase`
(`lib/AST/CXDeclCXX.cpp`), `clang_TemplateSpecializationType_getNumArgs` /
`clang_TemplateSpecializationType_getArg` (`lib/AST/CXType.cpp`). Count+fill —
`clang_RecordDecl_getFields`, `clang_EnumDecl_getEnumerators`
(`lib/AST/CXDecl.cpp`); for a `std::vector<std::string>` member the fill buffer
carries borrowed `c_str()` pointers — `clang_CodeGenOptions_getCommandLineArgs`
(`lib/Basic/CXCodeGenOptions.cpp`), `clang_FrontendOptions_getModulesEmbedFiles`
(`lib/Frontend/CXFrontendOptions.cpp`). Bulk two-buffer (node
pointers + kinds in lockstep, whole walk in one call) — `clang_Stmt_getSubtreeSize`
/ `clang_Stmt_collectSubtree` (`lib/AST/CXStmt.cpp`),
`clang_DeclContext_collectRecursiveDecls` (`lib/AST/CXDeclBase.cpp`).

**Why count+fill and not an opaque cursor.** A cursor (heap-boxed iterator with
`next`/`deref`/`atEnd`/`dispose`) is single-pass and allows early exit, but costs
n+1 boundary crossings instead of 2 and puts an iterator's lifetime *and
invalidation* across the boundary — mutating the AST or undoing a parse dangles it.
For AST ranges n is small and an in-process walk is far cheaper than an FFI
round-trip, so two calls plus one extra count walk wins, and the shim stays
stateless. The count walk is itself O(1) when the container caches its size
(`getNumBases`, `getNumParams`); it is only an O(n) walk for the truly
forward-only ranges. The one case a cursor would win — search with early exit — is
better served by a narrow predicate that runs the loop in C (§10), not by dragging
a lazy iterator across FFI. A Julia-side stride over a raw value array is *not* an
option: the caller can't know `sizeof(clang::TemplateArgument)` etc., which is
exactly how the old `get_template_args` mis-strided before it moved to the
count+index pair.

## 7. Value-type aggregates → expose the parts

`DeclarationNameInfo` (name + loc), `ExplicitSpecifier` (Expr* + kind), `Qualifiers`, `TypeInfo`
(width/align/req), `FPOptionsOverride`.

**Don't marshal the aggregate; expose its fields.** `DeclarationNameInfo` → a `getDeclName`
(the `DeclarationName` opaque encoding, pivot already exists) + the already-bound `getLoc`.
`Qualifiers` → `getAsOpaqueValue()` as `unsigned`. `TypeInfo` → out-params
(`uint64_t* width, unsigned* align, int* alignReq`). Only heap-box (with `dispose`) when the
aggregate must round-trip intact.

**In the tree.** `ExplicitSpecifier` → `clang_ExplicitSpecifier_getKind` / `getExpr`
(`lib/AST/CXDeclCXX.cpp`); `DeclarationNameInfo` → `clang_DeclarationNameInfo_getName`
(`lib/AST/CXDeclarationName.cpp`), plus the heap-boxed carrier for the
`CXXMethodDecl::Create` round-trip.

## 8. Discriminated unions (`PointerUnion`, `std::optional`)

`ClassTemplateSpecializationDecl::getSpecializedTemplateOrPartial` (union of two decl types);
`IfStmt::getNondiscardedCase` (`optional<Stmt*>`).

**Split the discriminator from the payload.** Return the pointer as `void*` plus a companion
`bool` predicate (`...specializedOnPartial`) so the Julia layer picks the right carrier. For
`optional<T*>`, use `nullptr` as the disengaged sentinel when `T*` is a pointer.

**Partly in the tree.** The union split —
`clang_ClassTemplateSpecializationDecl_getSpecializedTemplateOrPartial` +
`clang_ClassTemplateSpecializationDecl_specializedOnPartial`
(`lib/AST/CXDeclTemplate.cpp`); the arm pointer crosses untouched (no base-class
adjustment) so the Julia layer wraps it at the exact arm type the predicate
names. The collapsed convenience form
`clang_ClassTemplateSpecializationDecl_getSpecializedTemplate`
(`lib/AST/CXDeclTemplate.cpp`) also remains. For `optional<scalar>`, bool-return
+ out-param — `clang_TemplateArgument_getNumTemplateExpansions`
(`lib/AST/CXTemplateBase.cpp`); a blind `*opt` is UB on a disengaged optional
and aborts outright under mingw's assertion-enabled libstdc++. The
`nullptr`-sentinel form for `optional<T*>` —
`clang_IfStmt_getNondiscardedCase` (`lib/AST/CXStmt.cpp`); note the sentinel
deliberately conflates "disengaged" with "engaged holding null" (an absent
else branch), which the wrapper documents.

**`std::optional<scalar>` as an INPUT** has no nullptr sentinel to borrow, so it
flattens to a `(bool Has<Name>, T <Name>)` pair rebuilt in the shim as
`Has ? std::optional<T>(V) : std::nullopt`. `clang_TemplateTypeParmDecl_Create`'s
trailing `bool HasNumExpanded, unsigned NumExpanded` is the worked example; the
Julia side spells it `num_expanded::Union{Nothing,Integer}=nothing`.

## 9. Qualifier / navigation classes with their own surface (`NestedNameSpecifier`, `TypeLoc`, `ASTRecordLayout`)

**Opaque handle + a dedicated accessor family, interior pointer borrowed.** These are
context/AST-arena-owned, so no `dispose`. `NestedNameSpecifier*` → `CXNestedNameSpecifier`
(family already exists). `ASTRecordLayout` → `CXASTRecordLayout` + `getSize`/`getFieldOffset(i)`/
`getBaseClassOffset` accessors and an `AbstractASTRecordLayout` carrier. `TypeLoc` → at minimum
an opaque handle + source-range floor.

**In the tree.** `NestedNameSpecifier` → `clang_NestedNameSpecifier_getPrefix` + the
`CXNestedNameSpecifier` family (`lib/AST/CXNestedNameSpecifier.cpp`), borrowed;
`TypeLoc` → the `CXTypeLoc` floor from `clang_TypeSourceInfo_getTypeLoc`
(`lib/AST/CXTypeLoc.cpp`), *owned* with a `dispose` because a `TypeLoc` is a
by-value object; `ASTRecordLayout` → the borrowed entry point
`clang_ASTContext_getASTRecordLayout` (`lib/AST/CXASTContext.cpp`) and the
`clang_ASTRecordLayout_getSize` / `getFieldOffset` / `getBaseClassOffset`
accessor family (`lib/AST/CXRecordLayout.cpp`), including the CXXInfo-gated
tail (`clang_ASTRecordLayout_getNonVirtualSize` / `hasOwnVFPtr` / `hasVBPtr`
etc., `lib/AST/CXRecordLayout.cpp`) — CharUnits cross in bytes as `int64_t`,
`getFieldOffset` alone in bits, matching the C++ API.

## 10. C++ callbacks / visitors — don't cross the boundary

`CXXRecordDecl::forallBases`/`lookupInBases` take `std::function` and `CXXBasePaths&`.

**Provide narrow composite wrappers instead.** The common need is usually a specific query
(`isDerivedFrom(Base)` — a plain bool method); bind that and skip the generic callback form. If a
true visitor is unavoidable, expose it as an explicit count+fill of results, not a function
pointer across FFI.

**In the tree.** The "run the whole walk in C" form is the bulk extractors —
`clang_Stmt_collectSubtree` (`lib/AST/CXStmt.cpp`) and
`clang_DeclContext_collectRecursiveDecls` (`lib/AST/CXDeclBase.cpp`) do the entire
recursion on the C side and hand back flat buffers. The narrow-predicate form —
`clang_CXXRecordDecl_isDerivedFrom` / `clang_CXXRecordDecl_isVirtuallyDerivedFrom`
(`lib/AST/CXDeclCXX.cpp`) — runs the base walk in C instead of exposing
`forallBases`.

**When the container is computed, not owned: rebuild it per call.** This section
assumes both walks see the same storage because the range is a member. Some APIs
instead *compute* a container into a caller-provided out-parameter whose key
storage dies with the call — `ASTContext::getFunctionFeatureMap` fills an
`llvm::StringMap<bool>`. Neither a borrowed `StringRef` nor a stable index into
persistent storage exists, so each accessor rebuilds the map and copies names out
through `makeCXString` (§5). This is sound only because a `StringMap`'s iteration
order is a pure function of its insertion sequence, so index `I` names the same
entry on every rebuild; the shim stays stateless.
`clang_ASTContext_getNumFunctionFeatures` / `getFunctionFeature` demonstrate it.

**Out-parameter parallel component arrays.** Count+fill above assumes a range of
*pointers*. When the element is an aggregate with no pointer form and lives inside
a container that is destroyed with the call — `CXXRecordDecl::getFinalOverriders`
yields a nested map down to `UniqueVirtualMethod` values — flatten the whole walk
to rows and hand back one C array per component field, filled in lockstep against
a single count. This is §11's parallel-component-array shape on the output side.
Both calls re-run the same walk, so the ordering must be deterministic; say so in
the header.

**Box the value together with the storage it borrows.** Some by-value classes have
no pointer form *and* do not own what they point at, so heap-boxing the value alone
leaves a handle onto freed memory: `SrcMgr::LineOffsetMapping` holds `unsigned *`
out of a caller-supplied `BumpPtrAllocator`, and `SourceManagerForFile` keeps only
`StringRef`s of the file name and contents it was constructed from. The scheme is a
file-local `struct <Thing>Box` in an anonymous namespace whose members are the
borrowed storage **first** and the C++ value **last**, so declaration order makes
the storage outlive the value; `CX<Thing>` is a handle to the box and `_dispose`
deletes it. This is the same boxing mechanism as §13's "synthesize the gate inside
the box" — a different missing thing (storage rather than a flag). The payoff is
that the Julia caller does not have to keep its own string alive: the box owns a
copy. `clang_LineOffsetMapping_create` and `clang_SourceManagerForFile_create`
(`lib/Basic/CXSourceManager.cpp`) demonstrate it.

**`NestedNameSpecifierLoc` is a member of this section**, not §7. An earlier round
crossed it as its source range alone, which is the cheap path and is still bound
(`clang_DeclRefExpr_getQualifierRange` and friends), but a `(specifier, range)` pair
cannot express `getTypeLoc`. The heap-boxed `CXNestedNameSpecifierLoc` family from
`clang_*_getQualifierLoc` (`lib/AST/CXNestedNameSpecifier.cpp`) is the full form,
owned and disposed because it is a by-value object.

## 11. Builders taking `ArrayRef` / non-trivial value inputs (`ASTContext::getFunctionType`, `getConstantArrayType`, `getTemplateSpecializationType`)

**`(ptr, count)` arrays rebuilt with `llvm::ArrayRef`, non-trivial scalars flattened.**
`getFunctionType` → `(const CXQualType* args, unsigned n)` + a flattened `ExtProtoInfo`
(bool variadic, int callingConv, int refQualifier). `getConstantArrayType` → build the `APInt`
from a `uint64_t` size inside the shim. `getTemplateSpecializationType` → a `CXTemplateArgument*`
array of heap-boxed encodings. These are AST-construction APIs — lower priority than read paths.

**Partly in the tree.** The array-input half is instanced by
`clang_TemplateArgumentList_CreateCopy` (`lib/AST/CXDeclTemplate.cpp`), which rebuilds
an `ArrayRef` from a `(handle-buffer, count)` pair (note it dereferences each handle —
the buffer is handles, not a contiguous value array), and by
`clang_ASTContext_getFunctionType` (`lib/AST/CXASTContext.cpp`), whose
`CXQualType` buffer decodes through `getFromOpaquePtr` and whose `ExtProtoInfo`
is flattened to the FFI-relevant subset (variadic + calling convention).
`clang_ASTContext_getConstantArrayType` (`lib/AST/CXASTContext.cpp`) builds the
`APInt` from a `uint64_t` at the target's `size_t` width, and
`clang_ASTContext_getTemplateSpecializationType` (`lib/AST/CXASTContext.cpp`)
rebuilds its argument `ArrayRef` from a `(handle-buffer, count)` pair of
heap-boxed `CXTemplateArgument` encodings.

**Handle buffers of *nested* value types, and `[First, Last)` iterator pairs.** The
same shape extends to a parameter clang spells as two pointers rather than an
`ArrayRef`, and to element types nested inside a class:
`clang_DesignatedInitExpr_ExpandDesignator` takes `(const CXDesignator *, unsigned)`
and copies `*static_cast<Designator *>(Ds[I])` into a local `SmallVector` so the
pair clang wants points at a contiguous *value* array, not at the handles. Say in
the header when the call invalidates handles the caller already holds — that one
reallocates the designator array unless the replacement length is exactly 1, so
every `CXDesignator` previously obtained from the node dangles afterwards.

**Array inputs whose element type has no pointer form at all** — `Comment::Argument`,
`HTMLStartTagComment::Attribute` — cross as **parallel component arrays**: §7 applied
per element, then this section applied to the result. One C array per component
field, all read in lockstep against a single count, each element placement-new'd
into an `ASTContext::Allocate`d buffer. Copy every `StringRef` payload into that
same arena: the C++ setters store the `ArrayRef` and the `StringRef`s rather than
copying them, so a buffer owned by the caller would dangle.
`clang_HTMLStartTagComment_setAttrs` (five component arrays) and
`clang_BlockCommandComment_setArgs` (two) are the worked examples; add the readers
for every component in the same pass, or the setter cannot be round-trip tested.

**When the iterator type itself cannot be constructed.** `UnresolvedSetIterator`
has only private `DeclAccessPair *` constructors, friended to the AST classes, so
the shim cannot build the `[First, Last)` pair directly. Take the parallel
component arrays as usual, replay them into a stack-local `UnresolvedSet<8>`, and
pass `Set.begin()` / `Set.end()`. Nothing dangles: clang copies the
`DeclAccessPair`s into the node's trailing storage. The file-local
`fillUnresolvedSet` helper in `lib/AST/CXExprCXX.cpp` is shared by the
`UnresolvedLookupExpr` / `UnresolvedMemberExpr` factories.

## 12. Refcount-adopting parameters (`IntrusiveRefCntPtr` sinks)

Some Clang entry points take an `IntrusiveRefCntPtr<T>` (e.g.
`CreateInvocationOptions::Diags`), but the shim's handles are caller-owned raw
pointers whose `_dispose` is an unconditional `delete` — refcounts are never part
of the C surface.

**Pin with `Retain()` before wrapping.** Wrapping the raw pointer in a temporary
`IntrusiveRefCntPtr` bumps the count 0→1 and the temporary's destructor takes it
back to 0 — deleting an object the caller still owns. One explicit `Retain()`
before constructing the temporary makes the count end at 1 instead: the borrowed
object survives, the caller's `_dispose` still frees it (plain `delete` ignores
the count), and no second boxing scheme appears. Never hand the C API's raw
handle to a refcount-taking parameter without the pin, and never add a
dispose-via-`Release` variant next to the `delete`-based one.

**In the tree.** `clang_CompilerInvocation_createFromCommandLine`
(`lib/Frontend/CXCompilerInvocation.cpp`) pins the borrowed `DiagnosticsEngine`
before `clang::createInvocation` runs the driver.

## 13. Uninitialized-state preconditions → export the gate, don't just document it

Some Clang methods read members that carry **no default initializer** and are
populated only on a configuration path the caller may not have taken. They are
not fallible and not partial in the `castAs<>` sense — they are plain UB, and the
symptom is platform-dependent: a garbage enum on one host, a clean zero on
another, a segfault on a third.

Four found so far, each caught by a test run rather than by the compiler:

| method | reads | populated only when | symptom |
| --- | --- | --- | --- |
| `Driver::getLTOMode(true)` | `OffloadLTOMode` only | `BuildCompilation` has run `setLTOMode` | enum outside its own range |
| `Preprocessor::PoisonSEHIdentifiers` | nine SEH `IdentifierInfo *` members | `-fborland-extensions` (`LangOpts.Borland`) | segfault |
| `CXXRecordDecl::nullFieldOffsetIsZero` | the `MSInheritanceAttr` inheritance model | the target uses the Microsoft C++ ABI | segfault |
| `ASTUnit::getPreprocessor` | `*PP`, an empty `std::shared_ptr` | a parse has installed a preprocessor | SIGABRT — **Windows only** |
| `Sema::BuildPredefinedExpr` | `getCurFunctionDecl()` | the call is inside a function body | segfault in `DiagnosticRenderer` |

**A Sema entry point that DIAGNOSES on bad input is as dangerous as one that
reads uninitialised memory.** `BuildPredefinedExpr` outside a function body does
not misbehave itself — it correctly emits an extension diagnostic, and rendering
*that* segfaults in `DiagnosticRenderer::emitDiagnostic`. The wrapper's docstring
already said "outside a function body there is none, so clang emits an extension
diagnostic", which reads as harmless colour; it is the crash. When a Sema method
documents a diagnostic for an input, gate the input out — `getCurFunctionDecl`
was already wrapped, so the assert cost one line. This is the same lesson as the
"in the X ABI" rule below: prose describing what clang does on bad input is a
precondition, not context.

**A `*shared_ptr` deref is a Windows-only abort.** The fourth is worth its own
rule: the Windows build links a libstdc++ compiled with `_GLIBCXX_ASSERTIONS`,
so dereferencing an empty `std::shared_ptr` calls `__glibcxx_assert_fail` and
aborts the process. macOS (libc++) and the Linux build return garbage and sail
on, so a local run and two of the three CI platforms all pass. Any clang
accessor whose body is `return *SomeSharedPtr;` is therefore a hard crash
waiting for a Windows runner. The fix is not a docstring: reach the member
through its `...Ptr()` accessor and return the raw pointer, which makes the
wrapper total, and export a `has*` predicate beside it
(`clang_ASTUnit_hasPreprocessor`). LLVM's own `IntrusiveRefCntPtr::operator*`
carries no such assertion, so `&X->getASTContext()` stays safe — the rule is
specific to the standard library's smart pointers.

The rest of the shim was audited against this rule: of the clang accessors whose
body is `return *SmartPtr;`, fourteen share a name with a libclangex binding, and
all but `ASTUnit::getPreprocessor` are safe because the member is populated by
construction — `CompilerInvocationBase()` allocates every option pointer and each
`EmptyConstructor` path immediately assigns them, while `Preprocessor`'s `PPOpts`
and `BuiltinInfo` and `HeaderSearch`'s `HSOpts` come from constructor arguments.
The one shape to re-check when adding to that family is a *moved-from* object,
whose pointers are empty again.

The third is the cheapest kind to fix and the easiest to miss: the gate
(`ASTContext::getCXXABIKind`) was already wrapped, so the assert cost one line —
but the method's own doc comment says only "In the Microsoft C++ ABI, ...",
which reads as context rather than as a precondition. Treat "in the X ABI" /
"for X targets" in a doc comment as a precondition until proven otherwise.

**Prefer exporting the gate over writing a warning.** Invariant 3 says restate the
precondition in the Julia wrapper as an `@assert` — but that only works if the
condition is *observable* through the C API. When it is not, the fix is usually a
one-line accessor for the flag that gates it, added alongside the risky wrapper:
`clang_LangOptions_getBorland` exists purely so `PoisonSEHIdentifiers` can assert
rather than crash. A wrapper that can reject the bad call is strictly better than
one whose docstring asks the caller not to make it.

**Third option: export the operation that establishes the state.** Sometimes the
member is not gated by a flag at all — it is simply written by a method the caller
was supposed to have run first. `Driver::getLTOMode` was this file's document-only
example precisely because a `Driver` exposes no "arguments processed" flag; what it
does expose is `BuildCompilation`, the call that writes `LTOMode`, `SaveTemps`,
`BitcodeEmbed` and `CXX20HeaderType`.

Be precise about which member: only the *offload* one is uninitialized. `Driver`'s sole
constructor mem-init list contains `LTOMode(LTOK_None)` but nothing for `OffloadLTOMode`, which
`setLTOMode` alone writes (`clang/lib/Driver/Driver.cpp:718`, tag julia-18.1.7-4-3-gadfa481dde2a).
So `getLTOMode()` on a fresh `Driver` reads a defined `LTOK_None`; it is `getLTOMode(true)` that
reads uninitialized memory. Checking which members a constructor actually initialises is the
whole of this determination — the class having an "unset" phase is not enough. Wrapping *that* (`clang_Driver_BuildCompilation`,
returning the owned `CXCompilation`) turns the whole family from UB reads into defined
ones, and the ordering requirement moves into the docstring and the test rather than
into an assert the wrapper cannot make. Prefer this to document-only whenever the
establishing operation is itself wrappable.

**When the gate is unreachable, synthesize one in the box.** A value type that
already has to be heap-boxed can carry the missing state alongside the value.
`clang::Expr::Classification` keeps "was modifiability tested" in a private
member only `clang::Expr` may read, and `getModifiable()` asserts on it — there
is no accessor to export. `clang_Expr_Classify` and
`clang_Expr_ClassifyModifiable` therefore box the value together with a `Tested`
flag set by whichever entry point produced it, and
`clang_Classification_isModifiableTested` publishes it, so the Julia wrapper can
`@assert` instead of tripping clang's assert. This costs nothing extra: the box
existed anyway because the class has no pointer form. Prefer it to
document-only whenever the type is already boxed.

Only fall back to a documented-precondition-with-no-assert when the state has no
observable proxy AND nothing is being boxed to hang one on — `Driver` exposes no
"arguments processed" flag and is not boxed, so `getLTOMode` documents and
cannot check. Say so explicitly in the docstring when that happens, so the gap
is a known one rather than an oversight.

**How to spot one while wrapping:** read the member declarations, not just the
method. A member with no `= init` in the class body, assigned only inside an
`if (LangOpts.X)` or a setter called from one entry point, is the signature. The
compiler will not warn, and a single-platform test run will often pass.

### The gate itself must be total over the accepted operands

A gate written as one `@assert` over a disjunction of shapes is only sound if
every *accessor it calls* is defined for every operand the disjunction accepts.
Julia evaluates the accessor eagerly if it is hoisted into a local, and even
inline the arms have to be ordered so that the narrowing test runs first.

`EvaluateStaticAssertMessageAsString` accepts a string literal *or* a class
object, and its gate opened by reading `getTypePtr(getType(message))` to test
the class-type arm. But the parser builds a `static_assert` message as an
**unevaluated** string literal, and an unevaluated string literal carries a null
`QualType` — so the gate tripped clang's `Cannot retrieve a NULL type pointer`
assertion on the one operand that is always valid. The wrapper aborted on
exactly the input it existed to accept, and no C++-side or lint check can see
it: the shim matched clang's signature exactly.

    ty = getType(message)
    @assert (resolve(message) isa StringLiteral ||
             (!isNull(ty) && isRecordType(getTypePtr(ty)))) "..."

**How to spot one while wrapping:** for each arm of a gate's disjunction, ask
which accessors run *before* that arm short-circuits, and whether each is total
for the operands the other arms admit. `QualType`-returning accessors are the
usual offender, because a null `QualType` asserts rather than returning null.
A gate is exercised by every valid call, so a defect here fails 100% of the
time — which is also why it survives only until the first test that calls the
wrapper at all.

---

## 14. Borrows the boundary cannot observe → copy, don't caveat

MARSHALLING.md §9 boxes a value together with the storage it borrows, which works when the
storage is something the boundary can hold. When the owner is **private** and the borrow has
no observable identity, there is nothing to box and nothing to check — and a documented
caveat is then the weakest possible answer, because the Julia layer is supposed to be where
that safety gets re-established.

`clang::HeaderSearch::getFileInfo` returns a reference into a private
`std::vector<HeaderFileInfo>`; a later `getFileInfo` reallocates it and `ClearFileInfo`
empties it. The shim cannot read the vector's data pointer or size to detect the move, so no
generation counter is possible. The fix is to stop borrowing: `clang_HeaderSearch_copyFileInfo`
copies the record into caller-owned storage released by `clang_HeaderFileInfo_dispose`, and
the borrowing entry points are **deleted** rather than left alongside it.

Two things make this sound rather than merely safer. The record's pointer members survive,
because reallocation moves the records and not what they point at — `ControllingMacro`
belongs to the identifier table, `Framework` to the search's string allocator. And every
accessor over the record is a pure getter, so a snapshot loses nothing a caller could have
written back. Check both before copying: a snapshot of a type with setters silently drops
writes, and a copy whose members point into the moved storage fixes nothing.

**In the tree.** `clang_HeaderSearch_copyFileInfo`, `clang_HeaderSearch_copyExistingFileInfo`,
`clang_HeaderFileInfo_dispose` (`lib/Lex/CXHeaderSearch.cpp`).

---

New value-type or range shapes not covered here should extend this file rather than inventing an
ad-hoc scheme, so the Julia side sees one consistent set of idioms.
