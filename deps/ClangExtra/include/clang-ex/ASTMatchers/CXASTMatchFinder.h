#ifndef LLVM_CLANG_C_EXTRA_CXASTMATCHFINDER_H
#define LLVM_CLANG_C_EXTRA_CXASTMATCHFINDER_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// MatchFinder in COLLECT-RESULTS mode — the execution half of clang-query.
//
// Upstream MatchFinder reports matches by calling back into a MatchCallback
// subclass, and a virtual override cannot cross a C boundary. It does not have
// to: clang's own header-inline match()/matchDynamic() helpers
// (ASTMatchFinder.h:301-351) subclass MatchCallback with
// internal::CollectMatchesCallback, which only pushes each MatchResult::Nodes
// onto a list. CXMatchFinder is that pairing made explicit — a MatchFinder and
// one such collector allocated together — so the callback stays entirely inside
// libclangex and Julia reads a result list instead of implementing a virtual.
//
// A CXMatchFinder is caller-owned; the collector and its results die with it.
CXMatchFinder clang_MatchFinder_create(void);

void clang_MatchFinder_dispose(CXMatchFinder MF);

// addMatcher (the nine statically typed overloads; unwrappable — each takes a
// Matcher<T> built by the template DSL)

// The dynamic entry point: NodeMatch is a matcher parsed by
// clang_Parser_parseMatcherExpression. Returns false when NodeMatch is not a
// valid TOP-LEVEL matcher (its supported kind is not one of the node families
// the finder traverses); the matcher is then not registered. The finder does
// NOT take ownership of NodeMatch — it stores a copy, so the CXDynTypedMatcher
// may be disposed independently. Matchers accumulate: adding several and
// running once is one pass over the AST.
bool clang_MatchFinder_addDynamicMatcher(CXMatchFinder MF, CXDynTypedMatcher NodeMatch);

// newASTConsumer (returns a std::unique_ptr<ASTConsumer>; the adoption rules for
// that are CXASTConsumer's, not this file's)

// Run every registered matcher over the whole translation unit of Context and
// return the number of matches collected. Each run CLEARS the previous results
// first, so the list the accessors below read is always the last run's.
unsigned clang_MatchFinder_matchAST(CXMatchFinder MF, CXASTContext Context);

// match(DynTypedNode, ASTContext&) — matches on ONE node rather than the whole
// TU (wrap the matcher in findAll() to search the subtree under it). C has no
// overloads, so the node's family is spelled in the name; the DynTypedNode is
// built inside the shim. Same clear-then-collect contract as matchAST.
unsigned clang_MatchFinder_matchDecl(CXMatchFinder MF, CXDecl Node, CXASTContext Context);

unsigned clang_MatchFinder_matchStmt(CXMatchFinder MF, CXStmt Node, CXASTContext Context);

unsigned clang_MatchFinder_matchQualType(CXMatchFinder MF, CXQualType Node, CXASTContext Context);

// registerTestCallbackAfterParsing (testing-only hook, needs a virtual override)

// helper: the size of the collected result list — the same number the last
// match run returned, re-readable without re-running.
unsigned clang_MatchFinder_getNumMatches(CXMatchFinder MF);

// helper: an OWNED copy of the Index-th result's BoundNodes, released with
// clang_BoundNodes_dispose. A copy rather than a borrowed element because the
// next match run clears the list. NULL when Index >= getNumMatches.
CXBoundNodes clang_MatchFinder_getMatch(CXMatchFinder MF, unsigned Index);

LLVM_CLANG_C_EXTERN_C_END

#endif
