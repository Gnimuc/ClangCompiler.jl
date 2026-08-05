abstract type AbstractParentMapContext end

"""
    struct ParentMapContext <: AbstractParentMapContext
Hold a pointer to a `clang::ParentMapContext` object.

The pointee is owned by the `ASTContext` through a `std::unique_ptr` member and built on the
first [`getParentMapContext`](@ref) call, so it lives exactly as long as that context and
there is no `dispose`.
"""
struct ParentMapContext <: AbstractParentMapContext
    ptr::CXParentMapContext
end
