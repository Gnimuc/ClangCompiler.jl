#include "clang-ex/AST/CXTypeLoc.h"

#include "clang/AST/TypeLoc.h"

CXTypeLoc clang_TypeSourceInfo_getTypeLoc(CXTypeSourceInfo TSI) {
  return new clang::TypeLoc( // NOLINT(*-owning-memory)
      static_cast<clang::TypeSourceInfo *>(TSI)->getTypeLoc());
}

CXQualType clang_TypeLoc_getType(CXTypeLoc TL) {
  return static_cast<clang::TypeLoc *>(TL)->getType().getAsOpaquePtr();
}

CXSourceLocation_ clang_TypeLoc_getBeginLoc(CXTypeLoc TL) {
  return static_cast<clang::TypeLoc *>(TL)->getBeginLoc().getPtrEncoding();
}

CXSourceLocation_ clang_TypeLoc_getEndLoc(CXTypeLoc TL) {
  return static_cast<clang::TypeLoc *>(TL)->getEndLoc().getPtrEncoding();
}

CXSourceRange_ clang_TypeLoc_getSourceRange(CXTypeLoc TL) {
  clang::SourceRange R = static_cast<clang::TypeLoc *>(TL)->getSourceRange();
  return CXSourceRange_{R.getBegin().getPtrEncoding(), R.getEnd().getPtrEncoding()};
}

CXSourceRange_ clang_TypeLoc_getLocalSourceRange(CXTypeLoc TL) {
  clang::SourceRange R = static_cast<clang::TypeLoc *>(TL)->getLocalSourceRange();
  return CXSourceRange_{R.getBegin().getPtrEncoding(), R.getEnd().getPtrEncoding()};
}

CXTypeLoc clang_TypeLoc_getNextTypeLoc(CXTypeLoc TL) {
  return new clang::TypeLoc( // NOLINT(*-owning-memory)
      static_cast<clang::TypeLoc *>(TL)->getNextTypeLoc());
}

bool clang_TypeLoc_isNull(CXTypeLoc TL) {
  return static_cast<clang::TypeLoc *>(TL)->isNull();
}

void clang_TypeLoc_dispose(CXTypeLoc TL) {
  delete static_cast<clang::TypeLoc *>(TL); // NOLINT(*-owning-memory)
}
