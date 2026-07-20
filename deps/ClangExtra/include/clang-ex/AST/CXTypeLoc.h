#ifndef LLVM_CLANG_C_EXTRA_CXTYPELOC_H
#define LLVM_CLANG_C_EXTRA_CXTYPELOC_H

#include "clang-ex/CXTypes.h"
#include "clang-ex/AST/CXType.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// TypeLoc pairs a Type with the source locations where it was written (the floor
// for source-rewriting tools). It is a small by-value object (Type* + opaque
// Data*); crossing the boundary it is heap-boxed, so every CXTypeLoc from
// getTypeLoc / getNextTypeLoc is OWNED and must be released with
// clang_TypeLoc_dispose.
CXTypeLoc clang_TypeSourceInfo_getTypeLoc(CXTypeSourceInfo TSI);

CXQualType clang_TypeLoc_getType(CXTypeLoc TL);

CXSourceLocation_ clang_TypeLoc_getBeginLoc(CXTypeLoc TL);

CXSourceLocation_ clang_TypeLoc_getEndLoc(CXTypeLoc TL);

CXSourceRange_ clang_TypeLoc_getSourceRange(CXTypeLoc TL);

CXSourceRange_ clang_TypeLoc_getLocalSourceRange(CXTypeLoc TL);

// The next TypeLoc in the chain (e.g. a pointer loc's pointee loc); OWNED,
// dispose it. Null (isNull) at the end of the chain.
CXTypeLoc clang_TypeLoc_getNextTypeLoc(CXTypeLoc TL);

bool clang_TypeLoc_isNull(CXTypeLoc TL);

void clang_TypeLoc_dispose(CXTypeLoc TL);
// The TypeLoc classification surface below is stamped from the vendored
// clang-ex/AST/TypeNodes.inc, the way clang builds TypeLoc::TypeLocClass from
// Type::TypeClass: one enumerator per concrete Type class holding the matching
// CXTypeClass value, plus a trailing Qualified for QualifiedTypeLoc (which has
// no Type counterpart). The static_assert table in CXTypeLoc.cpp proves
// value-for-value equality against clang::TypeLoc::TypeLocClass, so a stale
// vendored copy fails the build. POLICY: stamped symbols (CXTypeLocClass_* and
// the castTo family) are version-following per LLVM major, exempt from the
// frozen-ABI rule.
typedef enum CXTypeLocClass {
#define TYPE(Class, Base) CXTypeLocClass_##Class = CXTypeClass_##Class,
#define ABSTRACT_TYPE(Class, Base)
#include "clang-ex/AST/TypeNodes.inc"
  CXTypeLocClass_Qualified
} CXTypeLocClass;

// Qualified when the type carries local qualifiers, otherwise the Type class.
// TL must not be a null TypeLoc.
CXTypeLocClass clang_TypeLoc_getTypeLocClass(CXTypeLoc TL);

// Skips past any qualifiers; the result is a NEW heap box, release it with
// clang_TypeLoc_dispose.
CXTypeLoc clang_TypeLoc_getUnqualifiedLoc(CXTypeLoc TL);

// Skips past a ParenTypeLoc, if any; the result is a NEW heap box, release it
// with clang_TypeLoc_dispose.
CXTypeLoc clang_TypeLoc_IgnoreParens(CXTypeLoc TL);

// Per-class payload accessors. Each receiver must already be established as
// the named TypeLoc class (the impl re-views the box with castAs); the
// class-checked castTo family below is what establishes it. TypeLoc results
// are NEW heap boxes, release each with clang_TypeLoc_dispose.

// QualifiedTypeLoc
CXTypeLoc clang_QualifiedTypeLoc_getUnqualifiedLoc(CXTypeLoc TL);

// TypeSpecTypeLoc
CXSourceLocation_ clang_TypeSpecTypeLoc_getNameLoc(CXTypeLoc TL);

// BuiltinTypeLoc
CXSourceLocation_ clang_BuiltinTypeLoc_getBuiltinLoc(CXTypeLoc TL);

// AttributedTypeLoc
CXTypeLoc clang_AttributedTypeLoc_getModifiedLoc(CXTypeLoc TL);
CXAttr clang_AttributedTypeLoc_getAttr(CXTypeLoc TL);

// ParenTypeLoc
CXSourceLocation_ clang_ParenTypeLoc_getLParenLoc(CXTypeLoc TL);
CXSourceLocation_ clang_ParenTypeLoc_getRParenLoc(CXTypeLoc TL);

// AdjustedTypeLoc (DecayedTypeLoc inherits this accessor)
CXTypeLoc clang_AdjustedTypeLoc_getOriginalLoc(CXTypeLoc TL);

// PointerTypeLoc
CXSourceLocation_ clang_PointerTypeLoc_getStarLoc(CXTypeLoc TL);

// MemberPointerTypeLoc
CXSourceLocation_ clang_MemberPointerTypeLoc_getStarLoc(CXTypeLoc TL);

// LValueReferenceTypeLoc
CXSourceLocation_ clang_LValueReferenceTypeLoc_getAmpLoc(CXTypeLoc TL);

// RValueReferenceTypeLoc
CXSourceLocation_ clang_RValueReferenceTypeLoc_getAmpAmpLoc(CXTypeLoc TL);

// FunctionTypeLoc (FunctionProto/FunctionNoProto share these)
CXSourceLocation_ clang_FunctionTypeLoc_getLocalRangeBegin(CXTypeLoc TL);
CXSourceLocation_ clang_FunctionTypeLoc_getLocalRangeEnd(CXTypeLoc TL);
CXSourceLocation_ clang_FunctionTypeLoc_getLParenLoc(CXTypeLoc TL);
CXSourceLocation_ clang_FunctionTypeLoc_getRParenLoc(CXTypeLoc TL);
unsigned clang_FunctionTypeLoc_getNumParams(CXTypeLoc TL);
CXParmVarDecl clang_FunctionTypeLoc_getParam(CXTypeLoc TL, unsigned i);

// ArrayTypeLoc (Constant/Incomplete/Variable/DependentSizedArray share these)
CXSourceLocation_ clang_ArrayTypeLoc_getLBracketLoc(CXTypeLoc TL);
CXSourceLocation_ clang_ArrayTypeLoc_getRBracketLoc(CXTypeLoc TL);
CXExpr clang_ArrayTypeLoc_getSizeExpr(CXTypeLoc TL);

// TemplateSpecializationTypeLoc
CXSourceLocation_ clang_TemplateSpecializationTypeLoc_getTemplateNameLoc(CXTypeLoc TL);
CXSourceLocation_ clang_TemplateSpecializationTypeLoc_getLAngleLoc(CXTypeLoc TL);
CXSourceLocation_ clang_TemplateSpecializationTypeLoc_getRAngleLoc(CXTypeLoc TL);
unsigned clang_TemplateSpecializationTypeLoc_getNumArgs(CXTypeLoc TL);

// ElaboratedTypeLoc
CXSourceLocation_ clang_ElaboratedTypeLoc_getElaboratedKeywordLoc(CXTypeLoc TL);

// TypeLoc Cast — TypeLoc casting is value-based (TypeLoc::getAs, not
// dyn_cast): nullptr when the TypeLoc is not of the requested class, otherwise
// a NEW heap box (release with clang_TypeLoc_dispose). One stamped cast per
// concrete Type class, plus hand-written casts for the TypeLoc-only classes
// with no concrete TypeNodes.inc counterpart: Qualified, and the
// payload-bearing intermediates TypeSpec/Function/Array.
#define TYPE(Class, Base) CXTypeLoc clang_TypeLoc_castTo##Class##TypeLoc(CXTypeLoc TL);
#define ABSTRACT_TYPE(Class, Base)
#include "clang-ex/AST/TypeNodes.inc"

CXTypeLoc clang_TypeLoc_castToQualifiedTypeLoc(CXTypeLoc TL);
CXTypeLoc clang_TypeLoc_castToTypeSpecTypeLoc(CXTypeLoc TL);
CXTypeLoc clang_TypeLoc_castToFunctionTypeLoc(CXTypeLoc TL);
CXTypeLoc clang_TypeLoc_castToArrayTypeLoc(CXTypeLoc TL);

LLVM_CLANG_C_EXTERN_C_END

#endif
