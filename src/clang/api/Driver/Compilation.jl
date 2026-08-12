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

"""
    getJobs(x::AbstractCompilation) -> JobList
Return the commands the driver planned for this compilation — one per subprocess, the
`-###` view. The list is a member of the compilation, so it is borrowed and dies with it.
"""
function getJobs(x::AbstractCompilation)
    @check_ptrs x
    return JobList(clang_Compilation_getJobs(x))
end

"""
    ExecuteJobs(x::AbstractCompilation, jobs::AbstractJobList;
                log_only::Bool=false) -> Vector{Tuple{Int,Command}}
Run `jobs` and return the failures as `(result_code, command)` pairs, empty when every
command succeeded.

Failures can only come from commands in `jobs`, so the report is complete. With
`log_only` set nothing is executed and the commands are only logged.
"""
function ExecuteJobs(x::AbstractCompilation, jobs::AbstractJobList; log_only::Bool=false)
    @check_ptrs x jobs
    n = size(jobs)
    num = Ref{Cuint}(0)
    results = Vector{Cint}(undef, n)
    commands = Vector{CXCommand}(undef, n)
    clang_Compilation_ExecuteJobs(x, jobs, log_only, num, results, commands, n)
    k = min(Int(num[]), n)
    return Tuple{Int,Command}[(Int(results[i]), Command(commands[i])) for i = 1:k]
end

"""
    Redirect(x::AbstractCompilation; in_path=nothing, out_path=nothing, err_path=nothing)
Send the child processes' standard input, output and error to the named files; a `nothing`
leaves that stream alone.

clang stores the paths as non-owning references, so the shim first copies them into the
compilation's own argument allocator — they then live exactly as long as the compilation.
Per clang's own contract this can only be done once.
"""
function Redirect(x::AbstractCompilation; in_path::Union{AbstractString,Nothing}=nothing, out_path::Union{AbstractString,Nothing}=nothing, err_path::Union{AbstractString,Nothing}=nothing)
    @check_ptrs x
    i = in_path === nothing ? C_NULL : in_path
    o = out_path === nothing ? C_NULL : out_path
    e = err_path === nothing ? C_NULL : err_path
    clang_Compilation_Redirect(x, i, o, e)
    return nothing
end
