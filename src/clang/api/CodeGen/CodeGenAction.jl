# AbstractCodeGenAction
function takeModule(x::T) where {T<:AbstractCodeGenAction}
    @check_ptrs x
    m = clang_CodeGenAction_takeModule(x)
    m == C_NULL && error("failed to generate IR.")
    return LLVM.Module(m)
end

"""
    takeLLVMContext(x::AbstractCodeGenAction) -> LLVM.Context
The LLVM context the action is using, with ownership handed back to the caller.

Every constructor in this file supplies the context, so what comes back is that same
context: the caller already owns it, and this only stops the action from claiming it too.
Disposing it twice — once through the returned object and once through the one passed in —
is a double free.
"""
function takeLLVMContext(x::AbstractCodeGenAction)
    @check_ptrs x
    ctx = clang_CodeGenAction_takeLLVMContext(x)
    @assert ctx != C_NULL "the action has no LLVM context"
    return LLVM.Context(ctx)
end

"""
    getCodeGenerator(x::AbstractCodeGenAction) -> Union{Nothing,CodeGenerator}
The action's code generator, which is the way from an action-driven compile into the whole
`CodeGenerator`/`CodeGenModule` surface without going through an `Interpreter`.

`nothing` until the action has created its backend consumer, which happens inside
`CreateASTConsumer` — i.e. only once `ExecuteAction` has started it. The result belongs to
the action; never `dispose` it.
"""
function getCodeGenerator(x::AbstractCodeGenAction)
    @check_ptrs x
    cg = clang_CodeGenAction_getCodeGenerator(x)
    return cg == C_NULL ? nothing : CodeGenerator(cg)
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
