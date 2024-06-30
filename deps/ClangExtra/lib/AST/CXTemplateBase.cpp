#include "clang-ex/AST/CXTemplateBase.h"
#include "clang/AST/TemplateBase.h"
#include "llvm/ExecutionEngine/GenericValue.h"

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

unsigned clang_TemplateArgument_getNumTemplateExpansions(CXTemplateArgument TA) {
  return *static_cast<clang::TemplateArgument *>(TA)->getNumTemplateExpansions();
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

void clang_TemplateArgument_dump(CXTemplateArgument TA) {
  return static_cast<clang::TemplateArgument *>(TA)->dump();
}