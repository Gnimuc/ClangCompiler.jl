# CXXCatchStmt
function getExceptionDecl(x::AbstractCXXCatchStmt)
    @check_ptrs x
    return VarDecl(clang_CXXCatchStmt_getExceptionDecl(x))
end

function getCaughtType(x::AbstractCXXCatchStmt)
    @check_ptrs x
    return QualType(clang_CXXCatchStmt_getCaughtType(x))
end

function getHandlerBlock(x::AbstractCXXCatchStmt)
    @check_ptrs x
    return Stmt(clang_CXXCatchStmt_getHandlerBlock(x))
end

function getCatchLoc(x::AbstractCXXCatchStmt)
    @check_ptrs x
    return SourceLocation(clang_CXXCatchStmt_getCatchLoc(x))
end

# CXXTryStmt
function getTryBlock(x::AbstractCXXTryStmt)
    @check_ptrs x
    return CompoundStmt(clang_CXXTryStmt_getTryBlock(x))
end

function getNumHandlers(x::AbstractCXXTryStmt)
    @check_ptrs x
    return clang_CXXTryStmt_getNumHandlers(x)
end

"""
    getHandler(x::AbstractCXXTryStmt, i)
Return the `i`-th handler (0-based, following the C++ API).
"""
function getHandler(x::AbstractCXXTryStmt, i::Integer)
    @check_ptrs x
    return CXXCatchStmt(clang_CXXTryStmt_getHandler(x, i))
end

function getTryLoc(x::AbstractCXXTryStmt)
    @check_ptrs x
    return SourceLocation(clang_CXXTryStmt_getTryLoc(x))
end

# CXXForRangeStmt
function getLoopVariable(x::AbstractCXXForRangeStmt)
    @check_ptrs x
    return VarDecl(clang_CXXForRangeStmt_getLoopVariable(x))
end

function getRangeInit(x::AbstractCXXForRangeStmt)
    @check_ptrs x
    return Expr_(clang_CXXForRangeStmt_getRangeInit(x))
end

function getBody(x::AbstractCXXForRangeStmt)
    @check_ptrs x
    return Stmt(clang_CXXForRangeStmt_getBody(x))
end

function getBeginStmt(x::AbstractCXXForRangeStmt)
    @check_ptrs x
    return DeclStmt(clang_CXXForRangeStmt_getBeginStmt(x))
end

function getEndStmt(x::AbstractCXXForRangeStmt)
    @check_ptrs x
    return DeclStmt(clang_CXXForRangeStmt_getEndStmt(x))
end

function getForLoc(x::AbstractCXXForRangeStmt)
    @check_ptrs x
    return SourceLocation(clang_CXXForRangeStmt_getForLoc(x))
end

function getCoawaitLoc(x::AbstractCXXForRangeStmt)
    @check_ptrs x
    return SourceLocation(clang_CXXForRangeStmt_getCoawaitLoc(x))
end

function getColonLoc(x::AbstractCXXForRangeStmt)
    @check_ptrs x
    return SourceLocation(clang_CXXForRangeStmt_getColonLoc(x))
end

function getRParenLoc(x::AbstractCXXForRangeStmt)
    @check_ptrs x
    return SourceLocation(clang_CXXForRangeStmt_getRParenLoc(x))
end

# CXXForRangeStmt
function getInit(x::AbstractCXXForRangeStmt)
    @check_ptrs x
    return Stmt(clang_CXXForRangeStmt_getInit(x))
end

function getRangeStmt(x::AbstractCXXForRangeStmt)
    @check_ptrs x
    return DeclStmt(clang_CXXForRangeStmt_getRangeStmt(x))
end

function getCond(x::AbstractCXXForRangeStmt)
    @check_ptrs x
    return Expr_(clang_CXXForRangeStmt_getCond(x))
end

function getInc(x::AbstractCXXForRangeStmt)
    @check_ptrs x
    return Expr_(clang_CXXForRangeStmt_getInc(x))
end

function getLoopVarStmt(x::AbstractCXXForRangeStmt)
    @check_ptrs x
    return DeclStmt(clang_CXXForRangeStmt_getLoopVarStmt(x))
end

# CoroutineBodyStmt
function hasDependentPromiseType(x::AbstractCoroutineBodyStmt)
    @check_ptrs x
    return clang_CoroutineBodyStmt_hasDependentPromiseType(x)
end

"""
    getBody(x::AbstractCoroutineBodyStmt)
Return the body of the coroutine as written (a `CompoundStmt`).
"""
function getBody(x::AbstractCoroutineBodyStmt)
    @check_ptrs x
    return CompoundStmt(clang_CoroutineBodyStmt_getBody(x))
end

"""
    getPromiseDecl(x::AbstractCoroutineBodyStmt)
Return the `VarDecl` of the coroutine promise object.
"""
function getPromiseDecl(x::AbstractCoroutineBodyStmt)
    @check_ptrs x
    return VarDecl(clang_CoroutineBodyStmt_getPromiseDecl(x))
end

function getInitSuspendStmt(x::AbstractCoroutineBodyStmt)
    @check_ptrs x
    return Stmt(clang_CoroutineBodyStmt_getInitSuspendStmt(x))
end

function getFinalSuspendStmt(x::AbstractCoroutineBodyStmt)
    @check_ptrs x
    return Stmt(clang_CoroutineBodyStmt_getFinalSuspendStmt(x))
end

function getExceptionHandler(x::AbstractCoroutineBodyStmt)
    @check_ptrs x
    return Stmt(clang_CoroutineBodyStmt_getExceptionHandler(x))
end

function getAllocate(x::AbstractCoroutineBodyStmt)
    @check_ptrs x
    return Expr_(clang_CoroutineBodyStmt_getAllocate(x))
end

function getDeallocate(x::AbstractCoroutineBodyStmt)
    @check_ptrs x
    return Expr_(clang_CoroutineBodyStmt_getDeallocate(x))
end

function getReturnStmt(x::AbstractCoroutineBodyStmt)
    @check_ptrs x
    return Stmt(clang_CoroutineBodyStmt_getReturnStmt(x))
end

# CoreturnStmt
function getKeywordLoc(x::AbstractCoreturnStmt)
    @check_ptrs x
    return SourceLocation(clang_CoreturnStmt_getKeywordLoc(x))
end

function getOperand(x::AbstractCoreturnStmt)
    @check_ptrs x
    return Expr_(clang_CoreturnStmt_getOperand(x))
end

function getPromiseCall(x::AbstractCoreturnStmt)
    @check_ptrs x
    return Expr_(clang_CoreturnStmt_getPromiseCall(x))
end

function isImplicit(x::AbstractCoreturnStmt)
    @check_ptrs x
    return clang_CoreturnStmt_isImplicit(x)
end

# CXXForRangeStmt (cont.)
function setCond(x::AbstractCXXForRangeStmt, cond::AbstractExpr)
    @check_ptrs x cond
    return clang_CXXForRangeStmt_setCond(x, cond)
end

function setBody(x::AbstractCXXForRangeStmt, body::AbstractStmt)
    @check_ptrs x body
    return clang_CXXForRangeStmt_setBody(x, body)
end

# CoroutineBodyStmt (cont.)
"""
    getPromiseDeclStmt(x::AbstractCoroutineBodyStmt) -> Stmt
Return the declaration statement introducing the coroutine's promise object.

This is the `DeclStmt` [`getPromiseDecl`](@ref) unwraps; `resolve` it to refine the
carrier.
"""
function getPromiseDeclStmt(x::AbstractCoroutineBodyStmt)
    @check_ptrs x
    return Stmt(clang_CoroutineBodyStmt_getPromiseDeclStmt(x))
end

"""
    getFallthroughHandler(x::AbstractCoroutineBodyStmt) -> Stmt
Return the statement run when control falls off the end of the coroutine body — the
call to the promise type's `return_void`.
"""
function getFallthroughHandler(x::AbstractCoroutineBodyStmt)
    @check_ptrs x
    return Stmt(clang_CoroutineBodyStmt_getFallthroughHandler(x))
end

"""
    getResultDecl(x::AbstractCoroutineBodyStmt) -> Stmt
Return the declaration statement holding the coroutine's return object, or a NULL
carrier when the return object needs no temporary.
"""
function getResultDecl(x::AbstractCoroutineBodyStmt)
    @check_ptrs x
    return Stmt(clang_CoroutineBodyStmt_getResultDecl(x))
end

"""
    getReturnValueInit(x::AbstractCoroutineBodyStmt) -> Expr_
Return the expression initializing the coroutine's return object, i.e. the call to the
promise type's `get_return_object`.

The C++ accessor casts the stored slot to `Expr` unchecked. Every `CoroutineBodyStmt`
Sema builds fills that slot — a promise type without `get_return_object` makes the
coroutine ill-formed and no node is built — so the cast only misfires on a
hand-constructed node, and the slot is private, so the precondition cannot be checked
here.
"""
function getReturnValueInit(x::AbstractCoroutineBodyStmt)
    @check_ptrs x
    return Expr_(clang_CoroutineBodyStmt_getReturnValueInit(x))
end

"""
    getReturnValue(x::AbstractCoroutineBodyStmt) -> Expr_
Return the value the coroutine's return statement yields, or a NULL carrier when that
statement is absent or carries no value.
"""
function getReturnValue(x::AbstractCoroutineBodyStmt)
    @check_ptrs x
    return Expr_(clang_CoroutineBodyStmt_getReturnValue(x))
end

"""
    getReturnStmtOnAllocFailure(x::AbstractCoroutineBodyStmt) -> Stmt
Return the statement run when the coroutine frame allocation fails, or a NULL carrier
unless the promise type declares `get_return_object_on_allocation_failure`.
"""
function getReturnStmtOnAllocFailure(x::AbstractCoroutineBodyStmt)
    @check_ptrs x
    return Stmt(clang_CoroutineBodyStmt_getReturnStmtOnAllocFailure(x))
end

"""
    getNumParamMoves(x::AbstractCoroutineBodyStmt) -> UInt32
Return the number of parameter-move statements, one per parameter of the coroutine.

The count is an unsigned C value: widen it with `Int` before building a range, or an
empty range wraps around.
"""
function getNumParamMoves(x::AbstractCoroutineBodyStmt)
    @check_ptrs x
    return clang_CoroutineBodyStmt_getNumParamMoves(x)
end

"""
    getParamMove(x::AbstractCoroutineBodyStmt, i::Integer) -> Stmt
Return the `i`-th parameter-move statement (0-based, `i < getNumParamMoves(x)`) — the
copy of a coroutine parameter into the coroutine frame.
"""
function getParamMove(x::AbstractCoroutineBodyStmt, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumParamMoves(x) "coroutine parameter-move index $i out of range"
    return Stmt(clang_CoroutineBodyStmt_getParamMove(x, i))
end

# CoreturnStmt (cont.)
"""
    setIsImplicit(x::AbstractCoreturnStmt, value::Bool=true)
Mark the `co_return` as compiler-introduced — the fallthrough `return_void` call a
coroutine body ends with — rather than written in the source; [`isImplicit`](@ref)
reads the flag back.
"""
function setIsImplicit(x::AbstractCoreturnStmt, value::Bool=true)
    @check_ptrs x
    return clang_CoreturnStmt_setIsImplicit(x, value)
end

# CXXForRangeStmt (cont.)
"""
    setInit(x::AbstractCXXForRangeStmt, s::AbstractStmt)
Set the init-statement of the range-based `for` (the C++20 `for (init; decl : range)`
form).
"""
function setInit(x::AbstractCXXForRangeStmt, s::AbstractStmt)
    @check_ptrs x s
    return clang_CXXForRangeStmt_setInit(x, s)
end

"""
    setRangeStmt(x::AbstractCXXForRangeStmt, s::AbstractDeclStmt)
Set the implicit `__range` declaration statement.

`getRangeStmt` and `getRangeInit` cast that slot to `DeclStmt` unchecked, so the
argument is typed at `AbstractDeclStmt` here rather than at the `Stmt *` the C++
setter accepts.
"""
function setRangeStmt(x::AbstractCXXForRangeStmt, s::AbstractDeclStmt)
    @check_ptrs x s
    return clang_CXXForRangeStmt_setRangeStmt(x, s)
end

"""
    setBeginStmt(x::AbstractCXXForRangeStmt, s::AbstractDeclStmt)
Set the implicit `__begin` declaration statement.

`getBeginStmt` casts that slot to `DeclStmt` unchecked, hence the tightened argument
type.
"""
function setBeginStmt(x::AbstractCXXForRangeStmt, s::AbstractDeclStmt)
    @check_ptrs x s
    return clang_CXXForRangeStmt_setBeginStmt(x, s)
end

"""
    setEndStmt(x::AbstractCXXForRangeStmt, s::AbstractDeclStmt)
Set the implicit `__end` declaration statement.

`getEndStmt` casts that slot to `DeclStmt` unchecked, hence the tightened argument
type.
"""
function setEndStmt(x::AbstractCXXForRangeStmt, s::AbstractDeclStmt)
    @check_ptrs x s
    return clang_CXXForRangeStmt_setEndStmt(x, s)
end

"""
    setInc(x::AbstractCXXForRangeStmt, e::AbstractExpr)
Set the implicit increment expression (`++__begin`).
"""
function setInc(x::AbstractCXXForRangeStmt, e::AbstractExpr)
    @check_ptrs x e
    return clang_CXXForRangeStmt_setInc(x, e)
end

"""
    setLoopVarStmt(x::AbstractCXXForRangeStmt, s::AbstractDeclStmt)
Set the declaration statement introducing the loop variable.

`getLoopVarStmt` casts that slot to `DeclStmt` unchecked and does not tolerate a null
slot, hence the tightened argument type.
"""
function setLoopVarStmt(x::AbstractCXXForRangeStmt, s::AbstractDeclStmt)
    @check_ptrs x s
    return clang_CXXForRangeStmt_setLoopVarStmt(x, s)
end

"""
    setRangeInit(x::AbstractCXXForRangeStmt, e::AbstractExpr)
Set the range initializer — the `range` of `for (decl : range)` — as a bare expression.

This writes the same slot [`setRangeStmt`](@ref) owns. While the slot holds an
expression, [`getRangeStmt`](@ref) and [`getRangeInit`](@ref) would cast it to
`DeclStmt` unchecked, so restore the implicit `__range` declaration statement before
calling either of them again.
"""
function setRangeInit(x::AbstractCXXForRangeStmt, e::AbstractExpr)
    @check_ptrs x e
    return clang_CXXForRangeStmt_setRangeInit(x, e)
end

"""
    getNumChildrenExclBody(x::AbstractCoroutineBodyStmt) -> UInt32
Return the number of stored sub-statements other than the coroutine body: the promise
declaration, the two suspend points, the exception and fallthrough handlers, the frame
allocation and deallocation calls, the result declaration, the return value and return
statements, and one move statement per coroutine parameter.

The count is exact but the slots may be null. It is an unsigned C value: widen it with
`Int` before building a range.
"""
function getNumChildrenExclBody(x::AbstractCoroutineBodyStmt)
    @check_ptrs x
    return clang_CoroutineBodyStmt_getNumChildrenExclBody(x)
end

"""
    getChildExclBody(x::AbstractCoroutineBodyStmt, i::Integer) -> Stmt
Return the `i`-th sub-statement of the body-excluded view (0-based,
`i < getNumChildrenExclBody(x)`). Index 0 is the promise declaration statement, since
the coroutine body is the one slot this view drops.

The returned carrier may hold a null pointer: the view spans every slot, and a
coroutine without an allocation-failure path or without parameters leaves some empty.
"""
function getChildExclBody(x::AbstractCoroutineBodyStmt, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumChildrenExclBody(x) "coroutine sub-statement index $i out of range"
    return Stmt(clang_CoroutineBodyStmt_getChildExclBody(x, i))
end

# MSDependentExistsStmt
"""
    getKeywordLoc(x::AbstractMSDependentExistsStmt) -> SourceLocation
Return the location of the `__if_exists` or `__if_not_exists` keyword.
"""
function getKeywordLoc(x::AbstractMSDependentExistsStmt)
    @check_ptrs x
    return SourceLocation(clang_MSDependentExistsStmt_getKeywordLoc(x))
end

"""
    isIfExists(x::AbstractMSDependentExistsStmt) -> Bool
Test whether the block was introduced by `__if_exists` rather than `__if_not_exists`.
"""
function isIfExists(x::AbstractMSDependentExistsStmt)
    @check_ptrs x
    return clang_MSDependentExistsStmt_isIfExists(x)
end

"""
    isIfNotExists(x::AbstractMSDependentExistsStmt) -> Bool
Test whether the block was introduced by `__if_not_exists`; the exact negation of
[`isIfExists`](@ref).
"""
function isIfNotExists(x::AbstractMSDependentExistsStmt)
    @check_ptrs x
    return clang_MSDependentExistsStmt_isIfNotExists(x)
end

"""
    getQualifierRange(x::AbstractMSDependentExistsStmt) -> SourceRange
Return the extent of the nested-name-specifier qualifying the tested name — the `T::`
of `__if_exists(T::member)`. `NestedNameSpecifierLoc` has no handle of its own, so it
crosses as its two parts: the qualifier through [`getQualifier`](@ref), its written
extent here. Invalid when the name is written unqualified.
"""
function getQualifierRange(x::AbstractMSDependentExistsStmt)
    @check_ptrs x
    r = clang_MSDependentExistsStmt_getQualifierRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

"""
    getQualifier(x::AbstractMSDependentExistsStmt) -> NestedNameSpecifier
Return the nested-name-specifier qualifying the tested name, or a null carrier when the
name is written unqualified.
"""
function getQualifier(x::AbstractMSDependentExistsStmt)
    @check_ptrs x
    return NestedNameSpecifier(clang_MSDependentExistsStmt_getQualifier(x))
end

"""
    getNameInfo(x::AbstractMSDependentExistsStmt) -> DeclarationNameInfo
Return the name being tested for, with its location information.

`DeclarationNameInfo` is a value type with no pointer encoding, so this allocates and
one should call `dispose` to release the resources after using this object.
"""
function getNameInfo(x::AbstractMSDependentExistsStmt)
    @check_ptrs x
    return DeclarationNameInfo(clang_MSDependentExistsStmt_getNameInfo(x))
end

"""
    getSubStmt(x::AbstractMSDependentExistsStmt) -> CompoundStmt
Return the compound statement that is included in the program only if the existence of
the tested name matches the introducing keyword.
"""
function getSubStmt(x::AbstractMSDependentExistsStmt)
    @check_ptrs x
    return CompoundStmt(clang_MSDependentExistsStmt_getSubStmt(x))
end

"""
    getQualifierLoc(x::AbstractMSDependentExistsStmt) -> NestedNameSpecifierLoc
Return the nested-name-specifier written before the name, with its component locations.

An unqualified name yields an *empty* specifier rather than a NULL one, so test
[`hasQualifier`](@ref) rather than the handle. This function allocates and one should call
`dispose` to release the resources after using this object.
"""
function getQualifierLoc(x::AbstractMSDependentExistsStmt)
    @check_ptrs x
    return NestedNameSpecifierLoc(clang_MSDependentExistsStmt_getQualifierLoc(x))
end
