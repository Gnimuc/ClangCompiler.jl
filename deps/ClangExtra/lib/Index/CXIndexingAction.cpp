#include "clang-ex/Index/CXIndexingAction.h"

#include "utils.h"

#include "clang/AST/ASTContext.h"
#include "clang/AST/DeclBase.h"
#include "clang/Basic/IdentifierTable.h"
#include "clang/Basic/SourceLocation.h"
#include "clang/Frontend/ASTUnit.h"
#include "clang/Index/IndexDataConsumer.h"
#include "clang/Index/IndexingAction.h"
#include "clang/Index/IndexingOptions.h"
#include "clang/Lex/MacroInfo.h"
#include "clang/Lex/Preprocessor.h"
#include "llvm/ADT/ArrayRef.h"

#include <memory>
#include <string>
#include <vector>

namespace {

struct Occurrence {
  const clang::Decl *D;
  std::string MacroName;
  unsigned Roles;
  clang::SourceLocation Loc;
  bool IsMacro;
};

// The one concrete IndexDataConsumer this library compiles in. Both handlers return true,
// so a walk always runs to completion; relations are dropped, since a relation is a second
// Decl plus its own role set and the pair-per-occurrence shape the C surface exposes has
// nowhere to put it.
class Collector : public clang::index::IndexDataConsumer {
public:
  std::vector<Occurrence> Occurrences;

  bool handleDeclOccurrence(const clang::Decl *D, clang::index::SymbolRoleSet Roles,
                            llvm::ArrayRef<clang::index::SymbolRelation> Relations,
                            clang::SourceLocation Loc, ASTNodeInfo ASTNode) override {
    Occurrences.push_back({D, std::string(), Roles, Loc, false});
    return true;
  }

  bool handleMacroOccurrence(const clang::IdentifierInfo *Name,
                             const clang::MacroInfo *MI,
                             clang::index::SymbolRoleSet Roles,
                             clang::SourceLocation Loc) override {
    Occurrences.push_back(
        {nullptr, Name ? Name->getName().str() : std::string(), Roles, Loc, true});
    return true;
  }
};

Collector *collector(CXIndexDataCollector C) {
  return reinterpret_cast<Collector *>(C);
}

clang::index::IndexingOptions makeOptions(CXSystemSymbolFilterKind SystemSymbolFilter,
                                          bool IndexFunctionLocals,
                                          bool IndexImplicitInstantiation,
                                          bool IndexMacros,
                                          bool IndexMacrosInPreprocessor,
                                          bool IndexParametersInDeclarations,
                                          bool IndexTemplateParameters) {
  clang::index::IndexingOptions Opts;
  Opts.SystemSymbolFilter =
      static_cast<clang::index::IndexingOptions::SystemSymbolFilterKind>(
          SystemSymbolFilter);
  Opts.IndexFunctionLocals = IndexFunctionLocals;
  Opts.IndexImplicitInstantiation = IndexImplicitInstantiation;
  Opts.IndexMacros = IndexMacros;
  Opts.IndexMacrosInPreprocessor = IndexMacrosInPreprocessor;
  Opts.IndexParametersInDeclarations = IndexParametersInDeclarations;
  Opts.IndexTemplateParameters = IndexTemplateParameters;
  return Opts;
}

} // namespace

CXIndexDataCollector clang_IndexDataCollector_create(void) {
  return reinterpret_cast<CXIndexDataCollector>(std::make_unique<Collector>().release());
}

void clang_IndexDataCollector_dispose(CXIndexDataCollector C) {
  delete reinterpret_cast<Collector *>(C);
}

void clang_IndexDataCollector_clear(CXIndexDataCollector C) {
  collector(C)->Occurrences.clear();
}

unsigned clang_IndexDataCollector_getNumOccurrences(CXIndexDataCollector C) {
  return static_cast<unsigned>(collector(C)->Occurrences.size());
}

bool clang_IndexDataCollector_isMacroOccurrence(CXIndexDataCollector C, unsigned I) {
  return collector(C)->Occurrences[I].IsMacro;
}

CXDecl clang_IndexDataCollector_getOccurrenceDecl(CXIndexDataCollector C, unsigned I) {
  return reinterpret_cast<CXDecl>(
      const_cast<clang::Decl *>(collector(C)->Occurrences[I].D));
}

CXString clang_IndexDataCollector_getOccurrenceMacroName(CXIndexDataCollector C,
                                                         unsigned I) {
  return extra::makeCXString(collector(C)->Occurrences[I].MacroName);
}

unsigned clang_IndexDataCollector_getOccurrenceRoles(CXIndexDataCollector C, unsigned I) {
  return collector(C)->Occurrences[I].Roles;
}

CXSourceLocation_ clang_IndexDataCollector_getOccurrenceLocation(CXIndexDataCollector C,
                                                                 unsigned I) {
  return reinterpret_cast<CXSourceLocation_>(
      collector(C)->Occurrences[I].Loc.getPtrEncoding());
}

void clang_index_indexASTUnit(CXASTUnit Unit, CXIndexDataCollector C,
                              CXSystemSymbolFilterKind SystemSymbolFilter,
                              bool IndexFunctionLocals, bool IndexImplicitInstantiation,
                              bool IndexMacros, bool IndexMacrosInPreprocessor,
                              bool IndexParametersInDeclarations,
                              bool IndexTemplateParameters) {
  clang::index::indexASTUnit(
      *reinterpret_cast<clang::ASTUnit *>(Unit), *collector(C),
      makeOptions(SystemSymbolFilter, IndexFunctionLocals, IndexImplicitInstantiation,
                  IndexMacros, IndexMacrosInPreprocessor, IndexParametersInDeclarations,
                  IndexTemplateParameters));
}

void clang_index_indexTopLevelDecls(CXASTContext Ctx, CXPreprocessor PP, CXDecl *Decls,
                                    unsigned NumDecls, CXIndexDataCollector C,
                                    CXSystemSymbolFilterKind SystemSymbolFilter,
                                    bool IndexFunctionLocals,
                                    bool IndexImplicitInstantiation, bool IndexMacros,
                                    bool IndexMacrosInPreprocessor,
                                    bool IndexParametersInDeclarations,
                                    bool IndexTemplateParameters) {
  std::vector<const clang::Decl *> Ds;
  Ds.reserve(NumDecls);
  for (unsigned I = 0; I != NumDecls; ++I)
    Ds.push_back(reinterpret_cast<clang::Decl *>(Decls[I]));
  clang::index::indexTopLevelDecls(
      *reinterpret_cast<clang::ASTContext *>(Ctx),
      *reinterpret_cast<clang::Preprocessor *>(PP), llvm::ArrayRef(Ds), *collector(C),
      makeOptions(SystemSymbolFilter, IndexFunctionLocals, IndexImplicitInstantiation,
                  IndexMacros, IndexMacrosInPreprocessor, IndexParametersInDeclarations,
                  IndexTemplateParameters));
}
