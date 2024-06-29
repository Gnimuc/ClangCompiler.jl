#include "clang-ex/Basic/CXSourceLocation.h"
#include "libclang/CXString.h"
#include "clang/Basic/SourceLocation.h"

CXSourceLocation_ clang_SourceLocation_createInvalid(void) {
  return clang::SourceLocation().getPtrEncoding();
}

bool clang_SourceLocation_isFileID(CXSourceLocation_ Loc) {
  return clang::SourceLocation::getFromPtrEncoding(Loc).isFileID();
}

bool clang_SourceLocation_isMacroID(CXSourceLocation_ Loc) {
  return clang::SourceLocation::getFromPtrEncoding(Loc).isMacroID();
}

bool clang_SourceLocation_isValid(CXSourceLocation_ Loc) {
  return clang::SourceLocation::getFromPtrEncoding(Loc).isValid();
}

bool clang_SourceLocation_isInvalid(CXSourceLocation_ Loc) {
  return clang::SourceLocation::getFromPtrEncoding(Loc).isInvalid();
}

bool clang_SourceLocation_isPairOfFileLocations(CXSourceLocation_ Start,
                                                CXSourceLocation_ End) {
  return clang::SourceLocation::isPairOfFileLocations(
      clang::SourceLocation::getFromPtrEncoding(Start),
      clang::SourceLocation::getFromPtrEncoding(End));
}

unsigned clang_SourceLocation_getHashValue(CXSourceLocation_ Loc) {
  return clang::SourceLocation::getFromPtrEncoding(Loc).getHashValue();
}

void clang_SourceLocation_dump(CXSourceLocation_ Loc, CXSourceManager SM) {
  return clang::SourceLocation::getFromPtrEncoding(Loc).dump(
      *static_cast<clang::SourceManager *>(SM));
}

CXString clang_SourceLocation_printToString(CXSourceLocation_ Loc, CXSourceManager SM) {
  return clang::cxstring::createDup(
      clang::SourceLocation::getFromPtrEncoding(Loc).printToString(
          *static_cast<clang::SourceManager *>(SM)));
}

CXSourceLocation_ clang_SourceLocation_getLocWithOffset(CXSourceLocation_ Loc, int Offset) {
  return clang::SourceLocation::getFromPtrEncoding(Loc)
      .getLocWithOffset(Offset)
      .getPtrEncoding();
}
