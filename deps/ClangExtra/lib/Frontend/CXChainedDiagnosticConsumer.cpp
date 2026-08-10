#include "clang-ex/Frontend/CXChainedDiagnosticConsumer.h"
#include <memory>
#include "clang/Basic/Diagnostic.h"
#include "clang/Frontend/ChainedDiagnosticConsumer.h"

CXDiagnosticConsumer clang_ChainedDiagnosticConsumer_create(
    CXDiagnosticConsumer Primary, CXDiagnosticConsumer Secondary) {
  std::unique_ptr<clang::DiagnosticConsumer> Chain =
      std::make_unique<clang::ChainedDiagnosticConsumer>(
          reinterpret_cast<clang::DiagnosticConsumer *>(Primary),
          std::unique_ptr<clang::DiagnosticConsumer>(
              reinterpret_cast<clang::DiagnosticConsumer *>(Secondary)));
  return reinterpret_cast<CXDiagnosticConsumer>(Chain.release());
}
