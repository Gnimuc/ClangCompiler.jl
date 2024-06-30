#ifndef LLVM_CLANG_C_EXTRA_CXLINKAGE_H
#define LLVM_CLANG_C_EXTRA_CXLINKAGE_H

LLVM_CLANG_C_EXTERN_C_BEGIN

typedef enum CXLinkage : unsigned char {
  CXLinkage_NoLinkage = 0,
  CXLinkage_InternalLinkage,
  CXLinkage_UniqueExternalLinkage,
  CXLinkage_VisibleNoLinkage,
  CXLinkage_ModuleLinkage,
  CXLinkage_ExternalLinkage
} CXLinkage;

typedef enum CXLanguageLinkage {
  CXLanguageLinkage_CLanguageLinkage,
  CXLanguageLinkage_CXXLanguageLinkage,
  CXLanguageLinkage_NoLanguageLinkage
} CXLanguageLinkage;

LLVM_CLANG_C_EXTERN_C_END

#endif