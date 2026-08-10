#ifndef LLVM_CLANG_C_EXTRA_CXASTMATCHERSINTERNAL_H
#define LLVM_CLANG_C_EXTRA_CXASTMATCHERSINTERNAL_H

#include "clang-ex/CXTypes.h"
#include "clang-ex/AST/CXParentMapContext.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang::ast_matchers::internal::DynTypedMatcher — the type-erased matcher the
// whole dynamic pipeline speaks in. There is no way to build one here: the
// constructors take a MatcherInterface<T> from the template DSL. The one source
// of a CXDynTypedMatcher is clang_Parser_parseMatcherExpression
// (clang-ex/ASTMatchers/Dynamic/CXDynamicParser.h); every function below either
// reads one or derives a new OWNED one from it.
//
// A DynTypedMatcher is a small value (two ASTNodeKinds and a refcounted
// implementation pointer) heap-boxed to cross the boundary, so every
// CXDynTypedMatcher is caller-owned.
void clang_DynTypedMatcher_dispose(CXDynTypedMatcher M);

// constructVariadic / constructRestrictedWrapper / trueMatcher / setAllowBind /
// dynCastTo / matches / matchesNoKindCheck / getID / unconditionalConvertTo
// (ASTNodeKind, DynTypedNode and BoundNodesTreeBuilder do not cross)

// A NEW matcher with ID bound to it, so every node it matches turns up in the
// BoundNodes under that id — the .bind("id") suffix applied after parsing,
// without re-parsing. NULL when this matcher does not support binding, which is
// what upstream's empty std::optional means. OWNED.
CXDynTypedMatcher clang_DynTypedMatcher_tryBind(CXDynTypedMatcher M, const char *ID);

// A NEW matcher over the same implementation with TK forced, overriding any
// kind already set. TK_IgnoreUnlessSpelledInSource is what makes a matcher skip
// the implicit casts, materialized temporaries and rewritten operator calls that
// otherwise sit between a template-heavy expression and its spelled children.
// OWNED.
CXDynTypedMatcher clang_DynTypedMatcher_withTraversalKind(CXDynTypedMatcher M,
                                                          CXTraversalKind TK);

// The kind actually respected by matching, which is usually UNSET: most matchers
// defer to the surrounding context. Split return — false means "no kind set",
// and *TK is then untouched. TK may be NULL to test only.
bool clang_DynTypedMatcher_getTraversalKind(CXDynTypedMatcher M, CXTraversalKind *TK);

// The node family this matcher works on ("Decl", "Stmt", "QualType", ...), as
// clang::ASTNodeKind::asStringRef spells it. ASTNodeKind is exposed as a string
// only: it is a bare kind index whose numbering is stamped from the node .inc
// files and therefore version-following, so mirroring it as an enum would freeze
// an LLVM-internal enumeration into this ABI.
CXString clang_DynTypedMatcher_getSupportedKind(CXDynTypedMatcher M);

// Whether M could be used where a matcher of To's node family is required — the
// validation that decides whether a parsed query can run against a given node.
// Since ASTNodeKind does not cross the boundary, the destination kind is spelled
// as a second matcher: To contributes only its getSupportedKind().
bool clang_DynTypedMatcher_canConvertTo(CXDynTypedMatcher M, CXDynTypedMatcher To);

// canMatchNodesOfKind (same ASTNodeKind argument; canConvertTo covers the
// question Julia can actually ask)

LLVM_CLANG_C_EXTERN_C_END

#endif
