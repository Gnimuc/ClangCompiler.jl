function lookup_function(mod::LLVM.Module, func_name::String)
    LLVM.Function(LLVM.API.LLVMGetNamedFunction(mod, func_name))
end

lookup_function(ee::ExecutionEngine, func_name::String) = functions(ee)[func_name]

link(lib::AbstractString) = LLVM.load_library_permantly(lib)

link_crt(ee::ExecutionEngine) = LLVM.API.LLVMRunStaticConstructors(ee.ref)
