"""
    struct CxxInterpreter <: AbstractCxxInterpreter
"""
struct CxxInterpreter <: AbstractCxxInterpreter
    interp::Interpreter
end

CxxInterpreter(x::CXInterpreter) = CxxInterpreter(Interpreter(x))

"""
    create_interpreter(args=String[]; is_cxx=true, version=JLLEnvs.GCC_MIN_VER, triple=nothing)
        -> CxxInterpreter
Create a C/C++ interpreter.

# Arguments
- `args::Vector{String}`: Additional compiler flags.
- `is_cxx::Bool`: Whether to use the C++ compiler build environment.
- `version::String`: The compiler version.

`is_cxx` selects the **build environment** — which shard's system includes are on the search
path, and whether the C++ ones are excluded — and not the language. Clang's
`IncrementalCompilerBuilder` offers only `CreateCpp`, which puts `-xc++` ahead of these
arguments, so the interpreter parses C++ either way: `getCPlusPlus(getLangOpts(ci))` is
`true` under `is_cxx=false`, and a `-std=c11` is rejected outright as not allowed with C++.

A trailing `-x c` does override that and gives a C-language interpreter, but not a usable
one, and the reason is deeper than the flags. Clang's `Interpreter` starts a new
`TranslationUnitDecl` for every increment; C++ name lookup crosses the chain it makes and
C's does not, so in C mode an increment sees nothing declared before it — not even
`__builtin_va_list`, which is why `<stdarg.h>` and `<stdint.h>` cannot be included.
Objective-C fails identically, and upstream's own `clang-repl --Xcc -xc` reproduces all of
it, so no flag on this side fixes it.

For parsing rather than executing, use [`create_parser`](@ref): it drives the same clang
`Parser` over ONE translation unit it never replaces, which is the whole difference, and
works in C, C++, Objective-C and Objective-C++.
"""
function create_interpreter(args=String[]; is_cxx=true, version=JLLEnvs.GCC_MIN_VER, triple=nothing)
    LLVM.InitializeAllTargetInfos()
    LLVM.InitializeAllTargets()
    LLVM.InitializeAllTargetMCs()
    LLVM.InitializeAllAsmPrinters()
    default_args = get_default_args(; is_cxx, version, triple)
    builder = IncrementalCompilerBuilder()
    SetCompilerArgs(builder, [default_args..., args...])
    ci = CreateCpp(builder)
    @check_ptrs ci
    I = Interpreter(ci)
    dispose(builder)
    return CxxInterpreter(I)
end

"""
    dispose(x::CxxInterpreter)
Release the interpreter and everything it owns — the `CompilerInstance`, the AST, and the JIT
with any code compiled into it. Every pointer obtained from it, including function pointers
from [`get_function_pointer`](@ref) and any decl carrier, dangles afterwards.
"""
dispose(x::CxxInterpreter) = dispose(x.interp)

"""
    get_instance(x::CxxInterpreter) -> CompilerInstance
The `clang::CompilerInstance` driving `x`. Borrowed: it dies with the interpreter, never
`dispose` it. The returned type is not part of the public promise — this is the escape hatch
into the unpromised wrapper layer, not a stable signature.
"""
get_instance(x::CxxInterpreter) = getCompilerInstance(x.interp)
"""
    get_ast_context(x::CxxInterpreter) -> ASTContext
The `clang::ASTContext` holding everything `x` has parsed. Borrowed; same caveat about the
returned type as [`get_instance`](@ref).
"""
get_ast_context(x::CxxInterpreter) = getASTContext(get_instance(x))
"""
    get_codegen_module(x::CxxInterpreter) -> CodeGenModule

Return the `CodeGenModule` the interpreter is currently emitting into.

!!! warning "Valid for one increment only"
    The incremental interpreter starts a fresh module per increment, so this handle belongs
    to the increment that is current *now* and is left dangling by the next
    [`parse`](@ref). Using a stale one does not fail cleanly: the CodeGenTypes it reaches
    is freed memory, and the first lookup into its interned `CGFunctionInfo` set walks it
    and segfaults.

    Take it after the code you care about has been parsed, and take it again after every
    later parse rather than holding on to one:

    ```julia
    parse(I, "int f(int a) { return a; }")
    cgm = get_codegen_module(I)            # belongs to this increment
    fi  = arrangeFreeFunctionType(cgm, getType(fd))
    ```

    The handle is non-NULL even when stale, so `is_null_handle` does not detect this.
"""
get_codegen_module(x::CxxInterpreter) = CGM(getCodeGen(x.interp))
"""
    get_parser(x::CxxInterpreter) -> Parser
The `clang::Parser` behind `x`. Borrowed; same caveat as [`get_instance`](@ref), and one more:
reaching it goes through clang's private `Interpreter::IncrParser` / `IncrementalParser::P`
via an access-edited copy of the LLVM 20 headers. `getCodeGen` is a private method on
`Interpreter` itself in this version, hacked public the same way.
"""
get_parser(x::CxxInterpreter) = getParser(x.interp)
"""
    get_sema(x::CxxInterpreter) -> Sema
Clang's semantic analyser for `x`. Borrowed; reached through [`get_parser`](@ref) and carrying
the same caveats.
"""
get_sema(x::CxxInterpreter) = getSema(get_parser(x))
get_execution_engine(x::CxxInterpreter) = getExecutionEngine(x.interp)
get_symbol_address(x::CxxInterpreter, name::AbstractString) = getSymbolAddress(x.interp, name)
function get_symbol_address_from_linker_name(x::CxxInterpreter, name::AbstractString)
    getSymbolAddressFromLinkerName(x.interp, name)
end
"""
    get_function_pointer(x::CxxInterpreter, name::AbstractString) -> Ptr{Cvoid}
A pointer to the compiled function `name`, ready to `ccall`.

**Returns `C_NULL` for a name the JIT does not have**, where [`CxxCompiler`](@ref)'s method of
this name raises `LLVM.LLVMException` instead. The two drivers reach different JIT APIs, so a
caller writing one error path for both must test the pointer *and* catch.

`name` is the linker name: `extern "C"` functions as written, everything else as clang mangled
it — see [`mangled_name`](@ref).
"""
get_function_pointer(x::CxxInterpreter, name::AbstractString) = Ptr{Cvoid}(get_symbol_address(x, name))

"""
    parse(x::CxxInterpreter, code::String) -> PartialTranslationUnit
Parse `code` as one more increment of the translation unit.

**The returned unit is the success signal, and the diagnostic counters are not.** A failed
parse hands back a unit wrapping `C_NULL` — test it with `is_null_handle` — while
`getNumErrors` and `hasErrorOccurred` on the interpreter's `DiagnosticsEngine` both report
*no error*. That is clang's own doing rather than a lost signal here: its incremental parser
soft-resets the engine and clears its consumer's counts before reporting the failure, so a
caller reading the counters after a failed increment sees the state of a clean engine.

The message text survives that reset if a [`TextDiagnosticBuffer`](@ref) is the engine's
consumer, because `clear()` zeroes the counts without emptying the buffer:

```julia
buf = TextDiagnosticBuffer()
setClient(getDiagnostics(get_instance(I)), buf, false)
ptu = parse(I, code)
if is_null_handle(ptu)
    n = size(buf, CXTextDiagnosticBuffer_Error)
    msgs = [getMessage(buf, CXTextDiagnosticBuffer_Error, i) for i in 0:(n - 1)]
end
```

A null unit means clang refused the increment, not that nothing changed. The declarations
the increment created stay in the AST and stay findable, and can report `isInvalidDecl` as
`false` even though the increment as a whole failed — clang only unlinks the failed unit
from the lookup map. So neither the counters nor per-declaration validity substitutes for
the unit: what the unit says is that this increment will not be code-generated or executed.
"""
function parse(x::CxxInterpreter, code::String)
    ptu = Parse(x.interp, code)
    # Drop the cached parent map. `ASTContext` builds it lazily on the first parent query
    # and then keeps it, and clang never invalidates it here because a translation unit does
    # not normally grow after it is built -- an incremental interpreter is exactly the case
    # that breaks that assumption. Left alone, every node this increment added has no entry,
    # so `getNumParents` answers 0 for it and every matcher that consults parents
    # (`hasAncestor`, `hasParent`, and so `ExprMutationAnalyzer` and its static
    # `isUnevaluated`) silently reports nothing rather than failing.
    #
    # The map rebuilds lazily on the next query, so the cost is only paid by callers that
    # ask for parents, and it is paid once per increment rather than once per interpreter.
    clear(getParentMapContext(getASTContext(get_instance(x))))
    return ptu
end
execute(x::CxxInterpreter, tu::PartialTranslationUnit) = Execute(x.interp, tu)
"""
    compile(x::CxxInterpreter, code::String)
Parse `code` as one more increment and execute it: [`parse`](@ref) then `execute`.

This is the interpreter's `compile`, and it differs from [`CxxCompiler`](@ref)'s in what it
takes and what failure looks like. Here the argument is source and each call adds an increment;
there the argument is a module that was already compiled, and the call adds it to a JIT. A
snippet that fails to parse is not an error here — `parse` hands back a null unit and this
executes nothing — so check the unit rather than expecting a throw.
"""
compile(x::CxxInterpreter, code::String) = execute(x, parse(x, code))

parse_cxx_scope_spec(x::CxxInterpreter, ss::CXXScopeSpec, code::String) = parse_cxx_scope_spec(x.interp, ss, code)
