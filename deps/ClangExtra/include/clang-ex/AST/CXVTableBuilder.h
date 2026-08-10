#ifndef LLVM_CLANG_C_EXTRA_CXVTABLEBUILDER_H
#define LLVM_CLANG_C_EXTRA_CXVTABLEBUILDER_H

#include "clang-ex/Basic/CXABI.h"
#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// The vtable layout clang itself computes for codegen. Together with the already-wrapped
// ASTRecordLayout (where a field sits) and ItaniumMangleContext::mangleCXXVTable (what the
// table's symbol is called) this completes the object model: which slot a virtual function
// occupies, and what every slot of the table holds.
//
// clang/AST/VTableBuilder.h: enum clang::VTableComponent::Kind — what one entry of a vtable
// is. The offset kinds carry a CharUnits quantity, the pointer kinds carry a decl.
typedef enum CXVTableComponent_Kind {
  CXVTableComponent_CK_VCallOffset,
  CXVTableComponent_CK_VBaseOffset,
  CXVTableComponent_CK_OffsetToTop,
  CXVTableComponent_CK_RTTI,
  CXVTableComponent_CK_FunctionPointer,
  CXVTableComponent_CK_CompleteDtorPointer,
  CXVTableComponent_CK_DeletingDtorPointer,
  CXVTableComponent_CK_UnusedFunctionPointer
} CXVTableComponent_Kind;

// clang/AST/VTableBuilder.h: enum clang::ItaniumVTableContext::VTableComponentLayout —
// whether the emitted table holds pointers or 32-bit relative offsets (-fexperimental-
// relative-c++-abi-vtables).
typedef enum CXItaniumVTableContext_VTableComponentLayout {
  CXItaniumVTableContext_Pointer,
  CXItaniumVTableContext_Relative
} CXItaniumVTableContext_VTableComponentLayout;

// VTableComponent
//
// A borrowed view of one entry of a CXVTableLayout's component array, obtained from
// clang_VTableLayout_getVTableComponent. It points into storage the layout owns, so it dies
// with the layout and has no dispose.

CXVTableComponent_Kind clang_VTableComponent_getKind(CXVTableComponent C);

// The three offset accessors are PARTIAL: each asserts its own kind, restated as an @assert
// in the Julia layer. The quantity is in chars, the CharUnits convention the
// ASTRecordLayout family already uses.
int64_t clang_VTableComponent_getVCallOffset(CXVTableComponent C);

int64_t clang_VTableComponent_getVBaseOffset(CXVTableComponent C);

int64_t clang_VTableComponent_getOffsetToTop(CXVTableComponent C);

// PRECONDITION: the component's kind is CK_RTTI.
CXCXXRecordDecl clang_VTableComponent_getRTTIDecl(CXVTableComponent C);

// PRECONDITION: the component's kind is one of the four function-pointer kinds. For a
// destructor slot this answers the destructor itself.
CXCXXMethodDecl clang_VTableComponent_getFunctionDecl(CXVTableComponent C);

// PRECONDITION: the component's kind is CK_CompleteDtorPointer or CK_DeletingDtorPointer.
CXCXXDestructorDecl clang_VTableComponent_getDestructorDecl(CXVTableComponent C);

// PRECONDITION: the component's kind is CK_UnusedFunctionPointer.
CXCXXMethodDecl clang_VTableComponent_getUnusedFunctionDecl(CXVTableComponent C);

bool clang_VTableComponent_isDestructorKind(CXVTableComponent C);

bool clang_VTableComponent_isUsedFunctionPointerKind(CXVTableComponent C);

bool clang_VTableComponent_isFunctionPointerKind(CXVTableComponent C);

bool clang_VTableComponent_isRTTIKind(CXVTableComponent C);

// getGlobalDecl -- the (decl, ctor/dtor variant) pair it builds is already readable from
// the kind plus clang_VTableComponent_getFunctionDecl, and GlobalDecl has no handle.

// VTableLayout
//
// BORROWED: the layout of a record is owned by the ItaniumVTableContext that computed it
// and is cached there for the context's life, so it has no dispose. It is invalidated by
// nothing short of the context going away.

// helper — how many entries clang_VTableLayout_getVTableComponent indexes
// (MARSHALLING.md §6, count+index). This counts the whole vtable GROUP; use
// clang_VTableLayout_getVTableOffset/getVTableSize to cut it into the individual tables.
unsigned clang_VTableLayout_getNumVTableComponents(CXVTableLayout L);

// PRECONDITION: I < clang_VTableLayout_getNumVTableComponents(L), restated as an @assert in
// the Julia layer; out of range the shim answers NULL rather than reading past the array.
CXVTableComponent clang_VTableLayout_getVTableComponent(CXVTableLayout L, unsigned I);

// vtable_thunks
// getAddressPoint
// getAddressPoints
// getAddressPointIndices

// How many vtables the group holds — one per vptr the most-derived class needs.
size_t clang_VTableLayout_getNumVTables(CXVTableLayout L);

// Where the I-th vtable starts inside the component array, and how many components it
// spans. PRECONDITION: I < clang_VTableLayout_getNumVTables(L).
size_t clang_VTableLayout_getVTableOffset(CXVTableLayout L, size_t I);

size_t clang_VTableLayout_getVTableSize(CXVTableLayout L, size_t I);

// VTableContextBase

// Which ABI's builder this is. The Itanium accessors below are only defined on a
// non-Microsoft context; this is the gate, and clang_VTableContextBase_castToItaniumVTableContext
// is how the gate is taken.
bool clang_VTableContextBase_isMicrosoft(CXVTableContextBase VTC);

// Whether MD gets a slot in its class's vtable at all. Static — no receiver.
bool clang_VTableContextBase_hasVtableSlot(CXCXXMethodDecl MD);

// getThunkInfo

// NULL under the Microsoft C++ ABI, the same context otherwise. MicrosoftVTableContext is
// not wrapped: its layout model is vftables plus vbtables rather than one component array,
// and the shim already asserts Itanium for mangling.
CXItaniumVTableContext
clang_VTableContextBase_castToItaniumVTableContext(CXVTableContextBase VTC);

// ItaniumVTableContext
//
// BORROWED: the ASTContext owns its VTableContextBase and builds it on first use, so this
// family has no dispose.

// The layout of RD's vtable group, computing it on first ask. PRECONDITION: RD must be a
// dynamic class with a definition — clang asserts a layout was produced for it.
CXVTableLayout clang_ItaniumVTableContext_getVTableLayout(CXItaniumVTableContext VTC,
                                                          CXCXXRecordDecl RD);

// createConstructionVTableLayout

// The index of MD's function pointer relative to the vtable address point — the slot a
// virtual call dispatches through. PRECONDITION: MD must be virtual and must have a vtable
// slot (clang_VTableContextBase_hasVtableSlot), and must be neither a constructor nor a
// destructor: those name several emitted bodies, so they take the ctor/dtor variant
// explicitly through the two entry points below. Restated as @asserts in the Julia layer.
uint64_t clang_ItaniumVTableContext_getMethodVTableIndex(CXItaniumVTableContext VTC,
                                                         CXCXXMethodDecl MD);

// The same index for one variant of a destructor (Dtor_Complete or Dtor_Deleting are the
// two that appear in a vtable). C has no overloading, so the GlobalDecl flattening
// clang_Interpreter_getSymbolAddressFromDtorDecl uses is repeated here.
uint64_t
clang_ItaniumVTableContext_getMethodVTableIndexForDtor(CXItaniumVTableContext VTC,
                                                       CXCXXDestructorDecl D,
                                                       CXCXXDtorType DtorKind);

// The constructor form. Constructors are never virtual in C++, so this exists only to make
// the GlobalDecl flattening total; clang has no slot for one and will assert.
uint64_t
clang_ItaniumVTableContext_getMethodVTableIndexForCtor(CXItaniumVTableContext VTC,
                                                       CXCXXConstructorDecl D,
                                                       CXCXXCtorType CtorKind);

// The offset in chars, relative to the vtable address point, of the slot holding VBase's
// offset within RD; 0 when no virtual base of RD contains VBase. PRECONDITION: VBase must
// be a virtual base of RD or an unambiguous base of it.
int64_t clang_ItaniumVTableContext_getVirtualBaseOffsetOffset(CXItaniumVTableContext VTC,
                                                              CXCXXRecordDecl RD,
                                                              CXCXXRecordDecl VBase);

CXItaniumVTableContext_VTableComponentLayout
clang_ItaniumVTableContext_getVTableComponentLayout(CXItaniumVTableContext VTC);

bool clang_ItaniumVTableContext_isPointerLayout(CXItaniumVTableContext VTC);

bool clang_ItaniumVTableContext_isRelativeLayout(CXItaniumVTableContext VTC);

// VPtrInfo
// MicrosoftVTableContext

LLVM_CLANG_C_EXTERN_C_END

#endif
