#ifndef LLVM_CLANG_C_EXTRA_CXMANGLE_H
#define LLVM_CLANG_C_EXTRA_CXMANGLE_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

typedef enum CXMangleContext_ManglerKind {
  CXMangleContext_MK_Itanium,
  CXMangleContext_MK_Microsoft
} CXMangleContext_ManglerKind;

// MangleContext
CXMangleContext_ManglerKind clang_MangleContext_getKind(CXMangleContext MC);

CXASTContext clang_MangleContext_getASTContext(CXMangleContext MC);

CXDiagnosticsEngine clang_MangleContext_getDiags(CXMangleContext MC);

// startNewFunction
// getBlockId

uint64_t clang_MangleContext_getAnonymousStructId(CXMangleContext MC, CXNamedDecl D);

bool clang_MangleContext_shouldMangleDeclName(CXMangleContext MC, CXNamedDecl D);

bool clang_MangleContext_shouldMangleCXXName(CXMangleContext MC, CXNamedDecl D);

bool clang_MangleContext_shouldMangleStringLiteral(CXMangleContext MC, CXStringLiteral SL);

// Mangle the linkage name of a non-constructor/destructor decl (Clang's
// GlobalDecl(NamedDecl*) contract). The CXString is caller-owned.
CXString clang_MangleContext_mangleName(CXMangleContext MC, CXNamedDecl D);

// mangleCXXName
// mangleCXXDtorThunk
// mangleReferenceTemporary
// mangleCXXRTTI
// mangleCXXRTTIName
// mangleStringLiteral
// mangleMSGuidDecl
// mangleGlobalBlock
// mangleCtorBlock
// mangleDtorBlock
// mangleBlock
// mangleObjCMethodName
// mangleObjCMethodNameAsSourceName
// mangleStaticGuardVariable
// mangleStaticGuardVariable
// mangleDynamicInitializer
// mangleDynamicAtExitDestructor
// mangleSEHFilterExpression
// mangleSEHFinallyBlock
// mangleTypeName

// True for the auxiliary-target mangler of an offloading compilation.
bool clang_MangleContext_isAux(CXMangleContext MC);

// Reset the per-function block numbering before mangling a new function.
void clang_MangleContext_startNewFunction(CXMangleContext MC);

// The id previously handed out by clang_MangleContext_getAnonymousStructId for
// this decl; 0 when none was assigned yet.
uint64_t clang_MangleContext_getAnonymousStructIdForDebugInfo(CXMangleContext MC,
                                                              CXNamedDecl D);

// The RTTI type-name string for T (Itanium `_ZTS...`). The CXString is
// caller-owned.
CXString clang_MangleContext_mangleCXXRTTIName(CXMangleContext MC, CXQualType T,
                                               bool NormalizeIntegers);

// A unique string for T's canonical form, as used for TBAA and type uniquing.
// The CXString is caller-owned.
CXString clang_MangleContext_mangleCanonicalTypeName(CXMangleContext MC, CXQualType T,
                                                     bool NormalizeIntegers);

// True when ND is given a uniqued internal-linkage name. The base implementation
// always answers false; the Itanium mangler answers it only once
// clang_MangleContext_needsUniqueInternalLinkageNames has been called.
bool clang_MangleContext_isUniqueInternalLinkageDecl(CXMangleContext MC, CXNamedDecl ND);

// Ask the mangler to give internal-linkage declarations unique names from here on.
void clang_MangleContext_needsUniqueInternalLinkageNames(CXMangleContext MC);

// The `<lambda...>` spelling a closure type contributes to mangled names.
// PRECONDITION: Lambda must be a lambda closure class -- clang asserts isLambda() and
// then reads the lambda-only fields unconditionally. The CXString is caller-owned.
CXString clang_MangleContext_getLambdaString(CXMangleContext MC, CXCXXRecordDecl Lambda);

// The RTTI descriptor symbol name for T (Itanium `_ZTI...`).
// PRECONDITION: T must carry no qualifiers -- the Itanium mangler asserts on a
// qualified type. The CXString is caller-owned.
CXString clang_MangleContext_mangleCXXRTTI(CXMangleContext MC, CXQualType T);

// The symbol name of the guard variable protecting D's one-time initialization.
// The CXString is caller-owned.
CXString clang_MangleContext_mangleStaticGuardVariable(CXMangleContext MC, CXVarDecl D);

// The symbol name of the stub that runs D's dynamic initialization. The CXString is
// caller-owned.
CXString clang_MangleContext_mangleDynamicInitializer(CXMangleContext MC, CXVarDecl D);

// Mangle D with the C++ mangling rules directly, skipping the asm-label and
// "does this need mangling at all" fallbacks clang_MangleContext_mangleName applies
// first.
// PRECONDITION: D must be a function or a variable, and must not be a constructor or a
// destructor -- clang's GlobalDecl(NamedDecl *) contract asserts the latter. The CXString
// is caller-owned.
CXString clang_MangleContext_mangleCXXName(CXMangleContext MC, CXNamedDecl D);

// The symbol name of the reference temporary materialized for D. ManglingNumber
// distinguishes several temporaries created by one initializer and is 1-based, matching
// the numbers clang's MangleNumberingContext hands out. The CXString is caller-owned.
CXString clang_MangleContext_mangleReferenceTemporary(CXMangleContext MC, CXVarDecl D,
                                                      unsigned ManglingNumber);

// The symbol name of the stub that runs D's registered at-exit destructor. The CXString
// is caller-owned.
CXString clang_MangleContext_mangleDynamicAtExitDestructor(CXMangleContext MC, CXVarDecl D);

// The symbol names of the SEH filter expression and finally block outlined from
// EnclosingDecl.
// PRECONDITION: EnclosingDecl must not be a constructor or a destructor -- the
// GlobalDecl(FunctionDecl *) contract asserts it. The CXString is caller-owned.
CXString clang_MangleContext_mangleSEHFilterExpression(CXMangleContext MC,
                                                       CXFunctionDecl EnclosingDecl);

CXString clang_MangleContext_mangleSEHFinallyBlock(CXMangleContext MC,
                                                   CXFunctionDecl EnclosingDecl);

// MangleContext Cast
CXItaniumMangleContext clang_MangleContext_castToItaniumMangleContext(CXMangleContext MC);

// ItaniumMangleContext
// mangleCXXVTable
// mangleCXXVTT
// mangleCXXCtorVTable
// mangleItaniumThreadLocalInit
// mangleItaniumThreadLocalWrapper
// mangleCXXCtorComdat
// mangleCXXDtorComdat
// mangleLambdaSig
// mangleDynamicStermFinalizer

// Every entry point below needs an Itanium mangler receiver, obtained from
// clang_MangleContext_castToItaniumMangleContext (nullptr under the Microsoft C++ ABI).
// Each CXString is caller-owned.

// The virtual-table, VTT and construction-vtable symbol names of RD.
CXString clang_ItaniumMangleContext_mangleCXXVTable(CXItaniumMangleContext MC,
                                                    CXCXXRecordDecl RD);

CXString clang_ItaniumMangleContext_mangleCXXVTT(CXItaniumMangleContext MC,
                                                 CXCXXRecordDecl RD);

CXString clang_ItaniumMangleContext_mangleCXXCtorVTable(CXItaniumMangleContext MC,
                                                        CXCXXRecordDecl RD, int64_t Offset,
                                                        CXCXXRecordDecl Type);

// The thread-local initialization and access-wrapper symbol names of D.
CXString clang_ItaniumMangleContext_mangleItaniumThreadLocalInit(CXItaniumMangleContext MC,
                                                                 CXVarDecl D);

CXString
clang_ItaniumMangleContext_mangleItaniumThreadLocalWrapper(CXItaniumMangleContext MC,
                                                           CXVarDecl D);

// The comdat-group symbol names of D's constructor and destructor groups.
CXString clang_ItaniumMangleContext_mangleCXXCtorComdat(CXItaniumMangleContext MC,
                                                        CXCXXConstructorDecl D);

CXString clang_ItaniumMangleContext_mangleCXXDtorComdat(CXItaniumMangleContext MC,
                                                        CXCXXDestructorDecl D);

// The mangled call-operator signature of the closure type Lambda.
// PRECONDITION: Lambda must be a lambda closure class -- the mangler reads its call
// operator unconditionally.
CXString clang_ItaniumMangleContext_mangleLambdaSig(CXItaniumMangleContext MC,
                                                    CXCXXRecordDecl Lambda);

// The symbol name of the finalizer stub registered for D by at_thread_exit.
CXString clang_ItaniumMangleContext_mangleDynamicStermFinalizer(CXItaniumMangleContext MC,
                                                                CXVarDecl D);

// The module-initializer symbol name of the named module M. Only M's name, kind and
// parent chain are read, so a Module built with clang_Module_create works.
CXString clang_ItaniumMangleContext_mangleModuleInitializer(CXItaniumMangleContext MC,
                                                            CXModule M);

// MicrosoftMangleContext
// mangleCXXVFTable
// mangleCXXVBTable
// mangleThreadSafeStaticGuardVariable
// mangleVirtualMemPtrThunk
// mangleCXXVirtualDisplacementMap
// mangleCXXThrowInfo
// mangleCXXCatchableTypeArray
// mangleCXXCatchableType
// mangleCXXRTTIBaseClassDescriptor
// mangleCXXRTTIBaseClassArray
// mangleCXXRTTIClassHierarchyDescriptor
// mangleCXXRTTICompleteObjectLocator

// ASTNameGenerator
// writeName

CXString clang_ASTNameGenerator_getName(CXASTNameGenerator G, CXDecl D);

CXStringSet *clang_ASTNameGenerator_getAllManglings(CXASTNameGenerator G, CXDecl D);

LLVM_CLANG_C_EXTERN_C_END

#endif