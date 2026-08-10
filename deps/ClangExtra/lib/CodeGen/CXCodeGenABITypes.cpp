#include "clang-ex/CodeGen/CXCodeGenABITypes.h"
#include "utils.h"
#include "clang/AST/ASTContext.h"
#include "clang/AST/CanonicalType.h"
#include "clang/AST/Decl.h"
#include "clang/AST/DeclCXX.h"
#include "clang/AST/Type.h"
#include "clang/CodeGen/CGFunctionInfo.h"
#include "clang/CodeGen/CodeGenABITypes.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/IR/Attributes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Type.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/raw_ostream.h"
#include <algorithm>

#include <memory>

namespace {

clang::CodeGen::CodeGenModule &unwrapCGM(CXCodeGenModule CGM) {
  return *reinterpret_cast<clang::CodeGen::CodeGenModule *>(CGM);
}

CXCGFunctionInfo wrapFunctionInfo(const clang::CodeGen::CGFunctionInfo &FI) {
  return reinterpret_cast<CXCGFunctionInfo>(
      const_cast<clang::CodeGen::CGFunctionInfo *>(&FI));
}

// The canonical form of a type crossing as a CXQualType, or a null QualType when the handle
// was null. CanQual::CreateUnsafe only asserts canonicality, so the caller still has to
// check the dynamic class before naming one.
clang::QualType canonicalOf(CXQualType Ty) {
  clang::QualType QT = clang::QualType::getFromOpaquePtr(Ty);
  return QT.isNull() ? QT : QT.getCanonicalType();
}

} // namespace

CXCGFunctionInfo clang_CodeGen_arrangeFreeFunctionType(CXCodeGenModule CGM, CXQualType Ty) {
  clang::QualType QT = canonicalOf(Ty);
  if (!llvm::isa_and_nonnull<clang::FunctionProtoType>(QT.getTypePtrOrNull())) {
    llvm::errs() << "LIBCLANGEX ERROR: clang_CodeGen_arrangeFreeFunctionType: the type is "
                    "not a prototyped function type\n";
    return nullptr;
  }
  return wrapFunctionInfo(clang::CodeGen::arrangeFreeFunctionType(
      unwrapCGM(CGM), clang::CanQual<clang::FunctionProtoType>::CreateUnsafe(QT)));
}

CXCGFunctionInfo clang_CodeGen_arrangeFreeFunctionTypeNoProto(CXCodeGenModule CGM,
                                                              CXQualType Ty) {
  clang::QualType QT = canonicalOf(Ty);
  if (!llvm::isa_and_nonnull<clang::FunctionNoProtoType>(QT.getTypePtrOrNull())) {
    llvm::errs() << "LIBCLANGEX ERROR: clang_CodeGen_arrangeFreeFunctionTypeNoProto: the "
                    "type is not an unprototyped function type\n";
    return nullptr;
  }
  return wrapFunctionInfo(clang::CodeGen::arrangeFreeFunctionType(
      unwrapCGM(CGM), clang::CanQual<clang::FunctionNoProtoType>::CreateUnsafe(QT)));
}

CXCGFunctionInfo clang_CodeGen_arrangeCXXMethodType(CXCodeGenModule CGM, CXCXXRecordDecl RD,
                                                    CXFunctionProtoType FTP,
                                                    CXCXXMethodDecl MD) {
  return wrapFunctionInfo(clang::CodeGen::arrangeCXXMethodType(
      unwrapCGM(CGM), reinterpret_cast<const clang::CXXRecordDecl *>(RD),
      reinterpret_cast<const clang::FunctionProtoType *>(FTP),
      reinterpret_cast<const clang::CXXMethodDecl *>(MD)));
}

CXCGFunctionInfo clang_CodeGen_arrangeFreeFunctionCall(CXCodeGenModule CGM, CXASTContext Ctx,
                                                       CXQualType ReturnType,
                                                       const CXQualType *ArgTypes,
                                                       unsigned NumArgTypes,
                                                       CXCallingConv_ CC, bool NoReturn,
                                                       bool IsVariadic,
                                                       unsigned NumRequiredArgs) {
  if (IsVariadic && NumRequiredArgs == ~0U) {
    llvm::errs() << "LIBCLANGEX ERROR: clang_CodeGen_arrangeFreeFunctionCall: a variadic "
                    "call cannot require ~0U arguments\n";
    return nullptr;
  }
  auto &Context = *reinterpret_cast<clang::ASTContext *>(Ctx);

  llvm::SmallVector<clang::CanQualType, 8> Args;
  Args.reserve(NumArgTypes);
  for (unsigned I = 0; I != NumArgTypes; ++I)
    Args.push_back(Context.getCanonicalParamType(
        clang::QualType::getFromOpaquePtr(ArgTypes[I])));

  clang::FunctionType::ExtInfo Info(NoReturn, /*hasRegParm=*/false, /*regParm=*/0,
                                    static_cast<clang::CallingConv>(CC),
                                    /*producesResult=*/false, /*noCallerSavedRegs=*/false,
                                    /*NoCfCheck=*/false, /*cmseNSCall=*/false);
  clang::CodeGen::RequiredArgs Required =
      IsVariadic ? clang::CodeGen::RequiredArgs(NumRequiredArgs)
                 : clang::CodeGen::RequiredArgs(clang::CodeGen::RequiredArgs::All);

  return wrapFunctionInfo(clang::CodeGen::arrangeFreeFunctionCall(
      unwrapCGM(CGM),
      Context.getCanonicalType(clang::QualType::getFromOpaquePtr(ReturnType)), Args, Info,
      Required));
}

void clang_CodeGen_getImplicitCXXConstructorArgs(CXCodeGenModule CGM, CXCXXConstructorDecl D,
                                                 unsigned PrefixCapacity, LLVMValueRef *Prefix,
                                                 unsigned *NumPrefix, unsigned SuffixCapacity,
                                                 LLVMValueRef *Suffix, unsigned *NumSuffix) {
  clang::CodeGen::ImplicitCXXConstructorArgs ImplicitArgs =
      clang::CodeGen::getImplicitCXXConstructorArgs(
          unwrapCGM(CGM), reinterpret_cast<const clang::CXXConstructorDecl *>(D));

  unsigned NP = static_cast<unsigned>(ImplicitArgs.Prefix.size());
  unsigned NS = static_cast<unsigned>(ImplicitArgs.Suffix.size());
  if (NumPrefix)
    *NumPrefix = NP;
  if (NumSuffix)
    *NumSuffix = NS;
  if (Prefix)
    for (unsigned I = 0, E = std::min(NP, PrefixCapacity); I != E; ++I)
      Prefix[I] = llvm::wrap(ImplicitArgs.Prefix[I]);
  if (Suffix)
    for (unsigned I = 0, E = std::min(NS, SuffixCapacity); I != E; ++I)
      Suffix[I] = llvm::wrap(ImplicitArgs.Suffix[I]);
}

LLVMTypeRef clang_CodeGen_convertFreeFunctionType(CXCodeGenModule CGM, CXFunctionDecl FD) {
  return llvm::wrap(clang::CodeGen::convertFreeFunctionType(
      unwrapCGM(CGM), reinterpret_cast<const clang::FunctionDecl *>(FD)));
}

LLVMTypeRef clang_CodeGen_convertTypeForMemory(CXCodeGenModule CGM, CXQualType T) {
  return llvm::wrap(clang::CodeGen::convertTypeForMemory(
      unwrapCGM(CGM), clang::QualType::getFromOpaquePtr(T)));
}

unsigned clang_CodeGen_getLLVMFieldNumber(CXCodeGenModule CGM, CXRecordDecl RD,
                                          CXFieldDecl FD) {
  return clang::CodeGen::getLLVMFieldNumber(unwrapCGM(CGM),
                                            reinterpret_cast<const clang::RecordDecl *>(RD),
                                            reinterpret_cast<const clang::FieldDecl *>(FD));
}

CXAttrBuilder clang_AttrBuilder_create(LLVMContextRef C) {
  return reinterpret_cast<CXAttrBuilder>(
      std::make_unique<llvm::AttrBuilder>(*llvm::unwrap(C)).release());
}

void clang_AttrBuilder_dispose(CXAttrBuilder AB) {
  delete reinterpret_cast<llvm::AttrBuilder *>(AB);
}

void clang_CodeGen_addDefaultFunctionDefinitionAttributes(CXCodeGenModule CGM,
                                                          CXAttrBuilder AB) {
  clang::CodeGen::addDefaultFunctionDefinitionAttributes(
      unwrapCGM(CGM), *reinterpret_cast<llvm::AttrBuilder *>(AB));
}

unsigned clang_AttrBuilder_getNumAttributes(CXAttrBuilder AB) {
  return static_cast<unsigned>(reinterpret_cast<llvm::AttrBuilder *>(AB)->attrs().size());
}

CXString clang_AttrBuilder_getAttributeAsString(CXAttrBuilder AB, unsigned I) {
  return extra::makeCXString(
      reinterpret_cast<llvm::AttrBuilder *>(AB)->attrs()[I].getAsString());
}

bool clang_AttrBuilder_contains(CXAttrBuilder AB, const char *Kind) {
  return reinterpret_cast<llvm::AttrBuilder *>(AB)->contains(llvm::StringRef(Kind));
}

bool clang_AttrBuilder_applyToFunction(CXAttrBuilder AB, LLVMValueRef F) {
  auto *Fn = llvm::dyn_cast_or_null<llvm::Function>(llvm::unwrap(F));
  if (!Fn) {
    llvm::errs() << "LIBCLANGEX ERROR: clang_AttrBuilder_applyToFunction: the value is not "
                    "an llvm::Function\n";
    return false;
  }
  Fn->addFnAttrs(*reinterpret_cast<llvm::AttrBuilder *>(AB));
  return true;
}
