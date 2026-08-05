#include "clang-ex/Basic/CXSourceLocation.h"
#include "utils.h"
#include "clang/Basic/SourceLocation.h"
#include "clang/Basic/SourceManager.h"

uint32_t clang_SourceLocation_getRawEncoding(CXSourceLocation_ Loc) {
  return clang::SourceLocation::getFromPtrEncoding(Loc).getRawEncoding();
}

CXSourceLocation_ clang_SourceLocation_getFromRawEncoding(uint32_t Encoding) {
  return reinterpret_cast<CXSourceLocation_>(clang::SourceLocation::getFromRawEncoding(Encoding).getPtrEncoding());
}

CXString clang_SourceRange_printToString(CXSourceRange_ R, CXSourceManager SM) {
  clang::SourceRange SR(clang::SourceLocation::getFromPtrEncoding(R.B),
                        clang::SourceLocation::getFromPtrEncoding(R.E));
  return extra::makeCXString(SR.printToString(*reinterpret_cast<clang::SourceManager *>(SM)));
}

void clang_SourceRange_dump(CXSourceRange_ R, CXSourceManager SM) {
  clang::SourceRange SR(clang::SourceLocation::getFromPtrEncoding(R.B),
                        clang::SourceLocation::getFromPtrEncoding(R.E));
  SR.dump(*reinterpret_cast<clang::SourceManager *>(SM));
}

CXSourceLocation_ clang_SourceLocation_createInvalid(void) {
  return reinterpret_cast<CXSourceLocation_>(clang::SourceLocation().getPtrEncoding());
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
      *reinterpret_cast<clang::SourceManager *>(SM));
}

CXString clang_SourceLocation_printToString(CXSourceLocation_ Loc, CXSourceManager SM) {
  return extra::makeCXString(clang::SourceLocation::getFromPtrEncoding(Loc).printToString(
      *reinterpret_cast<clang::SourceManager *>(SM)));
}

CXSourceLocation_ clang_SourceLocation_getLocWithOffset(CXSourceLocation_ Loc, int Offset) {
  return reinterpret_cast<CXSourceLocation_>(clang::SourceLocation::getFromPtrEncoding(Loc)
      .getLocWithOffset(Offset)
      .getPtrEncoding());
}

CXPresumedLoc clang_PresumedLoc_create(CXSourceManager SM, CXSourceLocation_ Loc,
                                       bool UseLineDirectives) {
  return reinterpret_cast<CXPresumedLoc>(std::make_unique<clang::PresumedLoc>(
             reinterpret_cast<clang::SourceManager *>(SM)->getPresumedLoc(
                 clang::SourceLocation::getFromPtrEncoding(Loc), UseLineDirectives))
      .release());
}

void clang_PresumedLoc_dispose(CXPresumedLoc PLoc) {
  delete reinterpret_cast<clang::PresumedLoc *>(PLoc);
}

bool clang_PresumedLoc_isInvalid(CXPresumedLoc PLoc) {
  return reinterpret_cast<clang::PresumedLoc *>(PLoc)->isInvalid();
}

bool clang_PresumedLoc_isValid(CXPresumedLoc PLoc) {
  return reinterpret_cast<clang::PresumedLoc *>(PLoc)->isValid();
}

const char *clang_PresumedLoc_getFilename(CXPresumedLoc PLoc) {
  return reinterpret_cast<clang::PresumedLoc *>(PLoc)->getFilename();
}

CXFileID clang_PresumedLoc_getFileID(CXPresumedLoc PLoc) {
  return reinterpret_cast<CXFileID>(std::make_unique<clang::FileID>(
             reinterpret_cast<clang::PresumedLoc *>(PLoc)->getFileID())
      .release());
}

unsigned clang_PresumedLoc_getLine(CXPresumedLoc PLoc) {
  return reinterpret_cast<clang::PresumedLoc *>(PLoc)->getLine();
}

unsigned clang_PresumedLoc_getColumn(CXPresumedLoc PLoc) {
  return reinterpret_cast<clang::PresumedLoc *>(PLoc)->getColumn();
}

CXSourceLocation_ clang_PresumedLoc_getIncludeLoc(CXPresumedLoc PLoc) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::PresumedLoc *>(PLoc)->getIncludeLoc().getPtrEncoding());
}
