#include "clang-ex/Lex/CXPreprocessorLexer.h"

#include "clang/Basic/FileEntry.h"
#include "clang/Basic/SourceLocation.h"
#include "clang/Lex/PreprocessorLexer.h"
#include "clang/Lex/Token.h"

#include <iterator>
#include <memory>

namespace {

clang::PreprocessorLexer *lexer(CXPreprocessorLexer L) {
  return reinterpret_cast<clang::PreprocessorLexer *>(L);
}

} // namespace

void clang_PreprocessorLexer_LexIncludeFilename(CXPreprocessorLexer L,
                                                CXToken_ FilenameTok) {
  auto *PL = lexer(L);
  PL->setParsingPreprocessorDirective(true);
  PL->LexIncludeFilename(*reinterpret_cast<clang::Token *>(FilenameTok));
  PL->setParsingPreprocessorDirective(false);
}

// setParsingPreprocessorDirective

bool clang_PreprocessorLexer_isLexingRawMode(CXPreprocessorLexer L) {
  return lexer(L)->isLexingRawMode();
}

CXPreprocessor clang_PreprocessorLexer_getPP(CXPreprocessorLexer L) {
  return reinterpret_cast<CXPreprocessor>(lexer(L)->getPP());
}

CXFileID clang_PreprocessorLexer_getFileID(CXPreprocessorLexer L) {
  return reinterpret_cast<CXFileID>(
      std::make_unique<clang::FileID>(lexer(L)->getFileID()).release());
}

unsigned clang_PreprocessorLexer_getInitialNumSLocEntries(CXPreprocessorLexer L) {
  return lexer(L)->getInitialNumSLocEntries();
}

CXFileEntryRef clang_PreprocessorLexer_getFileEntry(CXPreprocessorLexer L) {
  clang::OptionalFileEntryRef Ref = lexer(L)->getFileEntry();
  if (!Ref)
    return nullptr;
  return reinterpret_cast<CXFileEntryRef>(
      std::make_unique<clang::FileEntryRef>(*Ref).release());
}

unsigned clang_PreprocessorLexer_getNumConditionals(CXPreprocessorLexer L) {
  auto *PL = lexer(L);
  return static_cast<unsigned>(
      std::distance(PL->conditional_begin(), PL->conditional_end()));
}

void clang_PreprocessorLexer_getConditionalStack(CXPreprocessorLexer L,
                                                 CXSourceLocation_ *IfLocs,
                                                 bool *WasSkipping, bool *FoundNonSkip,
                                                 bool *FoundElse) {
  auto *PL = lexer(L);
  unsigned I = 0;
  for (auto It = PL->conditional_begin(), End = PL->conditional_end(); It != End;
       ++It, ++I) {
    IfLocs[I] = reinterpret_cast<CXSourceLocation_>(It->IfLoc.getPtrEncoding());
    WasSkipping[I] = It->WasSkipping;
    FoundNonSkip[I] = It->FoundNonSkip;
    FoundElse[I] = It->FoundElse;
  }
}

// setConditionalLevels
