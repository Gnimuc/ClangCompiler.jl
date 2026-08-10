#include "clang-ex/Tooling/DependencyScanning/CXDependencyScanningTool.h"

#include "utils.h"

#include "clang/Tooling/DependencyScanning/DependencyScanningService.h"
#include "clang/Tooling/DependencyScanning/DependencyScanningTool.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Support/Error.h"

#include <memory>
#include <string>
#include <vector>

CXDependencyScanningTool
clang_DependencyScanningTool_create(CXDependencyScanningService Service) {
  return reinterpret_cast<CXDependencyScanningTool>(
      std::make_unique<clang::tooling::dependencies::DependencyScanningTool>(
          *reinterpret_cast<clang::tooling::dependencies::DependencyScanningService *>(
              Service))
          .release());
}

void clang_DependencyScanningTool_dispose(CXDependencyScanningTool T) {
  delete reinterpret_cast<clang::tooling::dependencies::DependencyScanningTool *>(T);
}

CXString clang_DependencyScanningTool_getDependencyFile(CXDependencyScanningTool T,
                                                        const char **CommandLine,
                                                        unsigned NumArgs, const char *CWD,
                                                        bool *OutSuccess) {
  std::vector<std::string> Args;
  Args.reserve(NumArgs);
  for (unsigned I = 0; I < NumArgs; ++I)
    Args.emplace_back(CommandLine[I]);

  llvm::Expected<std::string> Result =
      reinterpret_cast<clang::tooling::dependencies::DependencyScanningTool *>(T)
          ->getDependencyFile(Args, llvm::StringRef(CWD));
  if (!Result) {
    std::string Msg = llvm::toString(Result.takeError());
    if (OutSuccess)
      *OutSuccess = false;
    return extra::makeCXString(Msg);
  }
  if (OutSuccess)
    *OutSuccess = true;
  return extra::makeCXString(*Result);
}
