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
