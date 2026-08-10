# MultiplexConsumer
"""
    MultiplexConsumer(children::Vector{<:AbstractASTConsumer}) -> MultiplexConsumer
Build an `ASTConsumer` that forwards every callback to `children` in order.

A `CompilerInstance` holds exactly one consumer, so this is the only way to run two over one
parse — code generation beside PCH generation, or beside an AST printer.

The multiplexer **takes ownership of every child**, matching
`clang::MultiplexConsumer`'s `vector<unique_ptr<ASTConsumer>>` constructor: a child's own
disposal is a double free once this returns, whether or not the multiplexer is ever
installed. Passing the same consumer twice hands it over twice and is a double free on its
own.

This function allocates and one should call `dispose` to release the resources after using
this object — unless [`setASTConsumer`](@ref) has adopted it first, at which point the
instance frees it (and, through it, the children) and disposing it here is a double free;
[`takeASTConsumer`](@ref) is how that adoption is undone.
"""
function MultiplexConsumer(children::Vector{<:AbstractASTConsumer})
    @assert !isempty(children) "MultiplexConsumer needs at least one child consumer"
    for c in children
        @check_ptrs c
    end
    handles = [Base.unsafe_convert(CXASTConsumer, c) for c in children]
    @assert length(unique(handles)) == length(handles) "a consumer may only be handed over once"
    csr = clang_MultiplexConsumer_create(handles, length(handles))
    @assert csr != C_NULL "Failed to create MultiplexConsumer"
    return MultiplexConsumer(csr)
end

dispose(x::MultiplexConsumer) = clang_ASTConsumer_dispose(x)
