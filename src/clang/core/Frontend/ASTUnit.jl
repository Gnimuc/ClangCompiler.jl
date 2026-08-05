# `clang::ASTUnit` derives from nothing, so its abstract supertype is declared
# here next to the carrier rather than in the inheritance tree of abstract.jl.
abstract type AbstractASTUnit end

"""
    struct ASTUnit <: AbstractASTUnit
Hold a pointer to a `clang::ASTUnit` object.
"""
struct ASTUnit <: AbstractASTUnit
    ptr::CXASTUnit
end

