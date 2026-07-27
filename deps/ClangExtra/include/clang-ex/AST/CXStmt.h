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

// subtree: bulk pre-order extraction of S and all (non-null) descendants in a
// single walk, so a whole-subtree traversal costs O(1) FFI round-trips instead
// of one per node. getSubtreeSize counts the nodes; collectSubtree fills two
// caller-allocated buffers of exactly that many slots — the node pointers and
// their CXStmtClass values in lockstep — letting the caller build resolved
// carriers without a per-node getStmtClass call.
size_t clang_Stmt_getSubtreeSize(CXStmt S);

void clang_Stmt_collectSubtree(CXStmt S, CXStmt *Nodes, CXStmtClass *Classes);

// DeclStmt
bool clang_DeclStmt_isSingleDecl(CXDeclStmt DS);

CXDecl clang_DeclStmt_getSingleDecl(CXDeclStmt DS);

// decls: two-call protocol (decl_iterator is forward-only).
size_t clang_DeclStmt_getNumDecls(CXDeclStmt DS);

void clang_DeclStmt_getDecls(CXDeclStmt DS, CXDecl *Buf);

// CompoundStmt
unsigned clang_CompoundStmt_size(CXCompoundStmt CS);

CXStmt clang_CompoundStmt_body_front(CXCompoundStmt CS);

CXStmt clang_CompoundStmt_body_back(CXCompoundStmt CS);

CXSourceLocation_ clang_CompoundStmt_getLBracLoc(CXCompoundStmt CS);

CXSourceLocation_ clang_CompoundStmt_getRBracLoc(CXCompoundStmt CS);

// SwitchCase
CXSwitchCase clang_SwitchCase_getNextSwitchCase(CXSwitchCase SC);

CXStmt clang_SwitchCase_getSubStmt(CXSwitchCase SC);

// CaseStmt
CXExpr clang_CaseStmt_getLHS(CXCaseStmt CS);

CXExpr clang_CaseStmt_getRHS(CXCaseStmt CS);

// LabelStmt
const char *clang_LabelStmt_getName(CXLabelStmt LS);

CXLabelDecl clang_LabelStmt_getDecl(CXLabelStmt LS);

CXStmt clang_LabelStmt_getSubStmt(CXLabelStmt LS);

// IfStmt
CXExpr clang_IfStmt_getCond(CXIfStmt IS);

CXStmt clang_IfStmt_getThen(CXIfStmt IS);

CXStmt clang_IfStmt_getElse(CXIfStmt IS);

bool clang_IfStmt_hasElseStorage(CXIfStmt IS);

bool clang_IfStmt_hasInitStorage(CXIfStmt IS);

bool clang_IfStmt_hasVarStorage(CXIfStmt IS);

CXStmt clang_IfStmt_getInit(CXIfStmt IS);

CXVarDecl clang_IfStmt_getConditionVariable(CXIfStmt IS);

CXSourceLocation_ clang_IfStmt_getIfLoc(CXIfStmt IS);

// SwitchStmt
CXExpr clang_SwitchStmt_getCond(CXSwitchStmt SS);

CXStmt clang_SwitchStmt_getBody(CXSwitchStmt SS);

CXSwitchCase clang_SwitchStmt_getSwitchCaseList(CXSwitchStmt SS);

bool clang_SwitchStmt_isAllEnumCasesCovered(CXSwitchStmt SS);

// WhileStmt
CXExpr clang_WhileStmt_getCond(CXWhileStmt WS);

CXStmt clang_WhileStmt_getBody(CXWhileStmt WS);

CXVarDecl clang_WhileStmt_getConditionVariable(CXWhileStmt WS);

CXSourceLocation_ clang_WhileStmt_getWhileLoc(CXWhileStmt WS);

// DoStmt
CXExpr clang_DoStmt_getCond(CXDoStmt DS);

CXStmt clang_DoStmt_getBody(CXDoStmt DS);

CXSourceLocation_ clang_DoStmt_getDoLoc(CXDoStmt DS);

CXSourceLocation_ clang_DoStmt_getWhileLoc(CXDoStmt DS);

// ForStmt
CXStmt clang_ForStmt_getInit(CXForStmt FS);

CXExpr clang_ForStmt_getCond(CXForStmt FS);

CXExpr clang_ForStmt_getInc(CXForStmt FS);

CXStmt clang_ForStmt_getBody(CXForStmt FS);

CXVarDecl clang_ForStmt_getConditionVariable(CXForStmt FS);

CXSourceLocation_ clang_ForStmt_getForLoc(CXForStmt FS);

// GotoStmt
CXLabelDecl clang_GotoStmt_getLabel(CXGotoStmt GS);

CXSourceLocation_ clang_GotoStmt_getGotoLoc(CXGotoStmt GS);

// ReturnStmt
CXExpr clang_ReturnStmt_getRetValue(CXReturnStmt RS);

// IfStmt
CXSourceLocation_ clang_IfStmt_getElseLoc(CXIfStmt S);

bool clang_IfStmt_isConsteval(CXIfStmt S);

bool clang_IfStmt_isNonNegatedConsteval(CXIfStmt S);

bool clang_IfStmt_isNegatedConsteval(CXIfStmt S);

bool clang_IfStmt_isConstexpr(CXIfStmt S);

bool clang_IfStmt_isObjCAvailabilityCheck(CXIfStmt S);

// optional<Stmt*> crosses by nullptr sentinel (MARSHALLING.md §8): the branch
// a constexpr-if keeps, or null when the statement is not a constexpr-if with
// a known condition — or when the kept branch is an absent else.
CXStmt clang_IfStmt_getNondiscardedCase(CXIfStmt S, CXASTContext Ctx);

CXSourceLocation_ clang_IfStmt_getLParenLoc(CXIfStmt S);

CXSourceLocation_ clang_IfStmt_getRParenLoc(CXIfStmt S);

// SwitchStmt
bool clang_SwitchStmt_hasInitStorage(CXSwitchStmt S);

bool clang_SwitchStmt_hasVarStorage(CXSwitchStmt S);

CXSourceLocation_ clang_SwitchStmt_getSwitchLoc(CXSwitchStmt S);

CXSourceLocation_ clang_SwitchStmt_getLParenLoc(CXSwitchStmt S);

CXSourceLocation_ clang_SwitchStmt_getRParenLoc(CXSwitchStmt S);

// WhileStmt
bool clang_WhileStmt_hasVarStorage(CXWhileStmt S);

CXSourceLocation_ clang_WhileStmt_getLParenLoc(CXWhileStmt S);

CXSourceLocation_ clang_WhileStmt_getRParenLoc(CXWhileStmt S);

// DoStmt
CXSourceLocation_ clang_DoStmt_getRParenLoc(CXDoStmt S);

// ForStmt
CXSourceLocation_ clang_ForStmt_getLParenLoc(CXForStmt S);

CXSourceLocation_ clang_ForStmt_getRParenLoc(CXForStmt S);

// GotoStmt
CXSourceLocation_ clang_GotoStmt_getLabelLoc(CXGotoStmt S);

// IndirectGotoStmt
CXSourceLocation_ clang_IndirectGotoStmt_getGotoLoc(CXIndirectGotoStmt S);

CXSourceLocation_ clang_IndirectGotoStmt_getStarLoc(CXIndirectGotoStmt S);

// ContinueStmt
CXSourceLocation_ clang_ContinueStmt_getContinueLoc(CXContinueStmt S);

// BreakStmt
CXSourceLocation_ clang_BreakStmt_getBreakLoc(CXBreakStmt S);

// ReturnStmt
CXSourceLocation_ clang_ReturnStmt_getReturnLoc(CXReturnStmt S);

// SwitchCase
CXSourceLocation_ clang_SwitchCase_getKeywordLoc(CXSwitchCase S);

CXSourceLocation_ clang_SwitchCase_getColonLoc(CXSwitchCase S);

// CaseStmt
bool clang_CaseStmt_caseStmtIsGNURange(CXCaseStmt S);

CXSourceLocation_ clang_CaseStmt_getCaseLoc(CXCaseStmt S);

CXSourceLocation_ clang_CaseStmt_getEllipsisLoc(CXCaseStmt S);

// DefaultStmt
CXSourceLocation_ clang_DefaultStmt_getDefaultLoc(CXDefaultStmt S);

// LabelStmt
CXSourceLocation_ clang_LabelStmt_getIdentLoc(CXLabelStmt S);

bool clang_LabelStmt_isSideEntry(CXLabelStmt S);

// NullStmt
CXSourceLocation_ clang_NullStmt_getSemiLoc(CXNullStmt S);

bool clang_NullStmt_hasLeadingEmptyMacro(CXNullStmt S);

// CompoundStmt
bool clang_CompoundStmt_body_empty(CXCompoundStmt S);

bool clang_CompoundStmt_hasStoredFPFeatures(CXCompoundStmt S);


LLVM_CLANG_C_EXTERN_C_END

#endif
