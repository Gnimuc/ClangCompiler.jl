"""
    mutable struct CodeGenerator <: AbstractASTConsumer
Holds a pointer to a `clang::CodeGenerator` object.
"""
mutable struct CodeGenerator <: AbstractASTConsumer
    ptr::CXCodeGenerator
end

function get_llvm_module(cg::CodeGenerator)
    @assert cg.ptr != C_NULL "CodeGenerator has a NULL pointer."
    return clang_CodeGenerator_getLLVMModule(cg.ptr)
end
