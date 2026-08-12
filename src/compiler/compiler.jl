"""
    struct CxxCompiler <: AbstractCxxCompiler
[`IRGenerator`](@ref) + `LLVM.LLJIT`: a whole translation unit compiled ahead of time and run
in this process. Build one with [`create_compiler`](@ref).

This is the batch counterpart to [`CxxInterpreter`](@ref), and the difference is where the
module comes from rather than how it runs. Clang's incremental interpreter emits one module
per increment and hands each straight to its own JIT; here the frontend runs once, the whole
unit arrives as a single `LLVM.Module`, and nothing reaches the JIT until [`compile`](@ref)
puts it there. That gap is the point: [`take_module`](@ref) is where an optimisation pipeline,
an inspection or a hand-written function goes, and `compile(cc, mod)` takes the module back.

Release it with `dispose`, and do so in reverse creation order — see [`IRGenerator`](@ref) for
why.
"""
struct CxxCompiler <: AbstractCxxCompiler
    irgen::IRGenerator
    jit::LLVM.LLJIT
end

"""
    create_compiler(code::AbstractString; link_process=true, kwargs...) -> CxxCompiler
Compile `code` to LLVM IR and pair it with an `LLJIT` that can run it. Every other keyword is
[`create_irgenerator`](@ref)'s, and `code` is compiled exactly as it is there.

`link_process=true` (the default) is [`link_process_symbols`](@ref) called for you: it makes
the host process's symbols findable *by name* through the JIT, so `get_symbol_address(cc,
"malloc")` answers and so does a lookup of anything else already loaded here, Julia's own C API
included. `false` leaves them out of the main dylib — but not out of reach of the compiled
code, which resolves against the host regardless; see [`link_process_symbols`](@ref) for what
that distinction costs.

The module is **not** in the JIT yet: [`compile`](@ref) puts it there, and only then does
[`get_function_pointer`](@ref) resolve anything. Compiling for a foreign `triple` produces a
module this JIT cannot run — it emits for the host — so leave `triple` alone here.

Release it with `dispose`.
"""
function create_compiler(code::AbstractString; link_process::Bool=true, kwargs...)
    irgen = create_irgenerator(code; kwargs...)
    jit = nothing
    try
        jit = LLVM.LLJIT()
        cc = CxxCompiler(irgen, jit)
        link_process && link_process_symbols(cc)
        return cc
    catch
        # Building the JIT stack and linking the process's symbols both go through LLVM's
        # error-returning C API, so both can throw. Releasing here is what keeps the
        # generator's `ThreadSafeContext` off LLVM.jl's task-local stack, which only `dispose`
        # pops.
        jit === nothing || LLVM.dispose(jit)
        dispose(irgen)
        rethrow()
    end
end

get_instance(x::CxxCompiler) = get_instance(x.irgen)
get_llvm_context(x::CxxCompiler) = get_llvm_context(x.irgen)
take_module(x::CxxCompiler) = take_module(x.irgen)
has_module(x::CxxCompiler) = has_module(x.irgen)

"""
    get_jit(x::CxxCompiler) -> LLVM.LLJIT
The JIT stack the compiled module runs on. Borrowed: it is disposed with the compiler.
"""
get_jit(x::CxxCompiler) = x.jit

"""
    get_irgenerator(x::CxxCompiler) -> IRGenerator
The generator that produced the module. Borrowed: it is disposed with the compiler.
"""
get_irgenerator(x::CxxCompiler) = x.irgen

"""
    get_dylib(x::CxxCompiler) -> LLVM.JITDylib
The JIT's main dylib — where [`compile`](@ref) puts the module and where
[`link_process_symbols`](@ref) puts the process's symbols. Borrowed: it belongs to the JIT.
"""
get_dylib(x::CxxCompiler) = LLVM.JITDylib(x.jit)

"""
    link_process_symbols(x::CxxCompiler) -> CxxCompiler
Let the JIT *resolve* symbols already loaded in this process, by adding a search generator over
the host process to the main dylib. [`create_compiler`](@ref) calls this unless told not to.

What this adds is narrower than it sounds, and worth knowing before reading `link_process=false`
as isolation. `LLJIT` already puts a process-symbols dylib in the main dylib's **link order**,
so the externals of a module resolve against the host either way: the allocator behind `new`,
the unwinder's `__gxx_personality_v0`, `__cxa_throw` and the parts of the standard library that
are not header-only all find their definitions, and a snippet that allocates a `std::vector`
runs under `link_process=false` too.

What that link order does not cover is a **direct lookup**, because `LLJIT::lookup` searches
the main dylib alone — and a direct lookup is what
[`get_symbol_address`](@ref)/[`get_function_pointer`](@ref) do. So this is the difference:
without it `get_symbol_address(x, "malloc")` raises `LLVM.LLVMException`, and with it the
address comes back.
"""
function link_process_symbols(x::CxxCompiler)
    jit = get_jit(x)
    dg = LLVM.CreateDynamicLibrarySearchGeneratorForProcess(LLVM.get_prefix(jit))
    LLVM.add!(get_dylib(x), dg)
    return x
end

"""
    compile(x::CxxCompiler) -> CxxCompiler
    compile(x::CxxCompiler, mod::LLVM.Module) -> CxxCompiler
Add the module to the JIT, after which [`get_function_pointer`](@ref) can resolve its
functions.

The one-argument form takes the generator's own module, and so can only be called once —
`compile(x, mod)` is the form to use after [`take_module`](@ref) has already handed it over,
and the one that accepts a module that has been transformed or built by hand. Either way the
module is consumed: ownership passes to the JIT.

Nothing is emitted here. ORC materialises a symbol when it is first looked up, so an
unresolved reference surfaces at [`get_function_pointer`](@ref) rather than at this call.
"""
compile(x::CxxCompiler) = compile(x, take_module(x))

function compile(x::CxxCompiler, mod::LLVM.Module)
    # `ThreadSafeModule` reads the *active* thread-safe context, and creating any other
    # generator or compiler afterwards would have pushed its own on top of ours. Activating
    # for the length of the call is what keeps the module in the context it was emitted in;
    # under the wrong one LLVM.jl silently round-trips it through bitcode instead.
    ts_mod = LLVM.ts_context!(get_llvm_context(x)) do
        LLVM.ThreadSafeModule(mod)
    end
    LLVM.add!(get_jit(x), get_dylib(x), ts_mod)
    return x
end

"""
    get_symbol_address(x::CxxCompiler, name::AbstractString) -> UInt64
The address `name` resolves to, materialising it if this is its first lookup.

`name` is the *linker* name and not the source one: an `extern "C"` function goes in as
written, and anything else under the name clang mangled it to, which for a C++ symbol means
reading it off the module [`take_module`](@ref) hands back — the AST that
[`mangled_name`](@ref) works from is gone by the time this compiler exists.

Raises `LLVM.LLVMException` when nothing defines `name`, which is also where a definition
missing from the module surfaces: ORC materialises lazily, so [`compile`](@ref) accepts a
module with unresolved references and this is the call that fails on one.
"""
function get_symbol_address(x::CxxCompiler, name::AbstractString)
    return LLVM.lookup(get_jit(x), name).ptr
end

"""
    get_function_pointer(x::CxxCompiler, name::AbstractString) -> Ptr{Cvoid}
A pointer to the compiled function `name`, ready to `ccall`. See
[`get_symbol_address`](@ref) for how `name` is spelled and how a lookup fails.
"""
function get_function_pointer(x::CxxCompiler, name::AbstractString)
    return Ptr{Cvoid}(pointer(LLVM.lookup(get_jit(x), name)))
end

function dispose(x::CxxCompiler)
    LLVM.dispose(x.jit)      # before the context the modules it holds were emitted in
    return dispose(x.irgen)
end
