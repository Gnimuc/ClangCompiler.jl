"""
    struct APValue
Hold a pointer to a `clang::APValue` object.
"""
struct APValue
    ptr::CXAPValue
end

Base.unsafe_convert(::Type{CXAPValue}, x::APValue) = x.ptr
Base.cconvert(::Type{CXAPValue}, x::APValue) = x
