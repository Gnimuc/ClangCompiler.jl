module ClangCompiler

const __DLEXT = Base.BinaryPlatforms.platform_dlext()
const __ARTIFACT_BINDIR = Sys.iswindows() ? "bin" : "lib"

using LLVM_full_jll
# using libclangex_jll
const libclangex = joinpath(ENV["LIBCLANGEX_INSTALL_PREFIX"], __ARTIFACT_BINDIR, "libclangex.$__DLEXT") |> normpath
const libclangex_include = joinpath(ENV["LIBCLANGEX_INSTALL_PREFIX"], "include") |> normpath
const julia_include_dir = joinpath(Sys.BINDIR, "..", "include", "julia") |> normpath
const CLANG_BIN = joinpath(LLVM_full_jll.artifact_dir, "bin", "clang")

using LLVM
using LLVM.API: LLVMContextRef
using LLVM.Interop: call_function
export call_function

include("clang/LibClangEx.jl")
using .LibClangEx

include("platform/JLLEnvs.jl")
using .JLLEnvs

function get_compiler_args(;is_cxx=true, version=v"7.1.0")
    args = JLLEnvs.get_default_args(is_cxx, version)
    is_cxx ? push!(args, "-nostdinc++", "-nostdlib++") : push!(args, "-nostdinc", "-nostdlib")
    pushfirst!(args, CLANG_BIN)  # Argv0
    return args
end
export get_compiler_args

# internal
include("clang/type.jl")
include("clang/frontend.jl")
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
export CxxCompiler
export get_module, get_context, get_jit, get_codegen, get_dylib
export compile, destroy
export IRGenerator, generate_llvmir
export link_process_symbols

include("llvm.jl")
export lookup_function, link, link_crt

include("utils.jl")
export jlty2llvmty

# boot
const BOOT_COMPILER_REF = Ref{CxxCompiler}()

function __init__()
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
    irgen = generate_llvmir(boot_src, args)
    BOOT_COMPILER_REF[] = CxxCompiler(irgen, jit)

    link_process_symbols(BOOT_COMPILER_REF[])
    compile(BOOT_COMPILER_REF[])
end

include("boot.jl")

end
