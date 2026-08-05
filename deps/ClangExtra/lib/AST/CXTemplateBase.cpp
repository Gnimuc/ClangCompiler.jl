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
  return reinterpret_cast<CXTemplateArgument>(ptr.release());
}

CXTemplateArgument clang_TemplateArgument_constructFromValueDecl(CXValueDecl VD,
                                                                 CXQualType OpaquePtr) {
  std::unique_ptr<clang::TemplateArgument> ptr = std::make_unique<clang::TemplateArgument>(
      reinterpret_cast<clang::ValueDecl *>(VD), clang::QualType::getFromOpaquePtr(OpaquePtr));
  return reinterpret_cast<CXTemplateArgument>(ptr.release());
}

CXTemplateArgument clang_TemplateArgument_constructFromIntegral(CXASTContext Ctx,
                                                                LLVMGenericValueRef Val,
                                                                CXQualType OpaquePtr) {
  std::unique_ptr<clang::TemplateArgument> ptr = std::make_unique<clang::TemplateArgument>(
      *reinterpret_cast<clang::ASTContext *>(Ctx),
      llvm::APSInt(reinterpret_cast<llvm::GenericValue *>(Val)->IntVal),
      clang::QualType::getFromOpaquePtr(OpaquePtr));
  return reinterpret_cast<CXTemplateArgument>(ptr.release());
}

void clang_TemplateArgument_dispose(CXTemplateArgument TA) {
  delete reinterpret_cast<clang::TemplateArgument *>(TA);
}

CXTemplateArgument clang_TemplateArgument_getEmptyPack(void) {
  std::unique_ptr<clang::TemplateArgument> ptr =
      std::make_unique<clang::TemplateArgument>(clang::TemplateArgument::getEmptyPack());
  return reinterpret_cast<CXTemplateArgument>(ptr.release());
}

CXTemplateArgument clang_TemplateArgument_CreatePackCopy(CXASTContext Context,
                                                         CXTemplateArgument Args,
                                                         unsigned ArgNum) {
  // Args is a caller buffer of CXTemplateArgument handles (pointers to heap-boxed
  // clang::TemplateArgument), not a contiguous value array - dereference each into a
  // value vector before copying.
  auto **Handles = reinterpret_cast<clang::TemplateArgument **>(Args);
  llvm::SmallVector<clang::TemplateArgument, 4> Vec;
  Vec.reserve(ArgNum);
  for (unsigned I = 0; I < ArgNum; ++I)
    Vec.push_back(*Handles[I]);
  std::unique_ptr<clang::TemplateArgument> ptr =
      std::make_unique<clang::TemplateArgument>(clang::TemplateArgument::CreatePackCopy(
          *reinterpret_cast<clang::ASTContext *>(Context), Vec));
  return reinterpret_cast<CXTemplateArgument>(ptr.release());
}

CXTemplateArgument_ArgKind clang_TemplateArgument_getKind(CXTemplateArgument TA) {
  return static_cast<CXTemplateArgument_ArgKind>(
      reinterpret_cast<clang::TemplateArgument *>(TA)->getKind());
}

bool clang_TemplateArgument_isNull(CXTemplateArgument TA) {
  return reinterpret_cast<clang::TemplateArgument *>(TA)->isNull();
}

bool clang_TemplateArgument_isDependent(CXTemplateArgument TA) {
  return reinterpret_cast<clang::TemplateArgument *>(TA)->isDependent();
}

bool clang_TemplateArgument_isInstantiationDependent(CXTemplateArgument TA) {
  return reinterpret_cast<clang::TemplateArgument *>(TA)->isInstantiationDependent();
}

bool clang_TemplateArgument_containsUnexpandedParameterPack(CXTemplateArgument TA) {
  return reinterpret_cast<clang::TemplateArgument *>(TA)->containsUnexpandedParameterPack();
}

bool clang_TemplateArgument_isPackExpansion(CXTemplateArgument TA) {
  return reinterpret_cast<clang::TemplateArgument *>(TA)->isPackExpansion();
}

CXQualType clang_TemplateArgument_getAsType(CXTemplateArgument TA) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::TemplateArgument *>(TA)->getAsType().getAsOpaquePtr());
}

CXValueDecl clang_TemplateArgument_getAsDecl(CXTemplateArgument TA) {
  return reinterpret_cast<CXValueDecl>(reinterpret_cast<clang::TemplateArgument *>(TA)->getAsDecl());
}

CXQualType clang_TemplateArgument_getParamTypeForDecl(CXTemplateArgument TA) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::TemplateArgument *>(TA)->getParamTypeForDecl().getAsOpaquePtr());
}

CXQualType clang_TemplateArgument_getNullPtrType(CXTemplateArgument TA) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::TemplateArgument *>(TA)->getNullPtrType().getAsOpaquePtr());
}

CXTemplateName clang_TemplateArgument_getAsTemplate(CXTemplateArgument TA) {
  return reinterpret_cast<CXTemplateName>(reinterpret_cast<clang::TemplateArgument *>(TA)->getAsTemplate().getAsVoidPointer());
}

CXTemplateName
clang_TemplateArgument_getAsTemplateOrTemplatePattern(CXTemplateArgument TA) {
  return reinterpret_cast<CXTemplateName>(reinterpret_cast<clang::TemplateArgument *>(TA)
      ->getAsTemplateOrTemplatePattern()
      .getAsVoidPointer());
}

bool clang_TemplateArgument_getNumTemplateExpansions(CXTemplateArgument TA, unsigned *N) {
  if (auto Num = reinterpret_cast<clang::TemplateArgument *>(TA)->getNumTemplateExpansions()) {
    *N = *Num;
    return true;
  }
  return false;
}

LLVMGenericValueRef clang_TemplateArgument_getAsIntegral(CXTemplateArgument TA) {
  llvm::GenericValue *GenVal = new llvm::GenericValue();
  GenVal->IntVal = reinterpret_cast<clang::TemplateArgument *>(TA)->getAsIntegral();
  return reinterpret_cast<LLVMGenericValueRef>(GenVal);
}

CXQualType clang_TemplateArgument_getIntegralType(CXTemplateArgument TA) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::TemplateArgument *>(TA)->getIntegralType().getAsOpaquePtr());
}

void clang_TemplateArgument_setIntegralType(CXTemplateArgument TA, CXQualType OpaquePtr) {
  return reinterpret_cast<clang::TemplateArgument *>(TA)->setIntegralType(
      clang::QualType::getFromOpaquePtr(OpaquePtr));
}

CXQualType clang_TemplateArgument_getNonTypeTemplateArgumentType(CXTemplateArgument TA) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::TemplateArgument *>(TA)
      ->getNonTypeTemplateArgumentType()
      .getAsOpaquePtr());
}

void clang_TemplateArgument_setIsDefaulted(CXTemplateArgument TA, bool V) {
  reinterpret_cast<clang::TemplateArgument *>(TA)->setIsDefaulted(V);
}

bool clang_TemplateArgument_getIsDefaulted(CXTemplateArgument TA) {
  return reinterpret_cast<clang::TemplateArgument *>(TA)->getIsDefaulted();
}

CXAPValue clang_TemplateArgument_getAsStructuralValue(CXTemplateArgument TA) {
  return reinterpret_cast<CXAPValue>(const_cast<clang::APValue *>(
      &reinterpret_cast<clang::TemplateArgument *>(TA)->getAsStructuralValue()));
}

CXQualType clang_TemplateArgument_getStructuralValueType(CXTemplateArgument TA) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::TemplateArgument *>(TA)
      ->getStructuralValueType()
      .getAsOpaquePtr());
}

CXExpr clang_TemplateArgument_getAsExpr(CXTemplateArgument TA) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::TemplateArgument *>(TA)->getAsExpr());
}

unsigned clang_TemplateArgument_pack_size(CXTemplateArgument TA) {
  return reinterpret_cast<clang::TemplateArgument *>(TA)->pack_size();
}

CXTemplateArgument clang_TemplateArgument_getPackElement(CXTemplateArgument TA,
                                                         unsigned I) {
  return reinterpret_cast<CXTemplateArgument>(const_cast<clang::TemplateArgument *>(
      &reinterpret_cast<clang::TemplateArgument *>(TA)->getPackAsArray()[I]));
}

bool clang_TemplateArgument_structurallyEquals(CXTemplateArgument TA,
                                               CXTemplateArgument Other) {
  return reinterpret_cast<clang::TemplateArgument *>(TA)->structurallyEquals(
      *reinterpret_cast<clang::TemplateArgument *>(Other));
}

CXTemplateArgument clang_TemplateArgument_getPackExpansionPattern(CXTemplateArgument TA) {
  std::unique_ptr<clang::TemplateArgument> ptr = std::make_unique<clang::TemplateArgument>(
      reinterpret_cast<clang::TemplateArgument *>(TA)->getPackExpansionPattern());
  return reinterpret_cast<CXTemplateArgument>(ptr.release());
}

CXString clang_TemplateArgument_print(CXTemplateArgument TA, CXASTContext Context,
                                      bool IncludeType) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::TemplateArgument *>(TA)->print(
      reinterpret_cast<clang::ASTContext *>(Context)->getPrintingPolicy(), OS, IncludeType);
  return extra::makeCXString(S);
}

void clang_TemplateArgument_dump(CXTemplateArgument TA) {
  return reinterpret_cast<clang::TemplateArgument *>(TA)->dump();
}
// TemplateArgumentLoc
CXTemplateArgument clang_TemplateArgumentLoc_getArgument(CXTemplateArgumentLoc TAL) {
  return reinterpret_cast<CXTemplateArgument>(const_cast<clang::TemplateArgument *>(
      &reinterpret_cast<clang::TemplateArgumentLoc *>(TAL)->getArgument()));
}

CXSourceLocation_ clang_TemplateArgumentLoc_getLocation(CXTemplateArgumentLoc TAL) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::TemplateArgumentLoc *>(TAL)->getLocation().getPtrEncoding());
}

CXSourceRange_ clang_TemplateArgumentLoc_getSourceRange(CXTemplateArgumentLoc TAL) {
  auto rng = reinterpret_cast<clang::TemplateArgumentLoc *>(TAL)->getSourceRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

CXTypeSourceInfo clang_TemplateArgumentLoc_getTypeSourceInfo(CXTemplateArgumentLoc TAL) {
  return reinterpret_cast<CXTypeSourceInfo>(reinterpret_cast<clang::TemplateArgumentLoc *>(TAL)->getTypeSourceInfo());
}

CXExpr clang_TemplateArgumentLoc_getSourceExpression(CXTemplateArgumentLoc TAL) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::TemplateArgumentLoc *>(TAL)->getSourceExpression());
}

CXExpr clang_TemplateArgumentLoc_getSourceDeclExpression(CXTemplateArgumentLoc TAL) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::TemplateArgumentLoc *>(TAL)->getSourceDeclExpression());
}

CXExpr clang_TemplateArgumentLoc_getSourceNullPtrExpression(CXTemplateArgumentLoc TAL) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::TemplateArgumentLoc *>(TAL)->getSourceNullPtrExpression());
}

CXExpr clang_TemplateArgumentLoc_getSourceIntegralExpression(CXTemplateArgumentLoc TAL) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::TemplateArgumentLoc *>(TAL)->getSourceIntegralExpression());
}

CXExpr
clang_TemplateArgumentLoc_getSourceStructuralValueExpression(CXTemplateArgumentLoc TAL) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::TemplateArgumentLoc *>(TAL)
      ->getSourceStructuralValueExpression());
}

CXNestedNameSpecifier
clang_TemplateArgumentLoc_getTemplateQualifier(CXTemplateArgumentLoc TAL) {
  return reinterpret_cast<CXNestedNameSpecifier>(reinterpret_cast<clang::TemplateArgumentLoc *>(TAL)
      ->getTemplateQualifierLoc()
      .getNestedNameSpecifier());
}

CXSourceLocation_ clang_TemplateArgumentLoc_getTemplateNameLoc(CXTemplateArgumentLoc TAL) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::TemplateArgumentLoc *>(TAL)
      ->getTemplateNameLoc()
      .getPtrEncoding());
}

CXSourceLocation_
clang_TemplateArgumentLoc_getTemplateEllipsisLoc(CXTemplateArgumentLoc TAL) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::TemplateArgumentLoc *>(TAL)
      ->getTemplateEllipsisLoc()
      .getPtrEncoding());
}

// TemplateArgumentListInfo
CXTemplateArgumentListInfo
clang_TemplateArgumentListInfo_create(CXSourceLocation_ LAngleLoc,
                                      CXSourceLocation_ RAngleLoc) {
  // ::new, not make_unique: the class deletes operator new(size_t, ASTContext &) to keep
  // itself out of the AST arena (its SmallVector would leak there), and declaring any
  // operator new hides the global ones for class-scope lookup. The qualified form reaches
  // the global operator new, which is what a caller-owned box wants; ::delete matches.
  return reinterpret_cast<CXTemplateArgumentListInfo>(::new clang::TemplateArgumentListInfo(
      clang::SourceLocation::getFromPtrEncoding(LAngleLoc),
      clang::SourceLocation::getFromPtrEncoding(RAngleLoc)));
}

void clang_TemplateArgumentListInfo_dispose(CXTemplateArgumentListInfo LI) {
  ::delete reinterpret_cast<clang::TemplateArgumentListInfo *>(LI);
}

CXSourceLocation_
clang_TemplateArgumentListInfo_getLAngleLoc(CXTemplateArgumentListInfo LI) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::TemplateArgumentListInfo *>(LI)
      ->getLAngleLoc()
      .getPtrEncoding());
}

CXSourceLocation_
clang_TemplateArgumentListInfo_getRAngleLoc(CXTemplateArgumentListInfo LI) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::TemplateArgumentListInfo *>(LI)
      ->getRAngleLoc()
      .getPtrEncoding());
}

void clang_TemplateArgumentListInfo_setLAngleLoc(CXTemplateArgumentListInfo LI,
                                                 CXSourceLocation_ Loc) {
  reinterpret_cast<clang::TemplateArgumentListInfo *>(LI)->setLAngleLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_TemplateArgumentListInfo_setRAngleLoc(CXTemplateArgumentListInfo LI,
                                                 CXSourceLocation_ Loc) {
  reinterpret_cast<clang::TemplateArgumentListInfo *>(LI)->setRAngleLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

unsigned clang_TemplateArgumentListInfo_size(CXTemplateArgumentListInfo LI) {
  return reinterpret_cast<clang::TemplateArgumentListInfo *>(LI)->size();
}

CXTemplateArgumentLoc
clang_TemplateArgumentListInfo_getArgument(CXTemplateArgumentListInfo LI, unsigned I) {
  return reinterpret_cast<CXTemplateArgumentLoc>(&(*reinterpret_cast<clang::TemplateArgumentListInfo *>(LI))[I]);
}

void clang_TemplateArgumentListInfo_addArgument(CXTemplateArgumentListInfo LI,
                                                CXTemplateArgumentLoc Loc) {
  reinterpret_cast<clang::TemplateArgumentListInfo *>(LI)->addArgument(
      *reinterpret_cast<clang::TemplateArgumentLoc *>(Loc));
}

// ASTTemplateArgumentListInfo
CXSourceLocation_
clang_ASTTemplateArgumentListInfo_getLAngleLoc(CXASTTemplateArgumentListInfo LI) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::ASTTemplateArgumentListInfo *>(LI)
      ->getLAngleLoc()
      .getPtrEncoding());
}

CXSourceLocation_
clang_ASTTemplateArgumentListInfo_getRAngleLoc(CXASTTemplateArgumentListInfo LI) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::ASTTemplateArgumentListInfo *>(LI)
      ->getRAngleLoc()
      .getPtrEncoding());
}

unsigned
clang_ASTTemplateArgumentListInfo_getNumTemplateArgs(CXASTTemplateArgumentListInfo LI) {
  return reinterpret_cast<clang::ASTTemplateArgumentListInfo *>(LI)->getNumTemplateArgs();
}

CXTemplateArgumentLoc
clang_ASTTemplateArgumentListInfo_getTemplateArg(CXASTTemplateArgumentListInfo LI,
                                                 unsigned I) {
  return reinterpret_cast<CXTemplateArgumentLoc>(const_cast<clang::TemplateArgumentLoc *>(
      &reinterpret_cast<clang::ASTTemplateArgumentListInfo *>(LI)->arguments()[I]));
}

CXASTTemplateArgumentListInfo
clang_ASTTemplateArgumentListInfo_Create(CXASTContext Context,
                                         CXTemplateArgumentListInfo Info) {
  return reinterpret_cast<CXASTTemplateArgumentListInfo>(const_cast<clang::ASTTemplateArgumentListInfo *>(
      clang::ASTTemplateArgumentListInfo::Create(
          *reinterpret_cast<clang::ASTContext *>(Context),
          *reinterpret_cast<clang::TemplateArgumentListInfo *>(Info))));
}

CXNestedNameSpecifierLoc clang_TemplateArgumentLoc_getTemplateQualifierLoc(
    CXTemplateArgumentLoc TAL) {
  return reinterpret_cast<CXNestedNameSpecifierLoc>(std::make_unique<clang::NestedNameSpecifierLoc>(
             reinterpret_cast<clang::TemplateArgumentLoc *>(TAL)->getTemplateQualifierLoc())
      .release());
}

unsigned clang_TemplateArgument_getDependence(CXTemplateArgument TA) {
  return static_cast<unsigned>(
      reinterpret_cast<clang::TemplateArgument *>(TA)->getDependence());
}
