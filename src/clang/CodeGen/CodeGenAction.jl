"""
    abstract type AbstractCodeGenAction <: AbstractFrontendAction
Supertype for `CodeGenAction`s.
"""
abstract type AbstractCodeGenAction <: AbstractFrontendAction end

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

function create_emit_llvm_only_action(ctx::Context)
    status = Ref{CXInit_Error}(CXInit_NoError)
    act = clang_EmitLLVMOnlyAction_create(status, ctx.ref)
    @assert status[] == CXInit_NoError
    return act
end
