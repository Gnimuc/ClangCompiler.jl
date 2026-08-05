#include "clang-ex/AST/CXTypeLoc.h"

#include "clang/AST/TypeLoc.h"
// Drift alarm: the vendored TypeNodes.inc must match the pinned LLVM version.
// One assert per concrete class proves CXTypeLocClass equals clang's
// TypeLoc::TypeLocClass value-for-value; the Qualified assert catches classes
// appended at the end.
#define TYPE(Class, Base)                                                                  \
  static_assert(static_cast<int>(CXTypeLocClass_##Class) ==                                \
                    static_cast<int>(clang::TypeLoc::Class),                                \
                "CXTypeLocClass drift: " #Class);
#define ABSTRACT_TYPE(Class, Base)
#include "clang-ex/AST/TypeNodes.inc"
static_assert(static_cast<int>(CXTypeLocClass_Qualified) ==
                  static_cast<int>(clang::TypeLoc::Qualified),
              "CXTypeLocClass drift: Qualified");

CXTypeLoc clang_TypeSourceInfo_getTypeLoc(CXTypeSourceInfo TSI) {
  return reinterpret_cast<CXTypeLoc>(new clang::TypeLoc( // NOLINT(*-owning-memory)
      reinterpret_cast<clang::TypeSourceInfo *>(TSI)->getTypeLoc()));
}

CXQualType clang_TypeLoc_getType(CXTypeLoc TL) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::TypeLoc *>(TL)->getType().getAsOpaquePtr());
}

CXSourceLocation_ clang_TypeLoc_getBeginLoc(CXTypeLoc TL) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::TypeLoc *>(TL)->getBeginLoc().getPtrEncoding());
}

CXSourceLocation_ clang_TypeLoc_getEndLoc(CXTypeLoc TL) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::TypeLoc *>(TL)->getEndLoc().getPtrEncoding());
}

CXSourceRange_ clang_TypeLoc_getSourceRange(CXTypeLoc TL) {
  clang::SourceRange R = reinterpret_cast<clang::TypeLoc *>(TL)->getSourceRange();
  return CXSourceRange_{reinterpret_cast<CXSourceLocation_>(R.getBegin().getPtrEncoding()), reinterpret_cast<CXSourceLocation_>(R.getEnd().getPtrEncoding())};
}

CXSourceRange_ clang_TypeLoc_getLocalSourceRange(CXTypeLoc TL) {
  clang::SourceRange R = reinterpret_cast<clang::TypeLoc *>(TL)->getLocalSourceRange();
  return CXSourceRange_{reinterpret_cast<CXSourceLocation_>(R.getBegin().getPtrEncoding()), reinterpret_cast<CXSourceLocation_>(R.getEnd().getPtrEncoding())};
}

CXTypeLoc clang_TypeLoc_getNextTypeLoc(CXTypeLoc TL) {
  return reinterpret_cast<CXTypeLoc>(new clang::TypeLoc( // NOLINT(*-owning-memory)
      reinterpret_cast<clang::TypeLoc *>(TL)->getNextTypeLoc()));
}

bool clang_TypeLoc_isNull(CXTypeLoc TL) {
  return reinterpret_cast<clang::TypeLoc *>(TL)->isNull();
}

void clang_TypeLoc_dispose(CXTypeLoc TL) {
  delete reinterpret_cast<clang::TypeLoc *>(TL); // NOLINT(*-owning-memory)
}

CXTypeLocClass clang_TypeLoc_getTypeLocClass(CXTypeLoc TL) {
  return static_cast<CXTypeLocClass>(
      reinterpret_cast<clang::TypeLoc *>(TL)->getTypeLocClass());
}

CXTypeLoc clang_TypeLoc_getUnqualifiedLoc(CXTypeLoc TL) {
  return reinterpret_cast<CXTypeLoc>(new clang::TypeLoc( // NOLINT(*-owning-memory)
      reinterpret_cast<clang::TypeLoc *>(TL)->getUnqualifiedLoc()));
}

CXTypeLoc clang_TypeLoc_IgnoreParens(CXTypeLoc TL) {
  return reinterpret_cast<CXTypeLoc>(new clang::TypeLoc( // NOLINT(*-owning-memory)
      reinterpret_cast<clang::TypeLoc *>(TL)->IgnoreParens()));
}

// QualifiedTypeLoc
CXTypeLoc clang_QualifiedTypeLoc_getUnqualifiedLoc(CXTypeLoc TL) {
  clang::QualifiedTypeLoc L =
      reinterpret_cast<clang::TypeLoc *>(TL)->castAs<clang::QualifiedTypeLoc>();
  return reinterpret_cast<CXTypeLoc>(new clang::TypeLoc(L.getUnqualifiedLoc())); // NOLINT(*-owning-memory)
}

// TypeSpecTypeLoc
CXSourceLocation_ clang_TypeSpecTypeLoc_getNameLoc(CXTypeLoc TL) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::TypeLoc *>(TL)
      ->castAs<clang::TypeSpecTypeLoc>()
      .getNameLoc()
      .getPtrEncoding());
}

// BuiltinTypeLoc
CXSourceLocation_ clang_BuiltinTypeLoc_getBuiltinLoc(CXTypeLoc TL) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::TypeLoc *>(TL)
      ->castAs<clang::BuiltinTypeLoc>()
      .getBuiltinLoc()
      .getPtrEncoding());
}

// AttributedTypeLoc
CXTypeLoc clang_AttributedTypeLoc_getModifiedLoc(CXTypeLoc TL) {
  clang::AttributedTypeLoc L =
      reinterpret_cast<clang::TypeLoc *>(TL)->castAs<clang::AttributedTypeLoc>();
  return reinterpret_cast<CXTypeLoc>(new clang::TypeLoc(L.getModifiedLoc())); // NOLINT(*-owning-memory)
}

CXAttr clang_AttributedTypeLoc_getAttr(CXTypeLoc TL) {
  return reinterpret_cast<CXAttr>(const_cast<clang::Attr *>(
      reinterpret_cast<clang::TypeLoc *>(TL)->castAs<clang::AttributedTypeLoc>().getAttr()));
}

// ParenTypeLoc
CXSourceLocation_ clang_ParenTypeLoc_getLParenLoc(CXTypeLoc TL) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::TypeLoc *>(TL)
      ->castAs<clang::ParenTypeLoc>()
      .getLParenLoc()
      .getPtrEncoding());
}

CXSourceLocation_ clang_ParenTypeLoc_getRParenLoc(CXTypeLoc TL) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::TypeLoc *>(TL)
      ->castAs<clang::ParenTypeLoc>()
      .getRParenLoc()
      .getPtrEncoding());
}

// AdjustedTypeLoc
CXTypeLoc clang_AdjustedTypeLoc_getOriginalLoc(CXTypeLoc TL) {
  clang::AdjustedTypeLoc L =
      reinterpret_cast<clang::TypeLoc *>(TL)->castAs<clang::AdjustedTypeLoc>();
  return reinterpret_cast<CXTypeLoc>(new clang::TypeLoc(L.getOriginalLoc())); // NOLINT(*-owning-memory)
}

// PointerTypeLoc
CXSourceLocation_ clang_PointerTypeLoc_getStarLoc(CXTypeLoc TL) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::TypeLoc *>(TL)
      ->castAs<clang::PointerTypeLoc>()
      .getStarLoc()
      .getPtrEncoding());
}

// MemberPointerTypeLoc
CXSourceLocation_ clang_MemberPointerTypeLoc_getStarLoc(CXTypeLoc TL) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::TypeLoc *>(TL)
      ->castAs<clang::MemberPointerTypeLoc>()
      .getStarLoc()
      .getPtrEncoding());
}

// LValueReferenceTypeLoc
CXSourceLocation_ clang_LValueReferenceTypeLoc_getAmpLoc(CXTypeLoc TL) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::TypeLoc *>(TL)
      ->castAs<clang::LValueReferenceTypeLoc>()
      .getAmpLoc()
      .getPtrEncoding());
}

// RValueReferenceTypeLoc
CXSourceLocation_ clang_RValueReferenceTypeLoc_getAmpAmpLoc(CXTypeLoc TL) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::TypeLoc *>(TL)
      ->castAs<clang::RValueReferenceTypeLoc>()
      .getAmpAmpLoc()
      .getPtrEncoding());
}

// FunctionTypeLoc
CXSourceLocation_ clang_FunctionTypeLoc_getLocalRangeBegin(CXTypeLoc TL) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::TypeLoc *>(TL)
      ->castAs<clang::FunctionTypeLoc>()
      .getLocalRangeBegin()
      .getPtrEncoding());
}

CXSourceLocation_ clang_FunctionTypeLoc_getLocalRangeEnd(CXTypeLoc TL) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::TypeLoc *>(TL)
      ->castAs<clang::FunctionTypeLoc>()
      .getLocalRangeEnd()
      .getPtrEncoding());
}

CXSourceLocation_ clang_FunctionTypeLoc_getLParenLoc(CXTypeLoc TL) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::TypeLoc *>(TL)
      ->castAs<clang::FunctionTypeLoc>()
      .getLParenLoc()
      .getPtrEncoding());
}

CXSourceLocation_ clang_FunctionTypeLoc_getRParenLoc(CXTypeLoc TL) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::TypeLoc *>(TL)
      ->castAs<clang::FunctionTypeLoc>()
      .getRParenLoc()
      .getPtrEncoding());
}

unsigned clang_FunctionTypeLoc_getNumParams(CXTypeLoc TL) {
  return reinterpret_cast<clang::TypeLoc *>(TL)->castAs<clang::FunctionTypeLoc>().getNumParams();
}

CXParmVarDecl clang_FunctionTypeLoc_getParam(CXTypeLoc TL, unsigned i) {
  return reinterpret_cast<CXParmVarDecl>(reinterpret_cast<clang::TypeLoc *>(TL)->castAs<clang::FunctionTypeLoc>().getParam(i));
}

// ArrayTypeLoc
CXSourceLocation_ clang_ArrayTypeLoc_getLBracketLoc(CXTypeLoc TL) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::TypeLoc *>(TL)
      ->castAs<clang::ArrayTypeLoc>()
      .getLBracketLoc()
      .getPtrEncoding());
}

CXSourceLocation_ clang_ArrayTypeLoc_getRBracketLoc(CXTypeLoc TL) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::TypeLoc *>(TL)
      ->castAs<clang::ArrayTypeLoc>()
      .getRBracketLoc()
      .getPtrEncoding());
}

CXExpr clang_ArrayTypeLoc_getSizeExpr(CXTypeLoc TL) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::TypeLoc *>(TL)->castAs<clang::ArrayTypeLoc>().getSizeExpr());
}

// TemplateSpecializationTypeLoc
CXSourceLocation_ clang_TemplateSpecializationTypeLoc_getTemplateNameLoc(CXTypeLoc TL) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::TypeLoc *>(TL)
      ->castAs<clang::TemplateSpecializationTypeLoc>()
      .getTemplateNameLoc()
      .getPtrEncoding());
}

CXSourceLocation_ clang_TemplateSpecializationTypeLoc_getLAngleLoc(CXTypeLoc TL) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::TypeLoc *>(TL)
      ->castAs<clang::TemplateSpecializationTypeLoc>()
      .getLAngleLoc()
      .getPtrEncoding());
}

CXSourceLocation_ clang_TemplateSpecializationTypeLoc_getRAngleLoc(CXTypeLoc TL) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::TypeLoc *>(TL)
      ->castAs<clang::TemplateSpecializationTypeLoc>()
      .getRAngleLoc()
      .getPtrEncoding());
}

unsigned clang_TemplateSpecializationTypeLoc_getNumArgs(CXTypeLoc TL) {
  return reinterpret_cast<clang::TypeLoc *>(TL)
      ->castAs<clang::TemplateSpecializationTypeLoc>()
      .getNumArgs();
}

// ElaboratedTypeLoc
CXSourceLocation_ clang_ElaboratedTypeLoc_getElaboratedKeywordLoc(CXTypeLoc TL) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::TypeLoc *>(TL)
      ->castAs<clang::ElaboratedTypeLoc>()
      .getElaboratedKeywordLoc()
      .getPtrEncoding());
}

// TypeLoc Cast — value-based getAs re-boxed on the heap; nullptr on a class
// mismatch. TL must not be a null TypeLoc (isKind reads the type pointer);
// the Julia layer asserts this before calling.
#define TYPE(Class, Base)                                                                  \
  CX##Class##TypeLoc clang_TypeLoc_castTo##Class##TypeLoc(CXTypeLoc TL) {                  \
    clang::Class##TypeLoc L =                                                              \
        reinterpret_cast<clang::TypeLoc *>(TL)->getAs<clang::Class##TypeLoc>();            \
    if (L.isNull())                                                                        \
      return nullptr;                                                                      \
    /* NOLINTNEXTLINE(*-owning-memory) */                                                  \
    return reinterpret_cast<CX##Class##TypeLoc>(new clang::TypeLoc(L));                    \
  }
#define ABSTRACT_TYPE(Class, Base)
#include "clang-ex/AST/TypeNodes.inc"

CXQualifiedTypeLoc clang_TypeLoc_castToQualifiedTypeLoc(CXTypeLoc TL) {
  clang::QualifiedTypeLoc L =
      reinterpret_cast<clang::TypeLoc *>(TL)->getAs<clang::QualifiedTypeLoc>();
  if (L.isNull())
    return nullptr;
  return reinterpret_cast<CXQualifiedTypeLoc>(new clang::TypeLoc(L)); // NOLINT(*-owning-memory)
}

CXTypeSpecTypeLoc clang_TypeLoc_castToTypeSpecTypeLoc(CXTypeLoc TL) {
  clang::TypeSpecTypeLoc L =
      reinterpret_cast<clang::TypeLoc *>(TL)->getAs<clang::TypeSpecTypeLoc>();
  if (L.isNull())
    return nullptr;
  return reinterpret_cast<CXTypeSpecTypeLoc>(new clang::TypeLoc(L)); // NOLINT(*-owning-memory)
}

CXFunctionTypeLoc clang_TypeLoc_castToFunctionTypeLoc(CXTypeLoc TL) {
  clang::FunctionTypeLoc L =
      reinterpret_cast<clang::TypeLoc *>(TL)->getAs<clang::FunctionTypeLoc>();
  if (L.isNull())
    return nullptr;
  return reinterpret_cast<CXFunctionTypeLoc>(new clang::TypeLoc(L)); // NOLINT(*-owning-memory)
}

CXArrayTypeLoc clang_TypeLoc_castToArrayTypeLoc(CXTypeLoc TL) {
  clang::ArrayTypeLoc L =
      reinterpret_cast<clang::TypeLoc *>(TL)->getAs<clang::ArrayTypeLoc>();
  if (L.isNull())
    return nullptr;
  return reinterpret_cast<CXArrayTypeLoc>(new clang::TypeLoc(L)); // NOLINT(*-owning-memory)
}
