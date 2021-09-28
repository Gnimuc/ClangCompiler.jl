"""
    struct TemplateArgument <: Any
Hold a pointer to a `clang::TemplateArgument` object.
"""
struct TemplateArgument
    ptr::CXTemplateArgument
end

Base.unsafe_convert(::Type{CXTemplateArgument}, x::TemplateArgument) = x.ptr
Base.cconvert(::Type{CXTemplateArgument}, x::TemplateArgument) = x
