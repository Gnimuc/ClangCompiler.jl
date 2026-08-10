"""
    abstract type AbstractCommentToXMLConverter <: Any
Supertype for `clang::index::CommentToXMLConverter`.
"""
abstract type AbstractCommentToXMLConverter end

"""
    struct CommentToXMLConverter <: AbstractCommentToXMLConverter
Hold a pointer to a `clang::index::CommentToXMLConverter` object.
"""
struct CommentToXMLConverter <: AbstractCommentToXMLConverter
    ptr::CXCommentToXMLConverter
end
