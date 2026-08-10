"""
    abstract type AbstractFixItRewriter <: Any
Supertype for `FixItRewriter`s.
"""
abstract type AbstractFixItRewriter end

"""
    struct FixItRewriter <: AbstractFixItRewriter
Hold a pointer to a `clang::FixItRewriter` object.

The handle designates a box libclangex allocates: `clang::FixItRewriter` keeps its
`FixItOptions` as a raw pointer it does not own, so the shim keeps the two together.
`clang::FixItRewriter` is a `clang::DiagnosticConsumer`, but the carrier deliberately does
not subtype `AbstractDiagnosticConsumer` — the handle is the box, not the consumer, and the
`DiagnosticsEngine` already holds the consumer pointer from the moment the rewriter is
created.
"""
struct FixItRewriter <: AbstractFixItRewriter
    ptr::CXFixItRewriter
end
