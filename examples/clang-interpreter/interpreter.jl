using ClangCompiler
using ClangCompiler.LLVM_full_jll
using ClangCompiler.LLVM
using Libdl

llvm_include_dir = joinpath(LLVM_full_jll.artifact_dir, "include") |> normpath
@assert isdir(llvm_include_dir)
llvm_lib_dir = joinpath(LLVM_full_jll.artifact_dir, "lib") |> normpath
@assert isdir(llvm_lib_dir)
libclangcpp = joinpath(llvm_lib_dir, "libclang-cpp.$(Libdl.dlext)") |> normpath
@assert isfile(libclangcpp)

# link(libclangcpp)

src = joinpath(@__DIR__, "main.cpp")

args = get_compiler_args(; version=v"7.1.0")
push!(args, "-std=c++14")
Sys.isapple() && push!(args, "-stdlib=libc++")
push!(args, "-I$llvm_include_dir")

irgen = IRGenerator(src, args)

m = get_module(irgen)

ee = JIT(m);

f = lookup_function(ee, "main")

local_machine_env_compiler_args = [
    "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++",
    "-isysroot/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX11.1.sdk",
    "-I/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1",
    "-I$(joinpath(llvm_lib_dir, "clang", "12.0.0", "include"))",
    "-mmacosx-version-min=10.15",
    "-std=gnu++14",
    joinpath(@__DIR__, "Test.cxx"),
    # "-v",
]

argc = length(local_machine_env_compiler_args)
argv = pointer.(local_machine_env_compiler_args)
argv = Base.unsafe_convert(Ptr{Ptr{UInt8}}, argv)

run(ee, f, [
    GenericValue(LLVM.Int32Type(irgen.ctx), argc),
    GenericValue(argv)
])
