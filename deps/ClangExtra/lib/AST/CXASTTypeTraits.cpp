#include "clang-ex/AST/CXASTTypeTraits.h"
#include "utils.h"

#include "clang/AST/ASTContext.h"
#include "clang/AST/ASTTypeTraits.h"
#include "clang/AST/Attr.h"
#include "clang/AST/DeclBase.h"
#include "clang/AST/DeclCXX.h"
#include "clang/AST/NestedNameSpecifier.h"
#include "clang/AST/PrettyPrinter.h"
#include "clang/AST/Stmt.h"
#include "clang/AST/TemplateBase.h"
#include "clang/AST/Type.h"
#include "clang/AST/TypeLoc.h"
#include "llvm/Support/raw_ostream.h"

#include <memory>
#include <string>

namespace {

clang::DynTypedNode *node(CXDynTypedNode N) {
  return reinterpret_cast<clang::DynTypedNode *>(N);
}

CXDynTypedNode boxNode(const clang::DynTypedNode &N) {
  return reinterpret_cast<CXDynTypedNode>(
      std::make_unique<clang::DynTypedNode>(N).release());
}

} // namespace

// DynTypedNode
CXDynTypedNode clang_DynTypedNode_createFromStmt(CXStmt S) {
  return boxNode(clang::DynTypedNode::create(*reinterpret_cast<clang::Stmt *>(S)));
}

CXDynTypedNode clang_DynTypedNode_createFromDecl(CXDecl D) {
  return boxNode(clang::DynTypedNode::create(*reinterpret_cast<clang::Decl *>(D)));
}

CXDynTypedNode clang_DynTypedNode_createFromType(CXType_ T) {
  return boxNode(clang::DynTypedNode::create(*reinterpret_cast<clang::Type *>(T)));
}

CXDynTypedNode clang_DynTypedNode_createFromQualType(CXQualType T) {
  return boxNode(clang::DynTypedNode::create(clang::QualType::getFromOpaquePtr(T)));
}

CXDynTypedNode clang_DynTypedNode_createFromTypeLoc(CXTypeLoc TL) {
  return boxNode(clang::DynTypedNode::create(*reinterpret_cast<clang::TypeLoc *>(TL)));
}

CXDynTypedNode clang_DynTypedNode_createFromNestedNameSpecifier(CXNestedNameSpecifier NNS) {
  return boxNode(
      clang::DynTypedNode::create(*reinterpret_cast<clang::NestedNameSpecifier *>(NNS)));
}

CXDynTypedNode
clang_DynTypedNode_createFromNestedNameSpecifierLoc(CXNestedNameSpecifierLoc NNSL) {
  return boxNode(clang::DynTypedNode::create(
      *reinterpret_cast<clang::NestedNameSpecifierLoc *>(NNSL)));
}

CXDynTypedNode clang_DynTypedNode_createFromAttr(CXAttr A) {
  return boxNode(clang::DynTypedNode::create(*reinterpret_cast<clang::Attr *>(A)));
}

void clang_DynTypedNode_dispose(CXDynTypedNode N) {
  delete node(N); // NOLINT(*-owning-memory)
}

CXString clang_DynTypedNode_getNodeKindName(CXDynTypedNode N) {
  return extra::makeCXString(node(N)->getNodeKind().asStringRef().str());
}

bool clang_DynTypedNode_isNodeKindNone(CXDynTypedNode N) {
  return node(N)->getNodeKind().isNone();
}

bool clang_DynTypedNode_nodeKindHasPointerIdentity(CXDynTypedNode N) {
  return node(N)->getNodeKind().hasPointerIdentity();
}

bool clang_DynTypedNode_isNodeKindSame(CXDynTypedNode A, CXDynTypedNode B) {
  return node(A)->getNodeKind().isSame(node(B)->getNodeKind());
}

bool clang_DynTypedNode_isNodeKindBaseOf(CXDynTypedNode Base, CXDynTypedNode Derived) {
  return node(Base)->getNodeKind().isBaseOf(node(Derived)->getNodeKind());
}

CXStmt clang_DynTypedNode_getAsStmt(CXDynTypedNode N) {
  return reinterpret_cast<CXStmt>(const_cast<clang::Stmt *>(node(N)->get<clang::Stmt>()));
}

CXDecl clang_DynTypedNode_getAsDecl(CXDynTypedNode N) {
  return reinterpret_cast<CXDecl>(const_cast<clang::Decl *>(node(N)->get<clang::Decl>()));
}

CXType_ clang_DynTypedNode_getAsType(CXDynTypedNode N) {
  return reinterpret_cast<CXType_>(const_cast<clang::Type *>(node(N)->get<clang::Type>()));
}

CXNestedNameSpecifier clang_DynTypedNode_getAsNestedNameSpecifier(CXDynTypedNode N) {
  return reinterpret_cast<CXNestedNameSpecifier>(
      const_cast<clang::NestedNameSpecifier *>(node(N)->get<clang::NestedNameSpecifier>()));
}

CXAttr clang_DynTypedNode_getAsAttr(CXDynTypedNode N) {
  return reinterpret_cast<CXAttr>(const_cast<clang::Attr *>(node(N)->get<clang::Attr>()));
}

CXCXXCtorInitializer clang_DynTypedNode_getAsCXXCtorInitializer(CXDynTypedNode N) {
  return reinterpret_cast<CXCXXCtorInitializer>(const_cast<clang::CXXCtorInitializer *>(
      node(N)->get<clang::CXXCtorInitializer>()));
}

CXCXXBaseSpecifier clang_DynTypedNode_getAsCXXBaseSpecifier(CXDynTypedNode N) {
  return reinterpret_cast<CXCXXBaseSpecifier>(
      const_cast<clang::CXXBaseSpecifier *>(node(N)->get<clang::CXXBaseSpecifier>()));
}

CXQualType clang_DynTypedNode_getAsQualType(CXDynTypedNode N) {
  const clang::QualType *QT = node(N)->get<clang::QualType>();
  if (QT == nullptr)
    return nullptr;
  return reinterpret_cast<CXQualType>(QT->getAsOpaquePtr());
}

CXTypeLoc clang_DynTypedNode_getAsTypeLoc(CXDynTypedNode N) {
  const clang::TypeLoc *TL = node(N)->get<clang::TypeLoc>();
  if (TL == nullptr)
    return nullptr;
  return reinterpret_cast<CXTypeLoc>(new clang::TypeLoc(*TL)); // NOLINT(*-owning-memory)
}

CXNestedNameSpecifierLoc clang_DynTypedNode_getAsNestedNameSpecifierLoc(CXDynTypedNode N) {
  const clang::NestedNameSpecifierLoc *NNSL = node(N)->get<clang::NestedNameSpecifierLoc>();
  if (NNSL == nullptr)
    return nullptr;
  return reinterpret_cast<CXNestedNameSpecifierLoc>(
      new clang::NestedNameSpecifierLoc(*NNSL)); // NOLINT(*-owning-memory)
}

CXTemplateArgument clang_DynTypedNode_getAsTemplateArgument(CXDynTypedNode N) {
  return reinterpret_cast<CXTemplateArgument>(
      const_cast<clang::TemplateArgument *>(node(N)->get<clang::TemplateArgument>()));
}

// getUnchecked

const void *clang_DynTypedNode_getMemoizationData(CXDynTypedNode N) {
  return node(N)->getMemoizationData();
}

CXSourceRange_ clang_DynTypedNode_getSourceRange(CXDynTypedNode N) {
  clang::SourceRange R = node(N)->getSourceRange();
  return CXSourceRange_{
      reinterpret_cast<CXSourceLocation_>(R.getBegin().getPtrEncoding()),
      reinterpret_cast<CXSourceLocation_>(R.getEnd().getPtrEncoding())};
}

CXString clang_DynTypedNode_print(CXDynTypedNode N, CXPrintingPolicy_ PP) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  node(N)->print(OS, *reinterpret_cast<clang::PrintingPolicy *>(PP));
  return extra::makeCXString(OS.str());
}

CXString clang_DynTypedNode_dump(CXDynTypedNode N, CXASTContext Context) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  node(N)->dump(OS, *reinterpret_cast<clang::ASTContext *>(Context));
  return extra::makeCXString(OS.str());
}
