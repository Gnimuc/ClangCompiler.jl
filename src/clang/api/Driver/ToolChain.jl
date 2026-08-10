# ToolChain
"""
    getDriver(x::AbstractToolChain) -> Driver
Return the driver that owns this toolchain. The driver is borrowed, not a copy.
"""
function getDriver(x::AbstractToolChain)
    @check_ptrs x
    return Driver(clang_ToolChain_getDriver(x))
end

"""
    getTripleString(x::AbstractToolChain) -> String
Return the toolchain's target triple.
"""
function getTripleString(x::AbstractToolChain)
    @check_ptrs x
    return get_string(clang_ToolChain_getTripleString(x))
end

"""
    getArchName(x::AbstractToolChain) -> String
Return the architecture component of the toolchain's target triple.
"""
function getArchName(x::AbstractToolChain)
    @check_ptrs x
    return get_string(clang_ToolChain_getArchName(x))
end

"""
    getOS(x::AbstractToolChain) -> String
Return the OS name component of the toolchain's target triple, empty for a triple that
names no OS.
"""
function getOS(x::AbstractToolChain)
    @check_ptrs x
    return get_string(clang_ToolChain_getOS(x))
end

"""
    isCrossCompiling(x::AbstractToolChain) -> Bool
Return whether the toolchain targets an architecture other than the host `libclangex` was
built for.
"""
function isCrossCompiling(x::AbstractToolChain)
    @check_ptrs x
    return clang_ToolChain_isCrossCompiling(x)
end

"""
    getDefaultUniversalArchName(x::AbstractToolChain) -> String
Return the architecture name `-arch` expects for this toolchain.
"""
function getDefaultUniversalArchName(x::AbstractToolChain)
    @check_ptrs x
    return get_string(clang_ToolChain_getDefaultUniversalArchName(x))
end

# Where the toolchain would look for things. None of these needs an `ArgList`, which is what
# makes them reachable at all, and together they are how a caller finds the compiler-rt
# builtins or the C++ standard library the toolchain would have linked — the discovery step
# in front of handing an object or a dylib to the JIT.

"""
    getCompilerRTPath(x::AbstractToolChain) -> String
Return the directory the toolchain's compiler-rt libraries live in.
"""
function getCompilerRTPath(x::AbstractToolChain)
    @check_ptrs x
    return get_string(clang_ToolChain_getCompilerRTPath(x))
end

"""
    getRuntimePath(x::AbstractToolChain) -> String
Return the target-specific runtime directory, or the empty string when the toolchain
reports none.
"""
function getRuntimePath(x::AbstractToolChain)
    @check_ptrs x
    return get_string(clang_ToolChain_getRuntimePath(x))
end

"""
    getStdlibPath(x::AbstractToolChain) -> String
Return the target-specific standard library directory, or the empty string when the
toolchain reports none.
"""
function getStdlibPath(x::AbstractToolChain)
    @check_ptrs x
    return get_string(clang_ToolChain_getStdlibPath(x))
end

"""
    getArchSpecificLibPaths(x::AbstractToolChain) -> Vector{String}
Return the architecture-specific library directories runtimes such as OpenMP search.
"""
function getArchSpecificLibPaths(x::AbstractToolChain)
    @check_ptrs x
    return get_string(clang_ToolChain_getArchSpecificLibPaths(x))
end

"""
    getLibraryPaths(x::AbstractToolChain) -> Vector{String}
Return the `-L` paths the toolchain accumulated.
"""
function getLibraryPaths(x::AbstractToolChain)
    @check_ptrs x
    return get_string(clang_ToolChain_getLibraryPaths(x))
end

"""
    getFilePaths(x::AbstractToolChain) -> Vector{String}
Return the directories the toolchain searches for files — what
[`GetFilePath`](@ref) walks.
"""
function getFilePaths(x::AbstractToolChain)
    @check_ptrs x
    return get_string(clang_ToolChain_getFilePaths(x))
end

"""
    getProgramPaths(x::AbstractToolChain) -> Vector{String}
Return the directories the toolchain searches for programs — what
[`GetProgramPath`](@ref) walks.
"""
function getProgramPaths(x::AbstractToolChain)
    @check_ptrs x
    return get_string(clang_ToolChain_getProgramPaths(x))
end

"""
    GetLinkerPath(x::AbstractToolChain) -> Tuple{String,Bool}
Return the linker the toolchain would invoke, honouring `-fuse-ld=`, together with whether
that linker is LLD built at clang's own revision.
"""
function GetLinkerPath(x::AbstractToolChain)
    @check_ptrs x
    is_lld = Ref{Bool}(false)
    path = get_string(clang_ToolChain_GetLinkerPath(x, is_lld))
    return (path, is_lld[])
end

"""
    GetStaticLibToolPath(x::AbstractToolChain) -> String
Return the archiver the toolchain would invoke to build a static library.
"""
function GetStaticLibToolPath(x::AbstractToolChain)
    @check_ptrs x
    return get_string(clang_ToolChain_GetStaticLibToolPath(x))
end

"""
    computeSysRoot(x::AbstractToolChain) -> String
Return the sysroot the toolchain computes for itself, which is not always the driver's
`--sysroot`.
"""
function computeSysRoot(x::AbstractToolChain)
    @check_ptrs x
    return get_string(clang_ToolChain_computeSysRoot(x))
end

"""
    getOSLibName(x::AbstractToolChain) -> String
Return the `<osname>` component of the compiler-rt path, e.g. `"darwin"`.
"""
function getOSLibName(x::AbstractToolChain)
    @check_ptrs x
    return get_string(clang_ToolChain_getOSLibName(x))
end

"""
    getDefaultLinker(x::AbstractToolChain) -> String
Return the linker the toolchain uses when `-fuse-ld=` says nothing.
"""
function getDefaultLinker(x::AbstractToolChain)
    @check_ptrs x
    return unsafe_string(clang_ToolChain_getDefaultLinker(x))
end

"""
    isPICDefault(x::AbstractToolChain) -> Bool
Return whether the toolchain generates position-independent code by default.
"""
function isPICDefault(x::AbstractToolChain)
    @check_ptrs x
    return clang_ToolChain_isPICDefault(x)
end

"""
    isPICDefaultForced(x::AbstractToolChain) -> Bool
Return whether the PIC default cannot be turned off on this toolchain.
"""
function isPICDefaultForced(x::AbstractToolChain)
    @check_ptrs x
    return clang_ToolChain_isPICDefaultForced(x)
end

"""
    GetDefaultCXXStdlibType(x::AbstractToolChain) -> CXCXXStdlibType
Return the C++ standard library the toolchain links against by default.
"""
function GetDefaultCXXStdlibType(x::AbstractToolChain)
    @check_ptrs x
    return clang_ToolChain_GetDefaultCXXStdlibType(x)
end

"""
    GetDefaultRuntimeLibType(x::AbstractToolChain) -> CXRuntimeLibType
Return the compiler runtime the toolchain links against by default.
"""
function GetDefaultRuntimeLibType(x::AbstractToolChain)
    @check_ptrs x
    return clang_ToolChain_GetDefaultRuntimeLibType(x)
end

"""
    LookupTypeForExtension(x::AbstractToolChain, ext::AbstractString) -> Int
Return the driver type ID this toolchain assigns to files with extension `ext` (given
without its dot), or 0 (`TY_INVALID`) for an extension it does not recognise. The ID is
what [`getTypeName`](@ref) and the `types` predicates read.
"""
function LookupTypeForExtension(x::AbstractToolChain, ext::AbstractString)
    @check_ptrs x
    return Int(clang_ToolChain_LookupTypeForExtension(x, ext))
end
