#include "clang-ex/Frontend/CXVerifyDiagnosticConsumer.h"
#include <memory>
#include "clang/Basic/Diagnostic.h"
#include "clang/Frontend/VerifyDiagnosticConsumer.h"

CXDiagnosticConsumer clang_VerifyDiagnosticConsumer_create(CXDiagnosticsEngine Diags) {
  std::unique_ptr<clang::DiagnosticConsumer> DC =
      std::make_unique<clang::VerifyDiagnosticConsumer>(
          *reinterpret_cast<clang::DiagnosticsEngine *>(Diags));
  return reinterpret_cast<CXDiagnosticConsumer>(DC.release());
}
