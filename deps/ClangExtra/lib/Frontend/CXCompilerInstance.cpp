#include "clang-ex/Frontend/CXCompilerInstance.h"
#include "clang/Basic/TargetInfo.h"
#include "clang/CodeGen/ModuleBuilder.h"
#include "clang/Frontend/CompilerInstance.h"
#include "clang/Lex/Preprocessor.h"
#include "llvm/Support/VirtualFileSystem.h"
#include <cstdio>

CXCompilerInstance clang_CompilerInstance_create(CXInit_Error *ErrorCode) {
  CXInit_Error Err = CXInit_NoError;
  std::unique_ptr<clang::CompilerInstance> ptr =
      std::make_unique<clang::CompilerInstance>();

  if (!ptr) {
    fprintf(stderr, "LIBCLANGEX ERROR: failed to create `clang::CompilerInstance`\n");
    Err = CXInit_CanNotCreate;
  }

  if (ErrorCode)
    *ErrorCode = Err;

  return ptr.release();
}

void clang_CompilerInstance_dispose(CXCompilerInstance CI) {
  delete static_cast<clang::CompilerInstance *>(CI);
}

// Diagnostics
bool clang_CompilerInstance_hasDiagnostics(CXCompilerInstance CI) {
  return static_cast<clang::CompilerInstance *>(CI)->hasDiagnostics();
}

CXDiagnosticsEngine clang_CompilerInstance_getDiagnostics(CXCompilerInstance CI) {
  auto &Diag = static_cast<clang::CompilerInstance *>(CI)->getDiagnostics();
  return &Diag;
}

void clang_CompilerInstance_setDiagnostics(CXCompilerInstance CI,
                                           CXDiagnosticsEngine Value) {
  static_cast<clang::CompilerInstance *>(CI)->setDiagnostics(
      static_cast<clang::DiagnosticsEngine *>(Value));
}

CXDiagnosticConsumer clang_CompilerInstance_getDiagnosticClient(CXCompilerInstance CI) {
  auto &DC = static_cast<clang::CompilerInstance *>(CI)->getDiagnosticClient();
  return &DC;
}

void clang_CompilerInstance_createDiagnostics(CXCompilerInstance CI,
                                              CXDiagnosticConsumer DC,
                                              bool ShouldOwnClient) {
  return static_cast<clang::CompilerInstance *>(CI)->createDiagnostics(
      static_cast<clang::DiagnosticConsumer *>(DC), ShouldOwnClient);
}

// FileManager
bool clang_CompilerInstance_hasFileManager(CXCompilerInstance CI) {
  return static_cast<clang::CompilerInstance *>(CI)->hasFileManager();
}

CXFileManager clang_CompilerInstance_getFileManager(CXCompilerInstance CI) {
  auto &FileMgr = static_cast<clang::CompilerInstance *>(CI)->getFileManager();
  return &FileMgr;
}

void clang_CompilerInstance_setFileManager(CXCompilerInstance CI, CXFileManager FM) {
  static_cast<clang::CompilerInstance *>(CI)->setFileManager(
      static_cast<clang::FileManager *>(FM));
}

CXFileManager clang_CompilerInstance_createFileManager(CXCompilerInstance CI) {
  return static_cast<clang::CompilerInstance *>(CI)->createFileManager();
}

CXFileManager clang_CompilerInstance_createFileManagerWithVOFS4PCH(
    CXCompilerInstance CI, const char *Path, time_t ModificationTime,
    LLVMMemoryBufferRef PCHBuffer) {
  llvm::IntrusiveRefCntPtr<llvm::vfs::OverlayFileSystem> Overlay(
      new llvm::vfs::OverlayFileSystem(llvm::vfs::createPhysicalFileSystem().release()));

  llvm::IntrusiveRefCntPtr<llvm::vfs::InMemoryFileSystem> PCHIMFS(
      new llvm::vfs::InMemoryFileSystem());

  PCHIMFS->addFile(llvm::StringRef(Path), ModificationTime,
                   std::move(std::unique_ptr<llvm::MemoryBuffer>(llvm::unwrap(PCHBuffer))));
  Overlay->pushOverlay(PCHIMFS);

  return static_cast<clang::CompilerInstance *>(CI)->createFileManager(Overlay);
}

// SourceManager
bool clang_CompilerInstance_hasSourceManager(CXCompilerInstance CI) {
  return static_cast<clang::CompilerInstance *>(CI)->hasSourceManager();
}

CXSourceManager clang_CompilerInstance_getSourceManager(CXCompilerInstance CI) {
  auto &SrcMgr = static_cast<clang::CompilerInstance *>(CI)->getSourceManager();
  return &SrcMgr;
}

void clang_CompilerInstance_setSourceManager(CXCompilerInstance CI, CXSourceManager SM) {
  static_cast<clang::CompilerInstance *>(CI)->setSourceManager(
      static_cast<clang::SourceManager *>(SM));
}

void clang_CompilerInstance_createSourceManager(CXCompilerInstance CI,
                                                CXFileManager FileMgr) {
  auto FM = static_cast<clang::FileManager *>(FileMgr);
  static_cast<clang::CompilerInstance *>(CI)->createSourceManager(*FM);
}

// Invocation
bool clang_CompilerInstance_hasInvocation(CXCompilerInstance CI) {
  return static_cast<clang::CompilerInstance *>(CI)->hasInvocation();
}

void clang_CompilerInstance_setInvocation(CXCompilerInstance CI,
                                          CXCompilerInvocation CInv) {
  std::shared_ptr<clang::CompilerInvocation> Invocation(
      static_cast<clang::CompilerInvocation *>(CInv));
  static_cast<clang::CompilerInstance *>(CI)->setInvocation(Invocation);
}

CXCompilerInvocation clang_CompilerInstance_getInvocation(CXCompilerInstance CI) {
  auto &Invocation = static_cast<clang::CompilerInstance *>(CI)->getInvocation();
  return &Invocation;
}

// Target
bool clang_CompilerInstance_hasTarget(CXCompilerInstance CI) {
  return static_cast<clang::CompilerInstance *>(CI)->hasTarget();
}

CXTargetInfo_ clang_CompilerInstance_getTarget(CXCompilerInstance CI) {
  auto &Tgt = static_cast<clang::CompilerInstance *>(CI)->getTarget();
  return &Tgt;
}

void clang_CompilerInstance_setTarget(CXCompilerInstance CI, CXTargetInfo_ Info) {
  static_cast<clang::CompilerInstance *>(CI)->setTarget(
      static_cast<clang::TargetInfo *>(Info));
}

void clang_CompilerInstance_setTargetAndLangOpts(CXCompilerInstance CI) {
  auto compiler = static_cast<clang::CompilerInstance *>(CI);
  compiler->setTarget(clang::TargetInfo::CreateTargetInfo(
      compiler->getDiagnostics(),
      std::make_shared<clang::TargetOptions>(compiler->getTargetOpts())));
#if LLVM_VERSION_MAJOR < 13
  compiler->getTarget().adjust(compiler->getLangOpts());
#else
  compiler->getTarget().adjust(compiler->getDiagnostics(), compiler->getLangOpts());
#endif
}

// Preprocessor
bool clang_CompilerInstance_hasPreprocessor(CXCompilerInstance CI) {
  return static_cast<clang::CompilerInstance *>(CI)->hasPreprocessor();
}

CXPreprocessor clang_CompilerInstance_getPreprocessor(CXCompilerInstance CI) {
  auto &PP = static_cast<clang::CompilerInstance *>(CI)->getPreprocessor();
  return &PP;
}

void clang_CompilerInstance_setPreprocessor(CXCompilerInstance CI, CXPreprocessor PP) {
  std::shared_ptr<clang::Preprocessor> PProc(static_cast<clang::Preprocessor *>(PP));
  static_cast<clang::CompilerInstance *>(CI)->setPreprocessor(PProc);
}

void clang_CompilerInstance_createPreprocessor(CXCompilerInstance CI,
                                               CXTranslationUnitKind TUKind) {
  static_cast<clang::CompilerInstance *>(CI)->createPreprocessor(
      static_cast<clang::TranslationUnitKind>(TUKind));
}

// Sema
bool clang_CompilerInstance_hasSema(CXCompilerInstance CI) {
  return static_cast<clang::CompilerInstance *>(CI)->hasSema();
}

CXSema clang_CompilerInstance_getSema(CXCompilerInstance CI) {
  auto &Sema = static_cast<clang::CompilerInstance *>(CI)->getSema();
  return &Sema;
}

void clang_CompilerInstance_setSema(CXCompilerInstance CI, CXSema S) {
  static_cast<clang::CompilerInstance *>(CI)->setSema(static_cast<clang::Sema *>(S));
}

void clang_CompilerInstance_createSema(CXCompilerInstance CI,
                                       CXTranslationUnitKind TUKind) {
  static_cast<clang::CompilerInstance *>(CI)->createSema(
      static_cast<clang::TranslationUnitKind>(TUKind), nullptr);
}

// ASTContext
bool clang_CompilerInstance_hasASTContext(CXCompilerInstance CI) {
  return static_cast<clang::CompilerInstance *>(CI)->hasASTContext();
}

CXASTContext clang_CompilerInstance_getASTContext(CXCompilerInstance CI) {
  auto &Ctx = static_cast<clang::CompilerInstance *>(CI)->getASTContext();
  return &Ctx;
}

void clang_CompilerInstance_setASTContext(CXCompilerInstance CI, CXASTContext Ctx) {
  static_cast<clang::CompilerInstance *>(CI)->setASTContext(
      static_cast<clang::ASTContext *>(Ctx));
}

void clang_CompilerInstance_createASTContext(CXCompilerInstance CI) {
  static_cast<clang::CompilerInstance *>(CI)->createASTContext();
}

// ASTConsumer
bool clang_CompilerInstance_hasASTConsumer(CXCompilerInstance CI) {
  return static_cast<clang::CompilerInstance *>(CI)->hasASTConsumer();
}

CXASTConsumer clang_CompilerInstance_getASTConsumer(CXCompilerInstance CI) {
  auto &Csr = static_cast<clang::CompilerInstance *>(CI)->getASTConsumer();
  return &Csr;
}

void clang_CompilerInstance_setASTConsumer(CXCompilerInstance CI, CXASTConsumer CG) {
  static_cast<clang::CompilerInstance *>(CI)->setASTConsumer(
      std::unique_ptr<clang::ASTConsumer>(static_cast<clang::ASTConsumer *>(CG)));
}

// Options
CXCodeGenOptions clang_CompilerInstance_getCodeGenOpts(CXCompilerInstance CI) {
  auto &Opts = static_cast<clang::CompilerInstance *>(CI)->getCodeGenOpts();
  return &Opts;
}

CXDiagnosticOptions clang_CompilerInstance_getDiagnosticOpts(CXCompilerInstance CI) {
  auto &Opts = static_cast<clang::CompilerInstance *>(CI)->getDiagnosticOpts();
  return &Opts;
}

CXFrontendOptions clang_CompilerInstance_getFrontendOpts(CXCompilerInstance CI) {
  auto &Opts = static_cast<clang::CompilerInstance *>(CI)->getFrontendOpts();
  return &Opts;
}

CXHeaderSearchOptions clang_CompilerInstance_getHeaderSearchOpts(CXCompilerInstance CI) {
  auto &Opts = static_cast<clang::CompilerInstance *>(CI)->getHeaderSearchOpts();
  return &Opts;
}

CXPreprocessorOptions clang_CompilerInstance_getPreprocessorOpts(CXCompilerInstance CI) {
  auto &Opts = static_cast<clang::CompilerInstance *>(CI)->getPreprocessorOpts();
  return &Opts;
}

CXTargetOptions clang_CompilerInstance_getTargetOpts(CXCompilerInstance CI) {
  auto &Opts = static_cast<clang::CompilerInstance *>(CI)->getTargetOpts();
  return &Opts;
}

CXLangOptions clang_CompilerInstance_getLangOpts(CXCompilerInstance CI) {
  auto &Opts = static_cast<clang::CompilerInstance *>(CI)->getLangOpts();
  return &Opts;
}

// Action
bool clang_CompilerInstance_ExecuteAction(CXCompilerInstance CI, CXFrontendAction Act) {
  return static_cast<clang::CompilerInstance *>(CI)->ExecuteAction(
      *static_cast<clang::FrontendAction *>(Act));
}