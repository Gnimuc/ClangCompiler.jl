"""
    mutable struct CodeGenerator <: AbstractASTConsumer
Holds a pointer to a `clang::CodeGenerator` object.
"""
mutable struct CodeGenerator <: AbstractASTConsumer
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

"""
    abstract type AbstractCodeGenAction <: AbstractFrontendAction
Supertype for CodeGenActions.
"""
abstract type AbstractCodeGenAction <:AbstractFrontendAction end

function take_module(x::T) where {T<:AbstractCodeGenAction}
    @assert x.ptr != C_NULL "$T has a NULL pointer."
    m = clang_CodeGenAction_takeModule(x.ptr)
    m == C_NULL && error("failed to generate IR.")
    return LLVM.Module(m)
end

function destroy(x::AbstractCodeGenAction)
    if x.ptr != C_NULL
        clang_CodeGenAction_dispose(x.ptr)
        x.ptr = C_NULL
    end
    return x
end

mutable struct LLVMOnlyAction <: AbstractCodeGenAction
    ptr::CXCodeGenAction
end
LLVMOnlyAction(ctx::Context) = LLVMOnlyAction(create_emit_llvm_only_action(ctx))

function create_emit_llvm_only_action(llvm_ctx::LLVMContextRef)
    status = Ref{CXInit_Error}(CXInit_NoError)
    act = clang_EmitLLVMOnlyAction_create(status, llvm_ctx)
    @assert status[] == CXInit_NoError
    return act
end
create_emit_llvm_only_action(ctx::Context) = create_emit_llvm_only_action(ctx.ref)
