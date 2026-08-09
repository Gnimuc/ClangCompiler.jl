#ifndef LLVM_CLANG_C_EXTRA_CXATTR_H
#define LLVM_CLANG_C_EXTRA_CXATTR_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// The attribute classification surface below is stamped from the vendored
// clang-ex/AST/AttrList.inc (a verbatim copy of clang's TableGen output for the
// pinned LLVM version). Mirror-by-construction: the same table clang uses to
// build clang::attr::Kind builds CXAttrKind here, and the impl-side
// static_assert table in CXAttr.cpp proves value-for-value equality, so a stale
// vendored copy fails the build. POLICY: stamped symbols (CXAttrKind_* and the
// castTo/is families) are version-following per LLVM major, exempt from the
// frozen-ABI rule.

// Mirrors clang::attr::Kind: one enumerator per attribute (AttrList.inc order)
// plus the First##Base/Last##Base category range markers.
typedef enum CXAttrKind {
#define ATTR(X) CXAttrKind_##X,
#define ATTR_RANGE(CLASS, FIRST, LAST)                                                     \
  CXAttrKind_First##CLASS = CXAttrKind_##FIRST, CXAttrKind_Last##CLASS = CXAttrKind_##LAST,
#include "clang-ex/AST/AttrList.inc"
} CXAttrKind;

// Null-safe downcast (dyn_cast_or_null: nullptr on wrong kind or null input)
// and kind predicate for every attribute class, stamped from the same vendored
// table. Attribute classes are leaves (clang derives no attribute from
// another), so unlike the Stmt/Decl stamps there are no abstract entries.
// Each cast returns the attribute's own handle, so narrowing is checked by the compiler.
#define ATTR(X)                                                                            \
  CX##X##Attr clang_Attr_castTo##X##Attr(CXAttr A);                                        \
  bool clang_Attr_is##X##Attr(CXAttr A);
#include "clang-ex/AST/AttrList.inc"
// Attr base API (hand-written).
CXAttrKind clang_Attr_getKind(CXAttr A);

// Borrowed: a static spelling string owned by clang.
const char *clang_Attr_getSpelling(CXAttr A);

CXSourceRange_ clang_Attr_getRange(CXAttr A);

CXSourceLocation_ clang_Attr_getLocation(CXAttr A);

bool clang_Attr_isImplicit(CXAttr A);

bool clang_Attr_isInherited(CXAttr A);

bool clang_Attr_isPackExpansion(CXAttr A);
// Per-attribute payload accessors (hand-written, Clang class order). The
// TableGen string payloads are stored as length+data with no NUL terminator,
// so they cross as owned CXString copies (Julia reads and frees them with
// get_string), never as borrowed const char*.

// AlignedAttr
// The alignment in bits, resolving either payload form (expression or type).
unsigned clang_AlignedAttr_getAlignment(CXAlignedAttr A, CXASTContext Ctx);

bool clang_AlignedAttr_isAlignmentExpr(CXAlignedAttr A);

// Precondition (asserted upstream): isAlignmentExpr. May still be null for the
// default-alignment `alignas()` form.
CXExpr clang_AlignedAttr_getAlignmentExpr(CXAlignedAttr A);

// AnnotateAttr
CXString clang_AnnotateAttr_getAnnotation(CXAnnotateAttr A);

unsigned clang_AnnotateAttr_args_size(CXAnnotateAttr A);

// AsmLabelAttr
CXString clang_AsmLabelAttr_getLabel(CXAsmLabelAttr A);

bool clang_AsmLabelAttr_getIsLiteralLabel(CXAsmLabelAttr A);

// AvailabilityAttr
CXIdentifierInfo clang_AvailabilityAttr_getPlatform(CXAvailabilityAttr A);

// The three version payloads follow clang_Decl_getVersionIntroduced: true (and fills
// *Major/*Minor/*Subminor) when the component is present, false leaves the out-params
// untouched. Absent minor/subminor components come back as 0, which is also a legal
// written value — an all-zero tuple and `10.0` are indistinguishable, as they are in
// VersionTuple itself.
bool clang_AvailabilityAttr_getIntroduced(CXAvailabilityAttr A, unsigned *Major,
                                          unsigned *Minor, unsigned *Subminor);

bool clang_AvailabilityAttr_getDeprecated(CXAvailabilityAttr A, unsigned *Major,
                                          unsigned *Minor, unsigned *Subminor);

bool clang_AvailabilityAttr_getObsoleted(CXAvailabilityAttr A, unsigned *Major,
                                         unsigned *Minor, unsigned *Subminor);

bool clang_AvailabilityAttr_getUnavailable(CXAvailabilityAttr A);

CXString clang_AvailabilityAttr_getMessage(CXAvailabilityAttr A);

bool clang_AvailabilityAttr_getStrict(CXAvailabilityAttr A);

CXString clang_AvailabilityAttr_getReplacement(CXAvailabilityAttr A);

int clang_AvailabilityAttr_getPriority(CXAvailabilityAttr A);

// CleanupAttr
CXFunctionDecl clang_CleanupAttr_getFunctionDecl(CXCleanupAttr A);

// ConstructorAttr
int clang_ConstructorAttr_getPriority(CXConstructorAttr A);

// DeprecatedAttr
CXString clang_DeprecatedAttr_getMessage(CXDeprecatedAttr A);

CXString clang_DeprecatedAttr_getReplacement(CXDeprecatedAttr A);

// DestructorAttr
int clang_DestructorAttr_getPriority(CXDestructorAttr A);

// FormatAttr
CXIdentifierInfo clang_FormatAttr_getType(CXFormatAttr A);

int clang_FormatAttr_getFormatIdx(CXFormatAttr A);

int clang_FormatAttr_getFirstArg(CXFormatAttr A);

// MaxFieldAlignmentAttr
// The `n` of `#pragma pack(n)`, in bits.
unsigned clang_MaxFieldAlignmentAttr_getAlignment(CXMaxFieldAlignmentAttr A);

// NonNullAttr
unsigned clang_NonNullAttr_args_size(CXNonNullAttr A);

// IdxAST is the zero-origin AST parameter index. True when the attribute names
// no parameters at all (a bare nonnull marks every pointer parameter).
bool clang_NonNullAttr_isNonNull(CXNonNullAttr A, unsigned IdxAST);

// SectionAttr
CXString clang_SectionAttr_getName(CXSectionAttr A);

// TLSModelAttr
CXString clang_TLSModelAttr_getModel(CXTLSModelAttr A);

// UnavailableAttr
CXString clang_UnavailableAttr_getMessage(CXUnavailableAttr A);

// VisibilityAttr
// Mirrors clang::VisibilityAttr::VisibilityType (class-local enum; synced in
// lib/Basic/CXEnumSync.cpp).
typedef enum CXVisibilityAttr_VisibilityType {
  CXVisibilityAttr_Default,
  CXVisibilityAttr_Hidden,
  CXVisibilityAttr_Protected
} CXVisibilityAttr_VisibilityType;

CXVisibilityAttr_VisibilityType clang_VisibilityAttr_getVisibility(CXVisibilityAttr A);

// WarnUnusedResultAttr
CXString clang_WarnUnusedResultAttr_getMessage(CXWarnUnusedResultAttr A);

LLVM_CLANG_C_EXTERN_C_END

#endif
