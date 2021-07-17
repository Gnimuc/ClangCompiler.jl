using ClangCompiler
using ClangCompiler.LLVM

const CC = ClangCompiler

src = joinpath(@__DIR__, "sample.cpp")
args = get_compiler_args()

irgen = generate_llvmir(src, args)

instance = irgen.instance
pp = CC.get_preprocessor(instance)
CC.clang_Preprocessor_enableIncrementalProcessing(pp.ptr)
