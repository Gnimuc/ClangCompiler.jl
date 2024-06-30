#include "clang-ex/Sema/CXDeclSpec.h"
#include "clang/Sema/DeclSpec.h"
#include <cstdio>

CXCXXScopeSpec clang_CXXScopeSpec_create(CXInit_Error *ErrorCode) {
  CXInit_Error Err = CXInit_NoError;
  std::unique_ptr<clang::CXXScopeSpec> ptr = std::make_unique<clang::CXXScopeSpec>();

  if (!ptr) {
    fprintf(stderr, "LIBCLANGEX ERROR: failed to create `clang::CXXScopeSpec`\n");
    Err = CXInit_CanNotCreate;
  }

  if (ErrorCode)
    *ErrorCode = Err;

  return ptr.release();
}

void clang_CXXScopeSpec_dispose(CXCXXScopeSpec SS) {
  delete static_cast<clang::CXXScopeSpec *>(SS);
}

void clang_CXXScopeSpec_clear(CXCXXScopeSpec SS) {
  static_cast<clang::CXXScopeSpec *>(SS)->clear();
}

CXNestedNameSpecifier clang_CXXScopeSpec_getScopeRep(CXCXXScopeSpec SS) {
  return static_cast<clang::CXXScopeSpec *>(SS)->getScopeRep();
}

CXSourceLocation_ clang_CXXScopeSpec_getBeginLoc(CXCXXScopeSpec SS) {
  return static_cast<clang::CXXScopeSpec *>(SS)->getBeginLoc().getPtrEncoding();
}

CXSourceLocation_ clang_CXXScopeSpec_getEndLoc(CXCXXScopeSpec SS) {
  return static_cast<clang::CXXScopeSpec *>(SS)->getEndLoc().getPtrEncoding();
}

void clang_CXXScopeSpec_setBeginLoc(CXCXXScopeSpec SS, CXSourceLocation_ Loc) {
  static_cast<clang::CXXScopeSpec *>(SS)->setBeginLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_CXXScopeSpec_setEndLoc(CXCXXScopeSpec SS, CXSourceLocation_ Loc) {
  static_cast<clang::CXXScopeSpec *>(SS)->setEndLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

bool clang_CXXScopeSpec_isEmpty(CXCXXScopeSpec SS) {
  return static_cast<clang::CXXScopeSpec *>(SS)->isEmpty();
}

bool clang_CXXScopeSpec_isNotEmpty(CXCXXScopeSpec SS) {
  return static_cast<clang::CXXScopeSpec *>(SS)->isNotEmpty();
}

bool clang_CXXScopeSpec_isInvalid(CXCXXScopeSpec SS) {
  return static_cast<clang::CXXScopeSpec *>(SS)->isInvalid();
}

bool clang_CXXScopeSpec_isValid(CXCXXScopeSpec SS) {
  return static_cast<clang::CXXScopeSpec *>(SS)->isValid();
}