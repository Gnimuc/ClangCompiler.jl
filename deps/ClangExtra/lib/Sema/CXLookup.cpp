#include "clang-ex/Sema/CXLookup.h"
#include "clang/Sema/Lookup.h"
#include <cstdio>

CXLookupResult clang_LookupResult_create(CXSema S, CXDeclarationName Name,
                                         CXSourceLocation_ NameLoc,
                                         CXLookupNameKind LookupKind,
                                         CXInit_Error *ErrorCode) {
  CXInit_Error Err = CXInit_NoError;
  std::unique_ptr<clang::LookupResult> ptr = std::make_unique<clang::LookupResult>(
      *static_cast<clang::Sema *>(S), clang::DeclarationName::getFromOpaquePtr(Name),
      clang::SourceLocation::getFromPtrEncoding(NameLoc),
      static_cast<clang::Sema::LookupNameKind>(LookupKind));

  if (!ptr) {
    fprintf(stderr, "LIBCLANGEX ERROR: failed to create `clang::LookupResult`\n");
    Err = CXInit_CanNotCreate;
  }

  if (ErrorCode)
    *ErrorCode = Err;

  return ptr.release();
}

void clang_LookupResult_dispose(CXLookupResult LR) {
  delete static_cast<clang::LookupResult *>(LR);
}

void clang_LookupResult_clear(CXLookupResult LR, CXLookupNameKind LookupKind) {
  static_cast<clang::LookupResult *>(LR)->clear(
      static_cast<clang::Sema::LookupNameKind>(LookupKind));
}

void clang_LookupResult_dump(CXLookupResult LR) {
  static_cast<clang::LookupResult *>(LR)->dump();
}

bool clang_LookupResult_empty(CXLookupResult LR) {
  return static_cast<clang::LookupResult *>(LR)->empty();
}

CXNamedDecl clang_LookupResult_getRepresentativeDecl(CXLookupResult LR) {
  return static_cast<clang::LookupResult *>(LR)->getRepresentativeDecl();
}

void clang_LookupResult_setLookupName(CXLookupResult LR, CXDeclarationName DN) {
  static_cast<clang::LookupResult *>(LR)->setLookupName(
      clang::DeclarationName::getFromOpaquePtr(DN));
}

CXDeclarationName clang_LookupResult_getLookupName(CXLookupResult LR) {
  return static_cast<clang::LookupResult *>(LR)->getLookupName().getAsOpaquePtr();
}