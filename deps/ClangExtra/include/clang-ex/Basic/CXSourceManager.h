#ifndef LIBCLANGEX_CXSOURCEMANAGER_H
#define LIBCLANGEX_CXSOURCEMANAGER_H

#include "clang-ex/CXError.h"
#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"
#include "llvm-c/Types.h"

#ifdef __cplusplus
extern "C" {
#endif

CINDEX_LINKAGE CXSourceManager clang_SourceManager_create(CXDiagnosticsEngine Diag,
                                                          CXFileManager FileMgr,
                                                          bool UserFilesAreVolatile,
                                                          CXInit_Error *ErrorCode);

CINDEX_LINKAGE void clang_SourceManager_dispose(CXSourceManager SM);

CINDEX_LINKAGE void clang_SourceManager_PrintStats(CXSourceManager SM);

CINDEX_LINKAGE unsigned clang_FileID_getHashValue(CXFileID FID);

CINDEX_LINKAGE void clang_FileID_dispose(CXFileID FID);

CINDEX_LINKAGE CXFileID clang_SourceManager_createFileIDFromMemoryBuffer(
    CXSourceManager SM, LLVMMemoryBufferRef MB);

CINDEX_LINKAGE
CXFileID clang_SourceManager_createFileIDFromFileEntry(CXSourceManager SM, CXFileEntry FE,
                                                       CXSourceLocation_ Loc);

CINDEX_LINKAGE CXFileID clang_SourceManager_getMainFileID(CXSourceManager SM);

CINDEX_LINKAGE void clang_SourceManager_setMainFileID(CXSourceManager SM, CXFileID ID);

CINDEX_LINKAGE void clang_SourceManager_overrideFileContents(CXSourceManager SM,
                                                             CXFileEntry FE,
                                                             LLVMMemoryBufferRef MB);

CINDEX_LINKAGE CXSourceLocation_
clang_SourceManager_getLocForStartOfFile(CXSourceManager SM, CXFileID FID);

CINDEX_LINKAGE CXSourceLocation_ clang_SourceManager_getLocForEndOfFile(CXSourceManager SM,
                                                                        CXFileID FID);

#ifdef __cplusplus
}
#endif
#endif