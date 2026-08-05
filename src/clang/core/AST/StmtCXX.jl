"""
    struct CXXCatchStmt <: AbstractCXXCatchStmt
Hold a pointer to a `clang::CXXCatchStmt` object.
"""
struct CXXCatchStmt <: AbstractCXXCatchStmt
    ptr::CXCXXCatchStmt
end

"""
    struct CXXTryStmt <: AbstractCXXTryStmt
Hold a pointer to a `clang::CXXTryStmt` object.
"""
struct CXXTryStmt <: AbstractCXXTryStmt
    ptr::CXCXXTryStmt
end

"""
    struct CXXForRangeStmt <: AbstractCXXForRangeStmt
Hold a pointer to a `clang::CXXForRangeStmt` object.
"""
struct CXXForRangeStmt <: AbstractCXXForRangeStmt
    ptr::CXCXXForRangeStmt
end

"""
    struct MSDependentExistsStmt <: AbstractMSDependentExistsStmt
Hold a pointer to a `clang::MSDependentExistsStmt` object.
"""
struct MSDependentExistsStmt <: AbstractMSDependentExistsStmt
    ptr::CXMSDependentExistsStmt
end

"""
    struct CoroutineBodyStmt <: AbstractCoroutineBodyStmt
Hold a pointer to a `clang::CoroutineBodyStmt` object.
"""
struct CoroutineBodyStmt <: AbstractCoroutineBodyStmt
    ptr::CXCoroutineBodyStmt
end

"""
    struct CoreturnStmt <: AbstractCoreturnStmt
Hold a pointer to a `clang::CoreturnStmt` object.
"""
struct CoreturnStmt <: AbstractCoreturnStmt
    ptr::CXCoreturnStmt
end

