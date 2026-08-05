#include "clang-ex/Sema/CXDeclSpec.h"
#include "clang/Sema/DeclSpec.h"

CXCXXScopeSpec clang_CXXScopeSpec_create() {
  auto CXXSS = std::make_unique<clang::CXXScopeSpec>();
  return reinterpret_cast<CXCXXScopeSpec>(CXXSS.release());
}

void clang_CXXScopeSpec_dispose(CXCXXScopeSpec SS) {
  delete reinterpret_cast<clang::CXXScopeSpec *>(SS);
}

void clang_CXXScopeSpec_clear(CXCXXScopeSpec SS) {
  reinterpret_cast<clang::CXXScopeSpec *>(SS)->clear();
}

CXNestedNameSpecifier clang_CXXScopeSpec_getScopeRep(CXCXXScopeSpec SS) {
  return reinterpret_cast<CXNestedNameSpecifier>(reinterpret_cast<clang::CXXScopeSpec *>(SS)->getScopeRep());
}

CXSourceLocation_ clang_CXXScopeSpec_getBeginLoc(CXCXXScopeSpec SS) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::CXXScopeSpec *>(SS)->getBeginLoc().getPtrEncoding());
}

CXSourceLocation_ clang_CXXScopeSpec_getEndLoc(CXCXXScopeSpec SS) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::CXXScopeSpec *>(SS)->getEndLoc().getPtrEncoding());
}

void clang_CXXScopeSpec_setBeginLoc(CXCXXScopeSpec SS, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::CXXScopeSpec *>(SS)->setBeginLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_CXXScopeSpec_setEndLoc(CXCXXScopeSpec SS, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::CXXScopeSpec *>(SS)->setEndLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

bool clang_CXXScopeSpec_isEmpty(CXCXXScopeSpec SS) {
  return reinterpret_cast<clang::CXXScopeSpec *>(SS)->isEmpty();
}

bool clang_CXXScopeSpec_isNotEmpty(CXCXXScopeSpec SS) {
  return reinterpret_cast<clang::CXXScopeSpec *>(SS)->isNotEmpty();
}

bool clang_CXXScopeSpec_isInvalid(CXCXXScopeSpec SS) {
  return reinterpret_cast<clang::CXXScopeSpec *>(SS)->isInvalid();
}

bool clang_CXXScopeSpec_isValid(CXCXXScopeSpec SS) {
  return reinterpret_cast<clang::CXXScopeSpec *>(SS)->isValid();
}