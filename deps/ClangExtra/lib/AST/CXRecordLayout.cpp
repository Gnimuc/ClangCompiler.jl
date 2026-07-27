#include "clang-ex/AST/CXRecordLayout.h"
#include "clang/AST/DeclCXX.h"
#include "clang/AST/RecordLayout.h"

int64_t clang_ASTRecordLayout_getAlignment(CXASTRecordLayout RL) {
  return static_cast<clang::ASTRecordLayout *>(RL)->getAlignment().getQuantity();
}

int64_t clang_ASTRecordLayout_getPreferredAlignment(CXASTRecordLayout RL) {
  return static_cast<clang::ASTRecordLayout *>(RL)->getPreferredAlignment().getQuantity();
}

int64_t clang_ASTRecordLayout_getUnadjustedAlignment(CXASTRecordLayout RL) {
  return static_cast<clang::ASTRecordLayout *>(RL)->getUnadjustedAlignment().getQuantity();
}

int64_t clang_ASTRecordLayout_getRequiredAlignment(CXASTRecordLayout RL) {
  return static_cast<clang::ASTRecordLayout *>(RL)->getRequiredAlignment().getQuantity();
}

int64_t clang_ASTRecordLayout_getSize(CXASTRecordLayout RL) {
  return static_cast<clang::ASTRecordLayout *>(RL)->getSize().getQuantity();
}

unsigned clang_ASTRecordLayout_getFieldCount(CXASTRecordLayout RL) {
  return static_cast<clang::ASTRecordLayout *>(RL)->getFieldCount();
}

uint64_t clang_ASTRecordLayout_getFieldOffset(CXASTRecordLayout RL, unsigned FieldNo) {
  return static_cast<clang::ASTRecordLayout *>(RL)->getFieldOffset(FieldNo);
}

int64_t clang_ASTRecordLayout_getDataSize(CXASTRecordLayout RL) {
  return static_cast<clang::ASTRecordLayout *>(RL)->getDataSize().getQuantity();
}

int64_t clang_ASTRecordLayout_getNonVirtualSize(CXASTRecordLayout RL) {
  return static_cast<clang::ASTRecordLayout *>(RL)->getNonVirtualSize().getQuantity();
}

int64_t clang_ASTRecordLayout_getNonVirtualAlignment(CXASTRecordLayout RL) {
  return static_cast<clang::ASTRecordLayout *>(RL)->getNonVirtualAlignment().getQuantity();
}

int64_t clang_ASTRecordLayout_getPreferredNVAlignment(CXASTRecordLayout RL) {
  return static_cast<clang::ASTRecordLayout *>(RL)->getPreferredNVAlignment().getQuantity();
}

int64_t clang_ASTRecordLayout_getSizeOfLargestEmptySubobject(CXASTRecordLayout RL) {
  return static_cast<clang::ASTRecordLayout *>(RL)
      ->getSizeOfLargestEmptySubobject()
      .getQuantity();
}

int64_t clang_ASTRecordLayout_getBaseClassOffset(CXASTRecordLayout RL,
                                                 CXCXXRecordDecl Base) {
  return static_cast<clang::ASTRecordLayout *>(RL)
      ->getBaseClassOffset(static_cast<clang::CXXRecordDecl *>(Base))
      .getQuantity();
}

int64_t clang_ASTRecordLayout_getVBaseClassOffset(CXASTRecordLayout RL,
                                                  CXCXXRecordDecl VBase) {
  return static_cast<clang::ASTRecordLayout *>(RL)
      ->getVBaseClassOffset(static_cast<clang::CXXRecordDecl *>(VBase))
      .getQuantity();
}

int64_t clang_ASTRecordLayout_getVBPtrOffset(CXASTRecordLayout RL) {
  return static_cast<clang::ASTRecordLayout *>(RL)->getVBPtrOffset().getQuantity();
}

bool clang_ASTRecordLayout_hasOwnVFPtr(CXASTRecordLayout RL) {
  return static_cast<clang::ASTRecordLayout *>(RL)->hasOwnVFPtr();
}

bool clang_ASTRecordLayout_hasExtendableVFPtr(CXASTRecordLayout RL) {
  return static_cast<clang::ASTRecordLayout *>(RL)->hasExtendableVFPtr();
}

bool clang_ASTRecordLayout_hasOwnVBPtr(CXASTRecordLayout RL) {
  return static_cast<clang::ASTRecordLayout *>(RL)->hasOwnVBPtr();
}

bool clang_ASTRecordLayout_hasVBPtr(CXASTRecordLayout RL) {
  return static_cast<clang::ASTRecordLayout *>(RL)->hasVBPtr();
}
