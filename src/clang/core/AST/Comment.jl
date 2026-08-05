abstract type AbstractRawComment end

"""
    struct RawComment <: AbstractRawComment
Hold a pointer to a `clang::RawComment` object.

The pointee is owned by the `ASTContext` arena — there is no `dispose`.
"""
struct RawComment <: AbstractRawComment
    ptr::CXRawComment
end

# clang::comments::Comment hierarchy (clang/AST/Comment.h). Only the classes this
# layer can construct faithfully are mirrored; `Comment` is the base carrier that
# `getChild` hands back before a cast refines it.
abstract type AbstractComment end
abstract type AbstractInlineContentComment <: AbstractComment end
abstract type AbstractTextComment <: AbstractInlineContentComment end
abstract type AbstractBlockContentComment <: AbstractComment end
abstract type AbstractBlockCommandComment <: AbstractBlockContentComment end
abstract type AbstractParamCommandComment <: AbstractBlockCommandComment end
abstract type AbstractFullComment <: AbstractComment end

"""
    struct Comment <: AbstractComment
Hold a pointer to a `clang::comments::Comment` object.
"""
struct Comment <: AbstractComment
    ptr::CXComment
end

"""
    struct TextComment <: AbstractTextComment
Hold a pointer to a `clang::comments::TextComment` object.
"""
struct TextComment <: AbstractTextComment
    ptr::CXTextComment
end

"""
    struct BlockCommandComment <: AbstractBlockCommandComment
Hold a pointer to a `clang::comments::BlockCommandComment` object.
"""
struct BlockCommandComment <: AbstractBlockCommandComment
    ptr::CXBlockCommandComment
end

"""
    struct ParamCommandComment <: AbstractParamCommandComment
Hold a pointer to a `clang::comments::ParamCommandComment` object.
"""
struct ParamCommandComment <: AbstractParamCommandComment
    ptr::CXParamCommandComment
end

"""
    struct FullComment <: AbstractFullComment
Hold a pointer to a `clang::comments::FullComment` object.
"""
struct FullComment <: AbstractFullComment
    ptr::CXFullComment
end

# clang::comments::ParagraphComment (clang/AST/Comment.h). Wrapped so
# BlockCommandComment::getParagraph can hand its paragraph back at its static type.
abstract type AbstractParagraphComment <: AbstractBlockContentComment end

"""
    struct ParagraphComment <: AbstractParagraphComment
Hold a pointer to a `clang::comments::ParagraphComment` object.
"""
struct ParagraphComment <: AbstractParagraphComment
    ptr::CXParagraphComment
end

# The inline-content tail of the clang::comments hierarchy plus TParamCommandComment
# (clang/AST/Comment.h). `HTMLTagComment` is abstract in Clang, so it contributes an
# abstract type but no carrier; its two concrete subclasses carry the pointer.
abstract type AbstractInlineCommandComment <: AbstractInlineContentComment end
abstract type AbstractHTMLTagComment <: AbstractInlineContentComment end
abstract type AbstractHTMLStartTagComment <: AbstractHTMLTagComment end
abstract type AbstractHTMLEndTagComment <: AbstractHTMLTagComment end
abstract type AbstractTParamCommandComment <: AbstractBlockCommandComment end

"""
    struct InlineCommandComment <: AbstractInlineCommandComment
Hold a pointer to a `clang::comments::InlineCommandComment` object.
"""
struct InlineCommandComment <: AbstractInlineCommandComment
    ptr::CXInlineCommandComment
end

"""
    struct HTMLStartTagComment <: AbstractHTMLStartTagComment
Hold a pointer to a `clang::comments::HTMLStartTagComment` object.
"""
struct HTMLStartTagComment <: AbstractHTMLStartTagComment
    ptr::CXHTMLStartTagComment
end

"""
    struct HTMLEndTagComment <: AbstractHTMLEndTagComment
Hold a pointer to a `clang::comments::HTMLEndTagComment` object.
"""
struct HTMLEndTagComment <: AbstractHTMLEndTagComment
    ptr::CXHTMLEndTagComment
end

"""
    struct TParamCommandComment <: AbstractTParamCommandComment
Hold a pointer to a `clang::comments::TParamCommandComment` object.
"""
struct TParamCommandComment <: AbstractTParamCommandComment
    ptr::CXTParamCommandComment
end

# The verbatim tail of the clang::comments hierarchy (clang/AST/Comment.h).
# `VerbatimBlockComment` (\code…\endcode) and `VerbatimLineComment` (\defgroup,
# \fn, …) are block commands; the individual lines a verbatim block owns are plain
# `Comment` subclasses, not block content.
abstract type AbstractVerbatimBlockLineComment <: AbstractComment end
abstract type AbstractVerbatimBlockComment <: AbstractBlockCommandComment end
abstract type AbstractVerbatimLineComment <: AbstractBlockCommandComment end

"""
    struct VerbatimBlockLineComment <: AbstractVerbatimBlockLineComment
Hold a pointer to a `clang::comments::VerbatimBlockLineComment` object.
"""
struct VerbatimBlockLineComment <: AbstractVerbatimBlockLineComment
    ptr::CXVerbatimBlockLineComment
end

"""
    struct VerbatimBlockComment <: AbstractVerbatimBlockComment
Hold a pointer to a `clang::comments::VerbatimBlockComment` object.
"""
struct VerbatimBlockComment <: AbstractVerbatimBlockComment
    ptr::CXVerbatimBlockComment
end

"""
    struct VerbatimLineComment <: AbstractVerbatimLineComment
Hold a pointer to a `clang::comments::VerbatimLineComment` object.
"""
struct VerbatimLineComment <: AbstractVerbatimLineComment
    ptr::CXVerbatimLineComment
end

# clang::comments::DeclInfo (clang/AST/Comment.h). A plain struct rather than a node
# of the Comment hierarchy: it is a `FullComment`'s simplified description of the
# declaration the comment documents. The pointee lives in the `ASTContext` arena —
# there is no `dispose`.
abstract type AbstractDeclInfo end

"""
    struct DeclInfo <: AbstractDeclInfo
Hold a pointer to a `clang::comments::DeclInfo` object.
"""
struct DeclInfo <: AbstractDeclInfo
    ptr::CXDeclInfo
end

abstract type AbstractRawCommentList end

"""
    struct RawCommentList <: AbstractRawCommentList
Hold a pointer to a `clang::RawCommentList` object.

The list is a member of its `ASTContext`, so it is borrowed: there is no `dispose`.
"""
struct RawCommentList <: AbstractRawCommentList
    ptr::CXRawCommentList
end

