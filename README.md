# ClangCompiler

[![CI](https://github.com/Gnimuc/ClangCompiler.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/Gnimuc/ClangCompiler.jl/actions/workflows/CI.yml)
[![TagBot](https://github.com/Gnimuc/ClangCompiler.jl/actions/workflows/TagBot.yml/badge.svg)](https://github.com/Gnimuc/ClangCompiler.jl/actions/workflows/TagBot.yml)
[![codecov](https://codecov.io/gh/Gnimuc/ClangCompiler.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/Gnimuc/ClangCompiler.jl)

## Installation

```
pkg> add https://github.com/Gnimuc/ClangCompiler.jl.git
```

## Examples

### Decl Lookup

```julia
using ClangCompiler

# source file
src = joinpath(dirname(pathof(ClangCompiler)), "..", "examples", "sample.cpp")

# compilation flags
args = get_compiler_args()

cc = ClangCompiler.IncrementalIRGenerator(src, args)

decl_lookup = DeclFinder(cc.instance)

@assert decl_lookup(cc, "vector", "std::vector")

decl = get_decl(decl_lookup)
dump(decl)

# clean up
dispose(decl_lookup)
dispose(cc)
```

### JIT (experimental)

The following example is only tested on macOS.

```julia
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
