# Stmt
function getStmtClass(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_getStmtClass(x)
end

function getStmtClassName(x::AbstractStmt)
    @check_ptrs x
    return unsafe_string(clang_Stmt_getStmtClassName(x))
end

function getBeginLoc(x::AbstractStmt)
    @check_ptrs x
    return SourceLocation(clang_Stmt_getBeginLoc(x))
end

function getEndLoc(x::AbstractStmt)
    @check_ptrs x
    return SourceLocation(clang_Stmt_getEndLoc(x))
end

function getSourceRange(x::AbstractStmt)
    @check_ptrs x
    r = clang_Stmt_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

function getNumChildren(x::AbstractStmt)
    @check_ptrs x
    return Int(clang_Stmt_getNumChildren(x))
end

"""
    getChildren(x::AbstractStmt) -> Vector{Stmt}
Return the direct sub-statements. Slots may hold a NULL pointer (e.g. the
missing `else` branch of an `IfStmt` keeps its position).
"""
function getChildren(x::AbstractStmt)
    @check_ptrs x
    n = clang_Stmt_getNumChildren(x)
    buf = Vector{CXStmt}(undef, n)
    n > 0 && clang_Stmt_getChildren(x, buf)
    return [Stmt(p) for p in buf]
end

function EnableStatistics()
    return clang_Stmt_EnableStatistics()
end

function PrintStats()
    return clang_Stmt_PrintStats()
end
# Stmt Cast — one constructor-shaped downcast and one predicate per class in the
# hierarchy (abstract bases included; NULL carrier when the node is another
# class, dyn_cast_or_null semantics). Classes clang itself names `Abstract*`
# have no carrier, so they get only the predicate. Generated from StmtNodes.inc
# into lib/<major>/StmtWrappers.jl.
include("StmtWrappers.jl")

function isSingleDecl(x::AbstractDeclStmt)
    @check_ptrs x
    return clang_DeclStmt_isSingleDecl(x)
end

function getSingleDecl(x::AbstractDeclStmt)
    @check_ptrs x
    return Decl(clang_DeclStmt_getSingleDecl(x))
end

Base.length(x::AbstractCompoundStmt) = (@check_ptrs x; Int(clang_CompoundStmt_size(x)))

function body_front(x::AbstractCompoundStmt)
    @check_ptrs x
    return Stmt(clang_CompoundStmt_body_front(x))
end

function body_back(x::AbstractCompoundStmt)
    @check_ptrs x
    return Stmt(clang_CompoundStmt_body_back(x))
end

function getLBracLoc(x::AbstractCompoundStmt)
    @check_ptrs x
    return SourceLocation(clang_CompoundStmt_getLBracLoc(x))
end

function getRBracLoc(x::AbstractCompoundStmt)
    @check_ptrs x
    return SourceLocation(clang_CompoundStmt_getRBracLoc(x))
end

function getNextSwitchCase(x::AbstractSwitchCase)
    @check_ptrs x
    return SwitchCase(clang_SwitchCase_getNextSwitchCase(x))
end

function getSubStmt(x::AbstractSwitchCase)
    @check_ptrs x
    return Stmt(clang_SwitchCase_getSubStmt(x))
end

function getLHS(x::AbstractCaseStmt)
    @check_ptrs x
    return Expr_(clang_CaseStmt_getLHS(x))
end

function getRHS(x::AbstractCaseStmt)
    @check_ptrs x
    return Expr_(clang_CaseStmt_getRHS(x))
end

function getName(x::AbstractLabelStmt)
    @check_ptrs x
    return unsafe_string(clang_LabelStmt_getName(x))
end

function getDecl(x::AbstractLabelStmt)
    @check_ptrs x
    return LabelDecl(clang_LabelStmt_getDecl(x))
end

function getSubStmt(x::AbstractLabelStmt)
    @check_ptrs x
    return Stmt(clang_LabelStmt_getSubStmt(x))
end

function getCond(x::AbstractIfStmt)
    @check_ptrs x
    return Expr_(clang_IfStmt_getCond(x))
end

function getThen(x::AbstractIfStmt)
    @check_ptrs x
    return Stmt(clang_IfStmt_getThen(x))
end

function getElse(x::AbstractIfStmt)
    @check_ptrs x
    return Stmt(clang_IfStmt_getElse(x))
end

function hasElseStorage(x::AbstractIfStmt)
    @check_ptrs x
    return clang_IfStmt_hasElseStorage(x)
end

function hasInitStorage(x::AbstractIfStmt)
    @check_ptrs x
    return clang_IfStmt_hasInitStorage(x)
end

function hasVarStorage(x::AbstractIfStmt)
    @check_ptrs x
    return clang_IfStmt_hasVarStorage(x)
end

function getInit(x::AbstractIfStmt)
    @check_ptrs x
    return Stmt(clang_IfStmt_getInit(x))
end

function getConditionVariable(x::AbstractIfStmt)
    @check_ptrs x
    return VarDecl(clang_IfStmt_getConditionVariable(x))
end

function getIfLoc(x::AbstractIfStmt)
    @check_ptrs x
    return SourceLocation(clang_IfStmt_getIfLoc(x))
end

function getCond(x::AbstractSwitchStmt)
    @check_ptrs x
    return Expr_(clang_SwitchStmt_getCond(x))
end

function getBody(x::AbstractSwitchStmt)
    @check_ptrs x
    return Stmt(clang_SwitchStmt_getBody(x))
end

function getSwitchCaseList(x::AbstractSwitchStmt)
    @check_ptrs x
    return SwitchCase(clang_SwitchStmt_getSwitchCaseList(x))
end

function isAllEnumCasesCovered(x::AbstractSwitchStmt)
    @check_ptrs x
    return clang_SwitchStmt_isAllEnumCasesCovered(x)
end

function getCond(x::AbstractWhileStmt)
    @check_ptrs x
    return Expr_(clang_WhileStmt_getCond(x))
end

function getBody(x::AbstractWhileStmt)
    @check_ptrs x
    return Stmt(clang_WhileStmt_getBody(x))
end

function getConditionVariable(x::AbstractWhileStmt)
    @check_ptrs x
    return VarDecl(clang_WhileStmt_getConditionVariable(x))
end

function getWhileLoc(x::AbstractWhileStmt)
    @check_ptrs x
    return SourceLocation(clang_WhileStmt_getWhileLoc(x))
end

function getCond(x::AbstractDoStmt)
    @check_ptrs x
    return Expr_(clang_DoStmt_getCond(x))
end

function getBody(x::AbstractDoStmt)
    @check_ptrs x
    return Stmt(clang_DoStmt_getBody(x))
end

function getDoLoc(x::AbstractDoStmt)
    @check_ptrs x
    return SourceLocation(clang_DoStmt_getDoLoc(x))
end

function getWhileLoc(x::AbstractDoStmt)
    @check_ptrs x
    return SourceLocation(clang_DoStmt_getWhileLoc(x))
end

function getInit(x::AbstractForStmt)
    @check_ptrs x
    return Stmt(clang_ForStmt_getInit(x))
end

function getCond(x::AbstractForStmt)
    @check_ptrs x
    return Expr_(clang_ForStmt_getCond(x))
end

function getInc(x::AbstractForStmt)
    @check_ptrs x
    return Expr_(clang_ForStmt_getInc(x))
end

function getBody(x::AbstractForStmt)
    @check_ptrs x
    return Stmt(clang_ForStmt_getBody(x))
end

function getConditionVariable(x::AbstractForStmt)
    @check_ptrs x
    return VarDecl(clang_ForStmt_getConditionVariable(x))
end

function getForLoc(x::AbstractForStmt)
    @check_ptrs x
    return SourceLocation(clang_ForStmt_getForLoc(x))
end

function getLabel(x::AbstractGotoStmt)
    @check_ptrs x
    return LabelDecl(clang_GotoStmt_getLabel(x))
end

function getGotoLoc(x::AbstractGotoStmt)
    @check_ptrs x
    return SourceLocation(clang_GotoStmt_getGotoLoc(x))
end

function getRetValue(x::AbstractReturnStmt)
    @check_ptrs x
    return Expr_(clang_ReturnStmt_getRetValue(x))
end

# IfStmt
function getElseLoc(x::AbstractIfStmt)
    @check_ptrs x
    return SourceLocation(clang_IfStmt_getElseLoc(x))
end

function isConsteval(x::AbstractIfStmt)
    @check_ptrs x
    return clang_IfStmt_isConsteval(x)
end

function isNonNegatedConsteval(x::AbstractIfStmt)
    @check_ptrs x
    return clang_IfStmt_isNonNegatedConsteval(x)
end

function isNegatedConsteval(x::AbstractIfStmt)
    @check_ptrs x
    return clang_IfStmt_isNegatedConsteval(x)
end

function isConstexpr(x::AbstractIfStmt)
    @check_ptrs x
    return clang_IfStmt_isConstexpr(x)
end

function isObjCAvailabilityCheck(x::AbstractIfStmt)
    @check_ptrs x
    return clang_IfStmt_isObjCAvailabilityCheck(x)
end

"""
    getNondiscardedCase(x::AbstractIfStmt, ctx::ASTContext) -> Stmt
Return the branch a constexpr-if keeps. The returned `Stmt` wraps C_NULL when
the statement is not a constexpr-if with a known condition, or when the kept
branch is an absent `else` (the C side collapses `std::optional<Stmt*>` to a
nullptr sentinel).
"""
function getNondiscardedCase(x::AbstractIfStmt, ctx::ASTContext)
    @check_ptrs x ctx
    return Stmt(clang_IfStmt_getNondiscardedCase(x, ctx))
end

function getLParenLoc(x::AbstractIfStmt)
    @check_ptrs x
    return SourceLocation(clang_IfStmt_getLParenLoc(x))
end

function getRParenLoc(x::AbstractIfStmt)
    @check_ptrs x
    return SourceLocation(clang_IfStmt_getRParenLoc(x))
end

# SwitchStmt
function hasInitStorage(x::AbstractSwitchStmt)
    @check_ptrs x
    return clang_SwitchStmt_hasInitStorage(x)
end

function hasVarStorage(x::AbstractSwitchStmt)
    @check_ptrs x
    return clang_SwitchStmt_hasVarStorage(x)
end

function getSwitchLoc(x::AbstractSwitchStmt)
    @check_ptrs x
    return SourceLocation(clang_SwitchStmt_getSwitchLoc(x))
end

function getLParenLoc(x::AbstractSwitchStmt)
    @check_ptrs x
    return SourceLocation(clang_SwitchStmt_getLParenLoc(x))
end

function getRParenLoc(x::AbstractSwitchStmt)
    @check_ptrs x
    return SourceLocation(clang_SwitchStmt_getRParenLoc(x))
end

# WhileStmt
function hasVarStorage(x::AbstractWhileStmt)
    @check_ptrs x
    return clang_WhileStmt_hasVarStorage(x)
end

function getLParenLoc(x::AbstractWhileStmt)
    @check_ptrs x
    return SourceLocation(clang_WhileStmt_getLParenLoc(x))
end

function getRParenLoc(x::AbstractWhileStmt)
    @check_ptrs x
    return SourceLocation(clang_WhileStmt_getRParenLoc(x))
end

# DoStmt
function getRParenLoc(x::AbstractDoStmt)
    @check_ptrs x
    return SourceLocation(clang_DoStmt_getRParenLoc(x))
end

# ForStmt
function getLParenLoc(x::AbstractForStmt)
    @check_ptrs x
    return SourceLocation(clang_ForStmt_getLParenLoc(x))
end

function getRParenLoc(x::AbstractForStmt)
    @check_ptrs x
    return SourceLocation(clang_ForStmt_getRParenLoc(x))
end

# GotoStmt
function getLabelLoc(x::AbstractGotoStmt)
    @check_ptrs x
    return SourceLocation(clang_GotoStmt_getLabelLoc(x))
end

# IndirectGotoStmt
function getGotoLoc(x::AbstractIndirectGotoStmt)
    @check_ptrs x
    return SourceLocation(clang_IndirectGotoStmt_getGotoLoc(x))
end

function getStarLoc(x::AbstractIndirectGotoStmt)
    @check_ptrs x
    return SourceLocation(clang_IndirectGotoStmt_getStarLoc(x))
end

# ContinueStmt
function getContinueLoc(x::AbstractContinueStmt)
    @check_ptrs x
    return SourceLocation(clang_ContinueStmt_getContinueLoc(x))
end

# BreakStmt
function getBreakLoc(x::AbstractBreakStmt)
    @check_ptrs x
    return SourceLocation(clang_BreakStmt_getBreakLoc(x))
end

# ReturnStmt
function getReturnLoc(x::AbstractReturnStmt)
    @check_ptrs x
    return SourceLocation(clang_ReturnStmt_getReturnLoc(x))
end

# SwitchCase
function getKeywordLoc(x::AbstractSwitchCase)
    @check_ptrs x
    return SourceLocation(clang_SwitchCase_getKeywordLoc(x))
end

function getColonLoc(x::AbstractSwitchCase)
    @check_ptrs x
    return SourceLocation(clang_SwitchCase_getColonLoc(x))
end

# CaseStmt
function caseStmtIsGNURange(x::AbstractCaseStmt)
    @check_ptrs x
    return clang_CaseStmt_caseStmtIsGNURange(x)
end

function getCaseLoc(x::AbstractCaseStmt)
    @check_ptrs x
    return SourceLocation(clang_CaseStmt_getCaseLoc(x))
end

function getEllipsisLoc(x::AbstractCaseStmt)
    @check_ptrs x
    return SourceLocation(clang_CaseStmt_getEllipsisLoc(x))
end

# DefaultStmt
function getDefaultLoc(x::AbstractDefaultStmt)
    @check_ptrs x
    return SourceLocation(clang_DefaultStmt_getDefaultLoc(x))
end

# LabelStmt
function getIdentLoc(x::AbstractLabelStmt)
    @check_ptrs x
    return SourceLocation(clang_LabelStmt_getIdentLoc(x))
end

function isSideEntry(x::AbstractLabelStmt)
    @check_ptrs x
    return clang_LabelStmt_isSideEntry(x)
end

# NullStmt
function getSemiLoc(x::AbstractNullStmt)
    @check_ptrs x
    return SourceLocation(clang_NullStmt_getSemiLoc(x))
end

function hasLeadingEmptyMacro(x::AbstractNullStmt)
    @check_ptrs x
    return clang_NullStmt_hasLeadingEmptyMacro(x)
end

# CompoundStmt
function body_empty(x::AbstractCompoundStmt)
    @check_ptrs x
    return clang_CompoundStmt_body_empty(x)
end

function hasStoredFPFeatures(x::AbstractCompoundStmt)
    @check_ptrs x
    return clang_CompoundStmt_hasStoredFPFeatures(x)
end

# DeclStmt
function getNumDecls(x::AbstractDeclStmt)
    @check_ptrs x
    return Int(clang_DeclStmt_getNumDecls(x))
end

"""
    getDecls(x::AbstractDeclStmt) -> Vector{Decl}
Return the declarations introduced by the declaration statement.
"""

function getDecls(x::AbstractDeclStmt)
    @check_ptrs x
    n = clang_DeclStmt_getNumDecls(x)
    buf = Vector{CXDecl}(undef, n)
    n > 0 && clang_DeclStmt_getDecls(x, buf)
    return [Decl(p) for p in buf]
end


# AsmStmt
function getAsmLoc(x::AbstractAsmStmt)
    @check_ptrs x
    return SourceLocation(clang_AsmStmt_getAsmLoc(x))
end

function isSimple(x::AbstractAsmStmt)
    @check_ptrs x
    return clang_AsmStmt_isSimple(x)
end

function isVolatile(x::AbstractAsmStmt)
    @check_ptrs x
    return clang_AsmStmt_isVolatile(x)
end

"""
    generateAsmString(x::AbstractAsmStmt, ctx::ASTContext) -> String
Return the assembled final IR assembly string of the inline-asm statement.
"""
function generateAsmString(x::AbstractAsmStmt, ctx::ASTContext)
    @check_ptrs x ctx
    return get_string(clang_AsmStmt_generateAsmString(x, ctx))
end

function getNumOutputs(x::AbstractAsmStmt)
    @check_ptrs x
    return Int(clang_AsmStmt_getNumOutputs(x))
end

function getNumInputs(x::AbstractAsmStmt)
    @check_ptrs x
    return Int(clang_AsmStmt_getNumInputs(x))
end

function getNumClobbers(x::AbstractAsmStmt)
    @check_ptrs x
    return Int(clang_AsmStmt_getNumClobbers(x))
end

# The operand accessors below index clang's constraint/expression arrays with no
# bounds check, so the range precondition is restated here (Invariant 3).
# Indices are 0-based, matching the C++ API.
function getOutputConstraint(x::AbstractAsmStmt, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumOutputs(x) "output operand index out of range"
    return get_string(clang_AsmStmt_getOutputConstraint(x, i))
end

function getOutputExpr(x::AbstractAsmStmt, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumOutputs(x) "output operand index out of range"
    return Expr_(clang_AsmStmt_getOutputExpr(x, i))
end

function getInputConstraint(x::AbstractAsmStmt, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumInputs(x) "input operand index out of range"
    return get_string(clang_AsmStmt_getInputConstraint(x, i))
end

function getInputExpr(x::AbstractAsmStmt, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumInputs(x) "input operand index out of range"
    return Expr_(clang_AsmStmt_getInputExpr(x, i))
end

function getClobber(x::AbstractAsmStmt, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumClobbers(x) "clobber index out of range"
    return get_string(clang_AsmStmt_getClobber(x, i))
end

# GCCAsmStmt
function getAsmString(x::AbstractGCCAsmStmt)
    @check_ptrs x
    return StringLiteral(clang_GCCAsmStmt_getAsmString(x))
end

"""
    getOutputName(x::AbstractGCCAsmStmt, i::Integer) -> String
Return the symbolic `[name]` of the `i`-th output operand, or an empty string
when the operand has none.
"""
function getOutputName(x::AbstractGCCAsmStmt, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumOutputs(x) "output operand index out of range"
    return get_string(clang_GCCAsmStmt_getOutputName(x, i))
end

"""
    getInputName(x::AbstractGCCAsmStmt, i::Integer) -> String
Return the symbolic `[name]` of the `i`-th input operand, or an empty string
when the operand has none.
"""
function getInputName(x::AbstractGCCAsmStmt, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumInputs(x) "input operand index out of range"
    return get_string(clang_GCCAsmStmt_getInputName(x, i))
end

function isAsmGoto(x::AbstractGCCAsmStmt)
    @check_ptrs x
    return clang_GCCAsmStmt_isAsmGoto(x)
end

function getNumLabels(x::AbstractGCCAsmStmt)
    @check_ptrs x
    return Int(clang_GCCAsmStmt_getNumLabels(x))
end

# MSAsmStmt
function getAsmString(x::AbstractMSAsmStmt)
    @check_ptrs x
    return get_string(clang_MSAsmStmt_getAsmString(x))
end

function hasBraces(x::AbstractMSAsmStmt)
    @check_ptrs x
    return clang_MSAsmStmt_hasBraces(x)
end

function getLBraceLoc(x::AbstractMSAsmStmt)
    @check_ptrs x
    return SourceLocation(clang_MSAsmStmt_getLBraceLoc(x))
end


# IfStmt
"""
    setInit(x::AbstractIfStmt, init::AbstractStmt)
Set the init statement of an `if` statement.

`clang::IfStmt::setInit` asserts the statement was allocated with init storage,
so `hasInitStorage` must hold.
"""
function setInit(x::AbstractIfStmt, init::AbstractStmt)
    @check_ptrs x init
    @assert hasInitStorage(x) "if statement has no storage for an init statement"
    return clang_IfStmt_setInit(x, init)
end

function setCond(x::AbstractIfStmt, cond::AbstractExpr)
    @check_ptrs x cond
    return clang_IfStmt_setCond(x, cond)
end

function setThen(x::AbstractIfStmt, stmt::AbstractStmt)
    @check_ptrs x stmt
    return clang_IfStmt_setThen(x, stmt)
end

"""
    setElse(x::AbstractIfStmt, stmt::AbstractStmt)
Set the `else` branch of an `if` statement.

`clang::IfStmt::setElse` asserts the statement was allocated with else storage,
so `hasElseStorage` must hold.
"""
function setElse(x::AbstractIfStmt, stmt::AbstractStmt)
    @check_ptrs x stmt
    @assert hasElseStorage(x) "if statement has no storage for an else branch"
    return clang_IfStmt_setElse(x, stmt)
end

"""
    getConditionVariableDeclStmt(x::AbstractIfStmt) -> DeclStmt
Return the `DeclStmt` holding the condition variable, or a NULL carrier when the
statement has no condition-variable storage.
"""
function getConditionVariableDeclStmt(x::AbstractIfStmt)
    @check_ptrs x
    return DeclStmt(clang_IfStmt_getConditionVariableDeclStmt(x))
end

# SwitchStmt
"""
    getInit(x::AbstractSwitchStmt) -> Stmt
Return the init statement, or a NULL carrier when there is no init storage.
"""
function getInit(x::AbstractSwitchStmt)
    @check_ptrs x
    return Stmt(clang_SwitchStmt_getInit(x))
end

function getConditionVariable(x::AbstractSwitchStmt)
    @check_ptrs x
    return VarDecl(clang_SwitchStmt_getConditionVariable(x))
end

"""
    getConditionVariableDeclStmt(x::AbstractSwitchStmt) -> DeclStmt
Return the `DeclStmt` holding the condition variable, or a NULL carrier when the
statement has no condition-variable storage.
"""
function getConditionVariableDeclStmt(x::AbstractSwitchStmt)
    @check_ptrs x
    return DeclStmt(clang_SwitchStmt_getConditionVariableDeclStmt(x))
end

"""
    setInit(x::AbstractSwitchStmt, init::AbstractStmt)
Set the init statement of a `switch` statement.

`clang::SwitchStmt::setInit` asserts the statement was allocated with init
storage, so `hasInitStorage` must hold.
"""
function setInit(x::AbstractSwitchStmt, init::AbstractStmt)
    @check_ptrs x init
    @assert hasInitStorage(x) "switch statement has no storage for an init statement"
    return clang_SwitchStmt_setInit(x, init)
end

function setCond(x::AbstractSwitchStmt, cond::AbstractExpr)
    @check_ptrs x cond
    return clang_SwitchStmt_setCond(x, cond)
end

function setBody(x::AbstractSwitchStmt, body::AbstractStmt)
    @check_ptrs x body
    return clang_SwitchStmt_setBody(x, body)
end

# WhileStmt
function setCond(x::AbstractWhileStmt, cond::AbstractExpr)
    @check_ptrs x cond
    return clang_WhileStmt_setCond(x, cond)
end

function setBody(x::AbstractWhileStmt, body::AbstractStmt)
    @check_ptrs x body
    return clang_WhileStmt_setBody(x, body)
end

# DoStmt
function setCond(x::AbstractDoStmt, cond::AbstractExpr)
    @check_ptrs x cond
    return clang_DoStmt_setCond(x, cond)
end

function setBody(x::AbstractDoStmt, body::AbstractStmt)
    @check_ptrs x body
    return clang_DoStmt_setBody(x, body)
end

# ForStmt
function setInit(x::AbstractForStmt, init::AbstractStmt)
    @check_ptrs x init
    return clang_ForStmt_setInit(x, init)
end

function setCond(x::AbstractForStmt, cond::AbstractExpr)
    @check_ptrs x cond
    return clang_ForStmt_setCond(x, cond)
end

function setInc(x::AbstractForStmt, inc::AbstractExpr)
    @check_ptrs x inc
    return clang_ForStmt_setInc(x, inc)
end

function setBody(x::AbstractForStmt, body::AbstractStmt)
    @check_ptrs x body
    return clang_ForStmt_setBody(x, body)
end

# AttributedStmt
function getSubStmt(x::AbstractAttributedStmt)
    @check_ptrs x
    return Stmt(clang_AttributedStmt_getSubStmt(x))
end


function getRParenLoc(x::AbstractGCCAsmStmt)
    @check_ptrs x
    return SourceLocation(clang_GCCAsmStmt_getRParenLoc(x))
end

# The label accessors index clang's label slots with no bounds check, so the
# range precondition is restated here (Invariant 3); a statement that is not an
# `asm goto` has zero labels, which the same assert covers. Indices are 0-based.
function getLabelExpr(x::AbstractGCCAsmStmt, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumLabels(x) "asm goto label index out of range"
    return AddrLabelExpr(clang_GCCAsmStmt_getLabelExpr(x, i))
end

function getLabelName(x::AbstractGCCAsmStmt, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumLabels(x) "asm goto label index out of range"
    return get_string(clang_GCCAsmStmt_getLabelName(x, i))
end

"""
    getNamedOperand(x::AbstractGCCAsmStmt, name::AbstractString) -> Int
Return the 0-based index of the operand carrying the symbolic `[name]`, or `-1`
when no operand has it.
"""
function getNamedOperand(x::AbstractGCCAsmStmt, name::AbstractString)
    @check_ptrs x
    return Int(clang_GCCAsmStmt_getNamedOperand(x, name))
end

function setInputExpr(x::AbstractGCCAsmStmt, i::Integer, e::AbstractExpr)
    @check_ptrs x e
    @assert 0 <= i < getNumInputs(x) "input operand index out of range"
    return clang_GCCAsmStmt_setInputExpr(x, i, e)
end


# ValueStmt
"""
    getExprStmt(x::AbstractValueStmt) -> Expr_

Return the innermost expression of a value statement, walking through label and
attributed wrappers; an expression returns itself.
"""
function getExprStmt(x::AbstractValueStmt)
    @check_ptrs x
    return Expr_(clang_ValueStmt_getExprStmt(x))
end

# CompoundStmt
"""
    getStmtExprResult(x::AbstractCompoundStmt) -> Stmt

Return the result statement of a GNU statement expression: the last non-null
child. The returned carrier holds a null pointer when the body is empty.
"""
function getStmtExprResult(x::AbstractCompoundStmt)
    @check_ptrs x
    return Stmt(clang_CompoundStmt_getStmtExprResult(x))
end

# IndirectGotoStmt
function getTarget(x::AbstractIndirectGotoStmt)
    @check_ptrs x
    return Expr_(clang_IndirectGotoStmt_getTarget(x))
end

"""
    getConstantTarget(x::AbstractIndirectGotoStmt) -> LabelDecl

Return the fixed target label when the indirect goto jumps to a constant
`&&label`; the returned carrier holds a null pointer otherwise.
"""
function getConstantTarget(x::AbstractIndirectGotoStmt)
    @check_ptrs x
    return LabelDecl(clang_IndirectGotoStmt_getConstantTarget(x))
end

# ReturnStmt
"""
    getNRVOCandidate(x::AbstractReturnStmt) -> VarDecl

Return the variable eligible for the named return value optimization; the
returned carrier holds a null pointer when the statement has no NRVO storage.
"""
function getNRVOCandidate(x::AbstractReturnStmt)
    @check_ptrs x
    return VarDecl(clang_ReturnStmt_getNRVOCandidate(x))
end


# SEHTryStmt
function getIsCXXTry(x::AbstractSEHTryStmt)
    @check_ptrs x
    return clang_SEHTryStmt_getIsCXXTry(x)
end

function getTryLoc(x::AbstractSEHTryStmt)
    @check_ptrs x
    return SourceLocation(clang_SEHTryStmt_getTryLoc(x))
end

function getTryBlock(x::AbstractSEHTryStmt)
    @check_ptrs x
    return CompoundStmt(clang_SEHTryStmt_getTryBlock(x))
end

function getHandler(x::AbstractSEHTryStmt)
    @check_ptrs x
    return Stmt(clang_SEHTryStmt_getHandler(x))
end

"""
    getExceptHandler(x::AbstractSEHTryStmt) -> SEHExceptStmt

Return the `__except` handler of this `__try`; the returned carrier holds a null
pointer when the statement has a `__finally` handler instead.
"""
function getExceptHandler(x::AbstractSEHTryStmt)
    @check_ptrs x
    return SEHExceptStmt(clang_SEHTryStmt_getExceptHandler(x))
end

"""
    getFinallyHandler(x::AbstractSEHTryStmt) -> SEHFinallyStmt

Return the `__finally` handler of this `__try`; the returned carrier holds a null
pointer when the statement has a `__except` handler instead.
"""
function getFinallyHandler(x::AbstractSEHTryStmt)
    @check_ptrs x
    return SEHFinallyStmt(clang_SEHTryStmt_getFinallyHandler(x))
end

# SEHExceptStmt
function getExceptLoc(x::AbstractSEHExceptStmt)
    @check_ptrs x
    return SourceLocation(clang_SEHExceptStmt_getExceptLoc(x))
end

function getFilterExpr(x::AbstractSEHExceptStmt)
    @check_ptrs x
    return Expr_(clang_SEHExceptStmt_getFilterExpr(x))
end

function getBlock(x::AbstractSEHExceptStmt)
    @check_ptrs x
    return CompoundStmt(clang_SEHExceptStmt_getBlock(x))
end

# SEHFinallyStmt
function getFinallyLoc(x::AbstractSEHFinallyStmt)
    @check_ptrs x
    return SourceLocation(clang_SEHFinallyStmt_getFinallyLoc(x))
end

function getBlock(x::AbstractSEHFinallyStmt)
    @check_ptrs x
    return CompoundStmt(clang_SEHFinallyStmt_getBlock(x))
end

# SEHLeaveStmt
function getLeaveLoc(x::AbstractSEHLeaveStmt)
    @check_ptrs x
    return SourceLocation(clang_SEHLeaveStmt_getLeaveLoc(x))
end

# WhileStmt
"""
    getConditionVariableDeclStmt(x::AbstractWhileStmt) -> DeclStmt

Return the faux `DeclStmt` created for a `while (T v = ...)` condition variable;
the returned carrier holds a null pointer when the loop has no such storage.
"""
function getConditionVariableDeclStmt(x::AbstractWhileStmt)
    @check_ptrs x
    return DeclStmt(clang_WhileStmt_getConditionVariableDeclStmt(x))
end

# ForStmt
"""
    getConditionVariableDeclStmt(x::AbstractForStmt) -> DeclStmt

Return the faux `DeclStmt` created for a `for (...; T v = ...; ...)` condition
variable; the returned carrier holds a null pointer when the loop has none.
"""
function getConditionVariableDeclStmt(x::AbstractForStmt)
    @check_ptrs x
    return DeclStmt(clang_ForStmt_getConditionVariableDeclStmt(x))
end

# CapturedStmt
function getCapturedStmt(x::AbstractCapturedStmt)
    @check_ptrs x
    return Stmt(clang_CapturedStmt_getCapturedStmt(x))
end

function getCapturedDecl(x::AbstractCapturedStmt)
    @check_ptrs x
    return CapturedDecl(clang_CapturedStmt_getCapturedDecl(x))
end

function getCapturedRecordDecl(x::AbstractCapturedStmt)
    @check_ptrs x
    return RecordDecl(clang_CapturedStmt_getCapturedRecordDecl(x))
end

function capture_size(x::AbstractCapturedStmt)
    @check_ptrs x
    return clang_CapturedStmt_capture_size(x)
end

function capturesVariable(x::AbstractCapturedStmt, Var::AbstractVarDecl)
    @check_ptrs x Var
    return clang_CapturedStmt_capturesVariable(x, Var)
end


# AsmStmt (plus-constraint operands)
function isOutputPlusConstraint(x::AbstractAsmStmt, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumOutputs(x) "output operand index out of range"
    return clang_AsmStmt_isOutputPlusConstraint(x, i)
end

function getNumPlusOperands(x::AbstractAsmStmt)
    @check_ptrs x
    return Int(clang_AsmStmt_getNumPlusOperands(x))
end

# GCCAsmStmt (operand constraint literals and symbolic-name identifiers)
"""
    getOutputIdentifier(x::AbstractGCCAsmStmt, i::Integer) -> IdentifierInfo
Return the `IdentifierInfo` for the symbolic `[name]` of the `i`-th output
operand, or a NULL carrier when the operand has no symbolic name.
"""
function getOutputIdentifier(x::AbstractGCCAsmStmt, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumOutputs(x) "output operand index out of range"
    return IdentifierInfo(clang_GCCAsmStmt_getOutputIdentifier(x, i))
end

function getOutputConstraintLiteral(x::AbstractGCCAsmStmt, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumOutputs(x) "output operand index out of range"
    return StringLiteral(clang_GCCAsmStmt_getOutputConstraintLiteral(x, i))
end

"""
    getInputIdentifier(x::AbstractGCCAsmStmt, i::Integer) -> IdentifierInfo
Return the `IdentifierInfo` for the symbolic `[name]` of the `i`-th input
operand, or a NULL carrier when the operand has no symbolic name.
"""
function getInputIdentifier(x::AbstractGCCAsmStmt, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumInputs(x) "input operand index out of range"
    return IdentifierInfo(clang_GCCAsmStmt_getInputIdentifier(x, i))
end

function getInputConstraintLiteral(x::AbstractGCCAsmStmt, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumInputs(x) "input operand index out of range"
    return StringLiteral(clang_GCCAsmStmt_getInputConstraintLiteral(x, i))
end

"""
    getLabelIdentifier(x::AbstractGCCAsmStmt, i::Integer) -> IdentifierInfo
Return the `IdentifierInfo` naming the `i`-th `asm goto` label.
"""
function getLabelIdentifier(x::AbstractGCCAsmStmt, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumLabels(x) "label index out of range"
    return IdentifierInfo(clang_GCCAsmStmt_getLabelIdentifier(x, i))
end

function getClobberStringLiteral(x::AbstractGCCAsmStmt, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumClobbers(x) "clobber index out of range"
    return StringLiteral(clang_GCCAsmStmt_getClobberStringLiteral(x, i))
end

# AttributedStmt
function getAttrLoc(x::AbstractAttributedStmt)
    @check_ptrs x
    return SourceLocation(clang_AttributedStmt_getAttrLoc(x))
end

function getNumAttrs(x::AbstractAttributedStmt)
    @check_ptrs x
    return Int(clang_AttributedStmt_getNumAttrs(x))
end

"""
    getAttrs(x::AbstractAttributedStmt) -> Vector{Attr}
Return the attributes applied to the statement.
"""
function getAttrs(x::AbstractAttributedStmt)
    @check_ptrs x
    n = clang_AttributedStmt_getNumAttrs(x)
    buf = Vector{CXAttr}(undef, n)
    n > 0 && clang_AttributedStmt_getAttrs(x, buf)
    return [Attr(p) for p in buf]
end


# Stmt (likelihood, node identity, pretty/JSON printing, container skipping)
"""
    getLikelihood(x::AbstractStmt) -> CXLikelihood
Return the `[[likely]]`/`[[unlikely]]` likelihood the statement carries. Only an
`AttributedStmt` can carry one; every other statement reports
`CXLikelihood_LH_None`.
"""
function getLikelihood(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_getLikelihood(x)
end

"""
    getLikelihoodAttr(x::AbstractStmt) -> Attr
Return the `[[likely]]`/`[[unlikely]]` attribute of the statement, or a NULL
carrier when it carries none.
"""
function getLikelihoodAttr(x::AbstractStmt)
    @check_ptrs x
    return Attr(clang_Stmt_getLikelihoodAttr(x))
end

"""
    getID(x::AbstractStmt, ctx::ASTContext) -> Int64
Return a reproducible identifier for the node, unique among the nodes allocated
in `ctx`.
"""
function getID(x::AbstractStmt, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_Stmt_getID(x, ctx)
end

"""
    dumpPretty(x::AbstractStmt, ctx::ASTContext)
Write the pretty-printed statement to `stderr`.
"""
function dumpPretty(x::AbstractStmt, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_Stmt_dumpPretty(x, ctx)
end

"""
    printPretty(x::AbstractStmt, ctx::ASTContext, indentation::Integer=0) -> String
Pretty-print the statement back to source syntax, using `ctx`'s own printing
policy and no `PrinterHelper`.
"""
function printPretty(x::AbstractStmt, ctx::ASTContext, indentation::Integer=0)
    @check_ptrs x ctx
    return get_string(clang_Stmt_printPretty(x, ctx, indentation))
end

"""
    printJson(x::AbstractStmt, ctx::ASTContext, add_quotes::Bool=true) -> String
Return the pretty-printed statement JSON-escaped, wrapped in quotes when
`add_quotes` is true. This is clang's `Stmt::printJson`: an escaped rendering of
the pretty-printed text, not a structured node dump.
"""
function printJson(x::AbstractStmt, ctx::ASTContext, add_quotes::Bool=true)
    @check_ptrs x ctx
    return get_string(clang_Stmt_printJson(x, ctx, add_quotes))
end

"""
    IgnoreContainers(x::AbstractStmt, ignore_captured::Bool=false) -> Stmt
Skip no-op container statements — attributed statements and compound statements
holding exactly one statement — at the top of `x`, and a leading `CapturedStmt`
too when `ignore_captured` is true. Returns `x` itself when nothing is skipped.
"""
function IgnoreContainers(x::AbstractStmt, ignore_captured::Bool=false)
    @check_ptrs x
    return Stmt(clang_Stmt_IgnoreContainers(x, ignore_captured))
end

"""
    stripLabelLikeStatements(x::AbstractStmt) -> Stmt
Skip leading label and attributed wrappers down to the statement they label.
"""
function stripLabelLikeStatements(x::AbstractStmt)
    @check_ptrs x
    return Stmt(clang_Stmt_stripLabelLikeStatements(x))
end

# DeclStmt
"""
    getDeclGroup(x::AbstractDeclStmt) -> DeclGroupRef
Return the declaration group the statement declares.
"""
function getDeclGroup(x::AbstractDeclStmt)
    @check_ptrs x
    return DeclGroupRef(clang_DeclStmt_getDeclGroup(x))
end

# NullStmt
function setSemiLoc(x::AbstractNullStmt, loc::SourceLocation)
    @check_ptrs x
    return clang_NullStmt_setSemiLoc(x, loc)
end

# SwitchCase
function setKeywordLoc(x::AbstractSwitchCase, loc::SourceLocation)
    @check_ptrs x
    return clang_SwitchCase_setKeywordLoc(x, loc)
end

function setColonLoc(x::AbstractSwitchCase, loc::SourceLocation)
    @check_ptrs x
    return clang_SwitchCase_setColonLoc(x, loc)
end

# CaseStmt
function setLHS(x::AbstractCaseStmt, val::AbstractExpr)
    @check_ptrs x val
    return clang_CaseStmt_setLHS(x, val)
end

"""
    setRHS(x::AbstractCaseStmt, val::AbstractExpr)
Set the range end of a GNU `case LHS ... RHS:` statement. Only a case statement
that already is a GNU range has a slot for it — `clang::CaseStmt::setRHS` asserts
`caseStmtIsGNURange()`, so the precondition is restated here.
"""
function setRHS(x::AbstractCaseStmt, val::AbstractExpr)
    @check_ptrs x val
    @assert caseStmtIsGNURange(x) "case statement is not a GNU `case LHS ... RHS:` range"
    return clang_CaseStmt_setRHS(x, val)
end

function setSubStmt(x::AbstractCaseStmt, sub::AbstractStmt)
    @check_ptrs x sub
    return clang_CaseStmt_setSubStmt(x, sub)
end

# DefaultStmt
function setSubStmt(x::AbstractDefaultStmt, sub::AbstractStmt)
    @check_ptrs x sub
    return clang_DefaultStmt_setSubStmt(x, sub)
end

# LabelStmt
function setSubStmt(x::AbstractLabelStmt, sub::AbstractStmt)
    @check_ptrs x sub
    return clang_LabelStmt_setSubStmt(x, sub)
end

# ContinueStmt
function setContinueLoc(x::AbstractContinueStmt, loc::SourceLocation)
    @check_ptrs x
    return clang_ContinueStmt_setContinueLoc(x, loc)
end

# BreakStmt
function setBreakLoc(x::AbstractBreakStmt, loc::SourceLocation)
    @check_ptrs x
    return clang_BreakStmt_setBreakLoc(x, loc)
end

# ReturnStmt
function setRetValue(x::AbstractReturnStmt, e::AbstractExpr)
    @check_ptrs x e
    return clang_ReturnStmt_setRetValue(x, e)
end


# DeclStmt
function setStartLoc(x::AbstractDeclStmt, loc::SourceLocation)
    @check_ptrs x
    return clang_DeclStmt_setStartLoc(x, loc)
end

function setEndLoc(x::AbstractDeclStmt, loc::SourceLocation)
    @check_ptrs x
    return clang_DeclStmt_setEndLoc(x, loc)
end

# CompoundStmt
"""
    getStoredFPFeatures(x::AbstractCompoundStmt) -> UInt64
Return the floating-point options the compound statement overrides, as the opaque
integer encoding of `clang::FPOptionsOverride` — the `FPOptions` bits in the high
half, the override mask in the low half, so the value is nonzero whenever the slot
exists. Only a compound statement whose body changed the floating-point options
carries the slot: `clang::CompoundStmt::getStoredFPFeatures` asserts
`hasStoredFPFeatures()`, so the precondition is restated here.
"""
function getStoredFPFeatures(x::AbstractCompoundStmt)
    @check_ptrs x
    @assert hasStoredFPFeatures(x) "compound statement carries no stored FP features"
    return clang_CompoundStmt_getStoredFPFeatures(x)
end

# IfStmt
function setIfLoc(x::AbstractIfStmt, loc::SourceLocation)
    @check_ptrs x
    return clang_IfStmt_setIfLoc(x, loc)
end

"""
    setElseLoc(x::AbstractIfStmt, loc::SourceLocation)
Set the location of the `else` keyword. Only an if statement allocated with else
storage has a slot for it — `clang::IfStmt::setElseLoc` asserts `hasElseStorage()`,
so the precondition is restated here.
"""
function setElseLoc(x::AbstractIfStmt, loc::SourceLocation)
    @check_ptrs x
    @assert hasElseStorage(x) "if statement has no storage for an else branch"
    return clang_IfStmt_setElseLoc(x, loc)
end

function setLParenLoc(x::AbstractIfStmt, loc::SourceLocation)
    @check_ptrs x
    return clang_IfStmt_setLParenLoc(x, loc)
end

function setRParenLoc(x::AbstractIfStmt, loc::SourceLocation)
    @check_ptrs x
    return clang_IfStmt_setRParenLoc(x, loc)
end

# SwitchStmt
function setSwitchLoc(x::AbstractSwitchStmt, loc::SourceLocation)
    @check_ptrs x
    return clang_SwitchStmt_setSwitchLoc(x, loc)
end

function setLParenLoc(x::AbstractSwitchStmt, loc::SourceLocation)
    @check_ptrs x
    return clang_SwitchStmt_setLParenLoc(x, loc)
end

function setRParenLoc(x::AbstractSwitchStmt, loc::SourceLocation)
    @check_ptrs x
    return clang_SwitchStmt_setRParenLoc(x, loc)
end

"""
    setAllEnumCasesCovered(x::AbstractSwitchStmt)
Record that the switch is over an enum value whose every enumerator has an explicit
case. The flag is one-way — `clang::SwitchStmt` has no setter for the false state.
"""
function setAllEnumCasesCovered(x::AbstractSwitchStmt)
    @check_ptrs x
    return clang_SwitchStmt_setAllEnumCasesCovered(x)
end

# WhileStmt
function setWhileLoc(x::AbstractWhileStmt, loc::SourceLocation)
    @check_ptrs x
    return clang_WhileStmt_setWhileLoc(x, loc)
end

function setLParenLoc(x::AbstractWhileStmt, loc::SourceLocation)
    @check_ptrs x
    return clang_WhileStmt_setLParenLoc(x, loc)
end

function setRParenLoc(x::AbstractWhileStmt, loc::SourceLocation)
    @check_ptrs x
    return clang_WhileStmt_setRParenLoc(x, loc)
end

# DoStmt
function setDoLoc(x::AbstractDoStmt, loc::SourceLocation)
    @check_ptrs x
    return clang_DoStmt_setDoLoc(x, loc)
end

function setWhileLoc(x::AbstractDoStmt, loc::SourceLocation)
    @check_ptrs x
    return clang_DoStmt_setWhileLoc(x, loc)
end

function setRParenLoc(x::AbstractDoStmt, loc::SourceLocation)
    @check_ptrs x
    return clang_DoStmt_setRParenLoc(x, loc)
end

# ForStmt
function setForLoc(x::AbstractForStmt, loc::SourceLocation)
    @check_ptrs x
    return clang_ForStmt_setForLoc(x, loc)
end

function setLParenLoc(x::AbstractForStmt, loc::SourceLocation)
    @check_ptrs x
    return clang_ForStmt_setLParenLoc(x, loc)
end

function setRParenLoc(x::AbstractForStmt, loc::SourceLocation)
    @check_ptrs x
    return clang_ForStmt_setRParenLoc(x, loc)
end


# CapturedStmt
function getCapturedRegionKind(x::AbstractCapturedStmt)
    @check_ptrs x
    return clang_CapturedStmt_getCapturedRegionKind(x)
end

function setCapturedRegionKind(x::AbstractCapturedStmt, kind::CXCapturedRegionKind)
    @check_ptrs x
    return clang_CapturedStmt_setCapturedRegionKind(x, kind)
end

"""
    getCapture(x::AbstractCapturedStmt, i) -> CapturedStmtCapture
Return the `i`-th capture (0-based, following the C++ API). The wrapped pointer
borrows into the statement's capture list; do not dispose it.
"""
function getCapture(x::AbstractCapturedStmt, i::Integer)
    @check_ptrs x
    @assert 0 <= i < capture_size(x) "capture index out of range"
    return CapturedStmtCapture(clang_CapturedStmt_getCapture(x, i))
end

"""
    getCaptureInit(x::AbstractCapturedStmt, i) -> Expr_
Return the initializer of the `i`-th capture (0-based) — the expression stored
into the closure record field for that capture.
"""
function getCaptureInit(x::AbstractCapturedStmt, i::Integer)
    @check_ptrs x
    @assert 0 <= i < capture_size(x) "capture index out of range"
    return Expr_(clang_CapturedStmt_getCaptureInit(x, i))
end

# CapturedStmt::Capture
function getCaptureKind(x::CapturedStmtCapture)
    @check_ptrs x
    return clang_CapturedStmtCapture_getCaptureKind(x)
end

function getLocation(x::CapturedStmtCapture)
    @check_ptrs x
    return SourceLocation(clang_CapturedStmtCapture_getLocation(x))
end

function capturesThis(x::CapturedStmtCapture)
    @check_ptrs x
    return clang_CapturedStmtCapture_capturesThis(x)
end

function capturesVariable(x::CapturedStmtCapture)
    @check_ptrs x
    return clang_CapturedStmtCapture_capturesVariable(x)
end

function capturesVariableByCopy(x::CapturedStmtCapture)
    @check_ptrs x
    return clang_CapturedStmtCapture_capturesVariableByCopy(x)
end

function capturesVariableArrayType(x::CapturedStmtCapture)
    @check_ptrs x
    return clang_CapturedStmtCapture_capturesVariableArrayType(x)
end

"""
    getCapturedVar(x::CapturedStmtCapture) -> VarDecl
Retrieve the variable this capture carries. Clang documents the accessor as valid
only for a capture that captures a variable and asserts that in its out-of-line
body, so a `this` capture is rejected here. A variable-length-array capture is
rejected too: the assertion's exact wording is not visible from the installed
header, so the narrower of the two possible preconditions is enforced.
"""
function getCapturedVar(x::CapturedStmtCapture)
    @check_ptrs x
    @assert capturesVariable(x) || capturesVariableByCopy(x) "capture carries no variable"
    return VarDecl(clang_CapturedStmtCapture_getCapturedVar(x))
end

# LabelStmt
function setIdentLoc(x::AbstractLabelStmt, loc::SourceLocation)
    @check_ptrs x
    return clang_LabelStmt_setIdentLoc(x, loc)
end

function setDecl(x::AbstractLabelStmt, d::AbstractLabelDecl)
    @check_ptrs x d
    return clang_LabelStmt_setDecl(x, d)
end

function setSideEntry(x::AbstractLabelStmt, side_entry::Bool)
    @check_ptrs x
    return clang_LabelStmt_setSideEntry(x, side_entry)
end

# GotoStmt
function setLabel(x::AbstractGotoStmt, d::AbstractLabelDecl)
    @check_ptrs x d
    return clang_GotoStmt_setLabel(x, d)
end

function setGotoLoc(x::AbstractGotoStmt, loc::SourceLocation)
    @check_ptrs x
    return clang_GotoStmt_setGotoLoc(x, loc)
end

function setLabelLoc(x::AbstractGotoStmt, loc::SourceLocation)
    @check_ptrs x
    return clang_GotoStmt_setLabelLoc(x, loc)
end

# IndirectGotoStmt
function setGotoLoc(x::AbstractIndirectGotoStmt, loc::SourceLocation)
    @check_ptrs x
    return clang_IndirectGotoStmt_setGotoLoc(x, loc)
end

function setStarLoc(x::AbstractIndirectGotoStmt, loc::SourceLocation)
    @check_ptrs x
    return clang_IndirectGotoStmt_setStarLoc(x, loc)
end

function setTarget(x::AbstractIndirectGotoStmt, e::AbstractExpr)
    @check_ptrs x e
    return clang_IndirectGotoStmt_setTarget(x, e)
end


# DeclStmt
function setDeclGroup(x::AbstractDeclStmt, dg::AbstractDeclGroupRef)
    @check_ptrs x dg
    return clang_DeclStmt_setDeclGroup(x, dg)
end

# SwitchCase
function setNextSwitchCase(x::AbstractSwitchCase, next::AbstractSwitchCase)
    @check_ptrs x next
    return clang_SwitchCase_setNextSwitchCase(x, next)
end

# CaseStmt
function setCaseLoc(x::AbstractCaseStmt, loc::SourceLocation)
    @check_ptrs x
    return clang_CaseStmt_setCaseLoc(x, loc)
end

"""
    setEllipsisLoc(x::AbstractCaseStmt, loc::SourceLocation)
Set the location of the `...` in a `case LHS ... RHS` statement. Clang asserts
`caseStmtIsGNURange()`: the trailing `SourceLocation` slot is allocated only for that
GNU-extension form, so the precondition is restated here.
"""
function setEllipsisLoc(x::AbstractCaseStmt, loc::SourceLocation)
    @check_ptrs x
    @assert caseStmtIsGNURange(x) "case statement has no storage for an ellipsis location"
    return clang_CaseStmt_setEllipsisLoc(x, loc)
end

# DefaultStmt
function setDefaultLoc(x::AbstractDefaultStmt, loc::SourceLocation)
    @check_ptrs x
    return clang_DefaultStmt_setDefaultLoc(x, loc)
end

# IfStmt
"""
    setConditionVariableDeclStmt(x::AbstractIfStmt, cond_var::AbstractDeclStmt)
Store the faux `DeclStmt` that declares the condition variable of `if (T v = ...)`.
Clang asserts `hasVarStorage()`: the trailing slot exists only when the statement was
allocated with variable storage, so the precondition is restated here.
"""
function setConditionVariableDeclStmt(x::AbstractIfStmt, cond_var::AbstractDeclStmt)
    @check_ptrs x cond_var
    @assert hasVarStorage(x) "if statement has no storage for a condition variable"
    return clang_IfStmt_setConditionVariableDeclStmt(x, cond_var)
end

function setStatementKind(x::AbstractIfStmt, kind::CXIfStatementKind)
    @check_ptrs x
    return clang_IfStmt_setStatementKind(x, kind)
end

"""
    getStatementKind(x::AbstractIfStmt) -> CXIfStatementKind
Return whether this is an ordinary `if`, an `if constexpr`, an `if consteval` or an
`if ! consteval`.
"""
function getStatementKind(x::AbstractIfStmt)
    @check_ptrs x
    return clang_IfStmt_getStatementKind(x)
end

# SwitchStmt
"""
    setConditionVariableDeclStmt(x::AbstractSwitchStmt, cond_var::AbstractDeclStmt)
Store the faux `DeclStmt` that declares the condition variable of `switch (T v = ...)`.
Clang asserts `hasVarStorage()`, so the precondition is restated here.
"""
function setConditionVariableDeclStmt(x::AbstractSwitchStmt, cond_var::AbstractDeclStmt)
    @check_ptrs x cond_var
    @assert hasVarStorage(x) "switch statement has no storage for a condition variable"
    return clang_SwitchStmt_setConditionVariableDeclStmt(x, cond_var)
end

function setSwitchCaseList(x::AbstractSwitchStmt, first::AbstractSwitchCase)
    @check_ptrs x first
    return clang_SwitchStmt_setSwitchCaseList(x, first)
end

# WhileStmt
"""
    setConditionVariableDeclStmt(x::AbstractWhileStmt, cond_var::AbstractDeclStmt)
Store the faux `DeclStmt` that declares the condition variable of `while (T v = ...)`.
Clang asserts `hasVarStorage()`, so the precondition is restated here.
"""
function setConditionVariableDeclStmt(x::AbstractWhileStmt, cond_var::AbstractDeclStmt)
    @check_ptrs x cond_var
    @assert hasVarStorage(x) "while statement has no storage for a condition variable"
    return clang_WhileStmt_setConditionVariableDeclStmt(x, cond_var)
end

# ForStmt
"""
    setConditionVariableDeclStmt(x::AbstractForStmt, cond_var::AbstractDeclStmt)
Store the faux `DeclStmt` that declares the condition variable of `for (...; T v = ...;
...)`. A `ForStmt` always owns the slot, so this overload carries no precondition.
"""
function setConditionVariableDeclStmt(x::AbstractForStmt, cond_var::AbstractDeclStmt)
    @check_ptrs x cond_var
    return clang_ForStmt_setConditionVariableDeclStmt(x, cond_var)
end

# ReturnStmt
function setReturnLoc(x::AbstractReturnStmt, loc::SourceLocation)
    @check_ptrs x
    return clang_ReturnStmt_setReturnLoc(x, loc)
end

# AsmStmt
function setAsmLoc(x::AbstractAsmStmt, loc::SourceLocation)
    @check_ptrs x
    return clang_AsmStmt_setAsmLoc(x, loc)
end

function setSimple(x::AbstractAsmStmt, v::Bool)
    @check_ptrs x
    return clang_AsmStmt_setSimple(x, v)
end

function setVolatile(x::AbstractAsmStmt, v::Bool)
    @check_ptrs x
    return clang_AsmStmt_setVolatile(x, v)
end

# GCCAsmStmt
function setRParenLoc(x::AbstractGCCAsmStmt, loc::SourceLocation)
    @check_ptrs x
    return clang_GCCAsmStmt_setRParenLoc(x, loc)
end

# SEHLeaveStmt
function setLeaveLoc(x::AbstractSEHLeaveStmt, loc::SourceLocation)
    @check_ptrs x
    return clang_SEHLeaveStmt_setLeaveLoc(x, loc)
end

# CapturedStmt
function setCapturedDecl(x::AbstractCapturedStmt, d::AbstractCapturedDecl)
    @check_ptrs x d
    return clang_CapturedStmt_setCapturedDecl(x, d)
end

"""
    setCapturedRecordDecl(x::AbstractCapturedStmt, d::AbstractRecordDecl)
Set the closure record declaration holding the captured variables. Clang asserts the
argument is non-null; `@check_ptrs` rejects that case before the ccall.
"""
function setCapturedRecordDecl(x::AbstractCapturedStmt, d::AbstractRecordDecl)
    @check_ptrs x d
    return clang_CapturedStmt_setCapturedRecordDecl(x, d)
end


# --- Statement factories (clang/AST/Stmt.h) ---
# Every node built below lives in the ASTContext arena, so none of them is disposed.
# The `CreateEmpty` shells leave their sub-statement slots uninitialized (clang fills
# them from the serialized AST), which each docstring restates.

# CompoundStmt
"""
    CompoundStmt(ctx::ASTContext, num_stmts::Integer, has_fp_features::Bool) -> CompoundStmt
Build the empty `CompoundStmt` shell clang deserializes into. The `num_stmts` body slots,
and the trailing `FPOptionsOverride` when `has_fp_features`, are left uninitialized, so
`num_stmts == 0` with `has_fp_features` false is the only shape whose body and stored FP
features may be read straight away.
"""
function CompoundStmt(ctx::ASTContext, num_stmts::Integer, has_fp_features::Bool)
    @check_ptrs ctx
    return CompoundStmt(clang_CompoundStmt_CreateEmpty(ctx, num_stmts, has_fp_features))
end

# CaseStmt
"""
    CaseStmt(ctx::ASTContext, lhs::AbstractExpr, rhs::AbstractExpr,
             case_loc::SourceLocation, ellipsis_loc::SourceLocation,
             colon_loc::SourceLocation) -> CaseStmt
Build a `case lhs:` statement, or the GNU range form `case lhs ... rhs:` when `rhs` holds
a non-null pointer. Only the range form allocates the ellipsis slot, so `ellipsis_loc` is
ignored otherwise; pass `Expr_(C_NULL)` as `rhs` for the ordinary form.
"""
function CaseStmt(ctx::ASTContext, lhs::AbstractExpr, rhs::AbstractExpr,
                  case_loc::SourceLocation, ellipsis_loc::SourceLocation,
                  colon_loc::SourceLocation)
    @check_ptrs ctx lhs
    return CaseStmt(clang_CaseStmt_Create(ctx, lhs, rhs, case_loc, ellipsis_loc, colon_loc))
end

"""
    CaseStmt(ctx::ASTContext, is_gnu_range::Bool) -> CaseStmt
Build the empty `CaseStmt` shell clang deserializes into. The LHS and sub-statement slots
— plus RHS when `is_gnu_range` — are left uninitialized: fill them with `setLHS`,
`setSubStmt` and `setRHS` before anything reads them.
"""
function CaseStmt(ctx::ASTContext, is_gnu_range::Bool)
    @check_ptrs ctx
    return CaseStmt(clang_CaseStmt_CreateEmpty(ctx, is_gnu_range))
end

# IfStmt
"""
    IfStmt(ctx::ASTContext, if_loc::SourceLocation, kind::CXIfStatementKind,
           init::AbstractStmt, var::AbstractVarDecl, cond::AbstractExpr,
           lparen_loc::SourceLocation, rparen_loc::SourceLocation,
           then_stmt::AbstractStmt, else_loc::SourceLocation,
           else_stmt::AbstractStmt) -> IfStmt
Build an `if` statement. `init`, `var` and `else_stmt` are optional: pass a carrier holding
`C_NULL` (`Stmt(C_NULL)`, `VarDecl(C_NULL)`) to leave one out. Each non-null argument
allocates its trailing slot, which is exactly what `hasInitStorage`, `hasVarStorage` and
`hasElseStorage` report afterwards, and `else_loc` is stored only when `else_stmt` is
non-null.
"""
function IfStmt(ctx::ASTContext, if_loc::SourceLocation, kind::CXIfStatementKind,
                init::AbstractStmt, var::AbstractVarDecl, cond::AbstractExpr,
                lparen_loc::SourceLocation, rparen_loc::SourceLocation,
                then_stmt::AbstractStmt, else_loc::SourceLocation, else_stmt::AbstractStmt)
    @check_ptrs ctx cond then_stmt
    return IfStmt(clang_IfStmt_Create(ctx, if_loc, kind, init, var, cond, lparen_loc,
                                      rparen_loc, then_stmt, else_loc, else_stmt))
end

"""
    IfStmt(ctx::ASTContext, has_else::Bool, has_var::Bool, has_init::Bool) -> IfStmt
Build the empty `IfStmt` shell clang deserializes into, with storage for the optional else
branch, condition variable and init statement. Every sub-statement slot is left
uninitialized: fill them with `setCond`, `setThen`, `setElse` and `setInit` before anything
reads them.
"""
function IfStmt(ctx::ASTContext, has_else::Bool, has_var::Bool, has_init::Bool)
    @check_ptrs ctx
    return IfStmt(clang_IfStmt_CreateEmpty(ctx, has_else, has_var, has_init))
end

"""
    setConditionVariable(x::AbstractIfStmt, ctx::ASTContext, v::AbstractVarDecl)
Wrap `v` in a faux `DeclStmt` and store it as the condition variable of `if (T v = ...)`.
Clang asserts `hasVarStorage()`: the trailing slot exists only when the statement was
allocated with variable storage, so the precondition is restated here.
"""
function setConditionVariable(x::AbstractIfStmt, ctx::ASTContext, v::AbstractVarDecl)
    @check_ptrs x ctx v
    @assert hasVarStorage(x) "if statement has no storage for a condition variable"
    return clang_IfStmt_setConditionVariable(x, ctx, v)
end

# SwitchStmt
"""
    SwitchStmt(ctx::ASTContext, init::AbstractStmt, var::AbstractVarDecl,
               cond::AbstractExpr, lparen_loc::SourceLocation,
               rparen_loc::SourceLocation) -> SwitchStmt
Build a `switch` statement. `init` and `var` are optional: pass a carrier holding `C_NULL`
to leave one out. The body is not an argument — store it with `setBody` before `getBody`
reads it.
"""
function SwitchStmt(ctx::ASTContext, init::AbstractStmt, var::AbstractVarDecl,
                    cond::AbstractExpr, lparen_loc::SourceLocation,
                    rparen_loc::SourceLocation)
    @check_ptrs ctx cond
    return SwitchStmt(clang_SwitchStmt_Create(ctx, init, var, cond, lparen_loc, rparen_loc))
end

"""
    SwitchStmt(ctx::ASTContext, has_init::Bool, has_var::Bool) -> SwitchStmt
Build the empty `SwitchStmt` shell clang deserializes into, with storage for the optional
init statement and condition variable. The init, condition, variable and body slots are
left uninitialized: fill them with `setInit`, `setCond`, `setConditionVariable` and
`setBody` before anything reads them. The case list starts out empty.
"""
function SwitchStmt(ctx::ASTContext, has_init::Bool, has_var::Bool)
    @check_ptrs ctx
    return SwitchStmt(clang_SwitchStmt_CreateEmpty(ctx, has_init, has_var))
end

"""
    setConditionVariable(x::AbstractSwitchStmt, ctx::ASTContext, v::AbstractVarDecl)
Wrap `v` in a faux `DeclStmt` and store it as the condition variable of
`switch (T v = ...)`. Clang asserts `hasVarStorage()`, so the precondition is restated
here.
"""
function setConditionVariable(x::AbstractSwitchStmt, ctx::ASTContext, v::AbstractVarDecl)
    @check_ptrs x ctx v
    @assert hasVarStorage(x) "switch statement has no storage for a condition variable"
    return clang_SwitchStmt_setConditionVariable(x, ctx, v)
end

"""
    addSwitchCase(x::AbstractSwitchStmt, sc::AbstractSwitchCase)
Prepend `sc` to the switch's case list.

!!! warning
    `sc` must not already be in the list. `SwitchStmt::addSwitchCase` links it with
    `sc->setNextSwitchCase(FirstCase); FirstCase = sc`, so re-adding the current head
    sets `sc->next == sc` and any later traversal of the list spins forever. Checking
    `getNextSwitchCase(sc)` alone cannot catch that — the head's own next is null — so
    the whole list is walked here.
"""
function addSwitchCase(x::AbstractSwitchStmt, sc::AbstractSwitchCase)
    @check_ptrs x sc
    cur = getSwitchCaseList(x)
    while cur.ptr != C_NULL
        @assert cur.ptr != sc.ptr "case/default already added to this switch"
        cur = getNextSwitchCase(cur)
    end
    @assert getNextSwitchCase(sc).ptr == C_NULL "case/default already added to a switch"
    return clang_SwitchStmt_addSwitchCase(x, sc)
end

# WhileStmt
"""
    WhileStmt(ctx::ASTContext, var::AbstractVarDecl, cond::AbstractExpr,
              body::AbstractStmt, while_loc::SourceLocation,
              lparen_loc::SourceLocation, rparen_loc::SourceLocation) -> WhileStmt
Build a `while` statement. `var` is optional: pass `VarDecl(C_NULL)` to leave it out — a
non-null one allocates the trailing condition-variable slot that `hasVarStorage` reports.
"""
function WhileStmt(ctx::ASTContext, var::AbstractVarDecl, cond::AbstractExpr,
                   body::AbstractStmt, while_loc::SourceLocation,
                   lparen_loc::SourceLocation, rparen_loc::SourceLocation)
    @check_ptrs ctx cond body
    return WhileStmt(clang_WhileStmt_Create(ctx, var, cond, body, while_loc, lparen_loc,
                                            rparen_loc))
end

"""
    WhileStmt(ctx::ASTContext, has_var::Bool) -> WhileStmt
Build the empty `WhileStmt` shell clang deserializes into, with storage for the optional
condition variable. The condition, variable and body slots are left uninitialized: fill
them with `setCond`, `setConditionVariable` and `setBody` before anything reads them.
"""
function WhileStmt(ctx::ASTContext, has_var::Bool)
    @check_ptrs ctx
    return WhileStmt(clang_WhileStmt_CreateEmpty(ctx, has_var))
end

"""
    setConditionVariable(x::AbstractWhileStmt, ctx::ASTContext, v::AbstractVarDecl)
Wrap `v` in a faux `DeclStmt` and store it as the condition variable of
`while (T v = ...)`. Clang asserts `hasVarStorage()`, so the precondition is restated here.
"""
function setConditionVariable(x::AbstractWhileStmt, ctx::ASTContext, v::AbstractVarDecl)
    @check_ptrs x ctx v
    @assert hasVarStorage(x) "while statement has no storage for a condition variable"
    return clang_WhileStmt_setConditionVariable(x, ctx, v)
end

# ForStmt
"""
    setConditionVariable(x::AbstractForStmt, ctx::ASTContext, v::AbstractVarDecl)
Wrap `v` in a faux `DeclStmt` and store it as the condition variable of
`for (...; T v = ...; ...)`. A `ForStmt` always owns the slot, so this overload carries no
precondition.
"""
function setConditionVariable(x::AbstractForStmt, ctx::ASTContext, v::AbstractVarDecl)
    @check_ptrs x ctx v
    return clang_ForStmt_setConditionVariable(x, ctx, v)
end

# ReturnStmt
"""
    ReturnStmt(ctx::ASTContext, return_loc::SourceLocation, e::AbstractExpr,
               nrvo_candidate::AbstractVarDecl) -> ReturnStmt
Build a `return` statement. Both `e` and `nrvo_candidate` are optional: pass a carrier
holding `C_NULL` to leave one out. Only a non-null `nrvo_candidate` allocates the trailing
slot that `getNRVOCandidate` reads.
"""
function ReturnStmt(ctx::ASTContext, return_loc::SourceLocation, e::AbstractExpr,
                    nrvo_candidate::AbstractVarDecl)
    @check_ptrs ctx
    return ReturnStmt(clang_ReturnStmt_Create(ctx, return_loc, e, nrvo_candidate))
end

"""
    ReturnStmt(ctx::ASTContext, has_nrvo_candidate::Bool) -> ReturnStmt
Build the empty `ReturnStmt` shell clang deserializes into. The return-value slot is left
uninitialized: fill it with `setRetValue` before `getRetValue` reads it. Pass
`has_nrvo_candidate` false — with true the trailing NRVO slot is uninitialized as well and
no setter for it is exposed, because clang 18 gates `setNRVOCandidate` on a private
`hasNRVOCandidate()`, so `getNRVOCandidate` would read uninitialized memory.
"""
function ReturnStmt(ctx::ASTContext, has_nrvo_candidate::Bool)
    @check_ptrs ctx
    return ReturnStmt(clang_ReturnStmt_CreateEmpty(ctx, has_nrvo_candidate))
end

# SEHExceptStmt
"""
    SEHExceptStmt(ctx::ASTContext, except_loc::SourceLocation, filter::AbstractExpr,
                  block::AbstractCompoundStmt) -> SEHExceptStmt
Build an `__except (filter) block` handler. `block` is typed as a compound statement
because `getBlock` casts it unconditionally.
"""
function SEHExceptStmt(ctx::ASTContext, except_loc::SourceLocation, filter::AbstractExpr,
                       block::AbstractCompoundStmt)
    @check_ptrs ctx filter block
    return SEHExceptStmt(clang_SEHExceptStmt_Create(ctx, except_loc, filter, block))
end

# SEHFinallyStmt
"""
    SEHFinallyStmt(ctx::ASTContext, finally_loc::SourceLocation,
                   block::AbstractCompoundStmt) -> SEHFinallyStmt
Build a `__finally block` handler. `block` is typed as a compound statement because
`getBlock` casts it unconditionally.
"""
function SEHFinallyStmt(ctx::ASTContext, finally_loc::SourceLocation,
                        block::AbstractCompoundStmt)
    @check_ptrs ctx block
    return SEHFinallyStmt(clang_SEHFinallyStmt_Create(ctx, finally_loc, block))
end

# SEHTryStmt
"""
    SEHTryStmt(ctx::ASTContext, is_cxx_try::Bool, try_loc::SourceLocation,
               try_block::AbstractCompoundStmt, handler::AbstractStmt) -> SEHTryStmt
Build a `__try`/`try` statement. `try_block` is typed as a compound statement because
`getTryBlock` casts it unconditionally, and `handler` must be an `SEHExceptStmt` or an
`SEHFinallyStmt`: `getEndLoc` dereferences it and the handler accessors downcast it.
"""
function SEHTryStmt(ctx::ASTContext, is_cxx_try::Bool, try_loc::SourceLocation,
                    try_block::AbstractCompoundStmt, handler::AbstractStmt)
    @check_ptrs ctx try_block handler
    @assert handler isa AbstractSEHExceptStmt || handler isa AbstractSEHFinallyStmt "handler \
                                                 must be a __except or __finally statement"
    return SEHTryStmt(clang_SEHTryStmt_Create(ctx, is_cxx_try, try_loc, try_block, handler))
end



# Stmt (colour dump, controlled pretty-printing, structural profile)
"""
    dumpColor(x::AbstractStmt)
Write the AST subtree rooted at `x` to `stderr` with colour highlighting forced on.
"""
function dumpColor(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_dumpColor(x)
end

"""
    printPrettyControlled(x::AbstractStmt, ctx::ASTContext, indentation::Integer=0) -> String
Pretty-print the statement the way clang renders a control-flow body: wrapped in braces
and indented as a nested block. Same sources as `printPretty` — `ctx`'s own printing
policy, no `PrinterHelper` and `"\\n"` as the newline symbol.
"""
function printPrettyControlled(x::AbstractStmt, ctx::ASTContext, indentation::Integer=0)
    @check_ptrs x ctx
    return get_string(clang_Stmt_printPrettyControlled(x, ctx, indentation))
end

"""
    getProfileHash(x::AbstractStmt, ctx::ASTContext, canonical::Bool=false,
                   profile_lambda_expr::Bool=false) -> UInt32
Return the hash of the structural profile clang computes for `x` (`Stmt::Profile` fills an
`llvm::FoldingSetNodeID`, whose hash is the only part that crosses the C boundary).
Structurally equal statements always hash equal, unequal ones differ except on a hash
collision — so this decides "definitely different", not "definitely the same". With
`canonical` the profile compares declarations through their canonical declaration rather
than by pointer identity.
"""
function getProfileHash(x::AbstractStmt, ctx::ASTContext, canonical::Bool=false,
                        profile_lambda_expr::Bool=false)
    @check_ptrs x ctx
    return clang_Stmt_getProfileHash(x, ctx, canonical, profile_lambda_expr)
end

# GCCAsmStmt
function setAsmString(x::AbstractGCCAsmStmt, asm_str::StringLiteral)
    @check_ptrs x asm_str
    return clang_GCCAsmStmt_setAsmString(x, asm_str)
end

# MSAsmStmt
"""
    getNumAsmToks(x::AbstractMSAsmStmt) -> Int
Return the number of raw preprocessor tokens making up the `__asm` block.
"""
function getNumAsmToks(x::AbstractMSAsmStmt)
    @check_ptrs x
    return Int(clang_MSAsmStmt_getNumAsmToks(x))
end

"""
    getAsmTok(x::AbstractMSAsmStmt, i::Integer) -> Token
Return token `i` (0-based) of the `__asm` block, borrowed from the statement's own token
array — do not `dispose` it. `i` must be `< getNumAsmToks(x)`: clang stores a null array
pointer when the statement carries no tokens, so an out-of-range index dereferences null.
"""
function getAsmTok(x::AbstractMSAsmStmt, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumAsmToks(x) "asm token index out of range"
    return Token(clang_MSAsmStmt_getAsmTok(x, i))
end

function setLBraceLoc(x::AbstractMSAsmStmt, loc::SourceLocation)
    @check_ptrs x
    return clang_MSAsmStmt_setLBraceLoc(x, loc)
end

function setEndLoc(x::AbstractMSAsmStmt, loc::SourceLocation)
    @check_ptrs x
    return clang_MSAsmStmt_setEndLoc(x, loc)
end

"""
    setInputExpr(x::AbstractMSAsmStmt, i::Integer, e::AbstractExpr)
Store `e` as input operand `i` (0-based). `i` must be `< getNumInputs(x)`: clang indexes
the operand array unchecked.
"""
function setInputExpr(x::AbstractMSAsmStmt, i::Integer, e::AbstractExpr)
    @check_ptrs x e
    @assert 0 <= i < getNumInputs(x) "input operand index out of range"
    return clang_MSAsmStmt_setInputExpr(x, i, e)
end

# ReturnStmt
"""
    setNRVOCandidate(x::AbstractReturnStmt, var::AbstractVarDecl)
Store `var` as the named-return-value-optimization candidate. clang asserts the statement
owns the trailing NRVO slot and gates that on a `hasNRVOCandidate()` that is private in
clang 18, so the gate itself cannot be exported; the observable proxy asserted here is a
non-null `getNRVOCandidate`, which holds exactly for a `ReturnStmt` built with a non-null
candidate.
"""
function setNRVOCandidate(x::AbstractReturnStmt, var::AbstractVarDecl)
    @check_ptrs x var
    @assert getNRVOCandidate(x).ptr != C_NULL "return statement has no NRVO-candidate storage"
    return clang_ReturnStmt_setNRVOCandidate(x, var)
end

# CompoundStmt
"""
    CompoundStmt(ctx::ASTContext, stmts::Vector{<:AbstractStmt}, fp_features::Integer,
                 lbrace_loc::SourceLocation, rbrace_loc::SourceLocation) -> CompoundStmt
Build `{ stmts... }`. The statements are copied into the node's trailing storage, so
`stmts` need not outlive the call and may be empty. `fp_features` is the
`FPOptionsOverride` opaque encoding `getStoredFPFeatures` reads back: pass `0` for "no
override", the only value that leaves `hasStoredFPFeatures` false.
"""
function CompoundStmt(ctx::ASTContext, stmts::Vector{<:AbstractStmt}, fp_features::Integer,
                      lbrace_loc::SourceLocation, rbrace_loc::SourceLocation)
    @check_ptrs ctx
    @assert all(s -> s.ptr != C_NULL, stmts) "a compound statement body holds no null slot"
    buf = CXStmt[s.ptr for s in stmts]
    return CompoundStmt(clang_CompoundStmt_Create(ctx, buf, length(buf), fp_features,
                                                  lbrace_loc, rbrace_loc))
end

# AttributedStmt
"""
    AttributedStmt(ctx::ASTContext, loc::SourceLocation, attrs::Vector{<:AbstractAttr},
                   sub_stmt::AbstractStmt) -> AttributedStmt
Build the attributed statement `[[attrs...]] sub_stmt`, with `loc` as the location of the
leading attribute. The attributes are copied into the node's trailing storage, so `attrs`
need not outlive the call. clang requires a non-empty attribute list, which this restates.
"""
function AttributedStmt(ctx::ASTContext, loc::SourceLocation, attrs::Vector{<:AbstractAttr},
                        sub_stmt::AbstractStmt)
    @check_ptrs ctx sub_stmt
    @assert !isempty(attrs) "an AttributedStmt needs at least one attribute"
    @assert all(a -> a.ptr != C_NULL, attrs) "attribute list holds no null slot"
    buf = CXAttr[a.ptr for a in attrs]
    return AttributedStmt(clang_AttributedStmt_Create(ctx, loc, buf, length(buf), sub_stmt))
end


"""
    AttributedStmt(ctx::ASTContext, num_attrs::Integer) -> AttributedStmt
Build the empty `AttributedStmt` shell clang deserializes into. The `num_attrs` attribute
slots start out null and the attribute location is default-constructed invalid, but the
sub-statement slot is left uninitialized and can never be filled: clang keeps
`AttributedStmt::SubStmt` private with only `ASTStmtReader` as a friend, so libclangex
exports no setter for it. Only `getAttrLoc`, `getNumAttrs` and `getAttrs` may be read on a
shell built this way — `getSubStmt` and `getEndLoc` would read uninitialized memory.
"""
function AttributedStmt(ctx::ASTContext, num_attrs::Integer)
    @check_ptrs ctx
    return AttributedStmt(clang_AttributedStmt_CreateEmpty(ctx, num_attrs))
end

# GCCAsmStmt::AsmStringPiece
"""
    getNumAsmStringPieces(x::AbstractGCCAsmStmt, ctx::ASTContext) -> Tuple{Int,UInt32,UInt32}
Return the number of pieces the asm string decomposes into, clang's own `AnalyzeAsmString`
verdict (`0` when the string decomposes cleanly, nonzero when clang rejects it) and the
byte offset into the asm string the complaint points at, in that order. A rejected string
still reports however many pieces clang built before it stopped.
"""
function getNumAsmStringPieces(x::AbstractGCCAsmStmt, ctx::ASTContext)
    @check_ptrs x ctx
    diag_id = Ref{Cuint}(0)
    diag_offs = Ref{Cuint}(0)
    n = clang_GCCAsmStmt_getNumAsmStringPieces(x, ctx, diag_id, diag_offs)
    return Int(n), diag_id[], diag_offs[]
end

"""
    getAsmStringPieces(x::AbstractGCCAsmStmt, ctx::ASTContext) -> Vector{GCCAsmStmtAsmStringPiece}
Return the literal-text and operand-reference pieces the asm string decomposes into. clang
builds them into a caller-owned vector rather than the AST arena, so each piece here is a
heap copy: this function allocates and one should call `dispose` to release the resources
after using this object.
"""
function getAsmStringPieces(x::AbstractGCCAsmStmt, ctx::ASTContext)
    @check_ptrs x ctx
    n, _, _ = getNumAsmStringPieces(x, ctx)
    buf = Vector{CXGCCAsmStmtAsmStringPiece}(undef, n)
    n > 0 && clang_GCCAsmStmt_getAsmStringPieces(x, ctx, buf)
    return [GCCAsmStmtAsmStringPiece(p) for p in buf]
end

dispose(x::GCCAsmStmtAsmStringPiece) = clang_GCCAsmStmtAsmStringPiece_dispose(x)

function isString(x::GCCAsmStmtAsmStringPiece)
    @check_ptrs x
    return clang_GCCAsmStmtAsmStringPiece_isString(x)
end

function isOperand(x::GCCAsmStmtAsmStringPiece)
    @check_ptrs x
    return clang_GCCAsmStmtAsmStringPiece_isOperand(x)
end

"""
    getString(x::GCCAsmStmtAsmStringPiece) -> String
Return the literal text of a string piece, or the operand-reference text of an operand
piece.
"""
function getString(x::GCCAsmStmtAsmStringPiece)
    @check_ptrs x
    return get_string(clang_GCCAsmStmtAsmStringPiece_getString(x))
end

"""
    getOperandNo(x::GCCAsmStmtAsmStringPiece) -> Int
Return the index of the operand this piece references. clang asserts the piece is an
operand reference, which the `@assert` below restates.
"""
function getOperandNo(x::GCCAsmStmtAsmStringPiece)
    @check_ptrs x
    @assert isOperand(x) "only an operand piece carries an operand number"
    return Int(clang_GCCAsmStmtAsmStringPiece_getOperandNo(x))
end

"""
    getRange(x::GCCAsmStmtAsmStringPiece) -> SourceRange
Return the character range the operand reference occupies inside the asm string. clang
asserts the piece is an operand reference, which the `@assert` below restates.
"""
function getRange(x::GCCAsmStmtAsmStringPiece)
    @check_ptrs x
    @assert isOperand(x) "only an operand piece carries a source range"
    r = clang_GCCAsmStmtAsmStringPiece_getRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

"""
    getModifier(x::GCCAsmStmtAsmStringPiece) -> Char
Return the modifier letter of the operand reference (the `c` of `%c0`), or `'\\0'` when it
carries none. clang documents this as the modifier of an operand, so the `@assert` below
restates that scope like `getOperandNo` and `getRange`.
"""
function getModifier(x::GCCAsmStmtAsmStringPiece)
    @check_ptrs x
    @assert isOperand(x) "only an operand piece carries a modifier"
    return Char(clang_GCCAsmStmtAsmStringPiece_getModifier(x) % UInt8)
end


"""
    getBodyStmt(x::AbstractCompoundStmt, i) -> Stmt
Return the `i`-th body statement (0-based). A `CompoundStmt` keeps its body in a
contiguous `Stmt *` array, so this indexes that array directly and returns the same node
`getChildren` reports at position `i` — without the walk and the buffer the generic child
fill needs to reach one element.
"""
function getBodyStmt(x::AbstractCompoundStmt, i::Integer)
    @check_ptrs x
    @assert 0 <= i < length(x) "compound statement body index out of range"
    return Stmt(clang_CompoundStmt_getBodyStmt(x, i))
 end

"""
    getDecl(x::AbstractDeclStmt, i) -> Decl
Return the `i`-th declaration of the group (0-based). The group is a contiguous `Decl *`
array — a single-declaration statement indexes its inline slot at 0 — so this is the O(1)
counterpart of the `getDecls` fill.
"""
function getDecl(x::AbstractDeclStmt, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumDecls(x) "declaration statement index out of range"
    return Decl(clang_DeclStmt_getDecl(x, i))
end

"""
    addStmtClass(sc::CXStmtClass)
Bump the global statistics counter for statement class `sc`, the counter `PrintStats`
reports. clang exposes no reader for an individual class, so this is write-only from
Julia; it pairs with `EnableStatistics` and `PrintStats`.
"""
function addStmtClass(sc::CXStmtClass)
    return clang_Stmt_addStmtClass(sc)
end

"""
    getODRHash(x::AbstractStmt) -> UInt32
Return the ODR hash of the statement. `clang::Stmt::ProcessODRHash` profiles the subtree
without using pointer identity, so statements that are ODR-equivalent across translation
units hash equal. Unlike `getProfileHash` it needs no `ASTContext`, and unlike the cached
`getODRHash` of a `FunctionDecl` or `RecordDecl` it is recomputed on every call. Being a
hash, equal statements always agree and distinct ones agree only on a collision.
"""
function getODRHash(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_getODRHash(x)
end


# CapturedStmt::Capture
"""
    CapturedStmtCapture(loc::SourceLocation, kind::CXVariableCaptureKind,
                        var::AbstractVarDecl=VarDecl(C_NULL)) -> CapturedStmtCapture
Build one capture of a captured region: the entity named by `var` entering in form `kind`,
first used at `loc`. The kind and the variable must agree — `VCK_ByRef` and `VCK_ByCopy`
name a variable, `VCK_This` and `VCK_VLAType` take none — which this restates, because
`getCapturedVar` and the `captures*` predicates downstream assume that pairing.

A `clang::CapturedStmt::Capture` is a by-value class with no pointer form, so this function
allocates and one should call `dispose` to release the resources after using this object.
`CapturedStmt` copies the captures it is handed, so the boxes may be disposed as soon as
the statement is built. A capture obtained from `getCapture` borrows into its statement
instead and must not be disposed.
"""
function CapturedStmtCapture(loc::SourceLocation, kind::CXVariableCaptureKind,
                             var::AbstractVarDecl=VarDecl(C_NULL))
    named = kind == CXVariableCaptureKind_VCK_ByRef || kind == CXVariableCaptureKind_VCK_ByCopy
    @assert named == (var.ptr != C_NULL) "by-ref/by-copy captures name a variable, 'this'/VLA ones do not"
    return CapturedStmtCapture(clang_CapturedStmtCapture_create(loc, kind, var))
 end

dispose(x::CapturedStmtCapture) = clang_CapturedStmtCapture_dispose(x)

# CapturedStmt
"""
    CapturedStmt(ctx::ASTContext, s::AbstractStmt, kind::CXCapturedRegionKind,
                 captures::Vector{CapturedStmtCapture}, inits::Vector{<:AbstractExpr},
                 cd::AbstractCapturedDecl, rd::AbstractRecordDecl) -> CapturedStmt
Build the captured region `kind` around statement `s`, outlined into `cd` with `rd` as the
record of captured variables. `captures` and `inits` must have the same length — clang
stores exactly one initializer per capture — and both are copied into the node's arena
storage, so neither need outlive the call and the caller still owns its
`CapturedStmtCapture` boxes. An `inits` slot may be null; a `captures` slot may not.
"""
function CapturedStmt(ctx::ASTContext, s::AbstractStmt, kind::CXCapturedRegionKind,
                      captures::Vector{CapturedStmtCapture}, inits::Vector{<:AbstractExpr},
                      cd::AbstractCapturedDecl, rd::AbstractRecordDecl)
    @check_ptrs ctx s cd rd
    @assert length(captures) == length(inits) "each capture needs exactly one initializer"
    @assert all(c -> c.ptr != C_NULL, captures) "a capture list holds no null slot"
    cbuf = CXCapturedStmtCapture[c.ptr for c in captures]
    ibuf = CXExpr[e.ptr for e in inits]
    return CapturedStmt(clang_CapturedStmt_Create(ctx, s, kind, cbuf, ibuf, length(cbuf), cd, rd))
end

"""
    CapturedStmt(ctx::ASTContext, num_captures::Integer) -> CapturedStmt
Build the empty `CapturedStmt` shell clang deserializes into. Only `capture_size` (which
reads back `num_captures`) and `getCapturedStmt` (nulled by the shell constructor) are
meaningful on it: the `num_captures` capture slots and their initializers are left
uninitialized, so `getCapture` and `getCaptureInit` would read uninitialized memory.
"""
function CapturedStmt(ctx::ASTContext, num_captures::Integer)
    @check_ptrs ctx
    return CapturedStmt(clang_CapturedStmt_CreateDeserialized(ctx, num_captures))
end


"""
    getLikelihood(attrs::Vector{<:AbstractAttr}) -> CXLikelihood
Return the `[[likely]]`/`[[unlikely]]` likelihood carried by an explicit attribute list --
the `ArrayRef<const Attr *>` overload of `clang::Stmt::getLikelihood`. A list holding
neither attribute, the empty list included, reports `CXLikelihood_LH_None`.
"""
function getLikelihood(attrs::Vector{<:AbstractAttr})
    @assert all(a -> a.ptr != C_NULL, attrs) "attribute list holds no null slot"
    buf = CXAttr[a.ptr for a in attrs]
    return clang_Stmt_getLikelihoodOfAttrs(buf, length(buf))
end

"""
    getLikelihood(then_stmt::AbstractStmt, else_stmt::AbstractStmt) -> CXLikelihood
Return the likelihood of the `then` branch of an `if` statement -- the two-argument overload
of `clang::Stmt::getLikelihood`. The `else` branch takes part because two branches specifying
the same likelihood cancel out; `else_stmt` may be the NULL carrier `getElse` yields for an
`if` with no `else` branch, which this wrapper deliberately accepts.
"""
function getLikelihood(then_stmt::AbstractStmt, else_stmt::AbstractStmt)
    @check_ptrs then_stmt
    return clang_Stmt_getLikelihoodOfBranches(then_stmt, else_stmt)
end

"""
    determineLikelihoodConflict(then_stmt::AbstractStmt, else_stmt::AbstractStmt) ->
        (Bool, Attr, Attr)
Test whether the branches of an `if` statement carry conflicting `[[likely]]`/`[[unlikely]]`
attributes. The second and third elements are the `then` and `else` branch attributes, NULL
carriers when a branch carries none. `else_stmt` may be the NULL carrier `getElse` yields for
an `if` with no `else` branch.
"""
function determineLikelihoodConflict(then_stmt::AbstractStmt, else_stmt::AbstractStmt)
    @check_ptrs then_stmt
    then_attr = Ref{CXAttr}(C_NULL)
    else_attr = Ref{CXAttr}(C_NULL)
    conflict = clang_Stmt_determineLikelihoodConflict(then_stmt, else_stmt, then_attr, else_attr)
    return conflict, Attr(then_attr[]), Attr(else_attr[])
end


# GCCAsmStmt
"""
    GCCAsmStmt(ctx::ASTContext, asm_loc::SourceLocation, is_simple::Bool, is_volatile::Bool,
               num_outputs::Integer, num_inputs::Integer, names::Vector{IdentifierInfo},
               constraints::Vector{StringLiteral}, exprs::Vector{<:AbstractExpr},
               asm_str::StringLiteral, clobbers::Vector{StringLiteral},
               rparen_loc::SourceLocation) -> GCCAsmStmt
Build the GCC-style inline-assembly statement `asm(asm_str : outputs : inputs : clobbers)`
from its operand arrays.

`exprs` holds one slot per output, then per input, then per `asm goto` label, and `names`
one symbolic `[name]` for the same slots -- a `names` slot may be a NULL-pointer
`IdentifierInfo` for an operand carrying none, every other slot may not be null. The number
of labels is whatever `exprs` has beyond `num_outputs + num_inputs`, and each label slot
must hold an `AddrLabelExpr`: [`getLabelExpr`](@ref) casts it unchecked. `constraints`
holds one literal per output and input. Everything is copied into the statement's own arena
storage, so no vector need outlive the call, and the node is arena-allocated: there is no
`dispose`.
"""
function GCCAsmStmt(ctx::ASTContext, asm_loc::SourceLocation, is_simple::Bool, is_volatile::Bool,
                    num_outputs::Integer, num_inputs::Integer, names::Vector{IdentifierInfo},
                    constraints::Vector{StringLiteral}, exprs::Vector{<:AbstractExpr},
                    asm_str::StringLiteral, clobbers::Vector{StringLiteral},
                    rparen_loc::SourceLocation)
    @check_ptrs ctx asm_str
    @assert num_outputs >= 0 && num_inputs >= 0 "operand counts are non-negative"
    num_operands = Int(num_outputs) + Int(num_inputs)
    @assert length(exprs) >= num_operands "exprs holds one slot per output, input and label"
    @assert length(names) == length(exprs) "names holds one slot per output, input and label"
    @assert length(constraints) == num_operands "constraints holds one literal per output and input"
    @assert all(e -> e.ptr != C_NULL, exprs) "an asm operand list holds no null slot"
    @assert all(c -> c.ptr != C_NULL, constraints) "a constraint list holds no null slot"
    @assert all(c -> c.ptr != C_NULL, clobbers) "a clobber list holds no null slot"
    nbuf = CXIdentifierInfo[n.ptr for n in names]
    cbuf = CXStringLiteral[c.ptr for c in constraints]
    ebuf = CXExpr[e.ptr for e in exprs]
    lbuf = CXStringLiteral[c.ptr for c in clobbers]
    return GCCAsmStmt(clang_GCCAsmStmt_Create(ctx, asm_loc, is_simple, is_volatile, num_outputs,
                                              num_inputs, nbuf, cbuf, ebuf, asm_str, length(lbuf),
                                              lbuf, length(exprs) - num_operands, rparen_loc))
end

# MSAsmStmt
"""
    MSAsmStmt(ctx::ASTContext, asm_loc::SourceLocation, lbrace_loc::SourceLocation,
              is_simple::Bool, is_volatile::Bool, asm_toks::Vector{Token},
              num_outputs::Integer, num_inputs::Integer, constraints::Vector{String},
              exprs::Vector{<:AbstractExpr}, asm_str::AbstractString,
              clobbers::Vector{String}, end_loc::SourceLocation) -> MSAsmStmt
Build the MS-style `__asm { ... }` block from its operand arrays.

`constraints` and `exprs` hold one entry each per output and then per input; no slot may be
null. `asm_toks` are the raw preprocessor tokens of the block, whose values are copied, so
the caller keeps ownership of its `Token` boxes and must still `dispose` them. `lbrace_loc`
is what [`hasBraces`](@ref) reads: an invalid location means the block had none. Every
string, token and expression is copied into the statement's own arena storage, so nothing
passed here need outlive the call, and the node is arena-allocated: there is no `dispose`.
"""
function MSAsmStmt(ctx::ASTContext, asm_loc::SourceLocation, lbrace_loc::SourceLocation,
                   is_simple::Bool, is_volatile::Bool, asm_toks::Vector{Token},
                   num_outputs::Integer, num_inputs::Integer, constraints::Vector{String},
                   exprs::Vector{<:AbstractExpr}, asm_str::AbstractString,
                   clobbers::Vector{String}, end_loc::SourceLocation)
    @check_ptrs ctx
    @assert num_outputs >= 0 && num_inputs >= 0 "operand counts are non-negative"
    num_operands = Int(num_outputs) + Int(num_inputs)
    @assert length(constraints) == num_operands "constraints holds one string per output and input"
    @assert length(exprs) == num_operands "exprs holds one expression per output and input"
    @assert all(e -> e.ptr != C_NULL, exprs) "an asm operand list holds no null slot"
    @assert all(t -> t.ptr != C_NULL, asm_toks) "a token list holds no null slot"
    tbuf = CXToken_[t.ptr for t in asm_toks]
    ebuf = CXExpr[e.ptr for e in exprs]
    return MSAsmStmt(clang_MSAsmStmt_Create(ctx, asm_loc, lbrace_loc, is_simple, is_volatile, tbuf,
                                            length(tbuf), num_outputs, num_inputs, constraints,
                                            ebuf, String(asm_str), clobbers, length(clobbers),
                                            end_loc))
end

"""
    getAllConstraints(x::AbstractMSAsmStmt) -> Vector{String}
Return the constraint of every operand, outputs first and inputs after -- `getAllConstraints`
views the very array [`getOutputConstraint`](@ref) and [`getInputConstraint`](@ref) index
into, so it needs no binding of its own.
"""
function getAllConstraints(x::AbstractMSAsmStmt)
    @check_ptrs x
    n_out, n_in = Int(getNumOutputs(x)), Int(getNumInputs(x))
    return String[i < n_out ? getOutputConstraint(x, i) : getInputConstraint(x, i - n_out)
                  for i = 0:(n_out + n_in - 1)]
end

"""
    getAllExprs(x::AbstractMSAsmStmt) -> Vector{Expr_}
Return every operand expression, outputs first and inputs after -- the same array
[`getOutputExpr`](@ref) and [`getInputExpr`](@ref) index into.
"""
function getAllExprs(x::AbstractMSAsmStmt)
    @check_ptrs x
    n_out, n_in = Int(getNumOutputs(x)), Int(getNumInputs(x))
    return Expr_[i < n_out ? getOutputExpr(x, i) : getInputExpr(x, i - n_out)
                 for i = 0:(n_out + n_in - 1)]
end

"""
    getClobbers(x::AbstractMSAsmStmt) -> Vector{String}
Return every clobber of the block -- the same array [`getClobber`](@ref) indexes into.
"""
function getClobbers(x::AbstractMSAsmStmt)
    @check_ptrs x
    return String[getClobber(x, i) for i = 0:(Int(getNumClobbers(x)) - 1)]
end
