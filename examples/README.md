# Examples

Seven worked programs, in order. Each runs on its own and prints what it found:

```bash
julia --project examples/01_hello_cxx.jl
```

All seven at once — this is what CI runs, and it fails if any of them does:

```bash
julia --project examples/runall.jl
```

They are executable rather than illustrative. Every number printed is one clang computed, and
where a claim can be checked the script checks it and errors on a mismatch, so a passing run is
evidence and not decoration. The C++ is embedded in each file; nothing reads a `.cpp` from disk.

## The tour

**[01_hello_cxx.jl](01_hello_cxx.jl)** — the front door. Compile a C++ function into this
process and `ccall` it: no shared library, no build step, no file on disk. Computes a statistic
in C++, checks it against `Statistics`, returns a struct by value and confirms clang's field
offsets match Julia's. Ends with the thing an *incremental* compiler gives you that a batch one
cannot — a second snippet parsed into the same open translation unit, calling the first.

**[02_ast_tour.jl](02_ast_tour.jl)** — navigating what clang built. Clang hands back the
semantic tree, not a parse tree: names resolved, overloads picked, implicit conversions already
real nodes. Ten steps from the translation unit down to individual expressions — `resolve`,
`decls_in`, `find_decl`, `children` versus `subtree` — ending in a node histogram, a list of
every call site, and clang's own `dump_ast` of nodes you just walked by hand.

**[03_type_safety.jl](03_type_safety.jl)** — why any of this is safe, and the most important
file here. The C shim is check-free by contract: it takes a pointer and asserts what it is. The
example quotes the shim verbatim, then walks six sections — dispatch rejecting a method that
belongs to another class, a carrier refusing a foreign handle, an integer refusing to be a
pointer, the two crossings that *are* legal (`downcast` and `upcast`) with the argument for why
each is sound, and `DeclContext`, the one base that is not at offset zero.

Two things it does rather than asserts. It forces the wrong call — `clang_WhileStmt_getCond` on
an `IfStmt` — and reports that it returns the *correct* condition for an `if` with no
init-statement, and the `DeclStmt` for one that has it: a mistake that agrees with the truth on
the input you happened to test. And it *measures* the `DeclContext` offset rather than quoting
one, subtracting live addresses to show that the same cast moves the pointer by a different
amount for a `NamespaceDecl` than for a `CXXRecordDecl` — which is why that base can never be
reached by reusing a pointer. The numbers come from how libclang-cpp itself was compiled, so the
example prints what it measured instead of naming a constant that could differ on another build.

**[04_record_layout.jl](04_record_layout.jl)** — "what does this C++ type look like in memory?"
Field offsets, sizes, alignment and the padding between members, printed as a table, plus base
subobjects under inheritance. Cross-checked against Julia's own `fieldoffset`.

**[05_templates.jl](05_templates.jl)** — instantiating C++ generic code with arguments chosen in
a Julia loop. Keeps the two steps apart: `specialize` registers that `Buffer<double, 4>` exists,
and Sema's substitution is what turns that declaration into a definition with fields and a size.
The sizes it reports are re-derived a second way, by JIT-compiling `sizeof`, as an independent
check.

**[06_cross_target.jl](06_cross_target.jl)** — ABI answers about a machine you are not running
on. Pass a triple to `create_interpreter` and clang parses and lays out types as it would over
there. States its own limit up front: only parsing and AST inspection cross-target, because the
JIT still emits for the host. First run downloads that target's GCC shard.

**[07_julia_embedding.jl](07_julia_embedding.jl)** — the return trip. 01 had Julia call C++; here
the C++ includes `<julia.h>` and calls back into the session that is compiling it: mutating a
Julia array in place, invoking a Julia function defined a few lines above it, running
`jl_eval_string`, and naming the Julia exceptions it catches. Not ordinary embedding — Julia is
already running — the example asks `jl_is_initialized()` from inside the JIT'd code rather than
take that on trust — and the two languages share one heap and one collector.

Which is why its longest section is GC rooting, and why that section runs the experiment *twice*:
once holding the root and once dropping it, with a weak reference reporting whether the collector
took the box. The second row is what makes the first one evidence. A rooting demo that only shows
the rooted case passes whether or not the root does anything, since a non-moving collector leaves
freed bytes readable.

## Reading order

01 and 02 are the ones to read first. 03 is the argument for the design and pays off anywhere you
plan to hold clang handles yourself. 04, 05, 06 and 07 are independent and can be read in any order; 07 pairs naturally with 01, since it is the same bridge in the other direction.

## Finding the API for something the tour does not cover

These seven touch a small part of the surface: 8,980 C entry points behind 6,531 Julia wrapper
functions across 78 files. Two things make that navigable.

**The file tree mirrors Clang's.** A method declared in `clang/AST/Decl.h` is wrapped in
`src/clang/api/AST/Decl.jl`. So if you know where clang declares it, you know where to look.

**The names are Clang's.** A wrapper drops the `clang_` prefix and the class name and keeps the
rest verbatim, camelCase included — `clang_CXXRecordDecl_isAbstract` is `isAbstract`. Grepping
the C++ method name usually lands on it directly:

```bash
grep -rn "function isAbstract(" src/clang/api/
```

Dispatch tells you what a wrapper accepts, and the receiver is typed at the class that
*declares* the method — so `methods(ClangCompiler.getCond)` is a precise answer to "which node
kinds have a condition?", not an approximation.

When you want a worked recipe rather than a signature, `test/` is the better source than these
examples: it is larger, and every line in it is checked. `test/acceptance.jl` in particular is a
set of small static-analysis tools built end to end on this API.

## If an example stops working

That has happened before, undetected, for years: these scripts referenced an API generation that
had been removed, and every one of them failed at load because nothing ever ran them. The
`Examples run` CI job exists so that cannot recur. If you change a public API and that job goes
red, the example is the thing telling you the change reached users.
