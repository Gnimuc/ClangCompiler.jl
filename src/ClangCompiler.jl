module ClangCompiler

const libclangex = joinpath(ENV["LIBCLANGEX_INSTALL_PREFIX"], "..", "libclangex.dylib") |> normpath

using LLVM_full_jll

using LLVM
using LLVM.API: LLVMContextRef, LLVMGetGlobalContext, LLVMGetLastFunction
using LLVM.Interop: call_function

include("clang/LibClangEx.jl")
using .LibClangEx

include("platform/JLLEnvs.jl")
using .JLLEnvs
export get_default_args

function get_default_args(verbose=false)
    args = JLLEnvs.get_default_args()
    push!(args, "-nostdinc", "-nostdinc++", "-std=c++17")
    pushfirst!(args, "clang")  # Argv0
    verbose && push!(args, "-v")
    return args
end
export get_default_args

# internal
include("clang/option.jl")
include("clang/preprocessor.jl")
include("clang/diagnostic.jl")
include("clang/target.jl")
include("clang/buffer.jl")
include("clang/source.jl")
include("clang/ast.jl")
include("clang/codegen.jl")
include("clang/sema.jl")
include("clang/parser.jl")
include("clang/invocation.jl")
include("clang/instance.jl")

# interface
include("parse.jl")
include("compile.jl")
export CXXCompiler
export create_compiler, destroy, compile



end
