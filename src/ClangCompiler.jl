module ClangCompiler

const libclangex = joinpath(ENV["LIBCLANGEX_INSTALL_PREFIX"], "..", "libclangex.dylib") |> normpath

using LLVM_full_jll

const CLANG_BIN = joinpath(LLVM_full_jll.artifact_dir, "tools", "clang")

using LLVM
using LLVM.API: LLVMContextRef
using LLVM.Interop: call_function
export call_function

include("clang/LibClangEx.jl")
using .LibClangEx

include("platform/JLLEnvs.jl")
using .JLLEnvs

function get_default_args(;is_cxx=true, version=v"7.1.0")
    args = JLLEnvs.get_default_args(is_cxx, version)
    is_cxx ? push!(args, "-nostdinc++", "-nostdlib++") : push!(args, "-nostdinc", "-nostdlib")
    pushfirst!(args, CLANG_BIN)  # Argv0
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

include("llvm.jl")
export lookup_function, link, link_crt

end
