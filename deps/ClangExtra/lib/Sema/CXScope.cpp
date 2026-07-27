#include "clang-ex/Sema/CXScope.h"
#include "clang/Sema/Scope.h"
#include "clang/AST/DeclBase.h"

unsigned clang_Scope_getFlags(CXScope S) {
  return static_cast<clang::Scope *>(S)->getFlags();
}

CXScope clang_Scope_getFnParent(CXScope S) {
  return static_cast<clang::Scope *>(S)->getFnParent();
}

CXDeclContext clang_Scope_getEntity(CXScope S) {
  return static_cast<clang::Scope *>(S)->getEntity();
}

bool clang_Scope_isTemplateParamScope(CXScope S) {
  return static_cast<clang::Scope *>(S)->isTemplateParamScope();
}

bool clang_Scope_isDeclScope(CXScope S, CXDecl D) {
  return static_cast<clang::Scope *>(S)->isDeclScope(static_cast<clang::Decl *>(D));
}

void clang_Scope_dump(CXScope S) { static_cast<clang::Scope *>(S)->dump(); }

CXScope clang_Scope_getParent(CXScope S) {
  return static_cast<clang::Scope *>(S)->getParent();
}

unsigned clang_Scope_getDepth(CXScope S) {
  return static_cast<clang::Scope *>(S)->getDepth();
}