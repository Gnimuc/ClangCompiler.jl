"""
    const SOURCE_NAMES

The default main-file name [`create_irgenerator`](@ref) gives each of
[`SOURCE_LANGUAGES`](@ref). The file is virtual — the snippet is mapped in over it and nothing
is read from disk — so the name is not where the language comes from, which is an explicit
`-x`. It decides how diagnostics print, what `__FILE__` expands to, and what the emitted
`LLVM.Module` is called: clang names the module after its main input file, so the name is
observable on the module `take_module` hands back.
"""
const SOURCE_NAMES = (c="input.c", cxx="input.cc", objc="input.m", objcxx="input.mm")

"""
    struct IRGenerator <: AbstractIRGenerator
A whole translation unit compiled to LLVM IR in one go, via clang's `EmitLLVMOnlyAction`.
Build one with [`create_irgenerator`](@ref) and take its module with [`take_module`](@ref).

This is the batch counterpart to [`CxxInterpreter`](@ref): the frontend runs to completion
inside the constructor and there is no second increment, which is what makes the whole module
available as one `LLVM.Module` rather than one module per increment. It stops at the IR —
[`CxxCompiler`](@ref) is this plus an `LLJIT`, for running the result.

**The AST does not survive the constructor.** `FrontendAction::EndSourceFile` drops the
instance's `Sema`, `ASTContext` and `ASTConsumer` as the action finishes, so
`hasASTContext(get_instance(x))` is `false` here and there is nothing to traverse. Use
[`CxxInterpreter`](@ref), [`IncrementalParser`](@ref) or [`buildASTFromCodeWithArgs`](@ref)
for AST work — the preprocessor, source manager and target do survive, and are what the
`SourceLocation`s in a captured diagnostic still resolve against.

Release it with `dispose`, and do so in reverse creation order: the `LLVM.ThreadSafeContext`
each generator owns is pushed onto LLVM.jl's task-local context stack when it is created and
popped when it is disposed, and popping one that is not the top is an error.
"""
struct IRGenerator <: AbstractIRGenerator
    ts_ctx::LLVM.ThreadSafeContext
    instance::CompilerInstance
    act::LLVMOnlyAction
    buffer::LLVM.MemoryBuffer
    filename::String
    language::Symbol
    taken::Base.RefValue{Bool}
end

# interface
get_instance(x::IRGenerator) = x.instance
"""
    get_llvm_context(x::IRGenerator) -> LLVM.ThreadSafeContext
The `LLVM.ThreadSafeContext` the compiled module lives in. Borrowed: it is disposed with the
generator, and the module may not outlive it.

Named apart from [`get_ast_context`](@ref) deliberately. Both are "the context", and they are
different objects from different libraries — one is clang's `ASTContext`, this is LLVM's — so a
single `get_context` beside `get_ast_context` invited exactly the confusion that ends in a
module outliving the context it was emitted in.
"""
get_llvm_context(x::IRGenerator) = x.ts_ctx

"""
    create_irgenerator(code::AbstractString; args=String[], language=:cxx,
                       filename=SOURCE_NAMES[language], version=JLLEnvs.GCC_MIN_VER,
                       triple=nothing, diag_consumer=nothing, show_colors=false)
        -> IRGenerator
Compile `code` to LLVM IR and return the generator holding the result.

`code` is compiled as `language`, one of `$(join(keys(SOURCE_LANGUAGES), ", "))`, and the
build environment follows it — the C shards for `:c`/`:objc`, the C++ ones otherwise — so the
language and the include set cannot disagree. `args` are extra compiler flags, and they are
driver flags rather than `-cc1` ones: `-O2`, `-std=c++20`, `-g`, `-I`, `-D`, `-Werror` all
mean here what they mean on a `clang` command line. The one argument that cannot be given is
`-x`, which comes from `language` and is appended after `args`.

The snippet is mapped in over `filename` as an in-memory buffer, so nothing is read from disk
and `filename` need not exist. Compiling a real file is therefore the same call with the
contents read in, which also makes its diagnostics point at the real path:

```julia
gen = create_irgenerator(read(path, String); filename=path)
```

`:objc` and `:objcxx` take their Objective-C runtime from the target, and only Darwin's is the
non-fragile ABI — elsewhere the fragile GNU runtime applies, where a class extension may not
declare instance variables and `@interface C () { int x; } @end` is a hard error. So the same
source compiles or does not depending on the machine; `-fobjc-runtime=macosx` in `args` pins it
and takes the host out of it. Plain C or C++ constructs emit no runtime metadata and are
unaffected.

`triple` cross-compiles: the target, its system headers and its ABI all come from that
platform's shard rather than from the machine asking, and the module carries that triple and
data layout. A module built for a platform other than this one can be written out or inspected
but not run — [`CxxCompiler`](@ref) JITs for the host — so leave `triple` alone for anything
that has to execute.

Diagnostics go to stderr unless `diag_consumer` is given, which receives them instead — both
the driver's, while it reads `args`, and the compile's. It is borrowed and must outlive the
generator, and it is **cleared on the way in**: clang's consumers count their own warnings and
errors and never reset, and `ExecuteAction` reads that count rather than the engine's, so a
consumer carrying an earlier call's errors would fail a snippet that compiled. Clearing zeroes
the counts without emptying a recording consumer, so nothing already collected is lost. One
line escapes the consumer — `CompilerInstance::ExecuteAction` writes its own
`N error(s) generated.` summary to the instance's verbose stream, which is `llvm::errs()`
unless something replaced it, and it does that whenever `DiagnosticOptions::ShowCarets` is set,
as it is by default.

Errors are fatal to the call: arguments clang rejects raise `ArgumentError` and a snippet that
does not compile raises `ErrorException`, in both cases after everything this function
allocated has been released, so a caller may retry in a loop without accumulating anything.
Pass a [`TextDiagnosticBuffer`](@ref) as `diag_consumer` and the messages *this call* added are
quoted in that error rather than only counted.

Release it with `dispose`.
"""
function create_irgenerator(code::AbstractString; args=String[], language::Symbol=:cxx,
                            filename::AbstractString=SOURCE_NAMES[check_language(language)],
                            version=JLLEnvs.GCC_MIN_VER, triple=nothing,
                            diag_consumer::Union{Nothing,AbstractDiagnosticConsumer}=nothing, show_colors::Bool=false)
    check_language(language)
    # Codegen asks the target registry for the target machine the module is emitted against,
    # so an uninitialised registry fails inside the backend rather than here.
    LLVM.InitializeNativeTarget()
    LLVM.InitializeAllTargetInfos()
    LLVM.InitializeAllTargetMCs()
    LLVM.InitializeNativeAsmPrinter()
    default_args = get_default_args(; is_cxx=is_cxx_language(language), version, triple)
    name = String(filename)

    ci = CompilerInstance()
    ts_ctx = nothing
    buffer = nothing
    act = nothing
    # A snippet that does not compile is an expected outcome rather than an exceptional one,
    # and it is reported after the `try` instead of from inside it. The difference is real:
    # LLVM.jl leaks a context disposed while an exception is in flight rather than freeing it,
    # so raising first and releasing second would leak an `LLVMContext` per rejected snippet.
    compiled = false
    failure = ""
    try
        setShowColors(ci, show_colors)
        createDiagnostics(ci)
        # A consumer arrives having been used before, and clang's are latches: a
        # `DiagnosticConsumer` counts its own warnings and errors and only `clear` zeroes
        # them. That matters here beyond tidiness, because `CompilerInstance::ExecuteAction`
        # reports success from the CLIENT's error count rather than the engine's -- so a count
        # left by an earlier call would condemn a snippet that compiled. Clearing is what makes
        # every answer below this call's own; a recording consumer keeps its messages, since
        # `clear` zeroes the counts without emptying it.
        diag_consumer === nothing || clear(diag_consumer)
        _install_consumer!(ci, diag_consumer)
        mark = _diagnostic_mark(diag_consumer)
        diag = getDiagnostics(ci)
        all_args = [default_args..., args..., "-x", SOURCE_LANGUAGES[language]]
        # A driver-only flag -- `-###`, `--version`, `-help` -- makes clang print and build no
        # compilation job at all, and `createFromCommandLine` has nothing to hand back. That is
        # a rejected argument list like any other from a caller's point of view, so it is
        # reported as one rather than as the assertion the wrapper raises.
        invocation = try
            createFromCommandLine(name, all_args, diag)
        catch e
            e isa AssertionError || rethrow()
            throw(ArgumentError("clang built no compilation job from these arguments — a \
                                 driver-only flag such as `-###`, `--version` or `-help` makes \
                                 it print instead of compile"))
        end
        setInvocation(ci, invocation)
        # The driver reported a rejected argument into `diag`, and `diag` is about to be
        # replaced -- so this is the only moment such an error is observable at all. Unchecked
        # it disappears and the caller gets a generator built from a partially-parsed
        # invocation. clang's own cc1_main abandons the compilation here for the same reason.
        nerr = getNumErrors(diag)
        if nerr > 0
            throw(ArgumentError("clang rejected the compiler arguments ($nerr error(s))" *
                                _diagnostic_detail(diag_consumer, mark)))
        end
        # Twice, and both are needed. `createDiagnostics` builds the engine from the instance's
        # CURRENT DiagnosticOptions, and before `setInvocation` those are the defaults -- so the
        # first engine exists only to give the driver above somewhere to report a bad command
        # line, and an engine kept from that point ignores every `-W`/`-Werror` in `args`.
        # Rebuilding here is what clang's own `cc1_main` does for the same reason. The first
        # engine is refcounted and released with its client; the caller's consumer is not owned
        # by either engine, so it survives the swap and has to be installed on the new one.
        createDiagnostics(ci)
        _install_consumer!(ci, diag_consumer)
        # The driver puts `-disable-free` on every cc1 line it builds, and the invocation
        # keeps it TWICE: `CompilerInvocation::CreateFromArgsImpl` seeds
        # `CodeGenOpts.DisableFree` from the frontend flag of the same name, after which the
        # two are independent fields. Each leaks something different, so both have to go.
        #
        # Under the frontend one, `FrontendAction::EndSourceFile` calls
        # `resetAndLeakSema`/`resetAndLeakASTContext`: both objects are unlinked from the
        # instance and never destroyed, so `dispose` has nothing left to reach them through.
        # Under the codegen one, `~EmitAssemblyHelper` buries the `llvm::TargetMachine`. Sound
        # for a compiler process about to exit, a leak inside a Julia session -- and the second
        # is not a rounding error beside the first. Over 40 compiles of one `#include <vector>`
        # snippet, RSS grows about 1 MB per compile with both flags set and still ~0.2-0.5 MB
        # with only the frontend one cleared; with both cleared it is flat or falling. Clearing
        # both is what clang's own long-lived embedders do (`Interpreter::create`, tooling's
        # `newInvocation`), and the module is unaffected either way:
        # `CodeGenAction::EndSourceFileAction` has already moved it out of the consumer before
        # either branch is reached.
        #
        # `-clear-ast-before-backend` rides the same cc1 line and is deliberately left alone.
        # It releases the AST arena before codegen, which is what a driver that never traverses
        # the AST wants, and running `~ASTContext` afterwards is safe by construction rather
        # than by luck: `~ASTContext` IS `cleanup()`, every container it walks is emptied as it
        # goes, and `ReleaseDeclContextMaps` nulls `LastSDM`, so the second pass finds nothing.
        setDisableFree(getFrontendOpts(ci), false)
        setDisableFree(getCodeGenOpts(ci), false)

        ts_ctx = LLVM.ThreadSafeContext()
        # `-Wnewline-eof` reports a source file whose last line has no terminator, and a
        # snippet written as a Julia string literal usually has none. Appending one costs
        # nothing and keeps that warning for source that really is missing it.
        text = endswith(code, '\n') ? String(code) : string(code, '\n')
        buffer = LLVM.MemoryBuffer(Vector{UInt8}(codeunits(text)), name, true)
        ppopts = getPreprocessorOpts(ci)
        # Retained, so the SourceManager takes a non-owning `MemoryBufferRef` and the buffer
        # stays this generator's to release. Left at clang's default the SourceManager adopts
        # it, and the `dispose` below would be the second free.
        setRetainRemappedFileBuffers(ppopts, true)
        # `InitializeFileRemapping` registers `name` through `FileManager::getVirtualFile`,
        # which creates the entry rather than looking it up -- so the name is free not to exist
        # on disk, and an existing file of that name is shadowed rather than read.
        addRemappedFile(ppopts, name, buffer)

        act = LLVMOnlyAction(LLVM.context(ts_ctx))
        compiled = ExecuteAction(ci, act)
        if !compiled
            n = getNumErrors(getDiagnostics(ci))
            failure = "clang failed to compile the source ($n error(s))" * _diagnostic_detail(diag_consumer, mark)
        end
    catch
        # Everything allocated so far, in reverse: whatever the throw was, the caller is left
        # holding nothing rather than a half-built generator it has no handle on. The
        # `ThreadSafeContext` in particular has to be released rather than dropped -- it was
        # pushed onto LLVM.jl's task-local stack when it was created, and only `dispose` pops
        # it. Disposing from here pops that stack but does not free the context, since LLVM.jl
        # leaks one while an exception is in flight; this path is for the unexpected throw, and
        # the one failure a caller can provoke is handled below instead.
        _release!(act, ci, buffer, ts_ctx)
        rethrow()
    end
    if !compiled
        _release!(act, ci, buffer, ts_ctx)
        error(failure)
    end
    return IRGenerator(ts_ctx, ci, act, buffer, name, language, Ref(false))
end

"""
Release a part-built generator, innermost first: the action (which frees the module with it),
then the instance, then the buffer its `SourceManager` points at, and last the context the
module lived in. Each argument may be `nothing`, for the stages a failure got to before it.
"""
function _release!(act, ci::CompilerInstance, buffer, ts_ctx)
    act === nothing || dispose(act)
    dispose(ci)
    buffer === nothing || LLVM.dispose(buffer)
    ts_ctx === nothing || LLVM.dispose(ts_ctx)
    return nothing
end

"""
Point the instance's *current* engine at `consumer`, borrowed — the engine must not free
something the caller owns and will dispose itself.
"""
_install_consumer!(::CompilerInstance, ::Nothing) = nothing
function _install_consumer!(ci::CompilerInstance, consumer::AbstractDiagnosticConsumer)
    setClient(getDiagnostics(ci), consumer, false)
    return nothing
end

"""
How many diagnostics a recording consumer already held, so the ones this call adds can be told
from the ones an earlier call left behind. `clear` zeroes a consumer's counts without emptying
it, which is what makes the index rather than the count the thing to remember.
"""
_diagnostic_mark(::Any) = 0
_diagnostic_mark(buf::AbstractTextDiagnosticBuffer) = Int(Base.size(buf, CXTextDiagnosticBuffer_Error))

"""
Quote the errors a recording consumer collected from `from` onward, so a failed compile whose
diagnostics went to a buffer rather than stderr still says what went wrong. Any other consumer
keeps its messages to itself, and the count in the caller's message is all there is.

Both methods pin the return to `String`. `join` is inferred as
`Union{AnnotatedString{String},String}` whenever the receiver here is abstract — which is the
only way `create_irgenerator` ever calls this, since its `diag_consumer` is a `Union` — and
that widening would otherwise reach the local the error message is built in.
"""
_diagnostic_detail(::Any, ::Integer)::String = ""
function _diagnostic_detail(buf::AbstractTextDiagnosticBuffer, from::Integer)::String
    n = Int(Base.size(buf, CXTextDiagnosticBuffer_Error))
    n > from || return ""
    return ":\n" * join(("  " * getMessage(buf, CXTextDiagnosticBuffer_Error, i) for i = from:(n - 1)), "\n")
end

"""
    take_module(x::IRGenerator) -> LLVM.Module
Take the module the generator compiled, transferring it to the caller.

**Once.** The module is moved out of the action, so a second call has nothing left to hand
over and raises; the caller that took it owns it and disposes it, either directly or by
handing it to something that does — [`compile`](@ref) gives it to an `LLJIT`, and
`LLVM.ThreadSafeModule` and `LLVM.dispose` are the two ways to consume it directly. Left
untaken it belongs to the generator and dies with it.

The module lives in the `LLVM.Context` behind [`get_llvm_context`](@ref) and may not
outlive it.
"""
function take_module(x::IRGenerator)
    x.taken[] && error("the module has already been taken")
    mod = takeModule(x.act)
    x.taken[] = true
    return mod
end

"""
    has_module(x::IRGenerator) -> Bool
Whether the compiled module is still the generator's, i.e. whether [`take_module`](@ref) would
return rather than raise. `dispose` clears it too, so a disposed generator answers `false`
rather than offering a module whose context is gone.
"""
has_module(x::IRGenerator) = !x.taken[]

function dispose(x::IRGenerator)
    # The context pop has to be *checked* first even though it happens last. LLVM.jl errors
    # when the context being disposed is not the top of its task-local stack, and raising that
    # after the three irreversible frees below would leave an object that can be neither used
    # nor disposed again, with its context wedged on the stack forever. Checking up front turns
    # an out-of-order dispose into a no-op that says so.
    top = LLVM.ts_context(; throw_error=false)
    top !== nothing && top.ref == x.ts_ctx.ref ||
        error("dispose out of order: this generator's LLVM context is not the innermost one \
               still open. Generators and compilers must be disposed in reverse creation order.")
    dispose(x.act)                 # frees the module too, unless `take_module` moved it out
    dispose(x.instance)            # before the buffer its SourceManager points at
    LLVM.dispose(x.buffer)
    LLVM.dispose(x.ts_ctx)         # last: an untaken module lives in this context
    # `has_module` answers from this flag, so leaving it false would have a disposed generator
    # claim to still hold a module and `take_module` hand back one whose context is gone.
    x.taken[] = true
    return nothing
end
