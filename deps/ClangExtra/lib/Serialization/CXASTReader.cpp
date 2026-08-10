#include "clang-ex/Serialization/CXASTReader.h"

#include "utils.h"

#include "clang/Basic/Diagnostic.h"
#include "clang/Basic/FileManager.h"
#include "clang/Basic/LangOptions.h"
#include "clang/Basic/TargetOptions.h"
#include "clang/Frontend/PCHContainerOperations.h"
#include "clang/Lex/PreprocessorOptions.h"
#include "clang/Serialization/ASTReader.h"
#include "clang/Serialization/InMemoryModuleCache.h"
#include "llvm/ADT/StringRef.h"

#include <string>

// RawPCHContainerReader is stateless and both entry points below take it by const
// reference, so one instance with static lifetime serves every call. Same reasoning as
// lib/Frontend/CXASTUnit.cpp.
static const clang::RawPCHContainerReader &pchReader() {
  static const clang::RawPCHContainerReader Reader;
  return Reader;
}

CXString clang_ASTReader_getOriginalSourceFile(const char *ASTFileName,
                                               CXFileManager FileMgr,
                                               CXDiagnosticsEngine Diags) {
  std::string Name = clang::ASTReader::getOriginalSourceFile(
      std::string(ASTFileName), *reinterpret_cast<clang::FileManager *>(FileMgr),
      pchReader(), *reinterpret_cast<clang::DiagnosticsEngine *>(Diags));
  return extra::makeCXString(Name);
}

bool clang_ASTReader_isAcceptableASTFile(const char *Filename, CXFileManager FileMgr,
                                         CXLangOptions LangOpts,
                                         CXTargetOptions TargetOpts,
                                         CXPreprocessorOptions PPOpts,
                                         const char *ExistingModuleCachePath,
                                         bool RequireStrictOptionMatches) {
  // Consulted only for the duration of the call (the validator it feeds is a local of
  // ASTReader::isAcceptableASTFile), so a throwaway is exactly right and nothing outlives
  // this frame holding a reference to it.
  clang::InMemoryModuleCache ModuleCache;
  return clang::ASTReader::isAcceptableASTFile(
      llvm::StringRef(Filename), *reinterpret_cast<clang::FileManager *>(FileMgr),
      ModuleCache, pchReader(), *reinterpret_cast<clang::LangOptions *>(LangOpts),
      *reinterpret_cast<clang::TargetOptions *>(TargetOpts),
      *reinterpret_cast<clang::PreprocessorOptions *>(PPOpts),
      llvm::StringRef(ExistingModuleCachePath), RequireStrictOptionMatches);
}
