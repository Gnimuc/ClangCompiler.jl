# Attr
function getKind(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_getKind(x)
end

# The attribute's source spelling (e.g. "aligned"); borrowed clang-owned storage.
function getSpelling(x::AbstractAttr)
    @check_ptrs x
    return unsafe_string(clang_Attr_getSpelling(x))
end

function getRange(x::AbstractAttr)
    @check_ptrs x
    r = clang_Attr_getRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

function getLocation(x::AbstractAttr)
    @check_ptrs x
    return SourceLocation(clang_Attr_getLocation(x))
end

function isImplicit(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isImplicit(x)
end

function isInherited(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isInherited(x)
end

function isPackExpansion(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPackExpansion(x)
end

# Attr Cast — one checked cast and one predicate per attribute
# class (NULL carrier when the attribute is another class; dyn_cast_or_null
# semantics). Generated from AttrList.inc into src/clang/api/AST/AttrWrappers.jl.
include("AttrWrappers.jl")

# Per-attribute payload accessors (Clang class order). Attribute classes are
# leaves, so the concrete carrier IS the level of the declaring class — the
# receivers below are exactly as tight as the two-invariant rule requires.

# AlignedAttr
"""
    getAlignment(x::AlignedAttr, ctx::ASTContext) -> UInt32
The alignment in bits, resolving either payload form (expression or type).
"""
function getAlignment(x::AlignedAttr, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_AlignedAttr_getAlignment(x, ctx)
end

function isAlignmentExpr(x::AlignedAttr)
    @check_ptrs x
    return clang_AlignedAttr_isAlignmentExpr(x)
end

function getAlignmentExpr(x::AlignedAttr)
    @check_ptrs x
    @assert isAlignmentExpr(x) "the alignment payload is a type, not an expression"
    return Expr_(clang_AlignedAttr_getAlignmentExpr(x))
end

# AnnotateAttr
function getAnnotation(x::AnnotateAttr)
    @check_ptrs x
    return get_string(clang_AnnotateAttr_getAnnotation(x))
end

function args_size(x::AnnotateAttr)
    @check_ptrs x
    return clang_AnnotateAttr_args_size(x)
end

# AsmLabelAttr
function getLabel(x::AsmLabelAttr)
    @check_ptrs x
    return get_string(clang_AsmLabelAttr_getLabel(x))
end

function getIsLiteralLabel(x::AsmLabelAttr)
    @check_ptrs x
    return clang_AsmLabelAttr_getIsLiteralLabel(x)
end

# CleanupAttr
function getFunctionDecl(x::CleanupAttr)
    @check_ptrs x
    return FunctionDecl(clang_CleanupAttr_getFunctionDecl(x))
end

# ConstructorAttr
function getPriority(x::ConstructorAttr)
    @check_ptrs x
    return clang_ConstructorAttr_getPriority(x)
end

# DeprecatedAttr
function getMessage(x::DeprecatedAttr)
    @check_ptrs x
    return get_string(clang_DeprecatedAttr_getMessage(x))
end

function getReplacement(x::DeprecatedAttr)
    @check_ptrs x
    return get_string(clang_DeprecatedAttr_getReplacement(x))
end

# DestructorAttr
function getPriority(x::DestructorAttr)
    @check_ptrs x
    return clang_DestructorAttr_getPriority(x)
end

# FormatAttr
function getType(x::FormatAttr)
    @check_ptrs x
    return IdentifierInfo(clang_FormatAttr_getType(x))
end

function getFormatIdx(x::FormatAttr)
    @check_ptrs x
    return clang_FormatAttr_getFormatIdx(x)
end

function getFirstArg(x::FormatAttr)
    @check_ptrs x
    return clang_FormatAttr_getFirstArg(x)
end

# NonNullAttr
function args_size(x::NonNullAttr)
    @check_ptrs x
    return clang_NonNullAttr_args_size(x)
end

"""
    isNonNull(x::NonNullAttr, idx::Integer) -> Bool
Whether the zero-origin AST parameter index `idx` is covered by this attribute
(a bare `nonnull` with no argument list covers every pointer parameter).
"""
function isNonNull(x::NonNullAttr, idx::Integer)
    @check_ptrs x
    return clang_NonNullAttr_isNonNull(x, idx)
end

# SectionAttr
function getName(x::SectionAttr)
    @check_ptrs x
    return get_string(clang_SectionAttr_getName(x))
end

# TLSModelAttr
function getModel(x::TLSModelAttr)
    @check_ptrs x
    return get_string(clang_TLSModelAttr_getModel(x))
end

# UnavailableAttr
function getMessage(x::UnavailableAttr)
    @check_ptrs x
    return get_string(clang_UnavailableAttr_getMessage(x))
end

# VisibilityAttr
function getVisibility(x::VisibilityAttr)
    @check_ptrs x
    return clang_VisibilityAttr_getVisibility(x)
end

# WarnUnusedResultAttr
function getMessage(x::WarnUnusedResultAttr)
    @check_ptrs x
    return get_string(clang_WarnUnusedResultAttr_getMessage(x))
end
