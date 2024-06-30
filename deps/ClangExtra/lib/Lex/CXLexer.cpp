#include "clang-ex/Lex/CXLexer.h"
#include "clang/Lex/Lexer.h"
#include "llvm/Support/MemoryBuffer.h"
#include <cstdio>

CXLexer clang_Lexer_create(CXFileID FID, LLVMMemoryBufferRef FromFile, CXSourceManager SM,
                           CXLangOptions langOpts) {
  auto L = std::make_unique<clang::Lexer>(*static_cast<clang::FileID *>(FID),
                                          llvm::MemoryBufferRef(*llvm::unwrap(FromFile)),
                                          *static_cast<clang::SourceManager *>(SM),
                                          *static_cast<clang::LangOptions *>(langOpts));
  return L.release();
}

void clang_Lexer_dispose(CXLexer Lex) { delete static_cast<clang::Lexer *>(Lex); }