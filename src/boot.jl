@generated function clang_Preprocessor_enableIncrementalProcessing(pp)
    m = get_module(BOOT_COMPILER_REF[])
    f = lookup_function(m, "clang_Preprocessor_enableIncrementalProcessing")
    @show f
    call_function(f, Cvoid, Tuple{Ptr{Cvoid}}, :pp)
end
