function print_julia_version()
    jit = get_jit(BOOT_COMPILER_REF[])
    addr = lookup(jit, "print_julia_version")
    return ccall(pointer(addr), Cvoid, ())
end
