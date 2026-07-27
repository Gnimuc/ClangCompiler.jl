# Driver
"""
    GetResourcesPath(binary_path::AbstractString) -> String
Compute the path to the Clang resource directory for the given compiler binary path. The
underlying two-call protocol copies exactly N bytes with no NUL terminator.
"""
function GetResourcesPath(binary_path::AbstractString)
    n = clang_Driver_GetResourcesPathLength(binary_path)
    path = Vector{Cuchar}(undef, n)
    n > 0 && clang_Driver_GetResourcesPath(binary_path, path, n)
    return String(path)
end


"""
    Driver(clang_executable::AbstractString, target_triple::AbstractString, diags::AbstractDiagnosticsEngine) -> Driver
Create a `clang::driver::Driver` for the given compiler executable path and target triple.

This function allocates and one should call `dispose` to release the resources after using
this object. The driver holds a reference to `diags`, so dispose the driver before the
`DiagnosticsEngine` it was created with.
"""
function Driver(clang_executable::AbstractString, target_triple::AbstractString,
                diags::AbstractDiagnosticsEngine)
    @check_ptrs diags
    ptr = clang_Driver_create(clang_executable, target_triple, diags)
    @assert ptr != C_NULL "Failed to create Driver"
    return Driver(ptr)
end

dispose(x::Driver) = clang_Driver_dispose(x)

function getCheckInputsExist(x::AbstractDriver)
    @check_ptrs x
    return clang_Driver_getCheckInputsExist(x)
end

function setCheckInputsExist(x::AbstractDriver, value::Bool)
    @check_ptrs x
    return clang_Driver_setCheckInputsExist(x, value)
end

function getTargetTriple(x::AbstractDriver)
    @check_ptrs x
    return get_string(clang_Driver_getTargetTriple(x))
end

function getClangProgramPath(x::AbstractDriver)
    @check_ptrs x
    return unsafe_string(clang_Driver_getClangProgramPath(x))
end

function getInstalledDir(x::AbstractDriver)
    @check_ptrs x
    return unsafe_string(clang_Driver_getInstalledDir(x))
end

"""
    getDir(x::AbstractDriver) -> String
Return the path the driver executable was in, as invoked from the command line.
"""
function getDir(x::AbstractDriver)
    @check_ptrs x
    return unsafe_string(clang_Driver_getDir(x))
end

"""
    getResourceDir(x::AbstractDriver) -> String
Return the path to the compiler resource directory.
"""
function getResourceDir(x::AbstractDriver)
    @check_ptrs x
    return unsafe_string(clang_Driver_getResourceDir(x))
end

"""
    getSysRoot(x::AbstractDriver) -> String
Return the sysroot, or an empty string if none is present.
"""
function getSysRoot(x::AbstractDriver)
    @check_ptrs x
    return unsafe_string(clang_Driver_getSysRoot(x))
end

"""
    getDyldPrefix(x::AbstractDriver) -> String
Return the dynamic loader prefix, or an empty string if none is present.
"""
function getDyldPrefix(x::AbstractDriver)
    @check_ptrs x
    return unsafe_string(clang_Driver_getDyldPrefix(x))
end


"""
    CCCIsCXX(x::AbstractDriver) -> Bool
Return whether the driver is running in g++ mode.
"""
function CCCIsCXX(x::AbstractDriver)
    @check_ptrs x
    return clang_Driver_CCCIsCXX(x)
end

"""
    CCCIsCPP(x::AbstractDriver) -> Bool
Return whether the driver is running in cpp mode.
"""
function CCCIsCPP(x::AbstractDriver)
    @check_ptrs x
    return clang_Driver_CCCIsCPP(x)
end

"""
    CCCIsCC(x::AbstractDriver) -> Bool
Return whether the driver is running in gcc mode.
"""
function CCCIsCC(x::AbstractDriver)
    @check_ptrs x
    return clang_Driver_CCCIsCC(x)
end

"""
    IsCLMode(x::AbstractDriver) -> Bool
Return whether the driver is running in clang-cl mode.
"""
function IsCLMode(x::AbstractDriver)
    @check_ptrs x
    return clang_Driver_IsCLMode(x)
end

"""
    IsFlangMode(x::AbstractDriver) -> Bool
Return whether the driver is running in flang mode.
"""
function IsFlangMode(x::AbstractDriver)
    @check_ptrs x
    return clang_Driver_IsFlangMode(x)
end

"""
    IsDXCMode(x::AbstractDriver) -> Bool
Return whether the driver is running in dxc mode.
"""
function IsDXCMode(x::AbstractDriver)
    @check_ptrs x
    return clang_Driver_IsDXCMode(x)
end

"""
    getCCCGenericGCCName(x::AbstractDriver) -> String
Return the name to use when invoking gcc/g++.
"""
function getCCCGenericGCCName(x::AbstractDriver)
    @check_ptrs x
    return get_string(clang_Driver_getCCCGenericGCCName(x))
end

function getDiags(x::AbstractDriver)
    @check_ptrs x
    return DiagnosticsEngine(clang_Driver_getDiags(x))
end

"""
    getTitle(x::AbstractDriver) -> String
Return the driver title used in diagnostics and `--version` output.
"""
function getTitle(x::AbstractDriver)
    @check_ptrs x
    return get_string(clang_Driver_getTitle(x))
end

"""
    setTitle(x::AbstractDriver, value::AbstractString)
Set the driver title used in diagnostics and `--version` output.
"""
function setTitle(x::AbstractDriver, value::AbstractString)
    @check_ptrs x
    return clang_Driver_setTitle(x, value)
end

"""
    getDefaultImageName(x::AbstractDriver) -> String
Return the default name for linked images (e.g. `"a.out"`), derived from the driver's
target triple.
"""
function getDefaultImageName(x::AbstractDriver)
    @check_ptrs x
    return unsafe_string(clang_Driver_getDefaultImageName(x))
end

"""
    getLTOMode(x::AbstractDriver, is_offload::Bool=false) -> CXLTOKind
Return the specific kind of LTO being performed. Pass `is_offload=true` for the offload
LTO mode instead of the host one.

!!! warning
    The driver must already have processed arguments. `Driver::LTOMode` and
    `Driver::OffloadLTOMode` carry no default initializer and are written only by
    `setLTOMode` during `BuildCompilation`, so calling this on a freshly constructed
    `Driver` reads uninitialized memory — it has been seen returning a value outside
    `CXLTOKind` altogether. This wrapper cannot check the precondition: there is no
    observable "arguments processed" flag on the driver.
"""
function getLTOMode(x::AbstractDriver, is_offload::Bool=false)
    @check_ptrs x
    return clang_Driver_getLTOMode(x, is_offload)
end
