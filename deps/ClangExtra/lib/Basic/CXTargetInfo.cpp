#include "clang-ex/Basic/CXTargetInfo.h"
#include "clang/Basic/TargetInfo.h"

CXTargetInfo_ clang_TargetInfo_CreateTargetInfo(CXDiagnosticsEngine DE,
                                                CXTargetOptions Opts) {
  return clang::TargetInfo::CreateTargetInfo(
      *static_cast<clang::DiagnosticsEngine *>(DE),
      std::shared_ptr<clang::TargetOptions>(static_cast<clang::TargetOptions *>(Opts)));
}