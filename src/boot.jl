function clang_Preprocessor_enableIncrementalProcessing(pp)
    jit = get_jit(BOOT_COMPILER_REF[])
    addr = lookup(jit, "clang_Preprocessor_enableIncrementalProcessing")
    return ccall(pointer(addr), Cvoid, (CXPreprocessor,), pp)
end

function clang_Preprocessor_isIncrementalProcessingEnabled(pp)
    jit = get_jit(BOOT_COMPILER_REF[])
    addr = lookup(jit, "clang_Preprocessor_isIncrementalProcessingEnabled")
    return ccall(pointer(addr), Bool, (CXPreprocessor,), pp)
end
