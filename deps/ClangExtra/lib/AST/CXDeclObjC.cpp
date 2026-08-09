#include "clang-ex/AST/CXDeclObjC.h"
#include "utils.h"
#include "clang/AST/ASTContext.h"
#include "clang/AST/DeclObjC.h"
#include "clang/AST/Type.h"
#include "clang/Basic/IdentifierTable.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"

// ObjCMethodDecl
CXObjCMethodDecl clang_ObjCMethodDecl_getCanonicalDecl(CXObjCMethodDecl MD) {
  return reinterpret_cast<CXObjCMethodDecl>(
      reinterpret_cast<clang::ObjCMethodDecl *>(MD)->getCanonicalDecl());
}

CXObjCInterfaceDecl clang_ObjCMethodDecl_getClassInterface(CXObjCMethodDecl MD) {
  return reinterpret_cast<CXObjCInterfaceDecl>(
      reinterpret_cast<clang::ObjCMethodDecl *>(MD)->getClassInterface());
}

CXObjCCategoryDecl clang_ObjCMethodDecl_getCategory(CXObjCMethodDecl MD) {
  return reinterpret_cast<CXObjCCategoryDecl>(
      reinterpret_cast<clang::ObjCMethodDecl *>(MD)->getCategory());
}

CXString clang_ObjCMethodDecl_getSelector(CXObjCMethodDecl MD) {
  return extra::makeCXString(
      reinterpret_cast<clang::ObjCMethodDecl *>(MD)->getSelector().getAsString());
}

CXQualType clang_ObjCMethodDecl_getReturnType(CXObjCMethodDecl MD) {
  return reinterpret_cast<CXQualType>(
      reinterpret_cast<clang::ObjCMethodDecl *>(MD)->getReturnType().getAsOpaquePtr());
}

CXTypeSourceInfo clang_ObjCMethodDecl_getReturnTypeSourceInfo(CXObjCMethodDecl MD) {
  return reinterpret_cast<CXTypeSourceInfo>(
      reinterpret_cast<clang::ObjCMethodDecl *>(MD)->getReturnTypeSourceInfo());
}

unsigned clang_ObjCMethodDecl_param_size(CXObjCMethodDecl MD) {
  return reinterpret_cast<clang::ObjCMethodDecl *>(MD)->param_size();
}

CXParmVarDecl clang_ObjCMethodDecl_getParamDecl(CXObjCMethodDecl MD, unsigned I) {
  return reinterpret_cast<CXParmVarDecl>(
      reinterpret_cast<clang::ObjCMethodDecl *>(MD)->getParamDecl(I));
}

unsigned clang_ObjCMethodDecl_getNumSelectorLocs(CXObjCMethodDecl MD) {
  return reinterpret_cast<clang::ObjCMethodDecl *>(MD)->getNumSelectorLocs();
}

bool clang_ObjCMethodDecl_isInstanceMethod(CXObjCMethodDecl MD) {
  return reinterpret_cast<clang::ObjCMethodDecl *>(MD)->isInstanceMethod();
}

bool clang_ObjCMethodDecl_isClassMethod(CXObjCMethodDecl MD) {
  return reinterpret_cast<clang::ObjCMethodDecl *>(MD)->isClassMethod();
}

bool clang_ObjCMethodDecl_isVariadic(CXObjCMethodDecl MD) {
  return reinterpret_cast<clang::ObjCMethodDecl *>(MD)->isVariadic();
}

bool clang_ObjCMethodDecl_isPropertyAccessor(CXObjCMethodDecl MD) {
  return reinterpret_cast<clang::ObjCMethodDecl *>(MD)->isPropertyAccessor();
}

bool clang_ObjCMethodDecl_isDefined(CXObjCMethodDecl MD) {
  return reinterpret_cast<clang::ObjCMethodDecl *>(MD)->isDefined();
}

bool clang_ObjCMethodDecl_isThisDeclarationADesignatedInitializer(CXObjCMethodDecl MD) {
  return reinterpret_cast<clang::ObjCMethodDecl *>(MD)
      ->isThisDeclarationADesignatedInitializer();
}

bool clang_ObjCMethodDecl_hasRelatedResultType(CXObjCMethodDecl MD) {
  return reinterpret_cast<clang::ObjCMethodDecl *>(MD)->hasRelatedResultType();
}

bool clang_ObjCMethodDecl_isOptional(CXObjCMethodDecl MD) {
  return reinterpret_cast<clang::ObjCMethodDecl *>(MD)->isOptional();
}

// ObjCTypeParamDecl
CXObjCTypeParamVariance clang_ObjCTypeParamDecl_getVariance(CXObjCTypeParamDecl TPD) {
  return static_cast<CXObjCTypeParamVariance>(
      reinterpret_cast<clang::ObjCTypeParamDecl *>(TPD)->getVariance());
}

unsigned clang_ObjCTypeParamDecl_getIndex(CXObjCTypeParamDecl TPD) {
  return reinterpret_cast<clang::ObjCTypeParamDecl *>(TPD)->getIndex();
}

bool clang_ObjCTypeParamDecl_hasExplicitBound(CXObjCTypeParamDecl TPD) {
  return reinterpret_cast<clang::ObjCTypeParamDecl *>(TPD)->hasExplicitBound();
}

// ObjCContainerDecl
unsigned clang_ObjCContainerDecl_prop_size(CXObjCContainerDecl CD) {
  auto *C = reinterpret_cast<clang::ObjCContainerDecl *>(CD);
  return static_cast<unsigned>(std::distance(C->prop_begin(), C->prop_end()));
}

CXObjCPropertyDecl clang_ObjCContainerDecl_getProperty(CXObjCContainerDecl CD, unsigned I) {
  auto *C = reinterpret_cast<clang::ObjCContainerDecl *>(CD);
  auto It = C->prop_begin();
  std::advance(It, I);
  return reinterpret_cast<CXObjCPropertyDecl>(*It);
}

unsigned clang_ObjCContainerDecl_meth_size(CXObjCContainerDecl CD) {
  auto *C = reinterpret_cast<clang::ObjCContainerDecl *>(CD);
  return static_cast<unsigned>(std::distance(C->meth_begin(), C->meth_end()));
}

CXObjCMethodDecl clang_ObjCContainerDecl_getMethodAt(CXObjCContainerDecl CD, unsigned I) {
  auto *C = reinterpret_cast<clang::ObjCContainerDecl *>(CD);
  auto It = C->meth_begin();
  std::advance(It, I);
  return reinterpret_cast<CXObjCMethodDecl>(*It);
}

// A Selector is interned in the ASTContext's SelectorTable, so one cannot be built from a
// spelling without a context. "a:b:" is two segments, "a" is a nullary one; the split
// keeps clang's own convention that a trailing colon closes the last segment rather than
// opening an empty one.
static clang::Selector selectorFromSpelling(llvm::StringRef Spelling, clang::ASTContext &C) {
  llvm::SmallVector<clang::IdentifierInfo *, 4> Idents;
  if (Spelling.contains(':')) {
    llvm::StringRef Rest = Spelling;
    while (!Rest.empty()) {
      auto Split = Rest.split(':');
      Idents.push_back(Split.first.empty() ? nullptr : &C.Idents.get(Split.first));
      Rest = Split.second;
    }
  } else if (!Spelling.empty()) {
    Idents.push_back(&C.Idents.get(Spelling));
  }
  if (Idents.empty())
    return clang::Selector();
  return C.Selectors.getSelector(Spelling.contains(':') ? Idents.size() : 0, Idents.data());
}

CXObjCMethodDecl clang_ObjCContainerDecl_getMethod(CXObjCContainerDecl CD, const char *Sel,
                                                   CXASTContext C, bool IsInstance,
                                                   bool AllowHidden) {
  auto &Ctx = *reinterpret_cast<clang::ASTContext *>(C);
  return reinterpret_cast<CXObjCMethodDecl>(
      reinterpret_cast<clang::ObjCContainerDecl *>(CD)->getMethod(
          selectorFromSpelling(llvm::StringRef(Sel), Ctx), IsInstance, AllowHidden));
}

CXSourceRange_ clang_ObjCContainerDecl_getAtEndRange(CXObjCContainerDecl CD) {
  clang::SourceRange R = reinterpret_cast<clang::ObjCContainerDecl *>(CD)->getAtEndRange();
  return CXSourceRange_{reinterpret_cast<CXSourceLocation_>(R.getBegin().getPtrEncoding()),
                        reinterpret_cast<CXSourceLocation_>(R.getEnd().getPtrEncoding())};
}

// ObjCInterfaceDecl
unsigned clang_ObjCInterfaceDecl_protocol_size(CXObjCInterfaceDecl ID) {
  auto *D = reinterpret_cast<clang::ObjCInterfaceDecl *>(ID);
  return static_cast<unsigned>(std::distance(D->protocol_begin(), D->protocol_end()));
}

CXObjCProtocolDecl clang_ObjCInterfaceDecl_getProtocol(CXObjCInterfaceDecl ID, unsigned I) {
  auto *D = reinterpret_cast<clang::ObjCInterfaceDecl *>(ID);
  return reinterpret_cast<CXObjCProtocolDecl>(*(D->protocol_begin() + I));
}

unsigned clang_ObjCInterfaceDecl_all_referenced_protocol_size(CXObjCInterfaceDecl ID) {
  auto *D = reinterpret_cast<clang::ObjCInterfaceDecl *>(ID);
  return static_cast<unsigned>(std::distance(D->all_referenced_protocol_begin(),
                                             D->all_referenced_protocol_end()));
}

CXObjCProtocolDecl clang_ObjCInterfaceDecl_getAllReferencedProtocol(CXObjCInterfaceDecl ID,
                                                                    unsigned I) {
  auto *D = reinterpret_cast<clang::ObjCInterfaceDecl *>(ID);
  return reinterpret_cast<CXObjCProtocolDecl>(*(D->all_referenced_protocol_begin() + I));
}

unsigned clang_ObjCInterfaceDecl_ivar_size(CXObjCInterfaceDecl ID) {
  return reinterpret_cast<clang::ObjCInterfaceDecl *>(ID)->ivar_size();
}

CXObjCIvarDecl clang_ObjCInterfaceDecl_getIvar(CXObjCInterfaceDecl ID, unsigned I) {
  auto *D = reinterpret_cast<clang::ObjCInterfaceDecl *>(ID);
  auto It = D->ivar_begin();
  std::advance(It, I);
  return reinterpret_cast<CXObjCIvarDecl>(*It);
}

bool clang_ObjCInterfaceDecl_hasDefinition(CXObjCInterfaceDecl ID) {
  return reinterpret_cast<clang::ObjCInterfaceDecl *>(ID)->hasDefinition();
}

bool clang_ObjCInterfaceDecl_isThisDeclarationADefinition(CXObjCInterfaceDecl ID) {
  return reinterpret_cast<clang::ObjCInterfaceDecl *>(ID)->isThisDeclarationADefinition();
}

CXObjCInterfaceDecl clang_ObjCInterfaceDecl_getDefinition(CXObjCInterfaceDecl ID) {
  return reinterpret_cast<CXObjCInterfaceDecl>(
      reinterpret_cast<clang::ObjCInterfaceDecl *>(ID)->getDefinition());
}

CXObjCInterfaceDecl clang_ObjCInterfaceDecl_getSuperClass(CXObjCInterfaceDecl ID) {
  return reinterpret_cast<CXObjCInterfaceDecl>(
      reinterpret_cast<clang::ObjCInterfaceDecl *>(ID)->getSuperClass());
}

CXObjCObjectType clang_ObjCInterfaceDecl_getSuperClassType(CXObjCInterfaceDecl ID) {
  return reinterpret_cast<CXObjCObjectType>(const_cast<clang::ObjCObjectType *>(
      reinterpret_cast<clang::ObjCInterfaceDecl *>(ID)->getSuperClassType()));
}

CXTypeSourceInfo clang_ObjCInterfaceDecl_getSuperClassTInfo(CXObjCInterfaceDecl ID) {
  return reinterpret_cast<CXTypeSourceInfo>(
      reinterpret_cast<clang::ObjCInterfaceDecl *>(ID)->getSuperClassTInfo());
}

unsigned clang_ObjCInterfaceDecl_getNumTypeParams(CXObjCInterfaceDecl ID) {
  auto *L = reinterpret_cast<clang::ObjCInterfaceDecl *>(ID)->getTypeParamList();
  return L ? L->size() : 0;
}

CXObjCTypeParamDecl clang_ObjCInterfaceDecl_getTypeParam(CXObjCInterfaceDecl ID,
                                                         unsigned I) {
  auto *L = reinterpret_cast<clang::ObjCInterfaceDecl *>(ID)->getTypeParamList();
  return reinterpret_cast<CXObjCTypeParamDecl>(*(L->begin() + I));
}

CXObjCInterfaceDecl clang_ObjCInterfaceDecl_getCanonicalDecl(CXObjCInterfaceDecl ID) {
  return reinterpret_cast<CXObjCInterfaceDecl>(
      reinterpret_cast<clang::ObjCInterfaceDecl *>(ID)->getCanonicalDecl());
}

// ObjCProtocolDecl
unsigned clang_ObjCProtocolDecl_protocol_size(CXObjCProtocolDecl PD) {
  return reinterpret_cast<clang::ObjCProtocolDecl *>(PD)->protocol_size();
}

CXObjCProtocolDecl clang_ObjCProtocolDecl_getProtocol(CXObjCProtocolDecl PD, unsigned I) {
  auto *D = reinterpret_cast<clang::ObjCProtocolDecl *>(PD);
  return reinterpret_cast<CXObjCProtocolDecl>(*(D->protocol_begin() + I));
}

bool clang_ObjCProtocolDecl_hasDefinition(CXObjCProtocolDecl PD) {
  return reinterpret_cast<clang::ObjCProtocolDecl *>(PD)->hasDefinition();
}

bool clang_ObjCProtocolDecl_isThisDeclarationADefinition(CXObjCProtocolDecl PD) {
  return reinterpret_cast<clang::ObjCProtocolDecl *>(PD)->isThisDeclarationADefinition();
}

CXObjCProtocolDecl clang_ObjCProtocolDecl_getDefinition(CXObjCProtocolDecl PD) {
  return reinterpret_cast<CXObjCProtocolDecl>(
      reinterpret_cast<clang::ObjCProtocolDecl *>(PD)->getDefinition());
}

CXObjCProtocolDecl clang_ObjCProtocolDecl_getCanonicalDecl(CXObjCProtocolDecl PD) {
  return reinterpret_cast<CXObjCProtocolDecl>(
      reinterpret_cast<clang::ObjCProtocolDecl *>(PD)->getCanonicalDecl());
}

// ObjCCategoryDecl
CXObjCInterfaceDecl clang_ObjCCategoryDecl_getClassInterface(CXObjCCategoryDecl CD) {
  return reinterpret_cast<CXObjCInterfaceDecl>(
      reinterpret_cast<clang::ObjCCategoryDecl *>(CD)->getClassInterface());
}

unsigned clang_ObjCCategoryDecl_protocol_size(CXObjCCategoryDecl CD) {
  return reinterpret_cast<clang::ObjCCategoryDecl *>(CD)->protocol_size();
}

CXObjCProtocolDecl clang_ObjCCategoryDecl_getProtocol(CXObjCCategoryDecl CD, unsigned I) {
  auto *D = reinterpret_cast<clang::ObjCCategoryDecl *>(CD);
  return reinterpret_cast<CXObjCProtocolDecl>(*(D->protocol_begin() + I));
}

CXObjCCategoryDecl clang_ObjCCategoryDecl_getNextClassCategory(CXObjCCategoryDecl CD) {
  return reinterpret_cast<CXObjCCategoryDecl>(
      reinterpret_cast<clang::ObjCCategoryDecl *>(CD)->getNextClassCategory());
}

bool clang_ObjCCategoryDecl_IsClassExtension(CXObjCCategoryDecl CD) {
  return reinterpret_cast<clang::ObjCCategoryDecl *>(CD)->IsClassExtension();
}

unsigned clang_ObjCCategoryDecl_ivar_size(CXObjCCategoryDecl CD) {
  return reinterpret_cast<clang::ObjCCategoryDecl *>(CD)->ivar_size();
}

CXObjCIvarDecl clang_ObjCCategoryDecl_getIvar(CXObjCCategoryDecl CD, unsigned I) {
  auto *D = reinterpret_cast<clang::ObjCCategoryDecl *>(CD);
  auto It = D->ivar_begin();
  std::advance(It, I);
  return reinterpret_cast<CXObjCIvarDecl>(*It);
}

CXSourceLocation_ clang_ObjCCategoryDecl_getCategoryNameLoc(CXObjCCategoryDecl CD) {
  return reinterpret_cast<CXSourceLocation_>(
      reinterpret_cast<clang::ObjCCategoryDecl *>(CD)->getCategoryNameLoc().getPtrEncoding());
}

// ObjCPropertyDecl
CXQualType clang_ObjCPropertyDecl_getType(CXObjCPropertyDecl PD) {
  return reinterpret_cast<CXQualType>(
      reinterpret_cast<clang::ObjCPropertyDecl *>(PD)->getType().getAsOpaquePtr());
}

CXTypeSourceInfo clang_ObjCPropertyDecl_getTypeSourceInfo(CXObjCPropertyDecl PD) {
  return reinterpret_cast<CXTypeSourceInfo>(
      reinterpret_cast<clang::ObjCPropertyDecl *>(PD)->getTypeSourceInfo());
}

CXObjCPropertyAttributeKind
clang_ObjCPropertyDecl_getPropertyAttributes(CXObjCPropertyDecl PD) {
  return static_cast<CXObjCPropertyAttributeKind>(
      reinterpret_cast<clang::ObjCPropertyDecl *>(PD)->getPropertyAttributes());
}

CXObjCPropertyAttributeKind
clang_ObjCPropertyDecl_getPropertyAttributesAsWritten(CXObjCPropertyDecl PD) {
  return static_cast<CXObjCPropertyAttributeKind>(
      reinterpret_cast<clang::ObjCPropertyDecl *>(PD)->getPropertyAttributesAsWritten());
}

CXString clang_ObjCPropertyDecl_getGetterName(CXObjCPropertyDecl PD) {
  return extra::makeCXString(
      reinterpret_cast<clang::ObjCPropertyDecl *>(PD)->getGetterName().getAsString());
}

CXString clang_ObjCPropertyDecl_getSetterName(CXObjCPropertyDecl PD) {
  return extra::makeCXString(
      reinterpret_cast<clang::ObjCPropertyDecl *>(PD)->getSetterName().getAsString());
}

CXObjCMethodDecl clang_ObjCPropertyDecl_getGetterMethodDecl(CXObjCPropertyDecl PD) {
  return reinterpret_cast<CXObjCMethodDecl>(
      reinterpret_cast<clang::ObjCPropertyDecl *>(PD)->getGetterMethodDecl());
}

CXObjCMethodDecl clang_ObjCPropertyDecl_getSetterMethodDecl(CXObjCPropertyDecl PD) {
  return reinterpret_cast<CXObjCMethodDecl>(
      reinterpret_cast<clang::ObjCPropertyDecl *>(PD)->getSetterMethodDecl());
}

bool clang_ObjCPropertyDecl_isReadOnly(CXObjCPropertyDecl PD) {
  return reinterpret_cast<clang::ObjCPropertyDecl *>(PD)->isReadOnly();
}

bool clang_ObjCPropertyDecl_isAtomic(CXObjCPropertyDecl PD) {
  return reinterpret_cast<clang::ObjCPropertyDecl *>(PD)->isAtomic();
}

bool clang_ObjCPropertyDecl_isInstanceProperty(CXObjCPropertyDecl PD) {
  return reinterpret_cast<clang::ObjCPropertyDecl *>(PD)->isInstanceProperty();
}

bool clang_ObjCPropertyDecl_isClassProperty(CXObjCPropertyDecl PD) {
  return reinterpret_cast<clang::ObjCPropertyDecl *>(PD)->isClassProperty();
}

bool clang_ObjCPropertyDecl_isOptional(CXObjCPropertyDecl PD) {
  return reinterpret_cast<clang::ObjCPropertyDecl *>(PD)->isOptional();
}

CXSourceLocation_ clang_ObjCPropertyDecl_getAtLoc(CXObjCPropertyDecl PD) {
  return reinterpret_cast<CXSourceLocation_>(
      reinterpret_cast<clang::ObjCPropertyDecl *>(PD)->getAtLoc().getPtrEncoding());
}

// ObjCIvarDecl
CXObjCIvarDecl_AccessControl clang_ObjCIvarDecl_getAccessControl(CXObjCIvarDecl IVD) {
  return static_cast<CXObjCIvarDecl_AccessControl>(
      reinterpret_cast<clang::ObjCIvarDecl *>(IVD)->getAccessControl());
}

CXObjCIvarDecl_AccessControl
clang_ObjCIvarDecl_getCanonicalAccessControl(CXObjCIvarDecl IVD) {
  return static_cast<CXObjCIvarDecl_AccessControl>(
      reinterpret_cast<clang::ObjCIvarDecl *>(IVD)->getCanonicalAccessControl());
}

CXObjCInterfaceDecl clang_ObjCIvarDecl_getContainingInterface(CXObjCIvarDecl IVD) {
  return reinterpret_cast<CXObjCInterfaceDecl>(
      reinterpret_cast<clang::ObjCIvarDecl *>(IVD)->getContainingInterface());
}

CXObjCIvarDecl clang_ObjCIvarDecl_getNextIvar(CXObjCIvarDecl IVD) {
  return reinterpret_cast<CXObjCIvarDecl>(
      reinterpret_cast<clang::ObjCIvarDecl *>(IVD)->getNextIvar());
}

bool clang_ObjCIvarDecl_getSynthesize(CXObjCIvarDecl IVD) {
  return reinterpret_cast<clang::ObjCIvarDecl *>(IVD)->getSynthesize();
}

// ObjCCompatibleAliasDecl
CXObjCInterfaceDecl
clang_ObjCCompatibleAliasDecl_getClassInterface(CXObjCCompatibleAliasDecl AD) {
  return reinterpret_cast<CXObjCInterfaceDecl>(
      reinterpret_cast<clang::ObjCCompatibleAliasDecl *>(AD)->getClassInterface());
}

// ObjCImplDecl
CXObjCInterfaceDecl clang_ObjCImplDecl_getClassInterface(CXObjCImplDecl ID) {
  return reinterpret_cast<CXObjCInterfaceDecl>(
      reinterpret_cast<clang::ObjCImplDecl *>(ID)->getClassInterface());
}

// ObjCImplementationDecl
CXObjCInterfaceDecl
clang_ObjCImplementationDecl_getSuperClass(CXObjCImplementationDecl ID) {
  return reinterpret_cast<CXObjCInterfaceDecl>(
      reinterpret_cast<clang::ObjCImplementationDecl *>(ID)->getSuperClass());
}

// ObjCCategoryImplDecl
CXObjCCategoryDecl clang_ObjCCategoryImplDecl_getCategoryDecl(CXObjCCategoryImplDecl ID) {
  return reinterpret_cast<CXObjCCategoryDecl>(
      reinterpret_cast<clang::ObjCCategoryImplDecl *>(ID)->getCategoryDecl());
}
