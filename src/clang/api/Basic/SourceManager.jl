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


# SourceManager: configuration, sizes and the loaded SLocEntry table

"""
    setOverridenFilesKeepOriginalName(src_mgr::SourceManager, value::Bool)
Set whether the source manager reports the original file name for the contents of files
that were overridden by another file. Defaults to `true`.
"""
function setOverridenFilesKeepOriginalName(src_mgr::SourceManager, value::Bool)
    @check_ptrs src_mgr
    return clang_SourceManager_setOverridenFilesKeepOriginalName(src_mgr, value)
end

"""
    setPreambleFileID(src_mgr::SourceManager, id::FileID)
Set the `FileID` of the precompiled preamble. The preamble must not have been set already —
Clang asserts it and the C shim does not check, so the precondition is restated here.
"""
function setPreambleFileID(src_mgr::SourceManager, id::FileID)
    @check_ptrs src_mgr id
    current = getPreambleFileID(src_mgr)
    already_set = isValid(current)
    dispose(current)
    @assert !already_set "the preamble FileID has already been set"
    return clang_SourceManager_setPreambleFileID(src_mgr, id)
end

"""
    getFileEntryForSLocEntry(src_mgr::SourceManager, e::AbstractSLocEntry) -> Union{FileEntry,Nothing}
Return the borrowed `FileEntry` recorded in `e`'s content cache, or `nothing` when there is
none (e.g. the entry was created from a memory buffer). `isFile(e)` must hold — Clang
asserts it and the C shim does not check.
"""
function getFileEntryForSLocEntry(src_mgr::SourceManager, e::AbstractSLocEntry)
    @check_ptrs src_mgr e
    @assert isFile(e) "SLocEntry must be a file entry"
    ptr = clang_SourceManager_getFileEntryForSLocEntry(src_mgr, e)
    return ptr == C_NULL ? nothing : FileEntry(ptr)
end

"""
    getBufferDataIfLoaded(src_mgr::SourceManager, id::FileID) -> Union{String,Nothing}
Return the source buffer contents for `id`, or `nothing` when that buffer has not been
loaded yet.
"""
function getBufferDataIfLoaded(src_mgr::SourceManager, id::FileID)
    @check_ptrs src_mgr id
    len = Ref{Csize_t}(0)
    ptr = clang_SourceManager_getBufferDataIfLoaded(src_mgr, id, len)
    return ptr == C_NULL ? nothing : unsafe_string(ptr, len[])
end

"""
    setNumCreatedFIDsForFileID(src_mgr::SourceManager, id::FileID, num::Integer, force::Bool=false)
Record how many `FileID`s (files and macros) were created while preprocessing `id`,
including `id` itself. Unless `force` is set the slot must still be zero — Clang asserts it
and the C shim does not check.
"""
function setNumCreatedFIDsForFileID(src_mgr::SourceManager, id::FileID, num::Integer, force::Bool=false)
    @check_ptrs src_mgr id
    @assert force || getNumCreatedFIDsForFileID(src_mgr, id) == 0 "the FileID count is already set"
    return clang_SourceManager_setNumCreatedFIDsForFileID(src_mgr, id, num, force)
end

"""
    isInSameSLocAddrSpace(src_mgr::SourceManager, lhs::SourceLocation, rhs::SourceLocation) -> (Bool, Int32)
Return whether `lhs` and `rhs` both live in the local source-location address space or both
in the loaded one, together with the offset of `rhs` relative to `lhs`. The offset is only
written when the predicate holds, and reads back as `0` otherwise.
"""
function isInSameSLocAddrSpace(src_mgr::SourceManager, lhs::SourceLocation, rhs::SourceLocation)
    @check_ptrs src_mgr
    offset = Ref{Int32}(0)
    same = clang_SourceManager_isInSameSLocAddrSpace(src_mgr, lhs, rhs, offset)
    return same, offset[]
end

"""
    getMemoryBufferSizes(src_mgr::SourceManager) -> (Csize_t, Csize_t)
Return the memory used by the source manager's memory buffers, split into heap-backed bytes
and mmap'ed bytes.
"""
function getMemoryBufferSizes(src_mgr::SourceManager)
    @check_ptrs src_mgr
    malloc_bytes = Ref{Csize_t}(0)
    mmap_bytes = Ref{Csize_t}(0)
    clang_SourceManager_getMemoryBufferSizes(src_mgr, malloc_bytes, mmap_bytes)
    return malloc_bytes[], mmap_bytes[]
end

"""
    getDataStructureSizes(src_mgr::SourceManager) -> Csize_t
Return the memory used by the source manager's side tables and data structures.
"""
function getDataStructureSizes(src_mgr::SourceManager)
    @check_ptrs src_mgr
    return clang_SourceManager_getDataStructureSizes(src_mgr)
end

"""
    getLoadedSLocEntry(src_mgr::SourceManager, index::Integer) -> (SLocEntry, Bool)
Return the loaded `SLocEntry` at the 0-based `index` and whether loading it failed; `index`
must be less than [`loaded_sloc_entry_size`](@ref).

The returned carrier borrows an interior pointer with the same lifetime as
[`getLocalSLocEntry`](@ref).
"""
function getLoadedSLocEntry(src_mgr::SourceManager, index::Integer)
    @check_ptrs src_mgr
    @assert 0 <= index < loaded_sloc_entry_size(src_mgr) "SLocEntry index out of range"
    invalid = Ref{Bool}(false)
    e = clang_SourceManager_getLoadedSLocEntry(src_mgr, index, invalid)
    return SLocEntry(e), invalid[]
end

"""
    getContentCache(x::AbstractFileInfo) -> ContentCache
Return the content cache backing this file. The result borrows an interior pointer owned by
the source manager's content-cache allocator.
"""
function getContentCache(x::AbstractFileInfo)
    @check_ptrs x
    return ContentCache(clang_FileInfo_getContentCache(x))
end

# SrcMgr::ContentCache

"""
    getSize(x::AbstractContentCache) -> UInt32
Return the size of the content this cache encapsulates — either the source file's size or
the size of a scratch buffer. [`isBufferLoaded`](@ref) must hold: without a loaded buffer
Clang reads through a disengaged `OptionalFileEntryRef`, and the C shim does not check.
"""
function getSize(x::AbstractContentCache)
    @check_ptrs x
    @assert isBufferLoaded(x) "the content cache's memory buffer must be loaded"
    return clang_ContentCache_getSize(x)
end

"""
    getSizeBytesMapped(x::AbstractContentCache) -> UInt32
Return how many bytes are actually mapped for this cache; `0` when the memory buffer was
never expanded.
"""
function getSizeBytesMapped(x::AbstractContentCache)
    @check_ptrs x
    return clang_ContentCache_getSizeBytesMapped(x)
end

"""
    getMemoryBufferKind(x::AbstractContentCache) -> CXBufferKind
Return whether the memory buffer backing this cache is heap-allocated or mmap'ed.
[`isBufferLoaded`](@ref) must hold — Clang asserts it and the C shim does not check.
"""
function getMemoryBufferKind(x::AbstractContentCache)
    @check_ptrs x
    @assert isBufferLoaded(x) "the content cache's memory buffer must be loaded"
    return clang_ContentCache_getMemoryBufferKind(x)
end

"""
    isBufferLoaded(x::AbstractContentCache) -> Bool
Return `true` iff this cache's memory buffer has already been loaded. This is the gate for
[`getSize`](@ref) and [`getMemoryBufferKind`](@ref), both of which read the buffer
unconditionally.
"""
function isBufferLoaded(x::AbstractContentCache)
    @check_ptrs x
    return clang_ContentCache_isBufferLoaded(x)
end

"""
    getBufferDataIfLoaded(x::AbstractContentCache) -> Union{String,Nothing}
Return this cache's source buffer contents, or `nothing` when the buffer has not been
loaded yet.
"""
function getBufferDataIfLoaded(x::AbstractContentCache)
    @check_ptrs x
    len = Ref{Csize_t}(0)
    ptr = clang_ContentCache_getBufferDataIfLoaded(x, len)
    return ptr == C_NULL ? nothing : unsafe_string(ptr, len[])
end

"""
    getInvalidBOM(str::AbstractString) -> Union{String,Nothing}
Return the name of the byte order mark `str` starts with when Clang cannot handle it (only
UTF-8, with or without a BOM, is supported), and `nothing` otherwise.
"""
function getInvalidBOM(str::AbstractString)
    s = String(str)
    ptr = clang_ContentCache_getInvalidBOM(s, ncodeunits(s))
    return ptr == C_NULL ? nothing : unsafe_string(ptr)
end


# SourceManager: the whole-manager dump, ID tables and the module build stack

"""
    dump(src_mgr::SourceManager) -> Nothing
Print the source manager's whole SLocEntry table to `stderr`.
"""
function dump(src_mgr::SourceManager)
    @check_ptrs src_mgr
    return clang_SourceManager_dump(src_mgr)
end

"""
    clearIDTables(src_mgr::SourceManager) -> Nothing
Drop every `FileID` and SLocEntry the manager has handed out and restart its source location
address space.

Every `SourceLocation`, `FileID`, `SLocEntry`, `FileInfo` and `ExpansionInfo` obtained from
`src_mgr` before the call is stale afterwards, so this is only safe on a manager whose
results no AST refers to yet.
"""
function clearIDTables(src_mgr::SourceManager)
    @check_ptrs src_mgr
    return clang_SourceManager_clearIDTables(src_mgr)
end

"""
    getModuleBuildStackSize(src_mgr::SourceManager) -> UInt32
Return how many entries the module build stack holds.
"""
function getModuleBuildStackSize(src_mgr::SourceManager)
    @check_ptrs src_mgr
    return clang_SourceManager_getModuleBuildStackSize(src_mgr)
end

"""
    getModuleBuildStackEntry(src_mgr::SourceManager, index::Integer) -> (String, SourceLocation)
Return the module name and import location of the 0-based `index`th module build stack
entry; `index` must be less than [`getModuleBuildStackSize`](@ref).

The name is copied out, but the entry itself is invalidated by any later push.
"""
function getModuleBuildStackEntry(src_mgr::SourceManager, index::Integer)
    @check_ptrs src_mgr
    @assert 0 <= index < getModuleBuildStackSize(src_mgr) "module build stack index out of range"
    len = Ref{Csize_t}(0)
    loc = Ref{CXSourceLocation_}(C_NULL)
    ptr = clang_SourceManager_getModuleBuildStackEntry(src_mgr, index, len, loc)
    return unsafe_string(ptr, len[]), SourceLocation(loc[])
end

"""
    getModuleBuildStack(src_mgr::SourceManager) -> Vector{Tuple{String,SourceLocation}}
Return the whole module build stack — the chain of modules currently being built, innermost
last — as `(module name, import location)` pairs.
"""
function getModuleBuildStack(src_mgr::SourceManager)
    n = Int(getModuleBuildStackSize(src_mgr))
    return [getModuleBuildStackEntry(src_mgr, i) for i = 0:(n - 1)]
end

"""
    pushModuleBuildStack(src_mgr::SourceManager, name::AbstractString, import_loc::SourceLocation) -> Nothing
Push `name` onto the module build stack, recording `import_loc` as the location that
triggered the build. Clang stores it as a `clang::FullSourceLoc`, which the C shim builds by
pairing `import_loc` with `src_mgr` itself.
"""
function pushModuleBuildStack(src_mgr::SourceManager, name::AbstractString,
                              import_loc::SourceLocation)
    @check_ptrs src_mgr
    return clang_SourceManager_pushModuleBuildStack(src_mgr, name, import_loc)
end

# SourceManager: synthetic expansion locations and never-failing buffers

"""
    createMacroArgExpansionLoc(src_mgr::SourceManager, spelling_loc::SourceLocation, expansion_loc::SourceLocation, len::Integer) -> SourceLocation
Create the SLocEntry for substituting a macro argument into a function-like macro's body and
return the start of the expansion. The argument was written at `spelling_loc` and spans
`len` bytes; `expansion_loc` is the parameter name inside the expanded macro body.

This grows the manager's SLocEntry table, so every borrowed `SLocEntry`, `FileInfo` and
`ExpansionInfo` fetched before the call dangles afterwards — re-fetch instead of caching.
"""
function createMacroArgExpansionLoc(src_mgr::SourceManager, spelling_loc::SourceLocation,
                                    expansion_loc::SourceLocation, len::Integer)
    @check_ptrs src_mgr
    loc = clang_SourceManager_createMacroArgExpansionLoc(src_mgr, spelling_loc,
                                                         expansion_loc, len)
    return SourceLocation(loc)
end

"""
    createTokenSplitLoc(src_mgr::SourceManager, spelling_loc::SourceLocation, token_start::SourceLocation, token_end::SourceLocation) -> SourceLocation
Create a `SourceLocation` recording that the token starting at `token_start` ends
prematurely at `token_end`, spelled at `spelling_loc`.

`clang::SourceManager::createTokenSplitLoc` asserts that `token_start` and `token_end` are
written in the same file; the precondition is restated here. Like
[`createMacroArgExpansionLoc`](@ref) this grows the SLocEntry table and dangles every
borrowed entry fetched earlier.
"""
function createTokenSplitLoc(src_mgr::SourceManager, spelling_loc::SourceLocation,
                             token_start::SourceLocation, token_end::SourceLocation)
    @check_ptrs src_mgr
    @assert isWrittenInSameFile(src_mgr, token_start, token_end) "a split token's start and end must be in one file"
    loc = clang_SourceManager_createTokenSplitLoc(src_mgr, spelling_loc, token_start,
                                                  token_end)
    return SourceLocation(loc)
end

"""
    getMemoryBufferDataForFileOrNone(src_mgr::SourceManager, ref::FileEntryRef) -> Union{String,Nothing}
Return the contents of the memory buffer associated with `ref`, or `nothing` when the file
has no valid buffer.
"""
function getMemoryBufferDataForFileOrNone(src_mgr::SourceManager, ref::FileEntryRef)
    @check_ptrs src_mgr ref
    len = Ref{Csize_t}(0)
    ptr = clang_SourceManager_getMemoryBufferDataForFileOrNone(src_mgr, ref, len)
    return ptr == C_NULL ? nothing : unsafe_string(ptr, len[])
end

"""
    getMemoryBufferDataForFileOrFake(src_mgr::SourceManager, ref::FileEntryRef) -> String
Return the contents of the memory buffer associated with `ref`, falling back to Clang's fake
recovery buffer when the file has no valid one.
"""
function getMemoryBufferDataForFileOrFake(src_mgr::SourceManager, ref::FileEntryRef)
    @check_ptrs src_mgr ref
    len = Ref{Csize_t}(0)
    ptr = clang_SourceManager_getMemoryBufferDataForFileOrFake(src_mgr, ref, len)
    return unsafe_string(ptr, len[])
end

"""
    getBufferDataOrFake(src_mgr::SourceManager, id::FileID, loc::SourceLocation=SourceLocation()) -> String
Return the source buffer contents for `id`, falling back to Clang's fake recovery buffer
when the buffer is invalid. `loc` is where a "cannot open file" diagnostic is reported.
"""
function getBufferDataOrFake(src_mgr::SourceManager, id::FileID,
                             loc::SourceLocation=SourceLocation())
    @check_ptrs src_mgr id
    len = Ref{Csize_t}(0)
    ptr = clang_SourceManager_getBufferDataOrFake(src_mgr, id, loc, len)
    return unsafe_string(ptr, len[])
end

"""
    getModuleImportLoc(src_mgr::SourceManager, loc::SourceLocation) -> (SourceLocation, String)
Return the import location and name of the module `loc` lives in. The location is invalid
and the name empty when `loc` belongs to the current translation unit rather than to a
loaded module.
"""
function getModuleImportLoc(src_mgr::SourceManager, loc::SourceLocation)
    @check_ptrs src_mgr
    name = Ref{Ptr{Cchar}}(C_NULL)
    len = Ref{Csize_t}(0)
    l = clang_SourceManager_getModuleImportLoc(src_mgr, loc, name, len)
    return SourceLocation(l), name[] == C_NULL ? "" : unsafe_string(name[], len[])
end

"""
    isInSLocAddrSpace(src_mgr::SourceManager, loc::SourceLocation, start::SourceLocation, len::Integer) -> (Bool, UInt32)
Test whether `loc` lies inside the `len`-byte chunk of the source location address space
beginning at `start`; the second element is `loc`'s offset within the chunk and is
meaningful only when the predicate is `true`.

Clang asserts that `[start, start + len)` is a valid chunk of one half of the address space,
so pass a `start` obtained from this manager together with a `len` that does not run past
the end of its file — [`getFileIDSize`](@ref) is the usual source of both.
"""
function isInSLocAddrSpace(src_mgr::SourceManager, loc::SourceLocation,
                           start::SourceLocation, len::Integer)
    @check_ptrs src_mgr
    offset = Ref{UInt32}(0)
    inside = clang_SourceManager_isInSLocAddrSpace(src_mgr, loc, start, len, offset)
    return inside, offset[]
end

"""
    AddLineNote(src_mgr::SourceManager, loc::SourceLocation, line::Integer, filename_id::Integer, is_file_entry::Bool, is_file_exit::Bool, kind::CXCharacteristicKind=CXCharacteristicKind_C_User) -> Nothing
Record a `#line`/GNU-line-marker note in the line table for the file and offset `loc`
designates. `filename_id` comes from [`getLineTableFilenameID`](@ref), or is `-1` for
"unspecified".

Clang asserts that notes are added to one file in strictly increasing offset order, and the
call also flips that file's `hasLineDirectives` flag, so every later presumed location in it
is resolved through the line table.
"""
function AddLineNote(src_mgr::SourceManager, loc::SourceLocation, line::Integer,
                     filename_id::Integer, is_file_entry::Bool, is_file_exit::Bool,
                     kind::CXCharacteristicKind=CXCharacteristicKind_C_User)
    @check_ptrs src_mgr
    return clang_SourceManager_AddLineNote(src_mgr, loc, line, filename_id, is_file_entry,
                                           is_file_exit, kind)
end

# SrcMgr::ContentCache, SrcMgr::FileInfo and SrcMgr::ExpansionInfo tails

"""
    getBufferDataOrNone(x::AbstractContentCache, diag::DiagnosticsEngine, file_mgr::FileManager, loc::SourceLocation=SourceLocation()) -> Union{String,Nothing}
Return this cache's source buffer contents, or `nothing` when the buffer is invalid. A read
error is reported through `diag` at `loc`.

Unlike [`getBufferDataIfLoaded`](@ref) this forces the buffer to be loaded, so it is also
what makes [`isBufferLoaded`](@ref) start returning `true`.
"""
function getBufferDataOrNone(x::AbstractContentCache, diag::DiagnosticsEngine,
                             file_mgr::FileManager, loc::SourceLocation=SourceLocation())
    @check_ptrs x diag file_mgr
    len = Ref{Csize_t}(0)
    ptr = clang_ContentCache_getBufferDataOrNone(x, diag, file_mgr, loc, len)
    return ptr == C_NULL ? nothing : unsafe_string(ptr, len[])
end

"""
    setHasLineDirectives(x::AbstractFileInfo) -> Nothing
Mark this file as containing `#line` directives, which is what makes presumed locations in
it be resolved through the source manager's line table. The flag is one-way — Clang offers
no way to clear it — and [`AddLineNote`](@ref) sets it as a side effect.
"""
function setHasLineDirectives(x::AbstractFileInfo)
    @check_ptrs x
    return clang_FileInfo_setHasLineDirectives(x)
end

"""
    getExpansionLocRange(x::AbstractExpansionInfo) -> (SourceRange, Bool)
Return the expansion's `[start, end]` range and whether it is a token range, i.e. whether
its end designates the start of the last token rather than the last character.
"""
function getExpansionLocRange(x::AbstractExpansionInfo)
    @check_ptrs x
    is_token = Ref{Bool}(false)
    r = clang_ExpansionInfo_getExpansionLocRange(x, is_token)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E)), is_token[]
end


"""
    createExpansionLoc(src_mgr::SourceManager, spelling_loc::SourceLocation,
                       expansion_start::SourceLocation, expansion_end::SourceLocation,
                       len::Integer; is_token_range::Bool=true, loaded_id::Integer=0,
                       loaded_offset::Integer=0) -> SourceLocation
Create the `SLocEntry` for one macro use and return the start of its expansion. The macro
body begins at `spelling_loc` and runs for `len` bytes; the use spans
`[expansion_start, expansion_end]`.

`is_token_range` says whether `expansion_end` designates the start of the last token rather
than its last character. `loaded_id`/`loaded_offset` place the entry in the loaded half of
the source-location address space and are `0` for a locally created expansion.
"""
function createExpansionLoc(src_mgr::SourceManager, spelling_loc::SourceLocation,
                            expansion_start::SourceLocation, expansion_end::SourceLocation,
                            len::Integer; is_token_range::Bool=true, loaded_id::Integer=0,
                            loaded_offset::Integer=0)
    @check_ptrs src_mgr
    loc = clang_SourceManager_createExpansionLoc(src_mgr, spelling_loc, expansion_start,
                                                 expansion_end, len, is_token_range,
                                                 loaded_id, loaded_offset)
    return SourceLocation(loc)
end

"""
    isInTheSameTranslationUnit(src_mgr::SourceManager, lhs_id::FileID, lhs_offset::Integer,
                               rhs_id::FileID, rhs_offset::Integer) -> (Bool, Bool, UInt32, UInt32)
Decide whether two decomposed locations live in the same translation unit and, as a
byproduct, order them. The result is `(same_tu, lhs_before_rhs, lhs_offset, rhs_offset)`;
the ordering flag is meaningful only when `same_tu` is `true`.

Both decomposed locations are walked up to their common ancestor file, so `lhs_id` and
`rhs_id` are *mutated in place* to the file the walk ended in and the returned offsets are
the walked ones. The two `FileID` boxes stay caller-owned and are still released with
`dispose`.
"""
function isInTheSameTranslationUnit(src_mgr::SourceManager, lhs_id::FileID,
                                    lhs_offset::Integer, rhs_id::FileID,
                                    rhs_offset::Integer)
    @check_ptrs src_mgr lhs_id rhs_id
    loff = Ref{Cuint}(lhs_offset)
    roff = Ref{Cuint}(rhs_offset)
    before = Ref{Bool}(false)
    same = clang_SourceManager_isInTheSameTranslationUnit(src_mgr, lhs_id, loff, rhs_id,
                                                          roff, before)
    return same, before[], loff[], roff[]
end

"""
    isInTheSameTranslationUnitImpl(src_mgr::SourceManager, lhs_id::FileID, lhs_offset::Integer,
                                   rhs_id::FileID, rhs_offset::Integer) -> Bool
Return `true` iff the two decomposed locations live in the same translation unit, leaving
both of them untouched.
"""
function isInTheSameTranslationUnitImpl(src_mgr::SourceManager, lhs_id::FileID,
                                        lhs_offset::Integer, rhs_id::FileID,
                                        rhs_offset::Integer)
    @check_ptrs src_mgr lhs_id rhs_id
    return clang_SourceManager_isInTheSameTranslationUnitImpl(src_mgr, lhs_id, lhs_offset,
                                                              rhs_id, rhs_offset)
end


# SourceManager: replay, the fileinfo map and address-space notes

"""
    initializeForReplay(src_mgr::SourceManager, old::SourceManager) -> Nothing
Initialize `src_mgr` to replay the compilation `old` describes, inheriting `old`'s content
caches.

The inherited buffers are *unowned* views into `old`, so `old` must outlive `src_mgr` —
dispose `src_mgr` first. `src_mgr` must also still be fresh: replaying into a manager that
has already handed out its main file ID corrupts its address space, and that precondition is
asserted here.
"""
function initializeForReplay(src_mgr::SourceManager, old::SourceManager)
    @check_ptrs src_mgr old
    id = getMainFileID(src_mgr)
    fresh = isInvalid(id)
    dispose(id)
    @assert fresh "the replaying source manager must not have its main file ID set yet"
    return clang_SourceManager_initializeForReplay(src_mgr, old)
end

"""
    bypassFileContentsOverride(src_mgr::SourceManager, ref::FileEntryRef) -> Union{FileEntryRef,Nothing}
Return a fresh `FileEntryRef` for the on-disk contents of an overridden file, bypassing the
override, or `nothing` when the file cannot be found in the filesystem. Call it before
parsing begins.

Clang asserts that the file's contents were overridden; the precondition is restated here.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function bypassFileContentsOverride(src_mgr::SourceManager, ref::FileEntryRef)
    @check_ptrs src_mgr ref
    @assert isFileOverridden(src_mgr, getFileEntry(ref)) "the file's contents must have been overridden"
    ptr = clang_SourceManager_bypassFileContentsOverride(src_mgr, ref)
    return ptr == C_NULL ? nothing : FileEntryRef(ptr)
end

"""
    getNumFileInfos(src_mgr::SourceManager) -> UInt32
Return how many files the manager has built a content cache for.
"""
function getNumFileInfos(src_mgr::SourceManager)
    @check_ptrs src_mgr
    return clang_SourceManager_getNumFileInfos(src_mgr)
end

"""
    getFileInfos(src_mgr::SourceManager) -> Vector{Tuple{FileEntry,ContentCache}}
Return every `(file, content cache)` pair the manager holds.

Both halves are borrowed and die with the manager, and the underlying map is unordered — the
sequence is not stable and changes as files are added.
"""
function getFileInfos(src_mgr::SourceManager)
    @check_ptrs src_mgr
    n = clang_SourceManager_getNumFileInfos(src_mgr)
    files = Vector{CXFileEntry}(undef, n)
    caches = Vector{CXContentCache}(undef, n)
    n > 0 && clang_SourceManager_getFileInfos(src_mgr, files, caches)
    return [(FileEntry(files[i]), ContentCache(caches[i])) for i = 1:n]
end

"""
    noteSLocAddressSpaceUsage(src_mgr::SourceManager, diag::DiagnosticsEngine; max_notes::Union{Integer,Nothing}=32) -> Nothing
Report through `diag` how much of the source location address space each file occupies.
`max_notes` caps how many files are named; pass `nothing` to report every one of them.
"""
function noteSLocAddressSpaceUsage(src_mgr::SourceManager, diag::DiagnosticsEngine;
                                   max_notes::Union{Integer,Nothing}=32)
    @check_ptrs src_mgr diag
    has_max = max_notes !== nothing
    return clang_SourceManager_noteSLocAddressSpaceUsage(src_mgr, diag, has_max,
                                                         has_max ? max_notes : 0)
end

# LineOffsetMapping

"""
    LineOffsetMapping(content::AbstractString, name::AbstractString="") -> LineOffsetMapping
Compute the byte offset at which each physical line of `content` starts; `name` only labels
the buffer in diagnostics.

`content` is read during the call and need not outlive the mapping — the offsets are copied
into the mapping's own bump allocator.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function LineOffsetMapping(content::AbstractString, name::AbstractString="")
    text = String(content)
    m = clang_LineOffsetMapping_create(text, ncodeunits(text), String(name))
    @assert m != C_NULL "Failed to create LineOffsetMapping"
    return LineOffsetMapping(m)
end

dispose(x::LineOffsetMapping) = clang_LineOffsetMapping_dispose(x)

"""
    size(x::AbstractLineOffsetMapping) -> UInt32
Return how many physical lines the mapped buffer holds.
"""
function Base.size(x::AbstractLineOffsetMapping)
    @check_ptrs x
    return clang_LineOffsetMapping_size(x)
end

"""
    getLines(x::AbstractLineOffsetMapping) -> Vector{UInt32}
Return the byte offsets at which the buffer's physical lines start, copied out of the
mapping's own storage.
"""
function getLines(x::AbstractLineOffsetMapping)
    @check_ptrs x
    len = Ref{Csize_t}(0)
    ptr = clang_LineOffsetMapping_getLines(x, len)
    return ptr == C_NULL ? UInt32[] : copy(unsafe_wrap(Array, ptr, len[]))
end

# SourceManagerForFile

"""
    SourceManagerForFile(filename::AbstractString, content::AbstractString) -> SourceManagerForFile
Build a `SourceManager` over a single in-memory file, together with the `FileManager` and
`DiagnosticsEngine` it needs. All three belong to the returned object and die with it.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function SourceManagerForFile(filename::AbstractString, content::AbstractString)
    name = String(filename)
    text = String(content)
    smf = clang_SourceManagerForFile_create(name, ncodeunits(name), text, ncodeunits(text))
    @assert smf != C_NULL "Failed to create SourceManagerForFile"
    return SourceManagerForFile(smf)
end

dispose(x::SourceManagerForFile) = clang_SourceManagerForFile_dispose(x)

"""
    getSourceManager(x::AbstractSourceManagerForFile) -> SourceManager
Return the borrowed `SourceManager` `x` owns. It dies with `x`, so never `dispose` it.
"""
function getSourceManager(x::AbstractSourceManagerForFile)
    @check_ptrs x
    return SourceManager(clang_SourceManagerForFile_get(x))
end
