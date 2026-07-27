# ConstructionContext — where the object a `CXXConstructExpr` (or a class-prvalue call)
# builds is going to live (clang/Analysis/ConstructionContext.h). Reach one with
# `getElementConstructionContext` on a `Constructor` / `CXXRecordTypedCall` CFG element;
# the carrier is borrowed from that graph's arena and dies with `dispose(::CFG)`.
#
# clang declares the payload accessors on the twelve concrete subclasses. The C shim
# guards each one with a `dyn_cast` and answers NULL (0 for `getIndex`) on every other
# kind, so each wrapper below takes the base `AbstractConstructionContext`: branch on
# `getKind`, or on a NULL-pointer carrier, to find out which payload a context carries.
function getKind(x::AbstractConstructionContext)
    @check_ptrs x
    return clang_ConstructionContext_getKind(x)
end

"""
    getDeclStmt(x::AbstractConstructionContext) -> DeclStmt
Return the declaration statement the object is constructed into. The wrapped pointer is
NULL unless the kind is `SimpleVariableKind` or `CXX17ElidedCopyVariableKind`.
"""
function getDeclStmt(x::AbstractConstructionContext)
    @check_ptrs x
    return DeclStmt(clang_ConstructionContext_getDeclStmt(x))
end

"""
    getCXXCtorInitializer(x::AbstractConstructionContext) -> CXXCtorInitializer
Return the member/base initializer the object is constructed into. The wrapped pointer
is NULL unless the kind is `SimpleConstructorInitializerKind` or
`CXX17ElidedCopyConstructorInitializerKind`.
"""
function getCXXCtorInitializer(x::AbstractConstructionContext)
    @check_ptrs x
    return CXXCtorInitializer(clang_ConstructionContext_getCXXCtorInitializer(x))
end

"""
    getCXXNewExpr(x::AbstractConstructionContext) -> CXXNewExpr
Return the `new` expression the object is constructed into. The wrapped pointer is NULL
unless the kind is `NewAllocatedObjectKind`.
"""
function getCXXNewExpr(x::AbstractConstructionContext)
    @check_ptrs x
    return CXXNewExpr(clang_ConstructionContext_getCXXNewExpr(x))
end

"""
    getCXXBindTemporaryExpr(x::AbstractConstructionContext) -> CXXBindTemporaryExpr
Return the expression that binds the constructed temporary for destruction. clang
declares this payload on five unrelated subclasses, so the wrapped pointer is non-NULL
only for the `CXX17ElidedCopyVariableKind`,
`CXX17ElidedCopyConstructorInitializerKind`, `SimpleTemporaryObjectKind`,
`ElidedTemporaryObjectKind`, `CXX17ElidedCopyReturnedValueKind` and `ArgumentKind`
kinds — and NULL on those too when the temporary's destructor is trivial.
"""
function getCXXBindTemporaryExpr(x::AbstractConstructionContext)
    @check_ptrs x
    return CXXBindTemporaryExpr(clang_ConstructionContext_getCXXBindTemporaryExpr(x))
end

"""
    getMaterializedTemporaryExpr(x::AbstractConstructionContext) -> MaterializeTemporaryExpr
Return the expression that materializes the constructed temporary. The wrapped pointer
is NULL unless the kind is `SimpleTemporaryObjectKind` or `ElidedTemporaryObjectKind`,
and NULL on those too when the temporary is never used after construction.
"""
function getMaterializedTemporaryExpr(x::AbstractConstructionContext)
    @check_ptrs x
    return MaterializeTemporaryExpr(clang_ConstructionContext_getMaterializedTemporaryExpr(x))
end

"""
    getConstructorAfterElision(x::AbstractConstructionContext) -> CXXConstructExpr
Return the copy/move constructor call that was elided over this temporary. The wrapped
pointer is NULL unless the kind is `ElidedTemporaryObjectKind`.
"""
function getConstructorAfterElision(x::AbstractConstructionContext)
    @check_ptrs x
    return CXXConstructExpr(clang_ConstructionContext_getConstructorAfterElision(x))
end

"""
    getConstructionContextAfterElision(x::AbstractConstructionContext) -> ConstructionContext
Return the construction context the elided-over copy would itself have used. The
wrapped pointer is NULL unless the kind is `ElidedTemporaryObjectKind`; the result is
borrowed from the same `CFG` arena as `x`.
"""
function getConstructionContextAfterElision(x::AbstractConstructionContext)
    @check_ptrs x
    return ConstructionContext(clang_ConstructionContext_getConstructionContextAfterElision(x))
end

"""
    getReturnStmt(x::AbstractConstructionContext) -> ReturnStmt
Return the `return` statement the object is constructed into. The wrapped pointer is
NULL unless the kind is `SimpleReturnedValueKind` or
`CXX17ElidedCopyReturnedValueKind`.
"""
function getReturnStmt(x::AbstractConstructionContext)
    @check_ptrs x
    return ReturnStmt(clang_ConstructionContext_getReturnStmt(x))
end

"""
    getCallLikeExpr(x::AbstractConstructionContext) -> Expr_
Return the call the object is constructed as an argument of — a `CallExpr`, a
`CXXConstructExpr` or an `ObjCMessageExpr`; `resolve` it to refine. The wrapped pointer
is NULL unless the kind is `ArgumentKind`.
"""
function getCallLikeExpr(x::AbstractConstructionContext)
    @check_ptrs x
    return Expr_(clang_ConstructionContext_getCallLikeExpr(x))
end

"""
    getIndex(x::AbstractConstructionContext) -> UInt32
Return the argument index (`ArgumentKind`) or the captured-element index
(`LambdaCaptureKind`). Only those two kinds carry an index and the C function answers 0
for every other one — 0 is itself a valid index, so the kind is asserted here rather
than read back as a sentinel (Invariant 3).
"""
function getIndex(x::AbstractConstructionContext)
    @check_ptrs x
    k = getKind(x)
    @assert k == CXConstructionContextKind_ArgumentKind ||
            k == CXConstructionContextKind_LambdaCaptureKind "context must carry an index"
    return clang_ConstructionContext_getIndex(x)
end

"""
    getLambdaExpr(x::AbstractConstructionContext) -> LambdaExpr
Return the lambda whose capture the object is constructed into. The wrapped pointer is
NULL unless the kind is `LambdaCaptureKind`.
"""
function getLambdaExpr(x::AbstractConstructionContext)
    @check_ptrs x
    return LambdaExpr(clang_ConstructionContext_getLambdaExpr(x))
end

"""
    getInitializer(x::AbstractConstructionContext) -> Expr_
Return the capture initializer at this context's index. The wrapped pointer is NULL
unless the kind is `LambdaCaptureKind`. PARTIAL:
`clang::LambdaCaptureConstructionContext::getInitializer` indexes the lambda's
capture-initializer list with the stored index and bounds-checks nothing; the index is
in range by construction, because only clang's own CFG builder creates these contexts.
"""
function getInitializer(x::AbstractConstructionContext)
    @check_ptrs x
    return Expr_(clang_ConstructionContext_getInitializer(x))
end

"""
    getFieldDecl(x::AbstractConstructionContext) -> FieldDecl
Return the closure-class field the capture is stored in. The wrapped pointer is NULL
unless the kind is `LambdaCaptureKind`. PARTIAL in the same way as `getInitializer`: it
advances the lambda class's field list by the stored index with no bounds check.
"""
function getFieldDecl(x::AbstractConstructionContext)
    @check_ptrs x
    return FieldDecl(clang_ConstructionContext_getFieldDecl(x))
end
