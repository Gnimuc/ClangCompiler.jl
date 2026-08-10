#include "clang-ex/AST/CXASTImporter.h"
#include "utils.h"

#include "clang/AST/APValue.h"
#include "clang/AST/ASTContext.h"
#include "clang/AST/ASTImportError.h"
#include "clang/AST/ASTImporter.h"
#include "clang/AST/Attr.h"
#include "clang/AST/Decl.h"
#include "clang/AST/DeclBase.h"
#include "clang/AST/DeclCXX.h"
#include "clang/AST/DeclarationName.h"
#include "clang/AST/Expr.h"
#include "clang/AST/NestedNameSpecifier.h"
#include "clang/AST/Stmt.h"
#include "clang/AST/TemplateName.h"
#include "clang/AST/Type.h"
#include "clang/Basic/FileManager.h"
#include "clang/Basic/IdentifierTable.h"
#include "clang/Basic/SourceLocation.h"
#include "llvm/Support/Error.h"
#include "llvm/Support/raw_ostream.h"

#include <memory>
#include <string>
#include <utility>

namespace {

clang::ASTImporter *importer(CXASTImporter Importer) {
  return reinterpret_cast<clang::ASTImporter *>(Importer);
}

// No error crosses the boundary. Every ASTImporter::Import is
// llvm::Expected, and an Expected destroyed without being checked aborts under an
// assertion-enabled LLVM, so the error is always consumed here: logged, then reported as
// the caller's null sentinel.
void logImportError(llvm::Error E) {
  llvm::errs() << "LIBCLANGEX ERROR: ASTImporter: " << llvm::toString(std::move(E)) << "\n";
}

template <typename T> T *unwrapPointer(llvm::Expected<T *> Result) {
  if (!Result) {
    logImportError(Result.takeError());
    return nullptr;
  }
  return *Result;
}

} // namespace

// getCanonicalForwardRedeclChain

// ASTImporter
CXASTImporter clang_ASTImporter_create(CXASTContext ToContext, CXFileManager ToFileManager,
                                       CXASTContext FromContext,
                                       CXFileManager FromFileManager, bool MinimalImport) {
  return reinterpret_cast<CXASTImporter>(
      std::make_unique<clang::ASTImporter>(
          *reinterpret_cast<clang::ASTContext *>(ToContext),
          *reinterpret_cast<clang::FileManager *>(ToFileManager),
          *reinterpret_cast<clang::ASTContext *>(FromContext),
          *reinterpret_cast<clang::FileManager *>(FromFileManager), MinimalImport,
          /*SharedState=*/nullptr)
          .release());
}

void clang_ASTImporter_dispose(CXASTImporter Importer) {
  delete importer(Importer); // NOLINT(*-owning-memory)
}

bool clang_ASTImporter_isMinimalImport(CXASTImporter Importer) {
  return importer(Importer)->isMinimalImport();
}

void clang_ASTImporter_setODRHandling(CXASTImporter Importer,
                                      CXASTImporter_ODRHandlingType T) {
  importer(Importer)->setODRHandling(
      static_cast<clang::ASTImporter::ODRHandlingType>(T));
}

// importInto
// Import(ExprWithCleanups::CleanupObject)

CXType_ clang_ASTImporter_ImportType(CXASTImporter Importer, CXType_ FromT) {
  return reinterpret_cast<CXType_>(const_cast<clang::Type *>(
      unwrapPointer(importer(Importer)->Import(reinterpret_cast<clang::Type *>(FromT)))));
}

CXQualType clang_ASTImporter_ImportQualType(CXASTImporter Importer, CXQualType FromT) {
  auto Result = importer(Importer)->Import(clang::QualType::getFromOpaquePtr(FromT));
  if (!Result) {
    logImportError(Result.takeError());
    return nullptr;
  }
  return reinterpret_cast<CXQualType>(Result->getAsOpaquePtr());
}

CXTypeSourceInfo clang_ASTImporter_ImportTypeSourceInfo(CXASTImporter Importer,
                                                        CXTypeSourceInfo FromTSI) {
  return reinterpret_cast<CXTypeSourceInfo>(unwrapPointer(
      importer(Importer)->Import(reinterpret_cast<clang::TypeSourceInfo *>(FromTSI))));
}

CXAttr clang_ASTImporter_ImportAttr(CXASTImporter Importer, CXAttr FromAttr) {
  return reinterpret_cast<CXAttr>(
      unwrapPointer(importer(Importer)->Import(reinterpret_cast<clang::Attr *>(FromAttr))));
}

CXDecl clang_ASTImporter_ImportDecl(CXASTImporter Importer, CXDecl FromD) {
  return reinterpret_cast<CXDecl>(
      unwrapPointer(importer(Importer)->Import(reinterpret_cast<clang::Decl *>(FromD))));
}

// Import(const InheritedConstructor &)

CXDecl clang_ASTImporter_GetAlreadyImportedOrNull(CXASTImporter Importer, CXDecl FromD) {
  return reinterpret_cast<CXDecl>(
      importer(Importer)->GetAlreadyImportedOrNull(reinterpret_cast<clang::Decl *>(FromD)));
}

CXTranslationUnitDecl clang_ASTImporter_GetFromTU(CXASTImporter Importer, CXDecl ToD) {
  return reinterpret_cast<CXTranslationUnitDecl>(
      importer(Importer)->GetFromTU(reinterpret_cast<clang::Decl *>(ToD)));
}

// getImportedFromDecl

CXDeclContext clang_ASTImporter_ImportContext(CXASTImporter Importer,
                                              CXDeclContext FromDC) {
  return reinterpret_cast<CXDeclContext>(unwrapPointer(
      importer(Importer)->ImportContext(reinterpret_cast<clang::DeclContext *>(FromDC))));
}

CXExpr clang_ASTImporter_ImportExpr(CXASTImporter Importer, CXExpr FromE) {
  return reinterpret_cast<CXExpr>(
      unwrapPointer(importer(Importer)->Import(reinterpret_cast<clang::Expr *>(FromE))));
}

CXStmt clang_ASTImporter_ImportStmt(CXASTImporter Importer, CXStmt FromS) {
  return reinterpret_cast<CXStmt>(
      unwrapPointer(importer(Importer)->Import(reinterpret_cast<clang::Stmt *>(FromS))));
}

CXNestedNameSpecifier
clang_ASTImporter_ImportNestedNameSpecifier(CXASTImporter Importer,
                                            CXNestedNameSpecifier FromNNS) {
  return reinterpret_cast<CXNestedNameSpecifier>(unwrapPointer(
      importer(Importer)->Import(reinterpret_cast<clang::NestedNameSpecifier *>(FromNNS))));
}

// Import(NestedNameSpecifierLoc)

CXTemplateName clang_ASTImporter_ImportTemplateName(CXASTImporter Importer,
                                                    CXTemplateName From) {
  auto Result = importer(Importer)->Import(clang::TemplateName::getFromVoidPointer(From));
  if (!Result) {
    logImportError(Result.takeError());
    return nullptr;
  }
  return reinterpret_cast<CXTemplateName>(Result->getAsVoidPointer());
}

CXSourceLocation_ clang_ASTImporter_ImportSourceLocation(CXASTImporter Importer,
                                                         CXSourceLocation_ FromLoc) {
  auto Result = importer(Importer)->Import(
      clang::SourceLocation::getFromPtrEncoding(FromLoc));
  if (!Result) {
    logImportError(Result.takeError());
    return nullptr;
  }
  return reinterpret_cast<CXSourceLocation_>(Result->getPtrEncoding());
}

CXSourceRange_ clang_ASTImporter_ImportSourceRange(CXASTImporter Importer,
                                                   CXSourceRange_ FromRange) {
  clang::SourceRange R(clang::SourceLocation::getFromPtrEncoding(FromRange.B),
                       clang::SourceLocation::getFromPtrEncoding(FromRange.E));
  auto Result = importer(Importer)->Import(R);
  if (!Result) {
    logImportError(Result.takeError());
    return CXSourceRange_{nullptr, nullptr};
  }
  return CXSourceRange_{
      reinterpret_cast<CXSourceLocation_>(Result->getBegin().getPtrEncoding()),
      reinterpret_cast<CXSourceLocation_>(Result->getEnd().getPtrEncoding())};
}

CXDeclarationName clang_ASTImporter_ImportDeclarationName(CXASTImporter Importer,
                                                          CXDeclarationName FromName) {
  auto Result =
      importer(Importer)->Import(clang::DeclarationName::getFromOpaquePtr(FromName));
  if (!Result) {
    logImportError(Result.takeError());
    return nullptr;
  }
  return reinterpret_cast<CXDeclarationName>(Result->getAsOpaquePtr());
}

CXIdentifierInfo clang_ASTImporter_ImportIdentifierInfo(CXASTImporter Importer,
                                                        CXIdentifierInfo FromId) {
  return reinterpret_cast<CXIdentifierInfo>(importer(Importer)->Import(
      reinterpret_cast<const clang::IdentifierInfo *>(FromId)));
}

// Import(Selector)
// Import(FileID, bool)

CXCXXCtorInitializer
clang_ASTImporter_ImportCXXCtorInitializer(CXASTImporter Importer,
                                           CXCXXCtorInitializer FromInit) {
  return reinterpret_cast<CXCXXCtorInitializer>(unwrapPointer(
      importer(Importer)->Import(reinterpret_cast<clang::CXXCtorInitializer *>(FromInit))));
}

CXCXXBaseSpecifier clang_ASTImporter_ImportCXXBaseSpecifier(CXASTImporter Importer,
                                                            CXCXXBaseSpecifier FromSpec) {
  return reinterpret_cast<CXCXXBaseSpecifier>(unwrapPointer(
      importer(Importer)->Import(reinterpret_cast<clang::CXXBaseSpecifier *>(FromSpec))));
}

CXAPValue clang_ASTImporter_ImportAPValue(CXASTImporter Importer, CXAPValue FromValue) {
  auto Result = importer(Importer)->Import(*reinterpret_cast<clang::APValue *>(FromValue));
  if (!Result) {
    logImportError(Result.takeError());
    return nullptr;
  }
  return reinterpret_cast<CXAPValue>(
      std::make_unique<clang::APValue>(std::move(*Result)).release());
}

CXString clang_ASTImporter_ImportDefinition(CXASTImporter Importer, CXDecl From) {
  llvm::Error E = importer(Importer)->ImportDefinition(reinterpret_cast<clang::Decl *>(From));
  if (!E)
    return extra::makeCXString("");
  return extra::makeCXString(llvm::toString(std::move(E)));
}

// HandleNameConflict

CXASTContext clang_ASTImporter_getToContext(CXASTImporter Importer) {
  return reinterpret_cast<CXASTContext>(&importer(Importer)->getToContext());
}

CXASTContext clang_ASTImporter_getFromContext(CXASTImporter Importer) {
  return reinterpret_cast<CXASTContext>(&importer(Importer)->getFromContext());
}

CXFileManager clang_ASTImporter_getToFileManager(CXASTImporter Importer) {
  return reinterpret_cast<CXFileManager>(&importer(Importer)->getToFileManager());
}

CXFileManager clang_ASTImporter_getFromFileManager(CXASTImporter Importer) {
  return reinterpret_cast<CXFileManager>(&importer(Importer)->getFromFileManager());
}

// ToDiag
// FromDiag
// getNonEquivalentDecls

void clang_ASTImporter_CompleteDecl(CXASTImporter Importer, CXDecl D) {
  importer(Importer)->CompleteDecl(reinterpret_cast<clang::Decl *>(D));
}

void clang_ASTImporter_RegisterImportedDecl(CXASTImporter Importer, CXDecl FromD,
                                            CXDecl ToD) {
  importer(Importer)->RegisterImportedDecl(reinterpret_cast<clang::Decl *>(FromD),
                                           reinterpret_cast<clang::Decl *>(ToD));
}

CXDecl clang_ASTImporter_MapImported(CXASTImporter Importer, CXDecl From, CXDecl To) {
  return reinterpret_cast<CXDecl>(
      importer(Importer)->MapImported(reinterpret_cast<clang::Decl *>(From),
                                      reinterpret_cast<clang::Decl *>(To)));
}

// Imported
// GetOriginalDecl

CXASTImportError_ErrorKind
clang_ASTImporter_getImportDeclErrorIfAny(CXASTImporter Importer, CXDecl FromD,
                                          bool *HasError) {
  std::optional<clang::ASTImportError> Err =
      importer(Importer)->getImportDeclErrorIfAny(reinterpret_cast<clang::Decl *>(FromD));
  *HasError = Err.has_value();
  if (!Err)
    return CXASTImportError_Unknown;
  return static_cast<CXASTImportError_ErrorKind>(Err->Error);
}

void clang_ASTImporter_setImportDeclError(CXASTImporter Importer, CXDecl From,
                                          CXASTImportError_ErrorKind Error) {
  importer(Importer)->setImportDeclError(
      reinterpret_cast<clang::Decl *>(From),
      clang::ASTImportError(static_cast<clang::ASTImportError::ErrorKind>(Error)));
}

bool clang_ASTImporter_IsStructurallyEquivalent(CXASTImporter Importer, CXQualType From,
                                                CXQualType To, bool Complain) {
  return importer(Importer)->IsStructurallyEquivalent(
      clang::QualType::getFromOpaquePtr(From), clang::QualType::getFromOpaquePtr(To),
      Complain);
}

// getFieldIndex
