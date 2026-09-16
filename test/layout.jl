using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, create_parser, dispose
using Test

# The ABI façade. Pin the triple so size and offset equalities are the same on
# every CI host — these are values clang decided for that target, not this
# wrapper's return type.

const LAY_TRIPLE = "x86_64-linux-gnu"

@testset "record_layout | C packed and padded" begin
    p = create_parser(; language=:c, triple=LAY_TRIPLE)
    CC.parse(p, """
        struct LayPlain { int x; char y; double z; };
        struct LayPad { char a; int b; };
        enum LayColor { LAY_RED = 1, LAY_GREEN = 2, LAY_BLUE = 4 };
        int lay_add(int a, int b) { return a + b; }
        static int lay_hidden(void) { return 0; }
        """)
    ctx = CC.get_ast_context(p)

    plain = CC.record_layout(ctx, CC.find_decl(p, "LayPlain"))
    @test plain.size == 16
    @test plain.align == 8
    @test [f.bit_offset for f in plain.fields] == [0, 32, 64]
    @test [f.name for f in plain.fields] == ["x", "y", "z"]
    @test all(f -> f.bit_width == 0, plain.fields)
    @test !plain.has_vptr
    @test isempty(plain.bases)

    pad = CC.record_layout(ctx, CC.find_decl(p, "LayPad"))
    @test pad.size == 8
    @test [f.bit_offset for f in pad.fields] == [0, 32]

    e = CC.enum_info(CC.find_decl(p, "LayColor"))
    @test e.name == "LayColor"
    @test [x.name for x in e.enumerators] == ["LAY_RED", "LAY_GREEN", "LAY_BLUE"]
    @test [x.value for x in e.enumerators] == [1, 2, 4]
    @test occursin("int", e.underlying)

    add = CC.find_decl(p, "lay_add")
    @test CC.is_exported(add)
    @test !CC.is_exported(CC.find_decl(p, "lay_hidden"))
    @test CC.is_nothrow(add)  # C never throws

    decls = CC.api_decls(p)
    names = Set(CC.decl_name(d) for d in decls if d isa CC.AbstractNamedDecl)
    @test "LayPlain" in names
    @test "lay_add" in names
    @test !("int64_t" in names)  # system typedefs are filtered

    dispose(p)
end

@testset "record_layout | C++ bases and vtable" begin
    I = create_interpreter(String[]; triple=LAY_TRIPLE)
    ctx = CC.get_ast_context(I)
    CC.parse(I, """
        struct LayB1 { int a; };
        struct LayB2 { double b; };
        struct LayD : LayB1, LayB2 { char c; };
        struct LayVBase { int a; };
        struct LayV : virtual LayVBase { int d; };
        struct LayPoly { virtual int lay_f(); virtual ~LayPoly(); int n; };
        enum class LayScoped : unsigned { A = 3 };
        int lay_maythrow();
        int lay_nothrow() noexcept;
        """)

    dlay = CC.record_layout(ctx, CC.find_decl(I, "LayD"))
    @test dlay.size == 24
    @test length(dlay.bases) == 2
    @test dlay.bases[1].name == "LayB1" && dlay.bases[1].byte_offset == 0 && !dlay.bases[1].is_virtual
    @test dlay.bases[2].name == "LayB2" && dlay.bases[2].byte_offset == 8 && !dlay.bases[2].is_virtual
    @test [f.name for f in dlay.fields] == ["c"]

    vlay = CC.record_layout(ctx, CC.find_decl(I, "LayV"))
    @test vlay.has_vptr || any(b -> b.is_virtual, vlay.bases)
    @test any(b -> b.is_virtual && b.name == "LayVBase", vlay.bases)
    @test !isempty(vlay.vbases)

    poly = CC.find_decl(I, "LayPoly")
    play = CC.record_layout(ctx, poly)
    @test play.has_vptr
    vt = CC.vtable_info(ctx, poly)
    @test occursin("LayPoly", vt.symbol)
    @test any(s -> s.name == "lay_f", vt.slots)
    @test any(s -> s.name == "~LayPoly" || occursin("LayPoly", s.name), vt.slots)

    se = CC.enum_info(CC.find_decl(I, "LayScoped"))
    @test se.name == "LayScoped"
    @test se.enumerators[1].value == 3
    @test occursin("unsigned", se.underlying)

    @test CC.is_nothrow(CC.find_decl(I, "lay_nothrow"))
    @test !CC.is_nothrow(CC.find_decl(I, "lay_maythrow"))

    decls = CC.api_decls(I)
    names = Set(CC.decl_name(d) for d in decls if d isa CC.AbstractNamedDecl)
    @test "LayD" in names
    @test "lay_nothrow" in names

    dispose(I)
end

@testset "macros on the session" begin
    p = create_parser(; language=:c, record_macros=true)
    CC.parse(p, """
        #define LAY_ONE 1
        #define LAY_ADD(a, b) ((a) + (b))
        int lay_v = LAY_ADD(LAY_ONE, 2);
        """)
    @test CC.macro_text(p, "LAY_ONE") == "1"
    add = CC.macro_text(p, "LAY_ADD")
    @test add !== nothing
    @test occursin("+", add)
    @test CC.macro_text(p, "LAY_NOPE") === nothing

    vd = CC.find_decl(p, "lay_v")
    init = CC.getInit(vd)
    loc = CC.getExpansionLoc(CC.getSourceManager(CC.get_instance(p)), CC.getBeginLoc(init))
    expanded = CC.expanded_macro(p, loc)
    @test expanded !== nothing
    @test occursin("1", expanded) && occursin("2", expanded)

    dispose(p)
end
