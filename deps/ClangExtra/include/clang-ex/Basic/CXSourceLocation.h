#ifndef LLVM_CLANG_C_EXTRA_CXSOURCELOCATION_H
#define LLVM_CLANG_C_EXTRA_CXSOURCELOCATION_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

CXSourceLocation_ clang_SourceLocation_createInvalid(void);

bool clang_SourceLocation_isFileID(CXSourceLocation_ Loc);

bool clang_SourceLocation_isMacroID(CXSourceLocation_ Loc);

bool clang_SourceLocation_isValid(CXSourceLocation_ Loc);

bool clang_SourceLocation_isInvalid(CXSourceLocation_ Loc);

bool clang_SourceLocation_isPairOfFileLocations(CXSourceLocation_ Start,
                                                CXSourceLocation_ End);

unsigned clang_SourceLocation_getHashValue(CXSourceLocation_ Loc);

void clang_SourceLocation_dump(CXSourceLocation_ Loc, CXSourceManager SM);

CXString clang_SourceLocation_printToString(CXSourceLocation_ Loc, CXSourceManager SM);

CXSourceLocation_ clang_SourceLocation_getLocWithOffset(CXSourceLocation_ Loc, int Offset);

uint32_t clang_SourceLocation_getRawEncoding(CXSourceLocation_ Loc);

CXSourceLocation_ clang_SourceLocation_getFromRawEncoding(uint32_t Encoding);

CXString clang_SourceRange_printToString(CXSourceRange_ R, CXSourceManager SM);

void clang_SourceRange_dump(CXSourceRange_ R, CXSourceManager SM);

// PresumedLoc
// A `clang::PresumedLoc` has no pointer form, so it is heap-boxed: this create wraps
// `SourceManager::getPresumedLoc` and the box is caller-owned — release it with
// `clang_PresumedLoc_dispose`. The box is an *invalid* PresumedLoc whenever the presumed
// location cannot be computed (Loc is invalid, or its file changed on disk).
CXPresumedLoc clang_PresumedLoc_create(CXSourceManager SM, CXSourceLocation_ Loc,
                                       bool UseLineDirectives);

void clang_PresumedLoc_dispose(CXPresumedLoc PLoc);

bool clang_PresumedLoc_isInvalid(CXPresumedLoc PLoc);

bool clang_PresumedLoc_isValid(CXPresumedLoc PLoc);

// asserts isValid(); the storage belongs to the SourceManager, not to the caller
const char *clang_PresumedLoc_getFilename(CXPresumedLoc PLoc);

// asserts isValid(); this allocates, call `clang_FileID_dispose` to release
CXFileID clang_PresumedLoc_getFileID(CXPresumedLoc PLoc);

// asserts isValid(); reads a member with no default initializer
unsigned clang_PresumedLoc_getLine(CXPresumedLoc PLoc);

// asserts isValid(); reads a member with no default initializer
unsigned clang_PresumedLoc_getColumn(CXPresumedLoc PLoc);

// asserts isValid()
CXSourceLocation_ clang_PresumedLoc_getIncludeLoc(CXPresumedLoc PLoc);

LLVM_CLANG_C_EXTERN_C_END

#endif