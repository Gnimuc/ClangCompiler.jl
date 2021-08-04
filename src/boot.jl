function print_julia_version()
    jit = get_jit(BOOT_COMPILER_REF[])
    addr = lookup(jit, "print_julia_version")
    return ccall(pointer(addr), Cvoid, ())
end

function clang_Parser_tryParseAndSkipInvalidOrParsedDecl(Parser, CodeGen)
    jit = get_jit(BOOT_COMPILER_REF[])
    addr = lookup(jit, "clang_Parser_tryParseAndSkipInvalidOrParsedDecl")
    return ccall(pointer(addr), Bool, (CXPreprocessor, CXCodeGenerator), Parser, CodeGen)
end

function clang_Sema_processWeakTopLevelDecls(Sema, CodeGen)
    jit = get_jit(BOOT_COMPILER_REF[])
    addr = lookup(jit, "clang_Sema_processWeakTopLevelDecls")
    return ccall(pointer(addr), Cvoid, (CXSema, CXCodeGenerator), Sema, CodeGen)
end
