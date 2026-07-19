#include "clang-ex/AST/CXStmt.h"
#include "clang/AST/Expr.h"
#include "clang/AST/ExprCXX.h"
#include "clang/AST/ExprConcepts.h"
#include "clang/AST/ExprObjC.h"
#include "clang/AST/ExprOpenMP.h"
#include "clang/AST/Stmt.h"
#include "clang/AST/StmtCXX.h"
#include "clang/AST/StmtObjC.h"
#include "clang/AST/StmtOpenMP.h"

// Drift alarm: the vendored StmtNodes.inc must match the pinned LLVM version.
// One assert per concrete class proves CXStmtClass equals clang's StmtClass
// value-for-value; the count assert catches classes appended at the end
// (which per-class asserts alone would miss).
#define STMT(CLASS, PARENT)                                                                \
  static_assert(static_cast<int>(CXStmtClass_##CLASS##Class) ==                            \
                    static_cast<int>(clang::Stmt::CLASS##Class),                           \
                "CXStmtClass drift: " #CLASS);
#define ABSTRACT_STMT(STMT)
#include "clang-ex/AST/StmtNodes.inc"

namespace {
enum : int {
  CXStmtClassCount = 0
#define STMT(CLASS, PARENT) +1
#define ABSTRACT_STMT(STMT)
#include "clang-ex/AST/StmtNodes.inc"
};
} // namespace
static_assert(CXStmtClassCount == static_cast<int>(clang::Stmt::lastStmtConstant),
              "CXStmtClass drift: vendored StmtNodes.inc is missing classes");

#define STMT(CLASS, PARENT)                                                                \
  CXStmt clang_Stmt_castTo##CLASS(CXStmt S) {                                              \
    return llvm::dyn_cast_or_null<clang::CLASS>(static_cast<clang::Stmt *>(S));            \
  }                                                                                        \
  bool clang_Stmt_is##CLASS(CXStmt S) {                                                    \
    return llvm::isa_and_nonnull<clang::CLASS>(static_cast<clang::Stmt *>(S));             \
  }
#define ABSTRACT_STMT(STMT) STMT
#include "clang-ex/AST/StmtNodes.inc"

CXStmtClass clang_Stmt_getStmtClass(CXStmt S) {
  return static_cast<CXStmtClass>(static_cast<clang::Stmt *>(S)->getStmtClass());
}

const char *clang_Stmt_getStmtClassName(CXStmt S) {
  return static_cast<clang::Stmt *>(S)->getStmtClassName();
}

CXSourceLocation_ clang_Stmt_getBeginLoc(CXStmt S) {
  return static_cast<clang::Stmt *>(S)->getBeginLoc().getPtrEncoding();
}

CXSourceLocation_ clang_Stmt_getEndLoc(CXStmt S) {
  return static_cast<clang::Stmt *>(S)->getEndLoc().getPtrEncoding();
}

CXSourceRange_ clang_Stmt_getSourceRange(CXStmt S) {
  auto rng = static_cast<clang::Stmt *>(S)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

void clang_Stmt_dump(CXStmt S) { return static_cast<clang::Stmt *>(S)->dump(); }

size_t clang_Stmt_getNumChildren(CXStmt S) {
  size_t N = 0;
  for (clang::Stmt *Child : static_cast<clang::Stmt *>(S)->children()) {
    (void)Child;
    ++N;
  }
  return N;
}

void clang_Stmt_getChildren(CXStmt S, CXStmt *Buf) {
  size_t I = 0;
  for (clang::Stmt *Child : static_cast<clang::Stmt *>(S)->children())
    Buf[I++] = Child;
}
