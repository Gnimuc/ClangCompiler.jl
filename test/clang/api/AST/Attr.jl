using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, DeclIterator
using Test

const LX = CC.LibClangEx
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, DeclIterator
# Depth-first search for the first resolved child node whose carrier is `T`.
if !@isdefined(_find_node)
    function _find_node(::Type{T}, x) where {T}
        x isa T && return x
        for c in CC.children(x)
            r = _find_node(T, CC.resolve(c))
            r !== nothing && return r
        end
        return nothing
    end
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
             #pragma pack(2)
             struct SPack2 { char c; int i; };
             #pragma pack()
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
    @test !(CC.isInherited(dep))
    @test !CC.isPackExpansion(dep)
    @test !CC.is_null_handle(CC.getLocation(dep))
    @test CC.isValid((CC.getRange(dep)).begin_loc)
    @test CC.isValid((CC.getRange(dep)).end_loc)

    # stamped predicates and casts: `isa<T>` beside `cast<T>`, and the cast names both
    # classes when it refuses rather than handing back a carrier over nothing
    base = CC.getAttrs(look("gdep"))[1]
    @test base isa CC.Attr
    @test CC.isDeprecatedAttr(base)
    @test !CC.isSectionAttr(base)
    @test CC.DeprecatedAttr(base) == dep
    @test_throws CC.CastError CC.SectionAttr(base)

    # DeprecatedAttr payload round-trip
    @test CC.getMessage(dep) == "dep-msg"
    @test CC.getReplacement(dep) == "use_this"

    # AlignedAttr: alignas(32) is an expression payload; getAlignment is in bits
    ali = findattr(look("gali"), CC.AlignedAttr)
    @test ali isa CC.AbstractInheritableAttr
    @test CC.isAlignmentExpr(ali)
    @test CC.getAlignmentExpr(ali).ptr != C_NULL
    @test CC.getAlignment(ali, ctx) == 32 * 8

    # MaxFieldAlignmentAttr: `#pragma pack(2)` in bytes, reported in bits like AlignedAttr.
    # `struct SPacked`'s __attribute__((packed)) is a different attribute and leaves none.
    mfa = findattr(look("SPack2"), CC.MaxFieldAlignmentAttr)
    @test CC.getAlignment(mfa) == 2 * 8
    @test !any(a -> a isa CC.MaxFieldAlignmentAttr, resolved_attrs(look("SPacked")))

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
    @test CC.getIsLiteralLabel(asml)

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
    rd = CC.getDefinition(CC.RecordDecl(look("SPacked")))
    @test any(a -> a isa CC.PackedAttr, resolved_attrs(rd))

    # UsedAttr (marker attribute; classification only)
    @test any(a -> a isa CC.UsedAttr, resolved_attrs(look("gused")))

    # CleanupAttr lives on a local variable: walk the function body to it
    fd = CC.FunctionDecl(look("cfn"))
    body = CC.resolve(CC.getBody(fd))
    ds = nothing
    for k in CC.children(body)
        k isa CC.DeclStmt && (ds=k; break)
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

@testset "Attributes (Decl::getAttrs)" begin
    I = create_interpreter(String[])
    CC.parse(I, "int __attribute__((aligned(16), deprecated)) gattr;")
    f = DeclFinder(I)
    @test f(I, "gattr")
    d = get_decl(f)
    @test CC.hasAttrs(d)
    @test CC.getNumAttrs(d) == 2
    attrs = CC.getAttrs(d)
    @test length(attrs) == 2
    @test all(a -> a isa CC.Attr, attrs)
    spellings = [CC.getSpelling(a) for a in attrs]
    @test "aligned" in spellings
    @test "deprecated" in spellings
    @test CC.getKind(attrs[1]) == CC.LibClangEx.CXAttrKind_Aligned
    @test !CC.isImplicit(attrs[1])
    @test !CC.is_null_handle(CC.getLocation(attrs[1]))

    @test f(I, "gattr")   # a decl with no attrs
    CC.parse(I, "int noattr;")
    @test f(I, "noattr")
    @test !CC.hasAttrs(get_decl(f))
    @test isempty(CC.getAttrs(get_decl(f)))

    dispose(f)
    dispose(I)
end

@testset "stamped Attr predicate/cast surface" begin
    I = create_interpreter(String[])
    CC.parse(I, "[[noreturn]] void ce2_f();")
    f = DeclFinder(I)
    @test f(I, "ce2_f")
    fd = CC.FunctionDecl(get_decl(f))
    attrs = CC.getAttrs(fd)
    @test length(attrs) == 1
    a = attrs[1]
    # `getAttrs` hands out base-typed carriers, so `a`'s Julia type says nothing about the
    # node's class; `resolve` is what asks clang which class it is.
    r = CC.resolve(a)
    @test r isa CC.CXX11NoReturnAttr

    npred = ncast = nmatch = 0
    for nm in names(CC; all=true)
        isdefined(CC, nm) || continue
        v = getproperty(CC, nm)
        if v isa Function && !(v isa Type) && startswith(String(nm), "is") &&
           hasmethod(v, Tuple{CC.Attr})
            @test v(a) isa Bool
            npred += 1
        elseif v isa Type && v != CC.Attr && hasmethod(v, Tuple{CC.Attr}) &&
               # exact stamped-cast signature — every struct also has the
               # implicit converting constructor, whose sig is (::Type, ::Any)
               which(v, Tuple{CC.Attr}).sig <: Tuple{Type,CC.AbstractAttr}
            # The predicate and the cast are one question asked twice, `isa<T>` and `cast<T>`
            # off the same `classof` — and the Julia abstract mirroring that class is a third
            # spelling of it. Holding all three against each other for every attribute class
            # is what says the generated hierarchy matches the one clang actually has.
            absT = isdefined(CC, Symbol("Abstract", nm)) ? getproperty(CC, Symbol("Abstract", nm)) :
                   nothing
            if getproperty(CC, Symbol("is", nm))(a)
                absT === nothing || @test r isa absT
                @test v(a) == a                  # narrows to the same clang::Attr
                nmatch += 1
            else
                absT === nothing || @test !(r isa absT)
                @test_throws CC.CastError v(a)   # refused by name, not by a null carrier
            end
            ncast += 1
        end
    end
    @test npred >= 390
    @test ncast >= 390
    # exactly one of the 396 stamped classes accepts it. AttrList.inc names only the leaves,
    # so the abstract bases carry no stamped cast to match — the Julia mirror still has them,
    # which is what the second assertion says.
    @test nmatch == 1
    @test r isa CC.AbstractInheritableAttr

    dispose(f)
    dispose(I)
end
