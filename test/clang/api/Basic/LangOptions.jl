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
    @test CC.trackLocalOwningModule(lo) isa Bool
    @test CC.getDefaultExceptionMode(lo) == CC.CXFPExceptionModeKind_FPE_Ignore

    dispose(inv)
end
