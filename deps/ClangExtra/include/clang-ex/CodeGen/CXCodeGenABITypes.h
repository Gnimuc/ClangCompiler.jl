#ifndef LLVM_CLANG_C_EXTRA_CXCODEGENABITYPES_H
#define LLVM_CLANG_C_EXTRA_CXCODEGENABITYPES_H

#include "clang-ex/CXTypes.h"
#include "clang-ex/Basic/CXSpecifiers.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "llvm-c/Types.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// arrangeObjCMessageSendSignature

// The two arrangeFreeFunctionType overloads, split because C has no overloading: the first
// takes a prototyped function type, the second a K&R one. Both canonicalize Ty in the shim,
// so a typedef of a function type is accepted. Both answer NULL (and log) when Ty's
// canonical form is not the function type the overload wants -- clang would otherwise read
// it as one.
//
// The returned CGFunctionInfo is interned in CGM and BORROWED: no dispose, and it must not
// outlive CGM. See clang-ex/CodeGen/CXCGFunctionInfo.h for the accessors.
CXCGFunctionInfo clang_CodeGen_arrangeFreeFunctionType(CXCodeGenModule CGM, CXQualType Ty);

CXCGFunctionInfo clang_CodeGen_arrangeFreeFunctionTypeNoProto(CXCodeGenModule CGM,
                                                              CXQualType Ty);

// The signature of a C++ member function, including its implicit `this`. MD may be NULL,
// in which case FTP alone describes the arguments.
CXCGFunctionInfo clang_CodeGen_arrangeCXXMethodType(CXCodeGenModule CGM, CXCXXRecordDecl RD,
                                                    CXFunctionProtoType FTP,
                                                    CXCXXMethodDecl MD);

// The signature of a call with argument types given directly rather than read off a
// FunctionType. Ctx is what canonicalizes them: clang requires every argument type to be
// canonical *as a parameter* (arrays decayed, top-level qualifiers dropped), which is
// ASTContext::getCanonicalParamType, so the shim applies it rather than trusting the caller.
//
// FunctionType::ExtInfo and RequiredArgs are built here from scalars instead of being
// wrapped as types: CC and NoReturn fill the ExtInfo, and IsVariadic/NumRequiredArgs fill
// the RequiredArgs (a non-variadic call requires all of its arguments, so NumRequiredArgs is
// then ignored).
CXCGFunctionInfo clang_CodeGen_arrangeFreeFunctionCall(CXCodeGenModule CGM, CXASTContext Ctx,
                                                       CXQualType ReturnType,
                                                       const CXQualType *ArgTypes,
                                                       unsigned NumArgTypes,
                                                       CXCallingConv_ CC, bool NoReturn,
                                                       bool IsVariadic,
                                                       unsigned NumRequiredArgs);

// helper: ImplicitCXXConstructorArgs is a pair of SmallVector<llvm::Value *, 1> with no C
// form, so each half is filled into a caller buffer. At most PrefixCapacity / SuffixCapacity
// entries are written, while *NumPrefix / *NumSuffix always receive the true sizes -- a
// caller that guessed too small can resize and call again. Prefix/Suffix may be NULL when
// the matching capacity is 0.
//
// These are the arguments a complete, non-delegating constructor call must pass beyond
// `this`: the VTT under the Itanium ABI, the most-derived flag under the Microsoft one.
// Both halves are usually empty on Itanium.
void clang_CodeGen_getImplicitCXXConstructorArgs(CXCodeGenModule CGM, CXCXXConstructorDecl D,
                                                 unsigned PrefixCapacity, LLVMValueRef *Prefix,
                                                 unsigned *NumPrefix, unsigned SuffixCapacity,
                                                 LLVMValueRef *Suffix, unsigned *NumSuffix);

// getCXXDestructorImplicitParam

// The LLVM function type FD lowers to, or NULL when FD's type is incomplete and cannot be
// lowered.
LLVMTypeRef clang_CodeGen_convertFreeFunctionType(CXCodeGenModule CGM, CXFunctionDecl FD);

LLVMTypeRef clang_CodeGen_convertTypeForMemory(CXCodeGenModule CGM, CXQualType T);

// The index of FD within the LLVM struct clang_CodeGen_convertTypeForMemory produces for RD.
// Padding and bitfield storage units mean this is not FD's index among RD's fields.
// PRECONDITION (stated by the clang header): FD must be a direct, non-bitfield field of RD;
// an inherited or bitfield field is looked up in a table that does not contain it.
unsigned clang_CodeGen_getLLVMFieldNumber(CXCodeGenModule CGM, CXRecordDecl RD,
                                          CXFieldDecl FD);

// llvm::AttrBuilder has no llvm-c form, and addDefaultFunctionDefinitionAttributes needs one
// to write into. The builder is caller-owned; release it with clang_AttrBuilder_dispose.
CXAttrBuilder clang_AttrBuilder_create(LLVMContextRef C);

void clang_AttrBuilder_dispose(CXAttrBuilder AB);

// Fill AB with the IR attributes clang would put on a function it defined itself with CGM's
// configuration: target-cpu, target-features, the frame-pointer policy and so on. Existing
// entries in AB are not consulted, and may be overwritten.
void clang_CodeGen_addDefaultFunctionDefinitionAttributes(CXCodeGenModule CGM,
                                                          CXAttrBuilder AB);

// helper: the builder's contents, as an index pair. PRECONDITION on the second:
// I < clang_AttrBuilder_getNumAttributes(AB). The CXString is caller-owned.
unsigned clang_AttrBuilder_getNumAttributes(CXAttrBuilder AB);

CXString clang_AttrBuilder_getAttributeAsString(CXAttrBuilder AB, unsigned I);

// True when AB carries a string attribute spelled Kind, e.g. "target-cpu".
bool clang_AttrBuilder_contains(CXAttrBuilder AB, const char *Kind);

// helper: add everything in AB to F as function attributes. False (and a log line) when F is
// not an llvm::Function.
bool clang_AttrBuilder_applyToFunction(CXAttrBuilder AB, LLVMValueRef F);

// getNonTrivialCStructDefaultConstructor
// getNonTrivialCStructCopyConstructor
// getNonTrivialCStructMoveConstructor
// getNonTrivialCStructCopyAssignmentOperator
// getNonTrivialCStructMoveAssignmentOperator
// getNonTrivialCStructDestructor
// emitObjCProtocolObject

LLVM_CLANG_C_EXTERN_C_END

#endif
