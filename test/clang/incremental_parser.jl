using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_parser, dispose
using Test

const LXI = CC.LibClangEx

"Run `chunks` through one parser, returning the names it added and the errors it reported."
function ip_run(language, chunks)
    p = create_parser(; language)
    de = CC.getDiagnostics(CC.get_instance(p))
    buf = CC.TextDiagnosticBuffer()
    CC.setClient(de, buf, false)
    added = [String[] for _ in chunks]
    for (i, code) in enumerate(chunks)
        for d in map(CC.resolve, CC.parse(p, code))
            d isa CC.AbstractNamedDecl && push!(added[i], CC.getNameAsString(d))
        end
    end
    n = Base.size(buf, LXI.CXTextDiagnosticBuffer_Error)
    errs = [CC.getMessage(buf, LXI.CXTextDiagnosticBuffer_Error, i) for i = 0:(n - 1)]
    CC.setClient(de, CC.TextDiagnosticPrinter(CC.getDiagnosticOptions(de)), true)
    dispose(buf)
    dispose(p)
    return added, errs
end

@testset "IncrementalParser | one translation unit across increments" begin
    # The reason this driver exists. clang's own Interpreter starts a new TranslationUnitDecl
    # per increment; C++ lookup crosses that chain and C's does not, so `clang-repl --Xcc -xc`
    # cannot see a declaration made one line earlier. Each case below uses, in a LATER
    # increment, something declared in an earlier one — which is exactly what fails there.
    @testset "$language" for (language, chunks, expected) in (
        (:c, ["struct Pt { int x; };",
              "struct Pt ip_gp; int ip_getx(void) { return ip_gp.x; }"],
         ["Pt"] => ["ip_gp", "ip_getx"]),
        (:cxx, ["struct Pt { int x; };",
                "Pt ip_gp; int ip_getx() { return ip_gp.x; }"],   # `Pt` unqualified: C++ only
         ["Pt"] => ["ip_gp", "ip_getx"]),
        (:objc, ["@interface Thing { int v; } @end",
                 "Thing *ip_gt; id ip_get(void) { return ip_gt; }"],
         ["Thing"] => ["ip_gt", "ip_get"]),
        (:objcxx, ["@interface Thing { int v; } @end",
                   "Thing *ip_gt; struct Holder { Thing *t; };"],
         ["Thing"] => ["ip_gt", "Holder"]),
    )
        added, errs = ip_run(language, chunks)
        @test isempty(errs)
        @test added[1] == first(expected)
        @test added[2] == last(expected)
    end
end

@testset "IncrementalParser | headers, groups and the language argument" begin
    # `#include <stdint.h>` in C is the case clang's Interpreter cannot do at all: the
    # header reaches `__builtin_va_list`, which lives in the increment before every other
    # one. Reading `int64_t` from a LATER increment than the include is the second half.
    added, errs = ip_run(:c, ["#include <stdint.h>",
                              "int64_t ip_big = 1; uint8_t ip_small = 2;"])
    @test isempty(errs)
    @test "int64_t" in added[1]                       # the header's own typedefs
    @test added[2] == ["ip_big", "ip_small"]

    # The same for C++ and its own header spelling. This one only passed on macOS and Linux
    # at first: mingw's libstdc++ reaches `__builtin_unreachable` from `<cstdint>` where
    # libc++ and glibc's do not, and no builtin resolved at all — see below.
    added, errs = ip_run(:cxx, ["#include <cstdint>", "std::int64_t ip_big = 1;"])
    @test isempty(errs)
    @test added[2] == ["ip_big"]

    # One declarator group holding several declarations: reading only the single-decl case
    # would report `a` and silently drop the rest.
    added, errs = ip_run(:c, ["int ip_a, ip_b, ip_c;"])
    @test isempty(errs)
    @test added[1] == ["ip_a", "ip_b", "ip_c"]

    # An increment that declares nothing is not an error, and is distinguishable from one
    # that failed only through the diagnostics engine.
    added, errs = ip_run(:c, [";"])
    @test isempty(added[1])

    @test_throws ArgumentError create_parser(; language=:fortran)
end

@testset "IncrementalParser | builtins resolve" begin
    # A frontend action stamps builtin IDs onto their identifiers; a driver assembling a
    # CompilerInstance by hand has to ask. Skipping it leaves EVERY builtin reading as an
    # undeclared identifier, and nothing in the package's own sources calls one — so the
    # first failure was a system header on one platform, long after the cause. Asserting the
    # ID directly is what makes this cost one assertion instead of a CI round trip.
    @testset "$language" for language in (:c, :cxx, :objc, :objcxx)
        p = create_parser(; language)
        pp = CC.getPreprocessor(CC.get_instance(p))
        @test CC.getBuiltinID(CC.getIdentifierInfo(pp, "__builtin_unreachable")) != 0
        @test CC.getBuiltinID(CC.getIdentifierInfo(pp, "__builtin_memcpy")) != 0
        # not everything is a builtin, so the accessor is answering rather than saying yes
        @test CC.getBuiltinID(CC.getIdentifierInfo(pp, "ip_not_a_builtin")) == 0
        dispose(p)
    end

    added, errs = ip_run(:c, ["void ip_u(void) { __builtin_unreachable(); }",
                              "unsigned long ip_l(const char *s) { return __builtin_strlen(s); }"])
    @test isempty(errs)
    @test added == [["ip_u"], ["ip_l"]]
end

@testset "IncrementalParser | the target follows the triple, not the host" begin
    # Cross-parsing is this driver's natural home. `create_interpreter` accepts a triple too,
    # but its JIT still emits for the host, so only the parsing half ever crossed; nothing
    # here executes, so there is no half that does not.
    #
    # The same pinned triple as test/clang/pinned_target.jl, deliberately: pinning downloads
    # that target's shard and the suite should pay for exactly one. `aarch64-linux-gnu` and
    # `x86_64-w64-mingw32` were checked by hand and behave the same way -- the latter reports
    # `long` as 32 bits, which is the LLP64 fact that makes it worth having crossed at all.
    p = create_parser(; language=:c, triple="x86_64-linux-gnu")
    ci = CC.get_instance(p)
    @test CC.getTriple(CC.getTarget(ci)) == "x86_64-unknown-linux-gnu"

    # Target-specific builtins come from the pinned target rather than from the runner, which
    # is the half of the builtin table `initializeBuiltins` does not populate. Asserting both
    # directions means at least one of them discriminates on every CI host: an x86 runner
    # would pass the first anyway, an aarch64 one would pass the second.
    pp = CC.getPreprocessor(ci)
    @test CC.getBuiltinID(CC.getIdentifierInfo(pp, "__builtin_ia32_pause")) != 0
    @test CC.getBuiltinID(CC.getIdentifierInfo(pp, "__builtin_neon_vabsq_v")) == 0

    # ... and so do the headers and the ABI. `long` is 64 bits under LP64 and 32 on a Windows
    # host, so this equality is the target answering rather than the machine.
    CC.parse(p, "#include <stdint.h>")
    ds = map(CC.resolve, CC.parse(p, "long ip_cl; int64_t ip_ci;"))
    ctx = CC.get_ast_context(p)
    byname = Dict(CC.getNameAsString(d) => d for d in ds if d isa CC.AbstractNamedDecl)
    @test Int(CC.getTypeSize(ctx, CC.getType(byname["ip_cl"]))) == 64
    @test Int(CC.getTypeSize(ctx, CC.getType(byname["ip_ci"]))) == 64
    dispose(p)
end

@testset "IncrementalParser | the unit is shared, and can be finalised" begin
    p = create_parser(; language=:c)
    CC.parse(p, "struct Shared { int a; };")
    CC.parse(p, "struct Shared ip_inst;")

    # Every increment landed in ONE translation unit -- the property the whole driver turns
    # on, and the one clang's Interpreter does not have.
    ctx = CC.get_ast_context(p)
    tu = CC.getTranslationUnitDecl(ctx)
    @test CC.is_null_handle(CC.getPreviousDecl(tu))
    names = [CC.getNameAsString(d) for d in CC.decls_in(CC.castToDeclContext(tu))
             if d isa CC.AbstractNamedDecl]
    @test "Shared" in names
    @test "ip_inst" in names

    # Sema and the instance are the ones the parse ran against.
    @test CC.get_sema(p).ptr == CC.getSema(CC.get_instance(p)).ptr
    @test CC.get_parser(p).ptr != C_NULL

    # Finalising again is redundant rather than unit-ending -- clang already did it at each
    # increment's marker (see the per-increment testset below), and a further call neither
    # errors nor stops the unit being extended.
    @test CC.ActOnEndOfTranslationUnit(CC.get_sema(p)) === nothing
    added = map(CC.resolve, CC.parse(p, "struct Shared ip_after;"))
    @test [CC.getNameAsString(d) for d in added if d isa CC.AbstractNamedDecl] == ["ip_after"]
    dispose(p)
end

@testset "IncrementalParser | diagnostics reach the default client and do not latch" begin
    # `createDiagnostics` installs a TextDiagnosticPrinter, and a printer whose LangOpts were
    # never set dereferences null the first time it renders a caret. So an increment carrying
    # ANY diagnostic took the process down, and no test here saw it: every other one installs a
    # recording buffer, which stores messages instead of rendering them. This one keeps the
    # default client deliberately, and survival IS the assertion -- a regression is a segfault,
    # not a failed comparison. stderr goes to devnull only to keep the suite's log readable.
    p = create_parser(; language=:c)
    de = CC.getDiagnostics(CC.get_instance(p))
    redirect_stderr(devnull) do
        CC.parse(p, "int ip_bad = ip_nope_undeclared;")
    end
    @test CC.hasErrorOccurred(de)
    @test CC.getNumErrors(de) == 1
    # A warning renders through the same printer, and is the case a caller hits without asking
    # for it -- so it is the half of the crash worth covering separately. Falling off the end of
    # a non-void function is that warning; `return;` with no expression is `err_return_missing_
    # expr`, an error on every target, which would have made this a second error increment and
    # left the warning path unexercised. The severity is asserted rather than assumed for
    # exactly that reason.
    ds = redirect_stderr(devnull) do
        map(CC.resolve, CC.parse(p, "int ip_warn(void) { }"))
    end
    @test CC.getNumWarnings(de) == 1
    @test CC.getNumErrors(de) == 0
    @test [CC.getNameAsString(d) for d in ds if d isa CC.AbstractNamedDecl] == ["ip_warn"]
    dispose(p)

    # A fatal diagnostic latches `FatalErrorOccurred`, and clang then drops every later
    # diagnostic BEFORE the consumer is invoked -- so without the per-increment reset the
    # second bad increment below comes back with an empty buffer and recovery declarations,
    # indistinguishable from a clean parse. Asserting the SECOND message is what discriminates:
    # the first arrives either way.
    q = create_parser(; language=:c)
    de2 = CC.getDiagnostics(CC.get_instance(q))
    buf = CC.TextDiagnosticBuffer()
    CC.setClient(de2, buf, false)
    CC.parse(q, "#include <ip_definitely_nonexistent_zz.h>")     # err_pp_file_not_found: fatal
    @test CC.hasFatalErrorOccurred(de2)
    CC.parse(q, "int ip_y = ip_another_undeclared_thing;")
    n = Base.size(buf, LXI.CXTextDiagnosticBuffer_Error)
    msgs = [CC.getMessage(buf, LXI.CXTextDiagnosticBuffer_Error, i) for i = 0:(n - 1)]
    @test length(msgs) == 2
    @test occursin("file not found", msgs[1])
    @test occursin("undeclared identifier", msgs[2])
    # And the reset makes the engine answer for one increment rather than for the session, so a
    # caller can poll it. Latched state would keep this true.
    CC.parse(q, "int ip_fine = 1;")
    @test !CC.hasErrorOccurred(de2)
    @test !CC.hasFatalErrorOccurred(de2)
    CC.setClient(de2, CC.TextDiagnosticPrinter(CC.getDiagnosticOptions(de2)), true)
    dispose(buf)
    dispose(q)
end

@testset "IncrementalParser | diagnostic flags in args reach the engine" begin
    # `createDiagnostics` builds the engine from whatever DiagnosticOptions the instance holds
    # at the time, so an engine created before `setInvocation` is built from the defaults and
    # every `-W`/`-Werror` in `args` is silently inert -- the flag is accepted, parsing
    # succeeds, and nothing reports that the request was dropped. One source read three ways is
    # what makes that observable: a `-D` control cannot see it, because macros come from the
    # invocation, which IS set.
    src = "int ip_flag(void) { }"                 # -Wreturn-type: warns by default
    function severity(args)
        p = create_parser(args; language=:c)
        de = CC.getDiagnostics(CC.get_instance(p))
        buf = CC.TextDiagnosticBuffer()
        CC.setClient(de, buf, false)
        CC.parse(p, src)
        n = (Int(CC.getNumErrors(de)), Int(CC.getNumWarnings(de)))
        CC.setClient(de, CC.TextDiagnosticPrinter(CC.getDiagnosticOptions(de)), true)
        dispose(buf)
        dispose(p)
        return n
    end
    @test severity(String[]) == (0, 1)            # the default: one warning
    @test severity(["-Wno-return-type"]) == (0, 0) # silenced
    @test severity(["-Werror"]) == (1, 0)         # promoted

    # The engine that receives the driver's own complaint about the command line is the one
    # rebuilt away above, so a rejected argument is observable for exactly one call. Unchecked
    # it vanishes and `create_parser` hands back a parser configured from a half-parsed
    # invocation -- the flag is wrong, nothing says so, and every later diagnostic is suspect.
    redirect_stderr(devnull) do
        @test_throws ArgumentError create_parser(["--ip-bogus-driver-flag"]; language=:c)
    end
    # A valid argument set is not caught by that check, which is the half that would fail if it
    # were reading the wrong counter.
    p = create_parser(["-DIP_OK=1"]; language=:c)
    ds = map(CC.resolve, CC.parse(p, "int ip_ok = IP_OK;"))
    @test [CC.getNameAsString(d) for d in ds if d isa CC.AbstractNamedDecl] == ["ip_ok"]
    dispose(p)
end

@testset "IncrementalParser | -include reaches the first increment" begin
    # `-include` lands as an `#include` in the predefines buffer, which is a buffer the driver
    # has to parse off before the first increment stacks another on top of it. Undrained, the
    # header's tokens interleave with the increment's and the failure is not even a clean one:
    # the header's declaration is missing AND the increment picks up a spurious
    # `cannot combine with previous 'int' declaration specifier`. Asserting both the
    # declaration and the macro is what separates "drained" from "never included" -- a driver
    # that silently dropped the header would still parse the increment, just not resolve these.
    mktempdir() do dir
        hdr = joinpath(dir, "ip_pre.h")
        write(hdr, "int ip_preincluded;\n#define IP_PREINC 7\n")
        p = create_parser(["-include", hdr]; language=:c)
        de = CC.getDiagnostics(CC.get_instance(p))
        buf = CC.TextDiagnosticBuffer()
        CC.setClient(de, buf, false)
        ds = map(CC.resolve, CC.parse(p, "int ip_uses(void) { return IP_PREINC + ip_preincluded; }"))
        n = Base.size(buf, LXI.CXTextDiagnosticBuffer_Error)
        errs = [CC.getMessage(buf, LXI.CXTextDiagnosticBuffer_Error, i) for i = 0:(n - 1)]
        @test isempty(errs)
        @test [CC.getNameAsString(d) for d in ds if d isa CC.AbstractNamedDecl] == ["ip_uses"]
        # the header's own declaration is in the shared unit, not in the increment's result
        names = [CC.getNameAsString(d) for d in CC.decls_in(CC.castToDeclContext(CC.getTranslationUnitDecl(CC.get_ast_context(p))))
                 if d isa CC.AbstractNamedDecl]
        @test "ip_preincluded" in names
        CC.setClient(de, CC.TextDiagnosticPrinter(CC.getDiagnosticOptions(de)), true)
        dispose(buf)
        dispose(p)
    end
end

@testset "IncrementalParser | end-of-translation-unit semantics run per increment" begin
    # `Parser::ParseTopLevelDecl` calls `Sema::ActOnEndOfTranslationUnit` on reaching the
    # incremental marker, so full end-of-TU finalisation happens at EVERY increment rather than
    # once at the end. It is inherent to driving the Parser loop to that marker, so this pins
    # the behaviour rather than asserting it is desirable -- and pins it through a diagnostic
    # only that finalisation emits, so a change in when it runs fails here.
    #
    # `struct S; struct S s;` followed by `struct S { int x; };` is valid as ONE C translation
    # unit. Split across increments it is not: the tentative definition is diagnosed at the
    # first boundary, and completing S afterwards does not retract it.
    added, errs = ip_run(:c, ["struct S; struct S ip_s;", "struct S { int x; };"])
    @test length(errs) == 1
    @test occursin("tentative definition", errs[1])          # err_tentative_def_incomplete_type
    @test "ip_s" in added[1]                                 # the declaration is still made

    # The same finalisation gives an incomplete array its provisional type, so a later
    # completion reads as a redefinition. Both halves are the same one cause.
    added, errs = ip_run(:c, ["int ip_arr[];", "int ip_arr[10];"])
    @test any(e -> occursin("redefinition", e), errs)

    # Declarations that are self-contained per increment are unaffected, which is what makes
    # the driver usable at all -- so this is the partition, not a second pin of the same thing.
    added, errs = ip_run(:c, ["struct T { int x; }; struct T ip_t;",
                              "int ip_u(void) { return ip_t.x; }"])
    @test isempty(errs)
    @test added[2] == ["ip_u"]
end
