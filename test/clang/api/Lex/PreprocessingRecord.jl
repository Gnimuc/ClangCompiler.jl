using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Test

@testset "preprocessing record entities, casts and skipped ranges" begin
    # A preprocessing record installs itself on the callback chain for good and records
    # every directive the preprocessor sees afterwards, so the interpreter is a throwaway
    # this testset owns.
    I = create_interpreter()
    pp = CC.getPreprocessor(get_instance(I))
    CC.createPreprocessingRecord(pp)
    rec = CC.getPreprocessingRecord(pp)
    @test rec isa CC.PreprocessingRecord
    @test rec.ptr != C_NULL

    # the record was constructed with the preprocessor's own source manager
    @test !CC.is_null_handle(CC.getSourceManager(rec))
    @test CC.getSourceManager(rec).ptr == CC.getSourceManager(pp).ptr

    # the predefines were preprocessed before the record existed, so it starts empty
    @test CC.getNumPreprocessedEntities(rec) == 0
    @test isempty(CC.getPreprocessedEntities(rec))
    @test CC.getNumSkippedRanges(rec) == 0
    @test isempty(CC.getSkippedRanges(rec))

    hdr, io = mktemp()
    write(io, "int cc_pprec_from_header = 1;\n")
    close(io)
    # an absolute quoted include needs no search path, and clang takes forward slashes on
    # every host — a Windows temp path would otherwise carry escapes into the C literal
    hdr_spelling = replace(hdr, '\\' => '/')

    CC.parse(I, """
                #define CC_PPREC_OBJ 7
                #include "$hdr_spelling"
                #if 0
                int cc_pprec_dead = 0;
                #endif
                int cc_pprec_use = CC_PPREC_OBJ;
                """)

    n = CC.getNumPreprocessedEntities(rec)
    @test n isa Integer
    @test n ≥ 3
    ents = CC.getPreprocessedEntities(rec)
    @test length(ents) == n
    @test all(e -> e isa CC.PreprocessedEntity && e.ptr != C_NULL, ents)
    @test all(e -> !CC.isInvalid(e), ents)
    @test all(e -> CC.getKind(e) isa CC.LibClangEx.CXPreprocessedEntityKind, ents)
    @test all(e -> CC.isValid(CC.getSourceRange(e).begin_loc), ents)
    @test_throws AssertionError CC.getPreprocessedEntity(rec, n)

    # pick out the three entities this testset's own directives produced
    def_ent, exp_ent, inc_ent = nothing, nothing, nothing
    for e in ents
        k = CC.getKind(e)
        if k == CC.LibClangEx.CXPreprocessedEntityKind_MacroDefinitionKind
            d = CC.MacroDefinitionRecord(e)
            CC.getName(CC.getName(d)) == "CC_PPREC_OBJ" && (def_ent = e)
        elseif k == CC.LibClangEx.CXPreprocessedEntityKind_MacroExpansionKind
            m = CC.MacroExpansion(e)
            CC.getName(CC.getName(m)) == "CC_PPREC_OBJ" && (exp_ent = e)
        elseif k == CC.LibClangEx.CXPreprocessedEntityKind_InclusionDirectiveKind
            inc_ent = e
        end
    end
    @test def_ent !== nothing
    @test exp_ent !== nothing
    @test inc_ent !== nothing

    def = CC.MacroDefinitionRecord(def_ent)
    @test def.ptr != C_NULL
    @test CC.getName(def) isa CC.IdentifierInfo
    @test CC.getName(CC.getName(def)) == "CC_PPREC_OBJ"
    @test CC.isValid(CC.getLocation(def))
    # the PreprocessedEntity casts are dyn_cast: a wrong one yields a NULL carrier, not a lie
    @test CC.MacroExpansion(def_ent).ptr == C_NULL
    @test CC.InclusionDirective(def_ent).ptr == C_NULL

    exp = CC.MacroExpansion(exp_ent)
    @test exp.ptr != C_NULL
    @test CC.isBuiltinMacro(exp) == false
    @test CC.getName(exp) isa CC.IdentifierInfo
    @test CC.getDefinition(exp).ptr == def.ptr

    inc = CC.InclusionDirective(inc_ent)
    @test inc.ptr != C_NULL
    @test CC.getFileName(inc) == hdr_spelling
    @test CC.wasInQuotes(inc) == true
    @test CC.importedModule(inc) == false
    # getKind on the directive reports the directive spelling, not the entity kind
    @test CC.getKind(inc) == CC.LibClangEx.CXInclusionKind_Include

    # the `#if 0` body was skipped, and every skipped range spans real locations
    ns = CC.getNumSkippedRanges(rec)
    @test ns ≥ 1
    ranges = CC.getSkippedRanges(rec)
    @test length(ranges) == ns
    @test all(r -> r isa CC.SourceRange, ranges)
    @test all(r -> CC.isValid(r.begin_loc) && CC.isValid(r.end_loc), ranges)
    @test_throws AssertionError CC.getSkippedRange(rec, ns)

    # the record indexes its definitions by the MacroInfo the preprocessor still holds
    ii = CC.getIdentifierInfo(pp, "CC_PPREC_OBJ")
    mi = CC.getMacroInfo(pp, ii)
    @test mi.ptr != C_NULL
    @test CC.findMacroDefinition(rec, mi).ptr == def.ptr
    # a macro defined before the record existed was never registered with it
    mi_pre = CC.getMacroInfo(pp, CC.getIdentifierInfo(pp, "__cplusplus"))
    @test mi_pre.ptr == C_NULL || CC.findMacroDefinition(rec, mi_pre).ptr == C_NULL

    dispose(I)
    rm(hdr; force=true)
end

@testset "PreprocessingRecord | accumulated memory" begin
    I = create_interpreter(String[])
    pp = CC.getPreprocessor(CC.get_instance(I))
    CC.createPreprocessingRecord(pp)
    rec = CC.getPreprocessingRecord(pp)
    @test !CC.is_null_handle(rec)

    before = CC.getTotalMemory(rec)
    CC.parse(I, """
             #define PPREC_MEM_A 1
             #define PPREC_MEM_B 2
             #define PPREC_MEM_C 3
             int pprec_mem_probe = PPREC_MEM_A + PPREC_MEM_B + PPREC_MEM_C;
             """)
    after = CC.getTotalMemory(rec)
    # recording more preprocessing history cannot shrink the record
    @test after >= before

    dispose(I)
end
