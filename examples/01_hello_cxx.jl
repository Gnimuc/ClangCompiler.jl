# 01 — hello, C++
#
# ClangCompiler.jl embeds a real clang in your Julia session: clang's *incremental* interpreter —
# the engine behind `clang-repl` — a live CompilerInstance whose translation unit never closes,
# wired to an ORC JIT that emits machine code straight into this process. A C++ function compiled
# here is just a function pointer, so Julia can `ccall` it. No shared library, no build step, and
# nothing written to disk.
#
# Run me:  julia --project examples/01_hello_cxx.jl

import ClangCompiler as CC   # the package exports nothing (it uses `public`), so calls stay qualified
using Printf, Statistics

hdr(t) = @printf("\n== %s %s\n", t, "="^max(0, 88 - length(t)))

# Nothing below is merely printed: every answer C++ gives is checked against Julia's, so a
# disagreement stops the example instead of scrolling past.
function agree(what, cxx, julia)
    ok = cxx ≈ julia
    @printf("   %-16s %-24s %-24s %s\n", what, string(cxx), string(julia), ok ? "ok" : "MISMATCH")
    ok || error("C++ and Julia disagree on $what")
end

hdr("1. a live compiler")
# The interpreter is hermetic on purpose: the default flags switch the system include paths off and
# re-open them at directories unpacked from Julia artifacts, so nothing about your machine's own
# toolchain leaks in. That is also why a standard header must be asked for by name — `-include cmath`
# puts <cmath> in front of the session's single open translation unit, which every snippet extends.
I = CC.create_interpreter(["-include", "cmath"])
@printf("   clang is up; hermetic by construction: %s\n",
        join(filter(f -> startswith(f, "-nostd"), CC.get_default_args()), " "))

hdr("2. compiling C++ into this process")
# Welford's online algorithm: mean and variance in one numerically stable pass. The entry point is
# `extern "C"` because `get_function_pointer` looks a symbol up by the name it carries in the emitted
# *IR*, and without C linkage that name is mangled. §2b asks clang what it would have been rather
# than naming one here — the mangling scheme is a property of the target, not of C++.
ptu = CC.parse(I, """
    struct Stats { double mean; double var; long n; };

    extern "C" Stats stats_of(const double *p, long n) {
        double mean = 0.0, m2 = 0.0;
        for (long i = 0; i < n; ++i) {
            double d = p[i] - mean;
            mean += d / (double)(i + 1);       // running mean
            m2 += d * (p[i] - mean);           // running sum of squared deviations
        }
        return Stats{mean, n > 1 ? m2 / (double)(n - 1) : 0.0, n};
    }
""")
# `parse` returns a PartialTranslationUnit: the AST for this chunk plus the LLVM IR clang lowered it
# to. It is not runnable yet — `execute` is what hands that IR to the JIT.
println("   parse   -> ", typeof(ptu), " (AST + LLVM IR for this chunk)")
CC.execute(I, ptu)
stats_of = CC.get_function_pointer(I, "stats_of")
@printf("   execute -> JIT emitted it; `stats_of` is live machine code at 0x%x\n", UInt(stats_of))

# 2b. What `extern "C"` bought. The same signature with C++ linkage gets a name that encodes the
# whole parameter list, and it is the mangler for *this* target that decides how — Itanium here
# and on any GCC-shard target, a different scheme entirely under MSVC. So ask, do not assume.
CC.parse(I, "Stats stats_of_cxx(const double *p, long n) { return stats_of(p, n); }")
# The signature is deliberately primitive (`const double *`, `long`): a std-library type would
# mangle differently under libc++ and libstdc++, and this file runs on all three platforms.
let ctx = CC.get_ast_context(I)
    mc = CC.createMangleContext(ctx, CC.getTargetInfo(ctx))
    @printf("   with C linkage    -> %s\n", "stats_of")
    @printf("   without it        -> %s\n", CC.mangleName(mc, CC.find_decl(I, "stats_of_cxx")))
end

hdr("3. calling it from Julia")
# `samples` is never copied: `ccall` hands C++ a pointer into Julia's own array memory, and the
# 24-byte `Stats` comes back by value under the platform C ABI. Both directions work only because
# the two languages agree byte-for-byte on the layout — which §4 makes clang prove.
struct Stats
    mean::Float64
    var::Float64
    n::Clong
end

samples = [2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0]
cxx = ccall(stats_of, Stats, (Ptr{Float64}, Clong), samples, length(samples))

@printf("   samples: %s\n\n", string(samples))
@printf("   %-16s %-24s %-24s\n", "", "C++ (JIT'd, Welford)", "Julia (Statistics)")
agree("mean", cxx.mean, mean(samples))
agree("var", cxx.var, var(samples))
agree("n", cxx.n, length(samples))

hdr("4. why the struct survived the trip")
# We do not guess the layout, we ask clang for it. `find_decl` performs a real C++ name lookup and
# returns the concrete class (a CXXRecordDecl, already resolved — not some base carrier), and its
# ASTRecordLayout is the very layout the code generator used a moment ago. Field offsets come in
# bits and the record size in bytes, so only one of the two below needs dividing.
ctx = CC.get_ast_context(I)
rd = CC.find_decl(I, "Stats")
layout = CC.get_record_layout(ctx, rd)

println("   clang says `struct Stats` is a ", typeof(rd), "; field offsets, in bytes:\n")
@printf("   %-16s %-24s %-24s\n", "field", "clang (ASTRecordLayout)", "Julia (fieldoffset)")
for (i, (field, bitoff)) in enumerate(zip(CC.getFields(rd), CC.field_offsets(ctx, rd)))
    agree(CC.getName(field), Int(bitoff) ÷ 8, Int(fieldoffset(Stats, i)))
end
agree("sizeof", Int(CC.getSize(layout)), sizeof(Stats))

hdr("5. incrementality — what an interpreter gives you")
# An ordinary compiler is finished when the translation unit ends. This one's stays open. The
# snippet below is a *second* chunk fed to the same Sema and the same JIT, so name lookup finds
# `Stats` and `stats_of` from the first chunk, and the call binds to machine code already emitted.
# `compile` is just parse + execute in one step.
CC.compile(I, """
    extern "C" long count_outliers(const double *p, long n, double k) {
        Stats s = stats_of(p, n);                  // both names came from the previous chunk
        double sd = std::sqrt(s.var);              // std::sqrt came from -include cmath
        long hits = 0;
        for (long i = 0; i < n; ++i)
            if (std::abs(p[i] - s.mean) > k * sd) ++hits;
        return hits;
    }
""")

# Each chunk gets its own in-memory buffer and clang remembers which one every declaration came
# from — the two buffer names below are two translation-unit parts sharing one AST.
for name in ("stats_of", "count_outliers")
    loc = CC.source_location(I, CC.find_decl(I, name))
    @printf("   %-16s declared in buffer %s, line %d\n", name, loc.file, loc.line)
end

count_outliers = CC.get_function_pointer(I, "count_outliers")
println("\n   samples further than k standard deviations from the mean:\n")
@printf("   %-16s %-24s %-24s\n", "", "C++ (JIT'd)", "Julia")
for k in (0.5, 1.0, 1.5)
    hits = ccall(count_outliers, Clong, (Ptr{Float64}, Clong, Float64), samples, length(samples), k)
    agree("k = $k", hits, count(x -> abs(x - mean(samples)) > k * std(samples), samples))
end

hdr("6. cleanup")
# create -> use -> dispose, the pattern every resource in this package follows. Disposing tears down
# the CompilerInstance, the AST and the JIT'd code together, so every pointer taken above dangles
# afterwards: never let one outlive the interpreter that produced it.
CC.dispose(I)
println("   interpreter disposed; `stats_of` and `count_outliers` went with it\n")
