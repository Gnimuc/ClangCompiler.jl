#include "clang-ex/AST/CXTemplateBase.h"
#include "clang/AST/TemplateBase.h"
#include "llvm/ExecutionEngine/GenericValue.h"
#include "utils.h"
#include "clang/AST/ASTContext.h"
#include "llvm/Support/raw_ostream.h"
#include "clang/AST/APValue.h"
#include "clang/AST/NestedNameSpecifier.h"

CXTemplateArgument clang_TemplateArgument_constructFromQualType(CXQualType OpaquePtr,
                                                                bool isNullPtr) {
  std::unique_ptr<clang::TemplateArgument> ptr = std::make_unique<clang::TemplateArgument>(
      clang::QualType::getFromOpaquePtr(OpaquePtr), isNullPtr);
  return ptr.release();
}

CXTemplateArgument clang_TemplateArgument_constructFromValueDecl(CXValueDecl VD,
                                                                 CXQualType OpaquePtr) {
  std::unique_ptr<clang::TemplateArgument> ptr = std::make_unique<clang::TemplateArgument>(
      static_cast<clang::ValueDecl *>(VD), clang::QualType::getFromOpaquePtr(OpaquePtr));
  return ptr.release();
}

CXTemplateArgument clang_TemplateArgument_constructFromIntegral(CXASTContext Ctx,
                                                                LLVMGenericValueRef Val,
                                                                CXQualType OpaquePtr) {
  std::unique_ptr<clang::TemplateArgument> ptr = std::make_unique<clang::TemplateArgument>(
      *static_cast<clang::ASTContext *>(Ctx),
      llvm::APSInt(reinterpret_cast<llvm::GenericValue *>(Val)->IntVal),
      clang::QualType::getFromOpaquePtr(OpaquePtr));
  return ptr.release();
}

void clang_TemplateArgument_dispose(CXTemplateArgument TA) {
  delete static_cast<clang::TemplateArgument *>(TA);
}

CXTemplateArgument clang_TemplateArgument_getEmptyPack(void) {
  std::unique_ptr<clang::TemplateArgument> ptr =
      std::make_unique<clang::TemplateArgument>(clang::TemplateArgument::getEmptyPack());
  return ptr.release();
}

CXTemplateArgument clang_TemplateArgument_CreatePackCopy(CXASTContext Context,
                                                         CXTemplateArgument Args,
                                                         unsigned ArgNum) {
  // Args is a caller buffer of CXTemplateArgument handles (pointers to heap-boxed
  // clang::TemplateArgument), not a contiguous value array - dereference each into a
  // value vector before copying.
  auto **Handles = static_cast<clang::TemplateArgument **>(Args);
  llvm::SmallVector<clang::TemplateArgument, 4> Vec;
  Vec.reserve(ArgNum);
  for (unsigned I = 0; I < ArgNum; ++I)
    Vec.push_back(*Handles[I]);
  std::unique_ptr<clang::TemplateArgument> ptr =
      std::make_unique<clang::TemplateArgument>(clang::TemplateArgument::CreatePackCopy(
          *static_cast<clang::ASTContext *>(Context), Vec));
  return ptr.release();
}

CXTemplateArgument_ArgKind clang_TemplateArgument_getKind(CXTemplateArgument TA) {
  return static_cast<CXTemplateArgument_ArgKind>(
      static_cast<clang::TemplateArgument *>(TA)->getKind());
}

bool clang_TemplateArgument_isNull(CXTemplateArgument TA) {
  return static_cast<clang::TemplateArgument *>(TA)->isNull();
}

bool clang_TemplateArgument_isDependent(CXTemplateArgument TA) {
  return static_cast<clang::TemplateArgument *>(TA)->isDependent();
}

bool clang_TemplateArgument_isInstantiationDependent(CXTemplateArgument TA) {
  return static_cast<clang::TemplateArgument *>(TA)->isInstantiationDependent();
}

bool clang_TemplateArgument_containsUnexpandedParameterPack(CXTemplateArgument TA) {
  return static_cast<clang::TemplateArgument *>(TA)->containsUnexpandedParameterPack();
}

bool clang_TemplateArgument_isPackExpansion(CXTemplateArgument TA) {
  return static_cast<clang::TemplateArgument *>(TA)->isPackExpansion();
}

CXQualType clang_TemplateArgument_getAsType(CXTemplateArgument TA) {
  return static_cast<clang::TemplateArgument *>(TA)->getAsType().getAsOpaquePtr();
}

CXValueDecl clang_TemplateArgument_getAsDecl(CXTemplateArgument TA) {
  return static_cast<clang::TemplateArgument *>(TA)->getAsDecl();
}

CXQualType clang_TemplateArgument_getParamTypeForDecl(CXTemplateArgument TA) {
  return static_cast<clang::TemplateArgument *>(TA)->getParamTypeForDecl().getAsOpaquePtr();
}

CXQualType clang_TemplateArgument_getNullPtrType(CXTemplateArgument TA) {
  return static_cast<clang::TemplateArgument *>(TA)->getNullPtrType().getAsOpaquePtr();
}

CXTemplateName clang_TemplateArgument_getAsTemplate(CXTemplateArgument TA) {
  return static_cast<clang::TemplateArgument *>(TA)->getAsTemplate().getAsVoidPointer();
}

CXTemplateName
clang_TemplateArgument_getAsTemplateOrTemplatePattern(CXTemplateArgument TA) {
  return static_cast<clang::TemplateArgument *>(TA)
      ->getAsTemplateOrTemplatePattern()
      .getAsVoidPointer();
}

bool clang_TemplateArgument_getNumTemplateExpansions(CXTemplateArgument TA, unsigned *N) {
  if (auto Num = static_cast<clang::TemplateArgument *>(TA)->getNumTemplateExpansions()) {
    *N = *Num;
    return true;
  }
  return false;
}

LLVMGenericValueRef clang_TemplateArgument_getAsIntegral(CXTemplateArgument TA) {
  llvm::GenericValue *GenVal = new llvm::GenericValue();
  GenVal->IntVal = static_cast<clang::TemplateArgument *>(TA)->getAsIntegral();
  return reinterpret_cast<LLVMGenericValueRef>(GenVal);
}

CXQualType clang_TemplateArgument_getIntegralType(CXTemplateArgument TA) {
  return static_cast<clang::TemplateArgument *>(TA)->getIntegralType().getAsOpaquePtr();
}

void clang_TemplateArgument_setIntegralType(CXTemplateArgument TA, CXQualType OpaquePtr) {
  return static_cast<clang::TemplateArgument *>(TA)->setIntegralType(
      clang::QualType::getFromOpaquePtr(OpaquePtr));
}

CXQualType clang_TemplateArgument_getNonTypeTemplateArgumentType(CXTemplateArgument TA) {
  return static_cast<clang::TemplateArgument *>(TA)
      ->getNonTypeTemplateArgumentType()
      .getAsOpaquePtr();
}

void clang_TemplateArgument_setIsDefaulted(CXTemplateArgument TA, bool V) {
  static_cast<clang::TemplateArgument *>(TA)->setIsDefaulted(V);
}

bool clang_TemplateArgument_getIsDefaulted(CXTemplateArgument TA) {
  return static_cast<clang::TemplateArgument *>(TA)->getIsDefaulted();
}

CXAPValue clang_TemplateArgument_getAsStructuralValue(CXTemplateArgument TA) {
  return const_cast<clang::APValue *>(
      &static_cast<clang::TemplateArgument *>(TA)->getAsStructuralValue());
}

CXQualType clang_TemplateArgument_getStructuralValueType(CXTemplateArgument TA) {
  return static_cast<clang::TemplateArgument *>(TA)
      ->getStructuralValueType()
      .getAsOpaquePtr();
}

CXExpr clang_TemplateArgument_getAsExpr(CXTemplateArgument TA) {
  return static_cast<clang::TemplateArgument *>(TA)->getAsExpr();
}

unsigned clang_TemplateArgument_pack_size(CXTemplateArgument TA) {
  return static_cast<clang::TemplateArgument *>(TA)->pack_size();
}

CXTemplateArgument clang_TemplateArgument_getPackElement(CXTemplateArgument TA,
                                                         unsigned I) {
  return const_cast<clang::TemplateArgument *>(
      &static_cast<clang::TemplateArgument *>(TA)->getPackAsArray()[I]);
}

bool clang_TemplateArgument_structurallyEquals(CXTemplateArgument TA,
                                               CXTemplateArgument Other) {
  return static_cast<clang::TemplateArgument *>(TA)->structurallyEquals(
      *static_cast<clang::TemplateArgument *>(Other));
}

CXTemplateArgument clang_TemplateArgument_getPackExpansionPattern(CXTemplateArgument TA) {
  std::unique_ptr<clang::TemplateArgument> ptr = std::make_unique<clang::TemplateArgument>(
      static_cast<clang::TemplateArgument *>(TA)->getPackExpansionPattern());
  return ptr.release();
}

CXString clang_TemplateArgument_print(CXTemplateArgument TA, CXASTContext Context,
                                      bool IncludeType) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  static_cast<clang::TemplateArgument *>(TA)->print(
      static_cast<clang::ASTContext *>(Context)->getPrintingPolicy(), OS, IncludeType);
  return extra::makeCXString(S);
}

void clang_TemplateArgument_dump(CXTemplateArgument TA) {
  return static_cast<clang::TemplateArgument *>(TA)->dump();
}
// TemplateArgumentLoc
CXTemplateArgument clang_TemplateArgumentLoc_getArgument(CXTemplateArgumentLoc TAL) {
  return const_cast<clang::TemplateArgument *>(
      &static_cast<clang::TemplateArgumentLoc *>(TAL)->getArgument());
}

CXSourceLocation_ clang_TemplateArgumentLoc_getLocation(CXTemplateArgumentLoc TAL) {
  return static_cast<clang::TemplateArgumentLoc *>(TAL)->getLocation().getPtrEncoding();
}

CXSourceRange_ clang_TemplateArgumentLoc_getSourceRange(CXTemplateArgumentLoc TAL) {
  auto rng = static_cast<clang::TemplateArgumentLoc *>(TAL)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

CXTypeSourceInfo clang_TemplateArgumentLoc_getTypeSourceInfo(CXTemplateArgumentLoc TAL) {
  return static_cast<clang::TemplateArgumentLoc *>(TAL)->getTypeSourceInfo();
}

CXExpr clang_TemplateArgumentLoc_getSourceExpression(CXTemplateArgumentLoc TAL) {
  return static_cast<clang::TemplateArgumentLoc *>(TAL)->getSourceExpression();
}

CXExpr clang_TemplateArgumentLoc_getSourceDeclExpression(CXTemplateArgumentLoc TAL) {
  return static_cast<clang::TemplateArgumentLoc *>(TAL)->getSourceDeclExpression();
}

CXExpr clang_TemplateArgumentLoc_getSourceNullPtrExpression(CXTemplateArgumentLoc TAL) {
  return static_cast<clang::TemplateArgumentLoc *>(TAL)->getSourceNullPtrExpression();
}

CXExpr clang_TemplateArgumentLoc_getSourceIntegralExpression(CXTemplateArgumentLoc TAL) {
  return static_cast<clang::TemplateArgumentLoc *>(TAL)->getSourceIntegralExpression();
}

CXExpr
clang_TemplateArgumentLoc_getSourceStructuralValueExpression(CXTemplateArgumentLoc TAL) {
  return static_cast<clang::TemplateArgumentLoc *>(TAL)
      ->getSourceStructuralValueExpression();
}

CXNestedNameSpecifier
clang_TemplateArgumentLoc_getTemplateQualifier(CXTemplateArgumentLoc TAL) {
  return static_cast<clang::TemplateArgumentLoc *>(TAL)
      ->getTemplateQualifierLoc()
      .getNestedNameSpecifier();
}

CXSourceLocation_ clang_TemplateArgumentLoc_getTemplateNameLoc(CXTemplateArgumentLoc TAL) {
  return static_cast<clang::TemplateArgumentLoc *>(TAL)
      ->getTemplateNameLoc()
      .getPtrEncoding();
}

CXSourceLocation_
clang_TemplateArgumentLoc_getTemplateEllipsisLoc(CXTemplateArgumentLoc TAL) {
  return static_cast<clang::TemplateArgumentLoc *>(TAL)
      ->getTemplateEllipsisLoc()
      .getPtrEncoding();
}

// TemplateArgumentListInfo
CXTemplateArgumentListInfo
clang_TemplateArgumentListInfo_create(CXSourceLocation_ LAngleLoc,
                                      CXSourceLocation_ RAngleLoc) {
  // ::new, not make_unique: the class deletes operator new(size_t, ASTContext &) to keep
  // itself out of the AST arena (its SmallVector would leak there), and declaring any
  // operator new hides the global ones for class-scope lookup. The qualified form reaches
  // the global operator new, which is what a caller-owned box wants; ::delete matches.
  return ::new clang::TemplateArgumentListInfo(
      clang::SourceLocation::getFromPtrEncoding(LAngleLoc),
      clang::SourceLocation::getFromPtrEncoding(RAngleLoc));
}

void clang_TemplateArgumentListInfo_dispose(CXTemplateArgumentListInfo LI) {
  ::delete static_cast<clang::TemplateArgumentListInfo *>(LI);
}

CXSourceLocation_
clang_TemplateArgumentListInfo_getLAngleLoc(CXTemplateArgumentListInfo LI) {
  return static_cast<clang::TemplateArgumentListInfo *>(LI)
      ->getLAngleLoc()
      .getPtrEncoding();
}

CXSourceLocation_
clang_TemplateArgumentListInfo_getRAngleLoc(CXTemplateArgumentListInfo LI) {
  return static_cast<clang::TemplateArgumentListInfo *>(LI)
      ->getRAngleLoc()
      .getPtrEncoding();
}

void clang_TemplateArgumentListInfo_setLAngleLoc(CXTemplateArgumentListInfo LI,
                                                 CXSourceLocation_ Loc) {
  static_cast<clang::TemplateArgumentListInfo *>(LI)->setLAngleLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_TemplateArgumentListInfo_setRAngleLoc(CXTemplateArgumentListInfo LI,
                                                 CXSourceLocation_ Loc) {
  static_cast<clang::TemplateArgumentListInfo *>(LI)->setRAngleLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

unsigned clang_TemplateArgumentListInfo_size(CXTemplateArgumentListInfo LI) {
  return static_cast<clang::TemplateArgumentListInfo *>(LI)->size();
}

CXTemplateArgumentLoc
clang_TemplateArgumentListInfo_getArgument(CXTemplateArgumentListInfo LI, unsigned I) {
  return &(*static_cast<clang::TemplateArgumentListInfo *>(LI))[I];
}

void clang_TemplateArgumentListInfo_addArgument(CXTemplateArgumentListInfo LI,
                                                CXTemplateArgumentLoc Loc) {
  static_cast<clang::TemplateArgumentListInfo *>(LI)->addArgument(
      *static_cast<clang::TemplateArgumentLoc *>(Loc));
}

// ASTTemplateArgumentListInfo
CXSourceLocation_
clang_ASTTemplateArgumentListInfo_getLAngleLoc(CXASTTemplateArgumentListInfo LI) {
  return static_cast<clang::ASTTemplateArgumentListInfo *>(LI)
      ->getLAngleLoc()
      .getPtrEncoding();
}

CXSourceLocation_
clang_ASTTemplateArgumentListInfo_getRAngleLoc(CXASTTemplateArgumentListInfo LI) {
  return static_cast<clang::ASTTemplateArgumentListInfo *>(LI)
      ->getRAngleLoc()
      .getPtrEncoding();
}

unsigned
clang_ASTTemplateArgumentListInfo_getNumTemplateArgs(CXASTTemplateArgumentListInfo LI) {
  return static_cast<clang::ASTTemplateArgumentListInfo *>(LI)->getNumTemplateArgs();
}

CXTemplateArgumentLoc
clang_ASTTemplateArgumentListInfo_getTemplateArg(CXASTTemplateArgumentListInfo LI,
                                                 unsigned I) {
  return const_cast<clang::TemplateArgumentLoc *>(
      &static_cast<clang::ASTTemplateArgumentListInfo *>(LI)->arguments()[I]);
}

CXASTTemplateArgumentListInfo
clang_ASTTemplateArgumentListInfo_Create(CXASTContext Context,
                                         CXTemplateArgumentListInfo Info) {
  return const_cast<clang::ASTTemplateArgumentListInfo *>(
      clang::ASTTemplateArgumentListInfo::Create(
          *static_cast<clang::ASTContext *>(Context),
          *static_cast<clang::TemplateArgumentListInfo *>(Info)));
}

CXNestedNameSpecifierLoc clang_TemplateArgumentLoc_getTemplateQualifierLoc(
    CXTemplateArgumentLoc TAL) {
  return std::make_unique<clang::NestedNameSpecifierLoc>(
             static_cast<clang::TemplateArgumentLoc *>(TAL)->getTemplateQualifierLoc())
      .release();
}

unsigned clang_TemplateArgument_getDependence(CXTemplateArgument TA) {
  return static_cast<unsigned>(
      static_cast<clang::TemplateArgument *>(TA)->getDependence());
}
