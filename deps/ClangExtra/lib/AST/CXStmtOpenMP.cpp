#include "clang-ex/AST/CXStmtOpenMP.h"

#include "clang/AST/StmtOpenMP.h"

unsigned clang_OMPExecutableDirective_getNumClauses(CXStmt S) {
  return reinterpret_cast<clang::OMPExecutableDirective *>(S)->getNumClauses();
}

bool clang_OMPExecutableDirective_isStandaloneDirective(CXStmt S) {
  return reinterpret_cast<clang::OMPExecutableDirective *>(S)->isStandaloneDirective();
}

bool clang_OMPExecutableDirective_hasAssociatedStmt(CXStmt S) {
  return reinterpret_cast<clang::OMPExecutableDirective *>(S)->hasAssociatedStmt();
}

CXStmt clang_OMPExecutableDirective_getAssociatedStmt(CXStmt S) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::OMPExecutableDirective *>(S)->getAssociatedStmt());
}
