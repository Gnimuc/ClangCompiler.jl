using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, get_instance
using Test

@testset "Builtin::Context | what a builtin ID means" begin
    I = create_interpreter(String[])
    ci = get_instance(I)
    pp = CC.getPreprocessor(ci)
    bi = CC.getBuiltinInfo(pp)

    first_ts = CC.getFirstTSBuiltinID()
    @test first_ts > 1

    # The target-independent half of the table is the same on every host, so its records can
    # be looked up by name and asked about. Reading every name at once is also what asserts
    # that no record is missing one.
    names = [CC.getName(bi, id) for id = 1:(first_ts - 1)]
    @test all(!isempty, names)
    by_name = Dict(name => id for (id, name) in enumerate(names))

    # A handful of builtins whose attribute letters clang/Basic/Builtins.def spells out, each
    # paired with one that has the opposite answer so no predicate can be stuck.
    abs_id = by_name["__builtin_abs"]          # BUILTIN(__builtin_abs, "ii", "ncF")
    trap_id = by_name["__builtin_trap"]        # BUILTIN(__builtin_trap, "v", "nr")
    memcpy_id = by_name["__builtin_memcpy"]    # BUILTIN(__builtin_memcpy, "v*v*vC*z", "nFE")
    printf_id = by_name["__builtin_printf"]    # "nFp:0:"
    scanf_id = by_name["__builtin_scanf"]      # "Fs:0:"
    libprintf_id = by_name["printf"]           # LIBBUILTIN(printf, ..., STDIO_H, ...)

    # the name is a round trip through the record the ID indexes
    @test CC.getName(bi, abs_id) == "__builtin_abs"

    # 'c' const, 'r' noreturn, 'n' nothrow, 'F' libc-with-prefix, 'f' predefined libc
    @test CC.isConst(bi, abs_id)
    @test !CC.isConst(bi, trap_id)
    @test CC.isNoReturn(bi, trap_id)
    @test !CC.isNoReturn(bi, abs_id)
    @test CC.isNoThrow(bi, abs_id)
    @test !CC.isNoThrow(bi, scanf_id)
    @test CC.isLibFunction(bi, abs_id)
    @test !CC.isLibFunction(bi, trap_id)
    @test CC.isPredefinedLibFunction(bi, libprintf_id)
    @test !CC.isPredefinedLibFunction(bi, printf_id)

    # the type string is read for the pointer test rather than the attribute string, so the
    # two disagree here exactly as clang's own encoding does
    @test CC.getTypeString(bi, abs_id) == "ii"
    @test !CC.hasPtrArgsOrResult(bi, abs_id)
    @test CC.hasPtrArgsOrResult(bi, memcpy_id)

    # the format-string predicates: index 0 is the format argument and neither takes a
    # va_list, and a builtin that is neither answers nothing at all
    @test CC.isPrintfLike(bi, printf_id) == (0, false)
    @test CC.isScanfLike(bi, scanf_id) == (0, false)
    @test CC.isPrintfLike(bi, scanf_id) === nothing
    @test CC.isScanfLike(bi, printf_id) === nothing
    @test CC.isPrintfLike(bi, abs_id) === nothing

    # only a LIBBUILTIN carries a header, and the __builtin_-prefixed twin does not
    @test CC.getHeaderName(bi, libprintf_id) == "stdio.h"
    @test isempty(CC.getHeaderName(bi, printf_id))

    # the target-specific split is a bare comparison against FirstTSBuiltin, so it partitions
    # the ID space without reading a record at all
    @test !CC.isTSBuiltin(bi, abs_id)
    @test CC.isTSBuiltin(bi, first_ts)

    # Builtin::NotBuiltin has null Type and Attributes strings that every predicate would
    # walk with strchr, so it is refused rather than read.
    @test_throws AssertionError CC.getName(bi, 0)
    @test_throws AssertionError CC.isConst(bi, 0)
    @test_throws AssertionError CC.isPrintfLike(bi, 0)

    dispose(I)
end
