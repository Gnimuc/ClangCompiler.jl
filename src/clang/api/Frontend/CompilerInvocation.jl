# CompilerInvocation
CompilerInvocation() = CompilerInvocation(create_compiler_invocation())

"""
    create_compiler_invocation() -> CXCompilerInvocation
Return a pointer to a `clang::CompilerInvocation` object.
"""
function create_compiler_invocation()
    invocation = clang_CompilerInvocation_create()
    @assert invocation != C_NULL "Failed to create CompilerInvocation"
    return invocation
end

"""
    createFromCommandLine(src::String, args::Vector{String}=String[], diag::DiagnosticsEngine=DiagnosticsEngine()) -> CompilerInvocation
Return a `CompilerInvocation` created from command line arguments (the source
file goes last). Parse problems are reported through `diag`. This function
allocates and one should call `dispose` to release the resources after using
this object.
"""
function createFromCommandLine(src::String, args::Vector{String}=String[],
                               diag::DiagnosticsEngine=DiagnosticsEngine())
    @check_ptrs diag
    args_with_src = copy(args)
    push!(args_with_src, src)
    invocation = clang_CompilerInvocation_createFromCommandLine(args_with_src,
                                                                length(args_with_src), diag)
    @assert invocation != C_NULL "Failed to create CompilerInvocation"
    return CompilerInvocation(invocation)
end

# Options
function getCodeGenOpts(ci::CompilerInvocation)
    @check_ptrs ci
    return CodeGenOptions(clang_CompilerInvocation_getCodeGenOpts(ci))
end

function getDiagnosticOpts(ci::CompilerInvocation)
    @check_ptrs ci
    return DiagnosticOptions(clang_CompilerInvocation_getDiagnosticOpts(ci))
end

function getFrontendOpts(ci::CompilerInvocation)
    @check_ptrs ci
    return FrontendOptions(clang_CompilerInvocation_getFrontendOpts(ci))
end

function getHeaderSearchOpts(ci::CompilerInvocation)
    @check_ptrs ci
    return HeaderSearchOptions(clang_CompilerInvocation_getHeaderSearchOpts(ci))
end

function getPreprocessorOpts(ci::CompilerInvocation)
    @check_ptrs ci
    return PreprocessorOptions(clang_CompilerInvocation_getPreprocessorOpts(ci))
end

function getTargetOpts(ci::CompilerInvocation)
    @check_ptrs ci
    return TargetOptions(clang_CompilerInvocation_getTargetOpts(ci))
end

dispose(x::CompilerInvocation) = clang_CompilerInvocation_dispose(x)


"""
    getLangOpts(ci::CompilerInvocation) -> LangOptions
Return the `clang::LangOptions` owned by this invocation. The returned object is
a borrowed view: do not dispose it.
"""
function getLangOpts(ci::CompilerInvocation)
    @check_ptrs ci
    return LangOptions(clang_CompilerInvocation_getLangOpts(ci))
end

"""
    getAnalyzerOpts(ci::CompilerInvocation) -> AnalyzerOptions
Return the `clang::AnalyzerOptions` owned by this invocation (borrowed view).
"""
function getAnalyzerOpts(ci::CompilerInvocation)
    @check_ptrs ci
    return AnalyzerOptions(clang_CompilerInvocation_getAnalyzerOpts(ci))
end

"""
    getMigratorOpts(ci::CompilerInvocation) -> MigratorOptions
Return the `clang::MigratorOptions` owned by this invocation (borrowed view).
"""
function getMigratorOpts(ci::CompilerInvocation)
    @check_ptrs ci
    return MigratorOptions(clang_CompilerInvocation_getMigratorOpts(ci))
end

"""
    getFileSystemOpts(ci::CompilerInvocation) -> FileSystemOptions
Return the `clang::FileSystemOptions` owned by this invocation (borrowed view).
"""
function getFileSystemOpts(ci::CompilerInvocation)
    @check_ptrs ci
    return FileSystemOptions(clang_CompilerInvocation_getFileSystemOpts(ci))
end

"""
    getDependencyOutputOpts(ci::CompilerInvocation) -> DependencyOutputOptions
Return the `clang::DependencyOutputOptions` owned by this invocation (borrowed view).
"""
function getDependencyOutputOpts(ci::CompilerInvocation)
    @check_ptrs ci
    return DependencyOutputOptions(clang_CompilerInvocation_getDependencyOutputOpts(ci))
end

"""
    getPreprocessorOutputOpts(ci::CompilerInvocation) -> PreprocessorOutputOptions
Return the `clang::PreprocessorOutputOptions` owned by this invocation (borrowed view).
"""
function getPreprocessorOutputOpts(ci::CompilerInvocation)
    @check_ptrs ci
    return PreprocessorOutputOptions(clang_CompilerInvocation_getPreprocessorOutputOpts(ci))
end

"""
    getModuleHash(ci::CompilerInvocation) -> String
Return a hash string that uniquely identifies the conditions under which a module
built with this invocation would be built.
"""
function getModuleHash(ci::CompilerInvocation)
    @check_ptrs ci
    return get_string(clang_CompilerInvocation_getModuleHash(ci))
end


"""
    resetNonModularOptions(ci::CompilerInvocation)
Reset every option that is not considered when building a module, so that invocations
differing only in non-modular options agree on `getModuleHash`. The invocation stays
usable.
"""
function resetNonModularOptions(ci::CompilerInvocation)
    @check_ptrs ci
    return clang_CompilerInvocation_resetNonModularOptions(ci)
end

"""
    clearImplicitModuleBuildOptions(ci::CompilerInvocation)
Disable implicit modules and canonicalize the options only implicit module builds use.
The invocation stays usable.
"""
function clearImplicitModuleBuildOptions(ci::CompilerInvocation)
    @check_ptrs ci
    return clang_CompilerInvocation_clearImplicitModuleBuildOptions(ci)
end


"""
    getAPINotesOpts(ci::CompilerInvocation) -> APINotesOptions
Return the `clang::APINotesOptions` owned by this invocation (borrowed interior view —
it dies with the invocation, never `dispose` it).
"""
function getAPINotesOpts(ci::CompilerInvocation)
    @check_ptrs ci
    return APINotesOptions(clang_CompilerInvocation_getAPINotesOpts(ci))
end

"""
    getCC1CommandLine(ci::CompilerInvocation) -> Vector{String}
Return the `-cc1` command line that reproduces this invocation. The line is regenerated
on every call and copied into Julia strings, so the result outlives the invocation.

The invocation must have selected a language standard — generation reaches
`getLangStandardForKind`, which `report_fatal_error`s on `lang_unspecified`, the state a
default-constructed invocation is in. Fill it from an argument list first
([`CreateFromArgs`](@ref) or `createFromCommandLine`).
"""
function getCC1CommandLine(ci::CompilerInvocation)
    @check_ptrs ci
    @assert hasLangStandard(getLangOpts(ci)) "the invocation has selected no language standard"
    return get_string(clang_CompilerInvocation_getCC1CommandLine(ci))
end

"""
    CreateFromArgs(ci::CompilerInvocation, args::Vector{String}, diag::DiagnosticsEngine,
                   argv0::Union{Nothing,AbstractString}=nothing) -> Bool
Fill `ci` from the `-cc1` argument list `args`, which must not contain `-cc1` itself, and
report problems through the borrowed `diag`. Returns `false` when the arguments do not
parse; recovery is best-effort, so `ci` ends up in an arbitrary but valid-to-access state
either way. `argv0`, when given, is the program path the default resource directory is
derived from. Neither `ci` nor `diag` is adopted — both are still owned, and disposed, by
the caller.
"""
function CreateFromArgs(ci::CompilerInvocation, args::Vector{String},
                        diag::DiagnosticsEngine,
                        argv0::Union{Nothing,AbstractString}=nothing)
    @check_ptrs ci diag
    prog = argv0 === nothing ? C_NULL : String(argv0)
    return clang_CompilerInvocation_CreateFromArgs(ci, args, length(args), diag, prog)
end

"""
    GetResourcesPath(argv0::AbstractString, main_addr::Ptr{Cvoid}) -> String
Return the directory holding the compiler's own headers, relative to the executable that
`argv0` and `main_addr` locate. `main_addr` may be `C_NULL`: it is only consulted by the
`dladdr` fallback inside `llvm::sys::fs::getMainExecutable`, which macOS, Linux and
Windows do not take. The result is pure path arithmetic — nothing on disk is checked.

`main_addr` has no default on purpose: the one-argument `GetResourcesPath` is
`clang::driver::Driver`'s, which takes an already-resolved binary path.
"""
function GetResourcesPath(argv0::AbstractString, main_addr::Ptr{Cvoid})
    return get_string(clang_CompilerInvocation_GetResourcesPath(argv0, main_addr))
end

"""
    checkCC1RoundTrip(args::Vector{String}, diag::DiagnosticsEngine,
                      argv0::Union{Nothing,AbstractString}=nothing) -> Bool
Check that the `-cc1` argument list `args` parses and re-serializes unchanged, reporting
every difference through the borrowed `diag`. Only meaningful for command lines that are
already canonical, such as one `getCC1CommandLine` produced. `diag` is not adopted.
"""
function checkCC1RoundTrip(args::Vector{String}, diag::DiagnosticsEngine,
                           argv0::Union{Nothing,AbstractString}=nothing)
    @check_ptrs diag
    prog = argv0 === nothing ? C_NULL : String(argv0)
    return clang_CompilerInvocation_checkCC1RoundTrip(args, length(args), diag, prog)
end

# CowCompilerInvocation
CowCompilerInvocation() = CowCompilerInvocation(create_cow_compiler_invocation())

"""
    create_cow_compiler_invocation() -> CXCowCompilerInvocation
Return a pointer to a `clang::CowCompilerInvocation` object.
"""
function create_cow_compiler_invocation()
    invocation = clang_CowCompilerInvocation_create()
    @assert invocation != C_NULL "Failed to create CowCompilerInvocation"
    return invocation
end

"""
    CowCompilerInvocation(ci::CompilerInvocation) -> CowCompilerInvocation
Deep-copy every option object out of `ci` into a fresh copy-on-write invocation. `ci` is
*not* adopted: it keeps its own storage, stays independently usable, and its owner still
disposes it — unlike `setInvocation`, which rewraps the raw handle in a fresh
`shared_ptr`, or `clang_Interpreter_create`, which consumes its `CompilerInstance` even
on failure. This function allocates and one should call `dispose` to release the
resources after using this object.
"""
function CowCompilerInvocation(ci::CompilerInvocation)
    @check_ptrs ci
    invocation = clang_CowCompilerInvocation_createFromInvocation(ci)
    @assert invocation != C_NULL "Failed to create CowCompilerInvocation"
    return CowCompilerInvocation(invocation)
end

dispose(x::CowCompilerInvocation) = clang_CowCompilerInvocation_dispose(x)

"""
    getCC1CommandLine(ci::CowCompilerInvocation) -> Vector{String}
Return the `-cc1` command line that reproduces this invocation. The line is regenerated
on every call and copied into Julia strings, so the result outlives the invocation.
"""
function getCC1CommandLine(ci::CowCompilerInvocation)
    @check_ptrs ci
    @assert hasLangStandard(getLangOpts(ci)) "the invocation has selected no language standard"
    return get_string(clang_CowCompilerInvocation_getCC1CommandLine(ci))
end

"""
    getLangOpts(ci::CowCompilerInvocation) -> LangOptions
Return a read-only view of this invocation's `clang::LangOptions`. Unlike
[`getMutLangOpts`](@ref) this does not detach the copy-on-write storage, so it is safe for
a query (borrowed view — never dispose it).
"""
function getLangOpts(ci::CowCompilerInvocation)
    @check_ptrs ci
    return LangOptions(clang_CowCompilerInvocation_getLangOpts(ci))
end

# Mutable option accessors: each detaches this invocation's copy-on-write storage for
# that option object from any invocation still sharing it, then hands back a borrowed
# interior view of this invocation's own copy — never dispose a return value.
"""
    getMutLangOpts(ci::CowCompilerInvocation) -> LangOptions
Return this invocation's `clang::LangOptions` for mutation, detaching its copy-on-write
storage first (borrowed view).
"""
function getMutLangOpts(ci::CowCompilerInvocation)
    @check_ptrs ci
    return LangOptions(clang_CowCompilerInvocation_getMutLangOpts(ci))
end

"""
    getMutTargetOpts(ci::CowCompilerInvocation) -> TargetOptions
Return this invocation's `clang::TargetOptions` for mutation, detaching its copy-on-write
storage first (borrowed view).
"""
function getMutTargetOpts(ci::CowCompilerInvocation)
    @check_ptrs ci
    return TargetOptions(clang_CowCompilerInvocation_getMutTargetOpts(ci))
end

"""
    getMutDiagnosticOpts(ci::CowCompilerInvocation) -> DiagnosticOptions
Return this invocation's `clang::DiagnosticOptions` for mutation, detaching its
copy-on-write storage first (borrowed view).
"""
function getMutDiagnosticOpts(ci::CowCompilerInvocation)
    @check_ptrs ci
    return DiagnosticOptions(clang_CowCompilerInvocation_getMutDiagnosticOpts(ci))
end

"""
    getMutHeaderSearchOpts(ci::CowCompilerInvocation) -> HeaderSearchOptions
Return this invocation's `clang::HeaderSearchOptions` for mutation, detaching its
copy-on-write storage first (borrowed view).
"""
function getMutHeaderSearchOpts(ci::CowCompilerInvocation)
    @check_ptrs ci
    return HeaderSearchOptions(clang_CowCompilerInvocation_getMutHeaderSearchOpts(ci))
end

"""
    getMutPreprocessorOpts(ci::CowCompilerInvocation) -> PreprocessorOptions
Return this invocation's `clang::PreprocessorOptions` for mutation, detaching its
copy-on-write storage first (borrowed view).
"""
function getMutPreprocessorOpts(ci::CowCompilerInvocation)
    @check_ptrs ci
    return PreprocessorOptions(clang_CowCompilerInvocation_getMutPreprocessorOpts(ci))
end

"""
    getMutAnalyzerOpts(ci::CowCompilerInvocation) -> AnalyzerOptions
Return this invocation's `clang::AnalyzerOptions` for mutation, detaching its
copy-on-write storage first (borrowed view).
"""
function getMutAnalyzerOpts(ci::CowCompilerInvocation)
    @check_ptrs ci
    return AnalyzerOptions(clang_CowCompilerInvocation_getMutAnalyzerOpts(ci))
end

"""
    getMutMigratorOpts(ci::CowCompilerInvocation) -> MigratorOptions
Return this invocation's `clang::MigratorOptions` for mutation, detaching its
copy-on-write storage first (borrowed view).
"""
function getMutMigratorOpts(ci::CowCompilerInvocation)
    @check_ptrs ci
    return MigratorOptions(clang_CowCompilerInvocation_getMutMigratorOpts(ci))
end

"""
    getMutAPINotesOpts(ci::CowCompilerInvocation) -> APINotesOptions
Return this invocation's `clang::APINotesOptions` for mutation, detaching its
copy-on-write storage first (borrowed view).
"""
function getMutAPINotesOpts(ci::CowCompilerInvocation)
    @check_ptrs ci
    return APINotesOptions(clang_CowCompilerInvocation_getMutAPINotesOpts(ci))
end

"""
    getMutCodeGenOpts(ci::CowCompilerInvocation) -> CodeGenOptions
Return this invocation's `clang::CodeGenOptions` for mutation, detaching its
copy-on-write storage first (borrowed view).
"""
function getMutCodeGenOpts(ci::CowCompilerInvocation)
    @check_ptrs ci
    return CodeGenOptions(clang_CowCompilerInvocation_getMutCodeGenOpts(ci))
end

"""
    getMutFileSystemOpts(ci::CowCompilerInvocation) -> FileSystemOptions
Return this invocation's `clang::FileSystemOptions` for mutation, detaching its
copy-on-write storage first (borrowed view).
"""
function getMutFileSystemOpts(ci::CowCompilerInvocation)
    @check_ptrs ci
    return FileSystemOptions(clang_CowCompilerInvocation_getMutFileSystemOpts(ci))
end

"""
    getMutFrontendOpts(ci::CowCompilerInvocation) -> FrontendOptions
Return this invocation's `clang::FrontendOptions` for mutation, detaching its
copy-on-write storage first (borrowed view).
"""
function getMutFrontendOpts(ci::CowCompilerInvocation)
    @check_ptrs ci
    return FrontendOptions(clang_CowCompilerInvocation_getMutFrontendOpts(ci))
end

"""
    getMutDependencyOutputOpts(ci::CowCompilerInvocation) -> DependencyOutputOptions
Return this invocation's `clang::DependencyOutputOptions` for mutation, detaching its
copy-on-write storage first (borrowed view).
"""
function getMutDependencyOutputOpts(ci::CowCompilerInvocation)
    @check_ptrs ci
    return DependencyOutputOptions(clang_CowCompilerInvocation_getMutDependencyOutputOpts(ci))
end

"""
    getMutPreprocessorOutputOpts(ci::CowCompilerInvocation) -> PreprocessorOutputOptions
Return this invocation's `clang::PreprocessorOutputOptions` for mutation, detaching its
copy-on-write storage first (borrowed view).
"""
function getMutPreprocessorOutputOpts(ci::CowCompilerInvocation)
    @check_ptrs ci
    ptr = clang_CowCompilerInvocation_getMutPreprocessorOutputOpts(ci)
    return PreprocessorOutputOptions(ptr)
end
