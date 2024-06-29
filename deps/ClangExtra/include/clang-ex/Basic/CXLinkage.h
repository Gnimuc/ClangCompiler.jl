#ifndef LIBCLANGEX_CXLINKAGE_H
#define LIBCLANGEX_CXLINKAGE_H

#ifdef __cplusplus
extern "C" {
#endif

typedef enum CXLinkage : unsigned char {
  CXLinkage_NoLinkage = 0,
  CXLinkage_InternalLinkage,
  CXLinkage_UniqueExternalLinkage,
  CXLinkage_VisibleNoLinkage,
  CXLinkage_ModuleInternalLinkage,
  CXLinkage_ModuleLinkage,
  CXLinkage_ExternalLinkage
} CXLinkage;

typedef enum CXLanguageLinkage {
  CXLanguageLinkage_CLanguageLinkage,
  CXLanguageLinkage_CXXLanguageLinkage,
  CXLanguageLinkage_NoLanguageLinkage
} CXLanguageLinkage;

#ifdef __cplusplus
}
#endif
#endif