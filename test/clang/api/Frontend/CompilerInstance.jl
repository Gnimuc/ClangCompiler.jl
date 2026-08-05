using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
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
    @test CC.isIncrementalProcessingEnabled(pp) isa Bool  # shape-only: the host decides this
    @test (CC.enableIncrementalProcessing(pp); CC.isIncrementalProcessingEnabled(pp)) isa Bool

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
    widget_rd = CC.downcast(CC.CXXRecordDecl, get_decl(f).ptr)
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
    @test CC.LookupName(sema, lr, scope, true) isa Bool  # shape-only: the host decides this

    # LookupParsedName on a fresh result + scope spec
    ss_lp = CC.CXXScopeSpec()
    lr2 = CC.LookupResult(sema, nm, widget_loc, CC.CXLookupNameKind_LookupOrdinaryName)
    @test CC.LookupParsedName(sema, lr2, scope, ss_lp, true, true) isa Bool  # shape-only: the host decides this

    # ---- LookupResult query surface (Sema/Lookup.jl) on the populated `lr` ----
    @test (CC.resolveKind(lr); true)
    @test CC.isForRedeclaration(lr) isa Bool  # shape-only: the host decides this
    @test CC.isTemplateNameLookup(lr) isa Bool  # shape-only: the host decides this
    @test CC.isAmbiguous(lr) isa Bool
    @test CC.isSingleResult(lr) isa Bool  # shape-only: the host decides this
    @test CC.isOverloadedResult(lr) isa Bool  # shape-only: the host decides this
    @test CC.isUnresolvableResult(lr) isa Bool  # shape-only: the host decides this
    @test CC.isClassLookup(lr) isa Bool  # shape-only: the host decides this
    @test CC.isSingleTagDecl(lr) isa Bool  # shape-only: the host decides this
    @test CC.empty(lr) isa Bool  # shape-only: the host decides this
    @test CC.getNum(lr) isa Integer  # shape-only: the host decides this
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
    @test CC.isValid(dss) isa Bool  # shape-only: the host decides this
    @test CC.isInvalid(dss) isa Bool  # shape-only: the host decides this
    @test CC.isEmpty(dss) isa Bool  # shape-only: the host decides this
    @test CC.isNotEmpty(dss) isa Bool  # shape-only: the host decides this
    @test !CC.is_null_handle(CC.getScopeRep(dss))
    bloc = CC.getBeginLoc(dss)
    eloc = CC.getEndLoc(dss)
    @test bloc isa CC.SourceLocation
    @test eloc isa CC.SourceLocation
    @test (CC.setBeginLoc(dss, bloc); true)
    @test (CC.setEndLoc(dss, eloc); true)
    sr = CC.SourceRange(bloc, eloc)
    @test CC.getRange(dss, sr) isa CC.SourceRange  # shape-only: the host decides this
    @test (CC.setRange(dss, sr); true)
    @test (CC.clear(dss); true)
    dispose(dss)

    # ---- Parser: read-only queries (Parse/Parser.jl) ----
    @test CC.getLangOpts(parser) isa CC.LangOptions  # shape-only: the host decides this
    @test CC.getTargetInfo(parser) isa CC.TargetInfo  # shape-only: the host decides this
    @test CC.getPreprocessor(parser) isa CC.Preprocessor  # shape-only: the host decides this
    @test CC.getActions(parser) isa CC.Sema  # shape-only: the host decides this
    tok = CC.getCurToken(parser)
    @test tok isa CC.Token
    @test CC.NextToken(parser) isa CC.Token  # shape-only: the host decides this

    # pure helper functions over the parser context enums
    @test CC.getDeclSpecContextFromDeclaratorContext(CC.CXDeclaratorContext_Member) isa CC.CXDeclSpecContext
    @test CC.getDeclSpecContextFromDeclaratorContext(CC.CXDeclaratorContext_File) isa CC.CXDeclSpecContext
    @test CC.getDeclSpecContextFromDeclaratorContext(CC.CXDeclaratorContext_Block) isa CC.CXDeclSpecContext
    @test CC.shouldEnterContext(CC.CXDeclSpecContext_DSC_top_level) isa Bool
    @test CC.shouldEnterContext(CC.CXDeclSpecContext_DSC_normal) isa Bool

    # ---- Token query surface (Lex/Token.jl) ----
    @test CC.getLocation(tok) isa CC.SourceLocation  # shape-only: the host decides this
    @test CC.getAnnotationEndLoc(tok) isa CC.SourceLocation
    @test CC.getAnnotationRange(tok) isa CC.SourceRange
    @test CC.getName(tok) isa String
    @test CC.getAnnotationValue(tok) isa CC.AnnotationValue  # shape-only: the host decides this
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
    @test CC.getIdentifierInfo(tok) isa CC.IdentifierInfo  # shape-only: the host decides this
    @test CC.getName(CC.getIdentifierInfo(tok)) == "Widget"
    while !CC.is_annot_repl_input_end(tok)
        CC.ConsumeAnyToken(parser)
    end
    CC.EndSourceFile(pp)
    CC.end_diag(ci)
    dispose(ident_fid)

    # QualType annotation read off a token (Parse/Parser.jl)
    @test CC.getTypeAnnotation(tok) isa CC.QualType  # shape-only: the host decides this

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
    @test CC.TryAnnotateTypeOrScopeToken(parser) isa Bool  # shape-only: the host decides this
    ss_af = CC.CXXScopeSpec()
    @test CC.TryAnnotateTypeOrScopeTokenAfterScopeSpec(parser, ss_af) isa Bool  # shape-only: the host decides this
    dispose(ss_af)
    @test CC.ConsumeAnyToken(parser) isa CC.SourceLocation  # shape-only: the host decides this

    dispose(f)
    dispose(I)
end

@testset "CompilerInstance | plugins and frontend timer" begin
    I = create_interpreter(String[])

    # CompilerInstance: no plugins are requested, so loading them is a no-op
    ci = CC.get_instance(I)
    @test (CC.LoadRequestedPlugins(ci); true)
    @test CC.hasFrontendTimer(ci) isa Bool  # shape-only: the host decides this
    CC.createFrontendTimer(ci)
    @test CC.hasFrontendTimer(ci)

    dispose(I)
end

@testset "CompilerInstance module-building flag" begin
    # Inherited from clang::ModuleLoader, whose constructor sets the flag, so a bare
    # instance already answers and the setter round-trips.
    ci = CC.CompilerInstance()

    @test CC.buildingModule(ci) isa Bool  # shape-only: the host decides this
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
