#include "clang-ex/AST/CXQualTypeNames.h"
#include "utils.h"

#include "clang/AST/ASTContext.h"
#include "clang/AST/QualTypeNames.h"

CXString clang_TypeName_getFullyQualifiedName(CXQualType QT, CXASTContext Ctx,
                                              CXPrintingPolicy_ Policy,
                                              bool WithGlobalNsPrefix) {
  return extra::makeCXString(clang::TypeName::getFullyQualifiedName(
      clang::QualType::getFromOpaquePtr(QT), *reinterpret_cast<clang::ASTContext *>(Ctx),
      *reinterpret_cast<clang::PrintingPolicy *>(Policy), WithGlobalNsPrefix));
}

CXQualType clang_TypeName_getFullyQualifiedType(CXQualType QT, CXASTContext Ctx,
                                                bool WithGlobalNsPrefix) {
  return reinterpret_cast<CXQualType>(
      clang::TypeName::getFullyQualifiedType(clang::QualType::getFromOpaquePtr(QT),
                                             *reinterpret_cast<clang::ASTContext *>(Ctx),
                                             WithGlobalNsPrefix)
          .getAsOpaquePtr());
}
