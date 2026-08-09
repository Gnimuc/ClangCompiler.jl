#include "clang-ex/AST/CXAttr.h"
#include "utils.h"

#include "clang/AST/ASTContext.h"

#include "clang/AST/Attr.h"
#include "clang/Basic/AttrKinds.h"

// Drift alarm: the vendored AttrList.inc must match the pinned LLVM version. One
// assert per attribute proves CXAttrKind equals clang's attr::Kind value-for-
// value. (clang exposes no attr count sentinel, so an attribute appended at the
// very end is only caught when AttrList.inc is re-vendored — the documented
// per-bump step — not by these asserts.)
#define ATTR(X)                                                                            \
  static_assert(static_cast<int>(CXAttrKind_##X) == static_cast<int>(clang::attr::X),      \
                "CXAttrKind drift: " #X);
#include "clang-ex/AST/AttrList.inc"

#define ATTR(X)                                                                            \
  CX##X##Attr clang_Attr_castTo##X##Attr(CXAttr A) {                                       \
    return reinterpret_cast<CX##X##Attr>(                                                  \
        llvm::dyn_cast_or_null<clang::X##Attr>(reinterpret_cast<clang::Attr *>(A)));       \
  }                                                                                        \
  bool clang_Attr_is##X##Attr(CXAttr A) {                                                  \
    return llvm::isa_and_nonnull<clang::X##Attr>(reinterpret_cast<clang::Attr *>(A));      \
  }
#include "clang-ex/AST/AttrList.inc"
CXAttrKind clang_Attr_getKind(CXAttr A) {
  return static_cast<CXAttrKind>(reinterpret_cast<clang::Attr *>(A)->getKind());
}

const char *clang_Attr_getSpelling(CXAttr A) {
  return reinterpret_cast<clang::Attr *>(A)->getSpelling();
}

CXSourceRange_ clang_Attr_getRange(CXAttr A) {
  clang::SourceRange R = reinterpret_cast<clang::Attr *>(A)->getRange();
  return CXSourceRange_{reinterpret_cast<CXSourceLocation_>(R.getBegin().getPtrEncoding()), reinterpret_cast<CXSourceLocation_>(R.getEnd().getPtrEncoding())};
}

CXSourceLocation_ clang_Attr_getLocation(CXAttr A) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::Attr *>(A)->getLocation().getPtrEncoding());
}

bool clang_Attr_isImplicit(CXAttr A) {
  return reinterpret_cast<clang::Attr *>(A)->isImplicit();
}

bool clang_Attr_isInherited(CXAttr A) {
  return reinterpret_cast<clang::Attr *>(A)->isInherited();
}

bool clang_Attr_isPackExpansion(CXAttr A) {
  return reinterpret_cast<clang::Attr *>(A)->isPackExpansion();
}

// AlignedAttr
unsigned clang_AlignedAttr_getAlignment(CXAlignedAttr A, CXASTContext Ctx) {
  return reinterpret_cast<clang::AlignedAttr *>(A)->getAlignment(
      *reinterpret_cast<clang::ASTContext *>(Ctx));
}

bool clang_AlignedAttr_isAlignmentExpr(CXAlignedAttr A) {
  return reinterpret_cast<clang::AlignedAttr *>(A)->isAlignmentExpr();
}

CXExpr clang_AlignedAttr_getAlignmentExpr(CXAlignedAttr A) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::AlignedAttr *>(A)->getAlignmentExpr());
}

// AnnotateAttr
CXString clang_AnnotateAttr_getAnnotation(CXAnnotateAttr A) {
  return extra::makeCXString(reinterpret_cast<clang::AnnotateAttr *>(A)->getAnnotation().str());
}

unsigned clang_AnnotateAttr_args_size(CXAnnotateAttr A) {
  return reinterpret_cast<clang::AnnotateAttr *>(A)->args_size();
}

// AsmLabelAttr
CXString clang_AsmLabelAttr_getLabel(CXAsmLabelAttr A) {
  return extra::makeCXString(reinterpret_cast<clang::AsmLabelAttr *>(A)->getLabel().str());
}

bool clang_AsmLabelAttr_getIsLiteralLabel(CXAsmLabelAttr A) {
  return reinterpret_cast<clang::AsmLabelAttr *>(A)->getIsLiteralLabel();
}

// AvailabilityAttr
CXIdentifierInfo clang_AvailabilityAttr_getPlatform(CXAvailabilityAttr A) {
  return reinterpret_cast<CXIdentifierInfo>(
      reinterpret_cast<clang::AvailabilityAttr *>(A)->getPlatform());
}

static bool unpackVersion(llvm::VersionTuple V, unsigned *Major, unsigned *Minor,
                          unsigned *Subminor) {
  if (V.empty())
    return false;
  *Major = V.getMajor();
  *Minor = V.getMinor().value_or(0);
  *Subminor = V.getSubminor().value_or(0);
  return true;
}

bool clang_AvailabilityAttr_getIntroduced(CXAvailabilityAttr A, unsigned *Major,
                                          unsigned *Minor, unsigned *Subminor) {
  return unpackVersion(reinterpret_cast<clang::AvailabilityAttr *>(A)->getIntroduced(), Major,
                       Minor, Subminor);
}

bool clang_AvailabilityAttr_getDeprecated(CXAvailabilityAttr A, unsigned *Major,
                                          unsigned *Minor, unsigned *Subminor) {
  return unpackVersion(reinterpret_cast<clang::AvailabilityAttr *>(A)->getDeprecated(), Major,
                       Minor, Subminor);
}

bool clang_AvailabilityAttr_getObsoleted(CXAvailabilityAttr A, unsigned *Major,
                                         unsigned *Minor, unsigned *Subminor) {
  return unpackVersion(reinterpret_cast<clang::AvailabilityAttr *>(A)->getObsoleted(), Major,
                       Minor, Subminor);
}

bool clang_AvailabilityAttr_getUnavailable(CXAvailabilityAttr A) {
  return reinterpret_cast<clang::AvailabilityAttr *>(A)->getUnavailable();
}

CXString clang_AvailabilityAttr_getMessage(CXAvailabilityAttr A) {
  return extra::makeCXString(
      reinterpret_cast<clang::AvailabilityAttr *>(A)->getMessage().str());
}

bool clang_AvailabilityAttr_getStrict(CXAvailabilityAttr A) {
  return reinterpret_cast<clang::AvailabilityAttr *>(A)->getStrict();
}

CXString clang_AvailabilityAttr_getReplacement(CXAvailabilityAttr A) {
  return extra::makeCXString(
      reinterpret_cast<clang::AvailabilityAttr *>(A)->getReplacement().str());
}

int clang_AvailabilityAttr_getPriority(CXAvailabilityAttr A) {
  return reinterpret_cast<clang::AvailabilityAttr *>(A)->getPriority();
}

// CleanupAttr
CXFunctionDecl clang_CleanupAttr_getFunctionDecl(CXCleanupAttr A) {
  return reinterpret_cast<CXFunctionDecl>(reinterpret_cast<clang::CleanupAttr *>(A)->getFunctionDecl());
}

// ConstructorAttr
int clang_ConstructorAttr_getPriority(CXConstructorAttr A) {
  return reinterpret_cast<clang::ConstructorAttr *>(A)->getPriority();
}

// DeprecatedAttr
CXString clang_DeprecatedAttr_getMessage(CXDeprecatedAttr A) {
  return extra::makeCXString(reinterpret_cast<clang::DeprecatedAttr *>(A)->getMessage().str());
}

CXString clang_DeprecatedAttr_getReplacement(CXDeprecatedAttr A) {
  return extra::makeCXString(
      reinterpret_cast<clang::DeprecatedAttr *>(A)->getReplacement().str());
}

// DestructorAttr
int clang_DestructorAttr_getPriority(CXDestructorAttr A) {
  return reinterpret_cast<clang::DestructorAttr *>(A)->getPriority();
}

// FormatAttr
CXIdentifierInfo clang_FormatAttr_getType(CXFormatAttr A) {
  return reinterpret_cast<CXIdentifierInfo>(reinterpret_cast<clang::FormatAttr *>(A)->getType());
}

int clang_FormatAttr_getFormatIdx(CXFormatAttr A) {
  return reinterpret_cast<clang::FormatAttr *>(A)->getFormatIdx();
}

int clang_FormatAttr_getFirstArg(CXFormatAttr A) {
  return reinterpret_cast<clang::FormatAttr *>(A)->getFirstArg();
}

// MaxFieldAlignmentAttr
unsigned clang_MaxFieldAlignmentAttr_getAlignment(CXMaxFieldAlignmentAttr A) {
  return reinterpret_cast<clang::MaxFieldAlignmentAttr *>(A)->getAlignment();
}

// NonNullAttr
unsigned clang_NonNullAttr_args_size(CXNonNullAttr A) {
  return reinterpret_cast<clang::NonNullAttr *>(A)->args_size();
}

bool clang_NonNullAttr_isNonNull(CXNonNullAttr A, unsigned IdxAST) {
  return reinterpret_cast<clang::NonNullAttr *>(A)->isNonNull(IdxAST);
}

// SectionAttr
CXString clang_SectionAttr_getName(CXSectionAttr A) {
  return extra::makeCXString(reinterpret_cast<clang::SectionAttr *>(A)->getName().str());
}

// TLSModelAttr
CXString clang_TLSModelAttr_getModel(CXTLSModelAttr A) {
  return extra::makeCXString(reinterpret_cast<clang::TLSModelAttr *>(A)->getModel().str());
}

// UnavailableAttr
CXString clang_UnavailableAttr_getMessage(CXUnavailableAttr A) {
  return extra::makeCXString(reinterpret_cast<clang::UnavailableAttr *>(A)->getMessage().str());
}

// VisibilityAttr
CXVisibilityAttr_VisibilityType clang_VisibilityAttr_getVisibility(CXVisibilityAttr A) {
  return static_cast<CXVisibilityAttr_VisibilityType>(
      reinterpret_cast<clang::VisibilityAttr *>(A)->getVisibility());
}

// WarnUnusedResultAttr
CXString clang_WarnUnusedResultAttr_getMessage(CXWarnUnusedResultAttr A) {
  return extra::makeCXString(
      reinterpret_cast<clang::WarnUnusedResultAttr *>(A)->getMessage().str());
}
