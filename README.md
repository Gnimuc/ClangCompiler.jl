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

### Execution

The following example demonstrates how to compile and invoke function:

```
julia> import ClangCompiler as CC

julia> I = CC.create_interpreter(["-I", normpath(joinpath(Sys.BINDIR, "..", "include", "julia"))])
ClangCompiler.CxxInterpreter(ClangCompiler.Interpreter(Ptr{Nothing}(0x000000012ce70500)))

julia> CC.compile(I, 
       """
       #include <julia.h>
       #include <iostream>
       #include <vector>
       extern "C" void copy_from_julia_array(jl_array_t* julia_array) {
           size_t len = jl_array_len(julia_array);
           double* data = jl_array_data(julia_array, double);

           for (size_t i = 0; i < len; ++i) {
               data[i] *= 2.0;
           }

           std::vector<double> cpp_vec(data, data + len);
           for (double val : cpp_vec) {
               std::cout << val << " ";
           }
           std::cout << std::endl;
       }
       """)

julia> p = CC.get_function_pointer(I, "copy_from_julia_array")
Ptr{Nothing}(0x0000000123ffc000)

julia> v = [1.0, 2.0, 3.0, 4.0, 5.0]
5-element Vector{Float64}:
 1.0
 2.0
 3.0
 4.0
 5.0

julia> @ccall $p(v::Any)::Cvoid
2 4 6 8 10 

julia> v
5-element Vector{Float64}:
  2.0
  4.0
  6.0
  8.0
 10.0

julia> CC.dispose(I)
```