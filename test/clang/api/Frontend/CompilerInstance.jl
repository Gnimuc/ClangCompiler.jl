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
    @test CC.hasDiagnostics(ci) isa Bool
    @test CC.getDiagnostics(ci) isa CC.DiagnosticsEngine
    @test CC.getDiagnosticClient(ci) isa CC.DiagnosticConsumer
    @test CC.hasFileManager(ci) isa Bool
    @test CC.getFileManager(ci) isa CC.FileManager
    @test CC.hasSourceManager(ci) isa Bool
    @test CC.getSourceManager(ci) isa CC.SourceManager
    @test CC.hasInvocation(ci) isa Bool
    @test CC.getInvocation(ci) isa CC.CompilerInvocation
    @test CC.hasTarget(ci) isa Bool
    @test CC.getTarget(ci) isa CC.TargetInfo
    @test CC.hasPreprocessor(ci) isa Bool
    @test CC.getPreprocessor(ci) isa CC.Preprocessor
    @test CC.hasSema(ci) isa Bool
    @test CC.getSema(ci) isa CC.Sema
    @test CC.hasASTContext(ci) isa Bool
    @test CC.getASTContext(ci) isa CC.ASTContext
    @test CC.hasASTConsumer(ci) isa Bool
    @test CC.getASTConsumer(ci) isa CC.ASTConsumer

    # ---- CompilerInstance: option accessors ----
    @test CC.getCodeGenOpts(ci) isa CC.CodeGenOptions
    @test CC.getDiagnosticOpts(ci) isa CC.DiagnosticOptions
    @test CC.getFrontendOpts(ci) isa CC.FrontendOptions
    @test CC.getHeaderSearchOpts(ci) isa CC.HeaderSearchOptions
    @test CC.getPreprocessorOpts(ci) isa CC.PreprocessorOptions
    @test CC.getTargetOpts(ci) isa CC.TargetOptions
    @test CC.getLangOpts(ci) isa CC.LangOptions

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
    @test CC.isIncrementalProcessingEnabled(pp) isa Bool
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
    widget_rd = CC.CXXRecordDecl(get_decl(f).ptr)
    widget_ii = CC.getIdentifier(widget)
    widget_loc = CC.getLocation(widget)

    # ---- Sema (Sema/Sema.jl) ----
    sema = CC.get_sema(I)
    scope = CC.getCurScope(parser)
    @test (CC.PrintStats(sema); true)

    ss_tn = CC.CXXScopeSpec()
    @test CC.getTypeName(sema, widget_ii, widget_loc, scope, ss_tn) isa CC.QualType

    @test CC.LookupDefaultConstructor(sema, widget_rd) isa CC.CXXConstructorDecl
    @test CC.LookupDestructor(sema, widget_rd) isa CC.CXXDestructorDecl

    # LookupResult construction + unqualified LookupName
    nm = CC.DeclarationName(CC.get_name(ctx, "compute"))
    lr = CC.LookupResult(sema, nm, widget_loc, CC.CXLookupNameKind_LookupOrdinaryName)
    @test CC.LookupName(sema, lr, scope, true) isa Bool

    # LookupParsedName on a fresh result + scope spec
    ss_lp = CC.CXXScopeSpec()
    lr2 = CC.LookupResult(sema, nm, widget_loc, CC.CXLookupNameKind_LookupOrdinaryName)
    @test CC.LookupParsedName(sema, lr2, scope, ss_lp, true, true) isa Bool

    # ---- LookupResult query surface (Sema/Lookup.jl) on the populated `lr` ----
    @test (CC.resolveKind(lr); true)
    @test CC.isForRedeclaration(lr) isa Bool
    @test CC.isTemplateNameLookup(lr) isa Bool
    @test CC.isAmbiguous(lr) isa Bool
    @test CC.isSingleResult(lr) isa Bool
    @test CC.isOverloadedResult(lr) isa Bool
    @test CC.isUnresolvableResult(lr) isa Bool
    @test CC.isClassLookup(lr) isa Bool
    @test CC.isSingleTagDecl(lr) isa Bool
    @test CC.empty(lr) isa Bool
    @test CC.getNum(lr) isa Integer
    @test CC.getResults(lr) isa Vector
    @test CC.getRepresentativeDecl(lr) isa CC.NamedDecl
    @test CC.getLookupName(lr) isa CC.DeclarationName
    if CC.isSingleResult(lr)
        @test CC.getResult(lr) isa CC.NamedDecl
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
    @test CC.isValid(dss) isa Bool
    @test CC.isInvalid(dss) isa Bool
    @test CC.isEmpty(dss) isa Bool
    @test CC.isNotEmpty(dss) isa Bool
    @test CC.getScopeRep(dss) isa CC.NestedNameSpecifier
    bloc = CC.getBeginLoc(dss)
    eloc = CC.getEndLoc(dss)
    @test bloc isa CC.SourceLocation
    @test eloc isa CC.SourceLocation
    @test (CC.setBeginLoc(dss, bloc); true)
    @test (CC.setEndLoc(dss, eloc); true)
    sr = CC.SourceRange(bloc, eloc)
    @test CC.getRange(dss, sr) isa CC.SourceRange
    @test (CC.setRange(dss, sr); true)
    @test (CC.clear(dss); true)
    dispose(dss)

    # ---- Parser: read-only queries (Parse/Parser.jl) ----
    @test CC.getLangOpts(parser) isa CC.LangOptions
    @test CC.getTargetInfo(parser) isa CC.TargetInfo
    @test CC.getPreprocessor(parser) isa CC.Preprocessor
    @test CC.getActions(parser) isa CC.Sema
    tok = CC.getCurToken(parser)
    @test tok isa CC.Token
    @test CC.NextToken(parser) isa CC.Token

    # pure helper functions over the parser context enums
    @test CC.getDeclSpecContextFromDeclaratorContext(CC.CXDeclaratorContext_Member) isa CC.CXDeclSpecContext
    @test CC.getDeclSpecContextFromDeclaratorContext(CC.CXDeclaratorContext_File) isa CC.CXDeclSpecContext
    @test CC.getDeclSpecContextFromDeclaratorContext(CC.CXDeclaratorContext_Block) isa CC.CXDeclSpecContext
    @test CC.shouldEnterContext(CC.CXDeclSpecContext_DSC_top_level) isa Bool
    @test CC.shouldEnterContext(CC.CXDeclSpecContext_DSC_normal) isa Bool

    # ---- Token query surface (Lex/Token.jl) ----
    @test CC.getLocation(tok) isa CC.SourceLocation
    @test CC.getAnnotationEndLoc(tok) isa CC.SourceLocation
    @test CC.getAnnotationRange(tok) isa CC.SourceRange
    @test CC.getName(tok) isa String
    @test CC.getAnnotationValue(tok) isa CC.AnnotationValue
    @test CC.is_eof(tok) isa Bool
    @test CC.is_annot_repl_input_end(tok) isa Bool
    @test CC.is_identifier(tok) isa Bool
    @test CC.is_coloncolon(tok) isa Bool
    @test CC.is_annot_cxxscope(tok) isa Bool
    @test CC.is_annot_typename(tok) isa Bool
    @test CC.is_annot_template_id(tok) isa Bool
    @test CC.is_kw_enum(tok) isa Bool
    @test CC.is_kw_typename(tok) isa Bool
    # getIdentifierInfo aborts on annotation tokens; only call on a real identifier.
    if CC.is_identifier(tok)
        @test CC.getIdentifierInfo(tok) isa CC.IdentifierInfo
    end

    # QualType annotation read off a token (Parse/Parser.jl)
    @test CC.getTypeAnnotation(tok) isa CC.QualType

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
    @test CC.TryAnnotateTypeOrScopeToken(parser) isa Bool
    ss_af = CC.CXXScopeSpec()
    @test CC.TryAnnotateTypeOrScopeTokenAfterScopeSpec(parser, ss_af) isa Bool
    dispose(ss_af)
    @test CC.ConsumeAnyToken(parser) isa CC.SourceLocation

    dispose(f)
    dispose(I)
end

@testset "CompilerInstance | plugins and frontend timer" begin
    I = create_interpreter(String[])

    # CompilerInstance: no plugins are requested, so loading them is a no-op
    ci = CC.get_instance(I)
    @test (CC.LoadRequestedPlugins(ci); true)
    @test CC.hasFrontendTimer(ci) isa Bool
    CC.createFrontendTimer(ci)
    @test CC.hasFrontendTimer(ci)

    dispose(I)
end
