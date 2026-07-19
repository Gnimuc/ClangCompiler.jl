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

# Stmt Cast — one constructor-shaped downcast and one predicate per class in
# the hierarchy (abstract bases included), stamped from the STMT_NODES table.
# The wrapped pointer is NULL when the node is not of that class
# (dyn_cast_or_null semantics). Classes clang itself names `Abstract*` have no
# carrier struct, so they get only the predicate.
for node in STMT_NODES
    pred = Symbol("clang_Stmt_is", node.name)
    isname = Symbol("is", node.name)
    @eval function $isname(x::AbstractStmt)
        @check_ptrs x
        return $pred(x)
    end
    startswith(String(node.name), "Abstract") && continue
    tsym = stmt_carrier_name(node.name)
    cast = Symbol("clang_Stmt_castTo", node.name)
    @eval function $tsym(x::AbstractStmt)
        @check_ptrs x
        return $tsym($cast(x))
    end
end

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

