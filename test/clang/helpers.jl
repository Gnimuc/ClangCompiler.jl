using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_tag
using Test

# Exercises the middle-level snake_case helpers scattered across
# src/clang/{ast,basic,frontend,sema,stmt,decl,lex,parse,utils}.jl and
# src/{parse,utils}.jl — the files with no dedicated test correspondent.

@testset "coverage tail: helpers" begin
    I = create_interpreter(String[])
    CC.parse(I, """
    namespace CovHelpNS { struct CovHelpInner { int z; }; }
    struct CovHelpRec { int a; int b; };
    int covhelp_fn(int x) { int y = x + 1; return y; }
    int covhelp_gv = 7;
    """)

    ci = CC.get_instance(I)

    # ---- src/clang/frontend.jl ----
    ctx = CC.get_ast_context(ci)
    @test ctx.ptr == CC.getASTContext(ci).ptr
    CC.print_stats_all(ci)  # also runs print_stats_options/print_stats_modules

    # ---- src/clang/lex.jl ----
    pp = CC.getPreprocessor(ci)
    @test (CC.enable_incremental(pp); CC.is_incremental(pp)) == true

    # ---- src/clang/parse.jl ----
    parser = CC.get_parser(I)
    @test CC.get_target(parser).ptr == CC.getTarget(ci).ptr

    # ---- reach a FunctionDecl ----
    f = DeclFinder(I)
    @test f(I, "covhelp_fn")
    fd = CC.FunctionDecl(get_decl(f))

    # ---- src/clang/sema.jl: LookupResult predicates on the finder's populated result ----
    # DeclFinder uses LookupOrdinaryName, so these two flags stay off; the setters
    # that flip them (and the class-member lookup that would turn is_class_lookup
    # on) live in test/clang/api/Sema/Lookup.jl.
    lr = f.result
    @test CC.is_template_name(lr) == false
    @test CC.is_ambiguous(lr) == false
    @test CC.is_overloaded(lr) == false
    @test CC.is_class_lookup(lr) == false

    # ---- src/clang/ast.jl: Decl helpers ----
    # both overloads must reach the same context the interpreter built; a neighbouring
    # getter returning a well-typed empty carrier would satisfy `isa` and fail this
    @test CC.get_ast_context(fd).ptr == ctx.ptr
    @test CC.get_ast_context(CC.castToDeclContext(fd)).ptr == ctx.ptr
    loc = CC.get_loc(fd)
    @test CC.isValid(CC.get_begin_loc(fd))
    @test CC.isValid(CC.get_end_loc(fd))
    @test CC.isValid(loc)

    # DeclarationName helpers
    dn = CC.getDeclName(fd)
    @test CC.get_name(dn) == "covhelp_fn"
    @test CC.is_empty(dn) == false
    @test CC.is_empty(CC.DeclarationName()) == true

    # ---- src/clang/decl.jl ----
    @test CC.get_decl_kind_name(fd) == "Function"

    # ---- src/clang/stmt.jl ----
    body = CC.getBody(fd)
    @test CC.get_stmt_class_name(body) == "CompoundStmt"
    CC.dump_ast(body)  # writes the AST dump to stderr

    # ---- src/clang/ast.jl: ASTContext helpers ----
    it = CC.get_identifier_table(ctx)
    @test it.ptr == CC.getIdents(ctx).ptr
    @test CC.getName(CC.get_name(it, "covhelp_fn")) == "covhelp_fn"

    qt_int = CC.get_qual_type(CC.IntTy(ctx))
    @test CC.get_name(CC.get_pointer_type(ctx, qt_int)) == "int *"
    @test CC.get_name(CC.get_lvalue_reference_type(ctx, qt_int)) == "int &"
    @test CC.size_of(ctx, qt_int) > 0

    @test f(I, "CovHelpRec")
    rd = CC.CXXRecordDecl(get_tag(f))
    @test CC.get_name(CC.get_decl_type(ctx, rd)) == "struct CovHelpRec"
    @test CC.get_name(CC.get_decl_type(ctx, rd, rd)) == "struct CovHelpRec"  # prev's TypeForDecl set by the call above

    # dump(::CXXScopeSpec) via a populated scope spec
    dss = CC.CXXScopeSpec()
    tail = CC.parse_cxx_scope_spec(I, dss, "CovHelpNS::CovHelpInner")
    @test tail == "CovHelpInner"
    @test CC.isValid(dss)
    CC.dump(dss)  # writes to stderr
    dispose(dss)

    # ---- src/clang/basic.jl ----
    sm = CC.getSourceManager(ci)
    fid = CC.getMainFileID(sm)
    @test CC.value(fid) != 0  # shape-only: the host decides the FileID encoding; zero is the invalid id
    dispose(fid)
    @test CC.value(loc) != 0  # shape-only: the host decides the location encoding; zero is the invalid loc
    sr = CC.getSourceRange(fd)
    @test CC.isValid(CC.get_begin_loc(sr))
    @test CC.isValid(CC.get_end_loc(sr))
    @test CC.isValid(CC.get_main_file_end_loc(sm))

    # ---- src/clang/utils.jl: get_string(Ptr{CXStringSet}) NULL path (fully controlled) ----
    @test CC.get_string(Ptr{CC.CXStringSet}(C_NULL)) == String[]

    # ---- api/Sema/Sema.jl + api/AST/ASTConsumer.jl on the interpreter's own codegen ----
    # A CodeGenerator is an ASTConsumer (primary base), and per-PTU incremental parsing
    # itself calls HandleTranslationUnit on it, so one extra call is a benign finalize.
    sema = CC.get_sema(I)
    cg = CC.getCodeGen(I.interp)
    CC.processWeakTopLevelDecls(sema, cg)  # no #pragma weak decls -> no-op
    CC.HandleTranslationUnit(cg, ctx)

    dispose(f)
    dispose(I)

    # ---- src/utils.jl: LLVM helpers on a self-built module/engine ----
    llctx = CC.LLVM.Context()
    ft = CC.LLVM.FunctionType(CC.LLVM.VoidType())
    mod1 = CC.LLVM.Module("covhelp_mod1")
    CC.LLVM.Function(mod1, "covhelp_llfn", ft)
    @test CC.LLVM.name(CC.lookup_function(mod1, "covhelp_llfn")) == "covhelp_llfn"

    mod2 = CC.LLVM.Module("covhelp_mod2")
    CC.LLVM.Function(mod2, "covhelp_llfn2", ft)
    ee = CC.LLVM.Interpreter(mod2)  # takes ownership of mod2
    CC.link_crt(ee)  # no static ctors -> no-op
    CC.LLVM.dispose(ee)
    CC.LLVM.dispose(mod1)
    CC.LLVM.dispose(llctx)
end

@testset "repaired string and LLVM helpers" begin
    I = create_interpreter(String[])
    CC.parse(I, "int chf_g = 1;")
    f = DeclFinder(I)

    @test f(I, "chf_g")
    nd = get_decl(f)
    @test CC.get_string(CC.getDeclName(nd)) == "chf_g"

    sm = CC.getSourceManager(CC.get_instance(I))
    loc = CC.getLocation(nd)
    @test !isempty(CC.get_string(loc, sm))

    dispose(f)
    dispose(I)

    # lookup_function on an ExecutionEngine (needs a defined function — the
    # engine does not materialize bare declarations)
    llctx = CC.LLVM.Context()
    ft = CC.LLVM.FunctionType(CC.LLVM.VoidType())
    mod = CC.LLVM.Module("chf_mod")
    fn = CC.LLVM.Function(mod, "chf_llfn", ft)
    bb = CC.LLVM.BasicBlock(fn, "entry")
    builder = CC.LLVM.IRBuilder()
    CC.LLVM.position!(builder, bb)
    CC.LLVM.ret!(builder)
    CC.LLVM.dispose(builder)
    ee = CC.LLVM.Interpreter(mod)
    @test CC.LLVM.name(CC.lookup_function(ee, "chf_llfn")) == "chf_llfn"
    CC.LLVM.dispose(ee)
    CC.LLVM.dispose(llctx)
end
