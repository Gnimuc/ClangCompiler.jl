using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: dispose
using Test

@testset "MultiplexConsumer owns its children and installs as one consumer" begin
    # The guards first, while nothing has been handed over: each of these would otherwise
    # end in a double free inside clang's vector of unique_ptrs.
    lone = CC.ASTConsumer()
    @test_throws AssertionError CC.MultiplexConsumer(CC.ASTConsumer[])
    @test_throws AssertionError CC.MultiplexConsumer([lone, lone])
    @test_throws AssertionError CC.MultiplexConsumer([lone, CC.ASTConsumer(C_NULL)])
    dispose(lone)

    a = CC.ASTConsumer()
    b = CC.ASTConsumer()
    mc = CC.MultiplexConsumer([a, b])
    @test mc.ptr != C_NULL
    # The multiplexer is a new object, not one of the children handed back.
    @test mc.ptr != a.ptr
    @test mc.ptr != b.ptr

    # A CompilerInstance holds exactly one consumer, and this is how two get in: the
    # instance ends up holding the multiplexer itself.
    ci = CC.CompilerInstance()
    @test CC.hasASTConsumer(ci) == false
    CC.setASTConsumer(ci, mc)
    @test CC.hasASTConsumer(ci) == true
    @test CC.getASTConsumer(ci).ptr == mc.ptr

    # Undo the adoption before disposing either owner, so exactly one of them frees the
    # multiplexer -- and with it `a` and `b`, which it took ownership of at construction.
    taken = CC.takeASTConsumer(ci)
    @test taken.ptr == mc.ptr
    @test CC.hasASTConsumer(ci) == false
    dispose(ci)
    dispose(mc)
end
