"""
    struct StandardConversionSequence <: AbstractStandardConversionSequence
Hold a pointer to a `clang::StandardConversionSequence` object.
"""
struct StandardConversionSequence <: AbstractStandardConversionSequence
    ptr::CXStandardConversionSequence
end

Base.unsafe_convert(::Type{CXStandardConversionSequence}, x::StandardConversionSequence) = x.ptr
Base.cconvert(::Type{CXStandardConversionSequence}, x::StandardConversionSequence) = x

"""
    struct BadConversionSequence <: AbstractBadConversionSequence
Hold a pointer to a `clang::BadConversionSequence` object.
"""
struct BadConversionSequence <: AbstractBadConversionSequence
    ptr::CXBadConversionSequence
end

Base.unsafe_convert(::Type{CXBadConversionSequence}, x::BadConversionSequence) = x.ptr
Base.cconvert(::Type{CXBadConversionSequence}, x::BadConversionSequence) = x

"""
    struct ImplicitConversionSequence <: AbstractImplicitConversionSequence
Hold a pointer to a `clang::ImplicitConversionSequence` object.
"""
struct ImplicitConversionSequence <: AbstractImplicitConversionSequence
    ptr::CXImplicitConversionSequence
end

Base.unsafe_convert(::Type{CXImplicitConversionSequence}, x::ImplicitConversionSequence) = x.ptr
Base.cconvert(::Type{CXImplicitConversionSequence}, x::ImplicitConversionSequence) = x

"""
    struct OverloadCandidateSet <: AbstractOverloadCandidateSet
Hold a pointer to a `clang::OverloadCandidateSet` object.
"""
struct OverloadCandidateSet <: AbstractOverloadCandidateSet
    ptr::CXOverloadCandidateSet
end

Base.unsafe_convert(::Type{CXOverloadCandidateSet}, x::OverloadCandidateSet) = x.ptr
Base.cconvert(::Type{CXOverloadCandidateSet}, x::OverloadCandidateSet) = x


"""
    struct AmbiguousConversionSequence <: AbstractAmbiguousConversionSequence
Hold a pointer to a `clang::AmbiguousConversionSequence` object.
"""
struct AmbiguousConversionSequence <: AbstractAmbiguousConversionSequence
    ptr::CXAmbiguousConversionSequence
end

Base.unsafe_convert(::Type{CXAmbiguousConversionSequence}, x::AmbiguousConversionSequence) = x.ptr
Base.cconvert(::Type{CXAmbiguousConversionSequence}, x::AmbiguousConversionSequence) = x

"""
    struct OverloadCandidate <: AbstractOverloadCandidate
Hold a pointer to a `clang::OverloadCandidate` object.
"""
struct OverloadCandidate <: AbstractOverloadCandidate
    ptr::CXOverloadCandidate
end

Base.unsafe_convert(::Type{CXOverloadCandidate}, x::OverloadCandidate) = x.ptr
Base.cconvert(::Type{CXOverloadCandidate}, x::OverloadCandidate) = x


"""
    struct UserDefinedConversionSequence <: AbstractUserDefinedConversionSequence
Hold a pointer to a `clang::UserDefinedConversionSequence` object.
"""
struct UserDefinedConversionSequence <: AbstractUserDefinedConversionSequence
    ptr::CXUserDefinedConversionSequence
end

function Base.unsafe_convert(::Type{CXUserDefinedConversionSequence},
                             x::UserDefinedConversionSequence)
    return x.ptr
end
Base.cconvert(::Type{CXUserDefinedConversionSequence}, x::UserDefinedConversionSequence) = x
