#ifndef LLVM_CLANG_C_EXTRA_CXRECORDLAYOUT_H
#define LLVM_CLANG_C_EXTRA_CXRECORDLAYOUT_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// ASTRecordLayout
// All handles are borrowed interior pointers into the ASTContext arena (see
// clang_ASTContext_getASTRecordLayout) — no dispose. CharUnits quantities are
// returned in BYTES as int64_t; getFieldOffset alone is in BITS (uint64_t),
// matching the C++ API.
int64_t clang_ASTRecordLayout_getAlignment(CXASTRecordLayout RL);

int64_t clang_ASTRecordLayout_getPreferredAlignment(CXASTRecordLayout RL);

int64_t clang_ASTRecordLayout_getUnadjustedAlignment(CXASTRecordLayout RL);

int64_t clang_ASTRecordLayout_getRequiredAlignment(CXASTRecordLayout RL);

int64_t clang_ASTRecordLayout_getSize(CXASTRecordLayout RL);

unsigned clang_ASTRecordLayout_getFieldCount(CXASTRecordLayout RL);

uint64_t clang_ASTRecordLayout_getFieldOffset(CXASTRecordLayout RL, unsigned FieldNo);

int64_t clang_ASTRecordLayout_getDataSize(CXASTRecordLayout RL);

// The queries from here down require a C++ record's layout (they read the
// CXXInfo side table); the Julia layer routes only CXXRecordDecl layouts here.
int64_t clang_ASTRecordLayout_getNonVirtualSize(CXASTRecordLayout RL);

int64_t clang_ASTRecordLayout_getNonVirtualAlignment(CXASTRecordLayout RL);

int64_t clang_ASTRecordLayout_getPreferredNVAlignment(CXASTRecordLayout RL);

int64_t clang_ASTRecordLayout_getSizeOfLargestEmptySubobject(CXASTRecordLayout RL);

// The base-offset queries require the base to actually appear in the layout's
// (v)base map; the Julia layer establishes that before calling.
int64_t clang_ASTRecordLayout_getBaseClassOffset(CXASTRecordLayout RL,
                                                 CXCXXRecordDecl Base);

int64_t clang_ASTRecordLayout_getVBaseClassOffset(CXASTRecordLayout RL,
                                                  CXCXXRecordDecl VBase);

int64_t clang_ASTRecordLayout_getVBPtrOffset(CXASTRecordLayout RL);

bool clang_ASTRecordLayout_hasOwnVFPtr(CXASTRecordLayout RL);

bool clang_ASTRecordLayout_hasExtendableVFPtr(CXASTRecordLayout RL);

bool clang_ASTRecordLayout_hasOwnVBPtr(CXASTRecordLayout RL);

bool clang_ASTRecordLayout_hasVBPtr(CXASTRecordLayout RL);

// The primary base class -- the one whose vtable this class shares -- or NULL when there is
// none. PRECONDITION: the layout was obtained for a CXXRecordDecl; clang asserts CXXInfo.
// Not observable from the layout handle, so it is documented rather than asserted, matching
// the existing getNonVirtualSize / hasOwnVFPtr tail.
CXCXXRecordDecl clang_ASTRecordLayout_getPrimaryBase(CXASTRecordLayout RL);

// Whether the primary base is virtually inherited. Same documented CXXInfo precondition.
bool clang_ASTRecordLayout_isPrimaryBaseVirtual(CXASTRecordLayout RL);

// Whether the record ends with a zero-sized subobject.
//
// UNLIKE the tail above, this one is TOTAL. clang spells it `CXXInfo &&
// CXXInfo->EndsWithZeroSizedObject`, so a layout carrying no C++ info answers false instead
// of aborting, and it is safe on the layout of a C struct or any non-CXXRecordDecl.
bool clang_ASTRecordLayout_endsWithZeroSizedObject(CXASTRecordLayout RL);

// Whether the record begins with a zero-sized base class.
//
// PRECONDITION: the layout was obtained for a CXXRecordDecl; clang asserts CXXInfo here,
// where endsWithZeroSizedObject merely checks it. The two sit one after the other in
// clang's own header and differ in exactly this. The condition is not observable from the
// layout handle -- CXXInfo is private and clang exports no predicate over it -- so it is
// documented rather than gated, matching the getNonVirtualSize / hasOwnVFPtr tail.
bool clang_ASTRecordLayout_leadsWithZeroSizedBase(CXASTRecordLayout RL);

LLVM_CLANG_C_EXTERN_C_END

#endif
