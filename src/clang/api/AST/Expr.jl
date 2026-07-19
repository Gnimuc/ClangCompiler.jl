# Expr
function getType(x::AbstractExpr)
    @check_ptrs x
    return QualType(clang_Expr_getType(x))
end

function getValueKind(x::AbstractExpr)
    @check_ptrs x
    return clang_Expr_getValueKind(x)
end

function isLValue(x::AbstractExpr)
    @check_ptrs x
    return clang_Expr_isLValue(x)
end

function isPRValue(x::AbstractExpr)
    @check_ptrs x
    return clang_Expr_isPRValue(x)
end

function isXValue(x::AbstractExpr)
    @check_ptrs x
    return clang_Expr_isXValue(x)
end

function isGLValue(x::AbstractExpr)
    @check_ptrs x
    return clang_Expr_isGLValue(x)
end

function IgnoreImpCasts(x::AbstractExpr)
    @check_ptrs x
    return Expr_(clang_Expr_IgnoreImpCasts(x))
end

function IgnoreCasts(x::AbstractExpr)
    @check_ptrs x
    return Expr_(clang_Expr_IgnoreCasts(x))
end

function IgnoreParens(x::AbstractExpr)
    @check_ptrs x
    return Expr_(clang_Expr_IgnoreParens(x))
end

function IgnoreParenCasts(x::AbstractExpr)
    @check_ptrs x
    return Expr_(clang_Expr_IgnoreParenCasts(x))
end

function IgnoreParenImpCasts(x::AbstractExpr)
    @check_ptrs x
    return Expr_(clang_Expr_IgnoreParenImpCasts(x))
end
