#include "clang-ex/Frontend/CXCompilerInstance.h"
#include "clang/Frontend/FrontendOptions.h"
#include "utils.h"
#include "clang/Basic/FileSystemOptions.h"
#include "clang/Frontend/CompilerInvocation.h"
#include "clang/Frontend/DependencyOutputOptions.h"
#include "clang/Frontend/PreprocessorOutputOptions.h"
#include "clang/Basic/TargetInfo.h"
#include "clang/CodeGen/ModuleBuilder.h"
#include "clang/Frontend/CompilerInstance.h"
#include "clang/Lex/Preprocessor.h"
#include "llvm/Support/Timer.h"
#include "llvm/Support/VirtualFileSystem.h"
#include "clang/Lex/PreprocessorOptions.h"
#include "clang/Serialization/ASTReader.h"

CXCompilerInstance clang_CompilerInstance_create(void) {
  auto CI = std::make_unique<clang::CompilerInstance>();
  return reinterpret_cast<CXCompilerInstance>(CI.release());
}

void clang_CompilerInstance_dispose(CXCompilerInstance CI) {
  delete reinterpret_cast<clang::CompilerInstance *>(CI);
}

// Diagnostics
bool clang_CompilerInstance_hasDiagnostics(CXCompilerInstance CI) {
  return reinterpret_cast<clang::CompilerInstance *>(CI)->hasDiagnostics();
}

CXDiagnosticsEngine clang_CompilerInstance_getDiagnostics(CXCompilerInstance CI) {
  auto &Diag = reinterpret_cast<clang::CompilerInstance *>(CI)->getDiagnostics();
  return reinterpret_cast<CXDiagnosticsEngine>(&Diag);
}

void clang_CompilerInstance_setDiagnostics(CXCompilerInstance CI,
                                           CXDiagnosticsEngine Value) {
  reinterpret_cast<clang::CompilerInstance *>(CI)->setDiagnostics(
      reinterpret_cast<clang::DiagnosticsEngine *>(Value));
}

CXDiagnosticConsumer clang_CompilerInstance_getDiagnosticClient(CXCompilerInstance CI) {
  auto &DC = reinterpret_cast<clang::CompilerInstance *>(CI)->getDiagnosticClient();
  return reinterpret_cast<CXDiagnosticConsumer>(&DC);
}

void clang_CompilerInstance_createDiagnostics(CXCompilerInstance CI,
                                              CXDiagnosticConsumer DC,
                                              bool ShouldOwnClient) {
  return reinterpret_cast<clang::CompilerInstance *>(CI)->createDiagnostics(
      reinterpret_cast<clang::DiagnosticConsumer *>(DC), ShouldOwnClient);
}

// FileManager
bool clang_CompilerInstance_hasFileManager(CXCompilerInstance CI) {
  return reinterpret_cast<clang::CompilerInstance *>(CI)->hasFileManager();
}

CXFileManager clang_CompilerInstance_getFileManager(CXCompilerInstance CI) {
  auto &FileMgr = reinterpret_cast<clang::CompilerInstance *>(CI)->getFileManager();
  return reinterpret_cast<CXFileManager>(&FileMgr);
}

void clang_CompilerInstance_setFileManager(CXCompilerInstance CI, CXFileManager FM) {
  reinterpret_cast<clang::CompilerInstance *>(CI)->setFileManager(
      reinterpret_cast<clang::FileManager *>(FM));
}

CXFileManager clang_CompilerInstance_createFileManager(CXCompilerInstance CI) {
  return reinterpret_cast<CXFileManager>(reinterpret_cast<clang::CompilerInstance *>(CI)->createFileManager());
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

  return reinterpret_cast<CXFileManager>(reinterpret_cast<clang::CompilerInstance *>(CI)->createFileManager(Overlay));
}

// SourceManager
bool clang_CompilerInstance_hasSourceManager(CXCompilerInstance CI) {
  return reinterpret_cast<clang::CompilerInstance *>(CI)->hasSourceManager();
}

CXSourceManager clang_CompilerInstance_getSourceManager(CXCompilerInstance CI) {
  auto &SrcMgr = reinterpret_cast<clang::CompilerInstance *>(CI)->getSourceManager();
  return reinterpret_cast<CXSourceManager>(&SrcMgr);
}

void clang_CompilerInstance_setSourceManager(CXCompilerInstance CI, CXSourceManager SM) {
  reinterpret_cast<clang::CompilerInstance *>(CI)->setSourceManager(
      reinterpret_cast<clang::SourceManager *>(SM));
}

void clang_CompilerInstance_createSourceManager(CXCompilerInstance CI,
                                                CXFileManager FileMgr) {
  auto FM = reinterpret_cast<clang::FileManager *>(FileMgr);
  reinterpret_cast<clang::CompilerInstance *>(CI)->createSourceManager(*FM);
}

// Invocation
bool clang_CompilerInstance_hasInvocation(CXCompilerInstance CI) {
  return reinterpret_cast<clang::CompilerInstance *>(CI)->hasInvocation();
}

void clang_CompilerInstance_setInvocation(CXCompilerInstance CI,
                                          CXCompilerInvocation CInv) {
  std::shared_ptr<clang::CompilerInvocation> Invocation(
      reinterpret_cast<clang::CompilerInvocation *>(CInv));
  reinterpret_cast<clang::CompilerInstance *>(CI)->setInvocation(Invocation);
}

CXCompilerInvocation clang_CompilerInstance_getInvocation(CXCompilerInstance CI) {
  auto &Invocation = reinterpret_cast<clang::CompilerInstance *>(CI)->getInvocation();
  return reinterpret_cast<CXCompilerInvocation>(&Invocation);
}

// Target
bool clang_CompilerInstance_hasTarget(CXCompilerInstance CI) {
  return reinterpret_cast<clang::CompilerInstance *>(CI)->hasTarget();
}

CXTargetInfo_ clang_CompilerInstance_getTarget(CXCompilerInstance CI) {
  auto &Tgt = reinterpret_cast<clang::CompilerInstance *>(CI)->getTarget();
  return reinterpret_cast<CXTargetInfo_>(&Tgt);
}

void clang_CompilerInstance_setTarget(CXCompilerInstance CI, CXTargetInfo_ Info) {
  reinterpret_cast<clang::CompilerInstance *>(CI)->setTarget(
      reinterpret_cast<clang::TargetInfo *>(Info));
}

void clang_CompilerInstance_setTargetAndLangOpts(CXCompilerInstance CI) {
  auto compiler = reinterpret_cast<clang::CompilerInstance *>(CI);
  compiler->setTarget(clang::TargetInfo::CreateTargetInfo(
      compiler->getDiagnostics(),
      std::make_shared<clang::TargetOptions>(compiler->getTargetOpts())));
  compiler->getTarget().adjust(compiler->getDiagnostics(), compiler->getLangOpts());
}

// Preprocessor
bool clang_CompilerInstance_hasPreprocessor(CXCompilerInstance CI) {
  return reinterpret_cast<clang::CompilerInstance *>(CI)->hasPreprocessor();
}

CXPreprocessor clang_CompilerInstance_getPreprocessor(CXCompilerInstance CI) {
  auto &PP = reinterpret_cast<clang::CompilerInstance *>(CI)->getPreprocessor();
  return reinterpret_cast<CXPreprocessor>(&PP);
}

void clang_CompilerInstance_setPreprocessor(CXCompilerInstance CI, CXPreprocessor PP) {
  std::shared_ptr<clang::Preprocessor> PProc(reinterpret_cast<clang::Preprocessor *>(PP));
  reinterpret_cast<clang::CompilerInstance *>(CI)->setPreprocessor(PProc);
}

void clang_CompilerInstance_createPreprocessor(CXCompilerInstance CI,
                                               CXTranslationUnitKind TUKind) {
  reinterpret_cast<clang::CompilerInstance *>(CI)->createPreprocessor(
      static_cast<clang::TranslationUnitKind>(TUKind));
}

// Sema
bool clang_CompilerInstance_hasSema(CXCompilerInstance CI) {
  return reinterpret_cast<clang::CompilerInstance *>(CI)->hasSema();
}

CXSema clang_CompilerInstance_getSema(CXCompilerInstance CI) {
  auto &Sema = reinterpret_cast<clang::CompilerInstance *>(CI)->getSema();
  return reinterpret_cast<CXSema>(&Sema);
}

void clang_CompilerInstance_setSema(CXCompilerInstance CI, CXSema S) {
  reinterpret_cast<clang::CompilerInstance *>(CI)->setSema(reinterpret_cast<clang::Sema *>(S));
}

void clang_CompilerInstance_createSema(CXCompilerInstance CI,
                                       CXTranslationUnitKind TUKind) {
  reinterpret_cast<clang::CompilerInstance *>(CI)->createSema(
      static_cast<clang::TranslationUnitKind>(TUKind), nullptr);
}

// ASTContext
bool clang_CompilerInstance_hasASTContext(CXCompilerInstance CI) {
  return reinterpret_cast<clang::CompilerInstance *>(CI)->hasASTContext();
}

CXASTContext clang_CompilerInstance_getASTContext(CXCompilerInstance CI) {
  auto &Ctx = reinterpret_cast<clang::CompilerInstance *>(CI)->getASTContext();
  return reinterpret_cast<CXASTContext>(&Ctx);
}

void clang_CompilerInstance_setASTContext(CXCompilerInstance CI, CXASTContext Ctx) {
  reinterpret_cast<clang::CompilerInstance *>(CI)->setASTContext(
      reinterpret_cast<clang::ASTContext *>(Ctx));
}

void clang_CompilerInstance_createASTContext(CXCompilerInstance CI) {
  reinterpret_cast<clang::CompilerInstance *>(CI)->createASTContext();
}

// ASTConsumer
bool clang_CompilerInstance_hasASTConsumer(CXCompilerInstance CI) {
  return reinterpret_cast<clang::CompilerInstance *>(CI)->hasASTConsumer();
}

CXASTConsumer clang_CompilerInstance_getASTConsumer(CXCompilerInstance CI) {
  auto &Csr = reinterpret_cast<clang::CompilerInstance *>(CI)->getASTConsumer();
  return reinterpret_cast<CXASTConsumer>(&Csr);
}

void clang_CompilerInstance_setASTConsumer(CXCompilerInstance CI, CXASTConsumer CG) {
  reinterpret_cast<clang::CompilerInstance *>(CI)->setASTConsumer(
      std::unique_ptr<clang::ASTConsumer>(reinterpret_cast<clang::ASTConsumer *>(CG)));
}

// Options
CXCodeGenOptions clang_CompilerInstance_getCodeGenOpts(CXCompilerInstance CI) {
  auto &Opts = reinterpret_cast<clang::CompilerInstance *>(CI)->getCodeGenOpts();
  return reinterpret_cast<CXCodeGenOptions>(&Opts);
}

CXDiagnosticOptions clang_CompilerInstance_getDiagnosticOpts(CXCompilerInstance CI) {
  auto &Opts = reinterpret_cast<clang::CompilerInstance *>(CI)->getDiagnosticOpts();
  return reinterpret_cast<CXDiagnosticOptions>(&Opts);
}

CXFrontendOptions clang_CompilerInstance_getFrontendOpts(CXCompilerInstance CI) {
  auto &Opts = reinterpret_cast<clang::CompilerInstance *>(CI)->getFrontendOpts();
  return reinterpret_cast<CXFrontendOptions>(&Opts);
}

CXHeaderSearchOptions clang_CompilerInstance_getHeaderSearchOpts(CXCompilerInstance CI) {
  auto &Opts = reinterpret_cast<clang::CompilerInstance *>(CI)->getHeaderSearchOpts();
  return reinterpret_cast<CXHeaderSearchOptions>(&Opts);
}

CXPreprocessorOptions clang_CompilerInstance_getPreprocessorOpts(CXCompilerInstance CI) {
  auto &Opts = reinterpret_cast<clang::CompilerInstance *>(CI)->getPreprocessorOpts();
  return reinterpret_cast<CXPreprocessorOptions>(&Opts);
}

CXTargetOptions clang_CompilerInstance_getTargetOpts(CXCompilerInstance CI) {
  auto &Opts = reinterpret_cast<clang::CompilerInstance *>(CI)->getTargetOpts();
  return reinterpret_cast<CXTargetOptions>(&Opts);
}

CXLangOptions clang_CompilerInstance_getLangOpts(CXCompilerInstance CI) {
  auto &Opts = reinterpret_cast<clang::CompilerInstance *>(CI)->getLangOpts();
  return reinterpret_cast<CXLangOptions>(&Opts);
}

// Action

// Forwarding options — all of these dereference CompilerInstance::Invocation
// unchecked; see the header for the precondition.
CXAnalyzerOptions clang_CompilerInstance_getAnalyzerOpts(CXCompilerInstance CI) {
  auto &Opts = reinterpret_cast<clang::CompilerInstance *>(CI)->getAnalyzerOpts();
  return reinterpret_cast<CXAnalyzerOptions>(&Opts);
}

CXDependencyOutputOptions
clang_CompilerInstance_getDependencyOutputOpts(CXCompilerInstance CI) {
  auto &Opts = reinterpret_cast<clang::CompilerInstance *>(CI)->getDependencyOutputOpts();
  return reinterpret_cast<CXDependencyOutputOptions>(&Opts);
}

CXFileSystemOptions clang_CompilerInstance_getFileSystemOpts(CXCompilerInstance CI) {
  auto &Opts = reinterpret_cast<clang::CompilerInstance *>(CI)->getFileSystemOpts();
  return reinterpret_cast<CXFileSystemOptions>(&Opts);
}

CXPreprocessorOutputOptions
clang_CompilerInstance_getPreprocessorOutputOpts(CXCompilerInstance CI) {
  auto &Opts = reinterpret_cast<clang::CompilerInstance *>(CI)->getPreprocessorOutputOpts();
  return reinterpret_cast<CXPreprocessorOutputOptions>(&Opts);
}

CXAPINotesOptions clang_CompilerInstance_getAPINotesOpts(CXCompilerInstance CI) {
  auto &Opts = reinterpret_cast<clang::CompilerInstance *>(CI)->getAPINotesOpts();
  return reinterpret_cast<CXAPINotesOptions>(&Opts);
}

// Module loading
bool clang_CompilerInstance_shouldBuildGlobalModuleIndex(CXCompilerInstance CI) {
  return reinterpret_cast<clang::CompilerInstance *>(CI)->shouldBuildGlobalModuleIndex();
}

void clang_CompilerInstance_setBuildGlobalModuleIndex(CXCompilerInstance CI, bool Build) {
  reinterpret_cast<clang::CompilerInstance *>(CI)->setBuildGlobalModuleIndex(Build);
}

bool clang_CompilerInstance_hadModuleLoaderFatalFailure(CXCompilerInstance CI) {
  return reinterpret_cast<clang::CompilerInstance *>(CI)->hadModuleLoaderFatalFailure();
}

CXString clang_CompilerInstance_getSpecificModuleCachePath(CXCompilerInstance CI) {
  return extra::makeCXString(
      reinterpret_cast<clang::CompilerInstance *>(CI)->getSpecificModuleCachePath());
}

void clang_CompilerInstance_createPCHExternalASTSource(
    CXCompilerInstance CI, const char *Path,
    CXDisableValidationForModuleKind DisableValidation,
    bool AllowPCHWithCompilerErrors, void *DeserializationListener,
    bool OwnDeserializationListener) {
  reinterpret_cast<clang::CompilerInstance *>(CI)->createPCHExternalASTSource(
      llvm::StringRef(Path),
      static_cast<clang::DisableValidationForModuleKind>(DisableValidation),
      AllowPCHWithCompilerErrors, DeserializationListener,
      OwnDeserializationListener);
}

bool clang_CompilerInstance_hasASTReader(CXCompilerInstance CI) {
  // The IntrusiveRefCntPtr temporary retains and releases a live object, so no refcount
  // crosses the boundary.
  return reinterpret_cast<clang::CompilerInstance *>(CI)->getASTReader() != nullptr;
}

// AuxTarget
bool clang_CompilerInstance_createTarget(CXCompilerInstance CI) {
  return reinterpret_cast<clang::CompilerInstance *>(CI)->createTarget();
}

CXTargetInfo_ clang_CompilerInstance_getAuxTarget(CXCompilerInstance CI) {
  return reinterpret_cast<CXTargetInfo_>(reinterpret_cast<clang::CompilerInstance *>(CI)->getAuxTarget());
}

void clang_CompilerInstance_setAuxTarget(CXCompilerInstance CI, CXTargetInfo_ Info) {
  reinterpret_cast<clang::CompilerInstance *>(CI)->setAuxTarget(
      reinterpret_cast<clang::TargetInfo *>(Info));
}

// Code completion
bool clang_CompilerInstance_hasCodeCompletionConsumer(CXCompilerInstance CI) {
  return reinterpret_cast<clang::CompilerInstance *>(CI)->hasCodeCompletionConsumer();
}

// Output files
void clang_CompilerInstance_clearOutputFiles(CXCompilerInstance CI, bool EraseFiles) {
  reinterpret_cast<clang::CompilerInstance *>(CI)->clearOutputFiles(EraseFiles);
}

// Plugins
void clang_CompilerInstance_LoadRequestedPlugins(CXCompilerInstance CI) {
  reinterpret_cast<clang::CompilerInstance *>(CI)->LoadRequestedPlugins();
}

// Frontend timer
bool clang_CompilerInstance_hasFrontendTimer(CXCompilerInstance CI) {
  return reinterpret_cast<clang::CompilerInstance *>(CI)->hasFrontendTimer();
}

CXString clang_CompilerInstance_getFrontendTimerName(CXCompilerInstance CI) {
  return extra::makeCXString(
      reinterpret_cast<clang::CompilerInstance *>(CI)->getFrontendTimer().getName());
}

bool clang_CompilerInstance_isFrontendTimerRunning(CXCompilerInstance CI) {
  return reinterpret_cast<clang::CompilerInstance *>(CI)->getFrontendTimer().isRunning();
}

void clang_CompilerInstance_createFrontendTimer(CXCompilerInstance CI) {
  reinterpret_cast<clang::CompilerInstance *>(CI)->createFrontendTimer();
}

// Ownership transfer
void clang_CompilerInstance_resetAndLeakFileManager(CXCompilerInstance CI) {
  reinterpret_cast<clang::CompilerInstance *>(CI)->resetAndLeakFileManager();
}

void clang_CompilerInstance_resetAndLeakSourceManager(CXCompilerInstance CI) {
  reinterpret_cast<clang::CompilerInstance *>(CI)->resetAndLeakSourceManager();
}

void clang_CompilerInstance_resetAndLeakPreprocessor(CXCompilerInstance CI) {
  reinterpret_cast<clang::CompilerInstance *>(CI)->resetAndLeakPreprocessor();
}

void clang_CompilerInstance_resetAndLeakASTContext(CXCompilerInstance CI) {
  reinterpret_cast<clang::CompilerInstance *>(CI)->resetAndLeakASTContext();
}

void clang_CompilerInstance_resetAndLeakSema(CXCompilerInstance CI) {
  reinterpret_cast<clang::CompilerInstance *>(CI)->resetAndLeakSema();
}

// Action
bool clang_CompilerInstance_ExecuteAction(CXCompilerInstance CI, CXFrontendAction Act) {
  return reinterpret_cast<clang::CompilerInstance *>(CI)->ExecuteAction(
      *reinterpret_cast<clang::FrontendAction *>(Act));
}

bool clang_CompilerInstance_buildingModule(CXCompilerInstance CI) {
  return reinterpret_cast<clang::CompilerInstance *>(CI)->buildingModule();
}

void clang_CompilerInstance_setBuildingModule(CXCompilerInstance CI, bool Flag) {
  reinterpret_cast<clang::CompilerInstance *>(CI)->setBuildingModule(Flag);
}

CXASTConsumer clang_CompilerInstance_takeASTConsumer(CXCompilerInstance CI) {
  return reinterpret_cast<CXASTConsumer>(reinterpret_cast<clang::CompilerInstance *>(CI)->takeASTConsumer().release());
}

bool clang_CompilerInstance_InitializeSourceManagerFromFile(CXCompilerInstance CI,
                                                            const char *Path,
                                                            bool IsSystem) {
  clang::FrontendInputFile Input(
      Path, clang::InputKind(clang::Language::Unknown, clang::InputKind::Source), IsSystem);
  return reinterpret_cast<clang::CompilerInstance *>(CI)->InitializeSourceManager(Input);
}
