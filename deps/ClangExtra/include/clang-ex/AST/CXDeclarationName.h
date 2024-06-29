#ifndef LLVM_CLANG_C_EXTRA_CXDECLARATIONNAME_H
#define LLVM_CLANG_C_EXTRA_CXDECLARATIONNAME_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

CXDeclarationName clang_DeclarationName_create(void);

CXDeclarationName clang_DeclarationName_createFromIdentifierInfo(CXIdentifierInfo IDInfo);

void clang_DeclarationName_dump(CXDeclarationName DN);

bool clang_DeclarationName_isEmpty(CXDeclarationName DN);

CXString clang_DeclarationName_getAsString(CXDeclarationName DN);

LLVM_CLANG_C_EXTERN_C_END

#endif