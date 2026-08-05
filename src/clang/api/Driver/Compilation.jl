# Compilation
"""
    dispose(x::Compilation)
Destroy a `clang::driver::Compilation`.

The destructor reads the `Driver` that built the compilation and removes the temporary
files the compilation registered, so dispose the compilation before that driver.
"""
dispose(x::Compilation) = clang_Compilation_dispose(x)

"""
    getDriver(x::AbstractCompilation) -> Driver
Return the driver that built this compilation. The driver is borrowed, not a copy: it is
still owned -- and disposed -- by whoever created it.
"""
function getDriver(x::AbstractCompilation)
    @check_ptrs x
    return Driver(clang_Compilation_getDriver(x))
end

"""
    getDefaultToolChain(x::AbstractCompilation) -> ToolChain
Return the toolchain the compilation was built for. Toolchains are created and cached by
their driver, so the result is borrowed and lives exactly as long as that driver.
"""
function getDefaultToolChain(x::AbstractCompilation)
    @check_ptrs x
    return ToolChain(clang_Compilation_getDefaultToolChain(x))
end

"""
    getActiveOffloadKinds(x::AbstractCompilation) -> UInt32
Return the bit mask of offloading programming models the host has to support in this
compilation. Zero for an ordinary host-only compilation.
"""
function getActiveOffloadKinds(x::AbstractCompilation)
    @check_ptrs x
    return clang_Compilation_getActiveOffloadKinds(x)
end

"""
    getSysRoot(x::AbstractCompilation) -> String
Return the sysroot in effect for this compilation.
"""
function getSysRoot(x::AbstractCompilation)
    @check_ptrs x
    return get_string(clang_Compilation_getSysRoot(x))
end

"""
    getTempFiles(x::AbstractCompilation) -> Vector{String}
Return the temporary files registered with this compilation. Disposing the compilation
deletes those files from disk unless `-save-temps` is in effect.
"""
function getTempFiles(x::AbstractCompilation)
    @check_ptrs x
    n = Int(clang_Compilation_getNumTempFiles(x))
    return String[unsafe_string(clang_Compilation_getTempFile(x, i)) for i = 0:(n - 1)]
end

"""
    isForDiagnostics(x::AbstractCompilation) -> Bool
Return whether the compilation is a re-run set up to collect crash diagnostics.
"""
function isForDiagnostics(x::AbstractCompilation)
    @check_ptrs x
    return clang_Compilation_isForDiagnostics(x)
end

"""
    containsError(x::AbstractCompilation) -> Bool
Return whether an error occurred while parsing the input arguments.
"""
function containsError(x::AbstractCompilation)
    @check_ptrs x
    return clang_Compilation_containsError(x)
end

"""
    setContainsError(x::AbstractCompilation)
Force the compilation to fail before a toolchain is created. The bit can only be set; the
C++ API offers no way to clear it again.
"""
function setContainsError(x::AbstractCompilation)
    @check_ptrs x
    clang_Compilation_setContainsError(x)
    return nothing
end
