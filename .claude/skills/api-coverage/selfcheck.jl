# Is the linkability oracle in candidates.jl still right?
#
#   julia --project .claude/skills/api-coverage/selfcheck.jl
#
# Eight methods whose real outcome this branch already established — two that were written and
# dropped because they would not link, two inline accessors that an exports-only check rejects
# wrongly, and four that work. A tool that misjudges any of them is worse than no tool, so this
# is the gate on changing `linkage_of`.
#
# Not part of `Pkg.test()`: it parses ~30 clang headers and needs the pinned LLVM artifact,
# which the suite has no reason to require.

const CANDIDATES_NO_MAIN = true
include(joinpath(@__DIR__, "candidates.jl"))

# (class, method, must be linkable, what actually happened)
const TRUTH = [("Sema", "CheckBitwiseOperands", false,
                "written and dropped: libclang-cpp exports neither"),
               ("Sema", "CheckLogicalOperands", false, "written and dropped: same"),
               ("Sema", "CheckFunctionConstraints", true,
                "linked; segfaulted at runtime, a different question"),
               ("Decl", "getLocation", true, "wrapped and working — INLINE, no symbol exists"),
               ("Decl", "getDeclKindName", true, "wrapped and working — exported"),
               ("CXXConstructorDecl", "isDelegatingConstructor", true,
                "wrapped and working — INLINE"),
               ("CXXConstructorDecl", "getTargetConstructor", true,
                "wrapped and working — exported"),
               ("FileManager", "getVirtualFileRef", true,
                "wrapped once _FILE_OFFSET_BITS=64 made off_t agree")]

# Coverage is a second oracle, and it can be wrong in a direction linkability cannot: reporting
# a bound method as a gap wastes a batch, and reporting an unbound one as covered hides work
# forever. §5, §6 and §7 all cross a value by renaming it, so the exact-name test that used to
# live here reported every range and every string-sink as permanently unwrapped.
#
# (class, method, must be seen as wrapped, why)
const COVERAGE_TRUTH = [("NamedDecl", "printQualifiedName", true,
                         "§5 rename: bound as getQualifiedNameAsString"),
                        ("Decl", "print", true, "§5 rename: bound as printToString"),
                        ("FunctionDecl", "getNameForDiagnostic", true,
                         "declared on NamedDecl; the base's wrapper already serves it"),
                        ("ASTContext", "getModuleInitializers", true,
                         "§6 count+index: bound as getNumModuleInitializers + singular"),
                        ("CXXRecordDecl", "getLambdaExplicitTemplateParameters", true,
                         "§6 count+index, the ArrayRef form"),
                        ("ASTContext", "getTypes", true,
                         "§6 count+index: getNumTypes + getType(Ctx, I), CXASTContext.h:387"),
                        ("Module", "getTopHeaders", false,
                         "the negative that keeps the §6 rule honest: only " *
                         "addTopHeaderFilename is bound, no getNumTopHeaders, so keying on " *
                         "the COUNT reports the gap that is really there"),
                        ("ASTContext", "getAllocator", false,
                         "genuinely absent — a BumpPtrAllocator has no C form"),
                        ("Stmt", "Profile", false,
                         "DELIBERATE under-report: clang_Stmt_getProfileHash is the §7 " *
                         "decomposition, but it shares no noun with `Profile`, and guessing " *
                         "that rename would risk marking real gaps covered")]

# (class, method, expected shape) — the classifier's own pins.
const SHAPE_TRUTH = [("Stmt", "child_begin", :range),
                     ("CXXRecordDecl", "bases_begin", :range),
                     ("CompilerInstance", "createCodeCompletionConsumer", :out_of_scope),
                     ("ASTContext", "getAllocator", :blocked)]

function check_coverage(I, wrapped)
    bad = 0
    println("\ncoverage oracle (does it see a renamed or inherited crossing?)")
    for (cls, meth, want, note) in COVERAGE_TRUTH
        got = is_wrapped(base_chain(I, cls), meth, wrapped)
        got == want || (bad += 1)
        println("  ", got == want ? "OK " : "XX ", rpad("$cls::$meth", 44),
                rpad(got ? "seen wrapped" : "seen as gap", 15), note)
    end
    return bad
end

function check_shapes(I, mc, ng, exports, wrapped)
    bad = 0
    println("\nclassifier shapes")
    for (cls, meth, want) in SHAPE_TRUTH
        rows = survey(I, mc, ng, cls, exports, wrapped)
        hits = rows === nothing ? [] : filter(r -> r.name == meth, rows)
        got = isempty(hits) ? :NOTFOUND : first(hits).shape
        got == want || (bad += 1)
        println("  ", got == want ? "OK " : "XX ", rpad("$cls::$meth", 44),
                rpad(string(got), 16), "want ", want)
    end
    return bad
end

function main_selfcheck()
    exports = exported_symbols()
    wrapped = wrapped_names()
    I = CC.create_interpreter(["-std=c++17", "-I", joinpath(ART, "include"), "-fno-rtti"])
    bad = 0
    try
        CC.parse(I, join("#include \"" .* HEADERS .* "\"\n"))
        ctx = CC.get_ast_context(I)
        mc = CC.createMangleContext(ctx, CC.getTargetInfo(ctx))
        ng = CC.ASTNameGenerator(ctx)
        try
            for (cls, meth, want, note) in TRUTH
                rows = survey(I, mc, ng, cls, exports, wrapped)
                hits = rows === nothing ? [] : filter(r -> r.name == meth, rows)
                if isempty(hits)
                    println("  ?? $cls::$meth — not found in the parsed headers")
                    bad += 1
                    continue
                end
                got = any(h -> h.linkage != :missing, hits)
                got == want || (bad += 1)
                println("  ", got == want ? "OK " : "XX ",
                        rpad("$cls::$meth", 44),
                        rpad(got ? "linkable" : "NOT linkable", 14),
                        "[", join(unique(string(h.linkage) for h in hits), ","), "]  ", note)
            end
            bad += check_coverage(I, wrapped)
            bad += check_shapes(I, mc, ng, exports, wrapped)
        finally
            CC.dispose(ng)
            CC.dispose(mc)
        end
    finally
        CC.dispose(I)
    end
    total = length(TRUTH) + length(COVERAGE_TRUTH) + length(SHAPE_TRUTH)
    println("\n$(total - bad)/$total agree with what this branch actually established")
    return bad == 0 ? 0 : 1
end

exit(main_selfcheck())
