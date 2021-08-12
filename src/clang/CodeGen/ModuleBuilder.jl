"""
    struct CodeGenerator <: AbstractASTConsumer
Hold a pointer to a `clang::CodeGenerator` object.
"""
struct CodeGenerator <: AbstractASTConsumer
    ptr::CXCodeGenerator
end

function get_llvm_module(cg::CodeGenerator)
    @assert cg.ptr != C_NULL "CodeGenerator has a NULL pointer."
    return LLVM.Module(clang_CodeGenerator_GetModule(cg.ptr))
end

function release_llvm_module(cg::CodeGenerator)
    @assert cg.ptr != C_NULL "CodeGenerator has a NULL pointer."
    return LLVM.Module(clang_CodeGenerator_ReleaseModule(cg.ptr))
end

function get_decl(cg::CodeGenerator, s::String)
    @assert cg.ptr != C_NULL "CodeGenerator has a NULL pointer."
    return Decl(clang_CodeGenerator_GetDeclForMangledName(cg.ptr, s))
end

function start_llvm_module(cg::CodeGenerator, ctx::Context, mod_name::String)
    @assert cg.ptr != C_NULL "CodeGenerator has a NULL pointer."
    @assert ctx.ref != C_NULL "LLVMContextRef has a NULL pointer."
    return LLVM.Module(clang_CodeGenerator_StartModule(cg.ptr, ctx.ref, mod_name))
end
