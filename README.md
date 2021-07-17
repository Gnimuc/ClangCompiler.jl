# ClangCompiler

[![Build Status](https://github.com/Gnimuc/ClangCompiler.jl/workflows/CI/badge.svg)](https://github.com/Gnimuc/ClangCompiler.jl/actions)

## Installation

For now, this package only targets Julia 1.7 on macOS, it's not hard to edit a few lines to support other platforms though.

1. Build [libclangex](https://github.com/Gnimuc/libclangex) and setup `ENV["LIBCLANGEX_INSTALL_PREFIX"]`.
2. Install and test the package by running:
```
pkg> dev https://github.com/Gnimuc/ClangComplier.jl.git

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

# create compiler
cpr = create_compiler(src, args)

# generate IR
m = compile(cpr)

# create JIT and call function
ee = JIT(m)
ret = run(ee, lookup_function(m, "main"))

# clean up
destroy(cpr)
```
