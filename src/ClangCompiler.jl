module ClangCompiler

const libclangex = joinpath(ENV["LIBCLANGEX_INSTALL_PREFIX"], "..", "libclangex.dylib") |> normpath

using LLVM

include("clang/LibClangEx.jl")
using .LibClangEx

include("platform/JLLEnvs.jl")
using .JLLEnvs

include("clang/diagnostic.jl")
include("clang/option.jl")
include("clang/target.jl")
include("clang/buffer.jl")
include("clang/source.jl")
include("clang/preprocessor.jl")
include("clang/ast.jl")
include("clang/sema.jl")
include("clang/invocation.jl")
include("clang/instance.jl")

end
