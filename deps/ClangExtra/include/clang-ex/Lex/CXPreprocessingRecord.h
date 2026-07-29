#ifndef LLVM_CLANG_C_EXTRA_CXPREPROCESSINGRECORD_H
#define LLVM_CLANG_C_EXTRA_CXPREPROCESSINGRECORD_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// PreprocessedEntity

// Mirrors clang::PreprocessedEntity::EntityKind (clang/Lex/PreprocessingRecord.h). The
// FirstPreprocessingDirective/LastPreprocessingDirective range aliases are omitted — they
// duplicate values, which Julia's @enum rejects, and dropping them shifts nothing.
// CXEnumSync.cpp proves value-for-value equality.
typedef enum CXPreprocessedEntityKind {
  CXPreprocessedEntityKind_InvalidKind,
  CXPreprocessedEntityKind_MacroExpansionKind,
  CXPreprocessedEntityKind_MacroDefinitionKind,
  CXPreprocessedEntityKind_InclusionDirectiveKind
} CXPreprocessedEntityKind;

CXPreprocessedEntityKind clang_PreprocessedEntity_getKind(CXPreprocessedEntity PE);

CXSourceRange_ clang_PreprocessedEntity_getSourceRange(CXPreprocessedEntity PE);

bool clang_PreprocessedEntity_isInvalid(CXPreprocessedEntity PE);

// PreprocessedEntity Cast
CXMacroDefinitionRecord
clang_PreprocessedEntity_castToMacroDefinitionRecord(CXPreprocessedEntity PE);

CXMacroExpansion clang_PreprocessedEntity_castToMacroExpansion(CXPreprocessedEntity PE);

CXInclusionDirective
clang_PreprocessedEntity_castToInclusionDirective(CXPreprocessedEntity PE);

// MacroDefinitionRecord

// Borrowed; the identifier table owns the name.
CXIdentifierInfo clang_MacroDefinitionRecord_getName(CXMacroDefinitionRecord MD);

CXSourceLocation_ clang_MacroDefinitionRecord_getLocation(CXMacroDefinitionRecord MD);

// MacroExpansion

bool clang_MacroExpansion_isBuiltinMacro(CXMacroExpansion ME);

// Borrowed; the name of the definition being expanded, or the name token's identifier
// when the macro is a builtin.
CXIdentifierInfo clang_MacroExpansion_getName(CXMacroExpansion ME);

// Borrowed; NULL for a builtin macro, which the record stores by name and not by
// definition.
CXMacroDefinitionRecord clang_MacroExpansion_getDefinition(CXMacroExpansion ME);

// InclusionDirective

// Mirrors clang::InclusionDirective::InclusionKind (clang/Lex/PreprocessingRecord.h).
// CXEnumSync.cpp proves value-for-value equality.
typedef enum CXInclusionKind {
  CXInclusionKind_Include,
  CXInclusionKind_Import,
  CXInclusionKind_IncludeNext,
  CXInclusionKind_IncludeMacros
} CXInclusionKind;

CXInclusionKind clang_InclusionDirective_getKind(CXInclusionDirective ID);

// The file name exactly as written in the directive, without its delimiters.
CXString clang_InclusionDirective_getFileName(CXInclusionDirective ID);

bool clang_InclusionDirective_wasInQuotes(CXInclusionDirective ID);

bool clang_InclusionDirective_importedModule(CXInclusionDirective ID);

// PreprocessingRecord

// Borrowed; the record holds a reference to the manager it was constructed with.
CXSourceManager clang_PreprocessingRecord_getSourceManager(CXPreprocessingRecord PR);

// helper: the begin()/end() iterator pair exposed as count+index. The walk covers the
// entities loaded from an external source before the locally recorded ones, in source
// order. The count is exact.
unsigned clang_PreprocessingRecord_getNumPreprocessedEntities(CXPreprocessingRecord PR);

// helper: `Index` < clang_PreprocessingRecord_getNumPreprocessedEntities — the index is
// unchecked. Borrowed: entities live in the record's own allocator. A slot is NULL only
// when an external source failed to deserialize a loaded entity.
CXPreprocessedEntity
clang_PreprocessingRecord_getPreprocessedEntity(CXPreprocessingRecord PR, unsigned Index);

// Borrowed; NULL when the record holds no definition for `MI` — which is the case for
// every macro defined before the record was created.
CXMacroDefinitionRecord
clang_PreprocessingRecord_findMacroDefinition(CXPreprocessingRecord PR, CXMacroInfo MI);

// helper: `getSkippedRanges()` exposed as count+index. Both calls force any external
// source's skipped ranges to be loaded first.
unsigned clang_PreprocessingRecord_getNumSkippedRanges(CXPreprocessingRecord PR);

// The bytes the record's own allocations occupy. A monotone measure of how much preprocessing
// history has accumulated, not a value to pin.
size_t clang_PreprocessingRecord_getTotalMemory(CXPreprocessingRecord PR);

// helper: `Index` < clang_PreprocessingRecord_getNumSkippedRanges — unchecked.
CXSourceRange_ clang_PreprocessingRecord_getSkippedRange(CXPreprocessingRecord PR,
                                                         unsigned Index);

// The file the #include resolved to, heap-boxed and OWNED -- release with
// clang_FileEntryRef_dispose. NULL when the include did not resolve.
CXFileEntryRef clang_InclusionDirective_getFile(CXInclusionDirective ID);

LLVM_CLANG_C_EXTERN_C_END

#endif
