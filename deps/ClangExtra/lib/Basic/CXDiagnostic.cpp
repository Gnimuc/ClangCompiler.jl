#include "clang-ex/Basic/CXDiagnostic.h"
#include "clang/Basic/Diagnostic.h"

// DiagnosticConsumer
CXDiagnosticConsumer clang_IgnoringDiagConsumer_create(CXInit_Error *ErrorCode) {
  CXInit_Error Err = CXInit_NoError;
  std::unique_ptr<clang::DiagnosticConsumer> ptr =
      std::make_unique<clang::IgnoringDiagConsumer>();

  if (!ptr) {
    fprintf(stderr, "LIBCLANGEX ERROR: failed to create `clang::IgnoringDiagConsumer`\n");
    Err = CXInit_CanNotCreate;
  }

  if (ErrorCode)
    *ErrorCode = Err;

  return ptr.release();
}

void clang_DiagnosticConsumer_dispose(CXDiagnosticConsumer DC) {
  delete static_cast<clang::DiagnosticConsumer *>(DC);
}

void clang_DiagnosticConsumer_BeginSourceFile(CXDiagnosticConsumer DC,
                                              CXLangOptions LangOpts, CXPreprocessor PP) {
  static_cast<clang::DiagnosticConsumer *>(DC)->BeginSourceFile(
      *static_cast<clang::LangOptions *>(LangOpts), static_cast<clang::Preprocessor *>(PP));
}

void clang_DiagnosticConsumer_EndSourceFile(CXDiagnosticConsumer DC) {
  static_cast<clang::DiagnosticConsumer *>(DC)->EndSourceFile();
}

// DiagnosticsEngine
CXDiagnosticsEngine clang_DiagnosticsEngine_create(CXDiagnosticIDs ID,
                                                   CXDiagnosticOptions DO,
                                                   CXDiagnosticConsumer DC,
                                                   bool ShouldOwnClient,
                                                   CXInit_Error *ErrorCode) {
  CXInit_Error Err = CXInit_NoError;
  std::unique_ptr<clang::DiagnosticsEngine> ptr =
      std::make_unique<clang::DiagnosticsEngine>(
          llvm::IntrusiveRefCntPtr<clang::DiagnosticIDs>(
              static_cast<clang::DiagnosticIDs *>(ID)),
          llvm::IntrusiveRefCntPtr<clang::DiagnosticOptions>(
              static_cast<clang::DiagnosticOptions *>(DO)),
          static_cast<clang::DiagnosticConsumer *>(DC), ShouldOwnClient);

  if (!ptr) {
    fprintf(stderr, "LIBCLANGEX ERROR: failed to create `clang::DiagnosticsEngine`\n");
    Err = CXInit_CanNotCreate;
  }

  if (ErrorCode)
    *ErrorCode = Err;

  return ptr.release();
}

void clang_DiagnosticsEngine_dispose(CXDiagnosticsEngine DE) {
  delete static_cast<clang::DiagnosticsEngine *>(DE);
}

void clang_DiagnosticsEngine_setShowColors(CXDiagnosticsEngine DE, bool ShowColors) {
  static_cast<clang::DiagnosticsEngine *>(DE)->setShowColors(ShowColors);
}