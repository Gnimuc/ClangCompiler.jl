# ASTUnit

"""
    ASTUnit(inv::CompilerInvocation, diag::DiagnosticsEngine; kwargs...) -> ASTUnit
Return an empty parse-based `ASTUnit` built by `clang::ASTUnit::create`. It carries a
file manager, a source manager and `diag`, but no preprocessor, AST context or `Sema`
until a parse runs.

`inv` is **adopted**: the unit rewraps it in a fresh `shared_ptr` and frees it, so calling
`dispose` on `inv` afterwards is a double free. `diag` stays the caller's — the shim pins
it with an explicit `Retain` (MARSHALLING.md §12) so the unit's release cannot delete it.

Keyword arguments mirror the C++ parameters: `capture_diagnostics` selects whether the
unit installs a capturing diagnostic consumer on `diag` (the default,
`CXCaptureDiagsKind_None`, leaves the engine untouched) and `user_files_are_volatile`
marks user files as volatile in the source manager.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function ASTUnit(inv::CompilerInvocation, diag::DiagnosticsEngine; capture_diagnostics::CXCaptureDiagsKind=CXCaptureDiagsKind_None, user_files_are_volatile::Bool=false)
    @check_ptrs inv diag
    unit = clang_ASTUnit_create(inv, diag, capture_diagnostics, user_files_are_volatile)
    @assert unit != C_NULL "Failed to create ASTUnit"
    return ASTUnit(unit)
end

"""
    LoadFromCompilerInvocation(inv::CompilerInvocation, diag::DiagnosticsEngine,
                               fm::FileManager; kwargs...) -> Union{ASTUnit,Nothing}
Run a whole frontend parse of the single input file `inv` names and return the resulting
`ASTUnit`, or `nothing` when the parse could not be set up (a missing input file, a target
that cannot be created, a fatal error before the AST exists). Unlike a unit from
[`ASTUnit`](@ref), the result carries a preprocessor, an AST context, a `Sema` and the
file's top-level declarations, and it outlives any `CompilerInstance`.

`inv` is **adopted** — on the success path *and* on the failure path, where the unit is
destroyed before this returns — so calling `dispose` on it afterwards is a double free.
`diag` and `fm` stay the caller's: the unit holds each in an `IntrusiveRefCntPtr` and the
shim pins both with an explicit `Retain` (MARSHALLING.md §12), so the unit's release cannot
delete them. Both must still outlive the unit, which points at them — `dispose` the unit
first.

`inv` must carry exactly one input, of source kind and not LLVM IR: Clang reads `Inputs[0]`
unconditionally and asserts on the rest, so an invocation built for no input file is out of
bounds rather than a `nothing` return. `createFromCommandLine` produces exactly one.

Keyword arguments mirror the C++ parameters. `precompile_preamble_after_n_parses` above `0`
builds a precompiled preamble, which writes temporary PCH files; leave it at `0`, as this
package wraps no `Reparse` for a preamble to serve.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function LoadFromCompilerInvocation(inv::CompilerInvocation, diag::DiagnosticsEngine, fm::FileManager; only_local_decls::Bool=false, capture_diagnostics::CXCaptureDiagsKind=CXCaptureDiagsKind_None, precompile_preamble_after_n_parses::Integer=0, tu_kind::CXTranslationUnitKind=CXTranslationUnitKind_TU_Complete, cache_code_completion_results::Bool=false, include_brief_comments_in_code_completion::Bool=false, user_files_are_volatile::Bool=false)
    @check_ptrs inv diag fm
    unit = clang_ASTUnit_LoadFromCompilerInvocation(inv, diag, fm, only_local_decls, capture_diagnostics, precompile_preamble_after_n_parses, tu_kind, cache_code_completion_results, include_brief_comments_in_code_completion, user_files_are_volatile)
    return unit == C_NULL ? nothing : ASTUnit(unit)
end

"""
    isMainFileAST(x::AbstractASTUnit) -> Bool
Return whether the unit was loaded from a serialized AST file rather than parsed from
source. The top-level declaration accessors are only valid when this is `false`.
"""
function isMainFileAST(x::AbstractASTUnit)
    @check_ptrs x
    return clang_ASTUnit_isMainFileAST(x)
end

"""
    getDiagnostics(x::AbstractASTUnit) -> DiagnosticsEngine
Return the diagnostics engine the unit reports through. It is borrowed: the engine is the
one handed to the constructor and the unit never frees it.
"""
function getDiagnostics(x::AbstractASTUnit)
    @check_ptrs x
    return DiagnosticsEngine(clang_ASTUnit_getDiagnostics(x))
end

"""
    getSourceManager(x::AbstractASTUnit) -> SourceManager
Return the unit's source manager.
"""
function getSourceManager(x::AbstractASTUnit)
    @check_ptrs x
    return SourceManager(clang_ASTUnit_getSourceManager(x))
end

"""
    hasPreprocessor(x::AbstractASTUnit) -> Bool
Return whether a parse has installed a preprocessor on the unit yet, i.e. whether
[`getPreprocessor`](@ref) returns a non-NULL carrier.
"""
function hasPreprocessor(x::AbstractASTUnit)
    @check_ptrs x
    return clang_ASTUnit_hasPreprocessor(x)
end

"""
    getPreprocessor(x::AbstractASTUnit) -> Preprocessor
Return the unit's preprocessor, or a carrier holding `C_NULL` when no parse has installed
one — test with [`hasPreprocessor`](@ref) first.

The shim reads the member through `getPreprocessorPtr` rather than
`clang::ASTUnit::getPreprocessor`, which returns `*PP`: a libstdc++ built with
`_GLIBCXX_ASSERTIONS` aborts the process on that dereference, which is how a Windows CI run
first surfaced this.
"""
function getPreprocessor(x::AbstractASTUnit)
    @check_ptrs x
    return Preprocessor(clang_ASTUnit_getPreprocessor(x))
end

"""
    getASTContext(x::AbstractASTUnit) -> ASTContext
Return the unit's AST context.

The unit must have one, installed either by a parse or by `setASTContext`. The member is a
null `IntrusiveRefCntPtr` otherwise and has no accessor to gate on, so this precondition is
documented rather than checked (MARSHALLING.md §13); the carrier comes back holding
`C_NULL` on a unit with no context.
"""
function getASTContext(x::AbstractASTUnit)
    @check_ptrs x
    return ASTContext(clang_ASTUnit_getASTContext(x))
end

"""
    setASTContext(x::AbstractASTUnit, ctx::ASTContext)
Install `ctx` as the unit's AST context.

This is not an adoption in the `dispose` sense: `clang::ASTContext` is reference counted
and the unit holds it through an `IntrusiveRefCntPtr`, so the call retains it and the
unit's disposal releases it. Whoever created `ctx` keeps its own reference and its own
ownership — but that owner must outlive the unit.
"""
function setASTContext(x::AbstractASTUnit, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_ASTUnit_setASTContext(x, ctx)
end

"""
    hasSema(x::AbstractASTUnit) -> Bool
Return whether the unit owns a `Sema` object. This is the gate `getSema` asserts on.
"""
function hasSema(x::AbstractASTUnit)
    @check_ptrs x
    return clang_ASTUnit_hasSema(x)
end

"""
    getSema(x::AbstractASTUnit) -> Sema
Return the unit's semantic analyser. The unit must have one (`hasSema`).
"""
function getSema(x::AbstractASTUnit)
    @check_ptrs x
    @assert hasSema(x) "ASTUnit does not have a Sema object"
    return Sema(clang_ASTUnit_getSema(x))
end

"""
    getFileManager(x::AbstractASTUnit) -> FileManager
Return the unit's file manager.
"""
function getFileManager(x::AbstractASTUnit)
    @check_ptrs x
    return FileManager(clang_ASTUnit_getFileManager(x))
end

"""
    getOriginalSourceFileName(x::AbstractASTUnit) -> String
Return the name of the source file the unit was originally built from, or an empty string
when it was not built from one.
"""
function getOriginalSourceFileName(x::AbstractASTUnit)
    @check_ptrs x
    return get_string(clang_ASTUnit_getOriginalSourceFileName(x))
end

"""
    getOnlyLocalDecls(x::AbstractASTUnit) -> Bool
Return whether a walk of this unit should visit only declarations that came from its own
source, skipping those loaded from a precompiled header or AST file.
"""
function getOnlyLocalDecls(x::AbstractASTUnit)
    @check_ptrs x
    return clang_ASTUnit_getOnlyLocalDecls(x)
end

"""
    getOwnsRemappedFileBuffers(x::AbstractASTUnit) -> Bool
Return whether the unit frees the memory buffers of its remapped files when it is
disposed.
"""
function getOwnsRemappedFileBuffers(x::AbstractASTUnit)
    @check_ptrs x
    return clang_ASTUnit_getOwnsRemappedFileBuffers(x)
end

"""
    setOwnsRemappedFileBuffers(x::AbstractASTUnit, value::Bool)
Set whether the unit frees the memory buffers of its remapped files when it is disposed.
"""
function setOwnsRemappedFileBuffers(x::AbstractASTUnit, value::Bool)
    @check_ptrs x
    return clang_ASTUnit_setOwnsRemappedFileBuffers(x, value)
end

"""
    getMainFileName(x::AbstractASTUnit) -> String
Return the name of the unit's main file: the first frontend input when the unit has an
invocation with inputs, otherwise the file behind the source manager's main file ID. Empty
when the unit has neither.
"""
function getMainFileName(x::AbstractASTUnit)
    @check_ptrs x
    return get_string(clang_ASTUnit_getMainFileName(x))
end

"""
    top_level_size(x::AbstractASTUnit) -> Integer
Return the number of top-level declarations the unit holds, counting those still pending
in the precompiled preamble. The unit must not be AST-file based (`isMainFileAST`).
"""
function top_level_size(x::AbstractASTUnit)
    @check_ptrs x
    @assert !isMainFileAST(x) "top-level declarations are not tracked on an AST-file unit"
    return clang_ASTUnit_top_level_size(x)
end

"""
    top_level_empty(x::AbstractASTUnit) -> Bool
Return whether the unit holds no top-level declarations. The unit must not be AST-file
based (`isMainFileAST`).
"""
function top_level_empty(x::AbstractASTUnit)
    @check_ptrs x
    @assert !isMainFileAST(x) "top-level declarations are not tracked on an AST-file unit"
    return clang_ASTUnit_top_level_empty(x)
end

"""
    getTopLevelDecl(x::AbstractASTUnit, i::Integer) -> Decl
Return the `i`-th top-level declaration (0-based), realizing the ones still pending in the
precompiled preamble first. The unit must not be AST-file based (`isMainFileAST`) and `i`
must be in range — the C++ range accessor is unchecked.

The result is wrapped at `Decl`, the element type of the underlying container; `resolve`
or an explicit `castTo*` refines it.
"""
function getTopLevelDecl(x::AbstractASTUnit, i::Integer)
    @check_ptrs x
    @assert !isMainFileAST(x) "top-level declarations are not tracked on an AST-file unit"
    @assert 0 <= i < top_level_size(x) "top-level declaration index out of range"
    return Decl(clang_ASTUnit_getTopLevelDecl(x, i))
end

"""
    addTopLevelDecl(x::AbstractASTUnit, d::AbstractDecl)
Append `d` to the unit's list of top-level declarations. The unit stores the pointer only
and never frees the declaration, which stays owned by its AST context.
"""
function addTopLevelDecl(x::AbstractASTUnit, d::AbstractDecl)
    @check_ptrs x d
    return clang_ASTUnit_addTopLevelDecl(x, d)
end

dispose(x::ASTUnit) = clang_ASTUnit_dispose(x)

"""
    addFileLevelDecl(x::AbstractASTUnit, d::AbstractDecl)
Record `d` in the unit's file-level declaration table, the index `findFileRegionDecls`
searches. The unit stores the pointer only and never frees the declaration.

`d`'s location must belong to the unit's own source manager: the implementation decomposes
it there, and a location minted by another `SourceManager` indexes an entry table that does
not describe it. Declarations that came from an AST file, or whose location is invalid or
non-local, are dropped silently. There is no accessor that ties a declaration back to a
source manager, so this precondition is documented rather than checked (MARSHALLING.md
§13).
"""
function addFileLevelDecl(x::AbstractASTUnit, d::AbstractDecl)
    @check_ptrs x d
    return clang_ASTUnit_addFileLevelDecl(x, d)
end

"""
    getNumFileRegionDecls(x::AbstractASTUnit, file::FileID, offset::Integer, len::Integer) -> Int
Return how many file-level declarations of `file` fall inside the byte region starting at
`offset` and spanning `len` bytes. `len` may be `0` to designate a point at `offset`.

This is the count half of the two-call protocol behind `findFileRegionDecls`; it runs the
whole search, so prefer `findFileRegionDecls` when the declarations themselves are wanted.

`file` must come from the unit's own source manager, and the unit must have an AST context
with an external source whenever `file` is a loaded (AST-file) ID — Clang asserts on that.
Neither condition is observable without dereferencing the unit's possibly-absent AST
context, so both are documented rather than checked (MARSHALLING.md §13).
"""
function getNumFileRegionDecls(x::AbstractASTUnit, file::FileID, offset::Integer, len::Integer)
    @check_ptrs x file
    return Int(clang_ASTUnit_getNumFileRegionDecls(x, file, offset, len))
end

"""
    findFileRegionDecls(x::AbstractASTUnit, file::FileID, offset::Integer, len::Integer) -> Vector{Decl}
Return the file-level declarations of `file` that fall inside the byte region starting at
`offset` and spanning `len` bytes. `len` may be `0` to designate a point at `offset`.

The results are wrapped at `Decl`, the element type of the container Clang fills; `resolve`
or an explicit `castTo*` refines them. Same preconditions as `getNumFileRegionDecls`.
"""
function findFileRegionDecls(x::AbstractASTUnit, file::FileID, offset::Integer, len::Integer)
    @check_ptrs x file
    n = clang_ASTUnit_getNumFileRegionDecls(x, file, offset, len)
    buf = Vector{CXDecl}(undef, n)
    n > 0 && clang_ASTUnit_findFileRegionDecls(x, file, offset, len, buf)
    return [Decl(p) for p in buf]
end

"""
    getLocation(x::AbstractASTUnit, file::FileEntry, line::Integer, col::Integer) -> SourceLocation
Return the source location of the `file`:`line`:`col` triplet.

Unlike `translateFileLineCol` on a bare `SourceManager`, this checks whether the position
lies inside the precompiled preamble and yields a "loaded" location when it does. `line`
and `col` are one-based — `clang::SourceManager` asserts that neither is zero. The result
is an invalid location when `file` has no file ID in the unit's source manager.
"""
function getLocation(x::AbstractASTUnit, file::FileEntry, line::Integer, col::Integer)
    @check_ptrs x file
    @assert line >= 1 && col >= 1 "line and column are one-based"
    return SourceLocation(clang_ASTUnit_getLocation(x, file, line, col))
end

"""
    mapLocationFromPreamble(x::AbstractASTUnit, loc::SourceLocation) -> SourceLocation
Map a location loaded from the unit's precompiled preamble to the corresponding local
location of the main file. `loc` comes back unchanged when it is not such a location, and
in particular when the unit has no preamble at all.
"""
function mapLocationFromPreamble(x::AbstractASTUnit, loc::SourceLocation)
    @check_ptrs x
    return SourceLocation(clang_ASTUnit_mapLocationFromPreamble(x, loc))
end

"""
    mapLocationToPreamble(x::AbstractASTUnit, loc::SourceLocation) -> SourceLocation
Map a local location of the main file that falls inside the preamble chunk to the
corresponding loaded location from the precompiled preamble. `loc` comes back unchanged
when it is not such a location, and in particular when the unit has no preamble at all.
"""
function mapLocationToPreamble(x::AbstractASTUnit, loc::SourceLocation)
    @check_ptrs x
    return SourceLocation(clang_ASTUnit_mapLocationToPreamble(x, loc))
end

"""
    isInPreambleFileID(x::AbstractASTUnit, loc::SourceLocation) -> Bool
Return whether `loc` sits in the file ID of the unit's precompiled preamble. `false` when
`loc` is invalid or the unit has no preamble.

`loc` must come from the unit's own source manager — that is where Clang looks it up. There
is no accessor tying a location back to a source manager, so this is documented rather than
checked (MARSHALLING.md §13).
"""
function isInPreambleFileID(x::AbstractASTUnit, loc::SourceLocation)
    @check_ptrs x
    return clang_ASTUnit_isInPreambleFileID(x, loc)
end

"""
    isInMainFileID(x::AbstractASTUnit, loc::SourceLocation) -> Bool
Return whether `loc` sits in the unit's main file ID. `false` when `loc` is invalid or the
unit's source manager has no main file. Same source-manager precondition as
`isInPreambleFileID`.
"""
function isInMainFileID(x::AbstractASTUnit, loc::SourceLocation)
    @check_ptrs x
    return clang_ASTUnit_isInMainFileID(x, loc)
end

"""
    getStartOfMainFileID(x::AbstractASTUnit) -> SourceLocation
Return the location of the first character of the unit's main file, or an invalid location
when its source manager has no main file ID.
"""
function getStartOfMainFileID(x::AbstractASTUnit)
    @check_ptrs x
    return SourceLocation(clang_ASTUnit_getStartOfMainFileID(x))
end

"""
    getEndOfPreambleFileID(x::AbstractASTUnit) -> SourceLocation
Return the location just past the end of the unit's precompiled preamble, or an invalid
location when the unit has no preamble.
"""
function getEndOfPreambleFileID(x::AbstractASTUnit)
    @check_ptrs x
    return SourceLocation(clang_ASTUnit_getEndOfPreambleFileID(x))
end

"""
    mapRangeFromPreamble(x::AbstractASTUnit, r::SourceRange) -> SourceRange
Apply `mapLocationFromPreamble` to both endpoints of `r`.
"""
function mapRangeFromPreamble(x::AbstractASTUnit, r::SourceRange)
    @check_ptrs x
    m = clang_ASTUnit_mapRangeFromPreamble(x, CXSourceRange_(r.begin_loc.ptr, r.end_loc.ptr))
    return SourceRange(SourceLocation(m.B), SourceLocation(m.E))
end

"""
    mapRangeToPreamble(x::AbstractASTUnit, r::SourceRange) -> SourceRange
Apply `mapLocationToPreamble` to both endpoints of `r`.
"""
function mapRangeToPreamble(x::AbstractASTUnit, r::SourceRange)
    @check_ptrs x
    m = clang_ASTUnit_mapRangeToPreamble(x, CXSourceRange_(r.begin_loc.ptr, r.end_loc.ptr))
    return SourceRange(SourceLocation(m.B), SourceLocation(m.E))
end

"""
    getPCHFile(x::AbstractASTUnit) -> Union{FileEntryRef,Nothing}
Return the precompiled header the unit included, or `nothing` when it included none (which
is the case for every unit that has not loaded a serialized AST).

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function getPCHFile(x::AbstractASTUnit)
    @check_ptrs x
    ptr = clang_ASTUnit_getPCHFile(x)
    return ptr == C_NULL ? nothing : FileEntryRef(ptr)
end

"""
    isModuleFile(x::AbstractASTUnit) -> Bool
Return whether the unit was built from a serialized module file, i.e. whether it is
AST-file based (`isMainFileAST`) and its language options say a module was being compiled.
"""
function isModuleFile(x::AbstractASTUnit)
    @check_ptrs x
    return clang_ASTUnit_isModuleFile(x)
end

"""
    getBufferForFile(x::AbstractASTUnit, filename::AbstractString) -> Union{LLVM.MemoryBuffer,Nothing}
Read `filename` through the unit's file manager, honouring its "user files are volatile"
setting. Returns `nothing` when the file cannot be read; the shim logs the reason.

This function allocates and one should call `LLVM.dispose` to release the resources after using this object.
"""
function getBufferForFile(x::AbstractASTUnit, filename::AbstractString)
    @check_ptrs x
    buf = clang_ASTUnit_getBufferForFile(x, filename)
    return buf == C_NULL ? nothing : LLVM.MemoryBuffer(buf)
end

"""
    getTranslationUnitKind(x::AbstractASTUnit) -> CXTranslationUnitKind
Return what kind of translation unit the AST represents: a complete one, a preamble prefix,
a module, or an incremental chunk.
"""
function getTranslationUnitKind(x::AbstractASTUnit)
    @check_ptrs x
    return clang_ASTUnit_getTranslationUnitKind(x)
end

"""
    isUnsafeToFree(x::AbstractASTUnit) -> Bool
Return the bit a client uses to mark a unit that is in an inconsistent state and must not be
freed. `clang::ASTUnit` declares it as a bit-field with no in-class initializer, so only a
value written by [`setUnsafeToFree`](@ref) is meaningful; the bit before that is whatever the
constructor left there (MARSHALLING.md §13 — the state has no observable gate, so this is
documented rather than asserted).
"""
function isUnsafeToFree(x::AbstractASTUnit)
    @check_ptrs x
    return clang_ASTUnit_isUnsafeToFree(x)
end

"""
    setUnsafeToFree(x::AbstractASTUnit, value::Bool)
Mark the unit as unsafe (or safe) to free. Nothing in this package acts on the bit — it is
storage for a client that tracks unit consistency itself.
"""
function setUnsafeToFree(x::AbstractASTUnit, value::Bool)
    @check_ptrs x
    clang_ASTUnit_setUnsafeToFree(x, value)
    return nothing
end

"""
    getFileSystemOpts(x::AbstractASTUnit) -> FileSystemOptions
Return the unit's own `clang::FileSystemOptions` (borrowed view). It is a by-value member, so
unlike the unit's language, header-search and preprocessor option sets it is valid on a unit
that has never parsed.
"""
function getFileSystemOpts(x::AbstractASTUnit)
    @check_ptrs x
    return FileSystemOptions(clang_ASTUnit_getFileSystemOpts(x))
end

"""
    getCurrentTopLevelHashValue(x::AbstractASTUnit) -> Integer
Return the running hash of the top-level declaration and macro definition names that the
top-level tracking action maintains while parsing.
"""
function getCurrentTopLevelHashValue(x::AbstractASTUnit)
    @check_ptrs x
    return clang_ASTUnit_getCurrentTopLevelHashValue(x)
end

"""
    setCurrentTopLevelHashValue(x::AbstractASTUnit, value::Integer)
Overwrite the running top-level name hash. The C++ API exposes it as a mutable `unsigned &`;
this is the write half the C surface cannot express.
"""
function setCurrentTopLevelHashValue(x::AbstractASTUnit, value::Integer)
    @check_ptrs x
    clang_ASTUnit_setCurrentTopLevelHashValue(x, value)
    return nothing
end

"""
    getPreambleCounterForTests(x::AbstractASTUnit) -> Integer
Return how many times a precompiled preamble has been built for this unit.
"""
function getPreambleCounterForTests(x::AbstractASTUnit)
    @check_ptrs x
    return clang_ASTUnit_getPreambleCounterForTests(x)
end

"""
    stored_diag_size(x::AbstractASTUnit) -> Integer
Return how many diagnostics the unit has captured. The vector only fills while parsing, and
only on a unit created with a capturing `CXCaptureDiagsKind`.
"""
function stored_diag_size(x::AbstractASTUnit)
    @check_ptrs x
    return clang_ASTUnit_stored_diag_size(x)
end

"""
    getStoredDiagnostic(x::AbstractASTUnit, i::Integer) -> StoredDiagnostic
Return the `i`-th captured diagnostic (0-based); `i` must be in range, as the C++ iterator is
unchecked.

The carrier borrows an interior pointer into the unit's own vector: never `dispose` it, and
re-read it after anything that reparses the unit.
"""
function getStoredDiagnostic(x::AbstractASTUnit, i::Integer)
    @check_ptrs x
    @assert 0 <= i < stored_diag_size(x) "stored diagnostic index out of range"
    return StoredDiagnostic(clang_ASTUnit_getStoredDiagnostic(x, i))
end

"""
    stored_diag_afterDriver_index(x::AbstractASTUnit) -> Integer
Return the index that splits the diagnostics the driver produced from the ones the parse
produced: entries before it came from the driver. A stale driver count is clamped back to 0,
matching the C++ accessor.
"""
function stored_diag_afterDriver_index(x::AbstractASTUnit)
    @check_ptrs x
    return clang_ASTUnit_stored_diag_afterDriver_index(x)
end

"""
    cached_completion_size(x::AbstractASTUnit) -> Integer
Return how many global code-completion results the unit has cached. Caching is off unless the
unit was built for code completion, in which case this is 0.
"""
function cached_completion_size(x::AbstractASTUnit)
    @check_ptrs x
    return clang_ASTUnit_cached_completion_size(x)
end

"""
    Save(x::AbstractASTUnit, file::AbstractString) -> Bool
Serialize the translation unit to `file` as a Clang AST file and return whether the save
**failed**.

The polarity is Clang's, and it is the opposite of the usual one: `true` means an error and
`false` means success, so `Save(u, path) && handle_success()` reads backwards. Every failure
looks alike — a unit whose module loader failed fatally refuses to write, as does a
temporary that cannot be created, written or renamed. Diagnostics are not a failure: a
translation unit with errors is written out, carrying its uncompilable-error bit.

The write goes through `llvm::writeToOutput`, so the bytes land in a
`"<file>.temp-stream-%%%%%%"` temporary that is renamed over `file` once complete; the
parent directory has to exist and be writable.

The unit must have parsed ([`hasSema`](@ref)): serialization builds its `ASTWriter` over
`ASTUnit::getSema`, which asserts on a unit that holds no `Sema` — the state every unit
[`ASTUnit`](@ref) creates is in. It must also have parsed without an unrecoverable error:
writing an AST that holds invalid nodes can crash the writer, which is why libclang runs
this same call inside a `CrashRecoveryContext`. This package has no such net, so the
condition is refused instead (MARSHALLING.md §13).
"""
function Save(x::AbstractASTUnit, file::AbstractString)
    @check_ptrs x
    @assert hasSema(x) "ASTUnit must have parsed before it can be serialized"
    @assert !hasUnrecoverableErrorOccurred(getDiagnostics(x)) "ASTUnit holds invalid nodes"
    return clang_ASTUnit_Save(x, file)
end
