"""
    struct PartialTranslationUnit <: Any
Hold a pointer to a `clang::PartialTranslationUnit` object.
"""
struct PartialTranslationUnit
    ptr::CXPartialTranslationUnit
end

Base.unsafe_convert(::Type{CXPartialTranslationUnit}, x::PartialTranslationUnit) = x.ptr
Base.cconvert(::Type{CXPartialTranslationUnit}, x::PartialTranslationUnit) = x
