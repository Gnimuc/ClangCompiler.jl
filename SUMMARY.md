# ClangCompiler.jl — Project Summary

## Overview

**ClangCompiler.jl** is a Julia package that provides a high-level interface to the Clang C++ compiler infrastructure. It wraps the libclangex C API (from `libclangex_jll`) to expose Clang's internal compiler capabilities directly to Julia, enabling tasks such as:

- C/C++ declaration lookup and name resolution
- AST (Abstract Syntax Tree) traversal and introspection
- Incremental C++ parsing and compilation
- JIT execution of compiled C++ code from Julia
- Type system bridging between Julia and Clang/LLVM types

## Architecture

```
ClangCompiler.jl
├── lib/                     # Auto-generated C API bindings
│   ├── LibClang.jl          # Standard libclang bindings
│   └── 18/LibClangEx.jl     # libclangex bindings (1,655 functions)
├── src/
│   ├── ClangCompiler.jl     # Main module
│   ├── clang/               # Low-level Clang API wrappers
│   │   ├── core/            # Core type definitions and wrappers
│   │   ├── api/             # Julia API layer over C bindings
│   │   ├── ast.jl           # AST node types and iteration
│   │   ├── basic.jl         # Source locations, diagnostics
│   │   ├── codegen.jl       # Code generation module access
│   │   ├── frontend.jl      # Compiler instance/frontend
│   │   ├── lex.jl           # Lexer and token types
│   │   ├── parse.jl         # Parser interface
│   │   ├── qualtype.jl      # Qualified type operations
│   │   ├── sema.jl          # Semantic analysis
│   │   └── type.jl          # Type system wrappers
│   ├── compiler/
│   │   ├── compiler.jl      # AbstractClangCompiler base type
│   │   └── interpreter.jl   # CxxInterpreter implementation
│   ├── types.jl             # Julia<->Clang<->LLVM type mappings
│   ├── lookup.jl            # Declaration lookup (DeclFinder)
│   ├── parse.jl             # C++ scope specifier parsing
│   ├── env.jl               # Compiler flags and default args
│   └── platform/JLLEnvs.jl  # Platform-specific JLL environments
├── deps/ClangExtra/         # libclangex C header files (58 headers)
└── gen/generator.jl         # Auto-generator for C API bindings
```

## Key Components

### CxxInterpreter

The primary entry point. Wraps Clang's `IncrementalCompiler` to provide an incremental C++ interpreter:

```julia
import ClangCompiler as CC

I = CC.create_interpreter(["-include", "vector"])
CC.compile(I, "int square(int x) { return x * x; }")
p = CC.get_function_pointer(I, "square")
@ccall $p(5::Cint)::Cint  # => 25
CC.dispose(I)
```

**Public API:**
- `create_interpreter(args; is_cxx, version)` — create a C/C++ interpreter
- `dispose(interp)` — release resources
- `parse(interp, code)` — parse a code fragment into a `PartialTranslationUnit`
- `execute(interp, tu)` — JIT-compile and execute a parsed unit
- `compile(interp, code)` — parse + execute in one step
- `get_function_pointer(interp, name)` — get a pointer to a compiled symbol
- `get_instance(interp)` — access the underlying `CompilerInstance`
- `get_ast_context(interp)` — access the `ASTContext`
- `get_parser(interp)`, `get_sema(interp)` — access Parser/Sema

### DeclFinder

A functor for performing C++ declaration lookups by name:

```julia
decl_lookup = CC.DeclFinder(I)
@assert decl_lookup(I, "std::vector")
decl = CC.get_decl(decl_lookup)
CC.dump(decl)
CC.dispose(decl_lookup)
```

**Public API:**
- `DeclFinder(interp)` — create a lookup instance
- `reset(finder)` — clear lookup state
- `get_decl(finder)` — retrieve the unique lookup result
- `get_decls(finder)` — retrieve all lookup results

### AST Traversal

`DeclIterator` provides iteration over child declarations:

```julia
record = CC.getTemplatedDecl(CC.ClassTemplateDecl(decl.ptr))
for child in CC.DeclIterator(record)
    CC.dump(child)
end
```

### Type System Bridging

`jlty_to_clty` and `clty_to_jlty` map between Julia types and Clang's type system. `clty_to_llvmty_mem` converts Clang types to their LLVM memory representation for code generation.

**Supported Julia↔Clang type mappings:**

| Julia Type | Clang Type |
|---|---|
| `Nothing` | `void` |
| `Bool` | `bool` |
| `Int8/UInt8` | `signed char / unsigned char` |
| `Int16/UInt16` | `short / unsigned short` |
| `Int32/UInt32` | `int / unsigned int` |
| `Int64/UInt64` | `long long / unsigned long long` |
| `Int128/UInt128` | `__int128` |
| `Float16` | `_Float16` |
| `Float32` | `float` |
| `Float64` | `double` |
| `Ptr{Cvoid}` | `void*` |

## C API Coverage (libclangex)

The bindings in `lib/18/LibClangEx.jl` wrap **1,655 functions** across 58 header files organized into 9 subsystems:

| Subsystem | Headers | Key Functionality |
|---|---|---|
| **AST** | 15 | ASTContext, Decl types, Types, Expressions, Templates, Mangling |
| **Basic** | 19 | Diagnostics, Source locations, File manager, Target info, Lang options |
| **CodeGen** | 3 | Code generation types, Module builder, Actions |
| **Driver** | 1 | Compiler driver |
| **Frontend** | 4 | CompilerInstance, CompilerInvocation, Frontend options, Diagnostics |
| **Interpreter** | 2 | Incremental interpreter, runtime values |
| **Lex** | 4 | Lexer, Preprocessor, Tokens, Header search |
| **Parse** | 5 | Parser, DeclSpec, Lookup, Scope, Sema |
| **Sema** | — | Semantic analysis |

### Top Function Categories

| Prefix | Count | Description |
|---|---|---|
| `clang_ASTContext` | 232 | AST context queries |
| `clang_FunctionDecl` | 121 | Function declarations |
| `clang_Type` | 120 | Type system operations |
| `clang_VarDecl` | 74 | Variable declarations |
| `clang_isa` | 50 | RTTI type predicates |
| `clang_CompilerInstance` | 46 | Compiler instance management |
| `clang_Decl` | 44 | Base declaration operations |
| `clang_value` | 42 | Runtime value operations |
| `clang_RecordDecl` | 41 | Struct/class/union declarations |
| `clang_TagDecl` | 35 | Tag declarations |

## Dependencies

| Package | Role |
|---|---|
| `libclangex_jll` | Native libclangex shared library |
| `Clang_jll` | Native libclang shared library |
| `LLVM.jl` | LLVM IR types and JIT interop |
| `Preferences.jl` | User-configurable library path override |

## Examples

The `examples/` directory contains several runnable examples:

- **`decl-lookup/`** — Declaration lookup workflows
- **`clang-interpreter/`** — Incremental compilation and execution
- **`julia-embedding/`** — Embedding Julia arrays in C++ code
- **`LLJIT/`** — Direct LLVM JIT usage
- **`simple-compiler/`** — Minimal compilation example
- **`basic.jl`** — Basic API walkthrough
- **`template-helper/`** — C++ template introspection

## Binding Generation

Bindings are auto-generated from the C headers in `deps/ClangExtra/include/clang-ex/` using `gen/generator.jl`, which leverages `Clang.Generators` (part of the `Clang.jl` ecosystem). The generator produces the `lib/18/LibClangEx.jl` file with all `@ccall` declarations.
