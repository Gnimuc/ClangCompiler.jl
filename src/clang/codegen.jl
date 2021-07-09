"""
    abstract type AbstractCodeGenerator <: Any
Supertype for Clang code generator types.
"""
abstract type AbstractCodeGenerator end

"""
    mutable struct CodeGenerator <: AbstractCodeGenerator
Holds a pointer to a `clang::CodeGenerator` object.
"""
mutable struct CodeGenerator <: AbstractCodeGenerator
    ptr::CXCodeGenerator
end

function handle_translation_unit(cg::CodeGenerator, ctx::ASTContext)
    @assert cg.ptr != C_NULL "CodeGenerator has a NULL pointer."
    @assert ctx.ptr != C_NULL "ASTContext has a NULL pointer."
    clang_CodeGenerator_HandleTranslationUnit(cg.ptr, ctx.ptr)
end

function get_llvm_module(cg::CodeGenerator)
    @assert cg.ptr != C_NULL "CodeGenerator has a NULL pointer."
    return clang_CodeGenerator_getLLVMModule(cg.ptr)
end
