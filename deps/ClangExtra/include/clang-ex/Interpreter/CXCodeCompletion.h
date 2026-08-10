#ifndef LLVM_CLANG_C_EXTRA_CXCODECOMPLETION_H
#define LLVM_CLANG_C_EXTRA_CXCODECOMPLETION_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "clang-c/CXString.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang::ReplCodeCompleter is a bare struct whose only state is the Prefix its one method
// fills in, so it needs no handle: the shim stack-allocates one per call and hands both
// results back. This is the completion engine clang-repl itself drives.
//
// InterpCI is a compiler instance built for the completion request (an
// IncrementalCompilerBuilder CreateCpp is what clang-repl passes); ParentCI is the running
// interpreter's instance, which supplies the ASTContext completions are looked up in.
// Neither is consumed.
//
// Returns the completion candidates, caller-owned (clang_disposeStringSet); OutPrefix, when
// non-NULL, receives the prefix the candidates complete, also caller-owned.
CXStringSet *clang_ReplCodeCompleter_codeComplete(CXCompilerInstance InterpCI,
                                                  const char *Content, unsigned Line,
                                                  unsigned Col, CXCompilerInstance ParentCI,
                                                  CXString *OutPrefix);

LLVM_CLANG_C_EXTERN_C_END

#endif
