# Local abstract type: clang::LiveVariables derives from ManagedAnalysis, which is not
# wrapped (it is an empty registration base for AnalysisDeclContext::getAnalysis<T>).
abstract type AbstractLiveVariables end

"""
    struct LiveVariables <: AbstractLiveVariables
Hold a pointer to a `clang::LiveVariables` object.

The pointee is caller-owned ([`computeLiveness`](@ref) releases clang's `std::unique_ptr`) —
call `dispose` after use. It borrows the `AnalysisDeclContext` it was computed over, so that
context has to outlive it.
"""
struct LiveVariables <: AbstractLiveVariables
    ptr::CXLiveVariables
end
