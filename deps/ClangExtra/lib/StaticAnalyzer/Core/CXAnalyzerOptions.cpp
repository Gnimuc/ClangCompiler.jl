#include "clang-ex/StaticAnalyzer/Core/CXAnalyzerOptions.h"

#include "utils.h"

#include "clang/StaticAnalyzer/Core/AnalyzerOptions.h"
#include "llvm/ADT/StringRef.h"

#include <string>
#include <utility>
#include <vector>

static clang::AnalyzerOptions *opts(CXAnalyzerOptions AO) {
  return reinterpret_cast<clang::AnalyzerOptions *>(AO);
}

CXStringSet *clang_AnalyzerOptions_getRegisteredCheckers(bool IncludeExperimental) {
  std::vector<std::string> Names;
  for (llvm::StringRef N :
       clang::AnalyzerOptions::getRegisteredCheckers(IncludeExperimental))
    Names.emplace_back(N.str());
  return extra::makeCXStringSet(Names);
}

CXStringSet *clang_AnalyzerOptions_getRegisteredPackages(bool IncludeExperimental) {
  std::vector<std::string> Names;
  for (llvm::StringRef N :
       clang::AnalyzerOptions::getRegisteredPackages(IncludeExperimental))
    Names.emplace_back(N.str());
  return extra::makeCXStringSet(Names);
}

// CheckersAndPackages
void clang_AnalyzerOptions_addCheckerOrPackage(CXAnalyzerOptions AO, const char *Name,
                                               bool Enable) {
  opts(AO)->CheckersAndPackages.emplace_back(std::string(Name), Enable);
}

unsigned clang_AnalyzerOptions_getNumCheckersAndPackages(CXAnalyzerOptions AO) {
  return static_cast<unsigned>(opts(AO)->CheckersAndPackages.size());
}

CXString clang_AnalyzerOptions_getCheckerOrPackageName(CXAnalyzerOptions AO, unsigned I) {
  return extra::makeCXString(opts(AO)->CheckersAndPackages[I].first);
}

bool clang_AnalyzerOptions_isCheckerOrPackageEnabled(CXAnalyzerOptions AO, unsigned I) {
  return opts(AO)->CheckersAndPackages[I].second;
}

// SilencedCheckersAndPackages
void clang_AnalyzerOptions_addSilencedCheckerOrPackage(CXAnalyzerOptions AO,
                                                       const char *Name) {
  opts(AO)->SilencedCheckersAndPackages.emplace_back(Name);
}

unsigned clang_AnalyzerOptions_getNumSilencedCheckersAndPackages(CXAnalyzerOptions AO) {
  return static_cast<unsigned>(opts(AO)->SilencedCheckersAndPackages.size());
}

CXString clang_AnalyzerOptions_getSilencedCheckerOrPackage(CXAnalyzerOptions AO,
                                                           unsigned I) {
  return extra::makeCXString(opts(AO)->SilencedCheckersAndPackages[I]);
}

// Config
void clang_AnalyzerOptions_setConfig(CXAnalyzerOptions AO, const char *Key,
                                     const char *Value) {
  opts(AO)->Config[llvm::StringRef(Key)] = std::string(Value);
}

CXString clang_AnalyzerOptions_getConfig(CXAnalyzerOptions AO, const char *Key) {
  auto It = opts(AO)->Config.find(llvm::StringRef(Key));
  if (It == opts(AO)->Config.end())
    return extra::makeCXString("");
  return extra::makeCXString(It->second);
}

unsigned clang_AnalyzerOptions_getNumConfigEntries(CXAnalyzerOptions AO) {
  return static_cast<unsigned>(opts(AO)->Config.size());
}

// StringMap has no random access, so both index accessors walk the table. Both walk it in
// the same direction from the same iterator, so key I and value I are the same entry.
CXString clang_AnalyzerOptions_getConfigKey(CXAnalyzerOptions AO, unsigned I) {
  auto It = opts(AO)->Config.begin();
  std::advance(It, I);
  return extra::makeCXString(It->getKey().str());
}

CXString clang_AnalyzerOptions_getConfigValue(CXAnalyzerOptions AO, unsigned I) {
  auto It = opts(AO)->Config.begin();
  std::advance(It, I);
  return extra::makeCXString(It->second);
}

// Scalar knobs
CXAnalysisDiagClients clang_AnalyzerOptions_getAnalysisDiagOpt(CXAnalyzerOptions AO) {
  return static_cast<CXAnalysisDiagClients>(opts(AO)->AnalysisDiagOpt);
}

void clang_AnalyzerOptions_setAnalysisDiagOpt(CXAnalyzerOptions AO,
                                              CXAnalysisDiagClients Value) {
  opts(AO)->AnalysisDiagOpt = static_cast<clang::AnalysisDiagClients>(Value);
}

CXAnalysisConstraints
clang_AnalyzerOptions_getAnalysisConstraintsOpt(CXAnalyzerOptions AO) {
  return static_cast<CXAnalysisConstraints>(opts(AO)->AnalysisConstraintsOpt);
}

void clang_AnalyzerOptions_setAnalysisConstraintsOpt(CXAnalyzerOptions AO,
                                                     CXAnalysisConstraints Value) {
  opts(AO)->AnalysisConstraintsOpt = static_cast<clang::AnalysisConstraints>(Value);
}

CXString clang_AnalyzerOptions_getAnalyzeSpecificFunction(CXAnalyzerOptions AO) {
  return extra::makeCXString(opts(AO)->AnalyzeSpecificFunction);
}

void clang_AnalyzerOptions_setAnalyzeSpecificFunction(CXAnalyzerOptions AO,
                                                      const char *Value) {
  opts(AO)->AnalyzeSpecificFunction = std::string(Value);
}

CXString clang_AnalyzerOptions_getDumpExplodedGraphTo(CXAnalyzerOptions AO) {
  return extra::makeCXString(opts(AO)->DumpExplodedGraphTo);
}

void clang_AnalyzerOptions_setDumpExplodedGraphTo(CXAnalyzerOptions AO,
                                                  const char *Value) {
  opts(AO)->DumpExplodedGraphTo = std::string(Value);
}

unsigned clang_AnalyzerOptions_getMaxBlockVisitOnPath(CXAnalyzerOptions AO) {
  return opts(AO)->maxBlockVisitOnPath;
}

void clang_AnalyzerOptions_setMaxBlockVisitOnPath(CXAnalyzerOptions AO, unsigned Value) {
  opts(AO)->maxBlockVisitOnPath = Value;
}

// The four below are bitfields: value-copied in both directions, never addressed.
bool clang_AnalyzerOptions_getDisableAllCheckers(CXAnalyzerOptions AO) {
  return opts(AO)->DisableAllCheckers;
}

void clang_AnalyzerOptions_setDisableAllCheckers(CXAnalyzerOptions AO, bool Value) {
  opts(AO)->DisableAllCheckers = Value;
}

bool clang_AnalyzerOptions_getAnalyzeAll(CXAnalyzerOptions AO) {
  return opts(AO)->AnalyzeAll;
}

void clang_AnalyzerOptions_setAnalyzeAll(CXAnalyzerOptions AO, bool Value) {
  opts(AO)->AnalyzeAll = Value;
}

bool clang_AnalyzerOptions_getAnalyzerWerror(CXAnalyzerOptions AO) {
  return opts(AO)->AnalyzerWerror;
}

void clang_AnalyzerOptions_setAnalyzerWerror(CXAnalyzerOptions AO, bool Value) {
  opts(AO)->AnalyzerWerror = Value;
}

bool clang_AnalyzerOptions_getShouldEmitErrorsOnInvalidConfigValue(CXAnalyzerOptions AO) {
  return opts(AO)->ShouldEmitErrorsOnInvalidConfigValue;
}

void clang_AnalyzerOptions_setShouldEmitErrorsOnInvalidConfigValue(CXAnalyzerOptions AO,
                                                                   bool Value) {
  opts(AO)->ShouldEmitErrorsOnInvalidConfigValue = Value;
}
