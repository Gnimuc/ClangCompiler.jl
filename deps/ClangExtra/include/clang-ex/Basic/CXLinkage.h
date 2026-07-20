#ifndef LLVM_CLANG_C_EXTRA_CXLINKAGE_H
#define LLVM_CLANG_C_EXTRA_CXLINKAGE_H

LLVM_CLANG_C_EXTERN_C_BEGIN

typedef enum CXLinkage : unsigned char {
  CXLinkage_Invalid = 0,
  CXLinkage_None,
  CXLinkage_Internal,
  CXLinkage_UniqueExternal,
  CXLinkage_VisibleNone,
  CXLinkage_Module,
  CXLinkage_External
} CXLinkage;

typedef enum CXLanguageLinkage {
  CXLanguageLinkage_CLanguageLinkage,
  CXLanguageLinkage_CXXLanguageLinkage,
  CXLanguageLinkage_NoLanguageLinkage
} CXLanguageLinkage;

LLVM_CLANG_C_EXTERN_C_END

#endif