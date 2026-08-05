# FileID
getHashValue(id::FileID) = clang_FileID_getHashValue(id)

dispose(x::FileID) = clang_FileID_dispose(x)

# SourceLocation
SourceLocation() = SourceLocation(clang_SourceLocation_createInvalid())

isFileID(x::SourceLocation) = clang_SourceLocation_isFileID(x)
isMacroID(x::SourceLocation) = clang_SourceLocation_isMacroID(x)
isValid(x::SourceLocation) = clang_SourceLocation_isValid(x)
isInvalid(x::SourceLocation) = clang_SourceLocation_isInvalid(x)
getHashValue(x::SourceLocation) = clang_SourceLocation_getHashValue(x)

function isPairOfFileLocations(b::SourceLocation, e::SourceLocation)
    return clang_SourceLocation_isPairOfFileLocations(b, e)
end

function getLocWithOffset(x::SourceLocation, offset::Integer)
    return SourceLocation(clang_SourceLocation_getLocWithOffset(x, offset))
end

function printToString(x::SourceLocation, src_mgr::SourceManager)
    @check_ptrs src_mgr
    return get_string(clang_SourceLocation_printToString(x, src_mgr))
end

# SourceRange
getBeginLoc(x::SourceRange) = x.begin_loc
getEndLoc(x::SourceRange) = x.end_loc

getRawEncoding(x::SourceLocation) = clang_SourceLocation_getRawEncoding(x)

getFromRawEncoding(encoding::Integer) = SourceLocation(clang_SourceLocation_getFromRawEncoding(encoding))

isValid(x::SourceRange) = isValid(x.begin_loc) && isValid(x.end_loc)
isInvalid(x::SourceRange) = !isValid(x)

"""
    fullyContains(x::SourceRange, other::SourceRange) -> Bool
Return `true` iff `other` is wholly contained within `x` (raw-encoding order — meaningful
only when both ranges are in the same FileID).
"""
function fullyContains(x::SourceRange, other::SourceRange)
    return getRawEncoding(x.begin_loc) <= getRawEncoding(other.begin_loc) && getRawEncoding(x.end_loc) >= getRawEncoding(other.end_loc)
end

function printToString(x::SourceRange, src_mgr::SourceManager)
    @check_ptrs src_mgr
    r = CXSourceRange_(x.begin_loc.ptr, x.end_loc.ptr)
    return get_string(clang_SourceRange_printToString(r, src_mgr))
end

function dump(x::SourceRange, src_mgr::SourceManager)
    @check_ptrs src_mgr
    return clang_SourceRange_dump(CXSourceRange_(x.begin_loc.ptr, x.end_loc.ptr), src_mgr)
end

"""
    isValid(x::FileID) -> Bool
Return `true` iff `x` designates a source file, i.e. is not the null `FileID`.
"""
function isValid(x::FileID)
    @check_ptrs x
    return clang_FileID_isValid(x)
end

"""
    isInvalid(x::FileID) -> Bool
Return `true` iff `x` is the null `FileID`.
"""
function isInvalid(x::FileID)
    @check_ptrs x
    return clang_FileID_isInvalid(x)
end

"""
    getSentinel() -> FileID
Return the sentinel `FileID` the source manager's caches use as a "no entry" marker. It is
not the null `FileID`: the sentinel compares as valid and hashes to `typemax(UInt32)`.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
getSentinel() = FileID(clang_FileID_getSentinel())

# CharSourceRange
"""
    getTokenRange(r::SourceRange) -> CharSourceRange
    getTokenRange(b::SourceLocation, e::SourceLocation) -> CharSourceRange
Build a token range: its end designates the *start of the last token*, so the real end of
the range is known only once that token's length has been measured.
"""
getTokenRange(r::SourceRange) = CharSourceRange(r, true)
getTokenRange(b::SourceLocation, e::SourceLocation) = getTokenRange(SourceRange(b, e))

"""
    getCharRange(r::SourceRange) -> CharSourceRange
    getCharRange(b::SourceLocation, e::SourceLocation) -> CharSourceRange
Build a character range: its end designates the last character of the range.
"""
getCharRange(r::SourceRange) = CharSourceRange(r, false)
getCharRange(b::SourceLocation, e::SourceLocation) = getCharRange(SourceRange(b, e))

"""
    isTokenRange(x::CharSourceRange) -> Bool
Return `true` iff the end of `x` specifies the start of the last token.
"""
isTokenRange(x::CharSourceRange) = x.is_token_range

"""
    isCharRange(x::CharSourceRange) -> Bool
Return `true` iff the end of `x` specifies the last character in the range.
"""
isCharRange(x::CharSourceRange) = !x.is_token_range

getBegin(x::CharSourceRange) = x.range.begin_loc
getEnd(x::CharSourceRange) = x.range.end_loc
getAsRange(x::CharSourceRange) = x.range

function setBegin(x::CharSourceRange, b::SourceLocation)
    x.range = SourceRange(b, x.range.end_loc)
    return nothing
end

function setEnd(x::CharSourceRange, e::SourceLocation)
    x.range = SourceRange(x.range.begin_loc, e)
    return nothing
end

function setTokenRange(x::CharSourceRange, is_token_range::Bool)
    x.is_token_range = is_token_range
    return nothing
end

isValid(x::CharSourceRange) = isValid(x.range)
isInvalid(x::CharSourceRange) = !isValid(x)

# PresumedLoc
"""
    PresumedLoc(src_mgr::SourceManager, loc::SourceLocation; use_line_directives::Bool=true) -> PresumedLoc
Return the presumed location of `loc` — the `#line`/GNU-line-marker-aware view of a source
location that diagnostics present to the user — as a `clang::PresumedLoc` object.

The result is *invalid* whenever the presumed location cannot be computed (`loc` is invalid,
or the file holding it changed on disk). Every accessor asserts validity, so test `isValid`
before reaching for one.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function PresumedLoc(src_mgr::SourceManager, loc::SourceLocation; use_line_directives::Bool=true)
    @check_ptrs src_mgr
    return PresumedLoc(clang_PresumedLoc_create(src_mgr, loc, use_line_directives))
end

dispose(x::PresumedLoc) = clang_PresumedLoc_dispose(x)

"""
    isInvalid(x::PresumedLoc) -> Bool
Return `true` iff `x` is invalid or uninitialized, i.e. holds no presumed filename.
"""
function isInvalid(x::PresumedLoc)
    @check_ptrs x
    return clang_PresumedLoc_isInvalid(x)
end

"""
    isValid(x::PresumedLoc) -> Bool
Return `true` iff `x` holds a presumed filename, which is the precondition of every other
accessor.
"""
function isValid(x::PresumedLoc)
    @check_ptrs x
    return clang_PresumedLoc_isValid(x)
end

"""
    getFilename(x::PresumedLoc) -> String
Return the presumed filename of the location, as `#line` and GNU line-marker directives
report it.

`clang::PresumedLoc::getFilename` asserts `isValid()` and returns a member left null on an
invalid location; the precondition is restated here.
"""
function getFilename(x::PresumedLoc)
    @check_ptrs x
    @assert isValid(x) "presumed location must be valid"
    return unsafe_string(clang_PresumedLoc_getFilename(x))
end

"""
    getFileID(x::PresumedLoc) -> FileID
Return the `FileID` the presumed location belongs to.

`clang::PresumedLoc::getFileID` asserts `isValid()`; the precondition is restated here.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function getFileID(x::PresumedLoc)
    @check_ptrs x
    @assert isValid(x) "presumed location must be valid"
    return FileID(clang_PresumedLoc_getFileID(x))
end

"""
    getLine(x::PresumedLoc) -> UInt32
Return the presumed line number of the location, as `#line` and GNU line-marker directives
report it.

`clang::PresumedLoc::getLine` asserts `isValid()` and reads a member with no default
initializer; the precondition is restated here.
"""
function getLine(x::PresumedLoc)
    @check_ptrs x
    @assert isValid(x) "presumed location must be valid"
    return clang_PresumedLoc_getLine(x)
end

"""
    getColumn(x::PresumedLoc) -> UInt32
Return the column number of the location. `#line` cannot affect it; it rides along with the
presumed location for convenience.

`clang::PresumedLoc::getColumn` asserts `isValid()` and reads a member with no default
initializer; the precondition is restated here.
"""
function getColumn(x::PresumedLoc)
    @check_ptrs x
    @assert isValid(x) "presumed location must be valid"
    return clang_PresumedLoc_getColumn(x)
end

"""
    getIncludeLoc(x::PresumedLoc) -> SourceLocation
Return the presumed `#include` location of the file holding this location, which GNU line
marker directives can change.

`clang::PresumedLoc::getIncludeLoc` asserts `isValid()`; the precondition is restated here.
"""
function getIncludeLoc(x::PresumedLoc)
    @check_ptrs x
    @assert isValid(x) "presumed location must be valid"
    return SourceLocation(clang_PresumedLoc_getIncludeLoc(x))
end

# FullSourceLoc
# Every accessor forwards to the manager the location was paired with, so the family is
# written against the existing SourceManager bindings rather than against new C functions.
"""
    FullSourceLoc() -> FullSourceLoc
Build the invalid `FullSourceLoc`: an invalid location carrying no source manager.
"""
FullSourceLoc() = FullSourceLoc(SourceLocation(), SourceManager(C_NULL))

"""
    hasManager(x::FullSourceLoc) -> Bool
Return `true` iff `x` carries a source manager. Every accessor that has to interpret the
location needs one, so this is their shared precondition.
"""
hasManager(x::FullSourceLoc) = !is_null_handle(x.src_mgr)

"""
    getManager(x::FullSourceLoc) -> AbstractSourceManager
Return the borrowed source manager `x` was built with — never `dispose` it through this
carrier.

`clang::FullSourceLoc::getManager` asserts that a manager is present; the precondition is
restated here.
"""
function getManager(x::FullSourceLoc)
    @assert hasManager(x) "full source location must carry a source manager"
    return x.src_mgr
end

"""
    getFileID(x::FullSourceLoc) -> FileID
Return the `FileID` containing the location.

`clang::FullSourceLoc` asserts that a manager is present; the precondition is restated here.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function getFileID(x::FullSourceLoc)
    @assert hasManager(x) "full source location must carry a source manager"
    return getFileID(x.src_mgr, x.loc)
end

"""
    getFileOffset(x::FullSourceLoc) -> UInt32
Return the offset of the location from the start of its file buffer.

`clang::FullSourceLoc` asserts that a manager is present; the precondition is restated here.
"""
function getFileOffset(x::FullSourceLoc)
    @assert hasManager(x) "full source location must carry a source manager"
    return getFileOffset(x.src_mgr, x.loc)
end

"""
    getExpansionLoc(x::FullSourceLoc) -> FullSourceLoc
Return the location the macro expansion holding `x` was written at, paired with the same
manager.

`clang::FullSourceLoc` asserts that a manager is present; the precondition is restated here.
"""
function getExpansionLoc(x::FullSourceLoc)
    @assert hasManager(x) "full source location must carry a source manager"
    return FullSourceLoc(getExpansionLoc(x.src_mgr, x.loc), x.src_mgr)
end

"""
    getSpellingLoc(x::FullSourceLoc) -> FullSourceLoc
Return the location the characters behind `x` were actually spelled at, paired with the same
manager.

`clang::FullSourceLoc` asserts that a manager is present; the precondition is restated here.
"""
function getSpellingLoc(x::FullSourceLoc)
    @assert hasManager(x) "full source location must carry a source manager"
    return FullSourceLoc(getSpellingLoc(x.src_mgr, x.loc), x.src_mgr)
end

"""
    getFileLoc(x::FullSourceLoc) -> FullSourceLoc
Return the file location `x` maps to — the spelling location for a macro argument and the
expansion location otherwise — paired with the same manager.

`clang::FullSourceLoc` asserts that a manager is present; the precondition is restated here.
"""
function getFileLoc(x::FullSourceLoc)
    @assert hasManager(x) "full source location must carry a source manager"
    return FullSourceLoc(getFileLoc(x.src_mgr, x.loc), x.src_mgr)
end

"""
    getLineNumber(x::FullSourceLoc) -> UInt32
Return the 1-based line number of the location within its file buffer.

`clang::FullSourceLoc` asserts that a manager is present; the precondition is restated here.
"""
function getLineNumber(x::FullSourceLoc)
    @assert hasManager(x) "full source location must carry a source manager"
    id, offset = getDecomposedLoc(x.src_mgr, x.loc)
    n = getLineNumber(x.src_mgr, id, offset)
    dispose(id)
    return n
end

"""
    getColumnNumber(x::FullSourceLoc) -> UInt32
Return the 1-based column number of the location within its line.

`clang::FullSourceLoc` asserts that a manager is present; the precondition is restated here.
"""
function getColumnNumber(x::FullSourceLoc)
    @assert hasManager(x) "full source location must carry a source manager"
    id, offset = getDecomposedLoc(x.src_mgr, x.loc)
    n = getColumnNumber(x.src_mgr, id, offset)
    dispose(id)
    return n
end

"""
    isInSystemHeader(x::FullSourceLoc) -> Bool
Return `true` iff the location lies in a system header.

`clang::FullSourceLoc` asserts that a manager is present; the precondition is restated here.
"""
function isInSystemHeader(x::FullSourceLoc)
    @assert hasManager(x) "full source location must carry a source manager"
    return isInSystemHeader(x.src_mgr, x.loc)
end

"""
    isBeforeInTranslationUnitThan(x::FullSourceLoc, loc::SourceLocation) -> Bool
    isBeforeInTranslationUnitThan(x::FullSourceLoc, other::FullSourceLoc) -> Bool
Return `true` iff `x` comes before the other location in the translation unit.

`clang::FullSourceLoc` asserts that a manager is present, and its `FullSourceLoc` overload
additionally asserts that the other location is valid and came from the same manager; all
three preconditions are restated here.
"""
function isBeforeInTranslationUnitThan(x::FullSourceLoc, loc::SourceLocation)
    @assert hasManager(x) "full source location must carry a source manager"
    return isBeforeInTranslationUnit(x.src_mgr, x.loc, loc)
end

function isBeforeInTranslationUnitThan(x::FullSourceLoc, other::FullSourceLoc)
    @assert isValid(other.loc) "the compared location must be valid"
    @assert x.src_mgr.ptr == other.src_mgr.ptr "both locations must come from the same source manager"
    return isBeforeInTranslationUnitThan(x, other.loc)
end

"""
    getPresumedLoc(x::FullSourceLoc; use_line_directives::Bool=true) -> PresumedLoc
Return the `#line`-aware presumed location of `x` as a `clang::PresumedLoc` object.

`clang::FullSourceLoc` asserts that a manager is present; the precondition is restated here.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function getPresumedLoc(x::FullSourceLoc; use_line_directives::Bool=true)
    @assert hasManager(x) "full source location must carry a source manager"
    return PresumedLoc(x.src_mgr, x.loc; use_line_directives=use_line_directives)
end

"""
    isMacroArgExpansion(x::FullSourceLoc) -> (Bool, FullSourceLoc)
Test whether `x` is a macro argument expansion; the second element is the start of the
expansion paired with the same manager, and is invalid when the predicate is `false`.

`clang::FullSourceLoc` asserts that a manager is present; the precondition is restated here.
"""
function isMacroArgExpansion(x::FullSourceLoc)
    @assert hasManager(x) "full source location must carry a source manager"
    ret, start = isMacroArgExpansion(x.src_mgr, x.loc)
    return ret, FullSourceLoc(start, x.src_mgr)
end

"""
    getImmediateMacroCallerLoc(x::FullSourceLoc) -> FullSourceLoc
Return the location of the immediate macro caller — where the macro `x` came from was
spelled or expanded one level up — paired with the same manager.

`clang::FullSourceLoc` asserts that a manager is present; the precondition is restated here.
"""
function getImmediateMacroCallerLoc(x::FullSourceLoc)
    @assert hasManager(x) "full source location must carry a source manager"
    return FullSourceLoc(getImmediateMacroCallerLoc(x.src_mgr, x.loc), x.src_mgr)
end

"""
    getModuleImportLoc(x::FullSourceLoc) -> (FullSourceLoc, String)
Return the import location and name of the module `x` lives in. The location is invalid and
the name empty when `x` belongs to the current translation unit rather than to a loaded
module.

`clang::FullSourceLoc` asserts that a manager is present; the precondition is restated here.
"""
function getModuleImportLoc(x::FullSourceLoc)
    @assert hasManager(x) "full source location must carry a source manager"
    loc, name = getModuleImportLoc(x.src_mgr, x.loc)
    return FullSourceLoc(loc, x.src_mgr), name
end

"""
    getExpansionLineNumber(x::FullSourceLoc) -> UInt32
Return the 1-based line number of the location the macro expansion holding `x` was written
at.

`clang::FullSourceLoc` asserts that a manager is present; the precondition is restated here.
"""
function getExpansionLineNumber(x::FullSourceLoc)
    @assert hasManager(x) "full source location must carry a source manager"
    return getExpansionLineNumber(x.src_mgr, x.loc)
end

"""
    getExpansionColumnNumber(x::FullSourceLoc) -> UInt32
Return the 1-based column number of the location the macro expansion holding `x` was written
at.

`clang::FullSourceLoc` asserts that a manager is present; the precondition is restated here.
"""
function getExpansionColumnNumber(x::FullSourceLoc)
    @assert hasManager(x) "full source location must carry a source manager"
    return getExpansionColumnNumber(x.src_mgr, x.loc)
end

"""
    getSpellingLineNumber(x::FullSourceLoc) -> UInt32
Return the 1-based line number of the location the characters behind `x` were spelled at.

`clang::FullSourceLoc` asserts that a manager is present; the precondition is restated here.
"""
function getSpellingLineNumber(x::FullSourceLoc)
    @assert hasManager(x) "full source location must carry a source manager"
    return getSpellingLineNumber(x.src_mgr, x.loc)
end

"""
    getSpellingColumnNumber(x::FullSourceLoc) -> UInt32
Return the 1-based column number of the location the characters behind `x` were spelled at.

`clang::FullSourceLoc` asserts that a manager is present; the precondition is restated here.
"""
function getSpellingColumnNumber(x::FullSourceLoc)
    @assert hasManager(x) "full source location must carry a source manager"
    return getSpellingColumnNumber(x.src_mgr, x.loc)
end

"""
    getCharacterData(x::FullSourceLoc) -> String
Return the text from `x` to the end of its spelling buffer (source buffers are
NUL-terminated).

`clang::FullSourceLoc` asserts that a manager is present; the precondition is restated here.
"""
function getCharacterData(x::FullSourceLoc)
    @assert hasManager(x) "full source location must carry a source manager"
    return getCharacterData(x.src_mgr, x.loc)
end

"""
    getBufferData(x::FullSourceLoc) -> String
Return the whole source buffer of the file `x` lives in.

`clang::FullSourceLoc` asserts that a manager is present; the precondition is restated here.
"""
function getBufferData(x::FullSourceLoc)
    @assert hasManager(x) "full source location must carry a source manager"
    id = getFileID(x)
    data = getBufferData(x.src_mgr, id)
    dispose(id)
    return data
end

"""
    getFileEntryRef(x::FullSourceLoc) -> Union{FileEntryRef,Nothing}
Return a heap-boxed `FileEntryRef` for the file `x` lives in, or `nothing` when that file ID
has no file entry (e.g. it was created from a memory buffer).

`clang::FullSourceLoc` asserts that a manager is present; the precondition is restated here.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function getFileEntryRef(x::FullSourceLoc)
    @assert hasManager(x) "full source location must carry a source manager"
    id = getFileID(x)
    ref = getFileEntryRefForID(x.src_mgr, id)
    dispose(id)
    return ref
end

"""
    getFileEntry(x::FullSourceLoc) -> Union{FileEntry,Nothing}
Return the borrowed `FileEntry` for the file `x` lives in, or `nothing` when that file ID has
no file entry (e.g. it was created from a memory buffer).

`clang::FullSourceLoc` asserts that a manager is present; the precondition is restated here.
"""
function getFileEntry(x::FullSourceLoc)
    @assert hasManager(x) "full source location must carry a source manager"
    id = getFileID(x)
    entry = getFileEntryForID(x.src_mgr, id)
    dispose(id)
    return entry
end

"""
    getDecomposedLoc(x::FullSourceLoc) -> (FileID, UInt32)
Split the location into the `FileID` holding it and its offset within that file's buffer.

`clang::FullSourceLoc` asserts that a manager is present; the precondition is restated here.

The returned `FileID` allocates and one should call `dispose` to release the resources after
using this object.
"""
function getDecomposedLoc(x::FullSourceLoc)
    @assert hasManager(x) "full source location must carry a source manager"
    return getDecomposedLoc(x.src_mgr, x.loc)
end

"""
    getDecomposedExpansionLoc(x::FullSourceLoc) -> (FileID, UInt32)
Split the location's expansion location into its `FileID` and the offset within that file's
buffer.

`clang::FullSourceLoc` asserts that a manager is present; the precondition is restated here.

The returned `FileID` allocates and one should call `dispose` to release the resources after
using this object.
"""
function getDecomposedExpansionLoc(x::FullSourceLoc)
    @assert hasManager(x) "full source location must carry a source manager"
    return getDecomposedExpansionLoc(x.src_mgr, x.loc)
end

"""
    dump(x::FullSourceLoc)
Print the location to `stderr` through the manager it is paired with.

`clang::FullSourceLoc` asserts that a manager is present; the precondition is restated here.
"""
function dump(x::FullSourceLoc)
    @assert hasManager(x) "full source location must carry a source manager"
    return dump(x.loc, x.src_mgr)
end
