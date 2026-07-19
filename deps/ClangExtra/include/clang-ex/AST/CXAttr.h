#ifndef LLVM_CLANG_C_EXTRA_CXATTR_H
#define LLVM_CLANG_C_EXTRA_CXATTR_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// The attribute-kind surface below is stamped from the vendored
// clang-ex/AST/AttrList.inc (a verbatim copy of clang's TableGen output for the
// pinned LLVM version). Mirror-by-construction: the same table clang uses to
// build clang::attr::Kind builds CXAttrKind here, and the impl-side
// static_assert table in CXAttr.cpp proves value-for-value equality, so a stale
// vendored copy fails the build. POLICY: stamped symbols (CXAttrKind_*) are
// version-following per LLVM major, exempt from the frozen-ABI rule. Per-class
// downcasts are intentionally NOT stamped yet: attribute payload is unwrapped,
// so getKind + getSpelling is the classification surface for now.

// Mirrors clang::attr::Kind: one enumerator per attribute (AttrList.inc order)
// plus the First##Base/Last##Base category range markers.
typedef enum CXAttrKind {
#define ATTR(X) CXAttrKind_##X,
#define ATTR_RANGE(CLASS, FIRST, LAST)                                                     \
  CXAttrKind_First##CLASS = CXAttrKind_##FIRST, CXAttrKind_Last##CLASS = CXAttrKind_##LAST,
#include "clang-ex/AST/AttrList.inc"
} CXAttrKind;

// Attr base API (hand-written).
CXAttrKind clang_Attr_getKind(CXAttr A);

// Borrowed: a static spelling string owned by clang.
const char *clang_Attr_getSpelling(CXAttr A);

CXSourceRange_ clang_Attr_getRange(CXAttr A);

CXSourceLocation_ clang_Attr_getLocation(CXAttr A);

bool clang_Attr_isImplicit(CXAttr A);

bool clang_Attr_isInherited(CXAttr A);

bool clang_Attr_isPackExpansion(CXAttr A);

LLVM_CLANG_C_EXTERN_C_END

#endif
