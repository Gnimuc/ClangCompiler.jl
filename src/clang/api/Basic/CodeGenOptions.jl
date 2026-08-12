# CodeGenOptions
CodeGenOptions() = CodeGenOptions(create_codegen_options())

"""
    create_codegen_options() -> CXCodeGenOptions
Return a pointer to a `clang::CodeGenOptions` object.
"""
function create_codegen_options()
    opts = clang_CodeGenOptions_create()
    @assert opts != C_NULL "Failed to create CodeGenOptions"
    return opts
end

dispose(x::CodeGenOptions) = clang_CodeGenOptions_dispose(x)
function getArgv0(x::CodeGenOptions)
    @check_ptrs x
    return unsafe_string(clang_CodeGenOptions_getArgv0(x))
end

function getCommandLineArgs(x::CodeGenOptions)
    @check_ptrs x
    n = clang_CodeGenOptions_getCommandLineArgsNum(x)
    args = Vector{Ptr{Cchar}}(undef, n)
    clang_CodeGenOptions_getCommandLineArgs(x, args, n)
    return [unsafe_string(p) for p in args]
end

function PrintStats(x::CodeGenOptions)
    @check_ptrs x
    return clang_CodeGenOptions_PrintStats(x)
end

"""
    getClearASTBeforeBackend(x::AbstractCodeGenOptions) -> Bool
Whether the frontend releases the AST before running the backend.
"""
function getClearASTBeforeBackend(x::AbstractCodeGenOptions)
    @check_ptrs x
    return clang_CodeGenOptions_getClearASTBeforeBackend(x) != 0
end

"""
    setClearASTBeforeBackend(x::AbstractCodeGenOptions, value::Bool)
Choose whether the frontend releases the AST before running the backend — an
`ASTContext::cleanup()` and an arena reset, leaving what the `SourceManager` needs.

Clearing this is what an embedder that generates code from one AST more than once has to do;
leaving it set is otherwise harmless even when [`setDisableFree`](@ref) is off, because
`~ASTContext` *is* `cleanup()`, every container it walks is emptied as it goes and
`ReleaseDeclContextMaps` nulls its list head, so the second pass is a no-op by construction.
"""
function setClearASTBeforeBackend(x::AbstractCodeGenOptions, value::Bool)
    @check_ptrs x
    return clang_CodeGenOptions_setClearASTBeforeBackend(x, value)
end

"""
    getDisableFree(x::AbstractCodeGenOptions) -> Bool
Whether codegen leaves its own allocations for the process to take away.
"""
function getDisableFree(x::AbstractCodeGenOptions)
    @check_ptrs x
    return clang_CodeGenOptions_getDisableFree(x) != 0
end

"""
    setDisableFree(x::AbstractCodeGenOptions, value::Bool)
Choose whether codegen leaves its own allocations for the process to take away.

**This is a second, independent copy of the flag** `setDisableFree(::AbstractFrontendOptions,
…)` sets: `CompilerInvocation::CreateFromArgsImpl` seeds it from the frontend one and the two
go their own way afterwards, so an invocation built from a command line needs both cleared.
What reads this one is `~EmitAssemblyHelper`, which buries the `llvm::TargetMachine` instead
of destroying it — the only use of the flag in CodeGen, so clearing it trades one leak per
compilation for an ordinary destructor call.
"""
function setDisableFree(x::AbstractCodeGenOptions, value::Bool)
    @check_ptrs x
    return clang_CodeGenOptions_setDisableFree(x, value)
end

"""
    getOptimizationLevel(x::AbstractCodeGenOptions) -> Int
Return the `-O` level, 0 through 3.
"""
function getOptimizationLevel(x::AbstractCodeGenOptions)
    @check_ptrs x
    return Int(clang_CodeGenOptions_getOptimizationLevel(x))
end

"""
    setOptimizationLevel(x::AbstractCodeGenOptions, level::Integer)
Set the `-O` level. clang stores it in two bits, so `level` must be 0 through 3; a larger
value would be silently truncated by the C++ assignment.
"""
function setOptimizationLevel(x::AbstractCodeGenOptions, level::Integer)
    @check_ptrs x
    @assert 0 ≤ level ≤ 3 "the optimization level is a two-bit field: 0 through 3"
    return clang_CodeGenOptions_setOptimizationLevel(x, level)
end

"""
    getOptimizeSize(x::AbstractCodeGenOptions) -> Int
Return 1 for `-Os`, 2 for `-Oz` and 0 for neither.
"""
function getOptimizeSize(x::AbstractCodeGenOptions)
    @check_ptrs x
    return Int(clang_CodeGenOptions_getOptimizeSize(x))
end

"""
    setOptimizeSize(x::AbstractCodeGenOptions, level::Integer)
Select `-Os` (1), `-Oz` (2) or neither (0). Two bits again, so 3 is the hard upper bound
even though clang gives it no meaning.
"""
function setOptimizeSize(x::AbstractCodeGenOptions, level::Integer)
    @check_ptrs x
    @assert 0 ≤ level ≤ 3 "the optimize-size field is two bits wide"
    return clang_CodeGenOptions_setOptimizeSize(x, level)
end

"""
    getDebugInfo(x::AbstractCodeGenOptions) -> CXDebugInfoKind
Return how much debug information codegen would emit.
"""
function getDebugInfo(x::AbstractCodeGenOptions)
    @check_ptrs x
    return clang_CodeGenOptions_getDebugInfo(x)
end

"""
    setDebugInfo(x::AbstractCodeGenOptions, kind::CXDebugInfoKind)
Set how much debug information codegen should emit.
"""
function setDebugInfo(x::AbstractCodeGenOptions, kind::CXDebugInfoKind)
    @check_ptrs x
    return clang_CodeGenOptions_setDebugInfo(x, kind)
end

"""
    getRelocationModel(x::AbstractCodeGenOptions) -> CXRelocModel
Return the relocation model codegen would use.
"""
function getRelocationModel(x::AbstractCodeGenOptions)
    @check_ptrs x
    return clang_CodeGenOptions_getRelocationModel(x)
end

"""
    setRelocationModel(x::AbstractCodeGenOptions, model::CXRelocModel)
Set the relocation model codegen should use.
"""
function setRelocationModel(x::AbstractCodeGenOptions, model::CXRelocModel)
    @check_ptrs x
    return clang_CodeGenOptions_setRelocationModel(x, model)
end

"""
    getCodeModel(x::AbstractCodeGenOptions) -> String
Return the `-mcmodel` value, empty when none was set.
"""
function getCodeModel(x::AbstractCodeGenOptions)
    @check_ptrs x
    return get_string(clang_CodeGenOptions_getCodeModel(x))
end

"""
    setCodeModel(x::AbstractCodeGenOptions, model::AbstractString)
Set the `-mcmodel` value.
"""
function setCodeModel(x::AbstractCodeGenOptions, model::AbstractString)
    @check_ptrs x
    return clang_CodeGenOptions_setCodeModel(x, model)
end

"""
    getMainFileName(x::AbstractCodeGenOptions) -> String
Return the name codegen reports for the main file, empty when none was set.
"""
function getMainFileName(x::AbstractCodeGenOptions)
    @check_ptrs x
    return get_string(clang_CodeGenOptions_getMainFileName(x))
end

"""
    setMainFileName(x::AbstractCodeGenOptions, name::AbstractString)
Set the name codegen reports for the main file — what `-save-temps` needs when the input
file name is not the original one.
"""
function setMainFileName(x::AbstractCodeGenOptions, name::AbstractString)
    @check_ptrs x
    return clang_CodeGenOptions_setMainFileName(x, name)
end
