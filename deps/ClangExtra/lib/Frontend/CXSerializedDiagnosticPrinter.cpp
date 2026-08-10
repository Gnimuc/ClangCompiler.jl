#include "clang-ex/Frontend/CXSerializedDiagnosticPrinter.h"
#include "clang/Basic/Diagnostic.h"
#include "clang/Basic/DiagnosticOptions.h"
#include "clang/Frontend/SerializedDiagnosticPrinter.h"

CXDiagnosticConsumer clang_serialized_diags_create(const char *OutputFile,
                                                   CXDiagnosticOptions Diags,
                                                   bool MergeChildRecords) {
  auto DC = clang::serialized_diags::create(
      llvm::StringRef(OutputFile), reinterpret_cast<clang::DiagnosticOptions *>(Diags),
      MergeChildRecords);
  return reinterpret_cast<CXDiagnosticConsumer>(DC.release());
}
