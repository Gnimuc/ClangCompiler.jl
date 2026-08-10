using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: dispose
using Test

# HeaderSearchOptions is the bag a hand-assembled CompilerInstance is configured through.
# The defaults asserted here are the ones clang/Lex/HeaderSearchOptions.h's constructor
# sets; the rest are round trips over a throwaway instance.

@testset "HeaderSearchOptions | defaults and round trips" begin
    ci = CC.CompilerInstance()
    hso = CC.getHeaderSearchOpts(ci)

    # HeaderSearchOptions(StringRef _Sysroot = "/") is the only default with a value
    @test CC.getSysroot(hso) == "/"
    @test CC.getModuleCachePath(hso) == ""
    @test CC.getUseBuiltinIncludes(hso) == true
    @test CC.getUseStandardSystemIncludes(hso) == true
    @test CC.getUseStandardCXXIncludes(hso) == true
    @test CC.getVerbose(hso) == false

    CC.setSysroot(hso, "/probe/sysroot")
    @test CC.getSysroot(hso) == "/probe/sysroot"
    CC.setSysroot(hso, "/")
    @test CC.getSysroot(hso) == "/"

    cache = mktempdir()
    CC.setModuleCachePath(hso, cache)
    @test CC.getModuleCachePath(hso) == cache
    CC.setModuleCachePath(hso, "")
    @test CC.getModuleCachePath(hso) == ""

    for (getter, setter) in ((CC.getUseBuiltinIncludes, CC.setUseBuiltinIncludes),
                             (CC.getUseStandardSystemIncludes,
                              CC.setUseStandardSystemIncludes),
                             (CC.getUseStandardCXXIncludes,
                              CC.setUseStandardCXXIncludes),
                             (CC.getVerbose, CC.setVerbose))
        old = getter(hso)
        setter(hso, !old)
        @test getter(hso) == !old
        setter(hso, old)
        @test getter(hso) == old
    end

    # the six above are separate fields, not aliases of one another: flipping one leaves
    # the rest where they were
    CC.setVerbose(hso, true)
    @test CC.getUseBuiltinIncludes(hso) == true
    @test CC.getUseStandardSystemIncludes(hso) == true
    @test CC.getUseStandardCXXIncludes(hso) == true
    CC.setVerbose(hso, false)

    # ResourceDir has its own pair and is untouched by the new ones
    CC.SetResourceDir(hso, "/probe/resource")
    @test CC.GetResourceDir(hso) == "/probe/resource"
    @test CC.getSysroot(hso) == "/"

    dispose(ci)
end
