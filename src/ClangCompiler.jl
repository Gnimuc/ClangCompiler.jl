module ClangCompiler

const libclangex = joinpath(ENV["LIBCLANGEX_INSTALL_PREFIX"], "..", "libclangex.dylib") |> normpath

using LibClang
using LLVM

include("clang/LibClangEx.jl")
using .LibClangEx

include("platform/JLLEnvs.jl")
using .JLLEnvs

include("clang/diagnostic.jl")
include("clang/source.jl")
end
