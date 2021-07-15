# ClangCompiler

[![Build Status](https://github.com/Gnimuc/ClangCompiler.jl/workflows/CI/badge.svg)](https://github.com/Gnimuc/ClangCompiler.jl/actions)

## Installation

1. Print the directory path to `libclang-cpp`.
```
julia -e "using LLVM_full_jll; println(joinpath(LLVM_full_jll.artifact_dir, \"lib\"))"
```

2. Add the output above to your `DYLD_LIBRARY_PATH`/`LD_LIBRARY_PATH`/`PATH`.

3. Install the package
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
args = get_default_args()

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
