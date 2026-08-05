"""
    struct MangleContext <: AbstractMangleContext
Hold a pointer to a `clang::MangleContext` object.
"""
struct MangleContext <: AbstractMangleContext
    ptr::CXMangleContext
end

"""
    struct ASTNameGenerator <: AbstractASTNameGenerator
Hold a pointer to a `clang::ASTNameGenerator` object.
"""
struct ASTNameGenerator <: AbstractASTNameGenerator
    ptr::CXASTNameGenerator
end

"""
    struct ItaniumMangleContext <: AbstractItaniumMangleContext
Hold a pointer to a `clang::ItaniumMangleContext` object.
"""
struct ItaniumMangleContext <: AbstractItaniumMangleContext
    ptr::CXItaniumMangleContext
end

