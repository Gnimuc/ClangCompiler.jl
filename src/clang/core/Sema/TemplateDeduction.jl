"""
    abstract type AbstractTemplateDeductionInfo <: Any
Supertype for `clang::sema::TemplateDeductionInfo` carriers.
"""
abstract type AbstractTemplateDeductionInfo end

"""
    struct TemplateDeductionInfo <: AbstractTemplateDeductionInfo
Hold a pointer to a `clang::sema::TemplateDeductionInfo` object.

The C++ class is a by-value type with no pointer form and a deleted copy constructor, so the
handle is an owned heap box: `dispose` it after use.
"""
struct TemplateDeductionInfo <: AbstractTemplateDeductionInfo
    ptr::CXTemplateDeductionInfo
end

