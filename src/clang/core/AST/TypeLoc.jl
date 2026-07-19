"""
    struct TypeLoc
Hold a pointer to a heap-boxed `clang::TypeLoc` object.
"""
struct TypeLoc
    ptr::CXTypeLoc
end

Base.unsafe_convert(::Type{CXTypeLoc}, x::TypeLoc) = x.ptr
Base.cconvert(::Type{CXTypeLoc}, x::TypeLoc) = x
