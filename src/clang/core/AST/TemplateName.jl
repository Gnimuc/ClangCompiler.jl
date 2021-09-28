"""
    TemplateName <: Any
Represent a template name.

Note that, the underlying pointer is NOT a *pointer* to a `clang::TemplateName` object.
Instead, it's the opaque pointer representation of the `clang::TemplateName` itself.
"""
struct TemplateName
    ptr::CXTemplateName
end

Base.unsafe_convert(::Type{CXTemplateName}, x::TemplateName) = x.ptr
Base.cconvert(::Type{CXTemplateName}, x::TemplateName) = x
