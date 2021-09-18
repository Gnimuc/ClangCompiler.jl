"""
    struct CodeGenerator <: AbstractASTConsumer
Hold a pointer to a `clang::CodeGenerator` object.
"""
struct CodeGenerator <: AbstractASTConsumer
    ptr::CXCodeGenerator
end

function get_llvm_module(x::CodeGenerator)
    @check_ptrs x
    return LLVM.Module(clang_CodeGenerator_GetModule(x.ptr))
end

function release_llvm_module(x::CodeGenerator)
    @check_ptrs x
    return LLVM.Module(clang_CodeGenerator_ReleaseModule(x.ptr))
end

function get_decl(x::CodeGenerator, s::String)
    @check_ptrs x
    return Decl(clang_CodeGenerator_GetDeclForMangledName(x.ptr, s))
end

function start_llvm_module(x::CodeGenerator, ctx::Context, mod_name::String)
    @check_ptrs x
    @assert ctx.ref != C_NULL "LLVMContextRef has a NULL pointer."
    return LLVM.Module(clang_CodeGenerator_StartModule(x.ptr, ctx.ref, mod_name))
end
