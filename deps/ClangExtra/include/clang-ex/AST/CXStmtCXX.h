#ifndef LLVM_CLANG_C_EXTRA_CXSTMTCXX_H
#define LLVM_CLANG_C_EXTRA_CXSTMTCXX_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// CXXCatchStmt
CXVarDecl clang_CXXCatchStmt_getExceptionDecl(CXCXXCatchStmt CS);

CXQualType clang_CXXCatchStmt_getCaughtType(CXCXXCatchStmt CS);

CXStmt clang_CXXCatchStmt_getHandlerBlock(CXCXXCatchStmt CS);

// CXXTryStmt
CXCompoundStmt clang_CXXTryStmt_getTryBlock(CXCXXTryStmt TS);

unsigned clang_CXXTryStmt_getNumHandlers(CXCXXTryStmt TS);

CXCXXCatchStmt clang_CXXTryStmt_getHandler(CXCXXTryStmt TS, unsigned i);

// CXXForRangeStmt
CXVarDecl clang_CXXForRangeStmt_getLoopVariable(CXCXXForRangeStmt FRS);

CXExpr clang_CXXForRangeStmt_getRangeInit(CXCXXForRangeStmt FRS);

CXStmt clang_CXXForRangeStmt_getBody(CXCXXForRangeStmt FRS);

CXDeclStmt clang_CXXForRangeStmt_getBeginStmt(CXCXXForRangeStmt FRS);

CXDeclStmt clang_CXXForRangeStmt_getEndStmt(CXCXXForRangeStmt FRS);

// CXXCatchStmt
CXSourceLocation_ clang_CXXCatchStmt_getCatchLoc(CXCXXCatchStmt S);

// CXXTryStmt
CXSourceLocation_ clang_CXXTryStmt_getTryLoc(CXCXXTryStmt S);

// CXXForRangeStmt
CXSourceLocation_ clang_CXXForRangeStmt_getForLoc(CXCXXForRangeStmt S);

CXSourceLocation_ clang_CXXForRangeStmt_getCoawaitLoc(CXCXXForRangeStmt S);

CXSourceLocation_ clang_CXXForRangeStmt_getColonLoc(CXCXXForRangeStmt S);

CXSourceLocation_ clang_CXXForRangeStmt_getRParenLoc(CXCXXForRangeStmt S);

// CXXForRangeStmt
CXStmt clang_CXXForRangeStmt_getInit(CXCXXForRangeStmt FRS);

CXDeclStmt clang_CXXForRangeStmt_getRangeStmt(CXCXXForRangeStmt FRS);

CXExpr clang_CXXForRangeStmt_getCond(CXCXXForRangeStmt FRS);

CXExpr clang_CXXForRangeStmt_getInc(CXCXXForRangeStmt FRS);

CXDeclStmt clang_CXXForRangeStmt_getLoopVarStmt(CXCXXForRangeStmt FRS);

void clang_CXXForRangeStmt_setInit(CXCXXForRangeStmt FRS, CXStmt S);

// Writes the same slot as setRangeStmt. While it holds an expression,
// getRangeStmt()/getRangeInit() would cast that slot to DeclStmt unchecked, so the
// __range declaration statement must be restored before either is called again.
void clang_CXXForRangeStmt_setRangeInit(CXCXXForRangeStmt FRS, CXExpr E);

// getRangeStmt()/getRangeInit() cast the range slot to DeclStmt unchecked, so S
// must be the DeclStmt that declares the implicit __range variable.
void clang_CXXForRangeStmt_setRangeStmt(CXCXXForRangeStmt FRS, CXStmt S);

// getBeginStmt() casts the slot to DeclStmt unchecked; null is accepted.
void clang_CXXForRangeStmt_setBeginStmt(CXCXXForRangeStmt FRS, CXStmt S);

// getEndStmt() casts the slot to DeclStmt unchecked; null is accepted.
void clang_CXXForRangeStmt_setEndStmt(CXCXXForRangeStmt FRS, CXStmt S);

void clang_CXXForRangeStmt_setCond(CXCXXForRangeStmt FRS, CXExpr E);

void clang_CXXForRangeStmt_setInc(CXCXXForRangeStmt FRS, CXExpr E);

// getLoopVarStmt() casts the slot to DeclStmt unchecked and does not accept
// null, so S must be a non-null DeclStmt.
void clang_CXXForRangeStmt_setLoopVarStmt(CXCXXForRangeStmt FRS, CXStmt S);

void clang_CXXForRangeStmt_setBody(CXCXXForRangeStmt FRS, CXStmt S);

// CoroutineBodyStmt
bool clang_CoroutineBodyStmt_hasDependentPromiseType(CXCoroutineBodyStmt CBS);

CXCompoundStmt clang_CoroutineBodyStmt_getBody(CXCoroutineBodyStmt CBS);

CXStmt clang_CoroutineBodyStmt_getPromiseDeclStmt(CXCoroutineBodyStmt CBS);

CXVarDecl clang_CoroutineBodyStmt_getPromiseDecl(CXCoroutineBodyStmt CBS);

CXStmt clang_CoroutineBodyStmt_getInitSuspendStmt(CXCoroutineBodyStmt CBS);

CXStmt clang_CoroutineBodyStmt_getFinalSuspendStmt(CXCoroutineBodyStmt CBS);

CXStmt clang_CoroutineBodyStmt_getExceptionHandler(CXCoroutineBodyStmt CBS);

CXStmt clang_CoroutineBodyStmt_getFallthroughHandler(CXCoroutineBodyStmt CBS);

CXExpr clang_CoroutineBodyStmt_getAllocate(CXCoroutineBodyStmt CBS);

CXExpr clang_CoroutineBodyStmt_getDeallocate(CXCoroutineBodyStmt CBS);

CXStmt clang_CoroutineBodyStmt_getResultDecl(CXCoroutineBodyStmt CBS);

// Casts the stored return-value slot to Expr unchecked. Every CoroutineBodyStmt
// Sema builds fills that slot (a promise type without get_return_object makes
// the coroutine ill-formed and no node is built), so the cast only misfires on a
// hand-constructed node; the slot is private and cannot be probed first.
CXExpr clang_CoroutineBodyStmt_getReturnValueInit(CXCoroutineBodyStmt CBS);

// Null when the coroutine's return statement is absent or carries no value.
CXExpr clang_CoroutineBodyStmt_getReturnValue(CXCoroutineBodyStmt CBS);

CXStmt clang_CoroutineBodyStmt_getReturnStmt(CXCoroutineBodyStmt CBS);

// Null unless the promise type declares get_return_object_on_allocation_failure.
CXStmt clang_CoroutineBodyStmt_getReturnStmtOnAllocFailure(CXCoroutineBodyStmt CBS);

// helper: getParamMoves() exposed as count+index, one move statement per
// parameter of the coroutine. The count is exact and no slot is null.
unsigned clang_CoroutineBodyStmt_getNumParamMoves(CXCoroutineBodyStmt CBS);

// Reads the move array at I unchecked; I < getNumParamMoves required.
CXStmt clang_CoroutineBodyStmt_getParamMove(CXCoroutineBodyStmt CBS, unsigned I);

// helper: childrenExclBody() exposed as count+index — every stored sub-statement
// except the coroutine body itself: the promise declaration, the two suspend points,
// the exception and fallthrough handlers, the frame allocation and deallocation
// calls, the result declaration, the return value and return statements, and the
// parameter moves. Slots may be null; the count is exact. The underlying iterator is
// forward-only, so getChildExclBody re-walks from begin(), but the range is a small
// fixed-size array (MARSHALLING.md section 6's O(n^2) caveat costs nothing here).
unsigned clang_CoroutineBodyStmt_getNumChildrenExclBody(CXCoroutineBodyStmt CBS);

// Reads the sub-statement range at I unchecked; I < getNumChildrenExclBody required.
CXStmt clang_CoroutineBodyStmt_getChildExclBody(CXCoroutineBodyStmt CBS, unsigned I);

// CoreturnStmt
CXSourceLocation_ clang_CoreturnStmt_getKeywordLoc(CXCoreturnStmt CRS);

CXExpr clang_CoreturnStmt_getOperand(CXCoreturnStmt CRS);

CXExpr clang_CoreturnStmt_getPromiseCall(CXCoreturnStmt CRS);

bool clang_CoreturnStmt_isImplicit(CXCoreturnStmt CRS);

void clang_CoreturnStmt_setIsImplicit(CXCoreturnStmt CRS, bool Value);

// MSDependentExistsStmt
// A dependent __if_exists / __if_not_exists block. The parser only builds one under
// -fms-extensions and only when the tested name is dependent; a non-dependent name is
// resolved at parse time and leaves no node behind.
// children
// classof
// getBeginLoc
// getEndLoc
// Covered by the stamped Stmt layer (clang_Stmt_getBeginLoc / clang_Stmt_getEndLoc
// and the clang_Stmt_castTo* family).
CXSourceLocation_ clang_MSDependentExistsStmt_getKeywordLoc(CXMSDependentExistsStmt MSS);

bool clang_MSDependentExistsStmt_isIfExists(CXMSDependentExistsStmt MSS);

bool clang_MSDependentExistsStmt_isIfNotExists(CXMSDependentExistsStmt MSS);

// The extent of getQualifierLoc(). NestedNameSpecifierLoc has no handle of its own, so
// it crosses as its two parts (MARSHALLING.md section 7): the qualifier through
// getQualifier, its written extent here. Invalid when the name is unqualified.
CXSourceRange_ clang_MSDependentExistsStmt_getQualifierRange(CXMSDependentExistsStmt MSS);

// NULL when the tested name is written unqualified.
CXNestedNameSpecifier clang_MSDependentExistsStmt_getQualifier(CXMSDependentExistsStmt MSS);

// getNameInfo() returns by value, so this hands back an owned heap box; release it
// with clang_DeclarationNameInfo_dispose.
CXDeclarationNameInfo clang_MSDependentExistsStmt_getNameInfo(CXMSDependentExistsStmt MSS);

CXCompoundStmt clang_MSDependentExistsStmt_getSubStmt(CXMSDependentExistsStmt MSS);

LLVM_CLANG_C_EXTERN_C_END

#endif
