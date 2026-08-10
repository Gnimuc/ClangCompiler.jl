#include "clang-ex/Lex/CXPPConditionalDirectiveRecord.h"

#include "clang/Basic/SourceLocation.h"
#include "clang/Basic/SourceManager.h"
#include "clang/Lex/PPConditionalDirectiveRecord.h"
#include "clang/Lex/Preprocessor.h"

#include <memory>
#include <utility>

namespace {

clang::PPConditionalDirectiveRecord *rec(CXPPConditionalDirectiveRecord R) {
  return reinterpret_cast<clang::PPConditionalDirectiveRecord *>(R);
}

} // namespace

CXPPConditionalDirectiveRecord
clang_PPConditionalDirectiveRecord_create(CXPreprocessor PP) {
  auto *P = reinterpret_cast<clang::Preprocessor *>(PP);
  auto Rec = std::make_unique<clang::PPConditionalDirectiveRecord>(P->getSourceManager());
  auto *Borrowed = Rec.get();
  // ADOPTION: the callback chain owns it from here; the handle we hand back is borrowed.
  P->addPPCallbacks(std::move(Rec));
  return reinterpret_cast<CXPPConditionalDirectiveRecord>(Borrowed);
}

size_t clang_PPConditionalDirectiveRecord_getTotalMemory(CXPPConditionalDirectiveRecord R) {
  return rec(R)->getTotalMemory();
}

CXSourceManager
clang_PPConditionalDirectiveRecord_getSourceManager(CXPPConditionalDirectiveRecord R) {
  return reinterpret_cast<CXSourceManager>(&rec(R)->getSourceManager());
}

bool clang_PPConditionalDirectiveRecord_rangeIntersectsConditionalDirective(
    CXPPConditionalDirectiveRecord R, CXSourceRange_ Range) {
  return rec(R)->rangeIntersectsConditionalDirective(
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(Range.B),
                         clang::SourceLocation::getFromPtrEncoding(Range.E)));
}

CXSourceLocation_ clang_PPConditionalDirectiveRecord_findConditionalDirectiveRegionLoc(
    CXPPConditionalDirectiveRecord R, CXSourceLocation_ Loc) {
  return reinterpret_cast<CXSourceLocation_>(
      rec(R)
          ->findConditionalDirectiveRegionLoc(
              clang::SourceLocation::getFromPtrEncoding(Loc))
          .getPtrEncoding());
}

bool clang_PPConditionalDirectiveRecord_areInDifferentConditionalDirectiveRegion(
    CXPPConditionalDirectiveRecord R, CXSourceLocation_ LHS, CXSourceLocation_ RHS) {
  return rec(R)->areInDifferentConditionalDirectiveRegion(
      clang::SourceLocation::getFromPtrEncoding(LHS),
      clang::SourceLocation::getFromPtrEncoding(RHS));
}
