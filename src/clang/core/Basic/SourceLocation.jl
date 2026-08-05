"""
    struct FileID <: AbstractFileID
Hold a pointer to a `clang::FileID` object.

Note that, this ID is managed by source manager and should not be manually created.
"""
struct FileID <: AbstractFileID
    ptr::CXFileID
end

"""
    struct SourceLocation <: AbstractSourceLocation
Represent a Clang source location.

Note that, the underlying pointer is NOT a *pointer* to a `clang::SourceLocation` object.
Instead, it's the opaque pointer representation of the `clang::SourceLocation` itself.
"""
struct SourceLocation <: AbstractSourceLocation
    ptr::CXSourceLocation_
end

"""
    struct SourceRange <: Any
Hold two `SourceLocation`s.
"""
struct SourceRange
    begin_loc::SourceLocation
    end_loc::SourceLocation
end

"""
    mutable struct CharSourceRange <: Any
Hold a `SourceRange` together with the flag saying whether its end designates the start of
the last token (a token range) or the last character of the range (a character range).

`clang::CharSourceRange` is a pure aggregate of exactly those two fields, so — like
`SourceRange` — it is reproduced structurally in Julia instead of crossing the C boundary.
The struct is mutable because Clang's `setBegin`/`setEnd`/`setTokenRange` mutate in place.
"""
mutable struct CharSourceRange
    range::SourceRange
    is_token_range::Bool
end

"""
    struct PresumedLoc <: AbstractPresumedLoc
Hold a pointer to a `clang::PresumedLoc` object.

The object is a heap-boxed copy of a by-value C++ value, so it is caller-owned: release it
with `dispose`.
"""
struct PresumedLoc <: AbstractPresumedLoc
    ptr::CXPresumedLoc
end

"""
    struct FullSourceLoc <: Any
Hold a `SourceLocation` together with the `SourceManager` that can interpret it.

`clang::FullSourceLoc` is exactly those two fields — a `SourceLocation` plus a borrowed
`const SourceManager *` — and every one of its accessors forwards to that manager, so it is
reproduced structurally in Julia instead of crossing the C boundary, the same way
`SourceRange` and `CharSourceRange` are. A default-constructed value carries a NULL manager
and answers `hasManager` with `false`.

The manager field is typed at `AbstractSourceManager` because the concrete `SourceManager`
carrier is defined in a file this one precedes; the manager is borrowed and must never be
disposed through this struct.
"""
struct FullSourceLoc
    loc::SourceLocation
    src_mgr::AbstractSourceManager
end
