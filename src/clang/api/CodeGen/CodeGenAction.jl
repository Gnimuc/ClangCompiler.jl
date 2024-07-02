# AbstractCodeGenAction
function takeModule(x::T) where {T<:AbstractCodeGenAction}
    @check_ptrs x
    m = clang_CodeGenAction_takeModule(x)
    m == C_NULL && error("failed to generate IR.")
    return LLVM.Module(m)
end

dispose(x::AbstractCodeGenAction) = clang_CodeGenAction_dispose(x)

# LLVMOnlyAction
LLVMOnlyAction(ctx::LLVM.Context) = LLVMOnlyAction(create_emit_llvm_only_action(ctx))

function create_emit_llvm_only_action(ctx::LLVM.Context)
    act = clang_EmitLLVMOnlyAction_create(ctx.ref)
    @assert act != C_NULL "Failed to create EmitLLVMOnlyAction"
    return act
end
