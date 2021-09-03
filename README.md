# ClangCompiler

[![Build Status](https://github.com/Gnimuc/ClangCompiler.jl/workflows/CI/badge.svg)](https://github.com/Gnimuc/ClangCompiler.jl/actions)

## Installation

This package does not provide an out-of-box installation experience at the moment due to a limitation of [BinaryBuilder.jl](https://github.com/JuliaPackaging/BinaryBuilder.jl)(see [this issue](https://github.com/JuliaPackaging/Yggdrasil/pull/3315)).

1. Find the path to `libclang-cpp`, for example, run:
```shell
# macOS & Linux
julia -e "using LLVM_full_jll; println(joinpath(LLVM_full_jll.artifact_dir, \"lib\"))"

# Windows
julia -e "using LLVM_full_jll; println(joinpath(LLVM_full_jll.artifact_dir, \"bin\"))"
```
2. Add the path to `DYLD_LIBRARY_PATH`/`LD_LIBRARY_PATH`/`PATH`, for example, on macOS you could add the line below to your `.bashrc`.
```bash
export DYLD_LIBRARY_PATH="/path to/.julia/artifacts/8bfb227d3cb7e2ccd779f47050025cfa0b0fea9b/lib:${DYLD_LIBRARY_PATH:-}"
```
3. Make sure you don't have `LIBCLANGEX_INSTALL_PREFIX` in your environment variable.
4. Install and test the package by running:
```julia-repl
pkg> dev https://github.com/Gnimuc/ClangCompiler.jl.git

pkg> test ClangCompiler
```

### Development(macOS and Linux)
1. Build [libclangex](https://github.com/Gnimuc/libclangex) locally and set `ENV["LIBCLANGEX_INSTALL_PREFIX"]` to the `install` directory.
2. Install and test the package by running:
```julia-repl
pkg> dev https://github.com/Gnimuc/ClangCompiler.jl.git

pkg> test ClangCompiler
```

## Quick start

```julia-repl
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
