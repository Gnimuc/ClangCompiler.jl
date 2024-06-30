#ifndef LLVM_CLANG_C_EXTRA_CXSOURCEMANAGER_H
#define LLVM_CLANG_C_EXTRA_CXSOURCEMANAGER_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "llvm-c/Types.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

CXSourceManager clang_SourceManager_create(CXDiagnosticsEngine Diag, CXFileManager FileMgr,
                                           bool UserFilesAreVolatile);

void clang_SourceManager_dispose(CXSourceManager SM);

void clang_SourceManager_PrintStats(CXSourceManager SM);

unsigned clang_FileID_getHashValue(CXFileID FID);

void clang_FileID_dispose(CXFileID FID);

CXFileID clang_SourceManager_createFileIDFromMemoryBuffer(CXSourceManager SM,
                                                          LLVMMemoryBufferRef MB);

CINDEX_LINKAGE
CXFileID clang_SourceManager_createFileIDFromFileEntry(CXSourceManager SM, CXFileEntry FE,
                                                       CXSourceLocation_ Loc);

CXFileID clang_SourceManager_getMainFileID(CXSourceManager SM);

void clang_SourceManager_setMainFileID(CXSourceManager SM, CXFileID ID);

void clang_SourceManager_overrideFileContents(CXSourceManager SM, CXFileEntry FE,
                                              LLVMMemoryBufferRef MB);

CXSourceLocation_ clang_SourceManager_getLocForStartOfFile(CXSourceManager SM,
                                                           CXFileID FID);

CXSourceLocation_ clang_SourceManager_getLocForEndOfFile(CXSourceManager SM, CXFileID FID);

LLVM_CLANG_C_EXTERN_C_END

#endif