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

# EmitAssemblyAction / EmitBCAction / EmitLLVMAction / EmitCodeGenOnlyAction / EmitObjAction
# Each create returns the base CodeGenAction handle and shares the base dispose above.
function EmitAssemblyAction(ctx::LLVM.Context)
    act = clang_EmitAssemblyAction_create(ctx.ref)
    @assert act != C_NULL "Failed to create EmitAssemblyAction"
    return EmitAssemblyAction(act)
end

function EmitBCAction(ctx::LLVM.Context)
    act = clang_EmitBCAction_create(ctx.ref)
    @assert act != C_NULL "Failed to create EmitBCAction"
    return EmitBCAction(act)
end

function EmitLLVMAction(ctx::LLVM.Context)
    act = clang_EmitLLVMAction_create(ctx.ref)
    @assert act != C_NULL "Failed to create EmitLLVMAction"
    return EmitLLVMAction(act)
end

function EmitCodeGenOnlyAction(ctx::LLVM.Context)
    act = clang_EmitCodeGenOnlyAction_create(ctx.ref)
    @assert act != C_NULL "Failed to create EmitCodeGenOnlyAction"
    return EmitCodeGenOnlyAction(act)
end

function EmitObjAction(ctx::LLVM.Context)
    act = clang_EmitObjAction_create(ctx.ref)
    @assert act != C_NULL "Failed to create EmitObjAction"
    return EmitObjAction(act)
end
