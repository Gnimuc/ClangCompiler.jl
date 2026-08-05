
struct LLVMOnlyAction <: AbstractLLVMOnlyAction
    ptr::CXCodeGenAction
end

"""
    struct EmitAssemblyAction <: AbstractEmitAssemblyAction
Hold a pointer to a `clang::EmitAssemblyAction` object.
"""
struct EmitAssemblyAction <: AbstractEmitAssemblyAction
    ptr::CXCodeGenAction
end

"""
    struct EmitBCAction <: AbstractEmitBCAction
Hold a pointer to a `clang::EmitBCAction` object.
"""
struct EmitBCAction <: AbstractEmitBCAction
    ptr::CXCodeGenAction
end

"""
    struct EmitLLVMAction <: AbstractEmitLLVMAction
Hold a pointer to a `clang::EmitLLVMAction` object.
"""
struct EmitLLVMAction <: AbstractEmitLLVMAction
    ptr::CXCodeGenAction
end

"""
    struct EmitCodeGenOnlyAction <: AbstractEmitCodeGenOnlyAction
Hold a pointer to a `clang::EmitCodeGenOnlyAction` object.
"""
struct EmitCodeGenOnlyAction <: AbstractEmitCodeGenOnlyAction
    ptr::CXCodeGenAction
end

"""
    struct EmitObjAction <: AbstractEmitObjAction
Hold a pointer to a `clang::EmitObjAction` object.
"""
struct EmitObjAction <: AbstractEmitObjAction
    ptr::CXCodeGenAction
end
