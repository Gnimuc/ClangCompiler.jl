using ClangCompiler
using ClangCompiler: LLVM
using ClangCompiler: create_interpreter, dispose
using ClangCompiler: clty_to_jlty, jlty_to_clty
using ClangCompiler: get_ast_context, get_codegen_module, convertTypeForMemory
using Test
import ClangCompiler as CC

CC.clty_to_jlty(x::CC.VoidTy) = Cvoid
CC.clty_to_jlty(x::CC.BoolTy) = Bool
CC.clty_to_jlty(x::CC.CharTy) = Cuchar
CC.clty_to_jlty(x::CC.WCharTy) = Cwchar_t
CC.clty_to_jlty(x::CC.WideCharTy) = Cwchar_t
CC.clty_to_jlty(x::CC.SignedCharTy) = Cchar
CC.clty_to_jlty(x::CC.ShortTy) = Cshort
CC.clty_to_jlty(x::CC.IntTy) = Cint
CC.clty_to_jlty(x::CC.LongTy) = Clong
CC.clty_to_jlty(x::CC.LongLongTy) = Clonglong
CC.clty_to_jlty(x::CC.Int128Ty) = Int128
CC.clty_to_jlty(x::CC.UnsignedCharTy) = Cuchar
CC.clty_to_jlty(x::CC.UnsignedShortTy) = Cushort
CC.clty_to_jlty(x::CC.UnsignedIntTy) = Cuint
CC.clty_to_jlty(x::CC.UnsignedLongTy) = Culong
CC.clty_to_jlty(x::CC.UnsignedLongLongTy) = Culonglong
CC.clty_to_jlty(x::CC.UnsignedInt128Ty) = UInt128
CC.clty_to_jlty(x::CC.FloatTy) = Cfloat
CC.clty_to_jlty(x::CC.DoubleTy) = Cdouble
CC.clty_to_jlty(x::CC.Float16Ty) = Float16
CC.clty_to_jlty(x::CC.HalfTy) = Float16
CC.clty_to_jlty(x::CC.BFloat16Ty) = Float16
CC.clty_to_jlty(x::CC.NullPtrTy) = Ptr{Cvoid}
CC.clty_to_jlty(x::CC.VoidPtrTy) = Ptr{Cvoid}
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl
# Setter/factory coverage: round-trip setters and construct-from-live-context
# factories for the AST surface (built + self-verified by subagents).
const LX = CC.LibClangEx

@testset "convertTypeForMemory" begin
    I = create_interpreter()
    ctx = get_ast_context(I)
    cgm = get_codegen_module(I)

    i8 = LLVM.LLVMType(convertTypeForMemory(cgm, CC.BoolTy(ctx)))
    @test LLVM.width(i8) == 8

    dispose(I)
end

@testset "ASTContext type builders" begin
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)

    # ---- parse the nodes we need BEFORE mutating ASTContext singletons ----
    CC.parse(I, "int scf_gvar = 5;")
    CC.parse(I, "int scf_gfunc(int scf_p) { return scf_p; }")

    f = DeclFinder(I)
    @test f(I, "scf_gvar")
    vd = CC.VarDecl(get_decl(f).ptr)
    @test f(I, "scf_gfunc")
    fd = CC.FunctionDecl(get_decl(f).ptr)
    pvd = CC.ParmVarDecl(CC.getParamDecl(fd, 0))

    # ---- per-decl map setters: round-trip against the paired getters ----
    CC.setManglingNumber(ctx, vd, 42)
    @test CC.getManglingNumber(ctx, vd) == 42

    CC.setStaticLocalNumber(ctx, vd, 7)
    @test CC.getStaticLocalNumber(ctx, vd) == 7

    CC.setParameterIndex(ctx, pvd, 3)
    @test CC.getParameterIndex(ctx, pvd) == 3

    CC.setPrimaryMergedDecl(ctx, vd, fd)
    @test CC.getPrimaryMergedDecl(ctx, vd).ptr == fd.ptr

    CC.setcudaConfigureCallDecl(ctx, fd)
    @test CC.getcudaConfigureCallDecl(ctx).ptr == fd.ptr

    # ---- FieldDecl map: two real FieldDecls reached via getFields ----
    CC.parse(I, "struct SCFRec { int fa; int fb; };")
    @test f(I, "SCFRec")
    rd = CC.RecordDecl(get_decl(f).ptr)
    flds = CC.getFields(rd)
    @test length(flds) == 2
    CC.setInstantiatedFromUnnamedFieldDecl(ctx, flds[1], flds[2])
    @test CC.getInstantiatedFromUnnamedFieldDecl(ctx, flds[1]).ptr == flds[2].ptr

    # ---- Using / UsingShadow decls reached via the recursive decls() walk ----
    CC.parse(I,
             "struct SCFBase { void m(); void n(); }; struct SCFDer : SCFBase { using SCFBase::m; using SCFBase::n; };")
    dc = CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))
    all_decls = CC.decls(dc)

    usings = filter(d -> d isa CC.UsingDecl, all_decls)
    @test length(usings) >= 2
    CC.setInstantiatedFromUsingDecl(ctx, usings[1], usings[2])
    @test CC.getInstantiatedFromUsingDecl(ctx, usings[1]).ptr == usings[2].ptr

    shadows = filter(d -> d isa CC.UsingShadowDecl, all_decls)
    @test length(shadows) >= 2
    CC.setInstantiatedFromUsingShadowDecl(ctx, shadows[1], shadows[2])
    @test CC.getInstantiatedFromUsingShadowDecl(ctx, shadows[1]).ptr == shadows[2].ptr

    # ---- ObjC redefinition-type setters: store a QualType, read it back ----
    qt1 = CC.getIntPtrType(ctx)
    CC.setObjCIdRedefinitionType(ctx, qt1)
    @test CC.getObjCIdRedefinitionType(ctx).ptr == qt1.ptr

    qt2 = CC.getUIntPtrType(ctx)
    CC.setObjCClassRedefinitionType(ctx, qt2)
    @test CC.getObjCClassRedefinitionType(ctx).ptr == qt2.ptr

    # ---- builders: implicit record + implicit typedef ----
    rec = CC.buildImplicitRecord(ctx, "SCFImplicitRec")
    @test rec isa CC.RecordDecl
    rectype = CC.getRecordType(ctx, rec)
    tdef = CC.buildImplicitTypedef(ctx, rectype, "SCFImplicitTypedef")
    @test tdef isa CC.TypedefDecl

    # ---- CFConstantStringType: a typedef-of-record round-trips through the CF getters ----
    tdeftype = CC.getTypedefType(ctx, tdef, CC.QualType(C_NULL))
    CC.setCFConstantStringType(ctx, tdeftype)
    @test CC.getCFConstantStringTagDecl(ctx).ptr == rec.ptr
    @test CC.getCFContantStringDecl(ctx).ptr == tdef.ptr

    # ---- BOOL / FILE typedef setters ----
    CC.setBOOLDecl(ctx, tdef)
    @test CC.getBOOLDecl(ctx).ptr == tdef.ptr

    CC.setFILEDecl(ctx, tdef)
    @test CC.getFILEType(ctx).ptr == CC.getTypeDeclType(ctx, tdef).ptr

    # ---- CreateTypeSourceInfo (already-wrapped factory) ----
    tsi = CC.CreateTypeSourceInfo(ctx, qt1, 0)
    @test tsi isa CC.TypeSourceInfo

    # ---- getPredefinedStringLiteralFromCache (cache lookup) ----
    @test CC.getPredefinedStringLiteralFromCache(ctx, "no_such_key") isa CC.StringLiteral

    dispose(f)
    dispose(I)
end
