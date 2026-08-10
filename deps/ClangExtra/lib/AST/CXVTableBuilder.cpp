#include "clang-ex/AST/CXVTableBuilder.h"

#include "clang/AST/CharUnits.h"
#include "clang/AST/DeclCXX.h"
#include "clang/AST/GlobalDecl.h"
#include "clang/AST/VTableBuilder.h"
#include "clang/Basic/ABI.h"

namespace {

clang::VTableComponent *component(CXVTableComponent C) {
  return reinterpret_cast<clang::VTableComponent *>(C);
}

clang::VTableLayout *layout(CXVTableLayout L) {
  return reinterpret_cast<clang::VTableLayout *>(L);
}

clang::ItaniumVTableContext *itanium(CXItaniumVTableContext VTC) {
  return reinterpret_cast<clang::ItaniumVTableContext *>(VTC);
}

} // namespace

// VTableComponent
CXVTableComponent_Kind clang_VTableComponent_getKind(CXVTableComponent C) {
  return static_cast<CXVTableComponent_Kind>(component(C)->getKind());
}

int64_t clang_VTableComponent_getVCallOffset(CXVTableComponent C) {
  return component(C)->getVCallOffset().getQuantity();
}

int64_t clang_VTableComponent_getVBaseOffset(CXVTableComponent C) {
  return component(C)->getVBaseOffset().getQuantity();
}

int64_t clang_VTableComponent_getOffsetToTop(CXVTableComponent C) {
  return component(C)->getOffsetToTop().getQuantity();
}

CXCXXRecordDecl clang_VTableComponent_getRTTIDecl(CXVTableComponent C) {
  return reinterpret_cast<CXCXXRecordDecl>(
      const_cast<clang::CXXRecordDecl *>(component(C)->getRTTIDecl()));
}

CXCXXMethodDecl clang_VTableComponent_getFunctionDecl(CXVTableComponent C) {
  return reinterpret_cast<CXCXXMethodDecl>(
      const_cast<clang::CXXMethodDecl *>(component(C)->getFunctionDecl()));
}

CXCXXDestructorDecl clang_VTableComponent_getDestructorDecl(CXVTableComponent C) {
  return reinterpret_cast<CXCXXDestructorDecl>(
      const_cast<clang::CXXDestructorDecl *>(component(C)->getDestructorDecl()));
}

CXCXXMethodDecl clang_VTableComponent_getUnusedFunctionDecl(CXVTableComponent C) {
  return reinterpret_cast<CXCXXMethodDecl>(
      const_cast<clang::CXXMethodDecl *>(component(C)->getUnusedFunctionDecl()));
}

bool clang_VTableComponent_isDestructorKind(CXVTableComponent C) {
  return component(C)->isDestructorKind();
}

bool clang_VTableComponent_isUsedFunctionPointerKind(CXVTableComponent C) {
  return component(C)->isUsedFunctionPointerKind();
}

bool clang_VTableComponent_isFunctionPointerKind(CXVTableComponent C) {
  return component(C)->isFunctionPointerKind();
}

bool clang_VTableComponent_isRTTIKind(CXVTableComponent C) {
  return component(C)->isRTTIKind();
}

// getGlobalDecl

// VTableLayout
unsigned clang_VTableLayout_getNumVTableComponents(CXVTableLayout L) {
  return static_cast<unsigned>(layout(L)->vtable_components().size());
}

CXVTableComponent clang_VTableLayout_getVTableComponent(CXVTableLayout L, unsigned I) {
  llvm::ArrayRef<clang::VTableComponent> Components = layout(L)->vtable_components();
  if (I >= Components.size())
    return nullptr;
  return reinterpret_cast<CXVTableComponent>(
      const_cast<clang::VTableComponent *>(&Components[I]));
}

// vtable_thunks
// getAddressPoint
// getAddressPoints
// getAddressPointIndices

size_t clang_VTableLayout_getNumVTables(CXVTableLayout L) {
  return layout(L)->getNumVTables();
}

size_t clang_VTableLayout_getVTableOffset(CXVTableLayout L, size_t I) {
  return layout(L)->getVTableOffset(I);
}

size_t clang_VTableLayout_getVTableSize(CXVTableLayout L, size_t I) {
  return layout(L)->getVTableSize(I);
}

// VTableContextBase
bool clang_VTableContextBase_isMicrosoft(CXVTableContextBase VTC) {
  return reinterpret_cast<clang::VTableContextBase *>(VTC)->isMicrosoft();
}

bool clang_VTableContextBase_hasVtableSlot(CXCXXMethodDecl MD) {
  return clang::VTableContextBase::hasVtableSlot(
      reinterpret_cast<clang::CXXMethodDecl *>(MD));
}

// getThunkInfo

CXItaniumVTableContext
clang_VTableContextBase_castToItaniumVTableContext(CXVTableContextBase VTC) {
  return reinterpret_cast<CXItaniumVTableContext>(
      llvm::dyn_cast_or_null<clang::ItaniumVTableContext>(
          reinterpret_cast<clang::VTableContextBase *>(VTC)));
}

// ItaniumVTableContext
CXVTableLayout clang_ItaniumVTableContext_getVTableLayout(CXItaniumVTableContext VTC,
                                                          CXCXXRecordDecl RD) {
  return reinterpret_cast<CXVTableLayout>(const_cast<clang::VTableLayout *>(
      &itanium(VTC)->getVTableLayout(reinterpret_cast<clang::CXXRecordDecl *>(RD))));
}

// createConstructionVTableLayout

uint64_t clang_ItaniumVTableContext_getMethodVTableIndex(CXItaniumVTableContext VTC,
                                                         CXCXXMethodDecl MD) {
  return itanium(VTC)->getMethodVTableIndex(
      clang::GlobalDecl(reinterpret_cast<clang::CXXMethodDecl *>(MD)));
}

uint64_t
clang_ItaniumVTableContext_getMethodVTableIndexForDtor(CXItaniumVTableContext VTC,
                                                       CXCXXDestructorDecl D,
                                                       CXCXXDtorType DtorKind) {
  return itanium(VTC)->getMethodVTableIndex(
      clang::GlobalDecl(reinterpret_cast<clang::CXXDestructorDecl *>(D),
                        static_cast<clang::CXXDtorType>(DtorKind)));
}

uint64_t
clang_ItaniumVTableContext_getMethodVTableIndexForCtor(CXItaniumVTableContext VTC,
                                                       CXCXXConstructorDecl D,
                                                       CXCXXCtorType CtorKind) {
  return itanium(VTC)->getMethodVTableIndex(
      clang::GlobalDecl(reinterpret_cast<clang::CXXConstructorDecl *>(D),
                        static_cast<clang::CXXCtorType>(CtorKind)));
}

int64_t clang_ItaniumVTableContext_getVirtualBaseOffsetOffset(CXItaniumVTableContext VTC,
                                                              CXCXXRecordDecl RD,
                                                              CXCXXRecordDecl VBase) {
  return itanium(VTC)
      ->getVirtualBaseOffsetOffset(reinterpret_cast<clang::CXXRecordDecl *>(RD),
                                   reinterpret_cast<clang::CXXRecordDecl *>(VBase))
      .getQuantity();
}

CXItaniumVTableContext_VTableComponentLayout
clang_ItaniumVTableContext_getVTableComponentLayout(CXItaniumVTableContext VTC) {
  return static_cast<CXItaniumVTableContext_VTableComponentLayout>(
      itanium(VTC)->getVTableComponentLayout());
}

bool clang_ItaniumVTableContext_isPointerLayout(CXItaniumVTableContext VTC) {
  return itanium(VTC)->isPointerLayout();
}

bool clang_ItaniumVTableContext_isRelativeLayout(CXItaniumVTableContext VTC) {
  return itanium(VTC)->isRelativeLayout();
}

// VPtrInfo
// MicrosoftVTableContext
