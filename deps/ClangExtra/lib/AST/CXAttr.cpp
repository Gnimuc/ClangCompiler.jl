#include "clang-ex/AST/CXAttr.h"

#include "clang/AST/Attr.h"
#include "clang/Basic/AttrKinds.h"

// Drift alarm: the vendored AttrList.inc must match the pinned LLVM version. One
// assert per attribute proves CXAttrKind equals clang's attr::Kind value-for-
// value. (clang exposes no attr count sentinel, so an attribute appended at the
// very end is only caught when AttrList.inc is re-vendored — the documented
// per-bump step — not by these asserts.)
#define ATTR(X)                                                                            \
  static_assert(static_cast<int>(CXAttrKind_##X) == static_cast<int>(clang::attr::X),      \
                "CXAttrKind drift: " #X);
#include "clang-ex/AST/AttrList.inc"

CXAttrKind clang_Attr_getKind(CXAttr A) {
  return static_cast<CXAttrKind>(static_cast<clang::Attr *>(A)->getKind());
}

const char *clang_Attr_getSpelling(CXAttr A) {
  return static_cast<clang::Attr *>(A)->getSpelling();
}

CXSourceRange_ clang_Attr_getRange(CXAttr A) {
  clang::SourceRange R = static_cast<clang::Attr *>(A)->getRange();
  return CXSourceRange_{R.getBegin().getPtrEncoding(), R.getEnd().getPtrEncoding()};
}

CXSourceLocation_ clang_Attr_getLocation(CXAttr A) {
  return static_cast<clang::Attr *>(A)->getLocation().getPtrEncoding();
}

bool clang_Attr_isImplicit(CXAttr A) {
  return static_cast<clang::Attr *>(A)->isImplicit();
}

bool clang_Attr_isInherited(CXAttr A) {
  return static_cast<clang::Attr *>(A)->isInherited();
}

bool clang_Attr_isPackExpansion(CXAttr A) {
  return static_cast<clang::Attr *>(A)->isPackExpansion();
}
