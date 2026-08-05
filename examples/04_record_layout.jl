# ==========================================================================================
# 04 — Record layout: what does this C++ type look like in memory?
# ==========================================================================================
#
# Every FFI bug that starts with "the struct comes back full of garbage" is a layout bug. The
# C++ source says *what* the members are; it does not say *where* they are. That is decided by
# the ABI, and clang has already worked it out — `ASTRecordLayout` is the answer sheet.
#
# The rules clang applies (for the Itanium C++ ABI, which is everything except MSVC):
#
#   * every member that is not a bit-field sits at an offset that is a multiple of its own
#     alignment, so the compiler inserts PADDING to get there;
#   * the record's alignment is the largest alignment among its members and its base
#     subobjects (`alignas` can raise it), and its size is rounded up to a multiple of that —
#     TAIL PADDING;
#   * non-virtual base subobjects are laid out before the derived class's own members (virtual
#     bases go after them, at the end of the object);
#   * a bit-field's offset is measured in bits, not bytes, and may start part-way into a byte —
#     the one place the first rule does not hold.
#
# This example asks clang for all of that and prints it. Nothing here guesses.
#
# One caveat worth internalising before reading any number below: **the target decides these
# values, not clang**. Change the triple and `long` changes width, alignment rules change, and
# every offset moves. This script uses the host target on purpose — that is what makes the
# cross-check against Julia's own `fieldoffset` meaningful. Example 06 shows the other half:
# pinning a triple so the answers are the same everywhere.

using ClangCompiler
using ClangCompiler: create_interpreter, dispose
import ClangCompiler as CC

const BITS = 8  # clang reports field offsets in bits; record sizes in bytes

# ------------------------------------------------------------------------------------------
# The layout printer
# ------------------------------------------------------------------------------------------
# A row of the table. Offsets and extents are kept in *bits* throughout, because a bit-field's
# offset is not a whole number of bytes and the padding arithmetic has to survive that.
mkrow(bitoff, bits, align, name, ty) = (; bitoff=Int(bitoff), bits=Int(bits), align=Int(align), name=name, ty=ty)

"Byte offset, or `byte+k` when the entry starts part-way into a byte (bit-fields)."
fmt_off(b) = b % BITS == 0 ? string(b ÷ BITS) : "$(b ÷ BITS)+$(b % BITS)"

"Extent in bytes, or `Nb` when it is not a whole number of bytes."
fmt_ext(b) = b % BITS == 0 ? string(b ÷ BITS) : "$(b)b"

"A gap, spelled out in whatever unit is honest for it."
fmt_gap(b) = b % BITS == 0 ? "$(b ÷ BITS) byte(s)" : "$(b) bit(s)"

"""
Collect one row per thing that occupies space in `rd`: the vtable pointer if there is one,
then the base class subobjects, then the fields in declaration order.
"""
function layout_rows(ctx, rd, layout)
    rows = []

    # The vtable pointer is storage that no source line declares. `hasOwnVFPtr` says this class
    # is the one that introduced it (a derived class reuses its primary base's), and in the
    # Itanium ABI it sits at offset 0 and is one pointer wide.
    if rd isa CC.AbstractCXXRecordDecl && CC.hasOwnVFPtr(layout)
        vptr = Int(CC.getPointerWidth(CC.getTargetInfo(ctx)))
        push!(rows, mkrow(0, vptr, vptr ÷ BITS, "(vptr)", "vtable pointer"))
    end

    # Base subobjects. `getBaseClassOffset` answers where the base's data starts inside the
    # derived object — the number you must add to a `Derived*` to get a valid `Base*`.
    if rd isa CC.AbstractCXXRecordDecl && CC.getNumBases(rd) > 0
        for spec in CC.getBases(rd)
            CC.isVirtual(spec) && continue  # virtual bases live at the end; see getVBaseClassOffset
            base = CC.getAsCXXRecordDecl(CC.getTypePtr(CC.getType(spec)))
            blay = CC.get_record_layout(ctx, base)
            # A base with no data members is allowed to occupy zero bytes (the empty base
            # optimisation), and a non-empty base occupies only its *non-virtual size* — its
            # size minus its own tail padding, which the derived class may reuse.
            extent = CC.isEmpty(base) ? 0 : Int(CC.getNonVirtualSize(blay)) * BITS
            push!(rows,
                  mkrow(Int(CC.getBaseClassOffset(layout, base)) * BITS, extent,
                        Int(CC.getAlignment(blay)), "(base) " * CC.getName(base),
                        CC.getAsString(CC.getType(spec))))
        end
    end

    for f in CC.getFields(rd)
        qt = CC.getType(f)                                   # the field's QualType
        nm = CC.getName(f)
        nm = isempty(nm) ? "<unnamed>" : nm
        # `getFieldIndex` is the field's position in declaration order, which is exactly the
        # index `getFieldOffset` wants. Bases are not fields, so this starts at 0 either way.
        off = CC.getFieldOffset(layout, CC.getFieldIndex(f))
        align = Int(CC.getTypeAlignInChars(ctx, qt))
        if CC.isBitField(f)
            w = Int(CC.getBitWidthValue(f, ctx))
            push!(rows, mkrow(off, w, align, nm, CC.getAsString(qt) * " : $w"))
        else
            push!(rows, mkrow(off, Int(CC.getTypeSizeInChars(ctx, qt)) * BITS, align, nm, CC.getAsString(qt)))
        end
    end
    return rows
end

print_row(off, sz, al, nm, ty) = println("   ", lpad(off, 6), lpad(sz, 6), lpad(al, 6), "  ", rpad(nm, 18), ty)

"""
    show_layout(I, ctx, name) -> (; size, padding)

Print clang's layout for the record `name`, marking every gap. `size` comes back in bytes and
`padding` in bits — the only unit that can total up a bit-field's gap without rounding it
away. `fmt_ext` renders that total in whichever unit is honest for it.
"""
function show_layout(I, ctx, name)
    rd = CC.find_decl(I, name)                 # resolved: a CXXRecordDecl, not a bare NamedDecl
    layout = CC.get_record_layout(ctx, rd)     # clang::ASTRecordLayout

    # `getSize`/`getAlignment` are CharUnits, handed back in bytes. `getDataSize` is the extent a
    # derived class must respect: it equals the size for a C-like type, and drops below it when
    # the ABI lets a derived class move its own members into the tail padding (§5).
    size, align, dsize = Int(CC.getSize(layout)), Int(CC.getAlignment(layout)), Int(CC.getDataSize(layout))

    println("\n", name, "  —  size ", size, " B, alignment ", align, " B, data size ", dsize, " B")
    print_row("offset", "size", "align", "member", "type")
    print_row("------", "----", "-----", "-"^16, "-"^24)

    gapline(g, what) = println("   ", " "^18, "  ....... ", rpad(fmt_gap(g), 9), " of ", what, " .......")

    cursor, padding = 0, 0
    for r in layout_rows(ctx, rd, layout)
        # Anything between where the previous entry ended and where this one starts is padding
        # the compiler inserted to satisfy this entry's alignment. This is the number nobody
        # writes down and everybody gets wrong.
        gap = r.bitoff - cursor
        if gap > 0
            padding += gap
            gapline(gap, "padding")
        end
        print_row(fmt_off(r.bitoff), fmt_ext(r.bits), r.align, r.name, r.ty)
        cursor = max(cursor, r.bitoff + r.bits)
    end
    tail = size * BITS - cursor
    if tail > 0
        padding += tail
        gapline(tail, "TAIL padding")
    end
    println("   total padding: ", fmt_ext(padding), " of ", size, " bytes")
    return (; size=size, padding=padding)
end

# ------------------------------------------------------------------------------------------
# Set up an interpreter and hand it some deliberately awkward declarations
# ------------------------------------------------------------------------------------------
I = create_interpreter(String[])
ctx = CC.get_ast_context(I)

# The target is what actually decides every number printed below.
println("target triple: ", CC.getTriple(CC.getTarget(CC.get_instance(I))))

CC.parse(I, """
// (1) The classic: members ordered small-to-large force padding before each larger one.
struct Mixed {
  char   flag;
  int    count;
  char   tag;
  double value;
};

// (2) The same four members, largest first. Same data, less memory.
struct Packed {
  double value;
  int    count;
  char   flag;
  char   tag;
};

// (3) alignas raises the alignment of a member, and therefore of the whole record.
struct Cacheline {
  char         header;
  alignas(32) int payload;
};

// (4) Bit-fields share a storage unit. `unsigned : 0` is the special "start a new unit here"
//     declaration -- it names nothing and stores nothing.
struct Flags {
  unsigned kind  : 3;
  unsigned ready : 1;
  unsigned       : 0;
  unsigned id    : 20;
};

// (5) Inheritance. `Head` is non-POD (it has a user-provided constructor), which is what lets
//     the Itanium ABI put a derived member inside the base's tail padding.
struct Head { int a; char b; Head(); };
struct Tail : Head { char c; };
struct HasHead { Head h; char c; };   // a MEMBER of the same type -- not the same layout
struct PodHead { int a; char b; };    // the same members, no constructor: POD, so its tail
struct PodTail : PodHead { char c; }; // padding stays off limits to the derived class

// (6) An empty base costs nothing; an empty complete object still costs one byte.
struct Marker {};
struct Tagged : Marker { int v; };

// (7) A polymorphic class carries a vtable pointer that appears in no source line.
struct Shape { virtual ~Shape(); int sides; };
""")

# ------------------------------------------------------------------------------------------
# §1  Padding is the thing people get wrong
# ------------------------------------------------------------------------------------------
println("\n", "="^90)
println("§1  Declaration order decides how much memory you spend")
println("="^90)

println("   legend: offset and size are bytes unless suffixed — `0+3` means byte 0 bit 3, `3b` means")
println("           3 bits. `align` is the alignment clang gives that member's type; every offset")
println("           except a bit-field's is a multiple of it, and forcing that is why padding exists.")
println("           A `(base)` row spans the base's non-virtual size, which is below its standalone")
println("           size whenever the derived class may reuse the base's tail padding (§5).")
println("           `data size` is the part of the object a derived class may not overlap: equal to")
println("           `size` for a plain C-like type, smaller once tail padding becomes reusable (§5).")

mixed = show_layout(I, ctx, "Mixed")
packed = show_layout(I, ctx, "Packed")
println("\n  → same four members, only the order changed: ", mixed.size, " bytes with ",
        fmt_ext(mixed.padding), " wasted,")
println("    versus ", packed.size, " bytes with ", fmt_ext(packed.padding), " wasted.")

# The raw helper, for when you want the numbers rather than the table. Note the unit: field
# offsets come back in BITS, because that is the only unit that can describe a bit-field.
println("  field_offsets(Mixed) = ", Int.(CC.field_offsets(ctx, CC.find_decl(I, "Mixed"))), " (bits)")

# ------------------------------------------------------------------------------------------
# §2  Cross-check: Julia lays out isbits structs the same way
# ------------------------------------------------------------------------------------------
println("\n", "="^90)
println("§2  Julia's own layout agrees, member for member")
println("="^90)

struct MixedJL
    flag::Cchar
    count::Cint
    tag::Cchar
    value::Cdouble
end

clang_offsets = Int.(CC.field_offsets(ctx, CC.find_decl(I, "Mixed"))) .÷ BITS
julia_offsets = [Int(fieldoffset(MixedJL, i)) for i in 1:fieldcount(MixedJL)]

println("   member    clang    julia")
for (i, nm) in enumerate(fieldnames(MixedJL))
    println("   ", rpad(nm, 8), lpad(clang_offsets[i], 7), lpad(julia_offsets[i], 9))
end
println("   ", rpad("sizeof", 8), lpad(mixed.size, 7), lpad(sizeof(MixedJL), 9))
@assert clang_offsets == julia_offsets
@assert mixed.size == sizeof(MixedJL)
println("  → identical, so `Mixed*` from C++ can be loaded straight into a MixedJL.")
println("    (They agree because clang here targets the host. Retarget it and they need not.)")

# ------------------------------------------------------------------------------------------
# §3  An over-aligned member drags the whole record with it
# ------------------------------------------------------------------------------------------
println("\n", "="^90)
println("§3  alignas raises the alignment of the enclosing record too")
println("="^90)

cache = show_layout(I, ctx, "Cacheline")
println("\n  → ", fmt_ext(cache.size * BITS - cache.padding), " bytes of declared data inside a ", cache.size,
        "-byte object. `alignas(32)` on one member raised the")
println("    alignment of the whole record to 32, and a record's size must be a multiple of its")
println("    alignment — so the tail had to be padded out as well.")

# ------------------------------------------------------------------------------------------
# §4  Bit-fields: offsets that are not byte offsets
# ------------------------------------------------------------------------------------------
println("\n", "="^90)
println("§4  Bit-fields pack into a storage unit; `: 0` starts a new one")
println("="^90)

show_layout(I, ctx, "Flags")
println("\n  → `kind` takes bits 0-2 and `ready` bit 3 of the very same 4-byte unit: `ready` is")
println("    reported at offset `0+3`, byte 0 bit 3. The 28-bit gap after it is what the unnamed")
println("    zero-width bit-field bought — it pushed `id` out to the next storage unit, at byte 4.")
println("    This is why field offsets are handed back in bits: byte offsets cannot say `0+3`.")

# ------------------------------------------------------------------------------------------
# §5  Inheritance: where the base subobject lives
# ------------------------------------------------------------------------------------------
println("\n", "="^90)
println("§5  A base subobject is not the same thing as a member")
println("="^90)

tail = show_layout(I, ctx, "Tail")
hashead = show_layout(I, ctx, "HasHead")

head = CC.find_decl(I, "Head")
derived = CC.find_decl(I, "Tail")
headlay = CC.get_record_layout(ctx, head)
taillay = CC.get_record_layout(ctx, derived)

println("\n  Head alone:      size ", Int(CC.getSize(headlay)), " B, data size ",
        Int(CC.getDataSize(headlay)), " B  (",
        Int(CC.getSize(headlay)) - Int(CC.getDataSize(headlay)), " bytes of it are tail padding)")
println("  Tail : Head      base subobject at byte ", Int(CC.getBaseClassOffset(taillay, head)),
        ", and `c` landed at byte ", Int(CC.field_offsets(ctx, derived)[1]) ÷ BITS, " —")
println("                   *inside* what was Head's tail padding, so Tail is still ", tail.size, " bytes.")
println("  HasHead          holds a Head as a member instead: `c` cannot reuse that padding,")
println("                   so the object grows to ", hashead.size, " bytes. Same members, different rule.")

# The reuse above is not a property of tail padding as such: it is allowed because `Head` is
# non-POD. `PodHead` declares the same two members and no constructor, and clang lays its
# derived class out differently — the claim is checkable, not folklore.
podtail = CC.find_decl(I, "PodTail")
podtaillay = CC.get_record_layout(ctx, podtail)
podheadlay = CC.get_record_layout(ctx, CC.find_decl(I, "PodHead"))
println("  PodTail          the same pair without a constructor: PodHead is POD, so its data size")
println("                   equals its size (", Int(CC.getDataSize(podheadlay)), " B), `c` cannot start before byte ",
        Int(CC.field_offsets(ctx, podtail)[1]) ÷ BITS, ", and PodTail needs ",
        Int(CC.getSize(podtaillay)), " B.")
println("                   Reuse is a property of non-POD bases, not of tail padding as such.")

# `is_derived_from` answers the question a cast would ask. It is transitive and, like C++, a
# class is not derived from itself.
marker = CC.find_decl(I, "Marker")
tagged = CC.find_decl(I, "Tagged")
println("\n  is_derived_from(Tail, Head)     = ", CC.is_derived_from(derived, head))
println("  is_derived_from(Head, Tail)     = ", CC.is_derived_from(head, derived), "  (not the reverse)")
println("  is_derived_from(Tagged, Marker) = ", CC.is_derived_from(tagged, marker))

# Empty base optimisation: `Marker` costs a byte on its own, and nothing at all as a base.
markerlay = CC.get_record_layout(ctx, marker)
taggedlay = CC.get_record_layout(ctx, tagged)
println("\n  sizeof(Marker)             = ", Int(CC.getSize(markerlay)),
        "   (no *complete* object may have size 0)")
println("  sizeof(Tagged : Marker)    = ", Int(CC.getSize(taggedlay)),
        "   (the empty base was optimised away)")
println("  Marker subobject at byte   = ", Int(CC.getBaseClassOffset(taggedlay, marker)),
        "   — and `v` at byte ", Int(CC.field_offsets(ctx, tagged)[1]) ÷ BITS, ", the same address")
println("  → an empty *base* may occupy 0 bytes; an empty *complete object* may not. That is the")
println("    entire difference between the first two lines.")

# ------------------------------------------------------------------------------------------
# §6  The member you never declared
# ------------------------------------------------------------------------------------------
println("\n", "="^90)
println("§6  A polymorphic class has a vtable pointer at offset 0")
println("="^90)

shape = CC.find_decl(I, "Shape")
show_layout(I, ctx, "Shape")
println("\n  hasOwnVFPtr(Shape) = ", CC.hasOwnVFPtr(CC.get_record_layout(ctx, shape)),
        "   — this class is the one that introduced the vtable pointer")
println("  → `sides` is the only member anyone declared, yet it starts at byte ",
        Int(CC.field_offsets(ctx, shape)[1]) ÷ BITS, ". The row above it")
println("    is real storage that no source line asks for. A binding generated by reading the")
println("    C++ declaration alone would put `sides` at offset 0 and be wrong by a pointer —")
println("    which is why FFI layers normally refuse to map polymorphic classes at all.")

# ------------------------------------------------------------------------------------------
println("\n", "="^90)
println("Every number above came from clang's layout for target ",
        CC.getTriple(CC.getTarget(CC.get_instance(I))), ".")
println("Ask a different target and you get different numbers — see example 06.")
println("="^90)

dispose(I)
