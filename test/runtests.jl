# HACK: work around Pkg.jl#2500
if VERSION < v"1.8-"
test_project = Base.active_project()
preferences_file = joinpath(dirname(@__DIR__), "LocalPreferences.toml")
test_preferences_file = joinpath(dirname(test_project), "LocalPreferences.toml")
if isfile(preferences_file) && !isfile(test_preferences_file)
    cp(preferences_file, test_preferences_file)
end
end

using ClangCompiler
using Test

using libclangex_jll
@info "Testing against" libclangex_jll.libclangex

if haskey(ENV, "CI")
    include("clang/status.jl")
    include("platform/env.jl")
end

include("llvm/pointer_from_objref.jl")

include("clang/diagnostic.jl")
include("clang/source.jl")
include("clang/instance.jl")

include("lookup.jl")
if Sys.isapple()
    include("call.jl")
    include("execution.jl")
end
include("types.jl")

if haskey(ENV, "CLANGCOMPILER_ENABLE_BOOT")
    include("boot.jl")
end
