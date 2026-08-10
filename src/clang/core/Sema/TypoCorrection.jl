"""
    abstract type AbstractTypoCorrection <: Any
Supertype for `clang::TypoCorrection`s.
"""
abstract type AbstractTypoCorrection end

"""
    struct TypoCorrection <: AbstractTypoCorrection
Hold a pointer to a `clang::TypoCorrection` object.
"""
struct TypoCorrection <: AbstractTypoCorrection
    ptr::CXTypoCorrection
end

"""
    abstract type AbstractCorrectionCandidateCallback <: Any
Supertype for `clang::CorrectionCandidateCallback`s.
"""
abstract type AbstractCorrectionCandidateCallback end

"""
    struct CorrectionCandidateCallback <: AbstractCorrectionCandidateCallback
Hold a pointer to a `clang::CorrectionCandidateCallback` object.
"""
struct CorrectionCandidateCallback <: AbstractCorrectionCandidateCallback
    ptr::CXCorrectionCandidateCallback
end
