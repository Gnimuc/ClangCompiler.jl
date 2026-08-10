# index::CommentToXMLConverter — a parsed doc comment rendered as XML or HTML.
#
# `getCommentForDecl` on an `ASTContext` already yields the `FullComment` these take, so
# this is the last step of turning a C++ doc comment into something a docstring generator
# can consume without walking the comment AST node by node.

"""
    CommentToXMLConverter() -> CommentToXMLConverter
Build a doc-comment converter.

This function allocates and one should call `dispose` to release the resources after using
this object. The converter's only state is a formatting-context cache, so one per session
is the intended use — but it is not thread-safe, and two concurrent conversions must not
share one.
"""
function CommentToXMLConverter()
    c = clang_CommentToXMLConverter_create()
    @assert c != C_NULL "Failed to create CommentToXMLConverter"
    return CommentToXMLConverter(c)
end

dispose(x::CommentToXMLConverter) = clang_CommentToXMLConverter_dispose(x)

"""
    convertCommentToHTML(x::AbstractCommentToXMLConverter, fc::AbstractFullComment, ctx::AbstractASTContext) -> String
Render a full doc comment as HTML.

`ctx` must be the `ASTContext` the comment was parsed in: the converter reads the comment's
source locations and the declaration it is attached to out of that context's tables.
"""
function convertCommentToHTML(x::AbstractCommentToXMLConverter, fc::AbstractFullComment,
                              ctx::AbstractASTContext)
    @check_ptrs x fc ctx
    return get_string(clang_CommentToXMLConverter_convertCommentToHTML(x, fc, ctx))
end

"""
    convertHTMLTagNodeToText(x::AbstractCommentToXMLConverter, htc::AbstractHTMLTagComment, ctx::AbstractASTContext) -> String
Render one HTML tag node of a doc comment as the text it stands for. Same `ctx` requirement
as [`convertCommentToHTML`](@ref).
"""
function convertHTMLTagNodeToText(x::AbstractCommentToXMLConverter,
                                  htc::AbstractHTMLTagComment, ctx::AbstractASTContext)
    @check_ptrs x htc ctx
    return get_string(clang_CommentToXMLConverter_convertHTMLTagNodeToText(x, htc, ctx))
end

"""
    convertCommentToXML(x::AbstractCommentToXMLConverter, fc::AbstractFullComment, ctx::AbstractASTContext) -> String
Render a full doc comment as XML — the structured form libclang exposes as
`clang_FullComment_getAsXML`. Same `ctx` requirement as [`convertCommentToHTML`](@ref).
"""
function convertCommentToXML(x::AbstractCommentToXMLConverter, fc::AbstractFullComment,
                             ctx::AbstractASTContext)
    @check_ptrs x fc ctx
    return get_string(clang_CommentToXMLConverter_convertCommentToXML(x, fc, ctx))
end
