#include "clang-ex/Lex/CXHeaderSearch.h"
#include "utils.h"
#include "clang/Lex/DirectoryLookup.h"
#include "clang/Lex/HeaderSearch.h"
#include "llvm/ADT/SmallVector.h"
#include <string>
#include "clang/Basic/Diagnostic.h"

CXHeaderSearchOptions clang_HeaderSearch_getHeaderSearchOpts(CXHeaderSearch HS) {
  return &static_cast<clang::HeaderSearch *>(HS)->getHeaderSearchOpts();
}

CXFileManager clang_HeaderSearch_getFileMgr(CXHeaderSearch HS) {
  return &static_cast<clang::HeaderSearch *>(HS)->getFileMgr();
}

CXDiagnosticsEngine clang_HeaderSearch_getDiags(CXHeaderSearch HS) {
  return &static_cast<clang::HeaderSearch *>(HS)->getDiags();
}

bool clang_HeaderSearch_HasIncludeAliasMap(CXHeaderSearch HS) {
  return static_cast<clang::HeaderSearch *>(HS)->HasIncludeAliasMap();
}

void clang_HeaderSearch_AddIncludeAlias(CXHeaderSearch HS, const char *Source,
                                        const char *Dest) {
  static_cast<clang::HeaderSearch *>(HS)->AddIncludeAlias(llvm::StringRef(Source),
                                                          llvm::StringRef(Dest));
}

CXString clang_HeaderSearch_MapHeaderToIncludeAlias(CXHeaderSearch HS, const char *Source) {
  llvm::StringRef Alias = static_cast<clang::HeaderSearch *>(HS)->MapHeaderToIncludeAlias(
      llvm::StringRef(Source));
  return extra::makeCXString(Alias.str());
}

void clang_HeaderSearch_setModuleHash(CXHeaderSearch HS, const char *Hash) {
  static_cast<clang::HeaderSearch *>(HS)->setModuleHash(llvm::StringRef(Hash));
}

void clang_HeaderSearch_setModuleCachePath(CXHeaderSearch HS, const char *CachePath) {
  static_cast<clang::HeaderSearch *>(HS)->setModuleCachePath(llvm::StringRef(CachePath));
}

CXString clang_HeaderSearch_getModuleHash(CXHeaderSearch HS) {
  return extra::makeCXString(
      std::string(static_cast<clang::HeaderSearch *>(HS)->getModuleHash()));
}

CXString clang_HeaderSearch_getModuleCachePath(CXHeaderSearch HS) {
  return extra::makeCXString(
      std::string(static_cast<clang::HeaderSearch *>(HS)->getModuleCachePath()));
}

unsigned clang_HeaderSearch_getNumHeaderMapFileNames(CXHeaderSearch HS) {
  llvm::SmallVector<std::string, 4> Names;
  static_cast<clang::HeaderSearch *>(HS)->getHeaderMapFileNames(Names);
  return Names.size();
}

CXString clang_HeaderSearch_getHeaderMapFileName(CXHeaderSearch HS, unsigned Idx) {
  llvm::SmallVector<std::string, 4> Names;
  static_cast<clang::HeaderSearch *>(HS)->getHeaderMapFileNames(Names);
  return extra::makeCXString(Names[Idx]);
}

unsigned clang_HeaderSearch_header_file_size(CXHeaderSearch HS) {
  return static_cast<clang::HeaderSearch *>(HS)->header_file_size();
}

unsigned clang_HeaderSearch_search_dir_size(CXHeaderSearch HS) {
  return static_cast<clang::HeaderSearch *>(HS)->search_dir_size();
}

CXString clang_HeaderSearch_getSearchDirName(CXHeaderSearch HS, unsigned Idx) {
  auto *hs = static_cast<clang::HeaderSearch *>(HS);
  const clang::DirectoryLookup &DL = *hs->search_dir_nth(Idx);
  return extra::makeCXString(std::string(DL.getName()));
}

CXString clang_HeaderSearch_getUniqueFrameworkName(CXHeaderSearch HS,
                                                   const char *Framework) {
  llvm::StringRef Name = static_cast<clang::HeaderSearch *>(HS)->getUniqueFrameworkName(
      llvm::StringRef(Framework));
  return extra::makeCXString(Name.str());
}

void clang_HeaderSearch_PrintStats(CXHeaderSearch HS) {
  static_cast<clang::HeaderSearch *>(HS)->PrintStats();
}
size_t clang_HeaderSearch_getTotalMemory(CXHeaderSearch HS) {
  return static_cast<clang::HeaderSearch *>(HS)->getTotalMemory();
}
