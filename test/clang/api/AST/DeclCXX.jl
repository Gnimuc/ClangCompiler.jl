using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl
using Test

# Setter/factory coverage: round-trip setters and construct-from-live-context
# factories for the AST surface (built + self-verified by subagents).
const LX = CC.LibClangEx
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, DeclIterator
# Depth-first search for the first resolved child node whose carrier is `T`.
function _find_node(::Type{T}, x) where {T}
    x isa T && return x
    for c in CC.children(x)
        r = _find_node(T, CC.resolve(c))
        r === nothing || return r
    end
    return nothing
end

@testset "DeclCXX/DeclTemplate setters and factories" begin
    LCE = CC.LibClangEx
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)
    tu = CC.getTranslationUnitDecl(ctx)
    dc = CC.castToDeclContext(tu)

    # Two real, distinct source locations + an identifier to feed factories/setters.
    CC.parse(I, "int aa = 1; int bb = 2;")
    f = DeclFinder(I)
    @test f(I, "aa")
    aa = CC.VarDecl(get_decl(f).ptr)
    @test f(I, "bb")
    bb = CC.VarDecl(get_decl(f).ptr)
    loc_a = CC.getLocation(aa)
    loc_b = CC.getLocation(bb)
    id_a = CC.getIdentifier(aa)
    @test loc_a.ptr != loc_b.ptr

    # ---- AccessSpecDecl: factories + loc setters ----
    asd = CC.AccessSpecDecl(ctx, LCE.CXAccessSpecifier_AS_public, dc, loc_a, loc_a)
    @test asd isa CC.AccessSpecDecl
    asd2 = CC.AccessSpecDecl(ctx, UInt(1))
    @test asd2 isa CC.AccessSpecDecl
    CC.setAccessSpecifierLoc(asd, loc_b)
    @test CC.getAccessSpecifierLoc(asd).ptr == loc_b.ptr
    CC.setColonLoc(asd, loc_a)
    @test CC.getColonLoc(asd).ptr == loc_a.ptr

    # ---- LinkageSpecDecl: factories + setters ----
    lsd = CC.LinkageSpecDecl(ctx, dc, loc_a, loc_a, LCE.CXLinkageSpecDecl_lang_c, true)
    @test lsd isa CC.LinkageSpecDecl
    @test CC.getLanguage(lsd) == LCE.CXLinkageSpecDecl_lang_c
    lsd2 = CC.LinkageSpecDecl(ctx, UInt(1))
    @test lsd2 isa CC.LinkageSpecDecl
    CC.setLanguage(lsd, LCE.CXLinkageSpecDecl_lang_cxx)
    @test CC.getLanguage(lsd) == LCE.CXLinkageSpecDecl_lang_cxx
    CC.setExternLoc(lsd, loc_b)
    @test CC.getExternLoc(lsd).ptr == loc_b.ptr
    CC.setRBraceLoc(lsd, loc_a)
    @test CC.getRBraceLoc(lsd).ptr == loc_a.ptr

    # ---- CXXRecordDecl: Create + CreateLambda ----
    rd = CC.CXXRecordDecl(ctx, LCE.CXTagTypeKind_Struct, dc, loc_a, loc_a, id_a)
    @test rd isa CC.CXXRecordDecl
    tsi = CC.getTypeSourceInfo(aa)                    # a real TypeSourceInfo (int)
    lam = CC.CXXRecordDecl(ctx, dc, tsi, loc_a, LCE.CXLambdaDependencyKind_Unknown, false,
                           LCE.CXLambdaCaptureDefault_LCD_None)
    @test lam isa CC.CXXRecordDecl
    @test CC.isLambda(lam)

    # ---- CXXBaseSpecifier: setInheritConstructors round-trip ----
    CC.parse(I, "struct BB0 { BB0(int); }; struct DD0 : BB0 { using BB0::BB0; };")
    @test f(I, "DD0")
    dd0 = CC.CXXRecordDecl(get_decl(f).ptr)
    @test CC.getNumBases(dd0) == 1
    base = CC.getBase(dd0, 0)
    CC.setInheritConstructors(base, true)
    @test CC.getInheritConstructors(base) == true
    CC.setInheritConstructors(base, false)
    @test CC.getInheritConstructors(base) == false

    # ---- CXXMethodDecl: Create (from a parsed method) + CreateDeserialized ----
    CC.parse(I, "struct Foo0 { void bar0(int); };")
    @test f(I, "Foo0")
    foo0 = CC.CXXRecordDecl(get_decl(f).ptr)
    bar0 = first(m for m in CC.getMethods(foo0) if CC.getName(m) == "bar0")
    ni = CC.getNameInfo(bar0)
    mty = CC.getType(bar0)
    mtsi = CC.getTypeSourceInfo(bar0)
    sloc = CC.getBeginLoc(bar0)
    eloc = CC.getLocation(bar0)
    md = CC.CXXMethodDecl(ctx, foo0, sloc, ni, mty, mtsi,
                          LCE.CXStorageClass_SC_None, false, false,
                          LCE.CXConstexprSpecKind_Unspecified, eloc)
    @test md isa CC.CXXMethodDecl
    md2 = CC.CXXMethodDecl(ctx, UInt(1))
    @test md2 isa CC.CXXMethodDecl

    # ---- Template factories/setters (already wrapped) reachable safely ----
    CC.parse(I, "template<class TT> struct S1 { TT x; };")
    @test f(I, "S1")
    s1 = CC.ClassTemplateDecl(get_decl(f).ptr)
    targ = CC.TemplateArgument(CC.getType(aa))        # an `int` template argument
    tal = CC.TemplateArgumentList(ctx, [targ])
    @test size(tal) == 1
    @test Base.get(tal, 0) isa CC.TemplateArgument
    ctsd = CC.ClassTemplateSpecializationDecl(ctx, s1, tal)
    @test ctsd isa CC.ClassTemplateSpecializationDecl
    @test CC.getTemplateArgs(ctsd) isa CC.TemplateArgumentList
    tal2 = CC.TemplateArgumentList(ctx, [targ])
    CC.setTemplateArgs(ctsd, tal2)
    @test size(CC.getTemplateArgs(ctsd)) == 1

    dispose(f)
    dispose(I)
end

@testset "CXXMethodDecl_Create bool round-trip" begin
    # Regression: clang_CXXMethodDecl_Create forwarded (isInline, UsesFPIntrin) in
    # reversed order, so a method created inline read back non-inline. isInlineSpecified
    # is inherited from FunctionDecl; reach it through the free primary-base upcast.
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)
    dc = CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))
    CC.parse(I, "struct MFoo { void mbar(int); };")
    f = DeclFinder(I)
    @test f(I, "MFoo")
    mfoo = CC.CXXRecordDecl(get_decl(f).ptr)
    mbar = first(m for m in CC.getMethods(mfoo) if CC.getName(m) == "mbar")
    ni = CC.getNameInfo(mbar)
    mty = CC.getType(mbar)
    mtsi = CC.getTypeSourceInfo(mbar)
    sloc = CC.getBeginLoc(mbar)
    eloc = CC.getLocation(mbar)

    # uses_fp_intrin=false, is_inline=true
    md = CC.CXXMethodDecl(ctx, mfoo, sloc, ni, mty, mtsi, LX.CXStorageClass_SC_None,
                          false, true, LX.CXConstexprSpecKind_Unspecified, eloc)
    @test md isa CC.CXXMethodDecl
    @test CC.isInlineSpecified(CC.FunctionDecl(md.ptr)) == true    # was false before the fix

    # complementary: uses_fp_intrin=false, is_inline=false
    md2 = CC.CXXMethodDecl(ctx, mfoo, sloc, ni, mty, mtsi, LX.CXStorageClass_SC_None,
                           false, false, LX.CXConstexprSpecKind_Unspecified, eloc)
    @test CC.isInlineSpecified(CC.FunctionDecl(md2.ptr)) == false

    dispose(f)
    dispose(I)
end

@testset "DeclCXX ctor initializers" begin
    I = create_interpreter(String[])
    f = DeclFinder(I)
    CC.parse(I, "struct Base { int b; }; struct Wid : Base { int m; Wid(int x) : Base(), m(x) {} };")
    @test f(I, "Wid")
    wid = CC.CXXRecordDecl(get_decl(f).ptr)
    ctor = first(c for c in CC.getCtors(wid) if CC.getNumCtorInitializers(c) == 2)
    inits = CC.getCtorInitializers(ctor)
    @test length(inits) == 2
    @test all(x -> x isa CC.CXXCtorInitializer, inits)
    @test CC.isBaseInitializer(inits[1])
    @test !CC.isMemberInitializer(inits[1])
    @test CC.getBaseClass(inits[1]) isa CC.Type_
    @test CC.isMemberInitializer(inits[2])
    @test CC.getName(CC.getMember(inits[2])) == "m"
    @test CC.getInit(inits[2]) isa CC.Expr_
    dispose(f)
    dispose(I)
end
