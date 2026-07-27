#include "clang-ex/Basic/CXSourceLocation.h"
#include "utils.h"
#include "clang/Basic/SourceLocation.h"
#include "clang/Basic/SourceManager.h"

uint32_t clang_SourceLocation_getRawEncoding(CXSourceLocation_ Loc) {
  return clang::SourceLocation::getFromPtrEncoding(Loc).getRawEncoding();
}

CXSourceLocation_ clang_SourceLocation_getFromRawEncoding(uint32_t Encoding) {
  return clang::SourceLocation::getFromRawEncoding(Encoding).getPtrEncoding();
}

CXString clang_SourceRange_printToString(CXSourceRange_ R, CXSourceManager SM) {
  clang::SourceRange SR(clang::SourceLocation::getFromPtrEncoding(R.B),
                        clang::SourceLocation::getFromPtrEncoding(R.E));
  return extra::makeCXString(SR.printToString(*static_cast<clang::SourceManager *>(SM)));
}

void clang_SourceRange_dump(CXSourceRange_ R, CXSourceManager SM) {
  clang::SourceRange SR(clang::SourceLocation::getFromPtrEncoding(R.B),
                        clang::SourceLocation::getFromPtrEncoding(R.E));
  SR.dump(*static_cast<clang::SourceManager *>(SM));
}

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
  return extra::makeCXString(clang::SourceLocation::getFromPtrEncoding(Loc).printToString(
      *static_cast<clang::SourceManager *>(SM)));
}

CXSourceLocation_ clang_SourceLocation_getLocWithOffset(CXSourceLocation_ Loc, int Offset) {
  return clang::SourceLocation::getFromPtrEncoding(Loc)
      .getLocWithOffset(Offset)
      .getPtrEncoding();
}

CXPresumedLoc clang_PresumedLoc_create(CXSourceManager SM, CXSourceLocation_ Loc,
                                       bool UseLineDirectives) {
  return std::make_unique<clang::PresumedLoc>(
             static_cast<clang::SourceManager *>(SM)->getPresumedLoc(
                 clang::SourceLocation::getFromPtrEncoding(Loc), UseLineDirectives))
      .release();
}

void clang_PresumedLoc_dispose(CXPresumedLoc PLoc) {
  delete static_cast<clang::PresumedLoc *>(PLoc);
}

bool clang_PresumedLoc_isInvalid(CXPresumedLoc PLoc) {
  return static_cast<clang::PresumedLoc *>(PLoc)->isInvalid();
}

bool clang_PresumedLoc_isValid(CXPresumedLoc PLoc) {
  return static_cast<clang::PresumedLoc *>(PLoc)->isValid();
}

const char *clang_PresumedLoc_getFilename(CXPresumedLoc PLoc) {
  return static_cast<clang::PresumedLoc *>(PLoc)->getFilename();
}

CXFileID clang_PresumedLoc_getFileID(CXPresumedLoc PLoc) {
  return std::make_unique<clang::FileID>(
             static_cast<clang::PresumedLoc *>(PLoc)->getFileID())
      .release();
}

unsigned clang_PresumedLoc_getLine(CXPresumedLoc PLoc) {
  return static_cast<clang::PresumedLoc *>(PLoc)->getLine();
}

unsigned clang_PresumedLoc_getColumn(CXPresumedLoc PLoc) {
  return static_cast<clang::PresumedLoc *>(PLoc)->getColumn();
}

CXSourceLocation_ clang_PresumedLoc_getIncludeLoc(CXPresumedLoc PLoc) {
  return static_cast<clang::PresumedLoc *>(PLoc)->getIncludeLoc().getPtrEncoding();
}
