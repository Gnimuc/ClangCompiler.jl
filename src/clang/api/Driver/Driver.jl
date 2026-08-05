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
    With `is_offload=true` the driver must already have processed arguments.
    `Driver::OffloadLTOMode` is the one member of its group that the driver's only
    constructor does not initialize, so `setLTOMode` during [`BuildCompilation`](@ref) is
    the first thing to write it and reading it before that is uninitialized memory — it
    has been seen returning a value outside `CXLTOKind` altogether. This wrapper cannot
    check the precondition: there is no observable "arguments processed" flag on the
    driver.

The host mode is not affected: `Driver::LTOMode` is set to `LTOK_None` by that constructor,
so `is_offload=false` reads an initialized member on any driver.
"""
function getLTOMode(x::AbstractDriver, is_offload::Bool=false)
    @check_ptrs x
    return clang_Driver_getLTOMode(x, is_offload)
end

"""
    getConfigFiles(x::AbstractDriver) -> Vector{String}
Return the paths of the configuration files the driver loaded. Empty until the driver has
processed a command line.
"""
function getConfigFiles(x::AbstractDriver)
    @check_ptrs x
    n = Int(clang_Driver_getNumConfigFiles(x))
    return String[unsafe_string(clang_Driver_getConfigFile(x, i)) for i = 0:(n - 1)]
end

"""
    getProbePrecompiled(x::AbstractDriver) -> Bool
Return whether the driver probes for PCH files on disk, in order to upgrade
`-include foo.h` to `-include-pch foo.h.pch`.
"""
function getProbePrecompiled(x::AbstractDriver)
    @check_ptrs x
    return clang_Driver_getProbePrecompiled(x)
end

"""
    setProbePrecompiled(x::AbstractDriver, value::Bool)
Set whether the driver probes for PCH files on disk.
"""
function setProbePrecompiled(x::AbstractDriver, value::Bool)
    @check_ptrs x
    return clang_Driver_setProbePrecompiled(x, value)
end

"""
    getPrependArg(x::AbstractDriver) -> String
Return the argument the driver prepends when reinvoking clang, or `""` when none is set.
"""
function getPrependArg(x::AbstractDriver)
    @check_ptrs x
    ptr = clang_Driver_getPrependArg(x)
    return ptr == C_NULL ? "" : unsafe_string(ptr)
end

"""
    setPrependArg(x::AbstractDriver, value::AbstractString)
Set the argument the driver prepends when reinvoking clang.

!!! warning
    `Driver::PrependArg` is a bare `const char *`: the driver stores the pointer and
    never copies the bytes, exactly like `SetCompilerArgs`. `value` must stay rooted for
    as long as the driver may use it.
"""
function setPrependArg(x::AbstractDriver, value::AbstractString)
    @check_ptrs x
    return clang_Driver_setPrependArg(x, value)
end

"""
    setInstalledDir(x::AbstractDriver, value::AbstractString)
Set the path the clang executable was installed in. A non-empty value overrides
`getInstalledDir`'s fallback to `getDir`.
"""
function setInstalledDir(x::AbstractDriver, value::AbstractString)
    @check_ptrs x
    return clang_Driver_setInstalledDir(x, value)
end

"""
    isSaveTempsEnabled(x::AbstractDriver) -> Bool
Return whether the driver was asked to keep temporary compilation artefacts
(`-save-temps`).

`Driver::SaveTemps` is set to `SaveTempsNone` by the driver's only constructor and refined
while a command line is processed, so a driver that has not run [`BuildCompilation`](@ref)
answers `false` rather than reading uninitialized memory.
"""
function isSaveTempsEnabled(x::AbstractDriver)
    @check_ptrs x
    return clang_Driver_isSaveTempsEnabled(x)
end

"""
    isSaveTempsObj(x::AbstractDriver) -> Bool
Return whether temporaries are kept next to the object file (`-save-temps=obj`). Carries
the same `Driver::SaveTemps` caveat as [`isSaveTempsEnabled`](@ref).
"""
function isSaveTempsObj(x::AbstractDriver)
    @check_ptrs x
    return clang_Driver_isSaveTempsObj(x)
end

"""
    embedBitcodeEnabled(x::AbstractDriver) -> Bool
Return whether the driver embeds bitcode in the output at all (`-fembed-bitcode`).

`Driver::BitcodeEmbed` is set to `EmbedNone` by the driver's only constructor and refined
while a command line is processed, so a driver that has not run [`BuildCompilation`](@ref)
answers `false` rather than reading uninitialized memory.
"""
function embedBitcodeEnabled(x::AbstractDriver)
    @check_ptrs x
    return clang_Driver_embedBitcodeEnabled(x)
end

"""
    embedBitcodeInObject(x::AbstractDriver) -> Bool
Return whether whole bitcode is embedded in the object file. Carries the same
`Driver::BitcodeEmbed` caveat as [`embedBitcodeEnabled`](@ref).
"""
function embedBitcodeInObject(x::AbstractDriver)
    @check_ptrs x
    return clang_Driver_embedBitcodeInObject(x)
end

"""
    embedBitcodeMarkerOnly(x::AbstractDriver) -> Bool
Return whether only a bitcode marker is embedded (`-fembed-bitcode=marker`). Carries the
same `Driver::BitcodeEmbed` caveat as [`embedBitcodeEnabled`](@ref).
"""
function embedBitcodeMarkerOnly(x::AbstractDriver)
    @check_ptrs x
    return clang_Driver_embedBitcodeMarkerOnly(x)
end

"""
    offloadHostOnly(x::AbstractDriver) -> Bool
Return whether the driver builds only the host side of an offloading compilation.

`Driver::Offload` is set to `OffloadHostDevice` by the driver's only constructor and refined
while a command line is processed, so a driver that has not run [`BuildCompilation`](@ref)
answers `false` rather than reading uninitialized memory.
"""
function offloadHostOnly(x::AbstractDriver)
    @check_ptrs x
    return clang_Driver_offloadHostOnly(x)
end

"""
    offloadDeviceOnly(x::AbstractDriver) -> Bool
Return whether the driver builds only the device side of an offloading compilation.
Carries the same `Driver::Offload` caveat as [`offloadHostOnly`](@ref).
"""
function offloadDeviceOnly(x::AbstractDriver)
    @check_ptrs x
    return clang_Driver_offloadDeviceOnly(x)
end

"""
    hasHeaderMode(x::AbstractDriver) -> Bool
Return whether `-fmodule-header` selected a C++20 header-unit mode, i.e. whether
[`getModuleHeaderMode`](@ref) is anything but `CXModuleHeaderMode_HeaderMode_None`.

`Driver::CXX20HeaderType` is set to `HeaderMode_None` by the driver's only constructor and
refined while a command line is processed, so a driver that has not run
[`BuildCompilation`](@ref) answers `false` rather than reading uninitialized memory.
"""
function hasHeaderMode(x::AbstractDriver)
    @check_ptrs x
    return clang_Driver_hasHeaderMode(x)
end

"""
    getModuleHeaderMode(x::AbstractDriver) -> CXModuleHeaderMode
Return how the headers a C++20 header unit is built from are looked up: by the path given
on the command line (`-fmodule-header`), or in the user (`-fmodule-header=user`) or system
(`-fmodule-header=system`) search paths.

Finer-grained than [`hasHeaderMode`](@ref), which collapses the three selected modes into
one answer. It reads the same `Driver::CXX20HeaderType` and carries the same constructor
default, so it is defined on any driver.
"""
function getModuleHeaderMode(x::AbstractDriver)
    @check_ptrs x
    return clang_Driver_getModuleHeaderMode(x)
end

"""
    isUsingLTO(x::AbstractDriver, is_offload::Bool=false) -> Bool
Return whether the driver performs any kind of LTO. `is_offload` asks about the offload
LTO mode instead of the host one.

!!! note
    This reads the same `Driver::LTOMode` / `OffloadLTOMode` members as
    [`getLTOMode`](@ref), but it compares them instead of handing the raw enum out, so the
    result is a valid `Bool` even on the `is_offload=true` arm, whose member stays
    uninitialized until [`BuildCompilation`](@ref) runs. That arm is still only meaningful
    afterwards, and — as for `getLTOMode` — there is no observable \"arguments processed\"
    flag to assert on.
"""
function isUsingLTO(x::AbstractDriver, is_offload::Bool=false)
    @check_ptrs x
    return clang_Driver_isUsingLTO(x, is_offload)
end

"""
    GetTemporaryPath(x::AbstractDriver, prefix::AbstractString, suffix::AbstractString) -> String
Return the path of a temporary file carrying the given prefix and suffix, or `""` when
one could not be created (the failure is reported through the driver's
`DiagnosticsEngine`).

!!! warning
    The file is created on disk before this returns and nothing in the driver ever
    removes it; the caller owns it.
"""
function GetTemporaryPath(x::AbstractDriver, prefix::AbstractString, suffix::AbstractString)
    @check_ptrs x
    return get_string(clang_Driver_GetTemporaryPath(x, prefix, suffix))
end

"""
    GetTemporaryDirectory(x::AbstractDriver, prefix::AbstractString) -> String
Return the path of a temporary directory carrying the given prefix, or `""` when one
could not be created.

!!! warning
    The directory is created on disk before this returns and nothing in the driver ever
    removes it; the caller owns it.
"""
function GetTemporaryDirectory(x::AbstractDriver, prefix::AbstractString)
    @check_ptrs x
    return get_string(clang_Driver_GetTemporaryDirectory(x, prefix))
end

"""
    GetReleaseVersion(str::AbstractString) -> Union{Tuple{Cuint,Cuint,Cuint,Bool},Nothing}
Parse `"major[.minor[.micro]][extra]"` and return `(major, minor, micro, had_extra)`, or
`nothing` when the string could not be parsed. Groups the string does not provide come
back as `0`; `had_extra` reports whether characters remained after the last group.
"""
function GetReleaseVersion(str::AbstractString)
    major = Ref{Cuint}(0)
    minor = Ref{Cuint}(0)
    micro = Ref{Cuint}(0)
    had_extra = Ref{Bool}(false)
    parsed = clang_Driver_GetReleaseVersion(str, major, minor, micro, had_extra)
    return parsed ? (major[], minor[], micro[], had_extra[]) : nothing
end

"""
    GetReleaseVersionDigits(str::AbstractString, n::Integer) -> Union{Vector{Cuint},Nothing}
Parse up to `n` dot-separated digit groups out of `str`, or return `nothing` when the
whole string could not be consumed. This is the `MutableArrayRef` overload of
`Driver::GetReleaseVersion`, and it is stricter than [`GetReleaseVersion`](@ref), which
accepts trailing characters.
"""
function GetReleaseVersionDigits(str::AbstractString, n::Integer)
    @assert n > 0 "the number of digit groups to parse must be positive"
    groups = zeros(Cuint, n)
    return clang_Driver_GetReleaseVersionDigits(str, groups, n) ? groups : nothing
end

"""
    getDefaultModuleCachePath() -> String
Return the default `-fmodule-cache-path`, or `""` when the system provides no cache
directory at all.
"""
function getDefaultModuleCachePath()
    return get_string(clang_Driver_getDefaultModuleCachePath())
end

"""
    BuildCompilation(x::AbstractDriver, args::Vector{String}) -> Compilation
Construct a `clang::driver::Compilation` for the command line `args`.

`args` is a full argv: `args[1]` is the program name the driver inspects to choose its
mode, so it must not be empty. Building a compilation runs argument parsing, toolchain
selection, action building and job building, which is what assigns the `Driver` members
that have no in-class initializer -- [`getLTOMode`](@ref), [`isUsingLTO`](@ref),
[`isSaveTempsEnabled`](@ref), [`hasHeaderMode`](@ref) and [`getConfigFiles`](@ref) only
become meaningful on a driver a compilation has been built with.

This function allocates and one should call `dispose` to release the resources after using
this object. The compilation's destructor reads the driver, so dispose the compilation
before the driver.
"""
function BuildCompilation(x::AbstractDriver, args::Vector{String})
    @check_ptrs x
    @assert !isempty(args) "args must be a full argv: args[1] is the program name"
    ptr = clang_Driver_BuildCompilation(x, args, length(args))
    @assert ptr != C_NULL "Failed to build Compilation"
    return Compilation(ptr)
end

"""
    PrintVersion(x::AbstractDriver, c::AbstractCompilation) -> String
Return the driver's version banner for `c` as a string instead of writing it to a stream.
"""
function PrintVersion(x::AbstractDriver, c::AbstractCompilation)
    @check_ptrs x c
    return get_string(clang_Driver_PrintVersion(x, c))
end

"""
    GetFilePath(x::AbstractDriver, name::AbstractString, tc::AbstractToolChain) -> String
Look `name` up in the file search paths of `tc` and return the resulting path.
"""
function GetFilePath(x::AbstractDriver, name::AbstractString, tc::AbstractToolChain)
    @check_ptrs x tc
    return get_string(clang_Driver_GetFilePath(x, name, tc))
end

"""
    GetProgramPath(x::AbstractDriver, name::AbstractString, tc::AbstractToolChain) -> String
Look `name` up in the program search paths of `tc` and return the resulting path.
"""
function GetProgramPath(x::AbstractDriver, name::AbstractString, tc::AbstractToolChain)
    @check_ptrs x tc
    return get_string(clang_Driver_GetProgramPath(x, name, tc))
end

"""
    getName(x::AbstractDriver) -> String
Return the name the driver was invoked as -- the stem of `argv[0]`.
"""
function getName(x::AbstractDriver)
    @check_ptrs x
    return get_string(clang_Driver_getName(x))
end

"""
    getSystemConfigDir(x::AbstractDriver) -> String
Return the system-wide configuration directory the driver searches.
"""
function getSystemConfigDir(x::AbstractDriver)
    @check_ptrs x
    return get_string(clang_Driver_getSystemConfigDir(x))
end

"""
    getUserConfigDir(x::AbstractDriver) -> String
Return the per-user configuration directory the driver searches.
"""
function getUserConfigDir(x::AbstractDriver)
    @check_ptrs x
    return get_string(clang_Driver_getUserConfigDir(x))
end

"""
    getNumPrefixDirs(x::AbstractDriver) -> Int
Return how many prefix directories the driver searches ahead of the toolchain's own.

These come from every `-B` on the command line *and* from the `COMPILER_PATH` environment
variable, so the count is host-dependent.
"""
function getNumPrefixDirs(x::AbstractDriver)::Int
    @check_ptrs x
    return clang_Driver_getNumPrefixDirs(x)
end

"""
    getPrefixDir(x::AbstractDriver, i::Integer) -> String
Return the `i`-th prefix directory. `i` is 0-based and must be less than
[`getNumPrefixDirs`](@ref); the underlying container is indexed without a bounds check.
"""
function getPrefixDir(x::AbstractDriver, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumPrefixDirs(x) "prefix-directory index out of range"
    return get_string(clang_Driver_getPrefixDir(x, i))
end

"""
    getPrefixDirs(x::AbstractDriver) -> Vector{String}
Return every prefix directory the driver searches ahead of the toolchain's own.
"""
function getPrefixDirs(x::AbstractDriver)
    @check_ptrs x
    return String[getPrefixDir(x, i) for i = 0:(getNumPrefixDirs(x) - 1)]
end

"""
    CreateTempFile(x::AbstractDriver, c::Compilation, prefix::AbstractString,
                   suffix::AbstractString; multiple_archs::Bool=false,
                   bound_arch::AbstractString="",
                   need_unique_directory::Bool=false) -> Union{String,Nothing}
Create a temporary file on disk and return its path, or `nothing` when it could not be created
— a failure the driver also reports through its diagnostics engine.

The file really appears on disk and the path is registered with `c`, so it shows up in
[`getTempFile`](@ref) and is removed when the compilation cleans up. Dispose `c` before the
driver.
"""
function CreateTempFile(x::AbstractDriver, c::Compilation, prefix::AbstractString,
                        suffix::AbstractString; multiple_archs::Bool=false,
                        bound_arch::AbstractString="", need_unique_directory::Bool=false)
    @check_ptrs x c
    p = clang_Driver_CreateTempFile(x, c, prefix, suffix, multiple_archs, bound_arch,
                                    need_unique_directory)
    return p == C_NULL ? nothing : unsafe_string(p)
end

"""
    GetClPchPath(x::AbstractDriver, c::Compilation, base_name::AbstractString) -> String
Return the path clang-cl would use for the precompiled header of `base_name`.
"""
function GetClPchPath(x::AbstractDriver, c::Compilation, base_name::AbstractString)
    @check_ptrs x c
    return get_string(clang_Driver_GetClPchPath(x, c, base_name))
end

"""
    getDriverMode(prog_name::AbstractString, args::Vector{String}=String[]) -> String
Return the value of `--driver-mode=` in `args` — the `X` in `--driver-mode=X`, with the last
occurrence winning — or, when `args` names none, the mode `prog_name` implies. `""` when
neither yields one. Common values are `"gcc"`, `"g++"`, `"cpp"`, `"cl"` and `"flang"`, but
the result need not be one of those.

`args` is the argument list *without* the program name: clang's own driver passes everything
after `argv[0]`.

This is the free function `clang::driver::getDriverMode`, not a `Driver` method, so it takes
no receiver — which is the point of it. [`CCCIsCXX`](@ref), [`IsCLMode`](@ref) and the other
mode predicates read `Driver::Mode`, which stays `GCCMode` until [`BuildCompilation`](@ref)
has processed `--driver-mode`, and that needs a real toolchain and real inputs; this answers
the same question before any `Driver` exists.
"""
function getDriverMode(prog_name::AbstractString, args::Vector{String}=String[])
    return get_string(clang_driver_getDriverMode(prog_name, args, length(args)))
end
