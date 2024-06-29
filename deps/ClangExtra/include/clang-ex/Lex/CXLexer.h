#ifndef LIBCLANGEX_CXLEXER_H
#define LIBCLANGEX_CXLEXER_H

#include "clang-ex/CXError.h"
#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"
#include "llvm-c/Types.h"

#ifdef __cplusplus
extern "C" {
#endif

CINDEX_LINKAGE CXLexer clang_Lexer_create(CXFileID FID, LLVMMemoryBufferRef FromFile,
                                          CXSourceManager SM, CXLangOptions langOpts,
                                          CXInit_Error *ErrorCode);

CINDEX_LINKAGE void clang_Lexer_dispose(CXLexer Lex);

#ifdef __cplusplus
}
#endif
#endif