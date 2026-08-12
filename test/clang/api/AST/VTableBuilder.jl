using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, find_decl
using Test

# The vtable layout the ASTContext computes. Two things are worth asserting and one is not:
# WHICH slot a method lands in is an ABI number the target picks, so it is never pinned to a
# literal here; that the layout array and the index API agree about it, and that an override
# reuses its base's slot, are language rules and are pinned.

"The declared member functions of `rd`, keyed by name."
vtb_methods(rd) = Dict(CC.getNameAsString(m) => m for m in CC.getMethods(rd))

@testset "VTableBuilder" begin
    I = create_interpreter(["-std=c++17"])
    ctx = CC.get_ast_context(I)
    CC.parse(I, """
    struct VtbBase {
      virtual ~VtbBase();
      virtual int vtb_f();
      virtual int vtb_g();
      int vtb_plain();
    };
    struct VtbDerived : VtbBase { int vtb_f() override; virtual int vtb_h(); };
    struct VtbPod { int x; double y; };
    struct VtbVirt : virtual VtbBase { int z; };
    """)

    vtc = CC.getVTableContext(ctx)
    @test !CC.is_null_handle(vtc)
    itanium = CC.castToItaniumVTableContext(vtc)
    # the cast is the gate on the ABI: exactly one of the two holds on any host
    @test CC.isMicrosoft(vtc) == CC.is_null_handle(itanium)

    base = find_decl(I, "VtbBase")
    derived = find_decl(I, "VtbDerived")
    pod = find_decl(I, "VtbPod")
    virt = find_decl(I, "VtbVirt")
    @test all(x -> x !== nothing, (base, derived, pod, virt))

    base_methods = vtb_methods(base)
    derived_methods = vtb_methods(derived)
    @test haskey(base_methods, "vtb_f")
    @test haskey(base_methods, "vtb_g")
    @test haskey(base_methods, "vtb_plain")
    @test haskey(derived_methods, "vtb_f")
    base_f = base_methods["vtb_f"]
    base_g = base_methods["vtb_g"]
    base_plain = base_methods["vtb_plain"]
    derived_f = derived_methods["vtb_f"]

    # a slot is given to virtual methods and to nothing else -- true under either ABI
    @test CC.hasVtableSlot(base_f)
    @test !CC.hasVtableSlot(base_plain)

    # `vbases()` lists direct and indirect virtual bases, and only virtual ones
    @test CC.is_virtual_base_of(virt, base)
    @test !CC.is_virtual_base_of(derived, base)

    if !CC.isMicrosoft(vtc)
        layout = CC.getVTableLayout(itanium, base)
        n = CC.getNumVTableComponents(layout)
        @test n > 2

        # single inheritance produces one table, spanning the whole component array
        @test CC.getNumVTables(layout) == 1
        @test CC.getVTableOffset(layout, 0) == 0
        @test CC.getVTableSize(layout, 0) == n

        # the Itanium prologue: offset-to-top (zero for the most-derived class) then the
        # class's own RTTI, and the address point sits right after them
        c0 = CC.getVTableComponent(layout, 0)
        @test CC.getKind(c0) == CC.CXVTableComponent_CK_OffsetToTop
        @test CC.getOffsetToTop(c0) == 0
        c1 = CC.getVTableComponent(layout, 1)
        @test CC.isRTTIKind(c1)
        @test CC.getRTTIDecl(c1) == base

        # every entry is exactly one kind, and the kind decides which accessors are defined
        @test !CC.isFunctionPointerKind(c1)
        @test_throws AssertionError CC.getOffsetToTop(c1)
        @test_throws AssertionError CC.getRTTIDecl(c0)
        @test_throws AssertionError CC.getVTableComponent(layout, n)
        @test_throws AssertionError CC.getVTableOffset(layout, CC.getNumVTables(layout))

        # where the two virtual methods actually sit in the array
        slots = Dict{Any,Int}()
        for i = 0:(n - 1)
            c = CC.getVTableComponent(layout, i)
            CC.isUsedFunctionPointerKind(c) || continue
            CC.isDestructorKind(c) && continue
            slots[CC.getFunctionDecl(c)] = i
        end
        @test haskey(slots, base_f)
        @test haskey(slots, base_g)

        # the layout array and the index API measure from the same address point, so the
        # difference between two slots is the same in both
        fi = CC.getMethodVTableIndex(itanium, base_f)
        gi = CC.getMethodVTableIndex(itanium, base_g)
        @test slots[base_f] - Int(fi) == slots[base_g] - Int(gi)
        # declaration order is slot order in the Itanium ABI
        @test fi < gi

        # an override does not get a new slot: it replaces its base's entry
        @test CC.getMethodVTableIndex(itanium, derived_f) == fi
        # ... and the derived class's own table names the override there
        dlayout = CC.getVTableLayout(itanium, derived)
        dslots = Dict{Any,Int}()
        for i = 0:(CC.getNumVTableComponents(dlayout) - 1)
            c = CC.getVTableComponent(dlayout, i)
            CC.isUsedFunctionPointerKind(c) || continue
            CC.isDestructorKind(c) && continue
            dslots[CC.getFunctionDecl(c)] = i
        end
        # the overridden entry names the override, the inherited one still names the base
        @test haskey(dslots, derived_f)
        @test !haskey(dslots, base_f)
        @test haskey(dslots, base_g)

        # a non-virtual method and a class with no vtable are both rejected before clang is
        # asked, because clang answers them with an assertion failure rather than a value
        @test_throws AssertionError CC.getMethodVTableIndex(itanium, base_plain)
        @test_throws AssertionError CC.getVTableLayout(itanium, pod)
        @test_throws AssertionError CC.getVirtualBaseOffsetOffset(itanium, derived, base)

        # the virtual-base offset slot lives BEFORE the address point, so its offset is
        # negative
        @test CC.getVirtualBaseOffsetOffset(itanium, virt, base) < 0

        # the two spellings of the component representation agree
        @test CC.isPointerLayout(itanium) == (CC.getVTableComponentLayout(itanium) == CC.CXItaniumVTableContext_Pointer)
        @test CC.isPointerLayout(itanium) != CC.isRelativeLayout(itanium)
    else
        # Microsoft: the Itanium surface is unreachable, which is the whole content of the
        # gate above. Nothing else in this file applies.
        @test CC.is_null_handle(itanium)
    end

    dispose(I)
end
