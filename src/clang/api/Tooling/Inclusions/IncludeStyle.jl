# IncludeStyle
#
# `clang::tooling::IncludeStyle` is a settings struct with no member functions, so every
# wrapper below reads or writes a field rather than calling a method.

"""
    IncludeStyle() -> IncludeStyle
Create an include style seeded with clang-format's LLVM defaults: `IBS_Preserve`, the three
LLVM include categories, and `IncludeIsMainRegex = "(Test)?\$"`.

Clang's own struct has no in-class initialisers, so a value-initialised one would leave
`IncludeBlocks` and both regexes indeterminate; the shim never hands one of those out.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function IncludeStyle()
    ptr = clang_IncludeStyle_create()
    @assert ptr != C_NULL "Failed to create IncludeStyle"
    return IncludeStyle(ptr)
end

dispose(x::IncludeStyle) = clang_IncludeStyle_dispose(x)

"""
    getIncludeBlocks(x::AbstractIncludeStyle) -> CXIncludeBlocksStyle
Return whether `#include` blocks are left alone, merged, or merged and regrouped.
"""
function getIncludeBlocks(x::AbstractIncludeStyle)
    @check_ptrs x
    return clang_IncludeStyle_getIncludeBlocks(x)
end

function setIncludeBlocks(x::AbstractIncludeStyle, style::CXIncludeBlocksStyle)
    @check_ptrs x
    return clang_IncludeStyle_setIncludeBlocks(x, style)
end

"""
    getIncludeIsMainRegex(x::AbstractIncludeStyle) -> String
Return the regex of header-stem suffixes that still count as the main include, so that
`a.h` is the main header of both `a.cc` and `a_test.cc`.
"""
function getIncludeIsMainRegex(x::AbstractIncludeStyle)
    @check_ptrs x
    return get_string(clang_IncludeStyle_getIncludeIsMainRegex(x))
end

function setIncludeIsMainRegex(x::AbstractIncludeStyle, regex::AbstractString)
    @check_ptrs x
    return clang_IncludeStyle_setIncludeIsMainRegex(x, regex)
end

"""
    getIncludeIsMainSourceRegex(x::AbstractIncludeStyle) -> String
Return the regex of file names, beyond the usual `.c`/`.cc`/`.cpp` set, that are treated as
main source files for the purpose of finding a main include.
"""
function getIncludeIsMainSourceRegex(x::AbstractIncludeStyle)
    @check_ptrs x
    return get_string(clang_IncludeStyle_getIncludeIsMainSourceRegex(x))
end

function setIncludeIsMainSourceRegex(x::AbstractIncludeStyle, regex::AbstractString)
    @check_ptrs x
    return clang_IncludeStyle_setIncludeIsMainSourceRegex(x, regex)
end

"""
    getNumIncludeCategories(x::AbstractIncludeStyle) -> UInt32
Return how many include categories the style defines.
"""
function getNumIncludeCategories(x::AbstractIncludeStyle)
    @check_ptrs x
    return clang_IncludeStyle_getNumIncludeCategories(x)
end

"""
    getIncludeCategoryRegex(x::AbstractIncludeStyle, i::Integer) -> String
Return the regex of the `i`-th category, counting from 0. Categories are matched in order
against the include name, brackets and all.
"""
function getIncludeCategoryRegex(x::AbstractIncludeStyle, i::Integer)
    @check_ptrs x
    @assert 0 <= i < clang_IncludeStyle_getNumIncludeCategories(x) "include category index $i out of range"
    return get_string(clang_IncludeStyle_getIncludeCategoryRegex(x, i))
end

"""
    getIncludeCategoryPriority(x::AbstractIncludeStyle, i::Integer) -> Int32
Return the priority of the `i`-th category: lower sorts earlier, and a negative value puts a
header ahead of the main include.
"""
function getIncludeCategoryPriority(x::AbstractIncludeStyle, i::Integer)
    @check_ptrs x
    @assert 0 <= i < clang_IncludeStyle_getNumIncludeCategories(x) "include category index $i out of range"
    return clang_IncludeStyle_getIncludeCategoryPriority(x, i)
end

"""
    getIncludeCategorySortPriority(x::AbstractIncludeStyle, i::Integer) -> Int32
Return the sort priority of the `i`-th category, which orders includes *within* a regroup
independently of the block order `Priority` gives.
"""
function getIncludeCategorySortPriority(x::AbstractIncludeStyle, i::Integer)
    @check_ptrs x
    @assert 0 <= i < clang_IncludeStyle_getNumIncludeCategories(x) "include category index $i out of range"
    return clang_IncludeStyle_getIncludeCategorySortPriority(x, i)
end

"""
    getIncludeCategoryRegexIsCaseSensitive(x::AbstractIncludeStyle, i::Integer) -> Bool
Return whether the `i`-th category's regex is matched case-sensitively.
"""
function getIncludeCategoryRegexIsCaseSensitive(x::AbstractIncludeStyle, i::Integer)
    @check_ptrs x
    @assert 0 <= i < clang_IncludeStyle_getNumIncludeCategories(x) "include category index $i out of range"
    return clang_IncludeStyle_getIncludeCategoryRegexIsCaseSensitive(x, i)
end

"""
    addIncludeCategory(x::AbstractIncludeStyle, regex::AbstractString, priority::Integer,
                       sort_priority::Integer=0, case_sensitive::Bool=false)
Append one include category.

Order matters — the first matching regex wins — so this puts the new category last; clear
the list and rebuild it to control where it sits.
"""
function addIncludeCategory(x::AbstractIncludeStyle, regex::AbstractString, priority::Integer, sort_priority::Integer=0, case_sensitive::Bool=false)
    @check_ptrs x
    return clang_IncludeStyle_addIncludeCategory(x, regex, priority, sort_priority, case_sensitive)
end

"""
    clearIncludeCategories(x::AbstractIncludeStyle)
Drop every include category, which leaves every include in the same (INT_MAX) category.
"""
function clearIncludeCategories(x::AbstractIncludeStyle)
    @check_ptrs x
    return clang_IncludeStyle_clearIncludeCategories(x)
end
