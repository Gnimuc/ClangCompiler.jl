using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Clang_jll
using Test

@testset "Coverage | CompilerSemaParseLex" begin
    I = create_interpreter(String[])
    CC.parse(I, """
    namespace NS { struct Inner { int z; }; }
    struct Widget {
        int value;
        Widget() : value(0) {}
        ~Widget() {}
        int getValue() const { return value; }
    };
    int compute(int a, int b) { return a + b; }
    int gx = 42;
    """)

    ci = CC.get_instance(I)
    ctx = CC.get_ast_context(I)
    parser = CC.get_parser(I)

    # ---- CompilerInstance: has*/get* query accessors ----
    @test CC.hasDiagnostics(ci) == true
    @test CC.getDiagnostics(ci).ptr != C_NULL
    @test CC.getDiagnosticClient(ci).ptr != C_NULL
    @test CC.hasFileManager(ci) == true
    @test CC.getFileManager(ci).ptr != C_NULL
    @test CC.hasSourceManager(ci) == true
    @test CC.getSourceManager(ci).ptr != C_NULL
    @test CC.hasInvocation(ci) == true
    @test CC.getInvocation(ci).ptr != C_NULL
    @test CC.hasTarget(ci) == true
    @test CC.getTarget(ci).ptr != C_NULL
    @test CC.hasPreprocessor(ci) == true
    @test CC.getPreprocessor(ci).ptr != C_NULL
    @test CC.hasSema(ci) == true
    @test CC.getSema(ci).ptr == CC.get_sema(I).ptr
    @test CC.hasASTContext(ci) == true
    @test CC.getASTContext(ci).ptr == ctx.ptr
    @test CC.hasASTConsumer(ci) == true
    @test CC.getASTConsumer(ci).ptr != C_NULL

    # ---- CompilerInstance: option accessors ----
    @test CC.getCodeGenOpts(ci).ptr != C_NULL
    @test CC.getDiagnosticOpts(ci).ptr != C_NULL
    @test CC.getFrontendOpts(ci).ptr != C_NULL
    @test CC.getHeaderSearchOpts(ci).ptr != C_NULL
    @test !isempty(CC.GetResourceDir(CC.getHeaderSearchOpts(ci)))
    @test CC.getPreprocessorOpts(ci).ptr != C_NULL
    @test CC.getTargetOpts(ci).ptr != C_NULL
    @test CC.getLangOpts(ci).ptr != C_NULL

    # main file id (allocates -> dispose)
    fid = CC.getMainFileID(ci)
    @test fid isa CC.FileID
    dispose(fid)

    # ---- CompilerInstance: PrintStats dispatch table (writes to stderr) ----
    for T in (CC.CodeGenOptions, CC.DiagnosticOptions, CC.FrontendOptions,
              CC.HeaderSearchOptions, CC.PreprocessorOptions, CC.TargetOptions,
              CC.LangOptions, CC.FileManager, CC.SourceManager, CC.HeaderSearch,
              CC.Preprocessor, CC.Sema, CC.ASTContext, CC.ASTConsumer)
        @test (CC.PrintStats(ci, T); true)
    end

    # ---- Preprocessor (Lex/Preprocessor.jl) ----
    pp = CC.getPreprocessor(ci)
    hs = CC.getHeaderSearchInfo(pp)
    @test hs isa CC.HeaderSearch
    @test (CC.PrintStats(pp); true)
    # the interpreter drives clang incrementally, so this is already on before anything
    # here touches it, and enabling it again is idempotent rather than a toggle
    @test CC.isIncrementalProcessingEnabled(pp) == true
    @test (CC.enableIncrementalProcessing(pp); CC.isIncrementalProcessingEnabled(pp)) == true

    # ---- HeaderSearch / HeaderSearchOptions / PreprocessorOptions ----
    @test (CC.PrintStats(hs); true)
    hso = CC.getHeaderSearchOpts(ci)
    @test CC.GetResourceDir(hso) isa String
    @test (CC.PrintStats(hso); true)
    ppo = CC.getPreprocessorOpts(ci)
    @test (CC.PrintStats(ppo); true)

    # ---- Decls: reach a NamedDecl, a CXXRecordDecl, a SourceLocation ----
    f = DeclFinder(I)
    @test f(I, "Widget")
    widget = get_decl(f)
    @test widget isa CC.NamedDecl
    widget_rd = CC.CXXRecordDecl(get_decl(f))
    widget_ii = CC.getIdentifier(widget)
    widget_loc = CC.getLocation(widget)

    # ---- Sema (Sema/Sema.jl) ----
    sema = CC.get_sema(I)
    scope = CC.getCurScope(parser)
    @test (CC.PrintStats(sema); true)

    ss_tn = CC.CXXScopeSpec()
    @test !CC.is_null_handle(CC.getTypeName(sema, widget_ii, widget_loc, scope, ss_tn))

    @test !CC.is_null_handle(CC.LookupDefaultConstructor(sema, widget_rd))
    @test !CC.is_null_handle(CC.LookupDestructor(sema, widget_rd))

    # LookupResult construction + unqualified LookupName
    nm = CC.DeclarationName(CC.get_name(ctx, "compute"))
    lr = CC.LookupResult(sema, nm, widget_loc, CC.CXLookupNameKind_LookupOrdinaryName)
    # `compute` is a file-scope function in this translation unit, so an unqualified
    # ordinary-name lookup finds it. Nothing about that is host-decided.
    @test CC.LookupName(sema, lr, scope, true) == true

    # LookupParsedName on a fresh result + scope spec
    ss_lp = CC.CXXScopeSpec()
    lr2 = CC.LookupResult(sema, nm, widget_loc, CC.CXLookupNameKind_LookupOrdinaryName)
    @test CC.LookupParsedName(sema, lr2, scope, ss_lp, true, true) == true

    # ---- LookupResult query surface (Sema/Lookup.jl) on the populated `lr` ----
    @test (CC.resolveKind(lr); true)
    # `compute` is a single non-overloaded free function found by ordinary lookup, so
    # every one of these has an answer the source decides. `isa Bool` held for all of
    # them at once and so could not tell one predicate from another; these values can.
    @test CC.isForRedeclaration(lr) == false     # the shim's default is NotForRedeclaration
    @test CC.isTemplateNameLookup(lr) == false
    @test CC.isAmbiguous(lr) == false
    @test CC.isSingleResult(lr) == true
    @test CC.isOverloadedResult(lr) == false
    @test CC.isUnresolvableResult(lr) == false
    @test CC.isClassLookup(lr) == false          # LookupOrdinaryName, not a class member lookup
    @test CC.isSingleTagDecl(lr) == false        # a function, not a tag
    @test CC.empty(lr) == false
    @test Int(CC.getNum(lr)) == 1
    # and the count agrees with the two predicates derived from it
    @test CC.empty(lr) == (Int(CC.getNum(lr)) == 0)
    @test CC.isSingleResult(lr) == (Int(CC.getNum(lr)) == 1)
    @test CC.getResults(lr) isa Vector
    @test !CC.is_null_handle(CC.getRepresentativeDecl(lr))
    @test !CC.is_null_handle(CC.getLookupName(lr))
    if CC.isSingleResult(lr)
        @test !CC.is_null_handle(CC.getResult(lr))
    end
    @test (CC.dump(lr); true)
    @test (CC.setLookupName(lr, CC.getLookupName(lr)); true)
    @test (CC.clear(lr, CC.CXLookupNameKind_LookupOrdinaryName); true)
    dispose(lr)
    dispose(lr2)
    dispose(ss_tn)
    dispose(ss_lp)

    # ---- Scope (Sema/Scope.jl) ----
    scope = CC.getCurScope(parser)
    @test CC.getDepth(scope) isa Integer
    @test CC.getParent(scope) isa CC.Scope
    @test (CC.dump(scope); true)

    # ---- CXXScopeSpec (Sema/DeclSpec.jl) via a populated scope spec ----
    dss = CC.CXXScopeSpec()
    tail = CC.parse_cxx_scope_spec(I, dss, "NS::Inner")
    @test tail isa AbstractString
    # `NS::Inner` names a real nested scope, so the spec parsed and is populated. The two
    # pairs are complements of each other, which is the part `isa Bool` cannot state: two
    # predicates wired to the same underlying query satisfy it and fail this.
    @test CC.isValid(dss) == true
    @test CC.isInvalid(dss) == false
    @test CC.isEmpty(dss) == false
    @test CC.isNotEmpty(dss) == true
    @test CC.isValid(dss) == !CC.isInvalid(dss)
    @test CC.isNotEmpty(dss) == !CC.isEmpty(dss)
    @test !CC.is_null_handle(CC.getScopeRep(dss))
    bloc = CC.getBeginLoc(dss)
    eloc = CC.getEndLoc(dss)
    @test bloc isa CC.SourceLocation
    @test eloc isa CC.SourceLocation
    @test (CC.setBeginLoc(dss, bloc); true)
    @test (CC.setEndLoc(dss, eloc); true)
    sr = CC.SourceRange(bloc, eloc)
    @test CC.getRange(dss, sr) isa CC.SourceRange  # shape-only: varies with the scope spec the parse left behind
    @test (CC.setRange(dss, sr); true)
    @test (CC.clear(dss); true)
    dispose(dss)

    # ---- Parser: read-only queries (Parse/Parser.jl) ----
    # the parser borrows these from the CompilerInstance rather than owning copies, so
    # each is the very same object -- an accessor reading a neighbouring member returns a
    # perfectly well-typed carrier and fails only on identity
    @test CC.getLangOpts(parser).ptr == CC.getLangOpts(sema).ptr
    @test CC.getTargetInfo(parser).ptr == CC.getTarget(ci).ptr
    @test CC.getPreprocessor(parser).ptr == CC.getPreprocessor(ci).ptr
    @test CC.getActions(parser).ptr == CC.getSema(ci).ptr
    tok = CC.getCurToken(parser)
    @test tok isa CC.Token
    @test CC.NextToken(parser) isa CC.Token  # shape-only: varies with where the incremental parser is resting

    # pure helper functions over the parser context enums
    @test CC.getDeclSpecContextFromDeclaratorContext(CC.CXDeclaratorContext_Member) isa CC.CXDeclSpecContext
    @test CC.getDeclSpecContextFromDeclaratorContext(CC.CXDeclaratorContext_File) isa CC.CXDeclSpecContext
    @test CC.getDeclSpecContextFromDeclaratorContext(CC.CXDeclaratorContext_Block) isa CC.CXDeclSpecContext
    @test CC.shouldEnterContext(CC.CXDeclSpecContext_DSC_top_level) isa Bool
    @test CC.shouldEnterContext(CC.CXDeclSpecContext_DSC_normal) isa Bool

    # ---- Token query surface (Lex/Token.jl) ----
    # a token the parser is actually resting on was written somewhere
    @test CC.isValid(CC.getLocation(tok))
    @test CC.getAnnotationEndLoc(tok) isa CC.SourceLocation
    @test CC.getAnnotationRange(tok) isa CC.SourceRange
    @test CC.getName(tok) isa String
    @test CC.getAnnotationValue(tok) isa CC.AnnotationValue  # shape-only: varies with the token kind the parser is resting on
    @test CC.is_eof(tok) isa Bool
    @test CC.is_annot_repl_input_end(tok) isa Bool
    @test CC.is_identifier(tok) isa Bool
    @test CC.is_coloncolon(tok) isa Bool
    @test CC.is_annot_cxxscope(tok) isa Bool
    @test CC.is_annot_typename(tok) isa Bool
    @test CC.is_annot_template_id(tok) isa Bool
    @test CC.is_kw_enum(tok) isa Bool
    @test CC.is_kw_typename(tok) isa Bool
    # getIdentifierInfo aborts on annotation tokens, and a finished incremental parse leaves
    # the parser sitting on annot_repl_input_end. Pushing a one-identifier buffer under the
    # parser and consuming that end-of-input annotation puts a real `identifier` in
    # `Parser::Tok`, which `tok` is a live view of. Draining back to annot_repl_input_end
    # restores the token stream for the assertions below.
    ident_fid = CC.FileID(CC.getSourceManager(ci), CC.get_buffer("Widget"))
    CC.begin_diag(ci)
    CC.EnterSourceFile(pp, ident_fid)
    CC.is_annot_repl_input_end(tok) && CC.ConsumeAnyToken(parser)
    @test CC.is_identifier(tok)
    @test CC.getName(CC.getIdentifierInfo(tok)) == "Widget"
    while !CC.is_annot_repl_input_end(tok)
        CC.ConsumeAnyToken(parser)
    end
    CC.EndSourceFile(pp)
    CC.end_diag(ci)
    dispose(ident_fid)

    # QualType annotation read off a token (Parse/Parser.jl)
    @test CC.getTypeAnnotation(tok) isa CC.QualType  # shape-only: varies with the token kind the parser is resting on

    # ---- Preprocessor dump helpers (need a token / a location) ----
    @test (CC.DumpToken(pp, tok); true)
    @test (CC.DumpLocation(pp, widget_loc); true)

    # ---- Parser mutators run LAST (they advance/annotate the live token stream) ----
    @test CC.TryAnnotateCXXScopeToken(parser, false) isa Bool
    @test CC.TryAnnotateCXXScopeToken(parser, CC.CXDeclSpecContext_DSC_top_level) isa Bool
    @test CC.TryAnnotateCXXScopeToken(parser, CC.CXDeclaratorContext_File) isa Bool
    @test CC.TryAnnotateOptionalCXXScopeToken(parser, false) isa Bool
    @test CC.TryAnnotateOptionalCXXScopeToken(parser, CC.CXDeclSpecContext_DSC_class) isa Bool
    @test CC.TryAnnotateOptionalCXXScopeToken(parser, CC.CXDeclaratorContext_Member) isa Bool
    @test CC.TryAnnotateTypeOrScopeToken(parser) isa Bool  # shape-only: varies with where the incremental parser is resting
    ss_af = CC.CXXScopeSpec()
    @test CC.TryAnnotateTypeOrScopeTokenAfterScopeSpec(parser, ss_af) isa Bool  # shape-only: varies with where the incremental parser is resting
    dispose(ss_af)
    # the location it hands back is the token it consumed, which was a real one
    @test CC.isValid(CC.ConsumeAnyToken(parser))

    dispose(f)
    dispose(I)
end

@testset "CompilerInstance | plugins and frontend timer" begin
    I = create_interpreter(String[])

    # CompilerInstance: no plugins are requested, so loading them is a no-op
    ci = CC.get_instance(I)
    @test (CC.LoadRequestedPlugins(ci); true)
    # -ftime-report was not passed, so there is no timer until one is made -- the half of
    # the round trip that says the assertion below is the create doing something
    @test CC.hasFrontendTimer(ci) == false
    CC.createFrontendTimer(ci)
    @test CC.hasFrontendTimer(ci)

    dispose(I)
end

@testset "CompilerInstance module-building flag" begin
    # Inherited from clang::ModuleLoader, whose constructor sets the flag, so a bare
    # instance already answers and the setter round-trips.
    ci = CC.CompilerInstance()

    # ModuleLoader's constructor sets it false, so the initial answer is a value and not
    # an uninitialised read -- which is what makes the setter round trip below meaningful
    @test CC.buildingModule(ci) == false
    @test !CC.buildingModule(ci)
    @test CC.setBuildingModule(ci, true) === nothing
    @test CC.buildingModule(ci)
    @test CC.setBuildingModule(ci, false) === nothing
    @test !CC.buildingModule(ci)

    dispose(ci)
end

@testset "CompilerInstance | InitializeSourceManagerFromFile" begin
    ci = CC.CompilerInstance()
    CC.createDiagnostics(ci)
    fm = CC.createFileManager(ci)
    # `createFileManager` hands back the manager it installed, not a fresh one -- the instance
    # then reports the same object. Asserting the identity rather than the Julia type is what
    # makes this about clang: the wrapper's own `return FileManager(...)` fixes the type, so
    # `isa` could not tell a correct wrapper from one handing back some other file manager.
    H = CC.LibClangEx.CXFileManager
    @test Base.unsafe_convert(H, fm) == Base.unsafe_convert(H, CC.getFileManager(ci))
    CC.createSourceManager(ci, CC.getFileManager(ci))
    sm = CC.getSourceManager(ci)

    path = joinpath(mktempdir(), "ismff_probe.cpp")
    write(path, "int g = 1;\n")

    @test CC.InitializeSourceManagerFromFile(ci, path)
    fid = CC.getMainFileID(sm)
    @test CC.isValid(fid)
    # the content round-trips, so the file really became the main file
    @test CC.getBufferData(sm, fid) == "int g = 1;\n"
    @test CC.getFileCharacteristic(sm, CC.getLocForStartOfFile(sm, fid)) ==
          CC.CXCharacteristicKind_C_User
    CC.dispose(fid)

    # is_system selects the other characteristic for the same bytes
    @test CC.InitializeSourceManagerFromFile(ci, path, true)
    sfid = CC.getMainFileID(sm)
    @test CC.getFileCharacteristic(sm, CC.getLocForStartOfFile(sm, sfid)) ==
          CC.CXCharacteristicKind_C_System
    CC.dispose(sfid)

    # an unreadable path is a counted diagnostic, not a silent false
    before = CC.getNumErrors(CC.getDiagnostics(ci))
    @test !CC.InitializeSourceManagerFromFile(ci, joinpath(dirname(path), "no_such_file.cpp"))
    @test CC.getNumErrors(CC.getDiagnostics(ci)) > before

    @test_throws AssertionError CC.InitializeSourceManagerFromFile(ci, "-")

    CC.dispose(ci)
end

@testset "CompilerInstance | PCH loading" begin
    # createPCHExternalASTSource returns void, so `hasASTReader` and the diagnostics engine's
    # error count are the only things that tell a loaded PCH from a rejected one. Both halves
    # below assert that pair -- once on a file clang accepts, once on a file it does not.
    args = ["-nostdinc", "-nostdlib", "-std=c++17"]

    # Everything createPCHExternalASTSource reads, and deliberately nothing that parses into
    # the AST context: no consumer and no Sema, so the translation unit stays empty until a
    # PCH fills it.
    function pch_instance(src)
        ci = CC.CompilerInstance()
        CC.setShowColors(ci, false)
        CC.createDiagnostics(ci)
        diag = CC.getDiagnostics(ci)
        CC.setInvocation(ci, CC.createFromCommandLine(src, args, diag))  # adopted, no dispose
        CC.setTargetAndLangOpts(ci)
        CC.createFileManager(ci)
        CC.createSourceManager(ci)
        CC.setMainFileID(ci, src)
        CC.createPreprocessor(ci)
        CC.createASTContext(ci)
        return ci
    end

    mktempdir() do dir
        hdr = joinpath(dir, "pch_probe.h")
        write(hdr, "int pch_probe_g = 7;\n")
        pch = joinpath(dir, "pch_probe.pch")
        src = joinpath(dir, "pch_main.cpp")
        write(src, "int pch_main_v = 1;\n")

        # The positive input has to come from outside: this package can construct no
        # GeneratePCHAction (only the clang_Emit*Action_create CodeGen family exists), so the
        # PCH is emitted by the clang binary Clang_jll already ships.
        @test success(pipeline(`$(clang()) -x c++-header -std=c++17 -nostdinc
                                -o $pch $hdr`; stdout=devnull, stderr=devnull))

        # ---- a real PCH loads, and its declarations reach the AST context ----
        ci = pch_instance(src)
        diag = CC.getDiagnostics(ci)
        @test !CC.hasASTReader(ci)
        before = CC.getNumErrors(diag)
        # The PCH comes from a separate clang process driven by a different command line, so
        # its language options, target triple and version string are all compared against
        # this instance's unless validation is off. Disabling it keeps the assertion about
        # the loading path rather than about two command lines agreeing; the enumerator's
        # numbering is pinned C-side by the ENUM_SYNC table, not here.
        CC.createPCHExternalASTSource(ci, pch, CC.CXDisableValidationForModuleKind_All, true)
        @test CC.hasASTReader(ci)
        # a load that "succeeded" while reporting errors would be a rejected PCH
        @test CC.getNumErrors(diag) == before

        # Nothing parsed the main file, so the PCH is the only route this name has into the
        # translation unit -- which is also what pins `path` to the right C parameter.
        # Iterating the context is what pulls the decls across: the reader leaves the
        # translation unit with external lexical storage, and `decls_begin` loads it.
        tu = CC.getTranslationUnitDecl(CC.getASTContext(ci))
        names = [CC.getNameAsString(d)
                 for d in CC.decls_in(CC.castToDeclContext(tu)) if d isa CC.AbstractNamedDecl]
        @test "pch_probe_g" in names
        @test !("pch_main_v" in names)
        CC.dispose(ci)

        # ---- a file that is not a PCH is refused, and says why ----
        ci2 = pch_instance(src)
        diag2 = CC.getDiagnostics(ci2)
        before2 = CC.getNumErrors(diag2)
        CC.createPCHExternalASTSource(ci2, hdr)
        @test !CC.hasASTReader(ci2)
        @test CC.getNumErrors(diag2) > before2
        CC.dispose(ci2)
    end
end

@testset "CompilerInstance | PCH loading preconditions" begin
    # The three members the C++ body reaches unchecked -- invocation, preprocessor, AST
    # context -- are restated as assertions, so a caller who skipped a pipeline step gets an
    # AssertionError instead of clang's abort.
    ci = CC.CompilerInstance()
    # CompilerInstance's constructor default-constructs an invocation, so that gate is
    # already satisfied on a bare instance and the preprocessor is the first one that bites.
    @test CC.hasInvocation(ci)
    @test !CC.hasPreprocessor(ci)
    @test !CC.hasASTContext(ci)
    @test_throws AssertionError CC.createPCHExternalASTSource(ci, "no_such.pch")
    # the reader predicate is total, and answers on an instance with nothing built
    @test !CC.hasASTReader(ci)
    CC.dispose(ci)
end
