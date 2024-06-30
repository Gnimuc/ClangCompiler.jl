#include "clang-ex/Lex/CXLexer.h"
#include "clang/Lex/Lexer.h"
#include "llvm/Support/MemoryBuffer.h"
#include <cstdio>

CXLexer clang_Lexer_create(CXFileID FID, LLVMMemoryBufferRef FromFile, CXSourceManager SM,
                           CXLangOptions langOpts, CXInit_Error *ErrorCode) {
  CXInit_Error Err = CXInit_NoError;
  std::unique_ptr<clang::Lexer> ptr = std::make_unique<clang::Lexer>(
      *static_cast<clang::FileID *>(FID), llvm::MemoryBufferRef(*llvm::unwrap(FromFile)),
      *static_cast<clang::SourceManager *>(SM),
      *static_cast<clang::LangOptions *>(langOpts));

  if (!ptr) {
    fprintf(stderr, "LIBCLANGEX ERROR: failed to create `clang::Lexer`\n");
    Err = CXInit_CanNotCreate;
  }

  if (ErrorCode)
    *ErrorCode = Err;

  return ptr.release();
}

void clang_Lexer_dispose(CXLexer Lex) { delete static_cast<clang::Lexer *>(Lex); }