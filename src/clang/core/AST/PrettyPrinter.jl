abstract type AbstractPrintingPolicy end

"""
    struct PrintingPolicy <: AbstractPrintingPolicy
Hold a pointer to a `clang::PrintingPolicy` object.

A policy from `PrintingPolicy(opts)` or `PrintingPolicy(other)` is caller-owned and released with
`dispose`; the one [`getPrintingPolicy`](@ref) returns is borrowed from its `ASTContext` and
must never be disposed.
"""
struct PrintingPolicy <: AbstractPrintingPolicy
    ptr::CXPrintingPolicy_
end

