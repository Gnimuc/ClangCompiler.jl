#include "clang-ex/Lex/CXPreprocessingRecord.h"
#include "utils.h"
#include "clang/Basic/IdentifierTable.h"
#include "clang/Basic/SourceManager.h"
#include "clang/Lex/MacroInfo.h"
#include "clang/Lex/PreprocessingRecord.h"

CXPreprocessedEntityKind clang_PreprocessedEntity_getKind(CXPreprocessedEntity PE) {
  return static_cast<CXPreprocessedEntityKind>(
      static_cast<clang::PreprocessedEntity *>(PE)->getKind());
}

CXSourceRange_ clang_PreprocessedEntity_getSourceRange(CXPreprocessedEntity PE) {
  auto rng = static_cast<clang::PreprocessedEntity *>(PE)->getSourceRange();
  return CXSourceRange_{rng.getBegin().getPtrEncoding(), rng.getEnd().getPtrEncoding()};
}

bool clang_PreprocessedEntity_isInvalid(CXPreprocessedEntity PE) {
  return static_cast<clang::PreprocessedEntity *>(PE)->isInvalid();
}

CXMacroDefinitionRecord
clang_PreprocessedEntity_castToMacroDefinitionRecord(CXPreprocessedEntity PE) {
  return llvm::dyn_cast_or_null<clang::MacroDefinitionRecord>(
      static_cast<clang::PreprocessedEntity *>(PE));
}

CXMacroExpansion clang_PreprocessedEntity_castToMacroExpansion(CXPreprocessedEntity PE) {
  return llvm::dyn_cast_or_null<clang::MacroExpansion>(
      static_cast<clang::PreprocessedEntity *>(PE));
}

CXInclusionDirective
clang_PreprocessedEntity_castToInclusionDirective(CXPreprocessedEntity PE) {
  return llvm::dyn_cast_or_null<clang::InclusionDirective>(
      static_cast<clang::PreprocessedEntity *>(PE));
}

CXIdentifierInfo clang_MacroDefinitionRecord_getName(CXMacroDefinitionRecord MD) {
  return const_cast<clang::IdentifierInfo *>(
      static_cast<clang::MacroDefinitionRecord *>(MD)->getName());
}

CXSourceLocation_ clang_MacroDefinitionRecord_getLocation(CXMacroDefinitionRecord MD) {
  return static_cast<clang::MacroDefinitionRecord *>(MD)->getLocation().getPtrEncoding();
}

bool clang_MacroExpansion_isBuiltinMacro(CXMacroExpansion ME) {
  return static_cast<clang::MacroExpansion *>(ME)->isBuiltinMacro();
}

CXIdentifierInfo clang_MacroExpansion_getName(CXMacroExpansion ME) {
  return const_cast<clang::IdentifierInfo *>(
      static_cast<clang::MacroExpansion *>(ME)->getName());
}

CXMacroDefinitionRecord clang_MacroExpansion_getDefinition(CXMacroExpansion ME) {
  return static_cast<clang::MacroExpansion *>(ME)->getDefinition();
}

CXInclusionKind clang_InclusionDirective_getKind(CXInclusionDirective ID) {
  return static_cast<CXInclusionKind>(
      static_cast<clang::InclusionDirective *>(ID)->getKind());
}

CXString clang_InclusionDirective_getFileName(CXInclusionDirective ID) {
  return extra::makeCXString(
      static_cast<clang::InclusionDirective *>(ID)->getFileName().str());
}

bool clang_InclusionDirective_wasInQuotes(CXInclusionDirective ID) {
  return static_cast<clang::InclusionDirective *>(ID)->wasInQuotes();
}

bool clang_InclusionDirective_importedModule(CXInclusionDirective ID) {
  return static_cast<clang::InclusionDirective *>(ID)->importedModule();
}

CXSourceManager clang_PreprocessingRecord_getSourceManager(CXPreprocessingRecord PR) {
  return &static_cast<clang::PreprocessingRecord *>(PR)->getSourceManager();
}

unsigned clang_PreprocessingRecord_getNumPreprocessedEntities(CXPreprocessingRecord PR) {
  auto *Rec = static_cast<clang::PreprocessingRecord *>(PR);
  return static_cast<unsigned>(Rec->end() - Rec->begin());
}

CXPreprocessedEntity
clang_PreprocessingRecord_getPreprocessedEntity(CXPreprocessingRecord PR, unsigned Index) {
  auto *Rec = static_cast<clang::PreprocessingRecord *>(PR);
  return *(Rec->begin() + static_cast<int>(Index));
}

CXMacroDefinitionRecord
clang_PreprocessingRecord_findMacroDefinition(CXPreprocessingRecord PR, CXMacroInfo MI) {
  return static_cast<clang::PreprocessingRecord *>(PR)->findMacroDefinition(
      static_cast<clang::MacroInfo *>(MI));
}

unsigned clang_PreprocessingRecord_getNumSkippedRanges(CXPreprocessingRecord PR) {
  return static_cast<unsigned>(
      static_cast<clang::PreprocessingRecord *>(PR)->getSkippedRanges().size());
}

CXSourceRange_ clang_PreprocessingRecord_getSkippedRange(CXPreprocessingRecord PR,
                                                         unsigned Index) {
  auto rng = static_cast<clang::PreprocessingRecord *>(PR)->getSkippedRanges()[Index];
  return CXSourceRange_{rng.getBegin().getPtrEncoding(), rng.getEnd().getPtrEncoding()};
}

size_t clang_PreprocessingRecord_getTotalMemory(CXPreprocessingRecord PR) {
  return static_cast<clang::PreprocessingRecord *>(PR)->getTotalMemory();
}

CXFileEntryRef clang_InclusionDirective_getFile(CXInclusionDirective ID) {
  auto F = static_cast<clang::InclusionDirective *>(ID)->getFile();
  if (!F)
    return nullptr;
  return std::make_unique<clang::FileEntryRef>(*F).release();
}
