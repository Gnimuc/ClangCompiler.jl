function jlty2llvmty(ty::Type, isboxed_ref=Ref{Bool}(false))
    ccall(:jl_type_to_llvm, LLVM.API.LLVMTypeRef, (Any, Ptr{Bool}), ty, isboxed_ref)
end

function lookup_function(mod::LLVM.Module, func_name::String)
    LLVM.Function(LLVM.API.LLVMGetNamedFunction(mod, func_name))
end

lookup_function(ee::LLVM.ExecutionEngine, func_name::String) = functions(ee)[func_name]

link(lib::AbstractString) = LLVM.load_library_permantly(lib)

link_crt(ee::LLVM.ExecutionEngine) = LLVM.API.LLVMRunStaticConstructors(ee.ref)

function get_buffer(x::String, name="", copy=true)
    data = unsafe_wrap(Vector{UInt8}, x)
    return LLVM.MemoryBuffer(data, name, copy)
end
