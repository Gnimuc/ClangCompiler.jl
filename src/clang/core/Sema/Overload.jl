"""
    struct StandardConversionSequence <: AbstractStandardConversionSequence
Hold a pointer to a `clang::StandardConversionSequence` object.
"""
struct StandardConversionSequence <: AbstractStandardConversionSequence
    ptr::CXStandardConversionSequence
end

"""
    struct BadConversionSequence <: AbstractBadConversionSequence
Hold a pointer to a `clang::BadConversionSequence` object.
"""
struct BadConversionSequence <: AbstractBadConversionSequence
    ptr::CXBadConversionSequence
end

"""
    struct ImplicitConversionSequence <: AbstractImplicitConversionSequence
Hold a pointer to a `clang::ImplicitConversionSequence` object.
"""
struct ImplicitConversionSequence <: AbstractImplicitConversionSequence
    ptr::CXImplicitConversionSequence
end

"""
    struct OverloadCandidateSet <: AbstractOverloadCandidateSet
Hold a pointer to a `clang::OverloadCandidateSet` object.
"""
struct OverloadCandidateSet <: AbstractOverloadCandidateSet
    ptr::CXOverloadCandidateSet
end

"""
    struct AmbiguousConversionSequence <: AbstractAmbiguousConversionSequence
Hold a pointer to a `clang::AmbiguousConversionSequence` object.
"""
struct AmbiguousConversionSequence <: AbstractAmbiguousConversionSequence
    ptr::CXAmbiguousConversionSequence
end

"""
    struct OverloadCandidate <: AbstractOverloadCandidate
Hold a pointer to a `clang::OverloadCandidate` object.
"""
struct OverloadCandidate <: AbstractOverloadCandidate
    ptr::CXOverloadCandidate
end

"""
    struct UserDefinedConversionSequence <: AbstractUserDefinedConversionSequence
Hold a pointer to a `clang::UserDefinedConversionSequence` object.
"""
struct UserDefinedConversionSequence <: AbstractUserDefinedConversionSequence
    ptr::CXUserDefinedConversionSequence
end
