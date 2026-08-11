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

Look a C++ declaration up by its qualified name:

```julia-repl
import ClangCompiler as CC

# Create an interpreter
I = CC.create_interpreter(["-include", "vector"])

# Run a real C++ name lookup. The result is resolved to the class clang built
# for it -- here a `ClassTemplateDecl` -- so `isa` tests on it mean what they say.
decl = CC.find_decl(I, "std::vector")
CC.dump(decl)

# Clean up resources
CC.dispose(I)
```

`find_decl` returns `nothing` when the name is not found, and `find_decls` returns the whole
overload set. `CC.DeclFinder` is still there if you want to drive the lookup yourself.

### AST Traversal

The following example demonstrates how to perform AST traversal:

```julia-repl
import ClangCompiler as CC

# Create an interpreter
I = CC.create_interpreter(["-include", "vector"])

# `std::vector` is a template; step from the template to the class it describes
record = CC.getTemplatedDecl(CC.find_decl(I, "std::vector"))

# AST Traversal -- 119 members, each resolved to its own concrete type
for x in CC.DeclIterator(record)
    CC.dump(x)
end

# Clean up resources
CC.dispose(I)
```

### Execution

The following example demonstrates how to compile and invoke function:

```
julia> import ClangCompiler as CC

julia> I = CC.create_interpreter(["-I", normpath(joinpath(Sys.BINDIR, "..", "include", "julia"))])
ClangCompiler.CxxInterpreter(ClangCompiler.Interpreter(Ptr{ClangCompiler.LibClangEx.CXInterpreterImpl}(0x000000012ce70500)))

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

### Batch Compilation

`create_interpreter` compiles increment by increment and hands each one straight to its own
JIT. `create_compiler` compiles a whole translation unit in one go, which puts the entire
module in your hands before anything runs it:

```julia-repl
julia> import ClangCompiler as CC

julia> cc = CC.create_compiler("""
           extern "C" int fib(int n) { return n < 2 ? n : fib(n - 1) + fib(n - 2); }
       """; args=["-O2"])

julia> mod = CC.take_module(cc)   # the whole unit as one LLVM module: inspect it, transform it

julia> CC.compile(cc, mod)        # ... and hand it back

julia> p = CC.get_function_pointer(cc, "fib")
Ptr{Nothing}(0x000000010f5b4000)

julia> @ccall $p(20::Cint)::Cint
6765

julia> CC.dispose(cc)
```

`CC.create_irgenerator` is the same frontend without the JIT, for when the IR itself is the
product. Neither leaves an AST behind — the frontend has finished by the time the call
returns — so use `create_interpreter` or `create_parser` for anything that traverses one.

## More

[`examples/`](examples/) has seven worked programs that run — a JIT'd C++ function called from
Julia, an AST tour, record layout, template instantiation, cross-target ABI inspection, the
type-safety guarantees the handle layer provides, and JIT'd C++ calling back into the hosting
Julia session. They are executed by CI, so they cannot drift away from the API:

```
julia --project examples/runall.jl
```
