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

# failed to workaround https://llvm.discourse.group/t/confused-about-the-usage-of-arrayref-in-clang/3807
# const __CC_CMD_ARGS_CACHE = Dict{Int,Vector{String}}()
# const __CC_CMD_ARGS_CACHE_COUNTER = Threads.Atomic{Int}(0)

# function __reset_counter()
#     return Threads.atomic_sub!(__CC_CMD_ARGS_CACHE_COUNTER, __CC_CMD_ARGS_CACHE_COUNTER[])
# end
# __add_counter() = Threads.atomic_add!(__CC_CMD_ARGS_CACHE_COUNTER, 1)
# __get_counter() = __CC_CMD_ARGS_CACHE_COUNTER[]
# __new_id() = (__add_counter(); __get_counter())
# __clear_cache() = empty!(__CC_CMD_ARGS_CACHE)

"""
    create_compiler_invocation_from_cmd(src::String, args::Vector{String}=String[], diag::DiagnosticsEngine=DiagnosticsEngine()) -> CompilerInvocation
Return a `CompilerInvocation` created from command line arguments.
"""
function create_compiler_invocation_from_cmd(src::String, args::Vector{String}=String[],
                                             diag::DiagnosticsEngine=DiagnosticsEngine())
    status = Ref{CXInit_Error}(CXInit_NoError)
    args_with_src = copy(args)
    push!(args_with_src, src)
    # __CC_CMD_ARGS_CACHE[__new_id()] = args_with_src
    invocation = clang_CompilerInvocation_createFromCommandLine(args_with_src,
                                                                length(args_with_src), diag.ptr,
                                                                status)
    @assert status[] == CXInit_NoError
    return CompilerInvocation(invocation)
end

# Options
function get_codegen_options(ci::CompilerInvocation)
    @assert ci.ptr != C_NULL "CompilerInvocation has a NULL pointer."
    return CodeGenOptions(clang_CompilerInvocation_getCodeGenOpts(ci.ptr))
end

function get_diagnostic_options(ci::CompilerInvocation)
    @assert ci.ptr != C_NULL "CompilerInvocation has a NULL pointer."
    return DiagnosticOptions(clang_CompilerInvocation_getDiagnosticOpts(ci.ptr))
end

function get_frontend_options(ci::CompilerInvocation)
    @assert ci.ptr != C_NULL "CompilerInvocation has a NULL pointer."
    return FrontendOptions(clang_CompilerInvocation_getFrontendOpts(ci.ptr))
end

function get_header_search_options(ci::CompilerInvocation)
    @assert ci.ptr != C_NULL "CompilerInvocation has a NULL pointer."
    return HeaderSearchOptions(clang_CompilerInvocation_getHeaderSearchOpts(ci.ptr))
end

function get_preprocessor_options(ci::CompilerInvocation)
    @assert ci.ptr != C_NULL "CompilerInvocation has a NULL pointer."
    return PreprocessorOptions(clang_CompilerInvocation_getPreprocessorOpts(ci.ptr))
end

function get_target_options(ci::CompilerInvocation)
    @assert ci.ptr != C_NULL "CompilerInvocation has a NULL pointer."
    return TargetOptions(clang_CompilerInvocation_getTargetOpts(ci.ptr))
end
