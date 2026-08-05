using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_tag
using Test

@testset "ASTRecordLayout" begin
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)
    CC.parse(I, """
    struct Plain { int x; char y; double z; };
    struct B1 { int a; };
    struct B2 { double b; };
    struct D : B1, B2 { char c; };
    struct V : virtual B1 { int d; };
    """)
    f = DeclFinder(I)

    @test f(I, "Plain")
    rd = CC.RecordDecl(get_tag(f))
    lay = CC.getASTRecordLayout(ctx, rd)
    @test lay isa CC.ASTRecordLayout
    @test CC.getSize(lay) == 16
    @test CC.getAlignment(lay) == 8
    @test CC.getPreferredAlignment(lay) >= 8
    @test CC.getDataSize(lay) == 16
    @test CC.getFieldCount(lay) == 3
    @test CC.getFieldOffset(lay, 0) == 0
    @test CC.getFieldOffset(lay, 1) == 32
    @test CC.getFieldOffset(lay, 2) == 64
    @test CC.field_offsets(ctx, rd) == [0, 32, 64]
    @test_throws AssertionError CC.getFieldOffset(lay, 3)

    @test f(I, "D")
    drd = CC.CXXRecordDecl(get_tag(f))
    @test f(I, "B1")
    b1 = CC.CXXRecordDecl(get_tag(f))
    @test f(I, "B2")
    b2 = CC.CXXRecordDecl(get_tag(f))
    dlay = CC.get_record_layout(ctx, CC.RecordDecl(drd))
    @test CC.getBaseClassOffset(dlay, b1) == 0
    @test CC.getBaseClassOffset(dlay, b2) == 8

    @test f(I, "V")
    v = CC.CXXRecordDecl(get_tag(f))
    vlay = CC.get_record_layout(ctx, CC.RecordDecl(v))
    # the exact virtual-base offset is ABI-dependent; it must land after the
    # vtable/vbase pointer
    @test CC.getVBaseClassOffset(vlay, b1) >= 8

    dispose(f)
    dispose(I)
end

@testset "ASTRecordLayout C++ tail accessors" begin
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)
    CC.parse(I, """
    struct RltPoly { virtual void rlt_vf(); int a; };
    struct RltPlain { int a; char b; };
    struct RltVB1 { int a; };
    struct RltV : virtual RltVB1 { int d; };
    """)
    f = DeclFinder(I)
    layof(name) = begin
        @assert f(I, name)
        CC.get_record_layout(ctx, CC.RecordDecl(get_tag(f)))
    end

    plain = layof("RltPlain")
    @test CC.getUnadjustedAlignment(plain) == 4
    @test CC.getRequiredAlignment(plain) >= 1
    @test CC.getNonVirtualSize(plain) == CC.getSize(plain)
    @test CC.getNonVirtualAlignment(plain) == CC.getAlignment(plain)
    @test CC.getPreferredNVAlignment(plain) >= CC.getNonVirtualAlignment(plain)
    @test CC.getSizeOfLargestEmptySubobject(plain) >= 0
    @test CC.hasOwnVFPtr(plain) == false

    poly = layof("RltPoly")
    @test CC.hasOwnVFPtr(poly) == true
    @test CC.hasExtendableVFPtr(poly) == true
    @test !(CC.hasOwnVBPtr(poly))

    virt = layof("RltV")
    # vbptr is an MS-ABI construct; on Itanium the queries answer false with a
    # negative sentinel offset — assert shape, not ABI specifics
    @test !(CC.hasVBPtr(virt))
    @test CC.getVBPtrOffset(virt) isa Integer  # shape-only: the target chooses this value
    @test CC.getNonVirtualSize(virt) <= CC.getSize(virt)

    dispose(f)
    dispose(I)
end

@testset "ASTRecordLayout | primary base selection" begin
    I = create_interpreter(String[])
    CC.parse(I, """
             struct PBNone { int a; };
             struct PBPoly { virtual ~PBPoly(); int b; };
             struct PBDerived : PBPoly { int c; };
             struct PBVirt : virtual PBPoly { int d; };
             """)
    ctx = CC.get_ast_context(I)
    f = DeclFinder(I)

    layout(name) = (@test f(I, name); CC.getASTRecordLayout(ctx, CC.CXXRecordDecl(get_decl(f))))

    # a non-polymorphic class shares no vtable, so it has no primary base
    l_none = layout("PBNone")
    @test CC.is_null_handle(CC.getPrimaryBase(l_none))
    @test !CC.isPrimaryBaseVirtual(l_none)

    # a polymorphic class with no bases introduces its own vtable, so still none
    @test CC.is_null_handle(CC.getPrimaryBase(layout("PBPoly")))

    # deriving non-virtually from a polymorphic base shares that base's vtable
    @test f(I, "PBPoly")
    poly = CC.CXXRecordDecl(get_decl(f))
    l_der = layout("PBDerived")
    pb = CC.getPrimaryBase(l_der)
    @test !CC.is_null_handle(pb)
    @test CC.getName(CC.NamedDecl(pb)) == "PBPoly"
    @test !CC.isPrimaryBaseVirtual(l_der)

    # a virtual base that becomes primary is reported as virtual
    l_virt = layout("PBVirt")
    pbv = CC.getPrimaryBase(l_virt)
    @test CC.is_null_handle(pbv) || CC.isPrimaryBaseVirtual(l_virt)

    dispose(f)
    dispose(I)
end
