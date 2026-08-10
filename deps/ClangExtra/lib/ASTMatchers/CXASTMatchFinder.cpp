#include "clang-ex/ASTMatchers/CXASTMatchFinder.h"

#include "clang/AST/ASTContext.h"
#include "clang/AST/ASTTypeTraits.h"
#include "clang/AST/DeclBase.h"
#include "clang/AST/Stmt.h"
#include "clang/AST/Type.h"
#include "clang/ASTMatchers/ASTMatchFinder.h"
#include "clang/ASTMatchers/ASTMatchers.h"
#include "clang/ASTMatchers/ASTMatchersInternal.h"
#include "llvm/ADT/SmallVector.h"

#include <memory>
#include <optional>

namespace {
// The collector clang itself uses for its header-inline match() helpers
// (clang::ast_matchers::internal::CollectMatchesCallback, ASTMatchFinder.h:287),
// reproduced here rather than reused because that one is declared inside a
// header's internal namespace with no out-of-line definition to link against.
// Returning std::nullopt from getCheckTraversalKind is what keeps the traversal
// kind the matcher's own business (see
// clang_DynTypedMatcher_withTraversalKind) instead of overriding it per check.
class CollectMatchesCallback : public clang::ast_matchers::MatchFinder::MatchCallback {
public:
  llvm::SmallVector<clang::ast_matchers::BoundNodes, 1> Nodes;

  void run(const clang::ast_matchers::MatchFinder::MatchResult &Result) override {
    Nodes.push_back(Result.Nodes);
  }

  std::optional<clang::TraversalKind> getCheckTraversalKind() const override {
    return std::nullopt;
  }
};

// MatchFinder stores a bare MatchCallback* and does not own it, so the finder
// and its one collector have to share a lifetime; this pairing is what
// CXMatchFinder points at.
struct MatchFinderState {
  clang::ast_matchers::MatchFinder Finder;
  CollectMatchesCallback Callback;
};

MatchFinderState *state(CXMatchFinder MF) {
  return reinterpret_cast<MatchFinderState *>(MF);
}
} // namespace

CXMatchFinder clang_MatchFinder_create(void) {
  return reinterpret_cast<CXMatchFinder>(std::make_unique<MatchFinderState>().release());
}

void clang_MatchFinder_dispose(CXMatchFinder MF) {
  delete state(MF); // NOLINT(*-owning-memory)
}

bool clang_MatchFinder_addDynamicMatcher(CXMatchFinder MF, CXDynTypedMatcher NodeMatch) {
  MatchFinderState *S = state(MF);
  return S->Finder.addDynamicMatcher(
      *reinterpret_cast<clang::ast_matchers::internal::DynTypedMatcher *>(NodeMatch),
      &S->Callback);
}

unsigned clang_MatchFinder_matchAST(CXMatchFinder MF, CXASTContext Context) {
  MatchFinderState *S = state(MF);
  S->Callback.Nodes.clear();
  S->Finder.matchAST(*reinterpret_cast<clang::ASTContext *>(Context));
  return static_cast<unsigned>(S->Callback.Nodes.size());
}

unsigned clang_MatchFinder_matchDecl(CXMatchFinder MF, CXDecl Node, CXASTContext Context) {
  MatchFinderState *S = state(MF);
  S->Callback.Nodes.clear();
  S->Finder.match(clang::DynTypedNode::create(*reinterpret_cast<clang::Decl *>(Node)),
                  *reinterpret_cast<clang::ASTContext *>(Context));
  return static_cast<unsigned>(S->Callback.Nodes.size());
}

unsigned clang_MatchFinder_matchStmt(CXMatchFinder MF, CXStmt Node, CXASTContext Context) {
  MatchFinderState *S = state(MF);
  S->Callback.Nodes.clear();
  S->Finder.match(clang::DynTypedNode::create(*reinterpret_cast<clang::Stmt *>(Node)),
                  *reinterpret_cast<clang::ASTContext *>(Context));
  return static_cast<unsigned>(S->Callback.Nodes.size());
}

unsigned clang_MatchFinder_matchQualType(CXMatchFinder MF, CXQualType Node,
                                         CXASTContext Context) {
  MatchFinderState *S = state(MF);
  S->Callback.Nodes.clear();
  clang::QualType QT = clang::QualType::getFromOpaquePtr(reinterpret_cast<void *>(Node));
  S->Finder.match(clang::DynTypedNode::create(QT),
                  *reinterpret_cast<clang::ASTContext *>(Context));
  return static_cast<unsigned>(S->Callback.Nodes.size());
}

unsigned clang_MatchFinder_getNumMatches(CXMatchFinder MF) {
  return static_cast<unsigned>(state(MF)->Callback.Nodes.size());
}

CXBoundNodes clang_MatchFinder_getMatch(CXMatchFinder MF, unsigned Index) {
  MatchFinderState *S = state(MF);
  if (Index >= S->Callback.Nodes.size())
    return nullptr;
  return reinterpret_cast<CXBoundNodes>( // NOLINT(*-owning-memory)
      new clang::ast_matchers::BoundNodes(S->Callback.Nodes[Index]));
}
