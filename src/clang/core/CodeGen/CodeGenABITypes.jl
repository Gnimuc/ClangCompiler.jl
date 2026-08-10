abstract type AbstractAttrBuilder end

"""
    struct AttrBuilder <: AbstractAttrBuilder
Hold a pointer to a `llvm::AttrBuilder` object.
"""
struct AttrBuilder <: AbstractAttrBuilder
    ptr::CXAttrBuilder
end
