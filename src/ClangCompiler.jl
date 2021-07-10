module ClangCompiler

const libclangex = joinpath(ENV["LIBCLANGEX_INSTALL_PREFIX"], "..", "libclangex.dylib") |> normpath

using LLVM
using LLVM.API: LLVMContextRef, LLVMGetGlobalContext, LLVMGetLastFunction
using LLVM.Interop: call_function

include("clang/LibClangEx.jl")
using .LibClangEx

include("platform/JLLEnvs.jl")
using .JLLEnvs

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
export CLCompiler
export create_compiler, destroy, compile

end
