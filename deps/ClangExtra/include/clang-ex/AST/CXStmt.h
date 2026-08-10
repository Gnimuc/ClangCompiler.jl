#ifndef LLVM_CLANG_C_EXTRA_CXSTMT_H
#define LLVM_CLANG_C_EXTRA_CXSTMT_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "clang-ex/Basic/CXCapturedStmt.h"
#include "clang-ex/Basic/CXSpecifiers.h"

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
// Each cast returns the class's own handle, so narrowing is checked by the compiler at
// every call site rather than asserted by the caller.
#define STMT(CLASS, PARENT)                                                                \
  CX##CLASS clang_Stmt_castTo##CLASS(CXStmt S);                                            \
  bool clang_Stmt_is##CLASS(CXStmt S);
#define ABSTRACT_STMT(STMT) STMT
#include "clang-ex/AST/StmtNodes.inc"

// Stmt base API (hand-written).
CXStmtClass clang_Stmt_getStmtClass(CXStmt S);

const char *clang_Stmt_getStmtClassName(CXStmt S);

CXSourceLocation_ clang_Stmt_getBeginLoc(CXStmt S);

CXSourceLocation_ clang_Stmt_getEndLoc(CXStmt S);

CXSourceRange_ clang_Stmt_getSourceRange(CXStmt S);

// The tree clang_Stmt_dump writes to stderr, captured as a string instead.
CXString clang_Stmt_dumpToString(CXStmt S, CXASTContext Ctx);

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

// IfStmt
// PARTIAL: clang::IfStmt::setInit/setElse assert hasInitStorage()/hasElseStorage()
// — the trailing-object slot only exists when the statement was allocated with
// that storage. The shim is total by contract, so the Julia wrapper restates the
// precondition (Invariant 3).
void clang_IfStmt_setInit(CXIfStmt S, CXStmt Init);

void clang_IfStmt_setCond(CXIfStmt S, CXExpr Cond);

void clang_IfStmt_setThen(CXIfStmt S, CXStmt Then);

void clang_IfStmt_setElse(CXIfStmt S, CXStmt Else);

// Null when the statement has no condition-variable storage.
CXDeclStmt clang_IfStmt_getConditionVariableDeclStmt(CXIfStmt S);

// SwitchStmt
// Null when the statement has no init / condition-variable storage.
CXStmt clang_SwitchStmt_getInit(CXSwitchStmt S);

CXVarDecl clang_SwitchStmt_getConditionVariable(CXSwitchStmt S);

CXDeclStmt clang_SwitchStmt_getConditionVariableDeclStmt(CXSwitchStmt S);

// PARTIAL: clang::SwitchStmt::setInit asserts hasInitStorage().
void clang_SwitchStmt_setInit(CXSwitchStmt S, CXStmt Init);

void clang_SwitchStmt_setCond(CXSwitchStmt S, CXExpr Cond);

void clang_SwitchStmt_setBody(CXSwitchStmt S, CXStmt Body);

// WhileStmt
void clang_WhileStmt_setCond(CXWhileStmt S, CXExpr Cond);

void clang_WhileStmt_setBody(CXWhileStmt S, CXStmt Body);

// DoStmt
void clang_DoStmt_setCond(CXDoStmt S, CXExpr Cond);

void clang_DoStmt_setBody(CXDoStmt S, CXStmt Body);

// ForStmt
void clang_ForStmt_setInit(CXForStmt S, CXStmt Init);

void clang_ForStmt_setCond(CXForStmt S, CXExpr Cond);

void clang_ForStmt_setInc(CXForStmt S, CXExpr Inc);

void clang_ForStmt_setBody(CXForStmt S, CXStmt Body);

// AttributedStmt
CXStmt clang_AttributedStmt_getSubStmt(CXAttributedStmt S);

// Source location of the leading attribute.
CXSourceLocation_ clang_AttributedStmt_getAttrLoc(CXAttributedStmt S);

// Attributes applied to the statement (count + fill; slots are non-null). Buf
// must hold clang_AttributedStmt_getNumAttrs(S) elements.
unsigned clang_AttributedStmt_getNumAttrs(CXAttributedStmt S);

void clang_AttributedStmt_getAttrs(CXAttributedStmt S, CXAttr *Buf);

// AsmStmt
// The AsmStmt-level accessors dispatch internally to the GCCAsmStmt/MSAsmStmt
// subclass (clang::AsmStmt is abstract and has exactly those two), so they are
// total on any real AsmStmt.
CXSourceLocation_ clang_AsmStmt_getAsmLoc(CXAsmStmt S);

bool clang_AsmStmt_isSimple(CXAsmStmt S);

bool clang_AsmStmt_isVolatile(CXAsmStmt S);

// Assembled final IR asm string.
CXString clang_AsmStmt_generateAsmString(CXAsmStmt S, CXASTContext Ctx);

unsigned clang_AsmStmt_getNumOutputs(CXAsmStmt S);

// Precondition: I < clang_AsmStmt_getNumOutputs(S). The operand accessors
// index the constraint/expression arrays unchecked.
CXString clang_AsmStmt_getOutputConstraint(CXAsmStmt S, unsigned I);

// Precondition: I < clang_AsmStmt_getNumOutputs(S).
CXExpr clang_AsmStmt_getOutputExpr(CXAsmStmt S, unsigned I);

// Precondition: I < clang_AsmStmt_getNumOutputs(S). True when output I carries
// a "+" (read/write) constraint rather than "=".
bool clang_AsmStmt_isOutputPlusConstraint(CXAsmStmt S, unsigned I);

// Number of output operands carrying a "+" constraint.
unsigned clang_AsmStmt_getNumPlusOperands(CXAsmStmt S);

unsigned clang_AsmStmt_getNumInputs(CXAsmStmt S);

// Precondition: I < clang_AsmStmt_getNumInputs(S).
CXString clang_AsmStmt_getInputConstraint(CXAsmStmt S, unsigned I);

// Precondition: I < clang_AsmStmt_getNumInputs(S).
CXExpr clang_AsmStmt_getInputExpr(CXAsmStmt S, unsigned I);

unsigned clang_AsmStmt_getNumClobbers(CXAsmStmt S);

// Precondition: I < clang_AsmStmt_getNumClobbers(S).
CXString clang_AsmStmt_getClobber(CXAsmStmt S, unsigned I);

// GCCAsmStmt
CXStringLiteral clang_GCCAsmStmt_getAsmString(CXGCCAsmStmt S);

// Symbolic [name] of an operand, empty when it has none.
// Precondition: I < clang_AsmStmt_getNumOutputs(S).
CXString clang_GCCAsmStmt_getOutputName(CXGCCAsmStmt S, unsigned I);

// Precondition: I < clang_AsmStmt_getNumInputs(S).
CXString clang_GCCAsmStmt_getInputName(CXGCCAsmStmt S, unsigned I);

bool clang_GCCAsmStmt_isAsmGoto(CXGCCAsmStmt S);

unsigned clang_GCCAsmStmt_getNumLabels(CXGCCAsmStmt S);

CXSourceLocation_ clang_GCCAsmStmt_getRParenLoc(CXGCCAsmStmt S);

// Labels of an `asm goto`. Precondition: I < clang_GCCAsmStmt_getNumLabels(S) —
// the label slots sit past the output/input operands and are indexed unchecked.
CXAddrLabelExpr clang_GCCAsmStmt_getLabelExpr(CXGCCAsmStmt S, unsigned I);

// Precondition: I < clang_GCCAsmStmt_getNumLabels(S).
CXString clang_GCCAsmStmt_getLabelName(CXGCCAsmStmt S, unsigned I);

// Index of the operand carrying this symbolic [name], or -1 when none does.
int clang_GCCAsmStmt_getNamedOperand(CXGCCAsmStmt S, const char *SymbolicName);

// Precondition: I < clang_AsmStmt_getNumInputs(S).
void clang_GCCAsmStmt_setInputExpr(CXGCCAsmStmt S, unsigned I, CXExpr E);

// StringLiteral / IdentifierInfo AST nodes behind an operand's constraint and
// its symbolic [name]. Identifier accessors return a NULL handle for operands
// with no symbolic name.
// Precondition: I < clang_AsmStmt_getNumOutputs(S).
CXIdentifierInfo clang_GCCAsmStmt_getOutputIdentifier(CXGCCAsmStmt S, unsigned I);

// Precondition: I < clang_AsmStmt_getNumOutputs(S).
CXStringLiteral clang_GCCAsmStmt_getOutputConstraintLiteral(CXGCCAsmStmt S, unsigned I);

// Precondition: I < clang_AsmStmt_getNumInputs(S).
CXIdentifierInfo clang_GCCAsmStmt_getInputIdentifier(CXGCCAsmStmt S, unsigned I);

// Precondition: I < clang_AsmStmt_getNumInputs(S).
CXStringLiteral clang_GCCAsmStmt_getInputConstraintLiteral(CXGCCAsmStmt S, unsigned I);

// Precondition: I < clang_GCCAsmStmt_getNumLabels(S).
CXIdentifierInfo clang_GCCAsmStmt_getLabelIdentifier(CXGCCAsmStmt S, unsigned I);

// Precondition: I < clang_AsmStmt_getNumClobbers(S).
CXStringLiteral clang_GCCAsmStmt_getClobberStringLiteral(CXGCCAsmStmt S, unsigned I);

// MSAsmStmt
CXString clang_MSAsmStmt_getAsmString(CXMSAsmStmt S);

bool clang_MSAsmStmt_hasBraces(CXMSAsmStmt S);

CXSourceLocation_ clang_MSAsmStmt_getLBraceLoc(CXMSAsmStmt S);

// ValueStmt
// Innermost expression of a value statement, walking through label/attributed
// wrappers to the underlying expression; an Expr returns itself. Total on any
// ValueStmt (Expr/LabelStmt/AttributedStmt).
CXExpr clang_ValueStmt_getExprStmt(CXValueStmt S);

// CompoundStmt
// GNU statement-expression result: the last non-null child statement, or a null
// handle when the body is empty (total, no precondition).
CXStmt clang_CompoundStmt_getStmtExprResult(CXCompoundStmt S);

// IndirectGotoStmt
CXExpr clang_IndirectGotoStmt_getTarget(CXIndirectGotoStmt S);

// Null unless the indirect goto's target is a constant `&&label`.
CXLabelDecl clang_IndirectGotoStmt_getConstantTarget(CXIndirectGotoStmt S);

// ReturnStmt
// Null unless the return statement has NRVO-candidate storage.
CXVarDecl clang_ReturnStmt_getNRVOCandidate(CXReturnStmt S);

// SEHTryStmt
bool clang_SEHTryStmt_getIsCXXTry(CXSEHTryStmt S);

CXSourceLocation_ clang_SEHTryStmt_getTryLoc(CXSEHTryStmt S);

CXCompoundStmt clang_SEHTryStmt_getTryBlock(CXSEHTryStmt S);

// Base Stmt* handle for the sole handler (an SEHExceptStmt or SEHFinallyStmt);
// resolve on the Julia side.
CXStmt clang_SEHTryStmt_getHandler(CXSEHTryStmt S);

// helper: clang::SEHTryStmt::getExceptHandler is defined out-of-line in Stmt.cpp
// and is NOT exported from clang-cpp, so this reimplements it as a dyn_cast over
// the header-inline getHandler(). Null when the __try has a __finally handler.
CXSEHExceptStmt clang_SEHTryStmt_getExceptHandler(CXSEHTryStmt S);

// helper: reimplements the un-exported clang::SEHTryStmt::getFinallyHandler as a
// dyn_cast over getHandler(). Null when the __try has a __except handler.
CXSEHFinallyStmt clang_SEHTryStmt_getFinallyHandler(CXSEHTryStmt S);

// SEHExceptStmt
CXSourceLocation_ clang_SEHExceptStmt_getExceptLoc(CXSEHExceptStmt S);

CXExpr clang_SEHExceptStmt_getFilterExpr(CXSEHExceptStmt S);

CXCompoundStmt clang_SEHExceptStmt_getBlock(CXSEHExceptStmt S);

// SEHFinallyStmt
CXSourceLocation_ clang_SEHFinallyStmt_getFinallyLoc(CXSEHFinallyStmt S);

CXCompoundStmt clang_SEHFinallyStmt_getBlock(CXSEHFinallyStmt S);

// SEHLeaveStmt
CXSourceLocation_ clang_SEHLeaveStmt_getLeaveLoc(CXSEHLeaveStmt S);

// WhileStmt
// Faux DeclStmt for a `while (T v = ...)` condition variable; null when the loop
// has no condition-variable storage (total, no precondition).
CXDeclStmt clang_WhileStmt_getConditionVariableDeclStmt(CXWhileStmt S);

// ForStmt
// Faux DeclStmt for a `for (...; T v = ...; ...)` condition variable; null when
// the loop has none (total, no precondition).
CXDeclStmt clang_ForStmt_getConditionVariableDeclStmt(CXForStmt S);

// CapturedStmt
// Base Stmt* handle for the captured statement; resolve on the Julia side.
CXStmt clang_CapturedStmt_getCapturedStmt(CXCapturedStmt S);

CXCapturedDecl clang_CapturedStmt_getCapturedDecl(CXCapturedStmt S);

CXRecordDecl clang_CapturedStmt_getCapturedRecordDecl(CXCapturedStmt S);

// Number of captures, including an implicit `this`.
unsigned clang_CapturedStmt_capture_size(CXCapturedStmt S);

// True if Var is captured by this region.
bool clang_CapturedStmt_capturesVariable(CXCapturedStmt S, CXVarDecl Var);

// Stmt
// Mirrors clang::Stmt::Likelihood (clang/AST/Stmt.h): the [[likely]]/[[unlikely]]
// attribute a branch carries. LH_Unlikely is -1, so the mirror's underlying type
// is int rather than the usual unsigned.
typedef enum CXLikelihood {
  CXLikelihood_LH_Unlikely = -1,
  CXLikelihood_LH_None,
  CXLikelihood_LH_Likely
} CXLikelihood;

// getLikelihood(ArrayRef<const Attr *>) overload: the likelihood carried by an explicit
// attribute list. LH_None when the list holds neither [[likely]] nor [[unlikely]], the
// empty list included. Attrs is a borrowed (ptr, count) input array (MARSHALLING.md
// section 11); its slots must be non-null.
CXLikelihood clang_Stmt_getLikelihoodOfAttrs(const CXAttr *Attrs, unsigned NumAttrs);

// Likelihood of a branch, read from the [[likely]]/[[unlikely]] attribute of an
// AttributedStmt. Total: LH_None for every other statement kind and for null.
CXLikelihood clang_Stmt_getLikelihood(CXStmt S);

// The [[likely]]/[[unlikely]] Attr itself, or null when the statement carries
// none. Total (dyn_cast_or_null internally).
CXAttr clang_Stmt_getLikelihoodAttr(CXStmt S);

// getLikelihood(const Stmt *Then, const Stmt *Else) overload: likelihood of the `then`
// branch of an if statement. The `else` branch takes part because two branches specifying
// the same likelihood cancel out. Total on a null Then or Else.
CXLikelihood clang_Stmt_getLikelihoodOfBranches(CXStmt Then, CXStmt Else);

// Whether the two branches of an if statement carry conflicting likelihood attributes.
// clang returns a std::tuple<bool, const Attr *, const Attr *>, which crosses as the bool
// return plus two out-params (MARSHALLING.md section 7). *ThenAttr / *ElseAttr are always
// written: the branch's likelihood attribute, or null when it carries none. Total on a
// null Then or Else; both out-params must be non-null.
bool clang_Stmt_determineLikelihoodConflict(CXStmt Then, CXStmt Else, CXAttr *ThenAttr,
                                            CXAttr *ElseAttr);

// Unique reproducible identifier of this node within Ctx's allocator.
int64_t clang_Stmt_getID(CXStmt S, CXASTContext Ctx);

// Stmt::dumpPretty writes the pretty-printed statement to llvm::errs().
void clang_Stmt_dumpPretty(CXStmt S, CXASTContext Ctx);

// Stmt::printPretty rendered into a string (clang writes it to a raw_ostream).
// The policy is Ctx's own getPrintingPolicy(), the PrinterHelper is null and the
// newline symbol is "\n".
CXString clang_Stmt_printPretty(CXStmt S, CXASTContext Ctx, unsigned Indentation);

// Stmt::printJson rendered into a string; same policy source as printPretty.
// Note clang's printJson is the pretty-printed text JSON-escaped (optionally
// quoted), not a structured node dump.
CXString clang_Stmt_printJson(CXStmt S, CXASTContext Ctx, bool AddQuotes);

// Skip no-op container statements (attributed, and single-statement compound) at
// the top, plus a leading CapturedStmt when IgnoreCaptured is true.
CXStmt clang_Stmt_IgnoreContainers(CXStmt S, bool IgnoreCaptured);

// Skip leading label/attributed wrappers down to the statement they label.
CXStmt clang_Stmt_stripLabelLikeStatements(CXStmt S);

// DeclStmt
// The declaration group encoding behind the statement (value type, crosses as its
// opaque pointer like every other DeclGroupRef).
CXDeclGroupRef clang_DeclStmt_getDeclGroup(CXDeclStmt S);

// NullStmt
void clang_NullStmt_setSemiLoc(CXNullStmt S, CXSourceLocation_ Loc);

// SwitchCase
void clang_SwitchCase_setKeywordLoc(CXSwitchCase S, CXSourceLocation_ Loc);

void clang_SwitchCase_setColonLoc(CXSwitchCase S, CXSourceLocation_ Loc);

// CaseStmt
void clang_CaseStmt_setLHS(CXCaseStmt S, CXExpr Val);

// PARTIAL: clang::CaseStmt::setRHS asserts caseStmtIsGNURange() — the trailing
// slot holding the range end exists only on a `case LHS ... RHS:` statement. The
// shim is total by contract, so the Julia wrapper restates the precondition
// (Invariant 3).
void clang_CaseStmt_setRHS(CXCaseStmt S, CXExpr Val);

void clang_CaseStmt_setSubStmt(CXCaseStmt S, CXStmt Sub);

// DefaultStmt
void clang_DefaultStmt_setSubStmt(CXDefaultStmt S, CXStmt Sub);

// LabelStmt
void clang_LabelStmt_setSubStmt(CXLabelStmt S, CXStmt Sub);

// ContinueStmt
void clang_ContinueStmt_setContinueLoc(CXContinueStmt S, CXSourceLocation_ Loc);

// BreakStmt
void clang_BreakStmt_setBreakLoc(CXBreakStmt S, CXSourceLocation_ Loc);

// ReturnStmt
void clang_ReturnStmt_setRetValue(CXReturnStmt S, CXExpr E);

// DeclStmt
void clang_DeclStmt_setStartLoc(CXDeclStmt S, CXSourceLocation_ Loc);

void clang_DeclStmt_setEndLoc(CXDeclStmt S, CXSourceLocation_ Loc);

// CompoundStmt
// PARTIAL: clang::CompoundStmt::getStoredFPFeatures asserts hasStoredFPFeatures()
// — the trailing FPOptionsOverride slot exists only on a compound statement whose
// body changed the floating-point options. The shim is total by contract, so the
// Julia wrapper restates the precondition (Invariant 3). The override crosses as
// its opaque integer encoding (MARSHALLING.md §7): the FPOptions bits in the high
// half, the override mask in the low half — so the value is nonzero whenever the
// slot exists.
uint64_t clang_CompoundStmt_getStoredFPFeatures(CXCompoundStmt S);

// IfStmt
void clang_IfStmt_setIfLoc(CXIfStmt S, CXSourceLocation_ Loc);

// PARTIAL: clang::IfStmt::setElseLoc asserts hasElseStorage() — the trailing
// SourceLocation slot exists only when the statement was allocated with else
// storage. The shim is total by contract, so the Julia wrapper restates the
// precondition (Invariant 3).
void clang_IfStmt_setElseLoc(CXIfStmt S, CXSourceLocation_ Loc);

void clang_IfStmt_setLParenLoc(CXIfStmt S, CXSourceLocation_ Loc);

void clang_IfStmt_setRParenLoc(CXIfStmt S, CXSourceLocation_ Loc);

// SwitchStmt
void clang_SwitchStmt_setSwitchLoc(CXSwitchStmt S, CXSourceLocation_ Loc);

void clang_SwitchStmt_setLParenLoc(CXSwitchStmt S, CXSourceLocation_ Loc);

void clang_SwitchStmt_setRParenLoc(CXSwitchStmt S, CXSourceLocation_ Loc);

// One-way flag: records that the switch is over an enum whose every enumerator has
// an explicit case. clang ships no setter for the false state.
void clang_SwitchStmt_setAllEnumCasesCovered(CXSwitchStmt S);

// WhileStmt
void clang_WhileStmt_setWhileLoc(CXWhileStmt S, CXSourceLocation_ Loc);

void clang_WhileStmt_setLParenLoc(CXWhileStmt S, CXSourceLocation_ Loc);

void clang_WhileStmt_setRParenLoc(CXWhileStmt S, CXSourceLocation_ Loc);

// DoStmt
void clang_DoStmt_setDoLoc(CXDoStmt S, CXSourceLocation_ Loc);

void clang_DoStmt_setWhileLoc(CXDoStmt S, CXSourceLocation_ Loc);

void clang_DoStmt_setRParenLoc(CXDoStmt S, CXSourceLocation_ Loc);

// ForStmt
void clang_ForStmt_setForLoc(CXForStmt S, CXSourceLocation_ Loc);

void clang_ForStmt_setLParenLoc(CXForStmt S, CXSourceLocation_ Loc);

void clang_ForStmt_setRParenLoc(CXForStmt S, CXSourceLocation_ Loc);

// CapturedStmt
// Mirrors clang::CapturedStmt::VariableCaptureKind (clang/AST/Stmt.h): the form
// in which one entity enters a captured region.
typedef enum CXVariableCaptureKind {
  CXVariableCaptureKind_VCK_This,
  CXVariableCaptureKind_VCK_ByRef,
  CXVariableCaptureKind_VCK_ByCopy,
  CXVariableCaptureKind_VCK_VLAType
} CXVariableCaptureKind;

CXCapturedRegionKind clang_CapturedStmt_getCapturedRegionKind(CXCapturedStmt S);

void clang_CapturedStmt_setCapturedRegionKind(CXCapturedStmt S, CXCapturedRegionKind Kind);

// Capture I of the region. capture_begin is a random-access `Capture *`, so this
// is the count+index half of MARSHALLING.md 6 against clang_CapturedStmt_capture_size.
// The handle borrows into the statement's trailing capture array; do not dispose.
// Precondition: I < clang_CapturedStmt_capture_size(S).
CXCapturedStmtCapture clang_CapturedStmt_getCapture(CXCapturedStmt S, unsigned I);

// Initializer of capture I - the expression stored into the closure record field
// for that capture. Precondition: I < clang_CapturedStmt_capture_size(S).
CXExpr clang_CapturedStmt_getCaptureInit(CXCapturedStmt S, unsigned I);

// CapturedStmt::Capture (clang/AST/Stmt.h) - borrowed, interior to the CapturedStmt
CXVariableCaptureKind clang_CapturedStmtCapture_getCaptureKind(CXCapturedStmtCapture C);

CXSourceLocation_ clang_CapturedStmtCapture_getLocation(CXCapturedStmtCapture C);

bool clang_CapturedStmtCapture_capturesThis(CXCapturedStmtCapture C);

bool clang_CapturedStmtCapture_capturesVariable(CXCapturedStmtCapture C);

bool clang_CapturedStmtCapture_capturesVariableByCopy(CXCapturedStmtCapture C);

bool clang_CapturedStmtCapture_capturesVariableArrayType(CXCapturedStmtCapture C);

// PARTIAL: clang::CapturedStmt::Capture::getCapturedVar is documented "only valid
// if this capture captures a variable" and its out-of-line body asserts that; a
// 'this' capture holds no VarDecl. The shim is total by contract, so the Julia
// wrapper restates the precondition (Invariant 3).
CXVarDecl clang_CapturedStmtCapture_getCapturedVar(CXCapturedStmtCapture C);

// LabelStmt
void clang_LabelStmt_setIdentLoc(CXLabelStmt S, CXSourceLocation_ Loc);

void clang_LabelStmt_setDecl(CXLabelStmt S, CXLabelDecl D);

void clang_LabelStmt_setSideEntry(CXLabelStmt S, bool SE);

// GotoStmt
void clang_GotoStmt_setLabel(CXGotoStmt S, CXLabelDecl D);

void clang_GotoStmt_setGotoLoc(CXGotoStmt S, CXSourceLocation_ Loc);

void clang_GotoStmt_setLabelLoc(CXGotoStmt S, CXSourceLocation_ Loc);

// IndirectGotoStmt
void clang_IndirectGotoStmt_setGotoLoc(CXIndirectGotoStmt S, CXSourceLocation_ Loc);

void clang_IndirectGotoStmt_setStarLoc(CXIndirectGotoStmt S, CXSourceLocation_ Loc);

void clang_IndirectGotoStmt_setTarget(CXIndirectGotoStmt S, CXExpr E);

// DeclStmt
void clang_DeclStmt_setDeclGroup(CXDeclStmt S, CXDeclGroupRef DG);

// SwitchCase
void clang_SwitchCase_setNextSwitchCase(CXSwitchCase S, CXSwitchCase Next);

// CaseStmt
void clang_CaseStmt_setCaseLoc(CXCaseStmt S, CXSourceLocation_ Loc);

// PARTIAL: clang::CaseStmt::setEllipsisLoc asserts caseStmtIsGNURange() — the
// trailing SourceLocation slot is allocated only for the GNU-extension form
// `case LHS ... RHS`. The shim is total by contract, so the Julia wrapper
// restates the precondition (Invariant 3) against
// clang_CaseStmt_caseStmtIsGNURange.
void clang_CaseStmt_setEllipsisLoc(CXCaseStmt S, CXSourceLocation_ Loc);

// DefaultStmt
void clang_DefaultStmt_setDefaultLoc(CXDefaultStmt S, CXSourceLocation_ Loc);

// IfStmt
// PARTIAL: clang::IfStmt::setConditionVariableDeclStmt asserts hasVarStorage()
// — the trailing condition-variable slot exists only when the statement was
// allocated with variable storage. The shim is total by contract, so the Julia
// wrapper restates the precondition (Invariant 3).
void clang_IfStmt_setConditionVariableDeclStmt(CXIfStmt S, CXDeclStmt CondVar);

void clang_IfStmt_setStatementKind(CXIfStmt S, CXIfStatementKind Kind);

CXIfStatementKind clang_IfStmt_getStatementKind(CXIfStmt S);

// SwitchStmt
// PARTIAL: clang::SwitchStmt::setConditionVariableDeclStmt asserts
// hasVarStorage(); see clang_IfStmt_setConditionVariableDeclStmt.
void clang_SwitchStmt_setConditionVariableDeclStmt(CXSwitchStmt S, CXDeclStmt CondVar);

void clang_SwitchStmt_setSwitchCaseList(CXSwitchStmt S, CXSwitchCase First);

// WhileStmt
// PARTIAL: clang::WhileStmt::setConditionVariableDeclStmt asserts
// hasVarStorage(); see clang_IfStmt_setConditionVariableDeclStmt.
void clang_WhileStmt_setConditionVariableDeclStmt(CXWhileStmt S, CXDeclStmt CondVar);

// ForStmt
// Total: a ForStmt always owns the condition-variable slot (SubExprs[CONDVAR]),
// so unlike the If/Switch/While overloads this one carries no precondition.
void clang_ForStmt_setConditionVariableDeclStmt(CXForStmt S, CXDeclStmt CondVar);

// ReturnStmt
void clang_ReturnStmt_setReturnLoc(CXReturnStmt S, CXSourceLocation_ Loc);

// AsmStmt
void clang_AsmStmt_setAsmLoc(CXAsmStmt S, CXSourceLocation_ Loc);

void clang_AsmStmt_setSimple(CXAsmStmt S, bool V);

void clang_AsmStmt_setVolatile(CXAsmStmt S, bool V);

// GCCAsmStmt
void clang_GCCAsmStmt_setRParenLoc(CXGCCAsmStmt S, CXSourceLocation_ Loc);

// SEHLeaveStmt
void clang_SEHLeaveStmt_setLeaveLoc(CXSEHLeaveStmt S, CXSourceLocation_ Loc);

// CapturedStmt
void clang_CapturedStmt_setCapturedDecl(CXCapturedStmt S, CXCapturedDecl D);

// clang::CapturedStmt::setCapturedRecordDecl asserts a non-null argument; the
// Julia wrapper's @check_ptrs already rejects that case.
void clang_CapturedStmt_setCapturedRecordDecl(CXCapturedStmt S, CXRecordDecl D);

// Stmt
// Same as clang::Stmt::dump, but forces colour highlighting on: writes the AST
// subtree rooted at S to llvm::errs().
void clang_Stmt_dumpColor(CXStmt S);

// Stmt::printPrettyControlled rendered into a string. Identical to
// clang_Stmt_printPretty except that a control-flow body is wrapped in braces and
// indented as a nested block. Same sources as printPretty: Ctx's own
// getPrintingPolicy(), a null PrinterHelper and "\n" as the newline symbol.
CXString clang_Stmt_printPrettyControlled(CXStmt S, CXASTContext Ctx, unsigned Indentation);

// helper: clang::Stmt::Profile fills an llvm::FoldingSetNodeID, which has no CX
// handle — MARSHALLING.md section 7 (expose the useful scalar, not the aggregate).
// This runs the profile into a local ID and returns its hash, so two statements
// with the same structural profile compare equal. It is a hash: equal profiles
// always agree, distinct ones agree only on a collision.
unsigned clang_Stmt_getProfileHash(CXStmt S, CXASTContext Ctx, bool Canonical,
                                   bool ProfileLambdaExpr);

// GCCAsmStmt
void clang_GCCAsmStmt_setAsmString(CXGCCAsmStmt S, CXStringLiteral E);

// MSAsmStmt
// Number of raw preprocessor tokens making up the __asm block.
unsigned clang_MSAsmStmt_getNumAsmToks(CXMSAsmStmt S);

// Token I of the block, borrowed from the statement's own token array — the
// count+index half of MARSHALLING.md section 6 against
// clang_MSAsmStmt_getNumAsmToks. Do not dispose it.
// Precondition: I < clang_MSAsmStmt_getNumAsmToks(S) — the array pointer is null
// when the statement carries no tokens.
CXToken_ clang_MSAsmStmt_getAsmTok(CXMSAsmStmt S, unsigned I);

void clang_MSAsmStmt_setLBraceLoc(CXMSAsmStmt S, CXSourceLocation_ L);

void clang_MSAsmStmt_setEndLoc(CXMSAsmStmt S, CXSourceLocation_ L);

// Precondition: I < clang_AsmStmt_getNumInputs(S) — the operand array is indexed
// unchecked, like every other MSAsmStmt operand accessor.
void clang_MSAsmStmt_setInputExpr(CXMSAsmStmt S, unsigned I, CXExpr E);

// ReturnStmt
// PARTIAL: clang::ReturnStmt::setNRVOCandidate asserts hasNRVOCandidate() — the
// trailing NRVO slot exists only when the statement was built with a candidate.
// That predicate is private in clang 18, so no accessor can export the gate
// (MARSHALLING.md section 13); the observable proxy is a non-null
// clang_ReturnStmt_getNRVOCandidate, which the Julia wrapper asserts on.
void clang_ReturnStmt_setNRVOCandidate(CXReturnStmt S, CXVarDecl Var);

// --- Statement factories (clang/AST/Stmt.h) ---
// Every Create/CreateEmpty below allocates in Ctx's ASTContext arena: the node is
// owned by the context, has no dispose, and dies with the context.
// CreateEmpty builds the shell ASTStmtReader deserializes into, so the trailing
// sub-statement slots it allocates are left UNINITIALIZED by clang (MARSHALLING.md
// section 13) -- each one must be filled through its setter before anything reads
// it. The per-class comments below name the slots concerned.

// CompoundStmt
// The NumStmts body slots, and the trailing FPOptionsOverride when HasFPFeatures,
// are uninitialized; NumStmts == 0 with HasFPFeatures false is the only shape whose
// body and stored FP features may be read straight away. The brace locations are
// default-constructed invalid.
CXCompoundStmt clang_CompoundStmt_CreateEmpty(CXASTContext Ctx, unsigned NumStmts,
                                              bool HasFPFeatures);

// CaseStmt
// `case LHS:` when RHS is null, the GNU range form `case LHS ... RHS:` otherwise --
// only the range form allocates the ellipsis slot, which is exactly what
// clang_CaseStmt_caseStmtIsGNURange then reports, and EllipsisLoc is ignored when
// RHS is null.
CXCaseStmt clang_CaseStmt_Create(CXASTContext Ctx, CXExpr LHS, CXExpr RHS,
                                 CXSourceLocation_ CaseLoc, CXSourceLocation_ EllipsisLoc,
                                 CXSourceLocation_ ColonLoc);

// The LHS and sub-statement slots -- plus RHS when CaseStmtIsGNURange -- are
// uninitialized; fill them with clang_CaseStmt_setLHS / setSubStmt / setRHS.
CXCaseStmt clang_CaseStmt_CreateEmpty(CXASTContext Ctx, bool CaseStmtIsGNURange);

// IfStmt
// Init, Var and Else are optional (pass null to leave one out); each non-null one
// allocates its trailing slot, so hasInitStorage/hasVarStorage/hasElseStorage
// afterwards report exactly which arguments were non-null. Cond and Then are
// mandatory. EL is stored only when Else is non-null.
CXIfStmt clang_IfStmt_Create(CXASTContext Ctx, CXSourceLocation_ IL, CXIfStatementKind Kind,
                             CXStmt Init, CXVarDecl Var, CXExpr Cond, CXSourceLocation_ LPL,
                             CXSourceLocation_ RPL, CXStmt Then, CXSourceLocation_ EL,
                             CXStmt Else);

// The cond/then/else/init slots are uninitialized; fill them with
// clang_IfStmt_setCond / setThen / setElse / setInit.
CXIfStmt clang_IfStmt_CreateEmpty(CXASTContext Ctx, bool HasElse, bool HasVar,
                                  bool HasInit);

// PARTIAL: clang::IfStmt::setConditionVariable asserts hasVarStorage() -- it builds
// a faux DeclStmt around V into the trailing condition-variable slot, which exists
// only when the statement was allocated with variable storage. The shim is total by
// contract, so the Julia wrapper restates the precondition (Invariant 3).
void clang_IfStmt_setConditionVariable(CXIfStmt S, CXASTContext Ctx, CXVarDecl V);

// SwitchStmt
// Init and Var are optional (pass null to leave one out); each non-null one
// allocates its trailing slot. The body is not an argument -- store it with
// clang_SwitchStmt_setBody before reading clang_SwitchStmt_getBody.
CXSwitchStmt clang_SwitchStmt_Create(CXASTContext Ctx, CXStmt Init, CXVarDecl Var,
                                     CXExpr Cond, CXSourceLocation_ LParenLoc,
                                     CXSourceLocation_ RParenLoc);

// The init/cond/var/body slots are uninitialized; fill them with
// clang_SwitchStmt_setInit / setCond / setConditionVariable / setBody. The case list
// starts out empty (FirstCase is default-initialized to null).
CXSwitchStmt clang_SwitchStmt_CreateEmpty(CXASTContext Ctx, bool HasInit, bool HasVar);

// PARTIAL: asserts hasVarStorage(), exactly like clang_IfStmt_setConditionVariable.
void clang_SwitchStmt_setConditionVariable(CXSwitchStmt S, CXASTContext Ctx, CXVarDecl VD);

// Prepend SC to the switch's case list. PARTIAL: clang asserts SC is not already
// linked into a switch, i.e. that clang_SwitchCase_getNextSwitchCase(SC) is null.
void clang_SwitchStmt_addSwitchCase(CXSwitchStmt S, CXSwitchCase SC);

// WhileStmt
// Var is optional (pass null to leave it out); a non-null one allocates the
// trailing condition-variable slot, which hasVarStorage then reports.
CXWhileStmt clang_WhileStmt_Create(CXASTContext Ctx, CXVarDecl Var, CXExpr Cond,
                                   CXStmt Body, CXSourceLocation_ WL,
                                   CXSourceLocation_ LParenLoc,
                                   CXSourceLocation_ RParenLoc);

// The cond/var/body slots are uninitialized; fill them with clang_WhileStmt_setCond
// / setConditionVariable / setBody.
CXWhileStmt clang_WhileStmt_CreateEmpty(CXASTContext Ctx, bool HasVar);

// PARTIAL: asserts hasVarStorage(), exactly like clang_IfStmt_setConditionVariable.
void clang_WhileStmt_setConditionVariable(CXWhileStmt S, CXASTContext Ctx, CXVarDecl V);

// ForStmt
// Total: a ForStmt always owns the condition-variable slot (SubExprs[CONDVAR]), so
// unlike the If/Switch/While overloads this one carries no precondition.
void clang_ForStmt_setConditionVariable(CXForStmt S, CXASTContext Ctx, CXVarDecl V);

// ReturnStmt
// NRVOCandidate is optional (pass null to leave it out); only a non-null one
// allocates the trailing NRVO slot that clang_ReturnStmt_getNRVOCandidate reads.
CXReturnStmt clang_ReturnStmt_Create(CXASTContext Ctx, CXSourceLocation_ RL, CXExpr E,
                                     CXVarDecl NRVOCandidate);

// The return-value slot is uninitialized; fill it with clang_ReturnStmt_setRetValue.
// Pass HasNRVOCandidate false: with true the trailing NRVO slot is uninitialized as
// well and libclangex exposes no setter for it, because clang::ReturnStmt's only
// filler (setNRVOCandidate) is gated on a hasNRVOCandidate() that is private in
// clang 18 -- so clang_ReturnStmt_getNRVOCandidate would read uninitialized memory.
CXReturnStmt clang_ReturnStmt_CreateEmpty(CXASTContext Ctx, bool HasNRVOCandidate);

// SEHExceptStmt
// Block must be a CompoundStmt: clang::SEHExceptStmt::getBlock casts it
// unconditionally. The handle is typed CXCompoundStmt to say so, and the Julia
// wrapper types the parameter so dispatch enforces it.
CXSEHExceptStmt clang_SEHExceptStmt_Create(CXASTContext Ctx, CXSourceLocation_ ExceptLoc,
                                           CXExpr FilterExpr, CXCompoundStmt Block);

// SEHFinallyStmt
// Block must be a CompoundStmt; see clang_SEHExceptStmt_Create.
CXSEHFinallyStmt clang_SEHFinallyStmt_Create(CXASTContext Ctx, CXSourceLocation_ FinallyLoc,
                                             CXCompoundStmt Block);

// SEHTryStmt
// TryBlock must be a CompoundStmt (clang::SEHTryStmt::getTryBlock casts it), and
// Handler must be a non-null SEHExceptStmt or SEHFinallyStmt -- getEndLoc
// dereferences it and getExceptHandler/getFinallyHandler dyn_cast it.
CXSEHTryStmt clang_SEHTryStmt_Create(CXASTContext Ctx, bool IsCXXTry,
                                     CXSourceLocation_ TryLoc, CXCompoundStmt TryBlock,
                                     CXStmt Handler);

// CompoundStmt
// `{ Stmts... }` with the given brace locations. Stmts is a (buffer, count) pair
// rebuilt as an ArrayRef (MARSHALLING.md section 11) and copied into the node's
// trailing storage, so the buffer need not outlive the call and NumStmts may be 0.
// FPFeatures is the FPOptionsOverride opaque integer encoding that
// clang_CompoundStmt_getStoredFPFeatures reads back — pass 0 for "no override",
// the only value that leaves clang_CompoundStmt_hasStoredFPFeatures false.
CXCompoundStmt clang_CompoundStmt_Create(CXASTContext Ctx, const CXStmt *Stmts,
                                         unsigned NumStmts, uint64_t FPFeatures,
                                         CXSourceLocation_ LB, CXSourceLocation_ RB);

// AttributedStmt
// PARTIAL: clang::AttributedStmt::Create requires a non-empty attribute list. Attrs
// is a (buffer, count) pair rebuilt as an ArrayRef (MARSHALLING.md section 11) and
// copied into the node's trailing storage, so the buffer need not outlive the call.
CXAttributedStmt clang_AttributedStmt_Create(CXASTContext Ctx, CXSourceLocation_ Loc,
                                             const CXAttr *Attrs, unsigned NumAttrs,
                                             CXStmt SubStmt);

// The NumAttrs attribute slots are null-filled by clang and the attribute location is
// default-constructed invalid, but the SUB-STATEMENT slot is left uninitialized
// (MARSHALLING.md section 13) and can never be filled: clang::AttributedStmt keeps
// SubStmt private with only ASTStmtReader as a friend, so libclangex can export no setter
// for it. Only clang_AttributedStmt_getAttrLoc / getNumAttrs / getAttrs are readable on a
// shell built this way -- getSubStmt would read uninitialized memory.
CXAttributedStmt clang_AttributedStmt_CreateEmpty(CXASTContext Ctx, unsigned NumAttrs);

// GCCAsmStmt::AsmStringPiece (clang/AST/Stmt.h)
// clang::GCCAsmStmt::AnalyzeAsmString decomposes the asm string into literal text and
// operand references, filling a caller-owned SmallVector -- unlike every other AST range
// there is no arena storage to borrow. The two-call protocol below (MARSHALLING.md
// section 6) therefore hands back heap-boxed COPIES of the pieces, each of which the
// caller releases with clang_GCCAsmStmtAsmStringPiece_dispose.

// Number of pieces the asm string decomposes into. *DiagID receives clang's own
// AnalyzeAsmString return value -- 0 when the string decomposes cleanly, nonzero when
// clang rejects it -- and *DiagOffs the byte offset into the asm string the complaint
// points at; either out-param may be null. A rejected string still reports however many
// pieces clang built before it stopped.
unsigned clang_GCCAsmStmt_getNumAsmStringPieces(CXGCCAsmStmt S, CXASTContext Ctx,
                                                unsigned *DiagID, unsigned *DiagOffs);

// Fills Buf with exactly clang_GCCAsmStmt_getNumAsmStringPieces(S, Ctx, 0, 0) pieces; the
// analysis is deterministic, so the counting call and this one always agree.
void clang_GCCAsmStmt_getAsmStringPieces(CXGCCAsmStmt S, CXASTContext Ctx,
                                         CXGCCAsmStmtAsmStringPiece *Buf);

void clang_GCCAsmStmtAsmStringPiece_dispose(CXGCCAsmStmtAsmStringPiece P);

bool clang_GCCAsmStmtAsmStringPiece_isString(CXGCCAsmStmtAsmStringPiece P);

bool clang_GCCAsmStmtAsmStringPiece_isOperand(CXGCCAsmStmtAsmStringPiece P);

// Literal text of a string piece, or the operand-reference text of an operand piece.
CXString clang_GCCAsmStmtAsmStringPiece_getString(CXGCCAsmStmtAsmStringPiece P);

// PARTIAL: clang::GCCAsmStmt::AsmStringPiece::getOperandNo asserts isOperand(). The shim
// is total by contract, so the Julia wrapper restates the precondition (Invariant 3).
unsigned clang_GCCAsmStmtAsmStringPiece_getOperandNo(CXGCCAsmStmtAsmStringPiece P);

// PARTIAL: getRange asserts isOperand() as well. AnalyzeAsmString only ever builds
// character ranges, so only the endpoints cross (MARSHALLING.md section 7).
CXSourceRange_ clang_GCCAsmStmtAsmStringPiece_getRange(CXGCCAsmStmtAsmStringPiece P);

// Modifier letter of an operand reference (the `c` of `%c0`), or '\0' when it carries
// none. PARTIAL: clang documents this as the modifier of an operand, so the Julia wrapper
// restates isOperand() like the two accessors above.
char clang_GCCAsmStmtAsmStringPiece_getModifier(CXGCCAsmStmtAsmStringPiece P);

// CompoundStmt
// Body statement I. clang::CompoundStmt::body_begin is a random-access `Stmt **`
// into the node's own trailing storage, so this is the count+index half of
// MARSHALLING.md section 6 against clang_CompoundStmt_size -- the O(1) counterpart
// of the generic clang_Stmt_getNumChildren / getChildren fill, which walks the child
// range and allocates a buffer to reach one element.
// Precondition: I < clang_CompoundStmt_size(CS).
CXStmt clang_CompoundStmt_getBodyStmt(CXCompoundStmt CS, unsigned I);

// DeclStmt
// Declaration I of the group. clang::DeclStmt::decl_begin is a DeclGroupRef::iterator,
// i.e. a random-access `Decl **` (a single-declaration group indexes its inline slot at
// 0), so this is the count+index half of MARSHALLING.md section 6 against
// clang_DeclStmt_getNumDecls, next to the count+fill clang_DeclStmt_getDecls.
// Precondition: I < clang_DeclStmt_getNumDecls(DS).
CXDecl clang_DeclStmt_getDecl(CXDeclStmt DS, unsigned I);

// Stmt
// Static member function: no receiver. Bumps the per-class statistics counter that
// clang_Stmt_PrintStats reports, completing the trio with clang_Stmt_EnableStatistics.
// Total for every CXStmtClass value: clang indexes a table sized by the last stmt
// constant, and initializes it on first use.
void clang_Stmt_addStmtClass(CXStmtClass SC);

// helper: clang::Stmt::ProcessODRHash fills an llvm::FoldingSetNodeID, which has no CX
// handle -- MARSHALLING.md section 7 (expose the useful scalar, not the aggregate). This
// runs the pointer-free ODR profile into a local ID plus a local clang::ODRHash and
// returns the ID's hash, so two statements that are ODR-equivalent compare equal. It is a
// hash: equal profiles always agree, distinct ones agree only on a collision. Unlike
// clang_Stmt_getProfileHash it needs no ASTContext (pointer identity is never used), and
// unlike the cached clang_FunctionDecl_getODRHash it recomputes on every call.
unsigned clang_Stmt_getODRHash(CXStmt S);

// CapturedStmt::Capture
// A clang::CapturedStmt::Capture is a by-value class with no pointer form, so a
// caller-built one is heap-boxed here and released with
// clang_CapturedStmtCapture_dispose. Handles from clang_CapturedStmt_getCapture
// instead borrow into the statement's trailing array and must NOT be disposed -- the
// same handle type carries both, as clang_CompilerInvocation_create vs getInvocation
// already does.
// PARTIAL: the kind and the variable must agree -- VCK_ByRef and VCK_ByCopy name a
// variable, VCK_This and VCK_VLAType take a null one. Every downstream accessor
// (capturesVariable, getCapturedVar) assumes that pairing, so the Julia wrapper
// restates it (Invariant 3).
CXCapturedStmtCapture clang_CapturedStmtCapture_create(CXSourceLocation_ Loc,
                                                       CXVariableCaptureKind Kind,
                                                       CXVarDecl Var);

void clang_CapturedStmtCapture_dispose(CXCapturedStmtCapture C);

// CapturedStmt
// Build the captured region Kind around statement S, outlined into CD with RD as the
// record of captured variables. The Capture values behind the handle buffer and the
// CaptureInits pointers are copied into the node's ASTContext-arena storage, so neither
// buffer need outlive the call and the caller still owns (and must dispose) its Capture
// boxes. One count governs both buffers: clang stores exactly one initializer per
// capture. S, CD and RD must all be non-null -- clang's constructor asserts each. This
// is the (handle-buffer, count) input form of MARSHALLING.md section 11.
CXCapturedStmt clang_CapturedStmt_Create(CXASTContext Ctx, CXStmt S,
                                         CXCapturedRegionKind Kind,
                                         const CXCapturedStmtCapture *Captures,
                                         const CXExpr *CaptureInits, unsigned NumCaptures,
                                         CXCapturedDecl CD, CXRecordDecl RD);

// The empty shell clang deserializes into. The NumCaptures capture slots and their
// initializers are left UNINITIALIZED (MARSHALLING.md section 13); only the captured
// statement slot is nulled by the shell constructor. Just clang_CapturedStmt_capture_size
// and clang_CapturedStmt_getCapturedStmt may be read on a shell built this way --
// clang_CapturedStmt_getCapture and getCaptureInit would read uninitialized memory.
CXCapturedStmt clang_CapturedStmt_CreateDeserialized(CXASTContext Ctx,
                                                     unsigned NumCaptures);

// GCCAsmStmt
// Build the GCC-style inline-assembly statement from its operand arrays.
// clang::GCCAsmStmt has a public constructor and no Create, so this is the (ptr, count)
// input form of MARSHALLING.md section 11 with the counts spelled out rather than
// derived; the node is arena-allocated with a placement new and every array is copied
// into that same arena, so no buffer need outlive the call and there is no dispose.
//
// Buffer lengths, which clang reads unchecked: Names and Exprs hold
// NumOutputs + NumInputs + NumLabels entries -- the label operands sit past the
// output/input ones, the layout clang_GCCAsmStmt_getLabelExpr indexes -- while
// Constraints holds NumOutputs + NumInputs and Clobbers holds NumClobbers. A Names slot
// may be NULL (that operand carries no symbolic [name]); AsmStr and every Constraints,
// Clobbers and Exprs slot are dereferenced by the accessors and must not be. A label's
// Exprs slot must be a clang::AddrLabelExpr -- getLabelExpr casts it unchecked.
CXGCCAsmStmt clang_GCCAsmStmt_Create(CXASTContext Ctx, CXSourceLocation_ AsmLoc,
                                     bool IsSimple, bool IsVolatile, unsigned NumOutputs,
                                     unsigned NumInputs, const CXIdentifierInfo *Names,
                                     const CXStringLiteral *Constraints,
                                     const CXExpr *Exprs, CXStringLiteral AsmStr,
                                     unsigned NumClobbers, const CXStringLiteral *Clobbers,
                                     unsigned NumLabels, CXSourceLocation_ RParenLoc);

// MSAsmStmt
// Build the MS-style `__asm { ... }` block from its operand arrays -- also a public
// constructor with no Create, and the only way to reach the MSAsmStmt accessors without
// parsing MS inline asm. Its string operands are StringRefs rather than StringLiteral
// nodes, so constraints and clobbers cross as NUL-terminated C strings (the parallel
// component arrays of MARSHALLING.md section 11), while AsmToks is a buffer of CXToken_
// HANDLES dereferenced here into the contiguous value array clang wants, the same
// nested-value shape as clang_DesignatedInitExpr_ExpandDesignator. clang copies every
// string, token and expression into the node's ASTContext arena, so neither the buffers
// nor the caller's Token boxes need outlive the call.
//
// Buffer lengths, read unchecked: AsmToks holds NumAsmToks entries, Constraints and
// Exprs hold NumOutputs + NumInputs each, Clobbers holds NumClobbers. Every slot is
// dereferenced and must be non-NULL.
CXMSAsmStmt clang_MSAsmStmt_Create(
    CXASTContext Ctx, CXSourceLocation_ AsmLoc, CXSourceLocation_ LBraceLoc, bool IsSimple,
    bool IsVolatile, const CXToken_ *AsmToks, unsigned NumAsmToks, unsigned NumOutputs,
    unsigned NumInputs, const char **Constraints, const CXExpr *Exprs, const char *AsmStr,
    const char **Clobbers, unsigned NumClobbers, CXSourceLocation_ EndLoc);

LLVM_CLANG_C_EXTERN_C_END

#endif
