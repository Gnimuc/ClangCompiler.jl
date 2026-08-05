#include "clang-ex/Sema/CXTemplateDeduction.h"

#include "clang/Basic/SourceLocation.h"
#include "clang/Sema/TemplateDeduction.h"

CXTemplateDeductionInfo clang_TemplateDeductionInfo_create(CXSourceLocation_ Loc,
                                                           unsigned DeducedDepth) {
  return new clang::sema::TemplateDeductionInfo( // NOLINT(*-owning-memory)
      clang::SourceLocation::getFromPtrEncoding(Loc), DeducedDepth);
}

void clang_TemplateDeductionInfo_dispose(CXTemplateDeductionInfo Info) {
  delete static_cast<clang::sema::TemplateDeductionInfo *>(Info); // NOLINT(*-owning-memory)
}

CXSourceLocation_ clang_TemplateDeductionInfo_getLocation(CXTemplateDeductionInfo Info) {
  return static_cast<clang::sema::TemplateDeductionInfo *>(Info)
      ->getLocation()
      .getPtrEncoding();
}

unsigned clang_TemplateDeductionInfo_getDeducedDepth(CXTemplateDeductionInfo Info) {
  return static_cast<clang::sema::TemplateDeductionInfo *>(Info)->getDeducedDepth();
}

unsigned clang_TemplateDeductionInfo_getNumExplicitArgs(CXTemplateDeductionInfo Info) {
  return static_cast<clang::sema::TemplateDeductionInfo *>(Info)->getNumExplicitArgs();
}

bool clang_TemplateDeductionInfo_hasSFINAEDiagnostic(CXTemplateDeductionInfo Info) {
  return static_cast<clang::sema::TemplateDeductionInfo *>(Info)->hasSFINAEDiagnostic();
}

CXTemplateArgumentList
clang_TemplateDeductionInfo_takeSugared(CXTemplateDeductionInfo Info) {
  return static_cast<clang::sema::TemplateDeductionInfo *>(Info)->takeSugared();
}

CXTemplateArgumentList
clang_TemplateDeductionInfo_takeCanonical(CXTemplateDeductionInfo Info) {
  return static_cast<clang::sema::TemplateDeductionInfo *>(Info)->takeCanonical();
}

unsigned clang_TemplateDeductionInfo_getCallArgIndex(CXTemplateDeductionInfo Info) {
  return static_cast<clang::sema::TemplateDeductionInfo *>(Info)->CallArgIndex;
}
