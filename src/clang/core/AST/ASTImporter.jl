"""
    abstract type AbstractASTImporter <: Any
Supertype for `clang::ASTImporter`s.
"""
abstract type AbstractASTImporter end

"""
    struct ASTImporter <: AbstractASTImporter
Hold a pointer to a `clang::ASTImporter` object.
"""
struct ASTImporter <: AbstractASTImporter
    ptr::CXASTImporter
end
