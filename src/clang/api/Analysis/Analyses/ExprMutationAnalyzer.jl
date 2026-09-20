# ExprMutationAnalyzer — "is this expression written through, anywhere inside the statement
# I was built over?" (clang/Analysis/Analyses/ExprMutationAnalyzer.h). Each query runs AST
# matchers over the whole statement and memoizes its answer, so one analyzer per statement
# is the intended use. The analyzer stores the statement and the `ASTContext` as C++
# references, so both must outlive it, and every `Expr` or `Decl` passed to a query has to
# come from them.

"""
    ExprMutationAnalyzer(stmt::AbstractStmt, ctx::AbstractASTContext) -> ExprMutationAnalyzer
Return an analyzer over `stmt` — normally a function body.

This function allocates and one should call `dispose` to release the resources after using
this object. `stmt` and `ctx` must outlive it.
"""
function ExprMutationAnalyzer(stmt::AbstractStmt, ctx::AbstractASTContext)
    @check_ptrs stmt ctx
    return ExprMutationAnalyzer(clang_ExprMutationAnalyzer_create(stmt, ctx))
end

dispose(x::ExprMutationAnalyzer) = clang_ExprMutationAnalyzer_dispose(x)

"""
    isMutated(x::AbstractExprMutationAnalyzer, e::AbstractExpr) -> Bool
Return whether `e` is mutated somewhere in the analyzed statement — the same answer as
`findMutation(x, e)` giving a non-NULL statement.
"""
function isMutated(x::AbstractExprMutationAnalyzer, e::AbstractExpr)
    @check_ptrs x e
    return clang_ExprMutationAnalyzer_isMutated(x, e)
end

"""
    isMutated(x::AbstractExprMutationAnalyzer, d::AbstractDecl) -> Bool
Return whether the entity `d` declares is mutated somewhere in the analyzed statement —
`isMutated` applied to every reference to `d` the statement contains.
"""
function isMutated(x::AbstractExprMutationAnalyzer, d::AbstractDecl)
    @check_ptrs x d
    return clang_ExprMutationAnalyzer_isMutatedFromDecl(x, d)
end

"""
    findMutation(x::AbstractExprMutationAnalyzer, e::AbstractExpr) -> Stmt
Return the statement that mutates `e`. The wrapped pointer is NULL when nothing does; which
one is reported when several do is unspecified. `resolve` it to refine the statement class.
"""
function findMutation(x::AbstractExprMutationAnalyzer, e::AbstractExpr)
    @check_ptrs x e
    return Stmt(clang_ExprMutationAnalyzer_findMutation(x, e))
end

"""
    findMutation(x::AbstractExprMutationAnalyzer, d::AbstractDecl) -> Stmt
Return the statement that mutates the entity `d` declares; NULL-pointered when nothing
does.
"""
function findMutation(x::AbstractExprMutationAnalyzer, d::AbstractDecl)
    @check_ptrs x d
    return Stmt(clang_ExprMutationAnalyzer_findMutationFromDecl(x, d))
end

"""
    isPointeeMutated(x::AbstractExprMutationAnalyzer, e::AbstractExpr) -> Bool
Return whether what `e` points at is mutated, as opposed to `e` itself: `*p = 1` mutates
the pointee of `p`, not `p`.
"""
function isPointeeMutated(x::AbstractExprMutationAnalyzer, e::AbstractExpr)
    @check_ptrs x e
    return clang_ExprMutationAnalyzer_isPointeeMutated(x, e)
end

"""
    isPointeeMutated(x::AbstractExprMutationAnalyzer, d::AbstractDecl) -> Bool
Return whether what the entity `d` declares points at is mutated.
"""
function isPointeeMutated(x::AbstractExprMutationAnalyzer, d::AbstractDecl)
    @check_ptrs x d
    return clang_ExprMutationAnalyzer_isPointeeMutatedFromDecl(x, d)
end

"""
    findPointeeMutation(x::AbstractExprMutationAnalyzer, e::AbstractExpr) -> Stmt
Return the statement that mutates what `e` points at; NULL-pointered when nothing does.
"""
function findPointeeMutation(x::AbstractExprMutationAnalyzer, e::AbstractExpr)
    @check_ptrs x e
    return Stmt(clang_ExprMutationAnalyzer_findPointeeMutation(x, e))
end

"""
    findPointeeMutation(x::AbstractExprMutationAnalyzer, d::AbstractDecl) -> Stmt
Return the statement that mutates what the entity `d` declares points at; NULL-pointered
when nothing does.
"""
function findPointeeMutation(x::AbstractExprMutationAnalyzer, d::AbstractDecl)
    @check_ptrs x d
    return Stmt(clang_ExprMutationAnalyzer_findPointeeMutationFromDecl(x, d))
end

"""
    isUnevaluated(smt::AbstractStmt, stm::AbstractStmt, ctx::AbstractASTContext) -> Bool
Return whether `smt` is an unevaluated operand — of a `sizeof`, `decltype`, `noexcept` or
`typeid` — where a write would never actually happen. This is
`clang::ExprMutationAnalyzer::isUnevaluated`, a static predicate needing no analyzer. `stm`
is accepted and ignored: LLVM 20 dropped the enclosing-statement parameter. It must still
be non-null, which this wrapper checks.

Not to be confused with the one-argument `isUnevaluated(::AbstractStringLiteral)`, which is
clang's unrelated same-named accessor on string literals.
"""
function isUnevaluated(smt::AbstractStmt, stm::AbstractStmt, ctx::AbstractASTContext)
    @check_ptrs smt stm ctx
    return clang_ExprMutationAnalyzer_isUnevaluated(smt, stm, ctx)
end

# FunctionParmMutationAnalyzer — an `ExprMutationAnalyzer` over a function body, asked one
# parameter at a time.

"""
    FunctionParmMutationAnalyzer(func::AbstractFunctionDecl,
                                 ctx::AbstractASTContext) -> FunctionParmMutationAnalyzer
Return an analyzer over the body of `func`.

`func` must have a body: clang's constructor is `BodyAnalyzer(*Func.getBody(), Context)`
and dereferences that body with no null check.

This function allocates and one should call `dispose` to release the resources after using
this object. The body and `ctx` must outlive it.
"""
function FunctionParmMutationAnalyzer(func::AbstractFunctionDecl, ctx::AbstractASTContext)
    @check_ptrs func ctx
    @assert hasBody(func) "the function must have a body in this translation unit"
    return FunctionParmMutationAnalyzer(clang_FunctionParmMutationAnalyzer_create(func, ctx))
end

dispose(x::FunctionParmMutationAnalyzer) = clang_FunctionParmMutationAnalyzer_dispose(x)

"""
    isMutated(x::AbstractFunctionParmMutationAnalyzer, parm::AbstractParmVarDecl) -> Bool
Return whether `parm` is written to inside the function body. `parm` must be a parameter of
the function the analyzer was built from.
"""
function isMutated(x::AbstractFunctionParmMutationAnalyzer, parm::AbstractParmVarDecl)
    @check_ptrs x parm
    return clang_FunctionParmMutationAnalyzer_isMutated(x, parm)
end

"""
    findMutation(x::AbstractFunctionParmMutationAnalyzer,
                 parm::AbstractParmVarDecl) -> Stmt
Return the statement that mutates `parm`; NULL-pointered when nothing does.
"""
function findMutation(x::AbstractFunctionParmMutationAnalyzer, parm::AbstractParmVarDecl)
    @check_ptrs x parm
    return Stmt(clang_FunctionParmMutationAnalyzer_findMutation(x, parm))
end
