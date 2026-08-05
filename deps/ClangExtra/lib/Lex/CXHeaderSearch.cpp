#include "clang-ex/Lex/CXHeaderSearch.h"
#include "utils.h"
#include "clang/Lex/DirectoryLookup.h"
#include "clang/Lex/HeaderSearch.h"
#include "llvm/ADT/SmallVector.h"
#include <string>
#include "clang/Basic/Diagnostic.h"
#include "clang/Basic/FileManager.h"
#include "clang/Basic/IdentifierTable.h"
#include "clang/Basic/SourceManager.h"
#include "clang/Basic/TargetInfo.h"
#include "clang/Basic/Module.h"
#include "clang/Basic/SourceLocation.h"
#include "clang/Lex/ModuleMap.h"
#include "llvm/ADT/ArrayRef.h"
#include <memory>
#include <utility>
#include <vector>

CXHeaderSearchOptions clang_HeaderSearch_getHeaderSearchOpts(CXHeaderSearch HS) {
  return reinterpret_cast<CXHeaderSearchOptions>(&reinterpret_cast<clang::HeaderSearch *>(HS)->getHeaderSearchOpts());
}

CXFileManager clang_HeaderSearch_getFileMgr(CXHeaderSearch HS) {
  return reinterpret_cast<CXFileManager>(&reinterpret_cast<clang::HeaderSearch *>(HS)->getFileMgr());
}

CXDiagnosticsEngine clang_HeaderSearch_getDiags(CXHeaderSearch HS) {
  return reinterpret_cast<CXDiagnosticsEngine>(&reinterpret_cast<clang::HeaderSearch *>(HS)->getDiags());
}

bool clang_HeaderSearch_HasIncludeAliasMap(CXHeaderSearch HS) {
  return reinterpret_cast<clang::HeaderSearch *>(HS)->HasIncludeAliasMap();
}

void clang_HeaderSearch_AddIncludeAlias(CXHeaderSearch HS, const char *Source,
                                        const char *Dest) {
  reinterpret_cast<clang::HeaderSearch *>(HS)->AddIncludeAlias(llvm::StringRef(Source),
                                                          llvm::StringRef(Dest));
}

CXString clang_HeaderSearch_MapHeaderToIncludeAlias(CXHeaderSearch HS, const char *Source) {
  llvm::StringRef Alias = reinterpret_cast<clang::HeaderSearch *>(HS)->MapHeaderToIncludeAlias(
      llvm::StringRef(Source));
  return extra::makeCXString(Alias.str());
}

void clang_HeaderSearch_setModuleHash(CXHeaderSearch HS, const char *Hash) {
  reinterpret_cast<clang::HeaderSearch *>(HS)->setModuleHash(llvm::StringRef(Hash));
}

void clang_HeaderSearch_setModuleCachePath(CXHeaderSearch HS, const char *CachePath) {
  reinterpret_cast<clang::HeaderSearch *>(HS)->setModuleCachePath(llvm::StringRef(CachePath));
}

CXString clang_HeaderSearch_getModuleHash(CXHeaderSearch HS) {
  return extra::makeCXString(
      std::string(reinterpret_cast<clang::HeaderSearch *>(HS)->getModuleHash()));
}

CXString clang_HeaderSearch_getModuleCachePath(CXHeaderSearch HS) {
  return extra::makeCXString(
      std::string(reinterpret_cast<clang::HeaderSearch *>(HS)->getModuleCachePath()));
}

void clang_HeaderSearch_setDirectoryHasModuleMap(CXHeaderSearch HS, CXDirectoryEntry Dir) {
  reinterpret_cast<clang::HeaderSearch *>(HS)->setDirectoryHasModuleMap(
      reinterpret_cast<const clang::DirectoryEntry *>(Dir));
}

void clang_HeaderSearch_ClearFileInfo(CXHeaderSearch HS) {
  reinterpret_cast<clang::HeaderSearch *>(HS)->ClearFileInfo();
}

void clang_HeaderSearch_SetExternalLookup(CXHeaderSearch HS,
                                          CXExternalPreprocessorSource EPS) {
  reinterpret_cast<clang::HeaderSearch *>(HS)->SetExternalLookup(
      reinterpret_cast<clang::ExternalPreprocessorSource *>(EPS));
}

CXExternalPreprocessorSource clang_HeaderSearch_getExternalLookup(CXHeaderSearch HS) {
  return reinterpret_cast<CXExternalPreprocessorSource>(reinterpret_cast<clang::HeaderSearch *>(HS)->getExternalLookup());
}

void clang_HeaderSearch_setTarget(CXHeaderSearch HS, CXTargetInfo_ Target) {
  reinterpret_cast<clang::HeaderSearch *>(HS)->setTarget(
      *reinterpret_cast<const clang::TargetInfo *>(Target));
}

CXCharacteristicKind clang_HeaderSearch_getFileDirFlavor(CXHeaderSearch HS,
                                                         CXFileEntryRef File) {
  return static_cast<CXCharacteristicKind>(
      reinterpret_cast<clang::HeaderSearch *>(HS)->getFileDirFlavor(
          *reinterpret_cast<clang::FileEntryRef *>(File)));
}

void clang_HeaderSearch_MarkFileIncludeOnce(CXHeaderSearch HS, CXFileEntryRef File) {
  reinterpret_cast<clang::HeaderSearch *>(HS)->MarkFileIncludeOnce(
      *reinterpret_cast<clang::FileEntryRef *>(File));
}

void clang_HeaderSearch_MarkFileSystemHeader(CXHeaderSearch HS, CXFileEntryRef File) {
  reinterpret_cast<clang::HeaderSearch *>(HS)->MarkFileSystemHeader(
      *reinterpret_cast<clang::FileEntryRef *>(File));
}

void clang_HeaderSearch_MarkFileModuleHeader(CXHeaderSearch HS, CXFileEntryRef FE,
                                             unsigned RoleBits,
                                             bool isCompilingModuleHeader) {
  reinterpret_cast<clang::HeaderSearch *>(HS)->MarkFileModuleHeader(
      *reinterpret_cast<clang::FileEntryRef *>(FE),
      static_cast<clang::ModuleMap::ModuleHeaderRole>(RoleBits), isCompilingModuleHeader);
}

void clang_HeaderSearch_SetFileControllingMacro(CXHeaderSearch HS, CXFileEntryRef File,
                                                CXIdentifierInfo ControllingMacro) {
  reinterpret_cast<clang::HeaderSearch *>(HS)->SetFileControllingMacro(
      *reinterpret_cast<clang::FileEntryRef *>(File),
      reinterpret_cast<const clang::IdentifierInfo *>(ControllingMacro));
}

bool clang_HeaderSearch_isFileMultipleIncludeGuarded(CXHeaderSearch HS,
                                                     CXFileEntryRef File) {
  return reinterpret_cast<clang::HeaderSearch *>(HS)->isFileMultipleIncludeGuarded(
      *reinterpret_cast<clang::FileEntryRef *>(File));
}

bool clang_HeaderSearch_hasFileBeenImported(CXHeaderSearch HS, CXFileEntryRef File) {
  return reinterpret_cast<clang::HeaderSearch *>(HS)->hasFileBeenImported(
      *reinterpret_cast<clang::FileEntryRef *>(File));
}

unsigned clang_HeaderSearch_getNumUserEntryUsage(CXHeaderSearch HS) {
  return reinterpret_cast<clang::HeaderSearch *>(HS)->computeUserEntryUsage().size();
}

void clang_HeaderSearch_computeUserEntryUsage(CXHeaderSearch HS, bool *Out) {
  std::vector<bool> Usage = reinterpret_cast<clang::HeaderSearch *>(HS)->computeUserEntryUsage();
  for (size_t I = 0, E = Usage.size(); I != E; ++I)
    Out[I] = Usage[I];
}

CXString clang_HeaderSearch_getPrebuiltModuleFileName(CXHeaderSearch HS,
                                                      const char *ModuleName,
                                                      bool FileMapOnly) {
  return extra::makeCXString(
      reinterpret_cast<clang::HeaderSearch *>(HS)->getPrebuiltModuleFileName(
          llvm::StringRef(ModuleName), FileMapOnly));
}

CXModule_ clang_HeaderSearch_lookupModule(CXHeaderSearch HS, const char *ModuleName,
                                          CXSourceLocation_ ImportLoc, bool AllowSearch,
                                          bool AllowExtraModuleMapSearch) {
  return reinterpret_cast<CXModule_>(
      reinterpret_cast<clang::HeaderSearch *>(HS)->lookupModule(
          llvm::StringRef(ModuleName),
          clang::SourceLocation::getFromPtrEncoding(ImportLoc), AllowSearch,
          AllowExtraModuleMapSearch));
}

bool clang_HeaderSearch_hasModuleMap(CXHeaderSearch HS, const char *Filename,
                                     CXDirectoryEntry Root, bool IsSystem) {
  return reinterpret_cast<clang::HeaderSearch *>(HS)->hasModuleMap(
      llvm::StringRef(Filename), reinterpret_cast<const clang::DirectoryEntry *>(Root),
      IsSystem);
}

CXModule_ clang_HeaderSearch_findModuleForHeader(CXHeaderSearch HS, CXFileEntryRef File,
                                                 bool AllowTextual, bool AllowExcluded,
                                                 unsigned *RoleBits) {
  clang::ModuleMap::KnownHeader KH =
      reinterpret_cast<clang::HeaderSearch *>(HS)->findModuleForHeader(
          *reinterpret_cast<clang::FileEntryRef *>(File), AllowTextual, AllowExcluded);
  if (RoleBits)
    *RoleBits = static_cast<unsigned>(KH.getRole());
  return reinterpret_cast<CXModule_>(KH.getModule());
}

unsigned clang_HeaderSearch_getNumResolvedModulesForHeader(CXHeaderSearch HS,
                                                           CXFileEntryRef File) {
  return reinterpret_cast<clang::HeaderSearch *>(HS)
      ->findResolvedModulesForHeader(*reinterpret_cast<clang::FileEntryRef *>(File))
      .size();
}

CXModule_ clang_HeaderSearch_getResolvedModuleForHeader(CXHeaderSearch HS,
                                                        CXFileEntryRef File, unsigned Idx,
                                                        unsigned *RoleBits) {
  llvm::ArrayRef<clang::ModuleMap::KnownHeader> KHs =
      reinterpret_cast<clang::HeaderSearch *>(HS)->findResolvedModulesForHeader(
          *reinterpret_cast<clang::FileEntryRef *>(File));
  if (RoleBits)
    *RoleBits = static_cast<unsigned>(KHs[Idx].getRole());
  return reinterpret_cast<CXModule_>(KHs[Idx].getModule());
}

bool clang_HeaderSearch_loadModuleMapFile(CXHeaderSearch HS, CXFileEntryRef File,
                                          bool IsSystem) {
  return reinterpret_cast<clang::HeaderSearch *>(HS)->loadModuleMapFile(
      *reinterpret_cast<clang::FileEntryRef *>(File), IsSystem);
}

unsigned clang_HeaderSearch_getNumAllModules(CXHeaderSearch HS) {
  llvm::SmallVector<clang::Module *, 8> Modules;
  reinterpret_cast<clang::HeaderSearch *>(HS)->collectAllModules(Modules);
  return Modules.size();
}

void clang_HeaderSearch_collectAllModules(CXHeaderSearch HS, CXModule_ *Buf) {
  llvm::SmallVector<clang::Module *, 8> Modules;
  reinterpret_cast<clang::HeaderSearch *>(HS)->collectAllModules(Modules);
  for (size_t I = 0, E = Modules.size(); I != E; ++I)
    Buf[I] = reinterpret_cast<CXModule_>(Modules[I]);
}

unsigned clang_HeaderSearch_getNumHeaderMapFileNames(CXHeaderSearch HS) {
  llvm::SmallVector<std::string, 4> Names;
  reinterpret_cast<clang::HeaderSearch *>(HS)->getHeaderMapFileNames(Names);
  return Names.size();
}

CXString clang_HeaderSearch_getHeaderMapFileName(CXHeaderSearch HS, unsigned Idx) {
  llvm::SmallVector<std::string, 4> Names;
  reinterpret_cast<clang::HeaderSearch *>(HS)->getHeaderMapFileNames(Names);
  return extra::makeCXString(Names[Idx]);
}

unsigned clang_HeaderSearch_header_file_size(CXHeaderSearch HS) {
  return reinterpret_cast<clang::HeaderSearch *>(HS)->header_file_size();
}

unsigned clang_HeaderSearch_search_dir_size(CXHeaderSearch HS) {
  return reinterpret_cast<clang::HeaderSearch *>(HS)->search_dir_size();
}

CXString clang_HeaderSearch_getSearchDirName(CXHeaderSearch HS, unsigned Idx) {
  auto *hs = reinterpret_cast<clang::HeaderSearch *>(HS);
  const clang::DirectoryLookup &DL = *hs->search_dir_nth(Idx);
  return extra::makeCXString(std::string(DL.getName()));
}

unsigned clang_HeaderSearch_getAngledDirIdx(CXHeaderSearch HS) {
  // Bind const so both calls pick the const overloads and the two iterators have the same
  // type. The walk only increments and compares; it never dereferences, so an empty range
  // is fine.
  const clang::HeaderSearch &hs = *reinterpret_cast<clang::HeaderSearch *>(HS);
  unsigned N = 0;
  for (clang::ConstSearchDirIterator It = hs.quoted_dir_begin(), E = hs.angled_dir_begin();
       It != E; ++It)
    ++N;
  return N;
}

unsigned clang_HeaderSearch_getSystemDirIdx(CXHeaderSearch HS) {
  const clang::HeaderSearch &hs = *reinterpret_cast<clang::HeaderSearch *>(HS);
  unsigned N = 0;
  for (clang::ConstSearchDirIterator It = hs.quoted_dir_begin(), E = hs.system_dir_begin();
       It != E; ++It)
    ++N;
  return N;
}

CXString clang_HeaderSearch_getUniqueFrameworkName(CXHeaderSearch HS,
                                                   const char *Framework) {
  llvm::StringRef Name = reinterpret_cast<clang::HeaderSearch *>(HS)->getUniqueFrameworkName(
      llvm::StringRef(Framework));
  return extra::makeCXString(Name.str());
}

CXString clang_HeaderSearch_getIncludeNameForHeader(CXHeaderSearch HS, CXFileEntry File) {
  llvm::StringRef Name = reinterpret_cast<clang::HeaderSearch *>(HS)->getIncludeNameForHeader(
      reinterpret_cast<const clang::FileEntry *>(File));
  return extra::makeCXString(Name.str());
}

CXString clang_HeaderSearch_suggestPathToFileForDiagnostics(CXHeaderSearch HS,
                                                            CXFileEntryRef File,
                                                            const char *MainFile,
                                                            bool *IsAngled) {
  return extra::makeCXString(
      reinterpret_cast<clang::HeaderSearch *>(HS)->suggestPathToFileForDiagnostics(
          *reinterpret_cast<clang::FileEntryRef *>(File), llvm::StringRef(MainFile), IsAngled));
}

void clang_HeaderSearch_PrintStats(CXHeaderSearch HS) {
  reinterpret_cast<clang::HeaderSearch *>(HS)->PrintStats();
}
size_t clang_HeaderSearch_getTotalMemory(CXHeaderSearch HS) {
  return reinterpret_cast<clang::HeaderSearch *>(HS)->getTotalMemory();
}

// HeaderFileInfo

bool clang_HeaderFileInfo_getIsImport(CXHeaderFileInfo HFI) {
  return reinterpret_cast<clang::HeaderFileInfo *>(HFI)->isImport;
}

bool clang_HeaderFileInfo_getIsPragmaOnce(CXHeaderFileInfo HFI) {
  return reinterpret_cast<clang::HeaderFileInfo *>(HFI)->isPragmaOnce;
}

CXCharacteristicKind clang_HeaderFileInfo_getDirInfo(CXHeaderFileInfo HFI) {
  return static_cast<CXCharacteristicKind>(
      reinterpret_cast<clang::HeaderFileInfo *>(HFI)->DirInfo);
}

bool clang_HeaderFileInfo_getExternal(CXHeaderFileInfo HFI) {
  return reinterpret_cast<clang::HeaderFileInfo *>(HFI)->External;
}

bool clang_HeaderFileInfo_getIsModuleHeader(CXHeaderFileInfo HFI) {
  return reinterpret_cast<clang::HeaderFileInfo *>(HFI)->isModuleHeader;
}

bool clang_HeaderFileInfo_getIsCompilingModuleHeader(CXHeaderFileInfo HFI) {
  return reinterpret_cast<clang::HeaderFileInfo *>(HFI)->isCompilingModuleHeader;
}

bool clang_HeaderFileInfo_getIsValid(CXHeaderFileInfo HFI) {
  return reinterpret_cast<clang::HeaderFileInfo *>(HFI)->IsValid;
}

CXIdentifierInfo clang_HeaderFileInfo_getControllingMacroRaw(CXHeaderFileInfo HFI) {
  return reinterpret_cast<CXIdentifierInfo>(const_cast<clang::IdentifierInfo *>(
      reinterpret_cast<clang::HeaderFileInfo *>(HFI)->ControllingMacro));
}

CXString clang_HeaderFileInfo_getFramework(CXHeaderFileInfo HFI) {
  return extra::makeCXString(reinterpret_cast<clang::HeaderFileInfo *>(HFI)->Framework.str());
}

CXHeaderFileInfo clang_HeaderSearch_copyFileInfo(CXHeaderSearch HS, CXFileEntryRef FE) {
  return reinterpret_cast<CXHeaderFileInfo>(new clang::HeaderFileInfo(reinterpret_cast<clang::HeaderSearch *>(HS)->getFileInfo(
      *reinterpret_cast<clang::FileEntryRef *>(FE))));
}

CXHeaderFileInfo clang_HeaderSearch_copyExistingFileInfo(CXHeaderSearch HS,
                                                         CXFileEntryRef FE,
                                                         bool WantExternal) {
  const clang::HeaderFileInfo *HFI =
      reinterpret_cast<clang::HeaderSearch *>(HS)->getExistingFileInfo(
          *reinterpret_cast<clang::FileEntryRef *>(FE), WantExternal);
  return reinterpret_cast<CXHeaderFileInfo>(HFI ? new clang::HeaderFileInfo(*HFI) : nullptr);
}

void clang_HeaderFileInfo_dispose(CXHeaderFileInfo HFI) {
  delete reinterpret_cast<clang::HeaderFileInfo *>(HFI);
}

void clang_HeaderSearch_AddSearchPath(CXHeaderSearch HS, CXDirectoryLookup Dir,
                                      bool isAngled) {
  reinterpret_cast<clang::HeaderSearch *>(HS)->AddSearchPath(
      *reinterpret_cast<clang::DirectoryLookup *>(Dir), isAngled);
}

void clang_HeaderSearch_AddSystemSearchPath(CXHeaderSearch HS, CXDirectoryLookup Dir) {
  reinterpret_cast<clang::HeaderSearch *>(HS)->AddSystemSearchPath(
      *reinterpret_cast<clang::DirectoryLookup *>(Dir));
}

CXHeaderMap clang_HeaderSearch_CreateHeaderMap(CXHeaderSearch HS, CXFileEntryRef FE) {
  return reinterpret_cast<CXHeaderMap>(const_cast<clang::HeaderMap *>(
      reinterpret_cast<clang::HeaderSearch *>(HS)->CreateHeaderMap(
          *reinterpret_cast<clang::FileEntryRef *>(FE))));
}

CXString clang_HeaderSearch_getCachedModuleFileName(CXHeaderSearch HS,
                                                    const char *ModuleName,
                                                    const char *ModuleMapPath) {
  return extra::makeCXString(reinterpret_cast<clang::HeaderSearch *>(HS)->getCachedModuleFileName(
      llvm::StringRef(ModuleName), llvm::StringRef(ModuleMapPath)));
}

CXFileEntryRef clang_HeaderSearch_LookupFile(CXHeaderSearch HS, const char *Filename,
                                             bool isAngled, bool SkipCache,
                                             bool CacheFailures, bool *IsMapped,
                                             bool *IsFrameworkFound) {
  using IncluderEntry = std::pair<clang::OptionalFileEntryRef, clang::DirectoryEntryRef>;
  llvm::ArrayRef<IncluderEntry> Includers;
  clang::OptionalFileEntryRef File =
      reinterpret_cast<clang::HeaderSearch *>(HS)->LookupFile(
          llvm::StringRef(Filename), clang::SourceLocation(), isAngled,
          /*FromDir=*/nullptr, /*CurDir=*/nullptr, Includers, /*SearchPath=*/nullptr,
          /*RelativePath=*/nullptr, /*RequestingModule=*/nullptr,
          /*SuggestedModule=*/nullptr, IsMapped, IsFrameworkFound, SkipCache,
          /*BuildSystemModule=*/false, /*OpenFile=*/true, CacheFailures);
  if (!File)
    return nullptr;
  std::unique_ptr<clang::FileEntryRef> ptr =
      std::make_unique<clang::FileEntryRef>(*File);
  return reinterpret_cast<CXFileEntryRef>(ptr.release());
}

bool clang_HeaderSearch_ShouldEnterIncludeFile(CXHeaderSearch HS, CXPreprocessor PP,
                                               CXFileEntryRef File, bool isImport,
                                               bool ModulesEnabled, CXModule_ M,
                                               bool *IsFirstIncludeOfFile) {
  bool First = false;
  bool Res = reinterpret_cast<clang::HeaderSearch *>(HS)->ShouldEnterIncludeFile(
      *reinterpret_cast<clang::Preprocessor *>(PP), *reinterpret_cast<clang::FileEntryRef *>(File),
      isImport, ModulesEnabled, reinterpret_cast<clang::Module *>(M), First);
  if (IsFirstIncludeOfFile)
    *IsFirstIncludeOfFile = First;
  return Res;
}
