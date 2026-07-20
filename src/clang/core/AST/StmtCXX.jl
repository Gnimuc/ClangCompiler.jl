"""
    struct CXXCatchStmt <: AbstractCXXCatchStmt
Hold a pointer to a `clang::CXXCatchStmt` object.
"""
struct CXXCatchStmt <: AbstractCXXCatchStmt
    ptr::CXCXXCatchStmt
end

Base.unsafe_convert(::Type{CXCXXCatchStmt}, x::CXXCatchStmt) = x.ptr
Base.cconvert(::Type{CXCXXCatchStmt}, x::CXXCatchStmt) = x

"""
    struct CXXTryStmt <: AbstractCXXTryStmt
Hold a pointer to a `clang::CXXTryStmt` object.
"""
struct CXXTryStmt <: AbstractCXXTryStmt
    ptr::CXCXXTryStmt
end

Base.unsafe_convert(::Type{CXCXXTryStmt}, x::CXXTryStmt) = x.ptr
Base.cconvert(::Type{CXCXXTryStmt}, x::CXXTryStmt) = x

"""
    struct CXXForRangeStmt <: AbstractCXXForRangeStmt
Hold a pointer to a `clang::CXXForRangeStmt` object.
"""
struct CXXForRangeStmt <: AbstractCXXForRangeStmt
    ptr::CXCXXForRangeStmt
end

Base.unsafe_convert(::Type{CXCXXForRangeStmt}, x::CXXForRangeStmt) = x.ptr
Base.cconvert(::Type{CXCXXForRangeStmt}, x::CXXForRangeStmt) = x

"""
    struct MSDependentExistsStmt <: AbstractMSDependentExistsStmt
Hold a pointer to a `clang::MSDependentExistsStmt` object.
"""
struct MSDependentExistsStmt <: AbstractMSDependentExistsStmt
    ptr::CXMSDependentExistsStmt
end

Base.unsafe_convert(::Type{CXMSDependentExistsStmt}, x::MSDependentExistsStmt) = x.ptr
Base.cconvert(::Type{CXMSDependentExistsStmt}, x::MSDependentExistsStmt) = x

"""
    struct CoroutineBodyStmt <: AbstractCoroutineBodyStmt
Hold a pointer to a `clang::CoroutineBodyStmt` object.
"""
struct CoroutineBodyStmt <: AbstractCoroutineBodyStmt
    ptr::CXCoroutineBodyStmt
end

Base.unsafe_convert(::Type{CXCoroutineBodyStmt}, x::CoroutineBodyStmt) = x.ptr
Base.cconvert(::Type{CXCoroutineBodyStmt}, x::CoroutineBodyStmt) = x

"""
    struct CoreturnStmt <: AbstractCoreturnStmt
Hold a pointer to a `clang::CoreturnStmt` object.
"""
struct CoreturnStmt <: AbstractCoreturnStmt
    ptr::CXCoreturnStmt
end

Base.unsafe_convert(::Type{CXCoreturnStmt}, x::CoreturnStmt) = x.ptr
Base.cconvert(::Type{CXCoreturnStmt}, x::CoreturnStmt) = x
