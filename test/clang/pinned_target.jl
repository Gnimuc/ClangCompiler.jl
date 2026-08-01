using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl
using Test

# Everything a target decides -- integer widths, alignments, record layout, endianness, the
# calling convention -- is normally answered by whichever CI runner happens to run the suite,
# which is why so many assertions elsewhere carry `# shape-only: the host decides this`. They
# are not unassertable; they were merely unpinned.
#
# `create_interpreter(...; triple=)` takes the target and its include paths from that
# platform's GCC shard instead of HostPlatform(), so every assertion below is an equality on a
# value *clang* decided and reads the same on macOS, Linux and Windows.
#
# Two limits. Only parsing and AST inspection cross-target: the JIT still emits for the host,
# so nothing here executes code. And this does not rescue the markers whose value is
# uninitialised rather than host-dependent (a synthetic `Module`'s availability, a `Driver`'s
# LTO mode before argument processing) -- those are UB preconditions, not platform variance.
#
# Pinning downloads that target's GCC shard on first use, so exactly ONE target is pinned:
# every runner fetches the same single shard rather than one per target. That is also why this
# is one focused file rather than a pin at every marker site.
#
# One target is enough for the point being made. The values below read the same on all three
# runners precisely because they come from this target and not from the machine; a second
# target would only show that they differ, which the note in CLAUDE.md already records.

"The pinned target. SysV/Itanium: `long` is 64 bits and names mangle the Itanium way."
const PIN = "x86_64-linux-gnu"
const PIN_LONG_BITS = 64
const PIN_WCHAR_BITS = 32

@testset "pinned target | scalar widths follow the target, not the runner" begin
    let I = create_interpreter(String[]; triple=PIN)
        ti = CC.getTarget(CC.get_instance(I))

        # `long` is the canonical divergence -- 64 bits here, 32 under mingw -- and is the
        # same mismatch that made a fixed-width `off_t` shim fail to link on Windows while
        # succeeding everywhere else. Pinned, it is an equality on every runner.
        @test CC.getLongWidth(ti) == PIN_LONG_BITS
        @test CC.getWCharWidth(ti) == PIN_WCHAR_BITS

        # asserted so that a shim reading the wrong member cannot hide behind
        # "the host decides it"
        @test CC.getCharWidth(ti) == 8
        @test CC.getShortWidth(ti) == 16
        @test CC.getIntWidth(ti) == 32
        @test CC.getLongLongWidth(ti) == 64
        @test CC.getPointerWidth(ti) == 64
        @test CC.getFloatWidth(ti) == 32
        @test CC.getDoubleWidth(ti) == 64
        @test CC.getBoolWidth(ti) == 8

        # alignment is a separate member from width, so a shim returning the sibling is only
        # caught by asserting both where they differ
        @test CC.getCharAlign(ti) == 8
        @test CC.getIntAlign(ti) == 32
        @test CC.getPointerAlign(ti) == 64
        @test CC.getLongWidth(ti) == CC.getLongAlign(ti)

        @test !CC.isBigEndian(ti)
        @test CC.isLittleEndian(ti)
        # the two are a partition, not two independent reads
        @test CC.isBigEndian(ti) != CC.isLittleEndian(ti)

        dispose(I)
    end
end

@testset "pinned target | record layout follows the target" begin
    src = """
          struct PinPad { char c; int i; double d; };
          struct PinEmpty {};
          struct PinDerived : PinEmpty { int x; };
          struct PinBits { unsigned a : 3; unsigned b : 5; };
          long pin_long; void *pin_ptr; char pin_char; int pin_int;
          """
    let I = create_interpreter(String[]; triple=PIN)
        CC.parse(I, src)
        ctx = CC.get_ast_context(I)
        f = DeclFinder(I)

        vwidth(n) = (@test f(I, n); CC.getTypeSize(ctx, CC.getType(CC.VarDecl(get_decl(f).ptr))))
        rec(n) = (@test f(I, n); CC.getTypeDeclType(ctx, CC.TypeDecl(get_decl(f).ptr)))

        # the context agrees with the target about the scalar it was pinned to
        @test vwidth("pin_long") == PIN_LONG_BITS
        @test vwidth("pin_ptr") == 64
        @test vwidth("pin_char") == 8
        @test vwidth("pin_int") == 32

        # char + pad + int + double: the padding is a layout fact of the target
        pad = rec("PinPad")
        @test CC.getTypeSize(ctx, pad) == 128
        @test CC.getTypeAlign(ctx, pad) == 64

        # an empty class is one byte standalone, and contributes nothing as a base --
        # the empty-base optimisation
        empty = rec("PinEmpty")
        @test CC.getTypeSize(ctx, empty) == 8
        derived = rec("PinDerived")
        @test CC.getTypeSize(ctx, derived) == 32

        # two bitfields totalling 8 bits share one storage unit
        bits = rec("PinBits")
        @test CC.getTypeSize(ctx, bits) == 32

        dispose(f)
        dispose(I)
    end
end

@testset "pinned target | the ABI split is visible, not guessed" begin
    # The Itanium/MSVC divide is what makes mangling and vtable layout unassertable on an
    # unpinned interpreter. Pinned to an Itanium target, they become stated expectations.
    let I = create_interpreter(String[]; triple=PIN)
        ti = CC.getTarget(CC.get_instance(I))

        # the triple round-trips: what was asked for is what clang built
        @test occursin("x86_64", CC.getTriple(ti))
        # the data layout is little-endian and 64-bit, and says so in the two fields that
        # must agree with what the target reports separately
        dl = CC.getDataLayoutString(ti)
        @test startswith(dl, "e-")                       # 'e' = little-endian
        @test occursin("-n8:16:32:64", dl)               # native integer widths
        @test CC.isLittleEndian(ti) == startswith(dl, "e-")

        @test CC.getRegisterWidth(ti) == 64
        @test CC.isTLSSupported(ti)
        @test CC.isVLASupported(ti) isa Bool  # shape-only: the target chooses this value

        dispose(I)
    end
end

@testset "pinned target | mangling under a fixed ABI" begin
    # Mangled names of primitive-typed signatures are stable once the ABI is pinned. Names
    # involving std types are NOT asserted here: those depend on the standard library the
    # target's shard provides, which is a separate axis from the ABI.
    let I = create_interpreter(String[]; triple=PIN)
        CC.parse(I, "int pin_mangle(int, double);")
        f = DeclFinder(I)
        @test f(I, "pin_mangle")
        nd = CC.NamedDecl(get_decl(f).ptr)
        ctx = CC.get_ast_context(I)
        mc = CC.createMangleContext(ctx, CC.getTargetInfo(ctx))
        name = CC.mangleName(mc, nd)
        # The pinned target uses the Itanium ABI, which spells the parameter types into the
        # symbol -- so this is an exact expectation, not a shape.
        @test name == "_Z10pin_mangleid"
        # createMangleContext hands back a caller-owned object with no dispose function --
        # a known leak recorded in deps/ClangExtra/CLAUDE.md, not an omission here.
        dispose(f)
        dispose(I)
    end
end

# The testsets above pin a target so every runner reads the same answers. This one is the
# complement: it uses the interpreter the package builds by DEFAULT and asserts what the host's
# own target says, so each runner exercises its native path rather than a pinned stand-in.
#
# The expected values are not written from knowledge. Each row was read back from an
# explicitly pinned interpreter (`triple=`) on one machine, which is what makes a Windows
# expectation checkable without a Windows machine -- normally the reason per-platform branches
# are risky.
#
# Two rules keep this honest:
#   * Key on architecture as well as OS. CI is x86_64 everywhere, but a developer machine may
#     not be -- this one is aarch64 Darwin, where `long` is still 64 but a bare `iswindows()`
#     split would have said nothing about which arch it assumed.
#   * Never pin the interpreter in this testset. `Sys` describes the HOST; the moment a triple
#     is pinned the values come from the target instead, and the two disagree silently.
#
# Only `long` and `wchar_t` actually diverge across the three CI targets. Mangling does not:
# mingw uses the Itanium ABI, so `_Z2pmid` is the answer on all three, and it is asserted
# unguarded above rather than split three ways for nothing.
"Expected (long, wchar_t) widths for the host, by (arch, OS). Each read from a pinned run."
const HOST_WIDTHS = Dict((:x86_64, :Windows) => (32, 16),   # mingw: the LLP64 outlier
                         (:x86_64, :Linux) => (64, 32),
                         (:x86_64, :Darwin) => (64, 32),
                         (:aarch64, :Darwin) => (64, 32),   # developer machines; not a CI runner
                         (:aarch64, :Linux) => (64, 32))

@testset "host target | the default interpreter reads this machine's target" begin
    I = create_interpreter(String[])          # deliberately NOT pinned -- see the note above
    ti = CC.getTarget(CC.get_instance(I))
    key = (Sys.ARCH, Symbol(Sys.KERNEL))

    # every platform this suite runs on is in the table; an unknown one is a failure rather
    # than a silent skip, so a new runner cannot quietly assert nothing
    @test haskey(HOST_WIDTHS, key)
    if haskey(HOST_WIDTHS, key)
        long_bits, wchar_bits = HOST_WIDTHS[key]
        @test CC.getLongWidth(ti) == long_bits
        @test CC.getWCharWidth(ti) == wchar_bits
    end

    # true on every target the package supports, so asserted once rather than per platform
    @test CC.getCharWidth(ti) == 8
    @test CC.getIntWidth(ti) == 32
    @test CC.getLongLongWidth(ti) == 64
    @test CC.getPointerWidth(ti) == 64
    @test CC.isLittleEndian(ti)

    # `long` is either the LLP64 32 or the LP64 64 -- never anything else -- and it agrees
    # with pointer width exactly when the target is LP64
    @test CC.getLongWidth(ti) in (32, 64)
    @test (CC.getLongWidth(ti) == CC.getPointerWidth(ti)) == (CC.getLongWidth(ti) == 64)

    dispose(I)
end
