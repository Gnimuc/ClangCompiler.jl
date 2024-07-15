# ClangCompiler

[![CI](https://github.com/Gnimuc/ClangCompiler.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/Gnimuc/ClangCompiler.jl/actions/workflows/CI.yml)
[![TagBot](https://github.com/Gnimuc/ClangCompiler.jl/actions/workflows/TagBot.yml/badge.svg)](https://github.com/Gnimuc/ClangCompiler.jl/actions/workflows/TagBot.yml)
[![codecov](https://codecov.io/gh/Gnimuc/ClangCompiler.jl/graph/badge.svg?token=uJ7HWrZcmd)](https://codecov.io/gh/Gnimuc/ClangCompiler.jl)

## Installation

```
pkg> add https://github.com/Gnimuc/ClangCompiler.jl.git
```

## Examples

### Decl Lookup

```julia-repl
import ClangCompiler as CC

I = CC.create_interpreter(["-include", "vector"])

decl_lookup = CC.DeclFinder(I)

@assert decl_lookup(I, "std::vector")

decl = CC.get_decl(decl_lookup)
dump(decl)

CC.dispose(decl_lookup)
CC.dispose(I)
```