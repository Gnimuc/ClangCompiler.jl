# IncludeCategoryManager

"""
    IncludeCategoryManager(style::AbstractIncludeStyle, file_name::AbstractString)
Create the object that answers which category an include name falls in.

`file_name` is what makes one of the includes the *main* header — the one that gets priority
0 — so it is the name the code would be compiled under. `style` is copied, so it may be
disposed as soon as this returns.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function IncludeCategoryManager(style::AbstractIncludeStyle, file_name::AbstractString)
    @check_ptrs style
    ptr = clang_IncludeCategoryManager_create(style, file_name)
    @assert ptr != C_NULL "Failed to create IncludeCategoryManager"
    return IncludeCategoryManager(ptr)
end

dispose(x::IncludeCategoryManager) = clang_IncludeCategoryManager_dispose(x)

"""
    getIncludePriority(x::AbstractIncludeCategoryManager, include_name::AbstractString,
                       check_main_header::Bool) -> Int32
Return the priority of the category `include_name` belongs to.

`include_name` carries its quotes or angle brackets: `"<vector>"`, `"\\"a.h\\""`. With
`check_main_header` set, the main header answers 0; an include no category regex matches
answers `typemax(Int32)`.

Clang documents this as not thread-safe.
"""
function getIncludePriority(x::AbstractIncludeCategoryManager,
                            include_name::AbstractString, check_main_header::Bool)
    @check_ptrs x
    return clang_IncludeCategoryManager_getIncludePriority(x, include_name,
                                                           check_main_header)
end

"""
    getSortIncludePriority(x::AbstractIncludeCategoryManager, include_name::AbstractString,
                           check_main_header::Bool) -> Int32
Same as [`getIncludePriority`](@ref), but reporting the category's `SortPriority` — the one
that orders includes inside a regrouped block.
"""
function getSortIncludePriority(x::AbstractIncludeCategoryManager,
                                include_name::AbstractString, check_main_header::Bool)
    @check_ptrs x
    return clang_IncludeCategoryManager_getSortIncludePriority(x, include_name,
                                                               check_main_header)
end

# HeaderIncludes

"""
    HeaderIncludes(file_name::AbstractString, code::AbstractString, style::AbstractIncludeStyle)
Scan `code` and record where each existing `#include`/`#import` sits, so that
[`insert`](@ref) and [`remove`](@ref) can compute edits that respect the layout already
there.

`file_name` is the name the code would be compiled under — it decides which include is the
main header. `style` is copied.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function HeaderIncludes(file_name::AbstractString, code::AbstractString,
                        style::AbstractIncludeStyle)
    @check_ptrs style
    ptr = clang_HeaderIncludes_create(file_name, code, style)
    @assert ptr != C_NULL "Failed to create HeaderIncludes"
    return HeaderIncludes(ptr)
end

dispose(x::HeaderIncludes) = clang_HeaderIncludes_dispose(x)

"""
    insert(x::AbstractHeaderIncludes, header::AbstractString, is_angled::Bool,
           directive::CXIncludeDirective=CXIncludeDirective_Include) -> Union{Replacement,Nothing}
Return the edit that adds `header` to the buffer, or `nothing` when it is already included
with exactly this spelling.

`header` is the *bare* name — `"vector"`, never `"<vector>"` — because `is_angled` is what
supplies the quoting; Clang asserts that the name has already been trimmed. "Already
included" is judged on the full spelling *and* the directive, so `#include <vector>` does
not stop `#import <vector>` or `#include "vector"`.

`is_angled` picks `<>` over `""`. The insertion point is chosen inside the `#include` block
of the same category, keeping the order of the includes already there — which is the whole
reason to compute this rather than prepend a line. Includes that come *after* the leading
block, inside `#if`s or raw string literals, are deliberately ignored as candidates.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function insert(x::AbstractHeaderIncludes, header::AbstractString, is_angled::Bool,
                directive::CXIncludeDirective=CXIncludeDirective_Include)
    @check_ptrs x
    @assert !isempty(header) "the header name must not be empty"
    @assert !startswith(header, '<') && !startswith(header, '"') "the header name carries no quoting: pass \"vector\", not \"<vector>\""
    ptr = clang_HeaderIncludes_insert(x, header, is_angled, directive)
    return ptr == C_NULL ? nothing : Replacement(ptr)
end

"""
    remove(x::AbstractHeaderIncludes, header::AbstractString, is_angled::Bool) -> Replacements
Return the edits that delete every `#include`/`#import` of `header` with this quoting.

`header` is the bare name, as for [`insert`](@ref). No path resolution happens: only an
exactly equal spelling is matched. The set is empty when there is nothing to remove.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function remove(x::AbstractHeaderIncludes, header::AbstractString, is_angled::Bool)
    @check_ptrs x
    @assert !isempty(header) "the header name must not be empty"
    @assert !startswith(header, '<') && !startswith(header, '"') "the header name carries no quoting: pass \"vector\", not \"<vector>\""
    ptr = clang_HeaderIncludes_remove(x, header, is_angled)
    @assert ptr != C_NULL "Failed to compute the removal replacements"
    return Replacements(ptr)
end
