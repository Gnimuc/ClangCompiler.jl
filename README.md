# ClangCompiler

[![Build Status](https://github.com/Gnimuc/ClangCompiler.jl/workflows/CI/badge.svg)](https://github.com/Gnimuc/ClangCompiler.jl/actions)

## Installation

For now, this package only targets Julia 1.7 on macOS, it's not hard to edit a few lines to support other platforms though.

1. Build [libclangex](https://github.com/Gnimuc/libclangex) and setup `ENV["LIBCLANGEX_INSTALL_PREFIX"]`.
2. Install and test the package by running:
```
pkg> dev https://github.com/Gnimuc/ClangCompiler.jl.git

pkg> test ClangCompiler
```

## Quick start

```
using ClangCompiler
using ClangCompiler.LLVM

# source file
src = joinpath(dirname(pathof(ClangCompiler)), "..", "examples", "sample.cpp")

# compilation flags
args = get_compiler_args()

# create JIT
jit = LLJIT(;tm=JITTargetMachine())

# generate LLVM IR
irgen = IRGenerator(src, args)

# compile and link
cc = CXCompiler(irgen, jit)
link_process_symbols(cc)
compile(cc)

# lookup and call the main function 
addr = lookup(jit, "main")
@eval main() = ccall($(pointer(addr)), Cint, ())

main()

# clean up
dispose(cc)
```
