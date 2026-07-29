# PreprocessedEntity

"""
    getKind(x::AbstractPreprocessedEntity) -> CXPreprocessedEntityKind
Return which kind of entity this is: a macro expansion, a macro definition, or an inclusion
directive.
"""
function getKind(x::AbstractPreprocessedEntity)
    @check_ptrs x
    return clang_PreprocessedEntity_getKind(x)
end

"""
    getSourceRange(x::AbstractPreprocessedEntity) -> SourceRange
Return the source range the entity covers.
"""
function getSourceRange(x::AbstractPreprocessedEntity)
    @check_ptrs x
    r = clang_PreprocessedEntity_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

"""
    isInvalid(x::AbstractPreprocessedEntity) -> Bool
Return whether the entity failed to load from the external source it was recorded in.
"""
function isInvalid(x::AbstractPreprocessedEntity)
    @check_ptrs x
    return clang_PreprocessedEntity_isInvalid(x)
end

# PreprocessedEntity Cast

"""
    MacroDefinitionRecord(x::AbstractPreprocessedEntity) -> MacroDefinitionRecord
Downcast to the `#define` record. The result holds a NULL pointer when the entity is not a
macro definition.
"""
function MacroDefinitionRecord(x::AbstractPreprocessedEntity)
    @check_ptrs x
    return MacroDefinitionRecord(clang_PreprocessedEntity_castToMacroDefinitionRecord(x))
end

"""
    MacroExpansion(x::AbstractPreprocessedEntity) -> MacroExpansion
Downcast to the macro-expansion record. The result holds a NULL pointer when the entity is
not a macro expansion.
"""
function MacroExpansion(x::AbstractPreprocessedEntity)
    @check_ptrs x
    return MacroExpansion(clang_PreprocessedEntity_castToMacroExpansion(x))
end

"""
    InclusionDirective(x::AbstractPreprocessedEntity) -> InclusionDirective
Downcast to the inclusion-directive record. The result holds a NULL pointer when the entity
is not an inclusion directive.
"""
function InclusionDirective(x::AbstractPreprocessedEntity)
    @check_ptrs x
    return InclusionDirective(clang_PreprocessedEntity_castToInclusionDirective(x))
end

# MacroDefinitionRecord

"""
    getName(x::AbstractMacroDefinitionRecord) -> IdentifierInfo
Return the identifier the `#define` introduced. The result is borrowed from the identifier
table.
"""
function getName(x::AbstractMacroDefinitionRecord)
    @check_ptrs x
    return IdentifierInfo(clang_MacroDefinitionRecord_getName(x))
end

"""
    getLocation(x::AbstractMacroDefinitionRecord) -> SourceLocation
Return the location of the macro name inside the `#define`.
"""
function getLocation(x::AbstractMacroDefinitionRecord)
    @check_ptrs x
    return SourceLocation(clang_MacroDefinitionRecord_getLocation(x))
end

# MacroExpansion

"""
    isBuiltinMacro(x::AbstractMacroExpansion) -> Bool
Return whether the macro expanded here is a builtin (`__LINE__`, `__FILE__`, …), which the
record stores by name instead of by definition.
"""
function isBuiltinMacro(x::AbstractMacroExpansion)
    @check_ptrs x
    return clang_MacroExpansion_isBuiltinMacro(x)
end

"""
    getName(x::AbstractMacroExpansion) -> IdentifierInfo
Return the identifier of the macro being expanded, borrowed from the identifier table.
"""
function getName(x::AbstractMacroExpansion)
    @check_ptrs x
    return IdentifierInfo(clang_MacroExpansion_getName(x))
end

"""
    getDefinition(x::AbstractMacroExpansion) -> MacroDefinitionRecord
Return the `#define` record this expansion resolves to. The result is borrowed and holds a
NULL pointer for a builtin macro, which carries a name and no definition — pair this with
`isBuiltinMacro`.
"""
function getDefinition(x::AbstractMacroExpansion)
    @check_ptrs x
    return MacroDefinitionRecord(clang_MacroExpansion_getDefinition(x))
end

# InclusionDirective

"""
    getKind(x::AbstractInclusionDirective) -> CXInclusionKind
Return which spelling of the directive was used: `#include`, `#import`, `#include_next` or
`#__include_macros`. `InclusionDirective::getKind` hides `PreprocessedEntity::getKind` in
C++ and this method hides `getKind(::AbstractPreprocessedEntity)` the same way — read the
entity kind off the `PreprocessedEntity` the record handed out, before the downcast.
"""
function getKind(x::AbstractInclusionDirective)
    @check_ptrs x
    return clang_InclusionDirective_getKind(x)
end

"""
    getFileName(x::AbstractInclusionDirective) -> String
Return the included file name exactly as written in the directive, without its quotes or
angle brackets.
"""
function getFileName(x::AbstractInclusionDirective)
    @check_ptrs x
    return get_string(clang_InclusionDirective_getFileName(x))
end

"""
    wasInQuotes(x::AbstractInclusionDirective) -> Bool
Return whether the file name was written in quotes rather than in angle brackets.
"""
function wasInQuotes(x::AbstractInclusionDirective)
    @check_ptrs x
    return clang_InclusionDirective_wasInQuotes(x)
end

"""
    importedModule(x::AbstractInclusionDirective) -> Bool
Return whether the directive was automatically turned into a module import.
"""
function importedModule(x::AbstractInclusionDirective)
    @check_ptrs x
    return clang_InclusionDirective_importedModule(x)
end

# PreprocessingRecord

"""
    getSourceManager(x::AbstractPreprocessingRecord) -> SourceManager
Return the source manager the record was constructed with — the preprocessor's own. The
result is borrowed.
"""
function getSourceManager(x::AbstractPreprocessingRecord)
    @check_ptrs x
    return SourceManager(clang_PreprocessingRecord_getSourceManager(x))
end

"""
    getNumPreprocessedEntities(x::AbstractPreprocessingRecord) -> Int
Return how many preprocessed entities the record holds. A record exists only once
`createPreprocessingRecord` has run on the preprocessor; the NULL carrier
`getPreprocessingRecord` hands back until then is rejected here.
"""
function getNumPreprocessedEntities(x::AbstractPreprocessingRecord)
    @check_ptrs x
    return Int(clang_PreprocessingRecord_getNumPreprocessedEntities(x))
end

"""
    getPreprocessedEntity(x::AbstractPreprocessingRecord, i::Integer) -> PreprocessedEntity
Return the `i`-th recorded entity, counting from 0 in source order. The result is borrowed
from the record's allocator and typed at the `PreprocessedEntity` base — refine it with
`MacroDefinitionRecord`, `MacroExpansion` or `InclusionDirective` once `getKind` says which.
"""
function getPreprocessedEntity(x::AbstractPreprocessingRecord, i::Integer)
    @check_ptrs x
    @assert 0 ≤ i < getNumPreprocessedEntities(x) "preprocessed-entity index out of bounds"
    return PreprocessedEntity(clang_PreprocessingRecord_getPreprocessedEntity(x, i))
end

"""
    getPreprocessedEntities(x::AbstractPreprocessingRecord) -> Vector{PreprocessedEntity}
Return every entity the record holds, in source order.
"""
function getPreprocessedEntities(x::AbstractPreprocessingRecord)
    @check_ptrs x
    return [getPreprocessedEntity(x, i) for i = 0:(getNumPreprocessedEntities(x) - 1)]
end

"""
    findMacroDefinition(x::AbstractPreprocessingRecord, mi::AbstractMacroInfo) -> MacroDefinitionRecord
Return the `#define` record registered for `mi`. The result is borrowed and holds a NULL
pointer when the record never saw that definition — which is the case for every macro
defined before `createPreprocessingRecord` ran, the predefines buffer included.
"""
function findMacroDefinition(x::AbstractPreprocessingRecord, mi::AbstractMacroInfo)
    @check_ptrs x mi
    return MacroDefinitionRecord(clang_PreprocessingRecord_findMacroDefinition(x, mi))
end

"""
    getNumSkippedRanges(x::AbstractPreprocessingRecord) -> Int
Return how many source ranges the preprocessor skipped.
"""
function getNumSkippedRanges(x::AbstractPreprocessingRecord)
    @check_ptrs x
    return Int(clang_PreprocessingRecord_getNumSkippedRanges(x))
end

"""
    getSkippedRange(x::AbstractPreprocessingRecord, i::Integer) -> SourceRange
Return the `i`-th skipped range, counting from 0.
"""
function getSkippedRange(x::AbstractPreprocessingRecord, i::Integer)
    @check_ptrs x
    @assert 0 ≤ i < getNumSkippedRanges(x) "skipped-range index out of bounds"
    r = clang_PreprocessingRecord_getSkippedRange(x, i)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

"""
    getSkippedRanges(x::AbstractPreprocessingRecord) -> Vector{SourceRange}
Return every range the preprocessor skipped — the body of each conditional whose condition
was false, running from the directive that opened it to the matching `#endif`.
"""
function getSkippedRanges(x::AbstractPreprocessingRecord)
    @check_ptrs x
    return [getSkippedRange(x, i) for i = 0:(getNumSkippedRanges(x) - 1)]
end

"""
    getTotalMemory(x::AbstractPreprocessingRecord) -> Csize_t
Return the bytes `x`'s own allocations occupy — a measure of how much preprocessing history has
accumulated, which grows as more entities are recorded.
"""
function getTotalMemory(x::AbstractPreprocessingRecord)
    @check_ptrs x
    return clang_PreprocessingRecord_getTotalMemory(x)
end
