#include "clang-ex/CrossTU/CXCrossTranslationUnit.h"

#include "utils.h"

#include "clang/AST/ASTContext.h"
#include "clang/AST/Decl.h"
#include "clang/AST/DeclBase.h"
#include "clang/CrossTU/CrossTranslationUnit.h"
#include "clang/Frontend/ASTUnit.h"
#include "clang/Frontend/CompilerInstance.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Support/Error.h"
#include "llvm/Support/raw_ostream.h"

#include <iterator>
#include <memory>
#include <optional>
#include <string>

using CTUIndex = llvm::StringMap<std::string>;

static CTUIndex *index_(CXCrossTUIndex Idx) { return reinterpret_cast<CTUIndex *>(Idx); }

static clang::cross_tu::CrossTranslationUnitContext *
ctu(CXCrossTranslationUnitContext CTU) {
  return reinterpret_cast<clang::cross_tu::CrossTranslationUnitContext *>(CTU);
}

// One place where an llvm::Expected is consumed: log what went wrong and hand the caller a
// null. Leaving the Error unconsumed aborts under an assertion build, so takeError's
// result always goes through llvm::toString here.
template <typename T> static T *flatten(llvm::Expected<T *> E, const char *What) {
  if (E)
    return *E;
  llvm::errs() << What << ": " << llvm::toString(E.takeError()) << "\n";
  return nullptr;
}

CXCrossTUIndex clang_CrossTUIndex_create(void) {
  return reinterpret_cast<CXCrossTUIndex>(std::make_unique<CTUIndex>().release());
}

void clang_CrossTUIndex_dispose(CXCrossTUIndex Idx) {
  delete reinterpret_cast<CTUIndex *>(Idx);
}

void clang_CrossTUIndex_set(CXCrossTUIndex Idx, const char *USR, const char *FilePath) {
  (*index_(Idx))[llvm::StringRef(USR)] = std::string(FilePath);
}

CXString clang_CrossTUIndex_lookup(CXCrossTUIndex Idx, const char *USR) {
  auto It = index_(Idx)->find(llvm::StringRef(USR));
  if (It == index_(Idx)->end())
    return extra::makeCXString("");
  return extra::makeCXString(It->second);
}

unsigned clang_CrossTUIndex_getNumEntries(CXCrossTUIndex Idx) {
  return static_cast<unsigned>(index_(Idx)->size());
}

CXString clang_CrossTUIndex_getUSR(CXCrossTUIndex Idx, unsigned I) {
  auto It = index_(Idx)->begin();
  std::advance(It, I);
  return extra::makeCXString(It->getKey().str());
}

CXString clang_CrossTUIndex_getFilePath(CXCrossTUIndex Idx, unsigned I) {
  auto It = index_(Idx)->begin();
  std::advance(It, I);
  return extra::makeCXString(It->second);
}

CXCrossTUIndex clang_cross_tu_parseCrossTUIndex(const char *IndexPath) {
  llvm::Expected<CTUIndex> Parsed =
      clang::cross_tu::parseCrossTUIndex(llvm::StringRef(IndexPath));
  if (!Parsed) {
    llvm::errs() << "parseCrossTUIndex: " << llvm::toString(Parsed.takeError()) << "\n";
    return nullptr;
  }
  return reinterpret_cast<CXCrossTUIndex>(std::make_unique<CTUIndex>(std::move(*Parsed))
                                              .release());
}

CXString clang_cross_tu_createCrossTUIndexString(CXCrossTUIndex Idx) {
  return extra::makeCXString(clang::cross_tu::createCrossTUIndexString(*index_(Idx)));
}

bool clang_cross_tu_shouldImport(CXVarDecl VD, CXASTContext ACtx) {
  return clang::cross_tu::shouldImport(reinterpret_cast<clang::VarDecl *>(VD),
                                       *reinterpret_cast<clang::ASTContext *>(ACtx));
}

CXCrossTranslationUnitContext
clang_CrossTranslationUnitContext_create(CXCompilerInstance CI) {
  auto C = std::make_unique<clang::cross_tu::CrossTranslationUnitContext>(
      *reinterpret_cast<clang::CompilerInstance *>(CI));
  return reinterpret_cast<CXCrossTranslationUnitContext>(C.release());
}

void clang_CrossTranslationUnitContext_dispose(CXCrossTranslationUnitContext CTU) {
  delete reinterpret_cast<clang::cross_tu::CrossTranslationUnitContext *>(CTU);
}

CXFunctionDecl clang_CrossTranslationUnitContext_getCrossTUDefinitionForFunction(
    CXCrossTranslationUnitContext CTU, CXFunctionDecl FD, const char *CrossTUDir,
    const char *IndexName, bool DisplayCTUProgress) {
  const clang::FunctionDecl *Def =
      flatten(ctu(CTU)->getCrossTUDefinition(reinterpret_cast<clang::FunctionDecl *>(FD),
                                            llvm::StringRef(CrossTUDir),
                                            llvm::StringRef(IndexName),
                                            DisplayCTUProgress),
              "getCrossTUDefinition");
  return reinterpret_cast<CXFunctionDecl>(const_cast<clang::FunctionDecl *>(Def));
}

CXVarDecl clang_CrossTranslationUnitContext_getCrossTUDefinitionForVar(
    CXCrossTranslationUnitContext CTU, CXVarDecl VD, const char *CrossTUDir,
    const char *IndexName, bool DisplayCTUProgress) {
  const clang::VarDecl *Def = flatten(
      ctu(CTU)->getCrossTUDefinition(reinterpret_cast<clang::VarDecl *>(VD),
                                     llvm::StringRef(CrossTUDir),
                                     llvm::StringRef(IndexName), DisplayCTUProgress),
      "getCrossTUDefinition");
  return reinterpret_cast<CXVarDecl>(const_cast<clang::VarDecl *>(Def));
}

CXASTUnit clang_CrossTranslationUnitContext_loadExternalAST(
    CXCrossTranslationUnitContext CTU, const char *LookupName, const char *CrossTUDir,
    const char *IndexName, bool DisplayCTUProgress) {
  clang::ASTUnit *Unit =
      flatten(ctu(CTU)->loadExternalAST(llvm::StringRef(LookupName),
                                        llvm::StringRef(CrossTUDir),
                                        llvm::StringRef(IndexName), DisplayCTUProgress),
              "loadExternalAST");
  return reinterpret_cast<CXASTUnit>(Unit);
}

CXFunctionDecl clang_CrossTranslationUnitContext_importDefinitionForFunction(
    CXCrossTranslationUnitContext CTU, CXFunctionDecl FD, CXASTUnit Unit) {
  const clang::FunctionDecl *Def =
      flatten(ctu(CTU)->importDefinition(reinterpret_cast<clang::FunctionDecl *>(FD),
                                         reinterpret_cast<clang::ASTUnit *>(Unit)),
              "importDefinition");
  return reinterpret_cast<CXFunctionDecl>(const_cast<clang::FunctionDecl *>(Def));
}

CXVarDecl clang_CrossTranslationUnitContext_importDefinitionForVar(
    CXCrossTranslationUnitContext CTU, CXVarDecl VD, CXASTUnit Unit) {
  const clang::VarDecl *Def =
      flatten(ctu(CTU)->importDefinition(reinterpret_cast<clang::VarDecl *>(VD),
                                         reinterpret_cast<clang::ASTUnit *>(Unit)),
              "importDefinition");
  return reinterpret_cast<CXVarDecl>(const_cast<clang::VarDecl *>(Def));
}

CXString clang_CrossTranslationUnitContext_getLookupName(CXNamedDecl ND) {
  std::optional<std::string> Name =
      clang::cross_tu::CrossTranslationUnitContext::getLookupName(
          reinterpret_cast<clang::NamedDecl *>(ND));
  return extra::makeCXString(Name ? *Name : std::string());
}

bool clang_CrossTranslationUnitContext_isImportedAsNew(CXCrossTranslationUnitContext CTU,
                                                       CXDecl ToDecl) {
  return ctu(CTU)->isImportedAsNew(reinterpret_cast<clang::Decl *>(ToDecl));
}

bool clang_CrossTranslationUnitContext_hasError(CXCrossTranslationUnitContext CTU,
                                                CXDecl ToDecl) {
  return ctu(CTU)->hasError(reinterpret_cast<clang::Decl *>(ToDecl));
}
