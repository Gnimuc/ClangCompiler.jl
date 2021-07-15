function jlty2llvmty(typ::Type, isboxed_ref=Ref{Bool}(false))
    ccall(:jl_type_to_llvm, LLVM.API.LLVMTypeRef, (Any, Ptr{Bool}), typ, isboxed_ref)
end
