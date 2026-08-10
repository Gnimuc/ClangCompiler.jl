using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, get_instance
using Test

# TrivialModuleLoader exists so that a Preprocessor can be constructed without the
# CompilerInstance that would otherwise supply a ModuleLoader &. It answers nothing, so
# what is asserted here is its identity and its ownership.

@testset "TrivialModuleLoader | create, distinctness and dispose" begin
    a = CC.TrivialModuleLoader()
    @test !CC.is_null_handle(a)
    b = CC.TrivialModuleLoader()
    # each call is its own object rather than a shared singleton, which is what makes
    # disposing one safe while the other is still in use
    @test b.ptr != a.ptr
    dispose(b)
    dispose(a)

    # the loader a preprocessor already owns is borrowed, and `dispose` is deliberately
    # defined only on the owned carrier so it cannot reach that one
    @test hasmethod(dispose, Tuple{CC.TrivialModuleLoader})
    @test !hasmethod(dispose, Tuple{CC.ModuleLoader})

    I = create_interpreter(String[])
    pp = CC.getPreprocessor(get_instance(I))
    borrowed = CC.getModuleLoader(pp)
    @test !CC.is_null_handle(borrowed)
    c = CC.TrivialModuleLoader()
    @test c.ptr != borrowed.ptr
    dispose(c)
    dispose(I)
end
