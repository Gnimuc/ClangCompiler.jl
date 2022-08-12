"""
    struct CXXCatchStmt <: AbstractStmt
Hold a pointer to a `clang::CXXCatchStmt` object.
"""
struct CXXCatchStmt <: AbstractStmt
    ptr::CXCXXCatchStmt
end

Base.unsafe_convert(::Type{CXCXXCatchStmt}, x::CXXCatchStmt) = x.ptr
Base.cconvert(::Type{CXCXXCatchStmt}, x::CXXCatchStmt) = x

"""
    struct CXXTryStmt <: AbstractStmt
Hold a pointer to a `clang::CXXTryStmt` object.
"""
struct CXXTryStmt <: AbstractStmt
    ptr::CXCXXTryStmt
end

Base.unsafe_convert(::Type{CXCXXTryStmt}, x::CXXTryStmt) = x.ptr
Base.cconvert(::Type{CXCXXTryStmt}, x::CXXTryStmt) = x

"""
    struct CXXForRangeStmt <: AbstractStmt
Hold a pointer to a `clang::CXXForRangeStmt` object.
"""
struct CXXForRangeStmt <: AbstractStmt
    ptr::CXCXXForRangeStmt
end

Base.unsafe_convert(::Type{CXCXXForRangeStmt}, x::CXXForRangeStmt) = x.ptr
Base.cconvert(::Type{CXCXXForRangeStmt}, x::CXXForRangeStmt) = x

"""
    struct MSDependentExistsStmt <: AbstractStmt
Hold a pointer to a `clang::MSDependentExistsStmt` object.
"""
struct MSDependentExistsStmt <: AbstractStmt
    ptr::CXMSDependentExistsStmt
end

Base.unsafe_convert(::Type{CXMSDependentExistsStmt}, x::MSDependentExistsStmt) = x.ptr
Base.cconvert(::Type{CXMSDependentExistsStmt}, x::MSDependentExistsStmt) = x

"""
    struct CoroutineBodyStmt <: AbstractStmt
Hold a pointer to a `clang::CoroutineBodyStmt` object.
"""
struct CoroutineBodyStmt <: AbstractStmt
    ptr::CXCoroutineBodyStmt
end

Base.unsafe_convert(::Type{CXCoroutineBodyStmt}, x::CoroutineBodyStmt) = x.ptr
Base.cconvert(::Type{CXCoroutineBodyStmt}, x::CoroutineBodyStmt) = x

"""
    struct CoreturnStmt <: AbstractStmt
Hold a pointer to a `clang::CoreturnStmt` object.
"""
struct CoreturnStmt <: AbstractStmt
    ptr::CXCoreturnStmt
end

Base.unsafe_convert(::Type{CXCoreturnStmt}, x::CoreturnStmt) = x.ptr
Base.cconvert(::Type{CXCoreturnStmt}, x::CoreturnStmt) = x
