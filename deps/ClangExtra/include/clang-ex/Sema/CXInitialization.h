#ifndef LLVM_CLANG_C_EXTRA_CXINITIALIZATION_H
#define LLVM_CLANG_C_EXTRA_CXINITIALIZATION_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang's initialization engine: describe WHAT is being initialized (InitializedEntity),
// HOW (InitializationKind), then let InitializationSequence pick and run the conversions,
// constructors and temporaries the language requires. This is the machinery Sema itself
// uses to bind a call argument or a return value, so it is what an argument built outside
// the parser has to go through to be bound correctly -- the piecewise conversions the shim
// already exposes (PerformImplicitConversion, ImpCastExprToType) cover only single steps.
//
// InitializedEntity and InitializationKind are value classes clang returns by value, so
// each handle below is a heap box the caller owns (MARSHALLING.md section 2); release with
// the matching _dispose. The entity must outlive every sequence built from it.

// InitializedEntity

// Initializing a declared variable.
CXInitializedEntity clang_InitializedEntity_InitializeVariable(CXVarDecl Var);

// Initializing a parameter of a call, given the parameter's declaration.
CXInitializedEntity clang_InitializedEntity_InitializeParameter(CXASTContext Ctx,
                                                                CXParmVarDecl Parm);

// Initializing a parameter known only by type -- the shape a call built from a list of
// argument types needs. Consumed is the ObjC ARC ownership transfer flag; false for C++.
CXInitializedEntity
clang_InitializedEntity_InitializeParameterWithType(CXASTContext Ctx, CXQualType Type,
                                                    bool Consumed);

// Initializing the object a return statement yields.
CXInitializedEntity clang_InitializedEntity_InitializeResult(CXSourceLocation_ ReturnLoc,
                                                             CXQualType Type);

// Initializing a temporary of the given type.
CXInitializedEntity clang_InitializedEntity_InitializeTemporary(CXQualType Type);

void clang_InitializedEntity_dispose(CXInitializedEntity Entity);

CXQualType clang_InitializedEntity_getType(CXInitializedEntity Entity);

// InitializationKind

// Direct-initialization, `T x(args)`.
CXInitializationKind clang_InitializationKind_CreateDirect(CXSourceLocation_ InitLoc,
                                                           CXSourceLocation_ LParenLoc,
                                                           CXSourceLocation_ RParenLoc);

// Direct-list-initialization, `T x{args}`.
CXInitializationKind clang_InitializationKind_CreateDirectList(CXSourceLocation_ InitLoc);

// Copy-initialization, `T x = arg`. AllowExplicitConvs lets explicit conversion functions
// take part, which copy-initialization normally forbids.
CXInitializationKind clang_InitializationKind_CreateCopy(CXSourceLocation_ InitLoc,
                                                         CXSourceLocation_ EqualLoc,
                                                         bool AllowExplicitConvs);

// Default-initialization, `T x;`.
CXInitializationKind clang_InitializationKind_CreateDefault(CXSourceLocation_ InitLoc);

// Value-initialization, `T x{}` / `T()`.
CXInitializationKind clang_InitializationKind_CreateValue(CXSourceLocation_ InitLoc,
                                                          CXSourceLocation_ LParenLoc,
                                                          CXSourceLocation_ RParenLoc,
                                                          bool IsImplicit);

void clang_InitializationKind_dispose(CXInitializationKind Kind);

// InitializationSequence

// Compute the sequence that initializes Entity from Args in the manner Kind describes.
// Computing it runs overload resolution but changes nothing; clang_InitializationSequence_Perform
// is what builds the expression.
CXInitializationSequence
clang_InitializationSequence_create(CXSema S, CXInitializedEntity Entity,
                                    CXInitializationKind Kind, CXExpr *Args, unsigned NumArgs,
                                    bool TopLevelOfInitList, bool TreatUnavailableAsInvalid);

void clang_InitializationSequence_dispose(CXInitializationSequence Seq);

bool clang_InitializationSequence_Failed(CXInitializationSequence Seq);

// Meaningful only when clang_InitializationSequence_Failed is true; clang asserts that.
unsigned clang_InitializationSequence_getFailureKind(CXInitializationSequence Seq);

unsigned clang_InitializationSequence_getKind(CXInitializationSequence Seq);

// Build the initialization expression. Args must be the same arguments the sequence was
// computed from. ExprResult crosses split (MARSHALLING.md section 8): *IsInvalid carries the
// failure bit and the return is null in that case.
CXExpr clang_InitializationSequence_Perform(CXInitializationSequence Seq, CXSema S,
                                            CXInitializedEntity Entity,
                                            CXInitializationKind Kind, CXExpr *Args,
                                            unsigned NumArgs, bool *IsInvalid);

// Emit the diagnostics explaining a failed sequence. Returns whether the sequence was
// ill-formed.
bool clang_InitializationSequence_Diagnose(CXInitializationSequence Seq, CXSema S,
                                           CXInitializedEntity Entity,
                                           CXInitializationKind Kind, CXExpr *Args,
                                           unsigned NumArgs);

// Sema one-shots over the same machinery

// Whether Init could copy-initialize Entity, asked without building anything or
// diagnosing.
bool clang_Sema_CanPerformCopyInitialization(CXSema S, CXInitializedEntity Entity,
                                             CXExpr Init);

// Copy-initialize Entity from Init -- the common case of the three-step dance above, which
// is what binding a call argument or a return value goes through. ExprResult crosses split.
CXExpr clang_Sema_PerformCopyInitialization(CXSema S, CXInitializedEntity Entity,
                                            CXSourceLocation_ EqualLoc, CXExpr Init,
                                            bool TopLevelOfInitList, bool AllowExplicit,
                                            bool *IsInvalid);

LLVM_CLANG_C_EXTERN_C_END

#endif
