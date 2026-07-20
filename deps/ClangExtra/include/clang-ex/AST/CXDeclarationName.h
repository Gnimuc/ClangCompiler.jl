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

// DeclarationNameInfo
//
// A CXDeclarationNameInfo is a heap-boxed clang::DeclarationNameInfo (the value
// type has no opaque pointer encoding). clang_DeclarationNameInfo_create and the
// class-specific producers (clang_FunctionDecl_getNameInfo,
// clang_DeclRefExpr_getNameInfo, clang_MemberExpr_getMemberNameInfo) each return
// an owned box; release it with clang_DeclarationNameInfo_dispose. The getName /
// getLoc / getBeginLoc / getEndLoc accessors return borrowed value encodings.
CXDeclarationNameInfo clang_DeclarationNameInfo_create(CXDeclarationName Name,
                                                       CXSourceLocation_ NameLoc);

void clang_DeclarationNameInfo_dispose(CXDeclarationNameInfo DNInfo);

CXDeclarationName clang_DeclarationNameInfo_getName(CXDeclarationNameInfo DNInfo);

CXSourceLocation_ clang_DeclarationNameInfo_getLoc(CXDeclarationNameInfo DNInfo);

CXSourceLocation_ clang_DeclarationNameInfo_getBeginLoc(CXDeclarationNameInfo DNInfo);

CXSourceLocation_ clang_DeclarationNameInfo_getEndLoc(CXDeclarationNameInfo DNInfo);

CXString clang_DeclarationNameInfo_getAsString(CXDeclarationNameInfo DNInfo);

LLVM_CLANG_C_EXTERN_C_END

#endif