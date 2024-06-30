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

LLVM_CLANG_C_EXTERN_C_END

#endif