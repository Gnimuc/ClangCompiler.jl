using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl
using Test

const TLX = CC.LibClangEx
# TypeLoc payload walk: parse declarators, then getTypeLoc -> resolve ->
# per-class payload accessors. Every non-NULL TypeLoc carrier is an owned heap
# box (create -> use -> dispose); resolve hits are second boxes disposed
# independently of their source. Assertions are host-portable: isa/Bool,
# validity, counts, and same-line written-order of encoded locations.
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, DeclIterator
# Depth-first search for the first resolved child node whose carrier is `T`.
if !@isdefined(_find_node)
    function _find_node(::Type{T}, x) where {T}
        x isa T && return x
        for c in CC.subtree(x)
            r = _find_node(T, CC.resolve(c))
            r !== nothing && return r
        end
        return nothing
    end
end

@testset "payload accessors" begin
    I = create_interpreter(String[])
    CC.parse(I, """
        int gi = 0;
        int *tp = &gi;
        int &lref = gi;
        int &&rref = 0;
        struct SBox { int fld; };
        int SBox::*mptr = &SBox::fld;
        int garr[7];
        int gfn(int a, double b);
        int (*pfn)(int) = nullptr;
        const int cqi = 1;
        template <typename T> struct TplBox { T v; };
        TplBox<int> tbox;
        struct SBox sval;
        int *_Nonnull nnp = &gi;
    """)
    f = DeclFinder(I)

    function tl_of(name)
        @assert f(I, name) "lookup failed: $name"
        return CC.getTypeLoc(CC.getTypeSourceInfo(CC.DeclaratorDecl(get_decl(f).ptr)))
    end

    # pointer declarator: star loc + pointee chain
    tl = tl_of("tp")
    @test !CC.isNull(tl)
    @test CC.getTypeLocClass(tl) == TLX.CXTypeLocClass_Pointer
    ptl = CC.resolve(tl)
    @test ptl isa CC.PointerTypeLoc
    @test CC.isValid(CC.getStarLoc(ptl))
    @test CC.getSourceRange(ptl) isa CC.SourceRange    # base method on a carrier
    miss = CC.ArrayTypeLoc(ptl)                        # class mismatch -> NULL carrier
    @test miss.ptr == C_NULL
    nxt = CC.getNextTypeLoc(ptl)
    btl = CC.resolve(nxt)
    @test btl isa CC.BuiltinTypeLoc
    @test CC.isValid(CC.getBuiltinLoc(btl))
    CC.dispose(btl)
    CC.dispose(nxt)
    CC.dispose(ptl)
    CC.dispose(tl)

    # references: amp / amp-amp sigils
    tl = tl_of("lref")
    lv = CC.resolve(tl)
    @test lv isa CC.LValueReferenceTypeLoc
    @test CC.isValid(CC.getAmpLoc(lv))
    CC.dispose(lv)
    CC.dispose(tl)

    tl = tl_of("rref")
    rv = CC.resolve(tl)
    @test rv isa CC.RValueReferenceTypeLoc
    @test CC.isValid(CC.getAmpAmpLoc(rv))
    CC.dispose(rv)
    CC.dispose(tl)

    # member pointer
    tl = tl_of("mptr")
    mp = CC.resolve(tl)
    @test mp isa CC.MemberPointerTypeLoc
    @test CC.isValid(CC.getStarLoc(mp))
    CC.dispose(mp)
    CC.dispose(tl)

    # array: brackets + size expression
    tl = tl_of("garr")
    ar = CC.resolve(tl)
    @test ar isa CC.ArrayTypeLoc
    lb = CC.getLBracketLoc(ar)
    rb = CC.getRBracketLoc(ar)
    @test CC.isValid(lb) && CC.isValid(rb)
    @test UInt(lb.ptr) < UInt(rb.ptr)    # [ is written before ]
    sz = CC.getSizeExpr(ar)
    szr = CC.resolve(sz)
    @test szr isa CC.IntegerLiteral || szr isa CC.ConstantExpr
    CC.dispose(ar)
    CC.dispose(tl)

    # function: params + parens + local range
    @assert f(I, "gfn")
    fd = CC.FunctionDecl(get_decl(f).ptr)
    tl = CC.getTypeLoc(CC.getTypeSourceInfo(fd))
    fn = CC.resolve(tl)
    @test fn isa CC.FunctionTypeLoc
    @test CC.getNumParams(fn) == 2
    p0 = CC.getParam(fn, 0)
    p1 = CC.getParam(fn, 1)
    @test p0 isa CC.ParmVarDecl && p1 isa CC.ParmVarDecl
    @test CC.getName(p0) == "a"
    @test CC.getName(p1) == "b"
    lp = CC.getLParenLoc(fn)
    rp = CC.getRParenLoc(fn)
    @test CC.isValid(lp) && CC.isValid(rp)
    @test UInt(lp.ptr) < UInt(rp.ptr)
    @test CC.isValid(CC.getLocalRangeBegin(fn))
    @test CC.isValid(CC.getLocalRangeEnd(fn))
    CC.dispose(fn)
    CC.dispose(tl)

    # parens around a declarator + IgnoreParens
    tl = tl_of("pfn")
    pp = CC.resolve(tl)
    @test pp isa CC.PointerTypeLoc
    inner = CC.getNextTypeLoc(pp)
    pr = CC.resolve(inner)
    @test pr isa CC.ParenTypeLoc
    @test CC.isValid(CC.getLParenLoc(pr)) && CC.isValid(CC.getRParenLoc(pr))
    unp = CC.IgnoreParens(pr)
    @test unp isa CC.TypeLoc
    @test CC.getTypeLocClass(unp) == TLX.CXTypeLocClass_FunctionProto
    CC.dispose(unp)
    CC.dispose(pr)
    CC.dispose(inner)
    CC.dispose(pp)
    CC.dispose(tl)

    # qualified: const int
    tl = tl_of("cqi")
    @test CC.getTypeLocClass(tl) == TLX.CXTypeLocClass_Qualified
    q = CC.resolve(tl)
    @test q isa CC.QualifiedTypeLoc
    uq = CC.getUnqualifiedLoc(q)
    @test uq isa CC.TypeLoc
    @test CC.getTypeLocClass(uq) == TLX.CXTypeLocClass_Builtin
    uq2 = CC.getUnqualifiedLoc(tl)    # base-level qualifier skip on the same box
    @test CC.getTypeLocClass(uq2) == TLX.CXTypeLocClass_Builtin
    CC.dispose(uq2)
    CC.dispose(uq)
    CC.dispose(q)
    CC.dispose(tl)

    # template specialization (written under elaborated sugar, no keyword)
    tl = tl_of("tbox")
    el = CC.resolve(tl)
    @test el isa CC.ElaboratedTypeLoc
    @test CC.is_null_handle(CC.getElaboratedKeywordLoc(el))
    nxt2 = CC.getNextTypeLoc(el)
    ts = CC.resolve(nxt2)
    @test ts isa CC.TemplateSpecializationTypeLoc
    @test CC.getNumArgs(ts) == 1
    @test CC.isValid(CC.getTemplateNameLoc(ts))
    la = CC.getLAngleLoc(ts)
    ra = CC.getRAngleLoc(ts)
    @test CC.isValid(la) && CC.isValid(ra)
    @test UInt(la.ptr) < UInt(ra.ptr)
    CC.dispose(ts)
    CC.dispose(nxt2)
    CC.dispose(el)
    CC.dispose(tl)

    # elaborated with keyword -> record name loc through TypeSpecTypeLoc
    tl = tl_of("sval")
    se = CC.resolve(tl)
    @test se isa CC.ElaboratedTypeLoc
    @test CC.isValid(CC.getElaboratedKeywordLoc(se))
    rn = CC.getNextTypeLoc(se)
    @test CC.getTypeLocClass(rn) == TLX.CXTypeLocClass_Record
    tspec = CC.resolve(rn)
    @test tspec isa CC.TypeSpecTypeLoc
    @test CC.isValid(CC.getNameLoc(tspec))
    CC.dispose(tspec)
    CC.dispose(rn)
    CC.dispose(se)
    CC.dispose(tl)

    # attributed: nullability sugar over the pointer
    tl = tl_of("nnp")
    @test CC.getTypeLocClass(tl) == TLX.CXTypeLocClass_Attributed
    at = CC.resolve(tl)
    @test at isa CC.AttributedTypeLoc
    attr = CC.getAttr(at)
    @test attr isa CC.Attr
    @test attr.ptr != C_NULL
    @test !isempty(CC.getSpelling(attr))
    mloc = CC.getModifiedLoc(at)
    @test CC.getTypeLocClass(mloc) == TLX.CXTypeLocClass_Pointer
    CC.dispose(mloc)
    CC.dispose(at)
    CC.dispose(tl)

    dispose(f)
    dispose(I)
end

@testset "TypeLoc resolve and navigation" begin
    I = create_interpreter(String[])
    CC.parse(I, "int *tlp;")
    f = DeclFinder(I)
    @test f(I, "tlp")
    vd = CC.VarDecl(get_decl(f).ptr)
    tl = CC.getTypeLoc(CC.getTypeSourceInfo(vd))   # owned box
    @test tl isa CC.TypeLoc
    @test !CC.isNull(tl)
    @test CC.resolve(CC.getTypePtr(CC.getType(tl))) isa CC.PointerType
    @test CC.getSourceRange(tl) isa CC.SourceRange  # shape-only
    @test !CC.is_null_handle(CC.getBeginLoc(tl))

    nxt = CC.getNextTypeLoc(tl)                     # the pointee (int) loc; owned box
    @test CC.resolve(CC.getTypePtr(CC.getType(nxt))) isa CC.BuiltinType
    CC.dispose(nxt)
    CC.dispose(tl)
    dispose(f)
    dispose(I)
end
