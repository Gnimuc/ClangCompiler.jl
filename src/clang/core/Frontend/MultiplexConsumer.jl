"""
    struct MultiplexConsumer <: AbstractMultiplexConsumer
Hold a pointer to a `clang::MultiplexConsumer` object.

An `ASTConsumer` that forwards every callback to a list of children and owns them, which is
the only way to run two consumers over one parse: a `CompilerInstance` holds exactly one.
"""
struct MultiplexConsumer <: AbstractMultiplexConsumer
    ptr::CXASTConsumer
end
