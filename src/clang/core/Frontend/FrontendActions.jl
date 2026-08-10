# The concrete clang::FrontendActions that need nothing but a default construction. Each
# carries the base CXFrontendAction handle its factory returns, the same way the
# CodeGen Emit*Action carriers all carry CXCodeGenAction.
#
# Their abstracts subtype AbstractFrontendAction directly rather than an
# AbstractASTFrontendAction: clang's ASTFrontendAction declares no member function this
# library reaches, and AbstractCodeGenAction — whose C++ class is also an ASTFrontendAction
# — already stands one level under AbstractFrontendAction for the same reason.

"""
    struct ReadPCHAndPreprocessAction <: AbstractReadPCHAndPreprocessAction
Hold a pointer to a `clang::ReadPCHAndPreprocessAction` object.
"""
struct ReadPCHAndPreprocessAction <: AbstractReadPCHAndPreprocessAction
    ptr::CXFrontendAction
end

"""
    struct ASTPrintAction <: AbstractASTPrintAction
Hold a pointer to a `clang::ASTPrintAction` object.
"""
struct ASTPrintAction <: AbstractASTPrintAction
    ptr::CXFrontendAction
end

"""
    struct ASTDumpAction <: AbstractASTDumpAction
Hold a pointer to a `clang::ASTDumpAction` object.
"""
struct ASTDumpAction <: AbstractASTDumpAction
    ptr::CXFrontendAction
end

"""
    struct GeneratePCHAction <: AbstractGeneratePCHAction
Hold a pointer to a `clang::GeneratePCHAction` object.
"""
struct GeneratePCHAction <: AbstractGeneratePCHAction
    ptr::CXFrontendAction
end

"""
    struct SyntaxOnlyAction <: AbstractSyntaxOnlyAction
Hold a pointer to a `clang::SyntaxOnlyAction` object.
"""
struct SyntaxOnlyAction <: AbstractSyntaxOnlyAction
    ptr::CXFrontendAction
end

"""
    struct FrontendAction <: AbstractFrontendAction
Hold a pointer to a `clang::FrontendAction` object whose dynamic class is not known here.

This is what [`CreateFrontendAction`](@ref) hands back: clang picks the class from
`FrontendOptions.ProgramAction`, so the only thing the Julia side can say about it is that
it is some `clang::FrontendAction`. Every base-class query and the base
[`dispose`](@ref) accept it.
"""
struct FrontendAction <: AbstractFrontendAction
    ptr::CXFrontendAction
end
