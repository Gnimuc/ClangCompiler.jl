# MangleContext
"""
    createMangleContext(x::ASTContext, ti::TargetInfo) -> MangleContext
Create a name mangler for the target. The result is a caller-owned heap object
with no dispose entry point (a known leak in the C shim).
"""
function createMangleContext(x::ASTContext, ti::TargetInfo)
    @check_ptrs x ti
    return MangleContext(clang_ASTContext_createMangleContext(x, ti))
end

function getKind(x::MangleContext)
    @check_ptrs x
    return clang_MangleContext_getKind(x)
end

function getASTContext(x::MangleContext)
    @check_ptrs x
    return ASTContext(clang_MangleContext_getASTContext(x))
end

function getDiags(x::MangleContext)
    @check_ptrs x
    return DiagnosticsEngine(clang_MangleContext_getDiags(x))
end

function getAnonymousStructId(x::MangleContext, d::AbstractNamedDecl)
    @check_ptrs x d
    return clang_MangleContext_getAnonymousStructId(x, d)
end

function shouldMangleDeclName(x::MangleContext, d::AbstractNamedDecl)
    @check_ptrs x d
    return clang_MangleContext_shouldMangleDeclName(x, d)
end

function shouldMangleCXXName(x::MangleContext, d::AbstractNamedDecl)
    @check_ptrs x d
    return clang_MangleContext_shouldMangleCXXName(x, d)
end

function shouldMangleStringLiteral(x::MangleContext, sl::AbstractStringLiteral)
    @check_ptrs x sl
    return clang_MangleContext_shouldMangleStringLiteral(x, sl)
end

"""
    mangleName(x::MangleContext, d::AbstractNamedDecl) -> String
Return the mangled linkage name of a non-constructor/destructor declaration.
"""
function mangleName(x::MangleContext, d::AbstractNamedDecl)
    @check_ptrs x d
    return get_string(clang_MangleContext_mangleName(x, d))
end

# ASTNameGenerator
function getName(x::ASTNameGenerator, d::AbstractDecl)
    @check_ptrs x d
    return get_string(clang_ASTNameGenerator_getName(x, d))
end

"""
    getAllManglings(x::ASTNameGenerator, d::AbstractDecl) -> Vector{String}
Return all of the mangled names of the declaration (constructors and destructors have
several).
"""
function getAllManglings(x::ASTNameGenerator, d::AbstractDecl)
    @check_ptrs x d
    return get_string(clang_ASTNameGenerator_getAllManglings(x, d))
end
