"""
    struct Attr
Hold a pointer to a `clang::Attr` object.
"""
struct Attr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::Attr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::Attr) = x
