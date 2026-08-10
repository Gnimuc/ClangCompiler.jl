#ifndef LLVM_CLANG_C_EXTRA_CXASTMATCHERS_H
#define LLVM_CLANG_C_EXTRA_CXASTMATCHERS_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// The ~700 matcher factories that make up the static DSL are variadic function
// templates instantiated at the call site; none of them has an address, so none
// of them can be wrapped. What crosses this boundary instead is the payload of a
// match: clang::ast_matchers::BoundNodes, the map from every bind("id") in a
// matcher expression to the AST node that id matched. Build the matcher with
// clang_Parser_parseMatcherExpression (clang-ex/ASTMatchers/Dynamic/CXDynamicParser.h),
// run it with clang_MatchFinder_matchAST (clang-ex/ASTMatchers/CXASTMatchFinder.h),
// then read the results here.

// BoundNodes

// Every CXBoundNodes comes from clang_MatchFinder_getMatch, which hands out an
// OWNED copy of one entry of the finder's result list — the copy outlives the
// next match run, and must be released here.
void clang_BoundNodes_dispose(CXBoundNodes BN);

// helper: getMap().size(). The number of ids bound by the match; the map is
// keyed on std::string with std::less<>, so the ids below come out sorted.
unsigned clang_BoundNodes_getNumBindings(CXBoundNodes BN);

// helper: the Index-th key of getMap(). Index must be < getNumBindings; out of
// range yields the empty string rather than walking off the map.
CXString clang_BoundNodes_getBindingID(CXBoundNodes BN, unsigned Index);

// getNodeAs<T> for the four node families a dynamic matcher can bind and this
// shim already carries. C has no templates, so the destination type is spelled
// in the name; each returns NULL both when nothing is bound to ID and when
// something is bound whose kind is not convertible to T, which is what makes
// these the discriminator for a bound node's family. The Decl and Stmt results
// are borrowed AST-arena pointers, the QualType result is an opaque QualType
// value, and the TypeLoc result is a NEW heap box — release that one with
// clang_TypeLoc_dispose.
CXDecl clang_BoundNodes_getNodeAsDecl(CXBoundNodes BN, const char *ID);

CXStmt clang_BoundNodes_getNodeAsStmt(CXBoundNodes BN, const char *ID);

CXQualType clang_BoundNodes_getNodeAsQualType(CXBoundNodes BN, const char *ID);

CXTypeLoc clang_BoundNodes_getNodeAsTypeLoc(CXBoundNodes BN, const char *ID);

// getMap (the std::map itself; reached through the index pair above)

LLVM_CLANG_C_EXTERN_C_END

#endif
