# PPConditionalDirectiveRecord
"""
    PPConditionalDirectiveRecord(pp::AbstractPreprocessor) -> PPConditionalDirectiveRecord
Install a record of every `#if`/`#ifdef`/`#ifndef`/`#else`/`#endif` region into `pp`'s
callback chain, and return it.

The record only sees directives lexed after this call, so install it before the main file
is entered. The preprocessor adopts it, exactly as it adopts a preprocessing record: the
returned carrier is borrowed and there is no `dispose`.
"""
function PPConditionalDirectiveRecord(pp::AbstractPreprocessor)
    @check_ptrs pp
    r = clang_PPConditionalDirectiveRecord_create(pp)
    @assert r != C_NULL "Failed to create PPConditionalDirectiveRecord"
    return PPConditionalDirectiveRecord(r)
end

function getTotalMemory(x::AbstractPPConditionalDirectiveRecord)
    @check_ptrs x
    return clang_PPConditionalDirectiveRecord_getTotalMemory(x)
end

function getSourceManager(x::AbstractPPConditionalDirectiveRecord)
    @check_ptrs x
    return SourceManager(clang_PPConditionalDirectiveRecord_getSourceManager(x))
end

"""
    rangeIntersectsConditionalDirective(x::AbstractPPConditionalDirectiveRecord, range::SourceRange) -> Bool
Return whether `range` is cut by a conditional directive.

A whole `#if`/`#endif` block sitting inside `range` does not count: the question is whether
the range crosses a boundary, which is what decides whether the text it covers can be moved
as one piece. An invalid range, or one spanning two files, is `false`.
"""
function rangeIntersectsConditionalDirective(x::AbstractPPConditionalDirectiveRecord, range::SourceRange)
    @check_ptrs x
    r = CXSourceRange_(range.begin_loc.ptr, range.end_loc.ptr)
    return clang_PPConditionalDirectiveRecord_rangeIntersectsConditionalDirective(x, r)
end

"""
    findConditionalDirectiveRegionLoc(x::AbstractPPConditionalDirectiveRecord, loc::SourceLocation) -> SourceLocation
Return the location of the conditional directive that opens the region `loc` falls in, or
an invalid location when `loc` is outside every region.
"""
function findConditionalDirectiveRegionLoc(x::AbstractPPConditionalDirectiveRecord, loc::SourceLocation)
    @check_ptrs x
    return SourceLocation(clang_PPConditionalDirectiveRecord_findConditionalDirectiveRegionLoc(x, loc))
end

"""
    areInDifferentConditionalDirectiveRegion(x::AbstractPPConditionalDirectiveRecord,
                                             lhs::SourceLocation, rhs::SourceLocation) -> Bool
Return whether the two locations sit in different conditional-directive regions, i.e.
whether code cannot be moved between them without changing what gets compiled.
"""
function areInDifferentConditionalDirectiveRegion(x::AbstractPPConditionalDirectiveRecord, lhs::SourceLocation, rhs::SourceLocation)
    @check_ptrs x
    return clang_PPConditionalDirectiveRecord_areInDifferentConditionalDirectiveRegion(x, lhs, rhs)
end
