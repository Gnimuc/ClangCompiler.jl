# RawComment
function getKind(x::AbstractRawComment)
    @check_ptrs x
    return clang_RawComment_getKind(x)
end

function isAttached(x::AbstractRawComment)
    @check_ptrs x
    return clang_RawComment_isAttached(x)
end

function isTrailingComment(x::AbstractRawComment)
    @check_ptrs x
    return clang_RawComment_isTrailingComment(x)
end

function isDocumentation(x::AbstractRawComment)
    @check_ptrs x
    return clang_RawComment_isDocumentation(x)
end

"""
    getRawText(x::AbstractRawComment, sm::SourceManager) -> String
Return the comment text with its comment markers.

`sm` must be the `SourceManager` the comment's range belongs to; the C++ method
reads the source buffer that range names.
"""
function getRawText(x::AbstractRawComment, sm::SourceManager)
    @check_ptrs x sm
    return get_string(clang_RawComment_getRawText(x, sm))
end

function getSourceRange(x::AbstractRawComment)
    @check_ptrs x
    r = clang_RawComment_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

"""
    getBriefText(x::AbstractRawComment, ctx::ASTContext) -> String
Return the text of the comment's brief paragraph, running the comment parser on
first use and caching the result in `ctx`'s arena.

`ctx` must be the `ASTContext` that owns `x`.
"""
function getBriefText(x::AbstractRawComment, ctx::ASTContext)
    @check_ptrs x ctx
    return unsafe_string(clang_RawComment_getBriefText(x, ctx))
end

# Comment
function getCommentKindName(x::AbstractComment)
    @check_ptrs x
    return unsafe_string(clang_Comment_getCommentKindName(x))
end

function getSourceRange(x::AbstractComment)
    @check_ptrs x
    r = clang_Comment_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

function child_count(x::AbstractComment)
    @check_ptrs x
    return clang_Comment_child_count(x)
end

"""
    getChild(x::AbstractComment, i::Integer) -> Comment
Return the `i`-th child node (0-based, `i < child_count(x)`).

The result is wrapped at the base `Comment` type — refine it with one of the
`TextComment`/`BlockCommandComment`/`ParamCommandComment` downcasts.
"""
function getChild(x::AbstractComment, i::Integer)
    @check_ptrs x
    @assert 0 <= i < child_count(x) "comment child index $i out of range"
    return Comment(clang_Comment_getChild(x, i))
end

# Comment Cast
function TextComment(x::AbstractComment)
    @check_ptrs x
    return TextComment(clang_Comment_castToTextComment(x))
end

function BlockCommandComment(x::AbstractComment)
    @check_ptrs x
    return BlockCommandComment(clang_Comment_castToBlockCommandComment(x))
end

function ParamCommandComment(x::AbstractComment)
    @check_ptrs x
    return ParamCommandComment(clang_Comment_castToParamCommandComment(x))
end

# TextComment
function getText(x::AbstractTextComment)
    @check_ptrs x
    return get_string(clang_TextComment_getText(x))
end

# BlockCommandComment
"""
    getCommandName(x::AbstractBlockCommandComment, ctx::ASTContext) -> String
Return the doxygen command name (`brief`, `param`, `return`, …) without its
leading backslash.

`ctx` must be the `ASTContext` whose comment parser produced `x`: the name is
looked up in that context's `CommandTraits` table by the command ID stored in
the node.
"""
function getCommandName(x::AbstractBlockCommandComment, ctx::ASTContext)
    @check_ptrs x ctx
    return get_string(clang_BlockCommandComment_getCommandName(x, ctx))
end

# ParamCommandComment
function hasParamName(x::AbstractParamCommandComment)
    @check_ptrs x
    return clang_ParamCommandComment_hasParamName(x)
end

"""
    getParamNameAsWritten(x::AbstractParamCommandComment) -> String
Return the parameter name exactly as spelled in the comment.

The C++ accessor reads `Args[0]` unchecked, so `hasParamName(x)` must hold.
"""
function getParamNameAsWritten(x::AbstractParamCommandComment)
    @check_ptrs x
    @assert hasParamName(x) "\\param command has no name argument"
    return get_string(clang_ParamCommandComment_getParamNameAsWritten(x))
end


# Comment
function getBeginLoc(x::AbstractComment)
    @check_ptrs x
    return SourceLocation(clang_Comment_getBeginLoc(x))
end

function getEndLoc(x::AbstractComment)
    @check_ptrs x
    return SourceLocation(clang_Comment_getEndLoc(x))
end

function getLocation(x::AbstractComment)
    @check_ptrs x
    return SourceLocation(clang_Comment_getLocation(x))
end

# InlineContentComment
function hasTrailingNewline(x::AbstractInlineContentComment)
    @check_ptrs x
    return clang_InlineContentComment_hasTrailingNewline(x)
end

# TextComment
function isWhitespace(x::AbstractTextComment)
    @check_ptrs x
    return clang_TextComment_isWhitespace(x)
end

# ParagraphComment
function isWhitespace(x::AbstractParagraphComment)
    @check_ptrs x
    return clang_ParagraphComment_isWhitespace(x)
end

# BlockCommandComment
function getCommandID(x::AbstractBlockCommandComment)
    @check_ptrs x
    return clang_BlockCommandComment_getCommandID(x)
end

function getCommandNameBeginLoc(x::AbstractBlockCommandComment)
    @check_ptrs x
    return SourceLocation(clang_BlockCommandComment_getCommandNameBeginLoc(x))
end

function getNumArgs(x::AbstractBlockCommandComment)
    @check_ptrs x
    return clang_BlockCommandComment_getNumArgs(x)
end

"""
    getArgText(x::AbstractBlockCommandComment, i::Integer) -> String
Return the text of the `i`-th word-like argument (0-based, `i < getNumArgs(x)`).

The C++ accessor reads `Args[i]` unchecked, so the index must be in range.
"""
function getArgText(x::AbstractBlockCommandComment, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumArgs(x) "block command argument index $i out of range"
    return get_string(clang_BlockCommandComment_getArgText(x, i))
end

"""
    getArgRange(x::AbstractBlockCommandComment, i::Integer) -> SourceRange
Return the source range of the `i`-th word-like argument (0-based, `i < getNumArgs(x)`).

The C++ accessor reads `Args[i]` unchecked, so the index must be in range.
"""
function getArgRange(x::AbstractBlockCommandComment, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumArgs(x) "block command argument index $i out of range"
    r = clang_BlockCommandComment_getArgRange(x, i)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

"""
    getParagraph(x::AbstractBlockCommandComment) -> ParagraphComment
Return the command's paragraph argument.

The C++ return type is statically `ParagraphComment *`; the pointer may be null
when the command carries no paragraph, so check `.ptr` before use.
"""
function getParagraph(x::AbstractBlockCommandComment)
    @check_ptrs x
    return ParagraphComment(clang_BlockCommandComment_getParagraph(x))
end

function hasNonWhitespaceParagraph(x::AbstractBlockCommandComment)
    @check_ptrs x
    return clang_BlockCommandComment_hasNonWhitespaceParagraph(x)
end

function getCommandMarker(x::AbstractBlockCommandComment)
    @check_ptrs x
    return clang_BlockCommandComment_getCommandMarker(x)
end

# ParamCommandComment
function getDirection(x::AbstractParamCommandComment)
    @check_ptrs x
    return clang_ParamCommandComment_getDirection(x)
end

function isDirectionExplicit(x::AbstractParamCommandComment)
    @check_ptrs x
    return clang_ParamCommandComment_isDirectionExplicit(x)
end

function isParamIndexValid(x::AbstractParamCommandComment)
    @check_ptrs x
    return clang_ParamCommandComment_isParamIndexValid(x)
end

function isVarArgParam(x::AbstractParamCommandComment)
    @check_ptrs x
    return clang_ParamCommandComment_isVarArgParam(x)
end

"""
    getParamNameRange(x::AbstractParamCommandComment) -> SourceRange
Return the source range of the parameter name.

The C++ accessor reads `Args[0]` unchecked, so `hasParamName(x)` must hold.
"""
function getParamNameRange(x::AbstractParamCommandComment)
    @check_ptrs x
    @assert hasParamName(x) "\\param command has no name argument"
    r = clang_ParamCommandComment_getParamNameRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

"""
    getParamIndex(x::AbstractParamCommandComment) -> UInt
Return the index of the documented parameter in the function's parameter list.

The C++ accessor asserts `isParamIndexValid(x) && !isVarArgParam(x)`; both must hold.
"""
function getParamIndex(x::AbstractParamCommandComment)
    @check_ptrs x
    @assert isParamIndexValid(x) && !isVarArgParam(x) "parameter index is not valid"
    return clang_ParamCommandComment_getParamIndex(x)
end


# Comment Cast
function InlineCommandComment(x::AbstractComment)
    @check_ptrs x
    return InlineCommandComment(clang_Comment_castToInlineCommandComment(x))
end

function HTMLStartTagComment(x::AbstractComment)
    @check_ptrs x
    return HTMLStartTagComment(clang_Comment_castToHTMLStartTagComment(x))
end

function HTMLEndTagComment(x::AbstractComment)
    @check_ptrs x
    return HTMLEndTagComment(clang_Comment_castToHTMLEndTagComment(x))
end

function TParamCommandComment(x::AbstractComment)
    @check_ptrs x
    return TParamCommandComment(clang_Comment_castToTParamCommandComment(x))
end

# InlineCommandComment
function getCommandID(x::AbstractInlineCommandComment)
    @check_ptrs x
    return clang_InlineCommandComment_getCommandID(x)
end

"""
    getCommandName(x::AbstractInlineCommandComment, ctx::ASTContext) -> String
Return the doxygen command name (`c`, `b`, `em`, …) without its leading backslash.

`ctx` must be the `ASTContext` whose comment parser produced `x`: the name is
looked up in that context's `CommandTraits` table by the command ID stored in
the node, and the `CommandInfo` it returns is dereferenced unchecked.
"""
function getCommandName(x::AbstractInlineCommandComment, ctx::ASTContext)
    @check_ptrs x ctx
    return get_string(clang_InlineCommandComment_getCommandName(x, ctx))
end

function getCommandNameRange(x::AbstractInlineCommandComment)
    @check_ptrs x
    r = clang_InlineCommandComment_getCommandNameRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

function getRenderKind(x::AbstractInlineCommandComment)
    @check_ptrs x
    return clang_InlineCommandComment_getRenderKind(x)
end

function getNumArgs(x::AbstractInlineCommandComment)
    @check_ptrs x
    return clang_InlineCommandComment_getNumArgs(x)
end

"""
    getArgText(x::AbstractInlineCommandComment, i::Integer) -> String
Return the text of the `i`-th word-like argument (0-based, `i < getNumArgs(x)`).

The C++ accessor reads `Args[i]` unchecked, so the index must be in range.
"""
function getArgText(x::AbstractInlineCommandComment, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumArgs(x) "inline command argument index $i out of range"
    return get_string(clang_InlineCommandComment_getArgText(x, i))
end

"""
    getArgRange(x::AbstractInlineCommandComment, i::Integer) -> SourceRange
Return the source range of the `i`-th word-like argument (0-based, `i < getNumArgs(x)`).

The C++ accessor reads `Args[i]` unchecked, so the index must be in range.
"""
function getArgRange(x::AbstractInlineCommandComment, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumArgs(x) "inline command argument index $i out of range"
    r = clang_InlineCommandComment_getArgRange(x, i)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

# HTMLTagComment
function getTagName(x::AbstractHTMLTagComment)
    @check_ptrs x
    return get_string(clang_HTMLTagComment_getTagName(x))
end

function getTagNameSourceRange(x::AbstractHTMLTagComment)
    @check_ptrs x
    r = clang_HTMLTagComment_getTagNameSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

function isMalformed(x::AbstractHTMLTagComment)
    @check_ptrs x
    return clang_HTMLTagComment_isMalformed(x)
end

# HTMLStartTagComment
function getNumAttrs(x::AbstractHTMLStartTagComment)
    @check_ptrs x
    return clang_HTMLStartTagComment_getNumAttrs(x)
end

"""
    getAttrName(x::AbstractHTMLStartTagComment, i::Integer) -> String
Return the name of the `i`-th HTML attribute (0-based, `i < getNumAttrs(x)`).

`HTMLStartTagComment::getAttr` hands back an `Attribute` value type, which is
exposed here as its component fields. The accessor reads `Attributes[i]`
unchecked, so the index must be in range.
"""
function getAttrName(x::AbstractHTMLStartTagComment, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumAttrs(x) "HTML attribute index $i out of range"
    return get_string(clang_HTMLStartTagComment_getAttrName(x, i))
end

"""
    getAttrValue(x::AbstractHTMLStartTagComment, i::Integer) -> String
Return the value of the `i`-th HTML attribute (0-based, `i < getNumAttrs(x)`),
or the empty string when the attribute is spelled without one.

The accessor reads `Attributes[i]` unchecked, so the index must be in range.
"""
function getAttrValue(x::AbstractHTMLStartTagComment, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumAttrs(x) "HTML attribute index $i out of range"
    return get_string(clang_HTMLStartTagComment_getAttrValue(x, i))
end

function isSelfClosing(x::AbstractHTMLStartTagComment)
    @check_ptrs x
    return clang_HTMLStartTagComment_isSelfClosing(x)
end

# TParamCommandComment
function hasParamName(x::AbstractTParamCommandComment)
    @check_ptrs x
    return clang_TParamCommandComment_hasParamName(x)
end

"""
    getParamNameAsWritten(x::AbstractTParamCommandComment) -> String
Return the template parameter name exactly as spelled in the comment.

The C++ accessor reads `Args[0]` unchecked, so `hasParamName(x)` must hold.
"""
function getParamNameAsWritten(x::AbstractTParamCommandComment)
    @check_ptrs x
    @assert hasParamName(x) "\\tparam command has no name argument"
    return get_string(clang_TParamCommandComment_getParamNameAsWritten(x))
end

"""
    getParamNameRange(x::AbstractTParamCommandComment) -> SourceRange
Return the source range of the template parameter name.

The C++ accessor reads `Args[0]` unchecked, so `hasParamName(x)` must hold.
"""
function getParamNameRange(x::AbstractTParamCommandComment)
    @check_ptrs x
    @assert hasParamName(x) "\\tparam command has no name argument"
    r = clang_TParamCommandComment_getParamNameRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

function isPositionValid(x::AbstractTParamCommandComment)
    @check_ptrs x
    return clang_TParamCommandComment_isPositionValid(x)
end

"""
    getDepth(x::AbstractTParamCommandComment) -> UInt
Return the number of template parameter lists the documented parameter is nested in.

The position list is empty until the comment parser resolves the name against a
template parameter list, and the C++ accessor asserts `isPositionValid(x)`.
"""
function getDepth(x::AbstractTParamCommandComment)
    @check_ptrs x
    @assert isPositionValid(x) "\\tparam name was not resolved to a template parameter"
    return clang_TParamCommandComment_getDepth(x)
end

"""
    getIndex(x::AbstractTParamCommandComment, depth::Integer) -> UInt
Return the position of the documented parameter within the template parameter
list at nesting level `depth` (0-based, `depth < getDepth(x)`).

The C++ accessor asserts `isPositionValid(x)` and then reads `Position[depth]`
unchecked, so both preconditions must hold.
"""
function getIndex(x::AbstractTParamCommandComment, depth::Integer)
    @check_ptrs x
    @assert isPositionValid(x) "\\tparam name was not resolved to a template parameter"
    @assert 0 <= depth < getDepth(x) "template parameter nesting level $depth out of range"
    return clang_TParamCommandComment_getIndex(x, depth)
end

# FullComment
"""
    getDecl(x::AbstractFullComment) -> Decl
Return the declaration this comment is attached to.

The C++ accessor dereferences the node's `DeclInfo` unconditionally, and that
member is private, so the precondition cannot be checked here: `x` must come
from [`getCommentForDecl`](@ref) or [`getLocalCommentForDeclUncached`](@ref),
the only two entry points that attach one.
"""
function getDecl(x::AbstractFullComment)
    @check_ptrs x
    return Decl(clang_FullComment_getDecl(x))
end
