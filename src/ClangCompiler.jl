module ClangCompiler

const __DLEXT = Base.BinaryPlatforms.platform_dlext()
const __ARTIFACT_BINDIR = Sys.iswindows() ? "bin" : "lib"

using LLVM_full_jll

if haskey(ENV, "LIBCLANGEX_INSTALL_PREFIX") && !isempty(get(ENV, "LIBCLANGEX_INSTALL_PREFIX", ""))
    const libclangex = joinpath(ENV["LIBCLANGEX_INSTALL_PREFIX"], __ARTIFACT_BINDIR, "libclangex.$__DLEXT") |> normpath
    const libclangex_include = joinpath(ENV["LIBCLANGEX_INSTALL_PREFIX"], "include") |> normpath
else
    # need manually add the output path below to `DYLD_LIBRARY_PATH`/`LD_LIBRARY_PATH`/`PATH`
    # julia -e "using LLVM_full_jll; println(joinpath(LLVM_full_jll.artifact_dir, \"lib\"))"
    using libclangex_jll
    const libclangex_include = joinpath(libclangex_jll.artifact_dir, "include") |> normpath
end

const julia_include_dir = joinpath(Sys.BINDIR, "..", "include", "julia") |> normpath

using LLVM
using LLVM.Interop: call_function
export call_function
import LLVM: dispose, name, value

import Base: dump, string

const CLANG_BIN = joinpath(LLVM_full_jll.artifact_dir, "bin", "clang")
const CLANG_INC = joinpath(LLVM_full_jll.artifact_dir, "lib", "clang", string(LLVM.version()), "include")

include("../lib/LibClangEx.jl")
using .LibClangEx

include("platform/JLLEnvs.jl")
using .JLLEnvs

function get_compiler_args(;is_cxx=true, version=v"7.1.0")
    args = JLLEnvs.get_default_args(is_cxx, version)
    push!(args, "-isystem"*CLANG_INC)
    is_cxx && push!(args, "-nostdinc++", "-nostdlib++")
    push!(args, "-nostdinc", "-nostdlib")
    pushfirst!(args, CLANG_BIN)  # Argv0
    return args
end
export get_compiler_args

# low-level
include("clang/utils.jl")
include("clang/core/core.jl")
include("clang/api/api.jl")
include("clang/ast.jl")
include("clang/basic.jl")
include("clang/codegen.jl")
include("clang/frontend.jl")
include("clang/lex.jl")
include("clang/parse.jl")
include("clang/qualtype.jl")
include("clang/sema.jl")
export AbstractClangType, AbstractQualType, AbstractBuiltinType

# high-level
include("types.jl")
export jlty_to_clty, clty_to_jlty, jlty_to_llvmty

include("parse.jl")
include("lookup.jl")
export DeclFinder, get_decl

include("template.jl")
export specialize

include("compiler.jl")
export AbstractCompiler, AbstractIRGenerator
export IRGenerator, IncrementalIRGenerator
export CXCompiler
export get_instance, get_context
export get_module, get_jit, get_dylib, get_codegen
export compile, dispose
export link_process_symbols
export get_modules, get_current_module
export incremental_parse

include("llvm.jl")
export lookup_function, link, link_crt
export get_buffer

include("utils.jl")
export jlty2llvmty

# boot
const BOOT_COMPILER_REF = Ref{CXCompiler}()

function __init__()
@static if haskey(ENV, "CLANGCOMPILER_ENABLE_BOOT")
    llvm_include_dir = joinpath(LLVM_full_jll.artifact_dir, "include") |> normpath
    @assert isdir(llvm_include_dir) "failed to find LLVM include dir."

    boot_include_dir = joinpath(@__DIR__, "..", "boot") |> normpath
    boot_src = joinpath(boot_include_dir, "boot.cpp")

    args = get_compiler_args(; version=v"7.1.0")
    push!(args, "-std=c++14")
    Sys.isapple() && push!(args, "-stdlib=libc++")
    push!(args, "-I$llvm_include_dir")
    push!(args, "-I$libclangex_include")
    push!(args, "-I$julia_include_dir")
    push!(args, "-I$boot_include_dir")

    jit = LLJIT(;tm=JITTargetMachine())
    irgen = IRGenerator(boot_src, args)
    BOOT_COMPILER_REF[] = CXCompiler(irgen, jit)

    link_process_symbols(BOOT_COMPILER_REF[])
    compile(BOOT_COMPILER_REF[])

    include(joinpath(@__DIR__, "boot.jl"))
end # @static
end

end
