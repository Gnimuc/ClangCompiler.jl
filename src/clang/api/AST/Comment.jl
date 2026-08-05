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
`TextComment`/`BlockCommandComment`/`ParamCommandComment` casts.
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

# Comment Cast
function VerbatimBlockLineComment(x::AbstractComment)
    @check_ptrs x
    return VerbatimBlockLineComment(clang_Comment_castToVerbatimBlockLineComment(x))
end

function VerbatimBlockComment(x::AbstractComment)
    @check_ptrs x
    return VerbatimBlockComment(clang_Comment_castToVerbatimBlockComment(x))
end

function VerbatimLineComment(x::AbstractComment)
    @check_ptrs x
    return VerbatimLineComment(clang_Comment_castToVerbatimLineComment(x))
end

# HTMLStartTagComment
"""
    getAttrNameRange(x::AbstractHTMLStartTagComment, i::Integer) -> SourceRange
Return the source range covering the name of the `i`-th HTML attribute (0-based,
`i < getNumAttrs(x)`).

The accessor reads `Attributes[i]` unchecked, so the index must be in range.
"""
function getAttrNameRange(x::AbstractHTMLStartTagComment, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumAttrs(x) "HTML attribute index $i out of range"
    r = clang_HTMLStartTagComment_getAttrNameRange(x, i)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

"""
    getAttrNameLocEnd(x::AbstractHTMLStartTagComment, i::Integer) -> SourceLocation
Return the location one past the last character of the `i`-th HTML attribute's name
(0-based, `i < getNumAttrs(x)`).

The accessor reads `Attributes[i]` unchecked, so the index must be in range.
"""
function getAttrNameLocEnd(x::AbstractHTMLStartTagComment, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumAttrs(x) "HTML attribute index $i out of range"
    return SourceLocation(clang_HTMLStartTagComment_getAttrNameLocEnd(x, i))
end

# BlockCommandComment
"""
    getCommandNameRange(x::AbstractBlockCommandComment, ctx::ASTContext) -> SourceRange
Return the source range covering the command name, starting just past its leading
marker (`\\` or `@`).

`ctx` must be the `ASTContext` whose comment parser produced `x`: the range's end is
computed from the name looked up in that context's `CommandTraits` table by the command
ID stored in the node, and the `CommandInfo` it returns is dereferenced unchecked.
"""
function getCommandNameRange(x::AbstractBlockCommandComment, ctx::ASTContext)
    @check_ptrs x ctx
    r = clang_BlockCommandComment_getCommandNameRange(x, ctx)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

# ParamCommandComment
"""
    getDirectionAsString(d::CXParamCommandPassDirection) -> String
Return the spelling doxygen uses for a `\\param` pass direction: `"[in]"`, `"[out]"` or
`"[in,out]"`.

Static member function — it takes no comment node. The C++ switch ends in
`llvm_unreachable`, so `d` must be one of the three enumerators.
"""
function getDirectionAsString(d::CXParamCommandPassDirection)
    return unsafe_string(clang_ParamCommandComment_getDirectionAsString(d))
end

"""
    getParamName(x::AbstractParamCommandComment, fc::AbstractFullComment) -> String
Return the documented parameter's name as resolved against the declaration `fc` is
attached to, or `"..."` when the command documents a variadic parameter.

`fc` must be the `FullComment` that owns `x`. The C++ method asserts
`isParamIndexValid(x)` and then indexes that declaration's parameter list with the
resolved index, dereferencing the entry unchecked. Use `getParamNameAsWritten` for the
unresolved spelling.
"""
function getParamName(x::AbstractParamCommandComment, fc::AbstractFullComment)
    @check_ptrs x fc
    @assert isParamIndexValid(x) "\\param name was not resolved to a parameter"
    return get_string(clang_ParamCommandComment_getParamName(x, fc))
end

# TParamCommandComment
"""
    getParamName(x::AbstractTParamCommandComment, fc::AbstractFullComment) -> String
Return the documented template parameter's name as resolved against the declaration
`fc` is attached to.

`fc` must be the `FullComment` that owns `x`. The C++ method asserts
`isPositionValid(x)` and then walks that declaration's template parameter lists with
unchecked dereferences; a valid position is only ever recorded when those lists exist,
so the single assertion covers both. Use `getParamNameAsWritten` for the unresolved
spelling.
"""
function getParamName(x::AbstractTParamCommandComment, fc::AbstractFullComment)
    @check_ptrs x fc
    @assert isPositionValid(x) "\\tparam name was not resolved to a template parameter"
    return get_string(clang_TParamCommandComment_getParamName(x, fc))
end

# VerbatimBlockLineComment
function getText(x::AbstractVerbatimBlockLineComment)
    @check_ptrs x
    return get_string(clang_VerbatimBlockLineComment_getText(x))
end

# VerbatimBlockComment
"""
    getCloseName(x::AbstractVerbatimBlockComment) -> String
Return the name of the command that closes the verbatim block (`endcode`,
`endverbatim`, …), without its leading marker.

The name is empty on an unterminated block, i.e. until the parser has seen the closing
command.
"""
function getCloseName(x::AbstractVerbatimBlockComment)
    @check_ptrs x
    return get_string(clang_VerbatimBlockComment_getCloseName(x))
end

function getNumLines(x::AbstractVerbatimBlockComment)
    @check_ptrs x
    return clang_VerbatimBlockComment_getNumLines(x)
end

"""
    getText(x::AbstractVerbatimBlockComment, i::Integer) -> String
Return the text of the `i`-th line of the verbatim block (0-based,
`i < getNumLines(x)`).

The accessor reads `Lines[i]` unchecked, so the index must be in range.
"""
function getText(x::AbstractVerbatimBlockComment, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumLines(x) "verbatim block line index $i out of range"
    return get_string(clang_VerbatimBlockComment_getText(x, i))
end

# VerbatimLineComment
function getText(x::AbstractVerbatimLineComment)
    @check_ptrs x
    return get_string(clang_VerbatimLineComment_getText(x))
end

function getTextRange(x::AbstractVerbatimLineComment)
    @check_ptrs x
    r = clang_VerbatimLineComment_getTextRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

# DeclInfo
"""
    getKind(x::AbstractDeclInfo) -> CXDeclInfo_DeclKind
Return the simplified kind of the declaration the comment documents.

The C++ accessor reads a bitfield with no default initializer that is written only by
`DeclInfo::fill()`, so reading it on an unfilled `DeclInfo` is undefined behaviour. `x`
must therefore come from `getDeclInfo`, which is this carrier's only producer and fills
on demand.
"""
function getKind(x::AbstractDeclInfo)
    @check_ptrs x
    return clang_DeclInfo_getKind(x)
end

"""
    getTemplateKind(x::AbstractDeclInfo) -> CXDeclInfo_TemplateDeclKind
Return whether the documented declaration is a template, and if so which flavour.

Same uninitialized-bitfield precondition as `getKind`: `x` must come from
`getDeclInfo`.
"""
function getTemplateKind(x::AbstractDeclInfo)
    @check_ptrs x
    return clang_DeclInfo_getTemplateKind(x)
end

"""
    involvesFunctionType(x::AbstractDeclInfo) -> Bool
Return whether the documented declaration has a return type, i.e. whether doxygen's
function-oriented commands apply to it.

This one reads `ReturnType`, which the implicit default constructor initializes to a
null `QualType`, so it is well-defined even on an unfilled `DeclInfo` — it just answers
`false` there.
"""
function involvesFunctionType(x::AbstractDeclInfo)
    @check_ptrs x
    return clang_DeclInfo_involvesFunctionType(x)
end

# FullComment
"""
    getDeclInfo(x::AbstractFullComment) -> DeclInfo
Return the simplified description of the declaration `x` is attached to, filling it on
first use.

The C++ accessor dereferences the node's `DeclInfo` unconditionally, and that member is
private, so the precondition cannot be checked here: `x` must come from
[`getCommentForDecl`](@ref) or [`getLocalCommentForDeclUncached`](@ref), the only two
entry points that attach one.
"""
function getDeclInfo(x::AbstractFullComment)
    @check_ptrs x
    return DeclInfo(clang_FullComment_getDeclInfo(x))
end

function getNumBlocks(x::AbstractFullComment)
    @check_ptrs x
    return clang_FullComment_getNumBlocks(x)
end

"""
    getBlock(x::AbstractFullComment, i::Integer) -> Comment
Return the `i`-th top-level block of the comment (0-based, `i < getNumBlocks(x)`).

Each block is a `BlockContentComment`, handed back at the `Comment` base carrier —
refine it with `BlockCommandComment`, `ParamCommandComment` or one of the other casts.
These are exactly the nodes `getChild` walks. The accessor reads `Blocks[i]` unchecked,
so the index must be in range.
"""
function getBlock(x::AbstractFullComment, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumBlocks(x) "comment block index $i out of range"
    return Comment(clang_FullComment_getBlock(x, i))
end

# Comment (cont.)
"""
    getCommentKind(x::AbstractComment) -> CXCommentKind_
Return the concrete node kind of the comment.

This is the enum spelling of [`getCommentKindName`](@ref): both come from the same
TableGen'd class list, so the enumerator is always `CXCommentKind_` followed by the name
that accessor returns.
"""
function getCommentKind(x::AbstractComment)
    @check_ptrs x
    return clang_Comment_getCommentKind(x)
end

# InlineContentComment (cont.)
"""
    addTrailingNewline(x::AbstractInlineContentComment)
Record that the inline content is followed by a newline in the source;
[`hasTrailingNewline`](@ref) reads the flag back.

The flag is set-only — Clang exposes no way to clear it again.
"""
function addTrailingNewline(x::AbstractInlineContentComment)
    @check_ptrs x
    return clang_InlineContentComment_addTrailingNewline(x)
end

# HTMLTagComment (cont.)
"""
    setIsMalformed(x::AbstractHTMLTagComment)
Mark the HTML tag as one the comment parser could not make sense of;
[`isMalformed`](@ref) reads the flag back. The flag is set-only.
"""
function setIsMalformed(x::AbstractHTMLTagComment)
    @check_ptrs x
    return clang_HTMLTagComment_setIsMalformed(x)
end

# HTMLStartTagComment (cont.)
"""
    setGreaterLoc(x::AbstractHTMLStartTagComment, loc::SourceLocation)
Move the end of the tag's source range to `loc`, the location of its closing `>`.

Only the range end changes; [`getTagNameSourceRange`](@ref) is unaffected.
"""
function setGreaterLoc(x::AbstractHTMLStartTagComment, loc::SourceLocation)
    @check_ptrs x
    return clang_HTMLStartTagComment_setGreaterLoc(x, loc)
end

"""
    setSelfClosing(x::AbstractHTMLStartTagComment)
Mark the start tag as self-closing (`<br />`); [`isSelfClosing`](@ref) reads the flag
back. The flag is set-only.
"""
function setSelfClosing(x::AbstractHTMLStartTagComment)
    @check_ptrs x
    return clang_HTMLStartTagComment_setSelfClosing(x)
end

# BlockCommandComment (cont.)
"""
    setParagraph(x::AbstractBlockCommandComment, p::AbstractParagraphComment)
Attach `p` as the command's paragraph argument and extend the command's source range to
the paragraph's end.

The C++ setter dereferences `p` unconditionally, so a NULL carrier is rejected here.
"""
function setParagraph(x::AbstractBlockCommandComment, p::AbstractParagraphComment)
    @check_ptrs x p
    return clang_BlockCommandComment_setParagraph(x, p)
end

# ParamCommandComment (cont.)
"""
    setDirection(x::AbstractParamCommandComment, d::CXParamCommandPassDirection, explicit::Bool)
Set the documented parameter's pass direction and whether it was spelled out in the
source; [`getDirection`](@ref) and [`isDirectionExplicit`](@ref) read them back.
"""
function setDirection(x::AbstractParamCommandComment, d::CXParamCommandPassDirection, explicit::Bool)
    @check_ptrs x
    return clang_ParamCommandComment_setDirection(x, d, explicit)
end

"""
    setIsVarArgParam(x::AbstractParamCommandComment)
Record that the documented parameter is the `...` of a variadic function.

This is one-way: afterwards [`isVarArgParam`](@ref) is true and [`getParamIndex`](@ref)
must not be called, because the C++ accessor asserts `!isVarArgParam()`.
"""
function setIsVarArgParam(x::AbstractParamCommandComment)
    @check_ptrs x
    return clang_ParamCommandComment_setIsVarArgParam(x)
end

"""
    setParamIndex(x::AbstractParamCommandComment, i::Integer)
Record the index of the function parameter this `\\param` command documents;
[`getParamIndex`](@ref) reads it back.

The C++ setter asserts the index is neither the invalid (`0xFFFFFFFF`) nor the vararg
(`0xFFFFFFFE`) sentinel, so both are rejected here.
"""
function setParamIndex(x::AbstractParamCommandComment, i::Integer)
    @check_ptrs x
    @assert 0 <= i < 0xFFFFFFFE "parameter index $i collides with a ParamCommandComment sentinel"
    return clang_ParamCommandComment_setParamIndex(x, i)
end

# Comment (cont.)
"""
    dump(x::AbstractComment)
Dump the comment node to `stderr`.

Debug aid only: nothing is returned and the output format is not stable.
"""
function dump(x::AbstractComment)
    @check_ptrs x
    return clang_Comment_dump(x)
end

"""
    dumpColor(x::AbstractComment)
Dump the comment node to `stderr` with syntax colouring. See [`dump`](@ref).
"""
function dumpColor(x::AbstractComment)
    @check_ptrs x
    return clang_Comment_dumpColor(x)
end

"""
    ParagraphComment(x::AbstractComment)
Refine a comment handle to a `ParagraphComment`, or a NULL carrier when the node is
not one.
"""
function ParagraphComment(x::AbstractComment)
    @check_ptrs x
    return ParagraphComment(clang_Comment_castToParagraphComment(x))
end

"""
    FullComment(x::AbstractComment)
Refine a comment handle to a `FullComment` — the root every parsed comment tree hangs
from — or a NULL carrier when the node is not one.
"""
function FullComment(x::AbstractComment)
    @check_ptrs x
    return FullComment(clang_Comment_castToFullComment(x))
end

"""
    isInlineContentComment(x::AbstractComment) -> Bool
Test whether the node is inline content: text, an inline command, or an HTML tag.

`InlineContentComment` is abstract and has no carrier, so this predicate stands in for
the cast its concrete subclasses get.
"""
function isInlineContentComment(x::AbstractComment)
    @check_ptrs x
    return clang_Comment_isInlineContentComment(x)
end

"""
    isBlockContentComment(x::AbstractComment) -> Bool
Test whether the node is block content: a paragraph or a block command.

`BlockContentComment` is abstract and has no carrier, so this predicate stands in for
the cast its concrete subclasses get.
"""
function isBlockContentComment(x::AbstractComment)
    @check_ptrs x
    return clang_Comment_isBlockContentComment(x)
end

"""
    isHTMLTagComment(x::AbstractComment) -> Bool
Test whether the node is an HTML start tag or end tag.

`HTMLTagComment` is abstract and has no carrier, so this predicate stands in for the
cast its two concrete subclasses get.
"""
function isHTMLTagComment(x::AbstractComment)
    @check_ptrs x
    return clang_Comment_isHTMLTagComment(x)
end

# VerbatimBlockComment (cont.)
"""
    setCloseName(x::AbstractVerbatimBlockComment, ctx::ASTContext, name::AbstractString,
                 loc::SourceLocation)
Set the block's closing command name (the `endcode` of `\\code` … `\\endcode`) and the
location it starts at; [`getCloseName`](@ref) reads the name back.

The C++ setter stores the `StringRef` it is handed, so `name` is copied into `ctx`'s
arena first — `ctx` must be the `ASTContext` that owns `x`.
"""
function setCloseName(x::AbstractVerbatimBlockComment, ctx::ASTContext, name::AbstractString,
                      loc::SourceLocation)
    @check_ptrs x ctx
    return clang_VerbatimBlockComment_setCloseName(x, ctx, name, loc)
end

"""
    setLines(x::AbstractVerbatimBlockComment, ctx::ASTContext,
             lines::AbstractVector{<:AbstractVerbatimBlockLineComment})
Set the verbatim block's lines; [`getNumLines`](@ref) and [`getText`](@ref) read them
back, and they are also the node's children.

The C++ setter stores the `ArrayRef` it is handed, so the array is copied into `ctx`'s
arena first — `ctx` must be the `ASTContext` that owns `x`. No line may be null.
"""
function setLines(x::AbstractVerbatimBlockComment, ctx::ASTContext,
                  lines::AbstractVector{<:AbstractVerbatimBlockLineComment})
    @check_ptrs x ctx
    buf = CXVerbatimBlockLineComment[Base.unsafe_convert(CXVerbatimBlockLineComment, l) for l in lines]
    @assert all(p -> p != C_NULL, buf) "every verbatim-block line must be non-NULL"
    return clang_VerbatimBlockComment_setLines(x, ctx, buf, length(buf))
end

# TParamCommandComment (cont.)
"""
    setPosition(x::AbstractTParamCommandComment, ctx::ASTContext,
                position::AbstractVector{<:Integer})
Set the resolved position of the documented template parameter — one index per level of
template nesting; [`getDepth`](@ref) and [`getIndex`](@ref) read it back.

The C++ setter stores the `ArrayRef` it is handed, so the array is copied into `ctx`'s
arena first — `ctx` must be the `ASTContext` that owns `x`. `position` must be
non-empty, because the setter asserts `isPositionValid()`. It is also what
[`getParamName`](@ref) walks the owning `FullComment`'s template parameter list with, so
a position that no longer matches that list makes `getParamName` undefined.
"""
function setPosition(x::AbstractTParamCommandComment, ctx::ASTContext,
                     position::AbstractVector{<:Integer})
    @check_ptrs x ctx
    @assert !isempty(position) "a template parameter position must have at least one level"
    buf = Cuint[p for p in position]
    return clang_TParamCommandComment_setPosition(x, ctx, buf, length(buf))
end

"""
    getAttrEqualsLoc(x::AbstractHTMLStartTagComment, i::Integer) -> SourceLocation
Return the location of the `=` separating the `i`-th HTML attribute's name from its value
(0-based, `i < getNumAttrs(x)`); an invalid location when the attribute is spelled without
a value.

The accessor reads `Attributes[i]` unchecked, so the index must be in range.
"""
function getAttrEqualsLoc(x::AbstractHTMLStartTagComment, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumAttrs(x) "HTML attribute index $i out of range"
    return SourceLocation(clang_HTMLStartTagComment_getAttrEqualsLoc(x, i))
end

"""
    getAttrValueRange(x::AbstractHTMLStartTagComment, i::Integer) -> SourceRange
Return the source range covering the value of the `i`-th HTML attribute (0-based,
`i < getNumAttrs(x)`); an invalid range when the attribute is spelled without a value.

The accessor reads `Attributes[i]` unchecked, so the index must be in range.
"""
function getAttrValueRange(x::AbstractHTMLStartTagComment, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumAttrs(x) "HTML attribute index $i out of range"
    r = clang_HTMLStartTagComment_getAttrValueRange(x, i)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

"""
    setAttrs(x::AbstractHTMLStartTagComment, ctx::ASTContext, name_loc_begins, names,
             equals_locs, value_ranges, values)
Replace the tag's attribute list with the attributes described by the five parallel
collections, which must all be the same length.

`HTMLStartTagComment::Attribute` is a value type with no handle, so an attribute crosses as
its component fields. The C++ setter stores the `ArrayRef` and the `StringRef`s it is given,
so the array and both strings are copied into `ctx`'s arena; `ctx` must be the `ASTContext`
that owns `x`. The setter also moves the tag's range end to the last attribute's value-range
end, or to its name end when that range is invalid.
"""
function setAttrs(x::AbstractHTMLStartTagComment, ctx::ASTContext,
                  name_loc_begins::AbstractVector{SourceLocation},
                  names::AbstractVector{<:AbstractString},
                  equals_locs::AbstractVector{SourceLocation},
                  value_ranges::AbstractVector{SourceRange},
                  values::AbstractVector{<:AbstractString})
    @check_ptrs x ctx
    n = length(names)
    @assert length(name_loc_begins) == n && length(equals_locs) == n &&
            length(value_ranges) == n && length(values) == n "every attribute component collection must have the same length"
    nb = CXSourceLocation_[Base.unsafe_convert(CXSourceLocation_, l) for l in name_loc_begins]
    el = CXSourceLocation_[Base.unsafe_convert(CXSourceLocation_, l) for l in equals_locs]
    vr = CXSourceRange_[CXSourceRange_(r.begin_loc.ptr, r.end_loc.ptr) for r in value_ranges]
    return clang_HTMLStartTagComment_setAttrs(x, ctx, nb, String[s for s in names], el, vr,
                                              String[s for s in values], n)
end

"""
    setArgs(x::AbstractBlockCommandComment, ctx::ASTContext, texts, ranges)
Replace the command's argument list with the arguments described by the two parallel
collections, which must be the same length.

`Comment::Argument` is a value type with no handle, so an argument crosses as its component
fields. The C++ setter stores the `ArrayRef` and the `StringRef`s it is given, so the array
and the texts are copied into `ctx`'s arena; `ctx` must be the `ASTContext` that owns `x`.
The setter also extends the command's source range to the last argument's range end when
that end is valid.
"""
function setArgs(x::AbstractBlockCommandComment, ctx::ASTContext,
                 texts::AbstractVector{<:AbstractString},
                 ranges::AbstractVector{SourceRange})
    @check_ptrs x ctx
    @assert length(texts) == length(ranges) "argument texts and ranges must have the same length"
    rs = CXSourceRange_[CXSourceRange_(r.begin_loc.ptr, r.end_loc.ptr) for r in ranges]
    return clang_BlockCommandComment_setArgs(x, ctx, String[t for t in texts], rs, length(rs))
end

"""
    getFormattedText(x::AbstractRawComment, src_mgr::AbstractSourceManager,
                     diags::AbstractDiagnosticsEngine) -> String
Return the comment's text with its decoration removed — the leading `///`, the `*` column and
the block delimiters — as a documentation tool would present it.

`diags` receives any warning raised while parsing the comment. Compare
[`getRawText`](@ref), which returns the bytes exactly as written.
"""
function getFormattedText(x::AbstractRawComment, src_mgr::AbstractSourceManager,
                          diags::AbstractDiagnosticsEngine)
    @check_ptrs x src_mgr diags
    return get_string(clang_RawComment_getFormattedText(x, src_mgr, diags))
end

"""
    isAlmostTrailingComment(x::AbstractRawComment) -> Bool
Return whether `x` is a `//` or `/* */` comment sitting where a trailing documentation comment
would go but lacking the `<` that would make it one — a comment clang suspects was meant to
document the preceding declaration but is not spelled so.
"""
function isAlmostTrailingComment(x::AbstractRawComment)
    @check_ptrs x
    return clang_RawComment_isAlmostTrailingComment(x)
end

# RawCommentList
"""
    empty(x::AbstractRawCommentList) -> Bool
Return whether the list holds no comments at all.
"""
function empty(x::AbstractRawCommentList)
    @check_ptrs x
    return clang_RawCommentList_empty(x)
end

"""
    getCommentsInFile(x::AbstractRawCommentList, id::FileID) -> Vector{RawComment}
Return the comments attached to the file `id`, in source order.

This is a *snapshot*. clang hands back a pointer into a private hash table's bucket array, so a
later comment would rehash and move it; the pointers copied out here are arena-owned and stay
valid, but the vector does not grow with the context.
"""
function getCommentsInFile(x::AbstractRawCommentList, id::FileID)
    @check_ptrs x id
    n = Int(clang_RawCommentList_getNumCommentsInFile(x, id))
    n == 0 && return RawComment[]
    buf = Vector{CXRawComment}(undef, n)
    clang_RawCommentList_getCommentsInFile(x, id, buf)
    return [RawComment(p) for p in buf]
end
