using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Test

@testset "LangOptions defaults and the FPOptions encoding" begin
    # A default-constructed invocation owns a pristine LangOptions. The interpreter's own
    # options must never be touched here — resetNonModularOptions below mutates in place.
    inv = CC.CompilerInvocation(CC.LibClangEx.clang_CompilerInvocation_create())
    lo = CC.getLangOpts(inv)

    @test CC.trackLocalOwningModule(lo) == false
    @test CC.allowsNonTrivialObjCLifetimeQualifiers(lo) == false

    # MSCompatibilityVersion defaults to 0, so no MSVC release compares compatible
    @test CC.isCompatibleWithMSVC(lo, CC.CXMSVCMajorVersion_MSVC2010) == false
    @test CC.isCompatibleWithMSVC(lo, CC.CXMSVCMajorVersion_MSVC2022_3) == false

    # LangOptions.def defaults: SignReturnAddressScope::None, SignReturnAddressKey::AKey
    @test CC.hasSignReturnAddress(lo) == false
    @test CC.isSignReturnAddressScopeAll(lo) == false
    @test CC.isSignReturnAddressWithAKey(lo) == true

    # DefaultVisibilityExportMapping::None
    @test CC.hasDefaultVisibilityExportMapping(lo) == false
    @test CC.isExplicitDefaultVisibilityExportMapping(lo) == false
    @test CC.isAllDefaultVisibilityExportMapping(lo) == false

    # GlobalAllocationFunctionVisibility::ForceDefault
    @test CC.hasGlobalAllocationFunctionVisibility(lo) == true
    @test CC.hasDefaultGlobalAllocationFunctionVisibility(lo) == true
    @test CC.hasProtectedGlobalAllocationFunctionVisibility(lo) == false
    @test CC.hasHiddenGlobalAllocationFunctionVisibility(lo) == false

    # An empty -fmacro-prefix-path map leaves every path alone
    @test CC.remapPathPrefix(lo, "/build/src/main.cpp") == "/build/src/main.cpp"

    # RoundingMath is off and FPExceptionMode is the FPE_Default placeholder
    @test CC.getDefaultRoundingMode(lo) == CC.CXRoundingMode_NearestTiesToEven
    @test CC.getDefaultExceptionMode(lo) == CC.CXFPExceptionModeKind_FPE_Ignore

    # FPOptions crosses as its opaque 32-bit word, decoded by the FPOptions accessors
    fp = CC.defaultWithoutTrailingStorage(lo)
    @test fp isa Unsigned
    @test CC.getRoundingMode(fp) == CC.CXRoundingMode_NearestTiesToEven
    @test CC.getExceptionMode(fp) == CC.CXFPExceptionModeKind_FPE_Ignore

    # Mutating reset lands on the throwaway and leaves it readable
    CC.resetNonModularOptions(lo)
    @test !(CC.trackLocalOwningModule(lo))
    @test CC.getDefaultExceptionMode(lo) == CC.CXFPExceptionModeKind_FPE_Ignore

    dispose(inv)
end

@testset "LangOptions | FPOptions contraction modes and overrides" begin
    # the three contraction modes are reached with `#pragma clang fp contract`, which is only
    # legal at the head of a compound statement -- so each mode gets its own nested block
    I = create_interpreter(String[])
    CC.parse(I, """
             extern "C" float fpo_probe(float a, float b, float c) {
                 float d = a * b + c;
                 float e, f;
                 { 
             #pragma clang fp contract(fast)
                     e = a * b + c;
                 }
                 { 
             #pragma clang fp contract(off)
                     f = a * b + c;
                 }
                 return d + e + f;
             }
             """)
    lo = CC.getLangOpts(CC.get_instance(I))
    base = CC.defaultWithoutTrailingStorage(lo)

    f = DeclFinder(I)
    @test f(I, "fpo_probe")
    fd = CC.FunctionDecl(get_decl(f))
    binops = [s for s in (CC.resolve(x) for x in CC.subtree(CC.getBody(fd)))
              if s isa CC.BinaryOperator]
    words = unique([CC.getFPFeaturesInEffect(b, lo) for b in binops])

    # whatever the modes present, the two contraction predicates are mutually exclusive on
    # every word -- that is the invariant, independent of which pragma reached which node
    for w in words
        @test !(CC.allowFPContractWithinStatement(w) && CC.allowFPContractAcrossStatement(w))
        # a word is constrained exactly when it departs from ignored exceptions / default rounding
        @test CC.isFPConstrained(w) ==
              (CC.getExceptionMode(w) != CC.CXFPExceptionModeKind_FPE_Ignore ||
               CC.getRoundingMode(w) != CC.CXRoundingMode_NearestTiesToEven)
    end
    # the pragmas produced more than one distinct mode, so the predicates discriminate
    @test length(words) > 1
    @test any(CC.allowFPContractAcrossStatement, words)

    # a word differs from itself by nothing, and from the default by something once a pragma
    # has moved it
    for w in words
        @test CC.getChangesFrom(w, w) == 0
    end
    @test any(w -> CC.getChangesFrom(w, base) != 0, words)

    # an override round-trips: applying the difference back to the base reproduces the word.
    # This is exact even though getChangesFrom may leave junk in non-overridden value bits,
    # because applyOverrides masks them off -- and it fails for a shim that ignores the base,
    # swaps its arguments, or truncates the 64-bit word.
    for w in words
        @test CC.applyOverrides(CC.getChangesFrom(w, base), base) == w
    end
    # an empty override changes nothing and needs no trailing storage
    @test CC.applyOverrides(0, base) == base
    @test !CC.requiresTrailingStorage(0)
    # a word that differs from the base does need it
    @test all(w -> CC.requiresTrailingStorage(CC.getChangesFrom(w, base)) ==
                   (CC.applyOverrides(CC.getChangesFrom(w, base), base) != base), words)

    # the three setters name the three modes, and each is visible through the decoders once
    # applied to the base
    on = CC.applyOverrides(CC.setAllowFPContractWithinStatement(0), base)
    fast = CC.applyOverrides(CC.setAllowFPContractAcrossStatement(0), base)
    off = CC.applyOverrides(CC.setDisallowFPContract(0), base)
    @test CC.allowFPContractWithinStatement(on) && !CC.allowFPContractAcrossStatement(on)
    @test CC.allowFPContractAcrossStatement(fast) && !CC.allowFPContractWithinStatement(fast)
    @test !CC.allowFPContractWithinStatement(off) && !CC.allowFPContractAcrossStatement(off)
    # three distinct modes, so the setters are not aliases of one another
    @test length(unique([on, fast, off])) == 3

    dispose(f)
    dispose(I)
end

@testset "LangOptions | the Microsoft-extensions gate" begin
    # Exposed for the same reason as getBorland: it gates a wrapper that would otherwise
    # reach unchecked into state clang only builds under these options. Two interpreters
    # differing only in the flag give an equality rather than a shape assertion.
    off = create_interpreter(["-std=c++17"])
    on = create_interpreter(["-std=c++17", "-fms-extensions"])
    @test CC.getMicrosoftExt(CC.getLangOpts(CC.get_sema(off))) == false
    @test CC.getMicrosoftExt(CC.getLangOpts(CC.get_sema(on))) == true
    # Without the flag clang never builds the implicit `_GUID` record, and asking for its type
    # aborts inside ASTContext rather than returning anything -- so the wrapper asserts first.
    # This assertion is what the gate is for; it fired for real before the guard was added.
    @test CC.getMSGuidTagDecl(CC.get_ast_context(off)).ptr == C_NULL
    @test_throws AssertionError CC.getMSGuidType(CC.get_ast_context(off))
    @test CC.getMSGuidTagDecl(CC.get_ast_context(on)).ptr != C_NULL
    @test !CC.is_null_handle(CC.get_qual_type(CC.getMSGuidType(CC.get_ast_context(on))))
    dispose(off)
    dispose(on)
end
