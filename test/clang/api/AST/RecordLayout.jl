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

    # A forward declaration has no layout, and neither does the *pattern* of a class template
    # -- and only the first was gated. The pattern is the sharper case precisely because it
    # looks complete: `getDefinition` is non-null, so it passed the has-a-definition check and
    # went on to `ItaniumRecordLayoutBuilder`, which reaches `llvm_unreachable` on a dependent
    # type. A release LLVM compiles that to `__builtin_unreachable()`, so the process segfaulted
    # rather than aborting -- no exception to catch, and nothing in the suite to see it.
    CC.parse(I, "struct Fwd; template <typename T> struct Pat { T a; int b; };")
    @test f(I, "Fwd")
    @test_throws AssertionError CC.getASTRecordLayout(ctx, CC.RecordDecl(get_tag(f)))

    @test f(I, "Pat")
    pattern = CC.getTemplatedDecl(CC.ClassTemplateDecl(get_decl(f)))
    # the two halves of the precondition, so the test says which one is doing the work
    @test CC.getDefinition(pattern).ptr != C_NULL
    @test CC.isDependentType(CC.getTypeForDecl(pattern)) == true
    @test_throws AssertionError CC.getASTRecordLayout(ctx, pattern)
    @test_throws AssertionError CC.field_offsets(ctx, pattern)

    # ... and an instantiation of that same template does have one, which is what makes the
    # assertion above a partition rather than a blanket refusal of templates. The instantiation
    # is reached through a variable of that type rather than by name: a lookup for
    # `Pat<double>` finds nothing, because an implicit instantiation is not entered into the
    # enclosing scope's lookup table.
    CC.parse(I, "Pat<double> pat_inst;")
    inst = CC.getAsCXXRecordDecl(CC.getTypePtr(CC.getType(CC.find_decl(I, "pat_inst"))))
    @test CC.isDependentType(CC.getTypeForDecl(inst)) == false
    @test CC.field_offsets(ctx, inst) == [0, 64]

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
    @test CC.getVBPtrOffset(virt) isa Integer  # shape-only: the target ABI decides it — a real offset under MS, a negative sentinel under Itanium
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

@testset "ASTRecordLayout | zero-sized object flags" begin
    # Both flags are, in clang's own words, "Only used for MS-ABI" -- the Microsoft layout
    # builder is the only thing that ever sets them. All three CI targets lay records out
    # with the Itanium ABI (mingw included), so `false` is a real equality holding on every
    # one of them rather than a shape assertion: a shim reading the neighbouring bit of the
    # same bitfield, or another record's CXXInfo, fails it. The records below are exactly
    # the shapes that WOULD set the flags under the MS ABI.
    I = create_interpreter(String[])
    CC.parse(I, """
             struct ZEmpty {};
             struct ZLeadsWithEmptyBase : ZEmpty { int x; };
             struct ZEndsWithEmptyMember { int x; ZEmpty e; };
             struct ZNeither { int x; double y; };
             """)
    ctx = CC.get_ast_context(I)
    f = DeclFinder(I)
    layout(name) = (@test f(I, name); CC.getASTRecordLayout(ctx, CC.CXXRecordDecl(get_decl(f))))

    for name in ("ZEmpty", "ZLeadsWithEmptyBase", "ZEndsWithEmptyMember", "ZNeither")
        @test !CC.endsWithZeroSizedObject(layout(name))
        @test !CC.leadsWithZeroSizedBase(layout(name))
    end

    # endsWithZeroSizedObject is TOTAL where its neighbour asserts -- clang spells it
    # `CXXInfo && ...`, so it answers rather than aborting. Only this one can be exercised
    # that way: calling the asserting sibling on a layout carrying no CXXInfo would take the
    # process down rather than fail a test.
    @test CC.endsWithZeroSizedObject(layout("ZNeither")) === false

    dispose(f)
    dispose(I)
end
