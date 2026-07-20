using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl
using Test

const LX = CC.LibClangEx

@testset "Attr hierarchy table" begin
    # every table entry produced a carrier subtyping its category abstract
    for node in CC.ATTR_NODES
        T = getfield(CC, CC.attr_carrier_name(node.name))
        A = getfield(CC, CC.attr_category_name(node.category))
        @test T <: A
        @test A <: CC.AbstractAttr
    end
    # every attribute kind has a carrier in the resolve map
    @test length(CC.ATTR_KIND_TO_TYPE) == length(CC.ATTR_NODES)
    @test CC.Attr <: CC.AbstractAttr
end

@testset "Attr classification & payload" begin
    I = create_interpreter(["-std=c++20"])
    f = DeclFinder(I)
    ctx = CC.get_ast_context(I)
    CC.parse(I,
             """
             int gdep __attribute__((deprecated("dep-msg", "use_this")));
             alignas(32) int gali;
             int gsec __attribute__((section("__DATA,__mysec")));
             [[noreturn]] void nofunc();
             int fasm(int) asm("real_fasm");
             int gann __attribute__((annotate("my-note")));
             __attribute__((constructor(200))) void ctorfn();
             __attribute__((destructor(201))) void dtorfn();
             int gunavail __attribute__((unavailable("gone-msg")));
             __attribute__((format(printf, 1, 2))) void logfn(const char *fmt, ...);
             void nnfn(int *a, int *b) __attribute__((nonnull(2)));
             [[nodiscard("check-me")]] int mustuse();
             struct __attribute__((packed)) SPacked { char c; int i; };
             __attribute__((used)) static int gused = 1;
             void cleanup_fn(int *p);
             void cfn() { int lc __attribute__((cleanup(cleanup_fn))) = 0; (void)lc; }
             thread_local int gtls __attribute__((tls_model("initial-exec")));
             __attribute__((visibility("hidden"))) void vfunc();
             """)

    look(name) = (@assert f(I, name) "lookup failed: $name"; get_decl(f))
    resolved_attrs(d) = [CC.resolve(a) for a in CC.getAttrs(d)]
    function findattr(d, T)
        as = resolved_attrs(d)
        i = findfirst(a -> a isa T, as)
        @assert i !== nothing "no $T on the decl"
        return as[i]
    end

    # base accessors through the retyped AbstractAttr receivers, on a resolved carrier
    dep = findattr(look("gdep"), CC.DeprecatedAttr)
    @test CC.getKind(dep) == LX.CXAttrKind_Deprecated
    @test CC.get_attr_kind(dep) == LX.CXAttrKind_Deprecated
    @test CC.getSpelling(dep) == "deprecated"
    @test CC.get_attr_spelling(dep) == "deprecated"
    @test !CC.isImplicit(dep)
    @test CC.isInherited(dep) isa Bool
    @test !CC.isPackExpansion(dep)
    @test CC.getLocation(dep) isa CC.SourceLocation
    @test CC.getRange(dep) isa CC.SourceRange

    # stamped predicates and casts (base carrier in, dyn_cast_or_null semantics out)
    base = CC.getAttrs(look("gdep"))[1]
    @test base isa CC.Attr
    @test CC.isDeprecatedAttr(base)
    @test !CC.isSectionAttr(base)
    @test CC.DeprecatedAttr(base).ptr != C_NULL
    @test CC.SectionAttr(base).ptr == C_NULL

    # DeprecatedAttr payload round-trip
    @test CC.getMessage(dep) == "dep-msg"
    @test CC.getReplacement(dep) == "use_this"

    # AlignedAttr: alignas(32) is an expression payload; getAlignment is in bits
    ali = findattr(look("gali"), CC.AlignedAttr)
    @test ali isa CC.AbstractInheritableAttr
    @test CC.isAlignmentExpr(ali)
    @test CC.getAlignmentExpr(ali).ptr != C_NULL
    @test CC.getAlignment(ali, ctx) == 32 * 8

    # SectionAttr
    @test CC.getName(findattr(look("gsec"), CC.SectionAttr)) == "__DATA,__mysec"

    # CXX11NoReturnAttr (marker attribute; classification only). The GNU
    # __attribute__((noreturn)) spelling is absorbed into the function type and
    # leaves no decl attribute — only [[noreturn]] produces one.
    @test any(a -> a isa CC.CXX11NoReturnAttr, resolved_attrs(look("nofunc")))
    @test CC.isCXX11NoReturnAttr(CC.getAttrs(look("nofunc"))[1])

    # AsmLabelAttr
    asml = findattr(look("fasm"), CC.AsmLabelAttr)
    @test CC.getLabel(asml) == "real_fasm"
    @test CC.getIsLiteralLabel(asml) isa Bool

    # AnnotateAttr
    ann = findattr(look("gann"), CC.AnnotateAttr)
    @test CC.getAnnotation(ann) == "my-note"
    @test CC.args_size(ann) == 0

    # Constructor/Destructor priorities
    @test CC.getPriority(findattr(look("ctorfn"), CC.ConstructorAttr)) == 200
    @test CC.getPriority(findattr(look("dtorfn"), CC.DestructorAttr)) == 201

    # UnavailableAttr
    @test CC.getMessage(findattr(look("gunavail"), CC.UnavailableAttr)) == "gone-msg"

    # FormatAttr
    fmt = findattr(look("logfn"), CC.FormatAttr)
    @test CC.getName(CC.getType(fmt)) == "printf"
    @test CC.getFormatIdx(fmt) == 1
    @test CC.getFirstArg(fmt) == 2

    # NonNullAttr: nonnull(2) covers AST parameter index 1 only
    nn = findattr(look("nnfn"), CC.NonNullAttr)
    @test CC.args_size(nn) == 1
    @test CC.isNonNull(nn, 1)
    @test !CC.isNonNull(nn, 0)

    # WarnUnusedResultAttr ([[nodiscard("...")]])
    @test CC.getMessage(findattr(look("mustuse"), CC.WarnUnusedResultAttr)) == "check-me"

    # PackedAttr on the record definition (marker attribute; classification only)
    rd = CC.getDefinition(CC.RecordDecl(look("SPacked").ptr))
    @test any(a -> a isa CC.PackedAttr, resolved_attrs(rd))

    # UsedAttr (marker attribute; classification only)
    @test any(a -> a isa CC.UsedAttr, resolved_attrs(look("gused")))

    # CleanupAttr lives on a local variable: walk the function body to it
    fd = CC.FunctionDecl(look("cfn").ptr)
    body = CC.resolve(CC.getBody(fd))
    ds = nothing
    for k in CC.children(body)
        k isa CC.DeclStmt && (ds = k; break)
    end
    @assert ds !== nothing "no DeclStmt in cfn's body"
    lvar = CC.resolve(CC.getSingleDecl(ds))
    cl = findattr(lvar, CC.CleanupAttr)
    cfd = CC.getFunctionDecl(cl)
    @test cfd isa CC.FunctionDecl
    @test cfd.ptr != C_NULL
    @test CC.getName(cfd) == "cleanup_fn"

    # TLSModelAttr
    @test CC.getModel(findattr(look("gtls"), CC.TLSModelAttr)) == "initial-exec"

    # VisibilityAttr (mirrored class-local enum)
    @test CC.getVisibility(findattr(look("vfunc"), CC.VisibilityAttr)) ==
          LX.CXVisibilityAttr_Hidden

    dispose(f)
    dispose(I)
end
