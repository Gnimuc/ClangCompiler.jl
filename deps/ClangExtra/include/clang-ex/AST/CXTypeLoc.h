#ifndef LLVM_CLANG_C_EXTRA_CXTYPELOC_H
#define LLVM_CLANG_C_EXTRA_CXTYPELOC_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// TypeLoc pairs a Type with the source locations where it was written (the floor
// for source-rewriting tools). It is a small by-value object (Type* + opaque
// Data*); crossing the boundary it is heap-boxed, so every CXTypeLoc from
// getTypeLoc / getNextTypeLoc is OWNED and must be released with
// clang_TypeLoc_dispose.
CXTypeLoc clang_TypeSourceInfo_getTypeLoc(CXTypeSourceInfo TSI);

CXQualType clang_TypeLoc_getType(CXTypeLoc TL);

CXSourceLocation_ clang_TypeLoc_getBeginLoc(CXTypeLoc TL);

CXSourceLocation_ clang_TypeLoc_getEndLoc(CXTypeLoc TL);

CXSourceRange_ clang_TypeLoc_getSourceRange(CXTypeLoc TL);

CXSourceRange_ clang_TypeLoc_getLocalSourceRange(CXTypeLoc TL);

// The next TypeLoc in the chain (e.g. a pointer loc's pointee loc); OWNED,
// dispose it. Null (isNull) at the end of the chain.
CXTypeLoc clang_TypeLoc_getNextTypeLoc(CXTypeLoc TL);

bool clang_TypeLoc_isNull(CXTypeLoc TL);

void clang_TypeLoc_dispose(CXTypeLoc TL);

LLVM_CLANG_C_EXTERN_C_END

#endif
