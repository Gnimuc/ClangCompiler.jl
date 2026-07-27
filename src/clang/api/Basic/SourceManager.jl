# SourceManager
function SourceManager(file_mgr::FileManager, diag::DiagnosticsEngine=DiagnosticsEngine(),
                       volatile::Bool=false)
    mgr = clang_SourceManager_create(diag, file_mgr, volatile)
    @assert mgr != C_NULL "Failed to create SourceManager"
    return SourceManager(mgr)
end

dispose(x::SourceManager) = clang_SourceManager_dispose(x)

function PrintStats(mgr::SourceManager)
    @check_ptrs mgr
    return clang_SourceManager_PrintStats(mgr)
end

"""
    FileID(src_mgr::SourceManager, buffer::MemoryBuffer)
Create a file ID from a memory buffer.

This function takes ownership of the memory buffer.
"""
function FileID(src_mgr::SourceManager, buffer::LLVM.MemoryBuffer)
    @check_ptrs src_mgr
    return FileID(clang_SourceManager_createFileIDFromMemoryBuffer(src_mgr, buffer.ref))
end

"""
    FileID(src_mgr::SourceManager, ref::FileEntryRef)
Create a file ID from a file entry reference (see `getFileRef`). The C side
dereferences the heap-boxed `clang::FileEntryRef` — a plain `FileEntry` is not
accepted.

See also [`get_file`](@ref).
"""
function FileID(src_mgr::SourceManager, ref::FileEntryRef,
                loc::SourceLocation=SourceLocation())
    @check_ptrs src_mgr ref
    return FileID(clang_SourceManager_createFileIDFromFileEntry(src_mgr, ref, loc))
end

"""
    getMainFileID(src_mgr::SourceManager) -> FileID
Return the main file ID.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function getMainFileID(src_mgr::SourceManager)
    @check_ptrs src_mgr
    return FileID(clang_SourceManager_getMainFileID(src_mgr))
end

"""
    setMainFileID(src_mgr::SourceManager, id::FileID)
Set the main file ID of the source manager to `id`.
"""
function setMainFileID(src_mgr::SourceManager, id::FileID)
    @check_ptrs src_mgr id
    return clang_SourceManager_setMainFileID(src_mgr, id)
end

"""
    setMainFileID(src_mgr::SourceManager, ref::FileEntryRef)
Set the main file ID of the source manager to the file `ref` points to.
"""
function setMainFileID(src_mgr::SourceManager, ref::FileEntryRef)
    id = FileID(src_mgr, ref)
    setMainFileID(src_mgr, id)
    dispose(id)
    return nothing
end

"""
    setMainFileID(src_mgr::SourceManager, buffer::MemoryBuffer)
Set the main file ID of the source manager to `buffer`.
"""
function setMainFileID(src_mgr::SourceManager, buffer::LLVM.MemoryBuffer)
    id = FileID(src_mgr, buffer)
    setMainFileID(src_mgr, id)
    dispose(id)
    return nothing
end

function getLocForStartOfFile(src_mgr::SourceManager, id::FileID)
    @check_ptrs src_mgr id
    return SourceLocation(clang_SourceManager_getLocForStartOfFile(src_mgr, id))
end

function getLocForEndOfFile(src_mgr::SourceManager, id::FileID)
    @check_ptrs src_mgr id
    return SourceLocation(clang_SourceManager_getLocForEndOfFile(src_mgr, id))
end

"""
    overrideFileContents(src_mgr::SourceManager, entry::FileEntryRef, buffer::LLVM.MemoryBuffer)
Override the contents of the given source file with the buffer.

This function takes ownership of the memory buffer.
"""
function overrideFileContents(src_mgr::SourceManager, entry::FileEntryRef,
                              buffer::LLVM.MemoryBuffer)
    @check_ptrs src_mgr entry
    return clang_SourceManager_overrideFileContents(src_mgr, entry, buffer)
end
function dump(x::SourceLocation, src_mgr::SourceManager)
    @check_ptrs src_mgr
    return clang_SourceLocation_dump(x, src_mgr)
end


function getDiagnostics(src_mgr::SourceManager)
    @check_ptrs src_mgr
    return DiagnosticsEngine(clang_SourceManager_getDiagnostics(src_mgr))
end

function getFileManager(src_mgr::SourceManager)
    @check_ptrs src_mgr
    return FileManager(clang_SourceManager_getFileManager(src_mgr))
end

function isMainFile(src_mgr::SourceManager, entry::FileEntry)
    @check_ptrs src_mgr entry
    return clang_SourceManager_isMainFile(src_mgr, entry)
end

"""
    getOrCreateFileID(src_mgr::SourceManager, ref::FileEntryRef, kind::CXCharacteristicKind=CXCharacteristicKind_C_User) -> FileID
Return the `FileID` for the given file, creating one if necessary.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function getOrCreateFileID(src_mgr::SourceManager, ref::FileEntryRef,
                           kind::CXCharacteristicKind=CXCharacteristicKind_C_User)
    @check_ptrs src_mgr ref
    return FileID(clang_SourceManager_getOrCreateFileID(src_mgr, ref, kind))
end

function isFileOverridden(src_mgr::SourceManager, entry::FileEntry)
    @check_ptrs src_mgr entry
    return clang_SourceManager_isFileOverridden(src_mgr, entry)
end

function setFileIsTransient(src_mgr::SourceManager, ref::FileEntryRef)
    @check_ptrs src_mgr ref
    return clang_SourceManager_setFileIsTransient(src_mgr, ref)
end

function setAllFilesAreTransient(src_mgr::SourceManager, transient::Bool)
    @check_ptrs src_mgr
    return clang_SourceManager_setAllFilesAreTransient(src_mgr, transient)
end

"""
    getFileEntryForID(src_mgr::SourceManager, id::FileID) -> Union{FileEntry,Nothing}
Return the borrowed `FileEntry` for `id`, or `nothing` when the file ID has no file entry
(e.g. it was created from a memory buffer).
"""
function getFileEntryForID(src_mgr::SourceManager, id::FileID)
    @check_ptrs src_mgr id
    ptr = clang_SourceManager_getFileEntryForID(src_mgr, id)
    return ptr == C_NULL ? nothing : FileEntry(ptr)
end

"""
    getFileEntryRefForID(src_mgr::SourceManager, id::FileID) -> Union{FileEntryRef,Nothing}
Return a heap-boxed `FileEntryRef` for `id`, or `nothing` when the file ID has no file
entry.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function getFileEntryRefForID(src_mgr::SourceManager, id::FileID)
    @check_ptrs src_mgr id
    ptr = clang_SourceManager_getFileEntryRefForID(src_mgr, id)
    return ptr == C_NULL ? nothing : FileEntryRef(ptr)
end

function getBufferData(src_mgr::SourceManager, id::FileID)
    @check_ptrs src_mgr id
    len = Ref{Csize_t}(0)
    ptr = clang_SourceManager_getBufferData(src_mgr, id, len, C_NULL)
    return ptr == C_NULL ? "" : unsafe_string(ptr, len[])
end

function getNumCreatedFIDsForFileID(src_mgr::SourceManager, id::FileID)
    @check_ptrs src_mgr id
    return clang_SourceManager_getNumCreatedFIDsForFileID(src_mgr, id)
end

"""
    getFileID(src_mgr::SourceManager, loc::SourceLocation) -> FileID
Return the `FileID` containing `loc`.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function getFileID(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    return FileID(clang_SourceManager_getFileID(src_mgr, loc))
end

function getFilename(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    len = Ref{Csize_t}(0)
    ptr = clang_SourceManager_getFilename(src_mgr, loc, len)
    return ptr == C_NULL ? "" : unsafe_string(ptr, len[])
end

function getIncludeLoc(src_mgr::SourceManager, id::FileID)
    @check_ptrs src_mgr id
    return SourceLocation(clang_SourceManager_getIncludeLoc(src_mgr, id))
end

function getExpansionLoc(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    return SourceLocation(clang_SourceManager_getExpansionLoc(src_mgr, loc))
end

function getFileLoc(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    return SourceLocation(clang_SourceManager_getFileLoc(src_mgr, loc))
end

"""
    getImmediateExpansionRange(src_mgr::SourceManager, loc::SourceLocation) -> (SourceRange, Bool)
Return the immediate expansion range of the macro location `loc` and whether it is a token
range. `loc` must be a macro (expansion) location.
"""
function getImmediateExpansionRange(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    is_token = Ref{Bool}(false)
    r = clang_SourceManager_getImmediateExpansionRange(src_mgr, loc, is_token)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E)), is_token[]
end

"""
    getExpansionRange(src_mgr::SourceManager, loc::SourceLocation) -> (SourceRange, Bool)
Return the expansion range of `loc` and whether it is a token range.
"""
function getExpansionRange(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    is_token = Ref{Bool}(false)
    r = clang_SourceManager_getExpansionRange(src_mgr, loc, is_token)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E)), is_token[]
end

function getSpellingLoc(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    return SourceLocation(clang_SourceManager_getSpellingLoc(src_mgr, loc))
end

function getImmediateSpellingLoc(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    return SourceLocation(clang_SourceManager_getImmediateSpellingLoc(src_mgr, loc))
end

function getComposedLoc(src_mgr::SourceManager, id::FileID, offset::Integer)
    @check_ptrs src_mgr id
    return SourceLocation(clang_SourceManager_getComposedLoc(src_mgr, id, offset))
end

"""
    getDecomposedLoc(src_mgr::SourceManager, loc::SourceLocation) -> (FileID, UInt32)
Decompose `loc` into a raw `FileID` + offset pair.

This function allocates (the returned `FileID`) and one should call `dispose` to release the resources after using this object.
"""
function getDecomposedLoc(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    offset = Ref{Cuint}(0)
    id = FileID(clang_SourceManager_getDecomposedLoc(src_mgr, loc, offset))
    return id, offset[]
end

"""
    getDecomposedExpansionLoc(src_mgr::SourceManager, loc::SourceLocation) -> (FileID, UInt32)
Decompose the expansion location of `loc` into a raw `FileID` + offset pair.

This function allocates (the returned `FileID`) and one should call `dispose` to release the resources after using this object.
"""
function getDecomposedExpansionLoc(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    offset = Ref{Cuint}(0)
    id = FileID(clang_SourceManager_getDecomposedExpansionLoc(src_mgr, loc, offset))
    return id, offset[]
end

"""
    getDecomposedSpellingLoc(src_mgr::SourceManager, loc::SourceLocation) -> (FileID, UInt32)
Decompose the spelling location of `loc` into a raw `FileID` + offset pair.

This function allocates (the returned `FileID`) and one should call `dispose` to release the resources after using this object.
"""
function getDecomposedSpellingLoc(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    offset = Ref{Cuint}(0)
    id = FileID(clang_SourceManager_getDecomposedSpellingLoc(src_mgr, loc, offset))
    return id, offset[]
end

"""
    getDecomposedIncludedLoc(src_mgr::SourceManager, id::FileID) -> (FileID, UInt32)
Return the \"included/expanded in\" decomposed location of `id`.

This function allocates (the returned `FileID`) and one should call `dispose` to release the resources after using this object.
"""
function getDecomposedIncludedLoc(src_mgr::SourceManager, id::FileID)
    @check_ptrs src_mgr id
    offset = Ref{Cuint}(0)
    inc_id = FileID(clang_SourceManager_getDecomposedIncludedLoc(src_mgr, id, offset))
    return inc_id, offset[]
end

function getFileOffset(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    return clang_SourceManager_getFileOffset(src_mgr, loc)
end

"""
    isMacroArgExpansion(src_mgr::SourceManager, loc::SourceLocation) -> (Bool, SourceLocation)
Test whether `loc` is a macro argument expansion; the second element is the start location
of the expansion (invalid when the predicate is `false`).
"""
function isMacroArgExpansion(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    start = Ref{CXSourceLocation_}(C_NULL)
    ret = clang_SourceManager_isMacroArgExpansion(src_mgr, loc, start)
    return ret, SourceLocation(start[])
end

function isMacroBodyExpansion(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    return clang_SourceManager_isMacroBodyExpansion(src_mgr, loc)
end

"""
    isAtStartOfImmediateMacroExpansion(src_mgr::SourceManager, loc::SourceLocation) -> (Bool, SourceLocation)
Test whether the macro location `loc` points at the start of the immediate macro
expansion; the second element is the expansion begin location (invalid when the predicate
is `false`). `loc` must be a valid macro location (check `isMacroID` first).
"""
function isAtStartOfImmediateMacroExpansion(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    mbegin = Ref{CXSourceLocation_}(C_NULL)
    ret = clang_SourceManager_isAtStartOfImmediateMacroExpansion(src_mgr, loc, mbegin)
    return ret, SourceLocation(mbegin[])
end

"""
    isAtEndOfImmediateMacroExpansion(src_mgr::SourceManager, loc::SourceLocation) -> (Bool, SourceLocation)
Test whether the macro location `loc` points at the character end of the immediate macro
expansion; the second element is the expansion end location (invalid when the predicate is
`false`). `loc` must be a valid macro location (check `isMacroID` first).
"""
function isAtEndOfImmediateMacroExpansion(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    mend = Ref{CXSourceLocation_}(C_NULL)
    ret = clang_SourceManager_isAtEndOfImmediateMacroExpansion(src_mgr, loc, mend)
    return ret, SourceLocation(mend[])
end

"""
    getCharacterData(src_mgr::SourceManager, loc::SourceLocation) -> String
Return the text from `loc` to the end of its spelling buffer (source buffers are
NUL-terminated).
"""
function getCharacterData(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    ptr = clang_SourceManager_getCharacterData(src_mgr, loc, C_NULL)
    return ptr == C_NULL ? "" : unsafe_string(ptr)
end

function getColumnNumber(src_mgr::SourceManager, id::FileID, pos::Integer)
    @check_ptrs src_mgr id
    return clang_SourceManager_getColumnNumber(src_mgr, id, pos, C_NULL)
end

function getSpellingColumnNumber(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    return clang_SourceManager_getSpellingColumnNumber(src_mgr, loc, C_NULL)
end

function getExpansionColumnNumber(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    return clang_SourceManager_getExpansionColumnNumber(src_mgr, loc, C_NULL)
end

function getPresumedColumnNumber(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    return clang_SourceManager_getPresumedColumnNumber(src_mgr, loc, C_NULL)
end

function getLineNumber(src_mgr::SourceManager, id::FileID, pos::Integer)
    @check_ptrs src_mgr id
    return clang_SourceManager_getLineNumber(src_mgr, id, pos, C_NULL)
end

function getSpellingLineNumber(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    return clang_SourceManager_getSpellingLineNumber(src_mgr, loc, C_NULL)
end

function getExpansionLineNumber(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    return clang_SourceManager_getExpansionLineNumber(src_mgr, loc, C_NULL)
end

function getPresumedLineNumber(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    return clang_SourceManager_getPresumedLineNumber(src_mgr, loc, C_NULL)
end

function getBufferName(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    len = Ref{Csize_t}(0)
    ptr = clang_SourceManager_getBufferName(src_mgr, loc, len, C_NULL)
    return ptr == C_NULL ? "" : unsafe_string(ptr, len[])
end

function getFileCharacteristic(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    return clang_SourceManager_getFileCharacteristic(src_mgr, loc)
end

"""
    getPresumedLoc(src_mgr::SourceManager, loc::SourceLocation; use_line_directives::Bool=true) -> Union{Tuple{String,UInt32,UInt32,SourceLocation},Nothing}
Return the presumed `(filename, line, column, include_loc)` for `loc`, or `nothing` when
the presumed location cannot be computed.
"""
function getPresumedLoc(src_mgr::SourceManager, loc::SourceLocation;
                        use_line_directives::Bool=true)
    @check_ptrs src_mgr
    fname = Ref{Ptr{Cchar}}(C_NULL)
    line = Ref{Cuint}(0)
    col = Ref{Cuint}(0)
    iloc = Ref{CXSourceLocation_}(C_NULL)
    ok = clang_SourceManager_getPresumedLoc(src_mgr, loc, use_line_directives, fname, line,
                                            col, iloc)
    ok || return nothing
    return unsafe_string(fname[]), line[], col[], SourceLocation(iloc[])
end

function isInMainFile(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    return clang_SourceManager_isInMainFile(src_mgr, loc)
end

function isWrittenInSameFile(src_mgr::SourceManager, loc1::SourceLocation,
                             loc2::SourceLocation)
    @check_ptrs src_mgr
    return clang_SourceManager_isWrittenInSameFile(src_mgr, loc1, loc2)
end

function isWrittenInMainFile(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    return clang_SourceManager_isWrittenInMainFile(src_mgr, loc)
end

function isWrittenInBuiltinFile(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    return clang_SourceManager_isWrittenInBuiltinFile(src_mgr, loc)
end

function isWrittenInCommandLineFile(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    return clang_SourceManager_isWrittenInCommandLineFile(src_mgr, loc)
end

function isWrittenInScratchSpace(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    return clang_SourceManager_isWrittenInScratchSpace(src_mgr, loc)
end

function isInSystemHeader(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    return clang_SourceManager_isInSystemHeader(src_mgr, loc)
end

function isInExternCSystemHeader(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    return clang_SourceManager_isInExternCSystemHeader(src_mgr, loc)
end

function isInSystemMacro(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    return clang_SourceManager_isInSystemMacro(src_mgr, loc)
end

function getFileIDSize(src_mgr::SourceManager, id::FileID)
    @check_ptrs src_mgr id
    return clang_SourceManager_getFileIDSize(src_mgr, id)
end

"""
    isInFileID(src_mgr::SourceManager, loc::SourceLocation, id::FileID) -> (Bool, UInt32)
Test whether `loc` is inside the chunk of `id`; the second element is the offset of `loc`
from the beginning of `id` (only meaningful when the predicate is `true`).
"""
function isInFileID(src_mgr::SourceManager, loc::SourceLocation, id::FileID)
    @check_ptrs src_mgr id
    offset = Ref{Cuint}(0)
    ret = clang_SourceManager_isInFileID(src_mgr, loc, id, offset)
    return ret, offset[]
end

function translateFileLineCol(src_mgr::SourceManager, entry::FileEntry, line::Integer,
                              col::Integer)
    @check_ptrs src_mgr entry
    return SourceLocation(clang_SourceManager_translateFileLineCol(src_mgr, entry, line,
                                                                   col))
end

"""
    translateFile(src_mgr::SourceManager, entry::FileEntry) -> FileID
Return the `FileID` for the given file (the first inclusion when included multiple times).

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function translateFile(src_mgr::SourceManager, entry::FileEntry)
    @check_ptrs src_mgr entry
    return FileID(clang_SourceManager_translateFile(src_mgr, entry))
end

function translateLineCol(src_mgr::SourceManager, id::FileID, line::Integer, col::Integer)
    @check_ptrs src_mgr id
    return SourceLocation(clang_SourceManager_translateLineCol(src_mgr, id, line, col))
end

function getMacroArgExpandedLocation(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    return SourceLocation(clang_SourceManager_getMacroArgExpandedLocation(src_mgr, loc))
end

function isBeforeInTranslationUnit(src_mgr::SourceManager, lhs::SourceLocation,
                                   rhs::SourceLocation)
    @check_ptrs src_mgr
    return clang_SourceManager_isBeforeInTranslationUnit(src_mgr, lhs, rhs)
end

function isBeforeInSLocAddrSpace(src_mgr::SourceManager, lhs::SourceLocation,
                                 rhs::SourceLocation)
    @check_ptrs src_mgr
    return clang_SourceManager_isBeforeInSLocAddrSpace(src_mgr, lhs, rhs)
end

function isPointWithin(src_mgr::SourceManager, loc::SourceLocation, b::SourceLocation,
                       e::SourceLocation)
    @check_ptrs src_mgr
    return clang_SourceManager_isPointWithin(src_mgr, loc, b, e)
end

function getImmediateMacroCallerLoc(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    return SourceLocation(clang_SourceManager_getImmediateMacroCallerLoc(src_mgr, loc))
end

function getTopMacroCallerLoc(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    return SourceLocation(clang_SourceManager_getTopMacroCallerLoc(src_mgr, loc))
end


function userFilesAreVolatile(src_mgr::SourceManager)
    @check_ptrs src_mgr
    return clang_SourceManager_userFilesAreVolatile(src_mgr)
end

"""
    getPreambleFileID(src_mgr::SourceManager) -> FileID
Return the `FileID` of the precompiled preamble. The returned ID is invalid (its hash value
is 0) when no preamble was set.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function getPreambleFileID(src_mgr::SourceManager)
    @check_ptrs src_mgr
    return FileID(clang_SourceManager_getPreambleFileID(src_mgr))
end

"""
    getNonBuiltinFilenameForID(src_mgr::SourceManager, id::FileID) -> Union{String,Nothing}
Return the filename backing `id`, or `nothing` for non-files and built-in buffers.
"""
function getNonBuiltinFilenameForID(src_mgr::SourceManager, id::FileID)
    @check_ptrs src_mgr id
    len = Ref{Csize_t}(0)
    ptr = clang_SourceManager_getNonBuiltinFilenameForID(src_mgr, id, len)
    return ptr == C_NULL ? nothing : unsafe_string(ptr, len[])
end

"""
    getBufferDataOrNone(src_mgr::SourceManager, id::FileID) -> Union{String,Nothing}
Return the source buffer contents for `id`, or `nothing` when the buffer is invalid.
"""
function getBufferDataOrNone(src_mgr::SourceManager, id::FileID)
    @check_ptrs src_mgr id
    len = Ref{Csize_t}(0)
    ptr = clang_SourceManager_getBufferDataOrNone(src_mgr, id, len)
    return ptr == C_NULL ? nothing : unsafe_string(ptr, len[])
end

"""
    getLineTableFilenameID(src_mgr::SourceManager, name::AbstractString) -> UInt32
Return the uniqued line-table ID for `name`, materialising the line table on first use.
"""
function getLineTableFilenameID(src_mgr::SourceManager, name::AbstractString)
    @check_ptrs src_mgr
    return clang_SourceManager_getLineTableFilenameID(src_mgr, name)
end

function hasLineTable(src_mgr::SourceManager)
    @check_ptrs src_mgr
    return clang_SourceManager_hasLineTable(src_mgr)
end

function getContentCacheSize(src_mgr::SourceManager)
    @check_ptrs src_mgr
    return clang_SourceManager_getContentCacheSize(src_mgr)
end

function hasFileInfo(src_mgr::SourceManager, entry::FileEntry)
    @check_ptrs src_mgr entry
    return clang_SourceManager_hasFileInfo(src_mgr, entry)
end

function local_sloc_entry_size(src_mgr::SourceManager)
    @check_ptrs src_mgr
    return clang_SourceManager_local_sloc_entry_size(src_mgr)
end

function loaded_sloc_entry_size(src_mgr::SourceManager)
    @check_ptrs src_mgr
    return clang_SourceManager_loaded_sloc_entry_size(src_mgr)
end

function getNextLocalOffset(src_mgr::SourceManager)
    @check_ptrs src_mgr
    return clang_SourceManager_getNextLocalOffset(src_mgr)
end

"""
    isLoadedSourceLocation(src_mgr::SourceManager, loc::SourceLocation) -> Bool
Return `true` iff `loc` came from a PCH/module.
"""
function isLoadedSourceLocation(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    return clang_SourceManager_isLoadedSourceLocation(src_mgr, loc)
end

"""
    isLocalSourceLocation(src_mgr::SourceManager, loc::SourceLocation) -> Bool
Return `true` iff `loc` did not come from a PCH/module.
"""
function isLocalSourceLocation(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    return clang_SourceManager_isLocalSourceLocation(src_mgr, loc)
end


# SourceManager: the SLocEntry table

"""
    getLocalSLocEntry(src_mgr::SourceManager, index::Integer) -> SLocEntry
Return the local `SLocEntry` at the 0-based `index`; `index` must be less than
[`local_sloc_entry_size`](@ref).

The returned carrier borrows an interior pointer into the source manager's local SLocEntry
table. Creating a new `FileID` can reallocate that table and dangle the pointer, so re-fetch
rather than caching.
"""
function getLocalSLocEntry(src_mgr::SourceManager, index::Integer)
    @check_ptrs src_mgr
    @assert 0 <= index < local_sloc_entry_size(src_mgr) "SLocEntry index out of range"
    return SLocEntry(clang_SourceManager_getLocalSLocEntry(src_mgr, index))
end

"""
    getSLocEntry(src_mgr::SourceManager, id::FileID) -> (SLocEntry, Bool)
Return the `SLocEntry` for `id` and whether the lookup was invalid. The flag is `true` for
the invalid/sentinel `FileID`, in which case local entry 0 is returned instead.

The entry is borrowed with the same lifetime as [`getLocalSLocEntry`](@ref).
"""
function getSLocEntry(src_mgr::SourceManager, id::FileID)
    @check_ptrs src_mgr id
    invalid = Ref{Bool}(false)
    e = clang_SourceManager_getSLocEntry(src_mgr, id, invalid)
    return SLocEntry(e), invalid[]
end

"""
    isLoadedFileID(src_mgr::SourceManager, id::FileID) -> Bool
Return `true` iff `id` came from a PCH/module. `id` must not be the sentinel `FileID` —
Clang asserts it and the C shim does not check.
"""
function isLoadedFileID(src_mgr::SourceManager, id::FileID)
    @check_ptrs src_mgr id
    @assert getHashValue(id) != typemax(UInt32) "FileID must not be the sentinel value"
    return clang_SourceManager_isLoadedFileID(src_mgr, id)
end

"""
    isLocalFileID(src_mgr::SourceManager, id::FileID) -> Bool
Return `true` iff `id` did not come from a PCH/module. `id` must not be the sentinel
`FileID` — Clang asserts it and the C shim does not check.
"""
function isLocalFileID(src_mgr::SourceManager, id::FileID)
    @check_ptrs src_mgr id
    @assert getHashValue(id) != typemax(UInt32) "FileID must not be the sentinel value"
    return clang_SourceManager_isLocalFileID(src_mgr, id)
end

# SrcMgr::FileInfo

"""
    getIncludeLoc(x::AbstractFileInfo) -> SourceLocation
Return the location of the `#include` that brought in this file; invalid for the main file.
"""
function getIncludeLoc(x::AbstractFileInfo)
    @check_ptrs x
    return SourceLocation(clang_FileInfo_getIncludeLoc(x))
end

"""
    getFileCharacteristic(x::AbstractFileInfo) -> CXCharacteristicKind
Return whether this file is a user header, a system header, and so on.
"""
function getFileCharacteristic(x::AbstractFileInfo)
    @check_ptrs x
    return clang_FileInfo_getFileCharacteristic(x)
end

"""
    hasLineDirectives(x::AbstractFileInfo) -> Bool
Return `true` iff this FileID has `#line` directives in it.
"""
function hasLineDirectives(x::AbstractFileInfo)
    @check_ptrs x
    return clang_FileInfo_hasLineDirectives(x)
end

"""
    getName(x::AbstractFileInfo) -> String
Return the name the file was loaded under from the underlying file system.
"""
function getName(x::AbstractFileInfo)
    @check_ptrs x
    len = Ref{Csize_t}(0)
    ptr = clang_FileInfo_getName(x, len)
    return ptr == C_NULL ? "" : unsafe_string(ptr, len[])
end

# SrcMgr::ExpansionInfo

"""
    getSpellingLoc(x::AbstractExpansionInfo) -> SourceLocation
Return where the character data for the token came from, falling back to the expansion
start when the spelling location is invalid.
"""
function getSpellingLoc(x::AbstractExpansionInfo)
    @check_ptrs x
    return SourceLocation(clang_ExpansionInfo_getSpellingLoc(x))
end

"""
    getExpansionLocStart(x::AbstractExpansionInfo) -> SourceLocation
Return the start of the expansion range.
"""
function getExpansionLocStart(x::AbstractExpansionInfo)
    @check_ptrs x
    return SourceLocation(clang_ExpansionInfo_getExpansionLocStart(x))
end

"""
    getExpansionLocEnd(x::AbstractExpansionInfo) -> SourceLocation
Return the end of the expansion range, falling back to the start for a macro-argument
expansion (whose recorded end is invalid).
"""
function getExpansionLocEnd(x::AbstractExpansionInfo)
    @check_ptrs x
    return SourceLocation(clang_ExpansionInfo_getExpansionLocEnd(x))
end

"""
    isExpansionTokenRange(x::AbstractExpansionInfo) -> Bool
Return `true` iff the expansion range is a token range rather than a character range.
"""
function isExpansionTokenRange(x::AbstractExpansionInfo)
    @check_ptrs x
    return clang_ExpansionInfo_isExpansionTokenRange(x)
end

"""
    isMacroArgExpansion(x::AbstractExpansionInfo) -> Bool
Return `true` iff this entry expands a macro argument into a function-like macro's body.
"""
function isMacroArgExpansion(x::AbstractExpansionInfo)
    @check_ptrs x
    return clang_ExpansionInfo_isMacroArgExpansion(x)
end

"""
    isMacroBodyExpansion(x::AbstractExpansionInfo) -> Bool
Return `true` iff this entry expands a macro body.
"""
function isMacroBodyExpansion(x::AbstractExpansionInfo)
    @check_ptrs x
    return clang_ExpansionInfo_isMacroBodyExpansion(x)
end

"""
    isFunctionMacroExpansion(x::AbstractExpansionInfo) -> Bool
Return `true` iff this entry expands a function-like macro.
"""
function isFunctionMacroExpansion(x::AbstractExpansionInfo)
    @check_ptrs x
    return clang_ExpansionInfo_isFunctionMacroExpansion(x)
end

# SrcMgr::SLocEntry

"""
    getOffset(x::AbstractSLocEntry) -> UInt32
Return this entry's offset in the source-location address space.
"""
function getOffset(x::AbstractSLocEntry)
    @check_ptrs x
    return clang_SLocEntry_getOffset(x)
end

"""
    isExpansion(x::AbstractSLocEntry) -> Bool
Return `true` iff this entry carries an `ExpansionInfo`.
"""
function isExpansion(x::AbstractSLocEntry)
    @check_ptrs x
    return clang_SLocEntry_isExpansion(x)
end

"""
    isFile(x::AbstractSLocEntry) -> Bool
Return `true` iff this entry carries a `FileInfo`.
"""
function isFile(x::AbstractSLocEntry)
    @check_ptrs x
    return clang_SLocEntry_isFile(x)
end

"""
    getFile(x::AbstractSLocEntry) -> FileInfo
Return the file payload. `isFile(x)` must hold — Clang asserts it and the C shim does not
check. The result borrows an interior pointer into `x`.
"""
function getFile(x::AbstractSLocEntry)
    @check_ptrs x
    @assert isFile(x) "SLocEntry must be a file entry"
    return FileInfo(clang_SLocEntry_getFile(x))
end

"""
    getExpansion(x::AbstractSLocEntry) -> ExpansionInfo
Return the macro-expansion payload. `isExpansion(x)` must hold — Clang asserts it and the C
shim does not check. The result borrows an interior pointer into `x`.
"""
function getExpansion(x::AbstractSLocEntry)
    @check_ptrs x
    @assert isExpansion(x) "SLocEntry must be a macro-expansion entry"
    return ExpansionInfo(clang_SLocEntry_getExpansion(x))
end
