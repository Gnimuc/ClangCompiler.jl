"""
    mutable struct CompilerInvocation <: Any
Holds a pointer to a `clang::CompilerInvocation` object.
"""
mutable struct CompilerInvocation
    ptr::CXCompilerInvocation
end
CompilerInvocation() = CompilerInvocation(create_compiler_invocation())

"""
    create_compiler_invocation() -> CXCompilerInvocation
Return a pointer to a `clang::CompilerInvocation` object.
"""
function create_compiler_invocation()
    status = Ref{CXInit_Error}(CXInit_NoError)
    invocation = clang_CompilerInvocation_create(status)
    @assert status[] == CXInit_NoError
    return invocation
end

const __CC_CMD_ARGS_CACHE = Dict{Int,Vector{String}}()
const __CC_CMD_ARGS_CACHE_COUNTER = Threads.Atomic{Int}(0)

function __reset_counter()
    return Threads.atomic_sub!(__CC_CMD_ARGS_CACHE_COUNTER, __CC_CMD_ARGS_CACHE_COUNTER[])
end
__add_counter() = Threads.atomic_add!(__CC_CMD_ARGS_CACHE_COUNTER, 1)
__get_counter() = __CC_CMD_ARGS_CACHE_COUNTER[]
__new_id() = (__add_counter(); __get_counter())
__clear_cache() = empty!(__CC_CMD_ARGS_CACHE)

"""
    create_compiler_invocation_from_cmd(src::String, args::Vector{String}=String[], diag::DiagnosticsEngine=DiagnosticsEngine()) -> CompilerInvocation
Return a `CompilerInvocation` created from command line arguments.
"""
function create_compiler_invocation_from_cmd(src::String, args::Vector{String}=String[],
                                             diag::DiagnosticsEngine=DiagnosticsEngine())
    status = Ref{CXInit_Error}(CXInit_NoError)
    args_with_src = copy(args)
    push!(args_with_src, src)
    __CC_CMD_ARGS_CACHE[__new_id()] = args_with_src
    invocation = clang_CompilerInvocation_createFromCommandLine(args_with_src,
                                                                langth(args_with_src), diag,
                                                                status)
    @assert status[] == CXInit_NoError
    return CompilerInvocation(invocation)
end

# Options
function get_codegen_options(ci::CompilerInvocation)
    return CodeGenOptions(clang_CompilerInstance_getCodeGenOpts(ci.ptr))
end

function get_diagnostic_options(ci::CompilerInvocation)
    return DiagnosticOptions(clang_CompilerInstance_getDiagnosticOpts(ci.ptr))
end

function get_frontend_options(ci::CompilerInvocation)
    return FrontendOptions(clang_CompilerInstance_getFrontendOpts(ci.ptr))
end

function get_header_search_options(ci::CompilerInvocation)
    return HeaderSearchOptions(clang_CompilerInstance_getHeaderSearchOpts(ci.ptr))
end

function get_preprocessor_options(ci::CompilerInvocation)
    return PreprocessorOptions(clang_CompilerInstance_getPreprocessorOpts(ci.ptr))
end

function get_target_options(ci::CompilerInvocation)
    return TargetOptions(clang_CompilerInvocation_getTargetOpts(ci.ptr))
end
