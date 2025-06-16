# ClangCompiler

[![CI](https://github.com/Gnimuc/ClangCompiler.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/Gnimuc/ClangCompiler.jl/actions/workflows/CI.yml)
[![TagBot](https://github.com/Gnimuc/ClangCompiler.jl/actions/workflows/TagBot.yml/badge.svg)](https://github.com/Gnimuc/ClangCompiler.jl/actions/workflows/TagBot.yml)
[![codecov](https://codecov.io/gh/Gnimuc/ClangCompiler.jl/graph/badge.svg?token=uJ7HWrZcmd)](https://codecov.io/gh/Gnimuc/ClangCompiler.jl)

ClangCompiler.jl provides a Julia interface to the Clang C++ API, and can be used for tasks such as declaration lookup, parsing, code analysis, etc.

## Installation

```
pkg> add ClangCompiler
```

## Examples

### Decl Lookup

The following example demonstrates how to perform a declaration lookup:

```julia-repl
import ClangCompiler as CC

# Create an interpreter
I = CC.create_interpreter(["-include", "vector"])

# Initialize a declaration lookup instance
decl_lookup = CC.DeclFinder(I)

# Perform a lookup for the declaration of std::vector
@assert decl_lookup(I, "std::vector")

# Retrieve lookup results and dump AST
decl = CC.get_decl(decl_lookup)
CC.dump(decl)

# Clean up resources
CC.dispose(decl_lookup)
CC.dispose(I)
```

### AST Traversal

The following example demonstrates how to perform AST traversal:

```julia-repl
import ClangCompiler as CC

# Create an interpreter
I = CC.create_interpreter(["-include", "vector"])

# Initialize a declaration lookup instance
decl_lookup = CC.DeclFinder(I)

# Perform a lookup for the declaration of std::vector
@assert decl_lookup(I, "std::vector")

# Retrieve lookup results
decl = CC.get_decl(decl_lookup)

# Extract the `CXXRecordDecl` from `ClassTemplateDecl`
record = CC.getTemplatedDecl(CC.ClassTemplateDecl(decl.ptr))

# AST Traversal
for x in CC.DeclIterator(record)
    CC.dump(x)
end

# Clean up resources
CC.dispose(decl_lookup)
CC.dispose(I)
```