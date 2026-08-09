"""
    const INCREMENTAL_LANGUAGES

The `language` values [`create_parser`](@ref) accepts, and the `-x` spelling each selects.
"""
const INCREMENTAL_LANGUAGES = (c = "c", cxx = "c++", objc = "objective-c", objcxx = "objective-c++")

"""
    struct IncrementalParser <: AbstractClangCompiler
An incremental parser: successive [`parse`](@ref) calls extend one translation unit, so a
declaration made in one call is visible to the next.

This exists because [`CxxInterpreter`](@ref) cannot do that in C or Objective-C. Clang's own
`Interpreter` starts a **new** `TranslationUnitDecl` for every increment and chains them by
previous-decl; C++ name lookup crosses that chain and C's does not, so in C mode each
increment sees nothing declared before it — not even `__builtin_va_list`, which is why
`<stdarg.h>` and `<stdint.h>` cannot be included there. Upstream's own `clang-repl` fails
the same way (`clang-repl --Xcc -xc`), so it is not something this package's flags cause.

This driver runs the same `Parser` loop over one translation unit that it never replaces,
which is the whole difference: C, C++, Objective-C and Objective-C++ all work.

It parses and does not execute — there is no JIT here. For running code, which clang's
Interpreter only supports in C++ anyway, use [`CxxInterpreter`](@ref).
"""
struct IncrementalParser <: AbstractClangCompiler
    instance::CompilerInstance
    parser::Parser
    language::Symbol
end

"""
    create_parser(args=String[]; language=:cxx, version=JLLEnvs.GCC_MIN_VER, triple=nothing)
        -> IncrementalParser
Create an incremental parser for `language`, one of `$(join(keys(INCREMENTAL_LANGUAGES), ", "))`.

`args` are extra compiler flags, and the build environment follows `language` — the C shards
for `:c`/`:objc`, the C++ ones otherwise — so unlike [`create_interpreter`](@ref) the
language and the include set cannot disagree. Diagnostic flags work too: `-Werror` promotes
this session's warnings and `-Wno-<group>` silences them, and so does `-include <header>`,
whose declarations are visible to the first increment like any other.

The one argument that cannot be given here is `-x`: the language comes from `language`, which is
appended after `args`, so an `-x` of your own is overridden rather than honoured.

`triple` cross-parses: the target, its system headers and its ABI all come from that
platform's shard rather than from the machine asking, so `long` reads as 32 bits under
`x86_64-w64-mingw32` and 64 under `x86_64-linux-gnu` whatever the host, and the
target-specific builtins follow too (`__builtin_ia32_*` for x86, `__builtin_neon_*` for
AArch64). This is the natural home for cross-parsing: `create_interpreter` accepts a triple
as well, but its JIT still emits for the host, so only its parsing half ever crossed —
nothing here executes, so there is no half that does not. Pinning downloads that target's
GCC shard on first use.

One flag is worth *passing* for `:objc`/`:objcxx`: `-fobjc-runtime=macosx`. Clang picks the
Objective-C runtime from the target, and only Darwin's is the non-fragile ABI — everywhere else
gets the fragile GNU runtime, where a class extension may not declare instance variables and
`@interface C () { int x; } @end` is a hard error. So the same source parses or does not
depending on the machine, which is rarely what a caller wants; pinning the runtime takes the
host out of it. Nothing here executes, so the runtime only has to be one clang will parse for.

One flag is worth *not* passing: `-fdelayed-template-parsing`. Clang registers the
late-template parser and its cleanup callback in `Parser::ParseTopLevelDecl`'s **`tok::eof`**
case, and an incremental session ends every buffer at the marker instead, so that case never
runs and the cached token streams of late-parsed templates are never drained. Nothing here
turns the flag on.

Release it with `dispose`.
"""
function create_parser(args=String[]; language::Symbol=:cxx, version=JLLEnvs.GCC_MIN_VER, triple=nothing)
    haskey(INCREMENTAL_LANGUAGES, language) ||
        throw(ArgumentError("language must be one of $(keys(INCREMENTAL_LANGUAGES)), got :$language"))
    is_cxx = language in (:cxx, :objcxx)
    default_args = get_default_args(; is_cxx, version, triple)

    ci = CompilerInstance()
    setShowColors(ci, false)
    createDiagnostics(ci)
    diag = getDiagnostics(ci)
    # `-fincremental-extensions` is what makes the lexer end each buffer with a marker token
    # rather than a hard EOF, so the parser can be handed another one afterwards.
    all_args = [default_args..., args..., "-x", INCREMENTAL_LANGUAGES[language],
                "-Xclang", "-fincremental-extensions"]
    # The driver needs an input name to build a job for; nothing ever opens it, because the
    # main file is installed below from an empty buffer.
    setInvocation(ci, createFromCommandLine("<<< inputs >>>", all_args, diag))
    # The driver reported a rejected argument into `diag`, and `diag` is about to be replaced --
    # so this is the only moment such an error is observable at all. Unchecked it disappears and
    # the caller gets a parser built from a partially-parsed invocation, which is the failure
    # the rebuild below would otherwise introduce while fixing another. clang's own cc1_main
    # abandons the compilation here for the same reason.
    nerr = getNumErrors(diag)
    if nerr > 0
        dispose(ci)
        throw(ArgumentError("clang rejected the compiler arguments ($nerr error(s) reported above)"))
    end
    # Twice, and both are needed. `createDiagnostics` builds the engine from the instance's
    # CURRENT DiagnosticOptions, and before `setInvocation` those are the defaults -- so the
    # first engine exists only to give the driver above somewhere to report a bad command line,
    # and an engine kept from that point ignores every `-W`/`-Werror` in `args`. Rebuilding here
    # is what clang's own `cc1_main` does for the same reason: parse argv with a throwaway
    # engine, then make the real one from what the parse produced. The first engine is
    # refcounted and released with its client.
    createDiagnostics(ci)
    setTargetAndLangOpts(ci)
    createFileManager(ci)
    createSourceManager(ci)
    sm = getSourceManager(ci)
    # The overload taking the buffer releases the FileID it boxes; spelling the FileID here
    # would leak one per parser.
    setMainFileID(sm, LLVM.MemoryBuffer(UInt8[], "<<< inputs >>>", true))
    createPreprocessor(ci)
    createASTContext(ci)
    setASTConsumer(ci, ASTConsumer())          # adopted; a parse-only driver needs no more
    createSema(ci)

    pp = getPreprocessor(ci)
    # Without this every builtin reads as an undeclared identifier. Nothing here calls one
    # directly, but system headers do — mingw's libstdc++ reaches `__builtin_unreachable`
    # from `<cstdint>`, which is how its absence first showed up.
    initializeBuiltins(pp)
    # `createDiagnostics` installed a TextDiagnosticPrinter, and a printer with no LangOpts
    # dereferences null the first time it renders a caret -- so this is not optional and not
    # only about errors: an ordinary warning kills the process too. Nothing showed it while
    # every test installed a recording consumer instead.
    begin_diag(ci)
    EnterMainSourceFile(pp)                    # `Parser::Initialize` lexes, so this precedes it
    parser = Parser(pp, getSema(ci), false)
    Initialize(parser)
    # The predefines buffer can hold more than macro definitions: `-include <header>` becomes an
    # `#include` line in it, and those declarations have to be parsed off before the first
    # increment enters a buffer on top. Left there, the header's tokens interleave with the
    # increment's -- `int preincluded;` followed by the increment's own `int` reads as
    # `cannot combine with previous 'int' declaration specifier` -- so the header neither takes
    # effect nor fails cleanly. `-D` never showed it, because a macro definition leaves nothing
    # to parse. With no `-include` this drains nothing and costs one lookahead.
    _parse_to_marker!(AbstractDecl[], parser)
    return IncrementalParser(ci, parser, language)
end

function dispose(x::IncrementalParser)
    dispose(x.parser)                          # before the instance that owns everything else
    return dispose(x.instance)
end

get_instance(x::IncrementalParser) = x.instance
get_ast_context(x::IncrementalParser) = getASTContext(x.instance)
get_sema(x::IncrementalParser) = getSema(x.instance)
get_parser(x::IncrementalParser) = x.parser

"""
    parse(x::IncrementalParser, code::AbstractString) -> Vector{AbstractDecl}
Parse `code` as one more increment of the translation unit and return the declarations it
added, each resolved to its concrete carrier.

Everything parsed so far stays visible: a `struct` declared in one call can be used in the
next, in every language this accepts.

Diagnostics go to the instance's `DiagnosticsEngine`, and each call starts that engine from a
clean state — so `hasErrorOccurred` after this call answers for *this* increment, and an empty
result means only that the increment declared nothing. Install a
[`TextDiagnosticBuffer`](@ref) on the engine to read the messages back; a recording consumer
accumulates across increments, since the per-increment reset zeroes counts without emptying it.

**End-of-translation-unit semantics run at every increment, not once at the end.** Clang's
`Parser::ParseTopLevelDecl` calls `Sema::ActOnEndOfTranslationUnit` when it reaches the
incremental marker that terminates each buffer, so pending instantiations are drained,
`#pragma weak` is resolved and the deferred end-of-TU diagnostics are emitted every time. It
is inherent to driving the `Parser` loop to that marker and is not something this function
chooses. Two consequences are worth knowing before splitting input across calls:

  - A C **tentative definition** must be completed within the increment that introduces it.
    `parse(p, "struct S; struct S s;")` reports `tentative definition has type 'struct S' that
    is never completed` at that increment's boundary, and completing `S` in a later increment
    does not retract it.
  - An incomplete array gets its provisional type at the same point, so `int a[];` becomes
    `int[1]` and a later `int a[10];` is a redefinition rather than a completion.

Neither affects a single-increment parse, or any input whose declarations are self-contained
per call.
"""
function parse(x::IncrementalParser, code::AbstractString)
    parser = x.parser
    @check_ptrs parser
    sm = getSourceManager(x.instance)
    pp = getPreprocessor(x.instance)

    # Each increment starts from a clean engine. Without this a single fatal diagnostic --
    # `#include <nonexistent.h>` is fatal by default -- latches `FatalErrorOccurred`, and from
    # then on clang drops every diagnostic BEFORE the consumer sees it: later bad increments
    # come back with recovery declarations and an empty buffer, indistinguishable from a clean
    # parse. Upstream resets in its error epilogue; resetting up front does the same job and
    # additionally makes `hasErrorOccurred` a per-increment answer rather than a latch, which
    # is what a caller polling for failure needs. A recording consumer keeps its messages --
    # `clear` zeroes counts without emptying it -- so only the latches go.
    diag = getDiagnostics(x.instance)
    Reset(diag, true)
    clear(getClient(diag))
    # The trailing newline is what upstream appends too: a buffer ending mid-line makes the
    # lexer report the marker token at a location inside the last token.
    buf = LLVM.MemoryBuffer(Vector{UInt8}(codeunits(string(code, '\n'))), "input_line", true)
    # Both FileIDs here are by-value C++ objects the shim heap-boxes, so both need releasing --
    # a session otherwise leaks two per increment. Neither call retains the box: each reads the
    # FileID out and passes it on by value.
    main_id = getMainFileID(sm)
    # The include location makes diagnostics from this buffer point at the main file.
    include_loc = getLocForStartOfFile(sm, main_id)
    dispose(main_id)
    fid = FileID(sm, buf)
    EnterSourceFile(pp, fid, include_loc)
    dispose(fid)

    # The parser caches one lookahead token, and after the previous increment (or after
    # `Initialize` on the empty main file) that is the incremental end marker. Entering a
    # buffer does not refill it, so it has to be dropped or the parse reads EOF immediately
    # and silently adds nothing.
    getName(getCurToken(parser)) == "annot_repl_input_end" && ConsumeAnyToken(parser)

    return _parse_to_marker!(AbstractDecl[], parser)
end

"""
Run clang's top-level parse loop over whatever buffer the preprocessor is currently in, until
the incremental marker that ends it, collecting the declarations produced.
"""
function _parse_to_marker!(out::Vector{AbstractDecl}, parser::Parser)
    state = Ref{Cuint}(0)
    group = Ref{CXDeclGroupRef}(CXDeclGroupRef(C_NULL))
    at_eof = clang_Parser_ParseFirstTopLevelDecl(parser, group, state)
    while true
        _collect_group!(out, group[])
        at_eof && break
        at_eof = clang_Parser_ParseTopLevelDecl(parser, group, state)
    end
    return out
end

"""
Append every declaration of one parsed group, resolved to its concrete carrier. A step that
produced none hands back a null group, and `int a, b;` hands back one holding two — reading
only the single-declaration case would drop the second silently.

Resolving here rather than leaving it to the caller matches the other traversal helpers
(`decls_in`, `redecls`): a base `Decl` carrier makes `d isa AbstractFunctionDecl` silently
false, so a caller that forgot to resolve gets a test that passes by never matching.
"""
function _collect_group!(out::Vector{AbstractDecl}, g::CXDeclGroupRef)
    g == CXDeclGroupRef(C_NULL) && return out
    dg = DeclGroupRef(g)
    for i in 0:(Base.size(dg) - 1)
        push!(out, resolve(getDecl(dg, i)))
    end
    return out
end
