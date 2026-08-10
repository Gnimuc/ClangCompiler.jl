#include "clang-ex/Analysis/CXUninitializedValues.h"
#include "clang/AST/Decl.h"
#include "clang/AST/DeclBase.h"
#include "clang/AST/Expr.h"
#include "clang/AST/Stmt.h"
#include "clang/Analysis/AnalysisDeclContext.h"
#include "clang/Analysis/CFG.h"
#include "clang/Analysis/Analyses/UninitializedValues.h"
#include <memory>
#include <utility>
#include <vector>

namespace {

// One clang::UninitUse report, copied out of the temporary clang hands the handler.
struct UninitUseRecord {
  const clang::VarDecl *VD = nullptr;
  const clang::Expr *User = nullptr;
  clang::UninitUse::Kind Kind = clang::UninitUse::Maybe;
  bool ConstRef = false;
  std::vector<const clang::Stmt *> BranchTerminators;
  std::vector<unsigned> BranchOutputs;
};

struct UninitVariablesResult {
  std::vector<UninitUseRecord> Uses;
  std::vector<const clang::VarDecl *> SelfInits;
  clang::UninitVariablesAnalysisStats Stats = {0, 0};
};

// The one fixed handler subclass the shim compiles: it records instead of diagnosing.
class CollectingUninitHandler : public clang::UninitVariablesHandler {
  UninitVariablesResult &R;

  void record(const clang::VarDecl *vd, const clang::UninitUse &use, bool ConstRef) {
    UninitUseRecord Rec;
    Rec.VD = vd;
    Rec.User = use.getUser();
    Rec.Kind = use.getKind();
    Rec.ConstRef = ConstRef;
    for (clang::UninitUse::branch_iterator I = use.branch_begin(), E = use.branch_end();
         I != E; ++I) {
      Rec.BranchTerminators.push_back(I->Terminator);
      Rec.BranchOutputs.push_back(I->Output);
    }
    R.Uses.push_back(std::move(Rec));
  }

public:
  explicit CollectingUninitHandler(UninitVariablesResult &R) : R(R) {}

  void handleUseOfUninitVariable(const clang::VarDecl *vd,
                                 const clang::UninitUse &use) override {
    record(vd, use, /*ConstRef=*/false);
  }

  void handleConstRefUseOfUninitVariable(const clang::VarDecl *vd,
                                         const clang::UninitUse &use) override {
    record(vd, use, /*ConstRef=*/true);
  }

  void handleSelfInit(const clang::VarDecl *vd) override { R.SelfInits.push_back(vd); }
};

} // namespace

CXUninitVariablesResult clang_UninitVariablesResult_create(CXDeclContext DC, CXCFG G,
                                                           CXAnalysisDeclContext ADC) {
  auto R = std::make_unique<UninitVariablesResult>();
  CollectingUninitHandler Handler(*R);
  clang::runUninitializedVariablesAnalysis(
      *reinterpret_cast<clang::DeclContext *>(DC), *reinterpret_cast<clang::CFG *>(G),
      *reinterpret_cast<clang::AnalysisDeclContext *>(ADC), Handler, R->Stats);
  return reinterpret_cast<CXUninitVariablesResult>(R.release());
}

void clang_UninitVariablesResult_dispose(CXUninitVariablesResult R) {
  delete reinterpret_cast<UninitVariablesResult *>(R);
}

unsigned clang_UninitVariablesResult_getNumVariablesAnalyzed(CXUninitVariablesResult R) {
  return reinterpret_cast<UninitVariablesResult *>(R)->Stats.NumVariablesAnalyzed;
}

unsigned clang_UninitVariablesResult_getNumBlockVisits(CXUninitVariablesResult R) {
  return reinterpret_cast<UninitVariablesResult *>(R)->Stats.NumBlockVisits;
}

unsigned clang_UninitVariablesResult_getNumUses(CXUninitVariablesResult R) {
  return static_cast<unsigned>(reinterpret_cast<UninitVariablesResult *>(R)->Uses.size());
}

CXVarDecl clang_UninitVariablesResult_getVarDecl(CXUninitVariablesResult R, unsigned I) {
  return reinterpret_cast<CXVarDecl>(const_cast<clang::VarDecl *>(
      reinterpret_cast<UninitVariablesResult *>(R)->Uses[I].VD));
}

CXExpr clang_UninitVariablesResult_getUser(CXUninitVariablesResult R, unsigned I) {
  return reinterpret_cast<CXExpr>(const_cast<clang::Expr *>(
      reinterpret_cast<UninitVariablesResult *>(R)->Uses[I].User));
}

CXUninitUseKind clang_UninitVariablesResult_getKind(CXUninitVariablesResult R, unsigned I) {
  return static_cast<CXUninitUseKind>(
      reinterpret_cast<UninitVariablesResult *>(R)->Uses[I].Kind);
}

bool clang_UninitVariablesResult_isConstRefUse(CXUninitVariablesResult R, unsigned I) {
  return reinterpret_cast<UninitVariablesResult *>(R)->Uses[I].ConstRef;
}

unsigned clang_UninitVariablesResult_getNumBranches(CXUninitVariablesResult R, unsigned I) {
  return static_cast<unsigned>(
      reinterpret_cast<UninitVariablesResult *>(R)->Uses[I].BranchTerminators.size());
}

CXStmt clang_UninitVariablesResult_getBranchTerminator(CXUninitVariablesResult R,
                                                       unsigned I, unsigned J) {
  return reinterpret_cast<CXStmt>(const_cast<clang::Stmt *>(
      reinterpret_cast<UninitVariablesResult *>(R)->Uses[I].BranchTerminators[J]));
}

unsigned clang_UninitVariablesResult_getBranchOutput(CXUninitVariablesResult R, unsigned I,
                                                     unsigned J) {
  return reinterpret_cast<UninitVariablesResult *>(R)->Uses[I].BranchOutputs[J];
}

unsigned clang_UninitVariablesResult_getNumSelfInits(CXUninitVariablesResult R) {
  return static_cast<unsigned>(
      reinterpret_cast<UninitVariablesResult *>(R)->SelfInits.size());
}

CXVarDecl clang_UninitVariablesResult_getSelfInit(CXUninitVariablesResult R, unsigned I) {
  return reinterpret_cast<CXVarDecl>(const_cast<clang::VarDecl *>(
      reinterpret_cast<UninitVariablesResult *>(R)->SelfInits[I]));
}
