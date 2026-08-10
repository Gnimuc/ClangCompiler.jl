using ClangCompiler
using ClangCompiler: create_interpreter, dispose, DeclFinder
using ClangCompiler: parse_cxx_scope_spec
using ClangCompiler: CXXScopeSpec, getScopeRep, getName, isValid, isEmpty, clear
using Test

@testset "Parse Decl" begin
    I = create_interpreter(["-include", "vector"])
    ss = CXXScopeSpec()

    id = parse_cxx_scope_spec(I, ss, "std::vector<int>::size_type")
    @test !isEmpty(ss)
    @test isValid(ss)
    @test getName(getScopeRep(ss)) == "std::vector<int>::"
    @test id == "size_type"
    clear(ss)

    id = parse_cxx_scope_spec(I, ss, "std::vector<int>::")
    @test !isEmpty(ss)
    @test isValid(ss)
    @test getName(getScopeRep(ss)) == "std::vector<int>::"
    @test id == ""
    clear(ss)

    id = parse_cxx_scope_spec(I, ss, "std::vector<int>")
    @test !isEmpty(ss)
    @test isValid(ss)
    @test getName(getScopeRep(ss)) == "std::"
    @test id == ""
    clear(ss)

    id = parse_cxx_scope_spec(I, ss, "std::vector")
    @test !isEmpty(ss)
    @test isValid(ss)
    @test getName(getScopeRep(ss)) == "std::"
    @test id == "vector"
    clear(ss)

    id = parse_cxx_scope_spec(I, ss, "std::")
    @test !isEmpty(ss)
    @test isValid(ss)
    @test getName(getScopeRep(ss)) == "std::"
    @test id == ""
    clear(ss)

    id = parse_cxx_scope_spec(I, ss, "std")
    @test isEmpty(ss)
    @test !isValid(ss)
    @test id == "std"
    clear(ss)

    id = parse_cxx_scope_spec(I, ss, "::std")
    @test !isEmpty(ss)
    @test isValid(ss)
    @test getName(getScopeRep(ss)) == "::"
    @test id == "std"
    clear(ss)

    dispose(ss)
    dispose(I)
end

import ClangCompiler as CC
using ClangCompiler: DeclFinder, get_decl, get_instance

@testset "parse(CompilerInstance) — classic pipeline" begin
    # parse() runs ParseAST over a standalone pipeline instance. Its
    # preprocessor must NOT be owned by a live Parser (the interpreter's
    # instance crashes there — see the docstring); the consumer is donated by
    # a throwaway interpreter, so `ci` is intentionally leaked to avoid a
    # double-free of the adopted consumer.
    SI = create_interpreter(String[])
    CC.parse(SI, "int tpp_donor = 1;")
    sci = get_instance(SI)

    mktempdir() do dir
        src = joinpath(dir, "tpp_main.cpp")
        write(src, "int tpp_g = 41; int tpp_f(int x) { return x + 1; }\n")

        ci = CC.CompilerInstance()
        CC.setShowColors(ci, false)
        CC.createDiagnostics(ci)
        diag = CC.getDiagnostics(ci)
        invok = CC.createFromCommandLine(src, ["-nostdinc", "-nostdlib"], diag)
        CC.setInvocation(ci, invok)  # adopted — no dispose
        CC.setTargetAndLangOpts(ci)
        CC.createFileManager(ci)
        CC.createSourceManager(ci)
        CC.setMainFileID(ci, src)
        CC.createPreprocessor(ci)
        CC.createASTContext(ci)
        CC.setASTConsumer(ci, CC.getASTConsumer(sci))
        CC.createSema(ci)

        @test CC.parse(ci) == true
        tu = CC.getTranslationUnitDecl(CC.getASTContext(ci))
        kinds = [CC.getDeclKindName(d) for d in CC.decls(CC.castToDeclContext(tu))]
        @test "Var" in kinds
        @test "Function" in kinds
        # ci intentionally leaked (donated consumer)
    end

    dispose(SI)
end

@testset "a scope-spec parse leaves the diagnostic consumer armed" begin
    # Regression: `parse_cxx_scope_spec` wraps its nested parse in begin_diag/end_diag, and
    # `end_diag` is DiagnosticConsumer::EndSourceFile, which on the TextDiagnosticPrinter
    # `createDiagnostics` installs destroys the printer's TextDiagnostic outright -- there is
    # no nesting, so it tore down the state the interpreter armed at construction rather than
    # only the nested parse's. The next diagnostic carrying a location then rendered through a
    # null unique_ptr, and the assert that would have caught it is compiled out of the release
    # libclang-cpp, so an ordinary warning killed the process.
    #
    # The shape below is what found it: a lookup (which runs a scope-spec parse whether or not
    # the name resolves), then an increment that warns. `sizeof(n = 3)` warns because the
    # assignment sits in an unevaluated operand.
    I = create_interpreter(String[])
    f = DeclFinder(I)
    CC.parse(I, "int dsa_gv = 1;")

    @test f(I, "dsa_gv")                 # a hit ...
    @test !f(I, "dsa_no_such_name")      # ... and a miss both run the scope-spec parse
    # the warning renders instead of segfaulting, and the increment still parses
    @test CC.parse(I, "void dsa_w(int n) { int z = sizeof(n = 3); (void)z; }").ptr != C_NULL
    # and the interpreter is still usable afterwards
    @test CC.parse(I, "int dsa_after = 2;").ptr != C_NULL
    @test f(I, "dsa_after")

    dispose(f)
    dispose(I)
end
