#ifndef LLVM_CLANG_C_EXTRA_CXPREPROCESSORLEXER_H
#define LLVM_CLANG_C_EXTRA_CXPREPROCESSORLEXER_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// The base of every lexer the preprocessor drives.
// `clang_Preprocessor_getCurrentLexer` and `clang_Preprocessor_getCurrentFileLexer`
// already hand this out; these are the questions that can be asked of it -- above all
// "which file is being lexed right now", which is what an error message raised in the
// middle of a nested #include has to name.

// helper: lexes one token in header-name mode, i.e. turns `<stdio.h>` or `"foo.h"` into a
// single `tok::header_name` rather than a punctuator run. Clang asserts that the lexer is
// mid-directive, a protected flag with no getter, so this sets that flag around the lex
// and clears it afterwards -- correct for a caller outside clang's own directive handling,
// which is the only place this is reachable from.
// DESTRUCTIVE: it consumes a token from the live stream, exactly like
// `clang_Preprocessor_Lex`.
void clang_PreprocessorLexer_LexIncludeFilename(CXPreprocessorLexer L,
                                                CXToken_ FilenameTok);

// setParsingPreprocessorDirective

// Raw mode disables macro expansion, identifier lookup and diagnostics; in raw mode the
// lexer's preprocessor pointer may be NULL, which is what makes the three accessors below
// conditional.
bool clang_PreprocessorLexer_isLexingRawMode(CXPreprocessorLexer L);

// NULL for a raw-mode lexer that was created without one. Gate `getFileID` and
// `getFileEntry` on this.
CXPreprocessor clang_PreprocessorLexer_getPP(CXPreprocessorLexer L);

// The FileID of the file being lexed. Precondition: `clang_PreprocessorLexer_getPP` is
// non-NULL; clang asserts. This allocates, call `clang_FileID_dispose` to release.
CXFileID clang_PreprocessorLexer_getFileID(CXPreprocessorLexer L);

unsigned clang_PreprocessorLexer_getInitialNumSLocEntries(CXPreprocessorLexer L);

// The file behind that FileID; NULL when the FileID names a memory buffer rather than a
// file on disk. Precondition: `clang_PreprocessorLexer_getPP` is non-NULL; clang asserts.
// This heap-boxes the `clang::FileEntryRef`, call `clang_FileEntryRef_dispose` to release.
CXFileEntryRef clang_PreprocessorLexer_getFileEntry(CXPreprocessorLexer L);

// Count + fill over the #if/#ifdef/#ifndef blocks the lexer is currently inside, outermost
// first -- the same four parallel arrays as
// `clang_Preprocessor_getPreambleConditionalStack`. The count is exact and all four
// buffers must have room for it: `IfLocs[i]` is where the conditional started,
// `WasSkipping[i]` whether it sat inside a skipped block, `FoundNonSkip[i]` whether tokens
// were already emitted for it, `FoundElse[i]` whether its `#else` has been seen.
// (`PreprocessorLexer::getConditionalStackDepth` is protected; this counts the public
// iterator range instead.)
unsigned clang_PreprocessorLexer_getNumConditionals(CXPreprocessorLexer L);

void clang_PreprocessorLexer_getConditionalStack(CXPreprocessorLexer L,
                                                 CXSourceLocation_ *IfLocs,
                                                 bool *WasSkipping, bool *FoundNonSkip,
                                                 bool *FoundElse);

// setConditionalLevels

LLVM_CLANG_C_EXTERN_C_END

#endif
