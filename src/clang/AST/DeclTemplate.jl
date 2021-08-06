"""
    struct TemplateParameterList <: Any
Holds a pointer to a `clang::TemplateParameterList` object.
"""
struct TemplateParameterList
    ptr::CXTemplateParameterList
end
