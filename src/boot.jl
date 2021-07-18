@generated function clang_Preprocessor_enableIncrementalProcessing(pp)
    m = get_module(BOOT_COMPILER_REF[])
    f = lookup_function(m, "clang_Preprocessor_enableIncrementalProcessing")
    call_function(f, Cvoid, Tuple{Core.LLVMPtr{Int8,0}}, :(reinterpret(Core.LLVMPtr{Int8,0}, pp)))
end

@generated function clang_Preprocessor_isIncrementalProcessingEnabled(pp)
    m = get_module(BOOT_COMPILER_REF[])
    f = lookup_function(m, "clang_Preprocessor_isIncrementalProcessingEnabled")
    @show f
    call_function(f, LLVM.Int1Type(BOOT_COMPILER_REF[].ctx), Tuple{Core.LLVMPtr{Int8,0}}, :(reinterpret(Core.LLVMPtr{Int8,0}, pp)))
end
