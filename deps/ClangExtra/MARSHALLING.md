# MARSHALLING.md — patterns for the hard-to-wrap Clang APIs

Most Clang methods marshal trivially (bool/int/enum, a `QualType` opaque pointer, an
AST-node pointer). This file is the playbook for the ones that don't — the value types,
iterator ranges, and out-of-band results that a naive `void *` accessor can't carry. Each
pattern respects the single-client axiom (see `CLAUDE.md`): the C shim stays type-erased and
total; the Julia thin wrapper re-imposes types and checks preconditions.

Pick the lightest pattern that fits. Prefer exposing components over marshalling an aggregate;
prefer a borrowed interior pointer over an owned copy; only heap-box when the value has no
pointer form and the caller genuinely needs it.

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
(`lib/AST/CXDeclCXX.cpp`). Count+fill — `clang_RecordDecl_getFields`,
`clang_EnumDecl_getEnumerators` (`lib/AST/CXDecl.cpp`). Bulk two-buffer (node
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
exactly how `get_template_args` mis-strided.

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

**Not yet in the tree.** No wrapper splits a `PointerUnion` this way today:
`clang_ClassTemplateSpecializationDecl_getSpecializedTemplate`
(`lib/AST/CXDeclTemplate.cpp`) *collapses* the union to its template arm rather than
returning the pointer + a `specializedOnPartial` predicate. The `nullptr`-sentinel
form for `optional<T*>` is likewise unimplemented. The paragraph above is the
intended shape.

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
by-value object. `ASTRecordLayout` is still a `// getASTRecordLayout` placeholder in
`CXASTContext.h` — the `CXASTRecordLayout` handle and its accessor family are
unimplemented.

## 10. C++ callbacks / visitors — don't cross the boundary

`CXXRecordDecl::forallBases`/`lookupInBases` take `std::function` and `CXXBasePaths&`.

**Provide narrow composite wrappers instead.** The common need is usually a specific query
(`isDerivedFrom(Base)` — a plain bool method); bind that and skip the generic callback form. If a
true visitor is unavoidable, expose it as an explicit count+fill of results, not a function
pointer across FFI.

**Partly in the tree.** The "run the whole walk in C" form is the bulk extractors —
`clang_Stmt_collectSubtree` (`lib/AST/CXStmt.cpp`) and
`clang_DeclContext_collectRecursiveDecls` (`lib/AST/CXDeclBase.cpp`) do the entire
recursion on the C side and hand back flat buffers. The narrow-predicate form
(`isDerivedFrom` instead of `forallBases`) is the recommendation but is not yet
bound.

## 11. Builders taking `ArrayRef` / non-trivial value inputs (`ASTContext::getFunctionType`, `getConstantArrayType`, `getTemplateSpecializationType`)

**`(ptr, count)` arrays rebuilt with `llvm::ArrayRef`, non-trivial scalars flattened.**
`getFunctionType` → `(const CXQualType* args, unsigned n)` + a flattened `ExtProtoInfo`
(bool variadic, int callingConv, int refQualifier). `getConstantArrayType` → build the `APInt`
from a `uint64_t` size inside the shim. `getTemplateSpecializationType` → a `CXTemplateArgument*`
array of heap-boxed encodings. These are AST-construction APIs — lower priority than read paths.

**Partly in the tree.** The array-input half is instanced by
`clang_TemplateArgumentList_CreateCopy` (`lib/AST/CXDeclTemplate.cpp`), which rebuilds
an `ArrayRef` from a `(handle-buffer, count)` pair (note it dereferences each handle —
the buffer is handles, not a contiguous value array). The `ExtProtoInfo`-flattening
builders — `getFunctionType`, `getConstantArrayType`, `getTemplateSpecializationType`
— remain `//` placeholders in `CXASTContext.h`; the sketch above is the intended
shape, not yet implemented.

---

New value-type or range shapes not covered here should extend this file rather than inventing an
ad-hoc scheme, so the Julia side sees one consistent set of idioms.
