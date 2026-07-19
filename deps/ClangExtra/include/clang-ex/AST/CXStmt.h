#ifndef LLVM_CLANG_C_EXTRA_CXSTMT_H
#define LLVM_CLANG_C_EXTRA_CXSTMT_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// The Stmt hierarchy surface below is stamped from the vendored
// clang-ex/AST/StmtNodes.inc (a verbatim copy of clang's TableGen output for
// the pinned LLVM version). Mirror-by-construction: the same table clang uses
// to build clang::Stmt::StmtClass builds CXStmtClass here, and the impl-side
// static_assert table in CXStmt.cpp proves value-for-value equality, so a
// stale vendored copy fails the build instead of shipping shifted values.
// POLICY: stamped symbols (CXStmtClass_* and the castTo/is families) are
// version-following per LLVM major — clang inserts and renames nodes between
// majors, and lib/<major>/ already models that. They are exempt from the
// frozen-ABI rule that governs hand-written symbols.

// Mirrors clang::Stmt::StmtClass: one enumerator per CONCRETE class, in
// StmtNodes.inc order; abstract classes get none (matching clang).
typedef enum CXStmtClass {
  CXStmtClass_NoStmtClass = 0,
#define STMT(CLASS, PARENT) CXStmtClass_##CLASS##Class,
#define ABSTRACT_STMT(STMT)
#include "clang-ex/AST/StmtNodes.inc"
} CXStmtClass;

// Null-safe downcast (dyn_cast_or_null: nullptr on wrong kind or null input)
// and kind predicate for every class in the hierarchy, ABSTRACT bases
// included (clang_Stmt_castToExpr is the most-used downcast in any tool).
// Stamped functions take and return plain CXStmt.
#define STMT(CLASS, PARENT)                                                                \
  CXStmt clang_Stmt_castTo##CLASS(CXStmt S);                                               \
  bool clang_Stmt_is##CLASS(CXStmt S);
#define ABSTRACT_STMT(STMT) STMT
#include "clang-ex/AST/StmtNodes.inc"

// Stmt base API (hand-written).
CXStmtClass clang_Stmt_getStmtClass(CXStmt S);

const char *clang_Stmt_getStmtClassName(CXStmt S);

CXSourceLocation_ clang_Stmt_getBeginLoc(CXStmt S);

CXSourceLocation_ clang_Stmt_getEndLoc(CXStmt S);

CXSourceRange_ clang_Stmt_getSourceRange(CXStmt S);

void clang_Stmt_dump(CXStmt S);

// children: two-call protocol. getNumChildren walks Stmt::children() to count
// (child_iterator is not a contiguous array); getChildren fills a
// caller-allocated buffer of exactly that many CXStmt slots. Slots can be
// null for some node kinds (clang's child ranges may contain null sub-exprs),
// though most nodes compact absent optionals away.
size_t clang_Stmt_getNumChildren(CXStmt S);

void clang_Stmt_getChildren(CXStmt S, CXStmt *Buf);

LLVM_CLANG_C_EXTERN_C_END

#endif
