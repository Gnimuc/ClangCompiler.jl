#include "clang-ex/AST/CXDecl.h"
#include "utils.h"
#include "clang/AST/ASTContext.h"
#include "clang/AST/ASTContextAllocate.h"
#include "clang/AST/Decl.h"
#include "clang/AST/DeclTemplate.h"
#include "clang/AST/TypeLoc.h"
#include "clang/Basic/LangOptions.h"
#include "clang/Basic/PartialDiagnostic.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/ExecutionEngine/GenericValue.h"

// TranslationUnitDecl
CXASTContext clang_TranslationUnitDecl_getASTContext(CXTranslationUnitDecl TUD) {
  return reinterpret_cast<CXASTContext>(&reinterpret_cast<clang::TranslationUnitDecl *>(TUD)->getASTContext());
}

CXNamespaceDecl clang_TranslationUnitDecl_getAnonymousNamespace(CXTranslationUnitDecl TUD) {
  return reinterpret_cast<CXNamespaceDecl>(reinterpret_cast<clang::TranslationUnitDecl *>(TUD)->getAnonymousNamespace());
}

void clang_TranslationUnitDecl_setAnonymousNamespace(CXTranslationUnitDecl TUD,
                                                     CXNamespaceDecl ND) {
  reinterpret_cast<clang::TranslationUnitDecl *>(TUD)->setAnonymousNamespace(
      reinterpret_cast<clang::NamespaceDecl *>(ND));
}

CXTranslationUnitDecl clang_TranslationUnitDecl_Create(CXASTContext C) {
  return reinterpret_cast<CXTranslationUnitDecl>(clang::TranslationUnitDecl::Create(*reinterpret_cast<clang::ASTContext *>(C)));
}

bool clang_TranslationUnitDecl_classofKind(CXDeclKind K) {
  return clang::TranslationUnitDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// TranslationUnitDecl Cast
CXDeclContext clang_TranslationUnitDecl_castToDeclContext(CXTranslationUnitDecl TUD) {
  return reinterpret_cast<CXDeclContext>(clang::TranslationUnitDecl::castToDeclContext(
      reinterpret_cast<clang::TranslationUnitDecl *>(TUD)));
}

CXTranslationUnitDecl clang_TranslationUnitDecl_castFromDeclContext(CXDeclContext DC) {
  return reinterpret_cast<CXTranslationUnitDecl>(clang::TranslationUnitDecl::castFromDeclContext(
      reinterpret_cast<clang::DeclContext *>(DC)));
}

// PragmaCommentDecl
CXPragmaCommentDecl clang_PragmaCommentDecl_Create(CXASTContext C, CXTranslationUnitDecl DC,
                                                   CXSourceLocation_ CommentLoc,
                                                   CXPragmaMSCommentKind CommentKind,
                                                   const char *Arg) {
  return reinterpret_cast<CXPragmaCommentDecl>(clang::PragmaCommentDecl::Create(
      *reinterpret_cast<clang::ASTContext *>(C), reinterpret_cast<clang::TranslationUnitDecl *>(DC),
      clang::SourceLocation::getFromPtrEncoding(CommentLoc),
      static_cast<clang::PragmaMSCommentKind>(CommentKind), llvm::StringRef(Arg)));
}

CXPragmaCommentDecl clang_PragmaCommentDecl_CreateDeserialized(CXASTContext C, unsigned ID,
                                                               unsigned ArgSize) {
  return reinterpret_cast<CXPragmaCommentDecl>(clang::PragmaCommentDecl::CreateDeserialized(*reinterpret_cast<clang::ASTContext *>(C),
                                                      ID, ArgSize));
}

CXPragmaMSCommentKind clang_PragmaCommentDecl_getCommentKind(CXPragmaCommentDecl PCD) {
  return static_cast<CXPragmaMSCommentKind>(
      reinterpret_cast<clang::PragmaCommentDecl *>(PCD)->getCommentKind());
}

const char *clang_PragmaCommentDecl_getArg(CXPragmaCommentDecl PCD) {
  return reinterpret_cast<clang::PragmaCommentDecl *>(PCD)->getArg().data();
}

bool clang_PragmaCommentDecl_classofKind(CXDeclKind K) {
  return clang::PragmaCommentDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// PragmaDetectMismatchDecl
CXPragmaDetectMismatchDecl clang_PragmaDetectMismatchDecl_Create(CXASTContext C,
                                                                 CXTranslationUnitDecl DC,
                                                                 CXSourceLocation_ Loc,
                                                                 const char *Name,
                                                                 const char *Value) {
  return reinterpret_cast<CXPragmaDetectMismatchDecl>(clang::PragmaDetectMismatchDecl::Create(
      *reinterpret_cast<clang::ASTContext *>(C), reinterpret_cast<clang::TranslationUnitDecl *>(DC),
      clang::SourceLocation::getFromPtrEncoding(Loc), llvm::StringRef(Name),
      llvm::StringRef(Value)));
}

CXPragmaDetectMismatchDecl
clang_PragmaDetectMismatchDecl_CreateDeserialized(CXASTContext C, unsigned ID,
                                                  unsigned NameValueSize) {
  return reinterpret_cast<CXPragmaDetectMismatchDecl>(clang::PragmaDetectMismatchDecl::CreateDeserialized(
      *reinterpret_cast<clang::ASTContext *>(C), ID, NameValueSize));
}

const char *clang_PragmaDetectMismatchDecl_getName(CXPragmaDetectMismatchDecl PDMD) {
  return reinterpret_cast<clang::PragmaDetectMismatchDecl *>(PDMD)->getName().data();
}

const char *clang_PragmaDetectMismatchDecl_getValue(CXPragmaDetectMismatchDecl PDMD) {
  return reinterpret_cast<clang::PragmaDetectMismatchDecl *>(PDMD)->getValue().data();
}

bool clang_PragmaDetectMismatchDecl_classofKind(CXDeclKind K) {
  return clang::PragmaDetectMismatchDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// ExternCContextDecl
CXExternCContextDecl clang_ExternCContextDecl_Create(CXASTContext C,
                                                     CXTranslationUnitDecl TU) {
  return reinterpret_cast<CXExternCContextDecl>(clang::ExternCContextDecl::Create(*reinterpret_cast<clang::ASTContext *>(C),
                                           reinterpret_cast<clang::TranslationUnitDecl *>(TU)));
}

bool clang_ExternCContextDecl_classofKind(CXDeclKind K) {
  return clang::ExternCContextDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// ExternCContextDecl Cast
CXDeclContext clang_ExternCContextDecl_castToDeclContext(CXExternCContextDecl ECD) {
  return reinterpret_cast<CXDeclContext>(clang::ExternCContextDecl::castToDeclContext(
      reinterpret_cast<clang::ExternCContextDecl *>(ECD)));
}

CXExternCContextDecl clang_ExternCContextDecl_castFromDeclContext(CXDeclContext DC) {
  return reinterpret_cast<CXExternCContextDecl>(clang::ExternCContextDecl::castFromDeclContext(
      reinterpret_cast<clang::DeclContext *>(DC)));
}

// NamedDecl
CXIdentifierInfo clang_NamedDecl_getIdentifier(CXNamedDecl ND) {
  return reinterpret_cast<CXIdentifierInfo>(reinterpret_cast<clang::NamedDecl *>(ND)->getIdentifier());
}

const char *clang_NamedDecl_getName(CXNamedDecl ND) {
  return reinterpret_cast<clang::NamedDecl *>(ND)->getName().data();
}

CXDeclarationName clang_NamedDecl_getDeclName(CXNamedDecl ND) {
  return reinterpret_cast<CXDeclarationName>(reinterpret_cast<clang::NamedDecl *>(ND)->getDeclName().getAsOpaquePtr());
}

void clang_NamedDecl_setDeclName(CXNamedDecl ND, CXDeclarationName DN) {
  return reinterpret_cast<clang::NamedDecl *>(ND)->setDeclName(
      clang::DeclarationName::getFromOpaquePtr(DN));
}

bool clang_NamedDecl_declarationReplaces(CXNamedDecl ND, CXNamedDecl OldD,
                                         bool IsKnownNewer) {
  return reinterpret_cast<clang::NamedDecl *>(ND)->declarationReplaces(
      reinterpret_cast<clang::NamedDecl *>(OldD), IsKnownNewer);
}

bool clang_NamedDecl_hasLinkage(CXNamedDecl ND) {
  return reinterpret_cast<clang::NamedDecl *>(ND)->hasLinkage();
}

bool clang_NamedDecl_isCXXClassMember(CXNamedDecl ND) {
  return reinterpret_cast<clang::NamedDecl *>(ND)->isCXXClassMember();
}

bool clang_NamedDecl_isCXXInstanceMember(CXNamedDecl ND) {
  return reinterpret_cast<clang::NamedDecl *>(ND)->isCXXInstanceMember();
}

CXReservedIdentifierStatus clang_NamedDecl_isReserved(CXNamedDecl ND,
                                                      CXLangOptions LangOpts) {
  return static_cast<CXReservedIdentifierStatus>(
      reinterpret_cast<clang::NamedDecl *>(ND)->isReserved(
          *reinterpret_cast<clang::LangOptions *>(LangOpts)));
}

CXLinkage clang_NamedDecl_getLinkageInternal(CXNamedDecl ND) {
  return static_cast<CXLinkage>(reinterpret_cast<clang::NamedDecl *>(ND)->getLinkageInternal());
}

CXLinkage clang_NamedDecl_getFormalLinkage(CXNamedDecl ND) {
  return static_cast<CXLinkage>(reinterpret_cast<clang::NamedDecl *>(ND)->getFormalLinkage());
}

bool clang_NamedDecl_hasExternalFormalLinkage(CXNamedDecl ND) {
  return reinterpret_cast<clang::NamedDecl *>(ND)->hasExternalFormalLinkage();
}

bool clang_NamedDecl_isExternallyVisible(CXNamedDecl ND) {
  return reinterpret_cast<clang::NamedDecl *>(ND)->isExternallyVisible();
}

bool clang_NamedDecl_isExternallyDeclarable(CXNamedDecl ND) {
  return reinterpret_cast<clang::NamedDecl *>(ND)->isExternallyDeclarable();
}

CXVisibility clang_NamedDecl_getVisibility(CXNamedDecl ND) {
  return static_cast<CXVisibility>(reinterpret_cast<clang::NamedDecl *>(ND)->getVisibility());
}


void clang_NamedDecl_getLinkageAndVisibility(CXNamedDecl ND, CXLinkage *L, CXVisibility *V,
                                             bool *VisibilityExplicit) {
  clang::LinkageInfo LV = reinterpret_cast<clang::NamedDecl *>(ND)->getLinkageAndVisibility();
  *L = static_cast<CXLinkage>(LV.getLinkage());
  *V = static_cast<CXVisibility>(LV.getVisibility());
  *VisibilityExplicit = LV.isVisibilityExplicit();
}

bool clang_NamedDecl_getExplicitVisibility(CXNamedDecl ND, bool ForType, CXVisibility *V) {
  std::optional<clang::Visibility> Vis =
      reinterpret_cast<clang::NamedDecl *>(ND)->getExplicitVisibility(
          ForType ? clang::NamedDecl::VisibilityForType
                  : clang::NamedDecl::VisibilityForValue);
  if (!Vis)
    return false;
  *V = static_cast<CXVisibility>(*Vis);
  return true;
}

bool clang_NamedDecl_isLinkageValid(CXNamedDecl ND) {
  return reinterpret_cast<clang::NamedDecl *>(ND)->isLinkageValid();
}

bool clang_NamedDecl_hasLinkageBeenComputed(CXNamedDecl ND) {
  return reinterpret_cast<clang::NamedDecl *>(ND)->hasLinkageBeenComputed();
}

CXNamedDecl clang_NamedDecl_getUnderlyingDecl(CXNamedDecl ND) {
  return reinterpret_cast<CXNamedDecl>(reinterpret_cast<clang::NamedDecl *>(ND)->getUnderlyingDecl());
}

CXNamedDecl clang_NamedDecl_getMostRecentDecl(CXNamedDecl ND) {
  return reinterpret_cast<CXNamedDecl>(reinterpret_cast<clang::NamedDecl *>(ND)->getMostRecentDecl());
}


CXObjCStringFormatFamily clang_NamedDecl_getObjCFStringFormattingFamily(CXNamedDecl ND) {
  return static_cast<CXObjCStringFormatFamily>(
      reinterpret_cast<clang::NamedDecl *>(ND)->getObjCFStringFormattingFamily());
}

bool clang_NamedDecl_classofKind(CXDeclKind K) {
  return clang::NamedDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

CXString clang_NamedDecl_getNameAsString(CXNamedDecl ND) {
  return extra::makeCXString(reinterpret_cast<clang::NamedDecl *>(ND)->getNameAsString());
}

CXString clang_NamedDecl_printName(CXNamedDecl ND) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::NamedDecl *>(ND)->printName(OS);
  return extra::makeCXString(S);
}

CXString clang_NamedDecl_printNestedNameSpecifier(CXNamedDecl ND) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::NamedDecl *>(ND)->printNestedNameSpecifier(OS);
  return extra::makeCXString(S);
}

CXString clang_NamedDecl_getQualifiedNameAsString(CXNamedDecl ND) {
  return extra::makeCXString(
      reinterpret_cast<clang::NamedDecl *>(ND)->getQualifiedNameAsString());
}

CXString clang_NamedDecl_getNameForDiagnostic(CXNamedDecl ND, bool Qualified) {
  auto *D = reinterpret_cast<clang::NamedDecl *>(ND);
  std::string S;
  llvm::raw_string_ostream OS(S);
  D->getNameForDiagnostic(OS, D->getASTContext().getPrintingPolicy(), Qualified);
  return extra::makeCXString(S);
}

bool clang_NamedDecl_isPlaceholderVar(CXNamedDecl ND, CXLangOptions LangOpts) {
  return reinterpret_cast<clang::NamedDecl *>(ND)->isPlaceholderVar(
      *reinterpret_cast<clang::LangOptions *>(LangOpts));
}

// LabelDecl
CXLabelDecl clang_LabelDecl_Create(CXASTContext C, CXDeclContext DC,
                                   CXSourceLocation_ IdentL, CXIdentifierInfo II) {
  return reinterpret_cast<CXLabelDecl>(clang::LabelDecl::Create(*reinterpret_cast<clang::ASTContext *>(C),
                                  reinterpret_cast<clang::DeclContext *>(DC),
                                  clang::SourceLocation::getFromPtrEncoding(IdentL),
                                  reinterpret_cast<clang::IdentifierInfo *>(II)));
}

CXLabelDecl clang_LabelDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return reinterpret_cast<CXLabelDecl>(clang::LabelDecl::CreateDeserialized(*reinterpret_cast<clang::ASTContext *>(C), ID));
}

CXLabelStmt clang_LabelDecl_getStmt(CXLabelDecl LD) {
  return reinterpret_cast<CXLabelStmt>(reinterpret_cast<clang::LabelDecl *>(LD)->getStmt());
}

void clang_LabelDecl_setStmt(CXLabelDecl LD, CXLabelStmt T) {
  reinterpret_cast<clang::LabelDecl *>(LD)->setStmt(reinterpret_cast<clang::LabelStmt *>(T));
}

bool clang_LabelDecl_isGnuLocal(CXLabelDecl LD) {
  return reinterpret_cast<clang::LabelDecl *>(LD)->isGnuLocal();
}

void clang_LabelDecl_setLocStart(CXLabelDecl LD, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::LabelDecl *>(LD)->setLocStart(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

CXSourceRange_ clang_LabelDecl_getSourceRange(CXLabelDecl LD) {
  auto rng = reinterpret_cast<clang::LabelDecl *>(LD)->getSourceRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

bool clang_LabelDecl_isMSAsmLabel(CXLabelDecl LD) {
  return reinterpret_cast<clang::LabelDecl *>(LD)->isMSAsmLabel();
}

bool clang_LabelDecl_isResolvedMSAsmLabel(CXLabelDecl LD) {
  return reinterpret_cast<clang::LabelDecl *>(LD)->isResolvedMSAsmLabel();
}


void clang_LabelDecl_setMSAsmLabel(CXLabelDecl LD, const char *Name) {
  reinterpret_cast<clang::LabelDecl *>(LD)->setMSAsmLabel(llvm::StringRef(Name));
}

const char *clang_LabelDecl_getMSAsmLabel(CXLabelDecl LD) {
  return reinterpret_cast<clang::LabelDecl *>(LD)->getMSAsmLabel().data();
}

void clang_LabelDecl_setMSAsmLabelResolved(CXLabelDecl LD) {
  reinterpret_cast<clang::LabelDecl *>(LD)->setMSAsmLabelResolved();
}

bool clang_LabelDecl_classofKind(CXDeclKind K) {
  return clang::LabelDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// NamespaceDecl
bool clang_NamespaceDecl_isNested(CXNamespaceDecl ND) {
  return reinterpret_cast<clang::NamespaceDecl *>(ND)->isNested();
}

void clang_NamespaceDecl_setNested(CXNamespaceDecl ND, bool Nested) {
  reinterpret_cast<clang::NamespaceDecl *>(ND)->setNested(Nested);
}

bool clang_NamespaceDecl_isRedundantInlineQualifierFor(CXNamespaceDecl ND,
                                                       CXDeclarationName Name) {
  return reinterpret_cast<clang::NamespaceDecl *>(ND)->isRedundantInlineQualifierFor(
      clang::DeclarationName::getFromOpaquePtr(Name));
}

// CXNamespaceDecl clang_NamespaceDecl_Create(CXASTContext C, CXDeclContext DC, bool Inline,
//                                            CXSourceLocation_ StartLoc,
//                                            CXSourceLocation_ IdLoc, CXIdentifierInfo Id,
//                                            CXNamespaceDecl PrevDecl) {
//   return clang::NamespaceDecl::Create(*static_cast<clang::ASTContext *>(C),
//                                       static_cast<clang::DeclContext *>(DC), Inline,
//                                       clang::SourceLocation::getFromPtrEncoding(StartLoc),
//                                       clang::SourceLocation::getFromPtrEncoding(IdLoc),
//                                       static_cast<clang::IdentifierInfo *>(Id),
//                                       static_cast<clang::NamespaceDecl *>(PrevDecl));
// }

CXNamespaceDecl clang_NamespaceDecl_Create(CXASTContext C, CXDeclContext DC, bool Inline,
                                           CXSourceLocation_ StartLoc,
                                           CXSourceLocation_ IdLoc, CXIdentifierInfo Id,
                                           CXNamespaceDecl PrevDecl, bool Nested) {
  return reinterpret_cast<CXNamespaceDecl>(clang::NamespaceDecl::Create(
      *reinterpret_cast<clang::ASTContext *>(C), reinterpret_cast<clang::DeclContext *>(DC), Inline,
      clang::SourceLocation::getFromPtrEncoding(StartLoc),
      clang::SourceLocation::getFromPtrEncoding(IdLoc),
      reinterpret_cast<clang::IdentifierInfo *>(Id),
      reinterpret_cast<clang::NamespaceDecl *>(PrevDecl), Nested));
}

CXNamespaceDecl clang_NamespaceDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return reinterpret_cast<CXNamespaceDecl>(clang::NamespaceDecl::CreateDeserialized(*reinterpret_cast<clang::ASTContext *>(C), ID));
}

bool clang_NamespaceDecl_isAnonymousNamespace(CXNamespaceDecl ND) {
  return reinterpret_cast<clang::NamespaceDecl *>(ND)->isAnonymousNamespace();
}

bool clang_NamespaceDecl_isInline(CXNamespaceDecl ND) {
  return reinterpret_cast<clang::NamespaceDecl *>(ND)->isInline();
}

void clang_NamespaceDecl_setInline(CXNamespaceDecl ND, bool Inline) {
  return reinterpret_cast<clang::NamespaceDecl *>(ND)->setInline(Inline);
}

CXNamespaceDecl clang_NamespaceDecl_getOriginalNamespace(CXNamespaceDecl ND) {
  return reinterpret_cast<CXNamespaceDecl>(reinterpret_cast<clang::NamespaceDecl *>(ND)->getOriginalNamespace());
}

bool clang_NamespaceDecl_isOriginalNamespace(CXNamespaceDecl ND) {
  return reinterpret_cast<clang::NamespaceDecl *>(ND)->isOriginalNamespace();
}

CXNamespaceDecl clang_NamespaceDecl_getAnonymousNamespace(CXNamespaceDecl ND) {
  return reinterpret_cast<CXNamespaceDecl>(reinterpret_cast<clang::NamespaceDecl *>(ND)->getAnonymousNamespace());
}

void clang_NamespaceDecl_setAnonymousNamespace(CXNamespaceDecl ND, CXNamespaceDecl D) {
  reinterpret_cast<clang::NamespaceDecl *>(ND)->setAnonymousNamespace(
      reinterpret_cast<clang::NamespaceDecl *>(D));
}

CXNamespaceDecl clang_NamespaceDecl_getCanonicalDecl(CXNamespaceDecl ND) {
  return reinterpret_cast<CXNamespaceDecl>(reinterpret_cast<clang::NamespaceDecl *>(ND)->getCanonicalDecl());
}

CXSourceRange_ clang_NamespaceDecl_getSourceRange(CXNamespaceDecl ND) {
  auto rng = reinterpret_cast<clang::NamespaceDecl *>(ND)->getSourceRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

CXSourceLocation_ clang_NamespaceDecl_getBeginLoc(CXNamespaceDecl ND) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::NamespaceDecl *>(ND)->getBeginLoc().getPtrEncoding());
}

CXSourceLocation_ clang_NamespaceDecl_getRBraceLoc(CXNamespaceDecl ND) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::NamespaceDecl *>(ND)->getRBraceLoc().getPtrEncoding());
}

void clang_NamespaceDecl_setLocStart(CXNamespaceDecl ND, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::NamespaceDecl *>(ND)->setLocStart(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_NamespaceDecl_setRBraceLoc(CXNamespaceDecl ND, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::NamespaceDecl *>(ND)->setRBraceLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

bool clang_NamespaceDecl_classofKind(CXDeclKind K) {
  return clang::NamespaceDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// NamespaceDecl Cast
CXDeclContext clang_NamespaceDecl_castToDeclContext(CXNamespaceDecl ND) {
  return reinterpret_cast<CXDeclContext>(clang::NamespaceDecl::castToDeclContext(reinterpret_cast<clang::NamespaceDecl *>(ND)));
}

CXNamespaceDecl clang_NamespaceDecl_castFromDeclContext(CXDeclContext DC) {
  return reinterpret_cast<CXNamespaceDecl>(clang::NamespaceDecl::castFromDeclContext(reinterpret_cast<clang::DeclContext *>(DC)));
}

// ValueDecl
bool clang_ValueDecl_isInitCapture(CXValueDecl VD) {
  return reinterpret_cast<clang::ValueDecl *>(VD)->isInitCapture();
}

CXVarDecl clang_ValueDecl_getPotentiallyDecomposedVarDecl(CXValueDecl VD) {
  return reinterpret_cast<CXVarDecl>(reinterpret_cast<clang::ValueDecl *>(VD)->getPotentiallyDecomposedVarDecl());
}

bool clang_ValueDecl_classofKind(CXDeclKind K) {
  return clang::ValueDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

CXQualType clang_ValueDecl_getType(CXValueDecl VD) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::ValueDecl *>(VD)->getType().getAsOpaquePtr());
}

void clang_ValueDecl_setType(CXValueDecl VD, CXQualType OpaquePtr) {
  reinterpret_cast<clang::ValueDecl *>(VD)->setType(
      clang::QualType::getFromOpaquePtr(OpaquePtr));
}

bool clang_ValueDecl_isWeak(CXValueDecl VD) {
  return reinterpret_cast<clang::ValueDecl *>(VD)->isWeak();
}

// DeclaratorDecl
CXSourceRange_ clang_DeclaratorDecl_getSourceRange(CXDeclaratorDecl DD) {
  clang::SourceRange R = reinterpret_cast<clang::DeclaratorDecl *>(DD)->getSourceRange();
  return CXSourceRange_{reinterpret_cast<CXSourceLocation_>(R.getBegin().getPtrEncoding()), reinterpret_cast<CXSourceLocation_>(R.getEnd().getPtrEncoding())};
}

CXTypeSourceInfo clang_DeclaratorDecl_getTypeSourceInfo(CXDeclaratorDecl DD) {
  return reinterpret_cast<CXTypeSourceInfo>(reinterpret_cast<clang::DeclaratorDecl *>(DD)->getTypeSourceInfo());
}

void clang_DeclaratorDecl_setTypeSourceInfo(CXDeclaratorDecl DD, CXTypeSourceInfo TI) {
  reinterpret_cast<clang::DeclaratorDecl *>(DD)->setTypeSourceInfo(
      reinterpret_cast<clang::TypeSourceInfo *>(TI));
}

CXSourceLocation_ clang_DeclaratorDecl_getInnerLocStart(CXDeclaratorDecl DD) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::DeclaratorDecl *>(DD)->getInnerLocStart().getPtrEncoding());
}

void clang_DeclaratorDecl_setInnerLocStart(CXDeclaratorDecl DD, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::DeclaratorDecl *>(DD)->setInnerLocStart(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

CXSourceLocation_ clang_DeclaratorDecl_getOuterLocStart(CXDeclaratorDecl DD) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::DeclaratorDecl *>(DD)->getOuterLocStart().getPtrEncoding());
}

CXSourceLocation_ clang_DeclaratorDecl_getBeginLoc(CXDeclaratorDecl DD) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::DeclaratorDecl *>(DD)->getBeginLoc().getPtrEncoding());
}

CXNestedNameSpecifier clang_DeclaratorDecl_getQualifier(CXDeclaratorDecl DD) {
  return reinterpret_cast<CXNestedNameSpecifier>(reinterpret_cast<clang::DeclaratorDecl *>(DD)->getQualifier());
}

// getQualifierLoc
// setQualifierInfo

CXSourceRange_ clang_DeclaratorDecl_getQualifierRange(CXDeclaratorDecl DD) {
  auto Q = reinterpret_cast<clang::DeclaratorDecl *>(DD)->getQualifierLoc();
  clang::SourceRange R = Q.getSourceRange();
  return CXSourceRange_{reinterpret_cast<CXSourceLocation_>(R.getBegin().getPtrEncoding()), reinterpret_cast<CXSourceLocation_>(R.getEnd().getPtrEncoding())};
}

CXExpr clang_DeclaratorDecl_getTrailingRequiresClause(CXDeclaratorDecl DD) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::DeclaratorDecl *>(DD)->getTrailingRequiresClause());
}

void clang_DeclaratorDecl_setTrailingRequiresClause(CXDeclaratorDecl DD,
                                                    CXExpr TrailingRequiresClause) {
  return reinterpret_cast<clang::DeclaratorDecl *>(DD)->setTrailingRequiresClause(
      reinterpret_cast<clang::Expr *>(TrailingRequiresClause));
}

unsigned clang_DeclaratorDecl_getNumTemplateParameterLists(CXDeclaratorDecl DD) {
  return reinterpret_cast<clang::DeclaratorDecl *>(DD)->getNumTemplateParameterLists();
}

CXTemplateParameterList clang_DeclaratorDecl_getTemplateParameterList(CXDeclaratorDecl DD,
                                                                      unsigned index) {
  return reinterpret_cast<CXTemplateParameterList>(reinterpret_cast<clang::DeclaratorDecl *>(DD)->getTemplateParameterList(index));
}


void clang_DeclaratorDecl_setTemplateParameterListsInfo(CXDeclaratorDecl DD, CXASTContext C,
                                                        CXTemplateParameterList *TPLists,
                                                        unsigned NumTPLists) {
  llvm::SmallVector<clang::TemplateParameterList *, 4> Lists;
  Lists.reserve(NumTPLists);
  for (unsigned I = 0; I != NumTPLists; ++I)
    Lists.push_back(reinterpret_cast<clang::TemplateParameterList *>(TPLists[I]));
  reinterpret_cast<clang::DeclaratorDecl *>(DD)->setTemplateParameterListsInfo(
      *reinterpret_cast<clang::ASTContext *>(C), Lists);
}

CXSourceLocation_ clang_DeclaratorDecl_getTypeSpecStartLoc(CXDeclaratorDecl DD) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::DeclaratorDecl *>(DD)->getTypeSpecStartLoc().getPtrEncoding());
}

CXSourceLocation_ clang_DeclaratorDecl_getTypeSpecEndLoc(CXDeclaratorDecl DD) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::DeclaratorDecl *>(DD)->getTypeSpecEndLoc().getPtrEncoding());
}

bool clang_DeclaratorDecl_classofKind(CXDeclKind K) {
  return clang::DeclaratorDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// VarDecl
const char *clang_VarDecl_getStorageClassSpecifierString(CXStorageClass SC) {
  return clang::VarDecl::getStorageClassSpecifierString(
      static_cast<clang::StorageClass>(SC));
}

CXVarDecl clang_VarDecl_Create(CXASTContext C, CXDeclContext DC, CXSourceLocation_ StartLoc,
                               CXSourceLocation_ IdLoc, CXIdentifierInfo Id, CXQualType T,
                               CXTypeSourceInfo TInfo, CXStorageClass S) {
  return reinterpret_cast<CXVarDecl>(clang::VarDecl::Create(
      *reinterpret_cast<clang::ASTContext *>(C), reinterpret_cast<clang::DeclContext *>(DC),
      clang::SourceLocation::getFromPtrEncoding(StartLoc),
      clang::SourceLocation::getFromPtrEncoding(IdLoc),
      reinterpret_cast<clang::IdentifierInfo *>(Id), clang::QualType::getFromOpaquePtr(T),
      reinterpret_cast<clang::TypeSourceInfo *>(TInfo), static_cast<clang::StorageClass>(S)));
}

CXVarDecl clang_VarDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return reinterpret_cast<CXVarDecl>(clang::VarDecl::CreateDeserialized(*reinterpret_cast<clang::ASTContext *>(C), ID));
}

CXSourceRange_ clang_VarDecl_getSourceRange(CXVarDecl VD) {
  auto rng = reinterpret_cast<clang::VarDecl *>(VD)->getSourceRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

CXStorageClass clang_VarDecl_getStorageClass(CXVarDecl VD) {
  return static_cast<CXStorageClass>(reinterpret_cast<clang::VarDecl *>(VD)->getStorageClass());
}

void clang_VarDecl_setStorageClass(CXVarDecl VD, CXStorageClass SC) {
  reinterpret_cast<clang::VarDecl *>(VD)->setStorageClass(static_cast<clang::StorageClass>(SC));
}

void clang_VarDecl_setTSCSpec(CXVarDecl VD, CXThreadStorageClassSpecifier TSC) {
  reinterpret_cast<clang::VarDecl *>(VD)->setTSCSpec(
      static_cast<clang::ThreadStorageClassSpecifier>(TSC));
}

CXThreadStorageClassSpecifier clang_VarDecl_getTSCSpec(CXVarDecl VD) {
  return static_cast<CXThreadStorageClassSpecifier>(
      reinterpret_cast<clang::VarDecl *>(VD)->getTSCSpec());
}


CXVarDecl_TLSKind clang_VarDecl_getTLSKind(CXVarDecl VD) {
  return static_cast<CXVarDecl_TLSKind>(reinterpret_cast<clang::VarDecl *>(VD)->getTLSKind());
}

bool clang_VarDecl_hasLocalStorage(CXVarDecl VD) {
  return reinterpret_cast<clang::VarDecl *>(VD)->hasLocalStorage();
}

bool clang_VarDecl_isStaticLocal(CXVarDecl VD) {
  return reinterpret_cast<clang::VarDecl *>(VD)->isStaticLocal();
}

bool clang_VarDecl_hasExternalStorage(CXVarDecl VD) {
  return reinterpret_cast<clang::VarDecl *>(VD)->hasExternalStorage();
}

bool clang_VarDecl_hasGlobalStorage(CXVarDecl VD) {
  return reinterpret_cast<clang::VarDecl *>(VD)->hasGlobalStorage();
}

CXStorageDuration clang_VarDecl_getStorageDuration(CXVarDecl VD) {
  return static_cast<CXStorageDuration>(
      reinterpret_cast<clang::VarDecl *>(VD)->getStorageDuration());
}

CXLanguageLinkage clang_VarDecl_getLanguageLinkage(CXVarDecl VD) {
  return static_cast<CXLanguageLinkage>(
      reinterpret_cast<clang::VarDecl *>(VD)->getLanguageLinkage());
}

bool clang_VarDecl_isExternC(CXVarDecl VD) {
  return reinterpret_cast<clang::VarDecl *>(VD)->isExternC();
}

bool clang_VarDecl_isInExternCContext(CXVarDecl VD) {
  return reinterpret_cast<clang::VarDecl *>(VD)->isInExternCContext();
}

bool clang_VarDecl_isInExternCXXContext(CXVarDecl VD) {
  return reinterpret_cast<clang::VarDecl *>(VD)->isInExternCXXContext();
}

bool clang_VarDecl_isLocalVarDecl(CXVarDecl VD) {
  return reinterpret_cast<clang::VarDecl *>(VD)->isLocalVarDecl();
}

bool clang_VarDecl_isLocalVarDeclOrParm(CXVarDecl VD) {
  return reinterpret_cast<clang::VarDecl *>(VD)->isLocalVarDeclOrParm();
}

bool clang_VarDecl_isFunctionOrMethodVarDecl(CXVarDecl VD) {
  return reinterpret_cast<clang::VarDecl *>(VD)->isFunctionOrMethodVarDecl();
}

bool clang_VarDecl_isStaticDataMember(CXVarDecl VD) {
  return reinterpret_cast<clang::VarDecl *>(VD)->isStaticDataMember();
}

CXVarDecl clang_VarDecl_getCanonicalDecl(CXVarDecl VD) {
  return reinterpret_cast<CXVarDecl>(reinterpret_cast<clang::VarDecl *>(VD)->getCanonicalDecl());
}

// isThisDeclarationADefinition
// hasDefinition

CXVarDecl_DefinitionKind clang_VarDecl_isThisDeclarationADefinition(CXVarDecl VD,
                                                                    CXASTContext C) {
  return static_cast<CXVarDecl_DefinitionKind>(
      reinterpret_cast<clang::VarDecl *>(VD)->isThisDeclarationADefinition(
          *reinterpret_cast<clang::ASTContext *>(C)));
}

CXVarDecl_DefinitionKind clang_VarDecl_hasDefinition(CXVarDecl VD, CXASTContext C) {
  return static_cast<CXVarDecl_DefinitionKind>(
      reinterpret_cast<clang::VarDecl *>(VD)->hasDefinition(
          *reinterpret_cast<clang::ASTContext *>(C)));
}

CXVarDecl clang_VarDecl_getActingDefinition(CXVarDecl VD) {
  return reinterpret_cast<CXVarDecl>(reinterpret_cast<clang::VarDecl *>(VD)->getActingDefinition());
}

CXVarDecl clang_VarDecl_getDefinition(CXVarDecl VD) {
  return reinterpret_cast<CXVarDecl>(reinterpret_cast<clang::VarDecl *>(VD)->getDefinition());
}

bool clang_VarDecl_isOutOfLine(CXVarDecl VD) {
  return reinterpret_cast<clang::VarDecl *>(VD)->isOutOfLine();
}

bool clang_VarDecl_isFileVarDecl(CXVarDecl VD) {
  return reinterpret_cast<clang::VarDecl *>(VD)->isFileVarDecl();
}

CXExpr clang_VarDecl_getAnyInitializer(CXVarDecl VD) {
  return reinterpret_cast<CXExpr>(const_cast<clang::Expr *>(reinterpret_cast<clang::VarDecl *>(VD)->getAnyInitializer()));
}

bool clang_VarDecl_hasInit(CXVarDecl VD) {
  return reinterpret_cast<clang::VarDecl *>(VD)->hasInit();
}

CXExpr clang_VarDecl_getInit(CXVarDecl VD) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::VarDecl *>(VD)->getInit());
}

// getInitAddress

void clang_VarDecl_setInit(CXVarDecl VD, CXExpr I) {
  reinterpret_cast<clang::VarDecl *>(VD)->setInit(reinterpret_cast<clang::Expr *>(I));
}

CXVarDecl clang_VarDecl_getInitializingDeclaration(CXVarDecl VD) {
  return reinterpret_cast<CXVarDecl>(reinterpret_cast<clang::VarDecl *>(VD)->getInitializingDeclaration());
}

bool clang_VarDecl_mightBeUsableInConstantExpressions(CXVarDecl VD, CXASTContext C) {
  return reinterpret_cast<clang::VarDecl *>(VD)->mightBeUsableInConstantExpressions(
      *reinterpret_cast<clang::ASTContext *>(C));
}

bool clang_VarDecl_isUsableInConstantExpressions(CXVarDecl VD, CXASTContext C) {
  return reinterpret_cast<clang::VarDecl *>(VD)->isUsableInConstantExpressions(
      *reinterpret_cast<clang::ASTContext *>(C));
}

CXEvaluatedStmt clang_VarDecl_ensureEvaluatedStmt(CXVarDecl VD) {
  return reinterpret_cast<CXEvaluatedStmt>(reinterpret_cast<clang::VarDecl *>(VD)->ensureEvaluatedStmt());
}

CXEvaluatedStmt clang_VarDecl_getEvaluatedStmt(CXVarDecl VD) {
  return reinterpret_cast<CXEvaluatedStmt>(reinterpret_cast<clang::VarDecl *>(VD)->getEvaluatedStmt());
}

CXAPValue clang_VarDecl_evaluateValue(CXVarDecl VD) {
  return reinterpret_cast<CXAPValue>(reinterpret_cast<clang::VarDecl *>(VD)->evaluateValue());
}


CXAPValue clang_VarDecl_getEvaluatedValue(CXVarDecl VD) {
  return reinterpret_cast<CXAPValue>(reinterpret_cast<clang::VarDecl *>(VD)->getEvaluatedValue());
}


bool clang_VarDecl_evaluateDestruction(CXVarDecl VD) {
  llvm::SmallVector<clang::PartialDiagnosticAt, 8> Notes;
  return reinterpret_cast<clang::VarDecl *>(VD)->evaluateDestruction(Notes);
}

bool clang_VarDecl_hasConstantInitialization(CXVarDecl VD) {
  return reinterpret_cast<clang::VarDecl *>(VD)->hasConstantInitialization();
}

bool clang_VarDecl_hasICEInitializer(CXVarDecl VD, CXASTContext Context) {
  return reinterpret_cast<clang::VarDecl *>(VD)->hasICEInitializer(
      *reinterpret_cast<clang::ASTContext *>(Context));
}


bool clang_VarDecl_checkForConstantInitialization(CXVarDecl VD) {
  llvm::SmallVector<clang::PartialDiagnosticAt, 8> Notes;
  return reinterpret_cast<clang::VarDecl *>(VD)->checkForConstantInitialization(Notes);
}

// setInitStyle
// getInitStyle

void clang_VarDecl_setInitStyle(CXVarDecl VD, CXVarDecl_InitializationStyle Style) {
  reinterpret_cast<clang::VarDecl *>(VD)->setInitStyle(
      static_cast<clang::VarDecl::InitializationStyle>(Style));
}

CXVarDecl_InitializationStyle clang_VarDecl_getInitStyle(CXVarDecl VD) {
  return static_cast<CXVarDecl_InitializationStyle>(
      reinterpret_cast<clang::VarDecl *>(VD)->getInitStyle());
}

bool clang_VarDecl_isDirectInit(CXVarDecl VD) {
  return reinterpret_cast<clang::VarDecl *>(VD)->isDirectInit();
}

bool clang_VarDecl_isThisDeclarationADemotedDefinition(CXVarDecl VD) {
  return reinterpret_cast<clang::VarDecl *>(VD)->isThisDeclarationADemotedDefinition();
}

void clang_VarDecl_demoteThisDefinitionToDeclaration(CXVarDecl VD) {
  reinterpret_cast<clang::VarDecl *>(VD)->demoteThisDefinitionToDeclaration();
}

bool clang_VarDecl_isExceptionVariable(CXVarDecl VD) {
  return reinterpret_cast<clang::VarDecl *>(VD)->isExceptionVariable();
}

void clang_VarDecl_setExceptionVariable(CXVarDecl VD, bool EV) {
  reinterpret_cast<clang::VarDecl *>(VD)->setExceptionVariable(EV);
}

bool clang_VarDecl_isNRVOVariable(CXVarDecl VD) {
  return reinterpret_cast<clang::VarDecl *>(VD)->isNRVOVariable();
}

void clang_VarDecl_setNRVOVariable(CXVarDecl VD, bool NRVO) {
  reinterpret_cast<clang::VarDecl *>(VD)->setNRVOVariable(NRVO);
}

bool clang_VarDecl_isCXXForRangeDecl(CXVarDecl VD) {
  return reinterpret_cast<clang::VarDecl *>(VD)->isCXXForRangeDecl();
}

void clang_VarDecl_setCXXForRangeDecl(CXVarDecl VD, bool FRD) {
  reinterpret_cast<clang::VarDecl *>(VD)->setCXXForRangeDecl(FRD);
}

bool clang_VarDecl_isObjCForDecl(CXVarDecl VD) {
  return reinterpret_cast<clang::VarDecl *>(VD)->isObjCForDecl();
}

void clang_VarDecl_setObjCForDecl(CXVarDecl VD, bool FRD) {
  reinterpret_cast<clang::VarDecl *>(VD)->setObjCForDecl(FRD);
}

bool clang_VarDecl_isARCPseudoStrong(CXVarDecl VD) {
  return reinterpret_cast<clang::VarDecl *>(VD)->isARCPseudoStrong();
}

void clang_VarDecl_setARCPseudoStrong(CXVarDecl VD, bool PS) {
  reinterpret_cast<clang::VarDecl *>(VD)->setARCPseudoStrong(PS);
}

bool clang_VarDecl_isInline(CXVarDecl VD) {
  return reinterpret_cast<clang::VarDecl *>(VD)->isInline();
}

bool clang_VarDecl_isInlineSpecified(CXVarDecl VD) {
  return reinterpret_cast<clang::VarDecl *>(VD)->isInlineSpecified();
}

void clang_VarDecl_setInlineSpecified(CXVarDecl VD) {
  reinterpret_cast<clang::VarDecl *>(VD)->setInlineSpecified();
}

void clang_VarDecl_setImplicitlyInline(CXVarDecl VD) {
  reinterpret_cast<clang::VarDecl *>(VD)->setImplicitlyInline();
}

bool clang_VarDecl_isConstexpr(CXVarDecl VD) {
  return reinterpret_cast<clang::VarDecl *>(VD)->isConstexpr();
}

void clang_VarDecl_setConstexpr(CXVarDecl VD, bool IC) {
  reinterpret_cast<clang::VarDecl *>(VD)->setConstexpr(IC);
}

bool clang_VarDecl_isInitCapture(CXVarDecl VD) {
  return reinterpret_cast<clang::VarDecl *>(VD)->isInitCapture();
}

void clang_VarDecl_setInitCapture(CXVarDecl VD, bool IC) {
  reinterpret_cast<clang::VarDecl *>(VD)->setInitCapture(IC);
}

bool clang_VarDecl_isParameterPack(CXVarDecl VD) {
  return reinterpret_cast<clang::VarDecl *>(VD)->isParameterPack();
}

bool clang_VarDecl_isPreviousDeclInSameBlockScope(CXVarDecl VD) {
  return reinterpret_cast<clang::VarDecl *>(VD)->isPreviousDeclInSameBlockScope();
}

void clang_VarDecl_setPreviousDeclInSameBlockScope(CXVarDecl VD, bool Same) {
  reinterpret_cast<clang::VarDecl *>(VD)->setPreviousDeclInSameBlockScope(Same);
}

bool clang_VarDecl_isEscapingByref(CXVarDecl VD) {
  return reinterpret_cast<clang::VarDecl *>(VD)->isEscapingByref();
}

bool clang_VarDecl_isNonEscapingByref(CXVarDecl VD) {
  return reinterpret_cast<clang::VarDecl *>(VD)->isNonEscapingByref();
}

void clang_VarDecl_setEscapingByref(CXVarDecl VD) {
  reinterpret_cast<clang::VarDecl *>(VD)->setEscapingByref();
}

CXVarDecl clang_VarDecl_getTemplateInstantiationPattern(CXVarDecl VD) {
  return reinterpret_cast<CXVarDecl>(reinterpret_cast<clang::VarDecl *>(VD)->getTemplateInstantiationPattern());
}

CXVarDecl clang_VarDecl_getInstantiatedFromStaticDataMember(CXVarDecl VD) {
  return reinterpret_cast<CXVarDecl>(reinterpret_cast<clang::VarDecl *>(VD)->getInstantiatedFromStaticDataMember());
}

CXTemplateSpecializationKind clang_VarDecl_getTemplateSpecializationKind(CXVarDecl VD) {
  return static_cast<CXTemplateSpecializationKind>(
      reinterpret_cast<clang::VarDecl *>(VD)->getTemplateSpecializationKind());
}

CXTemplateSpecializationKind
clang_VarDecl_getTemplateSpecializationKindForInstantiation(CXVarDecl VD) {
  return static_cast<CXTemplateSpecializationKind>(
      reinterpret_cast<clang::VarDecl *>(VD)->getTemplateSpecializationKindForInstantiation());
}

CXSourceLocation_ clang_VarDecl_getPointOfInstantiation(CXVarDecl VD) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::VarDecl *>(VD)->getPointOfInstantiation().getPtrEncoding());
}

// getMemberSpecializationInfo

bool clang_VarDecl_hasDependentAlignment(CXVarDecl VD) {
  return reinterpret_cast<clang::VarDecl *>(VD)->hasDependentAlignment();
}

CXMemberSpecializationInfo clang_VarDecl_getMemberSpecializationInfo(CXVarDecl VD) {
  return reinterpret_cast<CXMemberSpecializationInfo>(reinterpret_cast<clang::VarDecl *>(VD)->getMemberSpecializationInfo());
}

void clang_VarDecl_setTemplateSpecializationKind(CXVarDecl VD,
                                                 CXTemplateSpecializationKind TSK,
                                                 CXSourceLocation_ PointOfInstantiation) {
  reinterpret_cast<clang::VarDecl *>(VD)->setTemplateSpecializationKind(
      static_cast<clang::TemplateSpecializationKind>(TSK),
      clang::SourceLocation::getFromPtrEncoding(PointOfInstantiation));
}

void clang_VarDecl_setInstantiationOfStaticDataMember(CXVarDecl VD, CXVarDecl VD2,
                                                      CXTemplateSpecializationKind TSK) {
  reinterpret_cast<clang::VarDecl *>(VD)->setInstantiationOfStaticDataMember(
      reinterpret_cast<clang::VarDecl *>(VD2),
      static_cast<clang::TemplateSpecializationKind>(TSK));
}

CXVarTemplateDecl clang_VarDecl_getDescribedVarTemplate(CXVarDecl VD) {
  return reinterpret_cast<CXVarTemplateDecl>(reinterpret_cast<clang::VarDecl *>(VD)->getDescribedVarTemplate());
}

void clang_VarDecl_setDescribedVarTemplate(CXVarDecl VD, CXVarTemplateDecl Template) {
  reinterpret_cast<clang::VarDecl *>(VD)->setDescribedVarTemplate(
      reinterpret_cast<clang::VarTemplateDecl *>(Template));
}

bool clang_VarDecl_isKnownToBeDefined(CXVarDecl VD) {
  return reinterpret_cast<clang::VarDecl *>(VD)->isKnownToBeDefined();
}

bool clang_VarDecl_isNoDestroy(CXVarDecl VD, CXASTContext AST) {
  return reinterpret_cast<clang::VarDecl *>(VD)->isNoDestroy(
      *reinterpret_cast<clang::ASTContext *>(AST));
}


CXDestructionKind clang_VarDecl_needsDestruction(CXVarDecl VD, CXASTContext Ctx) {
  return static_cast<CXDestructionKind>(
      reinterpret_cast<clang::VarDecl *>(VD)->needsDestruction(
          *reinterpret_cast<clang::ASTContext *>(Ctx)));
}

bool clang_VarDecl_hasFlexibleArrayInit(CXVarDecl VD, CXASTContext Ctx) {
  return reinterpret_cast<clang::VarDecl *>(VD)->hasFlexibleArrayInit(
      *reinterpret_cast<clang::ASTContext *>(Ctx));
}

int64_t clang_VarDecl_getFlexibleArrayInitChars(CXVarDecl VD, CXASTContext Ctx) {
  return reinterpret_cast<clang::VarDecl *>(VD)
      ->getFlexibleArrayInitChars(*reinterpret_cast<clang::ASTContext *>(Ctx))
      .getQuantity();
}

bool clang_VarDecl_classofKind(CXDeclKind K) {
  return clang::VarDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// ImplicitParamDecl
CXImplicitParamDecl clang_ImplicitParamDecl_Create(CXASTContext C, CXDeclContext DC,
                                                   CXSourceLocation_ IdLoc,
                                                   CXIdentifierInfo Id, CXQualType T,
                                                   CXImplicitParamKind ParamKind) {
  return reinterpret_cast<CXImplicitParamDecl>(clang::ImplicitParamDecl::Create(
      *reinterpret_cast<clang::ASTContext *>(C), reinterpret_cast<clang::DeclContext *>(DC),
      clang::SourceLocation::getFromPtrEncoding(IdLoc),
      reinterpret_cast<clang::IdentifierInfo *>(Id), clang::QualType::getFromOpaquePtr(T),
      static_cast<clang::ImplicitParamKind>(ParamKind)));
}

CXImplicitParamDecl clang_ImplicitParamDecl_CreateDeserialized(CXASTContext C,
                                                               unsigned ID) {
  return reinterpret_cast<CXImplicitParamDecl>(clang::ImplicitParamDecl::CreateDeserialized(*reinterpret_cast<clang::ASTContext *>(C),
                                                      ID));
}

CXImplicitParamKind clang_ImplicitParamDecl_getParameterKind(CXImplicitParamDecl IPD) {
  return static_cast<CXImplicitParamKind>(
      reinterpret_cast<clang::ImplicitParamDecl *>(IPD)->getParameterKind());
}

bool clang_ImplicitParamDecl_classofKind(CXDeclKind K) {
  return clang::ImplicitParamDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// ParmVarDecl
CXSourceRange_ clang_ParmVarDecl_getSourceRange(CXParmVarDecl PVD) {
  clang::SourceRange R = reinterpret_cast<clang::ParmVarDecl *>(PVD)->getSourceRange();
  return CXSourceRange_{reinterpret_cast<CXSourceLocation_>(R.getBegin().getPtrEncoding()), reinterpret_cast<CXSourceLocation_>(R.getEnd().getPtrEncoding())};
}

CXParmVarDecl clang_ParmVarDecl_Create(CXASTContext C, CXDeclContext DC,
                                       CXSourceLocation_ StartLoc, CXSourceLocation_ IdLoc,
                                       CXIdentifierInfo Id, CXQualType T,
                                       CXTypeSourceInfo TInfo, CXStorageClass S,
                                       CXExpr DefArg) {
  return reinterpret_cast<CXParmVarDecl>(clang::ParmVarDecl::Create(
      *reinterpret_cast<clang::ASTContext *>(C), reinterpret_cast<clang::DeclContext *>(DC),
      clang::SourceLocation::getFromPtrEncoding(StartLoc),
      clang::SourceLocation::getFromPtrEncoding(IdLoc),
      reinterpret_cast<clang::IdentifierInfo *>(Id), clang::QualType::getFromOpaquePtr(T),
      reinterpret_cast<clang::TypeSourceInfo *>(TInfo), static_cast<clang::StorageClass>(S),
      reinterpret_cast<clang::Expr *>(DefArg)));
}

CXParmVarDecl clang_ParmVarDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return reinterpret_cast<CXParmVarDecl>(clang::ParmVarDecl::CreateDeserialized(*reinterpret_cast<clang::ASTContext *>(C), ID));
}

void clang_ParmVarDecl_setObjCMethodScopeInfo(CXParmVarDecl PVD, unsigned parameterIndex) {
  reinterpret_cast<clang::ParmVarDecl *>(PVD)->setObjCMethodScopeInfo(parameterIndex);
}

void clang_ParmVarDecl_setScopeInfo(CXParmVarDecl PVD, unsigned scopeDepth,
                                    unsigned parameterIndex) {
  reinterpret_cast<clang::ParmVarDecl *>(PVD)->setScopeInfo(scopeDepth, parameterIndex);
}

bool clang_ParmVarDecl_isObjCMethodParameter(CXParmVarDecl PVD) {
  return reinterpret_cast<clang::ParmVarDecl *>(PVD)->isObjCMethodParameter();
}

bool clang_ParmVarDecl_isDestroyedInCallee(CXParmVarDecl PVD) {
  return reinterpret_cast<clang::ParmVarDecl *>(PVD)->isDestroyedInCallee();
}

unsigned clang_ParmVarDecl_getFunctionScopeDepth(CXParmVarDecl PVD) {
  return reinterpret_cast<clang::ParmVarDecl *>(PVD)->getFunctionScopeDepth();
}

unsigned clang_ParmVarDecl_getFunctionScopeIndex(CXParmVarDecl PVD) {
  return reinterpret_cast<clang::ParmVarDecl *>(PVD)->getFunctionScopeIndex();
}


CXObjCDeclQualifier clang_ParmVarDecl_getObjCDeclQualifier(CXParmVarDecl PVD) {
  return static_cast<CXObjCDeclQualifier>(
      reinterpret_cast<clang::ParmVarDecl *>(PVD)->getObjCDeclQualifier());
}

void clang_ParmVarDecl_setObjCDeclQualifier(CXParmVarDecl PVD, CXObjCDeclQualifier QTVal) {
  reinterpret_cast<clang::ParmVarDecl *>(PVD)->setObjCDeclQualifier(
      static_cast<clang::Decl::ObjCDeclQualifier>(QTVal));
}

unsigned clang_ParmVarDecl_getMaxFunctionScopeDepth(void) {
  return clang::ParmVarDecl::getMaxFunctionScopeDepth();
}

bool clang_ParmVarDecl_isExplicitObjectParameter(CXParmVarDecl PVD) {
  return reinterpret_cast<clang::ParmVarDecl *>(PVD)->isExplicitObjectParameter();
}

void clang_ParmVarDecl_setExplicitObjectParameterLoc(CXParmVarDecl PVD,
                                                     CXSourceLocation_ Loc) {
  reinterpret_cast<clang::ParmVarDecl *>(PVD)->setExplicitObjectParameterLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

CXSourceLocation_ clang_ParmVarDecl_getExplicitObjectParamThisLoc(CXParmVarDecl PVD) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::ParmVarDecl *>(PVD)
      ->getExplicitObjectParamThisLoc()
      .getPtrEncoding());
}

bool clang_ParmVarDecl_isKNRPromoted(CXParmVarDecl PVD) {
  return reinterpret_cast<clang::ParmVarDecl *>(PVD)->isKNRPromoted();
}

void clang_ParmVarDecl_setKNRPromoted(CXParmVarDecl PVD, bool promoted) {
  reinterpret_cast<clang::ParmVarDecl *>(PVD)->setKNRPromoted(promoted);
}

CXExpr clang_ParmVarDecl_getDefaultArg(CXParmVarDecl PVD) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::ParmVarDecl *>(PVD)->getDefaultArg());
}

void clang_ParmVarDecl_setDefaultArg(CXParmVarDecl PVD, CXExpr defarg) {
  reinterpret_cast<clang::ParmVarDecl *>(PVD)->setDefaultArg(reinterpret_cast<clang::Expr *>(defarg));
}

CXSourceRange_ clang_ParmVarDecl_getDefaultArgRange(CXParmVarDecl PVD) {
  auto rng = reinterpret_cast<clang::ParmVarDecl *>(PVD)->getDefaultArgRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

void clang_ParmVarDecl_setUninstantiatedDefaultArg(CXParmVarDecl PVD, CXExpr arg) {
  reinterpret_cast<clang::ParmVarDecl *>(PVD)->setUninstantiatedDefaultArg(
      reinterpret_cast<clang::Expr *>(arg));
}

CXExpr clang_ParmVarDecl_getUninstantiatedDefaultArg(CXParmVarDecl PVD) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::ParmVarDecl *>(PVD)->getUninstantiatedDefaultArg());
}

bool clang_ParmVarDecl_hasDefaultArg(CXParmVarDecl PVD) {
  return reinterpret_cast<clang::ParmVarDecl *>(PVD)->hasDefaultArg();
}

bool clang_ParmVarDecl_hasUnparsedDefaultArg(CXParmVarDecl PVD) {
  return reinterpret_cast<clang::ParmVarDecl *>(PVD)->hasUnparsedDefaultArg();
}

bool clang_ParmVarDecl_hasUninstantiatedDefaultArg(CXParmVarDecl PVD) {
  return reinterpret_cast<clang::ParmVarDecl *>(PVD)->hasUninstantiatedDefaultArg();
}

void clang_ParmVarDecl_setUnparsedDefaultArg(CXParmVarDecl PVD) {
  reinterpret_cast<clang::ParmVarDecl *>(PVD)->setUnparsedDefaultArg();
}

bool clang_ParmVarDecl_hasInheritedDefaultArg(CXParmVarDecl PVD) {
  return reinterpret_cast<clang::ParmVarDecl *>(PVD)->hasInheritedDefaultArg();
}

void clang_ParmVarDecl_setHasInheritedDefaultArg(CXParmVarDecl PVD, bool I) {
  reinterpret_cast<clang::ParmVarDecl *>(PVD)->setHasInheritedDefaultArg(I);
}

CXQualType clang_ParmVarDecl_getOriginalType(CXParmVarDecl PVD) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::ParmVarDecl *>(PVD)->getOriginalType().getAsOpaquePtr());
}

void clang_ParmVarDecl_setOwningFunction(CXParmVarDecl PVD, CXDeclContext FD) {
  reinterpret_cast<clang::ParmVarDecl *>(PVD)->setOwningFunction(
      reinterpret_cast<clang::DeclContext *>(FD));
}

bool clang_ParmVarDecl_classofKind(CXDeclKind K) {
  return clang::ParmVarDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// FunctionDecl
CXFunctionDecl clang_FunctionDecl_Create(CXASTContext C, CXDeclContext DC,
                                         CXSourceLocation_ StartLoc, CXSourceLocation_ NLoc,
                                         CXDeclarationName N, CXQualType T,
                                         CXTypeSourceInfo TInfo, CXStorageClass SC,
                                         bool isInlineSpecified, bool hasWrittenPrototype) {
  return reinterpret_cast<CXFunctionDecl>(clang::FunctionDecl::Create(
      *reinterpret_cast<clang::ASTContext *>(C), reinterpret_cast<clang::DeclContext *>(DC),
      clang::SourceLocation::getFromPtrEncoding(StartLoc),
      clang::SourceLocation::getFromPtrEncoding(NLoc),
      clang::DeclarationName::getFromOpaquePtr(N), clang::QualType::getFromOpaquePtr(T),
      reinterpret_cast<clang::TypeSourceInfo *>(TInfo), static_cast<clang::StorageClass>(SC),
      /*UsesFPIntrin=*/false, isInlineSpecified, hasWrittenPrototype));
}

CXFunctionDecl clang_FunctionDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return reinterpret_cast<CXFunctionDecl>(clang::FunctionDecl::CreateDeserialized(*reinterpret_cast<clang::ASTContext *>(C), ID));
}

CXDeclarationNameInfo clang_FunctionDecl_getNameInfo(CXFunctionDecl FD) {
  return reinterpret_cast<CXDeclarationNameInfo>(std::make_unique<clang::DeclarationNameInfo>(
             reinterpret_cast<clang::FunctionDecl *>(FD)->getNameInfo())
      .release());
}

// getNameInfo
// getNameForDiagnostic

// helper: isReplaceableGlobalAllocationFunction with its out-params exposed.
bool clang_FunctionDecl_getReplaceableGlobalAllocationFunctionInfo(
    CXFunctionDecl FD, bool *HasAlignmentParam, unsigned *AlignmentParam, bool *IsNothrow) {
  std::optional<unsigned> Alignment;
  bool Nothrow = false;
  bool Replaceable = reinterpret_cast<clang::FunctionDecl *>(FD)
                         ->isReplaceableGlobalAllocationFunction(&Alignment, &Nothrow);
  *HasAlignmentParam = Alignment.has_value();
  *AlignmentParam = Alignment.value_or(0);
  *IsNothrow = Nothrow;
  return Replaceable;
}

CXSourceLocation_ clang_FunctionDecl_getDefaultLoc(CXFunctionDecl FD) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::FunctionDecl *>(FD)->getDefaultLoc().getPtrEncoding());
}

void clang_FunctionDecl_setDefaultLoc(CXFunctionDecl FD, CXSourceLocation_ NewLoc) {
  reinterpret_cast<clang::FunctionDecl *>(FD)->setDefaultLoc(
      clang::SourceLocation::getFromPtrEncoding(NewLoc));
}

bool clang_FunctionDecl_isIneligibleOrNotSelected(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isIneligibleOrNotSelected();
}

void clang_FunctionDecl_setIneligibleOrNotSelected(CXFunctionDecl FD, bool II) {
  reinterpret_cast<clang::FunctionDecl *>(FD)->setIneligibleOrNotSelected(II);
}

void clang_FunctionDecl_setBodyContainsImmediateEscalatingExpressions(CXFunctionDecl FD,
                                                                      bool Set) {
  reinterpret_cast<clang::FunctionDecl *>(FD)
      ->setBodyContainsImmediateEscalatingExpressions(Set);
}

bool clang_FunctionDecl_BodyContainsImmediateEscalatingExpressions(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)
      ->BodyContainsImmediateEscalatingExpressions();
}

bool clang_FunctionDecl_isImmediateEscalating(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isImmediateEscalating();
}

bool clang_FunctionDecl_isImmediateFunction(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isImmediateFunction();
}

void clang_FunctionDecl_setFriendConstraintRefersToEnclosingTemplate(CXFunctionDecl FD,
                                                                     bool V) {
  reinterpret_cast<clang::FunctionDecl *>(FD)->setFriendConstraintRefersToEnclosingTemplate(V);
}

bool clang_FunctionDecl_FriendConstraintRefersToEnclosingTemplate(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)
      ->FriendConstraintRefersToEnclosingTemplate();
}

bool clang_FunctionDecl_isMemberLikeConstrainedFriend(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isMemberLikeConstrainedFriend();
}

bool clang_FunctionDecl_isTargetClonesMultiVersion(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isTargetClonesMultiVersion();
}

bool clang_FunctionDecl_UsesFPIntrin(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->UsesFPIntrin();
}

void clang_FunctionDecl_setUsesFPIntrin(CXFunctionDecl FD, bool I) {
  reinterpret_cast<clang::FunctionDecl *>(FD)->setUsesFPIntrin(I);
}

void clang_FunctionDecl_setRangeEnd(CXFunctionDecl FD, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::FunctionDecl *>(FD)->setRangeEnd(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

CXSourceLocation_ clang_FunctionDecl_getEllipsisLoc(CXFunctionDecl FD) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::FunctionDecl *>(FD)->getEllipsisLoc().getPtrEncoding());
}

CXSourceRange_ clang_FunctionDecl_getSourceRange(CXFunctionDecl FD) {
  auto rng = reinterpret_cast<clang::FunctionDecl *>(FD)->getSourceRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

// bool clang_FunctionDecl_hasBody(CXFunctionDecl FD, CXFunctionDecl Definition) {
//   return static_cast<clang::FunctionDecl *>(FD)->hasBody(
//       static_cast<clang::FunctionDecl *>(Definition));
// }

bool clang_FunctionDecl_hasBody(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->hasBody();
}

bool clang_FunctionDecl_hasTrivialBody(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->hasTrivialBody();
}

bool clang_FunctionDecl_isDefined(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isDefined();
}

CXFunctionDecl clang_FunctionDecl_getDefinition(CXFunctionDecl FD) {
  return reinterpret_cast<CXFunctionDecl>(reinterpret_cast<clang::FunctionDecl *>(FD)->getDefinition());
}

CXStmt clang_FunctionDecl_getBody(CXFunctionDecl FD) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::FunctionDecl *>(FD)->getBody());
}

bool clang_FunctionDecl_isThisDeclarationADefinition(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isThisDeclarationADefinition();
}

bool clang_FunctionDecl_isThisDeclarationInstantiatedFromAFriendDefinition(
    CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)
      ->isThisDeclarationInstantiatedFromAFriendDefinition();
}

bool clang_FunctionDecl_doesThisDeclarationHaveABody(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->doesThisDeclarationHaveABody();
}

void clang_FunctionDecl_setBody(CXFunctionDecl FD, CXStmt B) {
  reinterpret_cast<clang::FunctionDecl *>(FD)->setBody(reinterpret_cast<clang::Stmt *>(B));
}

void clang_FunctionDecl_setLazyBody(CXFunctionDecl FD, uint64_t Offset) {
  reinterpret_cast<clang::FunctionDecl *>(FD)->setLazyBody(Offset);
}

void clang_FunctionDecl_setDefaultedFunctionInfo(
    CXFunctionDecl FD, CXFunctionDecl_DefaultedFunctionInfo Info) {
  reinterpret_cast<clang::FunctionDecl *>(FD)->setDefaultedFunctionInfo(
      reinterpret_cast<clang::FunctionDecl::DefaultedFunctionInfo *>(Info));
}

CXFunctionDecl_DefaultedFunctionInfo
clang_FunctionDecl_getDefaultedFunctionInfo(CXFunctionDecl FD) {
  return reinterpret_cast<CXFunctionDecl_DefaultedFunctionInfo>(reinterpret_cast<clang::FunctionDecl *>(FD)->getDefaultedFunctionInfo());
}

// FunctionDecl::DefaultedFunctionInfo
CXFunctionDecl_DefaultedFunctionInfo clang_FunctionDecl_DefaultedFunctionInfo_Create(
    CXASTContext C, CXNamedDecl *Decls, CXAccessSpecifier *Accesses, unsigned NumLookups) {
  llvm::SmallVector<clang::DeclAccessPair, 4> Lookups;
  Lookups.reserve(NumLookups);
  for (unsigned I = 0; I != NumLookups; ++I)
    Lookups.push_back(
        clang::DeclAccessPair::make(reinterpret_cast<clang::NamedDecl *>(Decls[I]),
                                    static_cast<clang::AccessSpecifier>(Accesses[I])));
  return reinterpret_cast<CXFunctionDecl_DefaultedFunctionInfo>(clang::FunctionDecl::DefaultedFunctionInfo::Create(
      *reinterpret_cast<clang::ASTContext *>(C), Lookups));
}

unsigned clang_FunctionDecl_DefaultedFunctionInfo_getNumUnqualifiedLookups(
    CXFunctionDecl_DefaultedFunctionInfo Info) {
  return static_cast<unsigned>(
      reinterpret_cast<clang::FunctionDecl::DefaultedFunctionInfo *>(Info)
          ->getUnqualifiedLookups()
          .size());
}

CXNamedDecl clang_FunctionDecl_DefaultedFunctionInfo_getUnqualifiedLookupDecl(
    CXFunctionDecl_DefaultedFunctionInfo Info, unsigned i) {
  return reinterpret_cast<CXNamedDecl>(reinterpret_cast<clang::FunctionDecl::DefaultedFunctionInfo *>(Info)
      ->getUnqualifiedLookups()[i]
      .getDecl());
}

CXAccessSpecifier clang_FunctionDecl_DefaultedFunctionInfo_getUnqualifiedLookupAccess(
    CXFunctionDecl_DefaultedFunctionInfo Info, unsigned i) {
  return static_cast<CXAccessSpecifier>(
      reinterpret_cast<clang::FunctionDecl::DefaultedFunctionInfo *>(Info)
          ->getUnqualifiedLookups()[i]
          .getAccess());
}

bool clang_FunctionDecl_isVariadic(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isVariadic();
}

bool clang_FunctionDecl_isVirtualAsWritten(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isVirtualAsWritten();
}

void clang_FunctionDecl_setVirtualAsWritten(CXFunctionDecl FD, bool V) {
  reinterpret_cast<clang::FunctionDecl *>(FD)->setVirtualAsWritten(V);
}

bool clang_FunctionDecl_isPureVirtual(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isPureVirtual();
}

void clang_FunctionDecl_setIsPureVirtual(CXFunctionDecl FD, bool P) {
  reinterpret_cast<clang::FunctionDecl *>(FD)->setIsPureVirtual(P);
}

bool clang_FunctionDecl_isLateTemplateParsed(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isLateTemplateParsed();
}

void clang_FunctionDecl_setLateTemplateParsed(CXFunctionDecl FD, bool ILT) {
  reinterpret_cast<clang::FunctionDecl *>(FD)->setLateTemplateParsed(ILT);
}

bool clang_FunctionDecl_isTrivial(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isTrivial();
}

void clang_FunctionDecl_setTrivial(CXFunctionDecl FD, bool IT) {
  reinterpret_cast<clang::FunctionDecl *>(FD)->setTrivial(IT);
}

bool clang_FunctionDecl_isTrivialForCall(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isTrivialForCall();
}

void clang_FunctionDecl_setTrivialForCall(CXFunctionDecl FD, bool IT) {
  reinterpret_cast<clang::FunctionDecl *>(FD)->setTrivialForCall(IT);
}

bool clang_FunctionDecl_isDefaulted(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isDefaulted();
}

void clang_FunctionDecl_setDefaulted(CXFunctionDecl FD, bool D) {
  reinterpret_cast<clang::FunctionDecl *>(FD)->setDefaulted(D);
}

bool clang_FunctionDecl_isExplicitlyDefaulted(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isExplicitlyDefaulted();
}

void clang_FunctionDecl_setExplicitlyDefaulted(CXFunctionDecl FD, bool ED) {
  reinterpret_cast<clang::FunctionDecl *>(FD)->setExplicitlyDefaulted(ED);
}

bool clang_FunctionDecl_isUserProvided(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isUserProvided();
}

bool clang_FunctionDecl_hasImplicitReturnZero(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->hasImplicitReturnZero();
}

void clang_FunctionDecl_setHasImplicitReturnZero(CXFunctionDecl FD, bool IRZ) {
  reinterpret_cast<clang::FunctionDecl *>(FD)->setHasImplicitReturnZero(IRZ);
}

bool clang_FunctionDecl_hasPrototype(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->hasPrototype();
}

bool clang_FunctionDecl_hasWrittenPrototype(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->hasWrittenPrototype();
}

void clang_FunctionDecl_setHasWrittenPrototype(CXFunctionDecl FD, bool P) {
  reinterpret_cast<clang::FunctionDecl *>(FD)->setHasWrittenPrototype(P);
}

bool clang_FunctionDecl_hasInheritedPrototype(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->hasInheritedPrototype();
}

void clang_FunctionDecl_setHasInheritedPrototype(CXFunctionDecl FD, bool P) {
  reinterpret_cast<clang::FunctionDecl *>(FD)->setHasInheritedPrototype(P);
}

bool clang_FunctionDecl_isConstexpr(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isConstexpr();
}

void clang_FunctionDecl_setConstexprKind(CXFunctionDecl FD, CXConstexprSpecKind CSK) {
  reinterpret_cast<clang::FunctionDecl *>(FD)->setConstexprKind(
      static_cast<clang::ConstexprSpecKind>(CSK));
}

CXConstexprSpecKind clang_FunctionDecl_getConstexprKind(CXFunctionDecl FD) {
  return static_cast<CXConstexprSpecKind>(
      reinterpret_cast<clang::FunctionDecl *>(FD)->getConstexprKind());
}

bool clang_FunctionDecl_isConstexprSpecified(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isConstexprSpecified();
}

bool clang_FunctionDecl_isConsteval(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isConsteval();
}

bool clang_FunctionDecl_instantiationIsPending(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->instantiationIsPending();
}

void clang_FunctionDecl_setInstantiationIsPending(CXFunctionDecl FD, bool IC) {
  reinterpret_cast<clang::FunctionDecl *>(FD)->setInstantiationIsPending(IC);
}

bool clang_FunctionDecl_usesSEHTry(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->usesSEHTry();
}

void clang_FunctionDecl_setUsesSEHTry(CXFunctionDecl FD, bool UST) {
  reinterpret_cast<clang::FunctionDecl *>(FD)->setUsesSEHTry(UST);
}

bool clang_FunctionDecl_isDeleted(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isDeleted();
}

bool clang_FunctionDecl_isDeletedAsWritten(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isDeletedAsWritten();
}

void clang_FunctionDecl_setDeletedAsWritten(CXFunctionDecl FD, bool D) {
  reinterpret_cast<clang::FunctionDecl *>(FD)->setDeletedAsWritten(D);
}

bool clang_FunctionDecl_isMain(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isMain();
}

bool clang_FunctionDecl_isMSVCRTEntryPoint(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isMSVCRTEntryPoint();
}

bool clang_FunctionDecl_isReservedGlobalPlacementOperator(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isReservedGlobalPlacementOperator();
}

bool clang_FunctionDecl_isReplaceableGlobalAllocationFunction(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isReplaceableGlobalAllocationFunction();
}

bool clang_FunctionDecl_isInlineBuiltinDeclaration(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isInlineBuiltinDeclaration();
}

bool clang_FunctionDecl_isDestroyingOperatorDelete(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isDestroyingOperatorDelete();
}

CXLanguageLinkage clang_FunctionDecl_getLanguageLinkage(CXFunctionDecl FD) {
  return static_cast<CXLanguageLinkage>(
      reinterpret_cast<clang::FunctionDecl *>(FD)->getLanguageLinkage());
}

bool clang_FunctionDecl_isExternC(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isExternC();
}

bool clang_FunctionDecl_isInExternCContext(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isInExternCContext();
}

bool clang_FunctionDecl_isInExternCXXContext(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isInExternCXXContext();
}

bool clang_FunctionDecl_isGlobal(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isGlobal();
}

bool clang_FunctionDecl_isNoReturn(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isNoReturn();
}

bool clang_FunctionDecl_hasSkippedBody(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->hasSkippedBody();
}

void clang_FunctionDecl_setHasSkippedBody(CXFunctionDecl FD, bool Skipped) {
  reinterpret_cast<clang::FunctionDecl *>(FD)->setHasSkippedBody(Skipped);
}

bool clang_FunctionDecl_willHaveBody(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->willHaveBody();
}

void clang_FunctionDecl_setWillHaveBody(CXFunctionDecl FD, bool V) {
  reinterpret_cast<clang::FunctionDecl *>(FD)->setWillHaveBody(V);
}

bool clang_FunctionDecl_isMultiVersion(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isMultiVersion();
}

void clang_FunctionDecl_setIsMultiVersion(CXFunctionDecl FD, bool V) {
  reinterpret_cast<clang::FunctionDecl *>(FD)->setIsMultiVersion(V);
}

CXMultiVersionKind clang_FunctionDecl_getMultiVersionKind(CXFunctionDecl FD) {
  return static_cast<CXMultiVersionKind>(
      reinterpret_cast<clang::FunctionDecl *>(FD)->getMultiVersionKind());
}

bool clang_FunctionDecl_isCPUDispatchMultiVersion(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isCPUDispatchMultiVersion();
}

bool clang_FunctionDecl_isCPUSpecificMultiVersion(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isCPUSpecificMultiVersion();
}

bool clang_FunctionDecl_isTargetMultiVersion(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isTargetMultiVersion();
}

// getAssociatedConstraints

unsigned clang_FunctionDecl_getNumAssociatedConstraints(CXFunctionDecl FD) {
  llvm::SmallVector<const clang::Expr *, 4> AC;
  reinterpret_cast<clang::FunctionDecl *>(FD)->getAssociatedConstraints(AC);
  return AC.size();
}

void clang_FunctionDecl_getAssociatedConstraints(CXFunctionDecl FD, CXExpr *Buf) {
  llvm::SmallVector<const clang::Expr *, 4> AC;
  reinterpret_cast<clang::FunctionDecl *>(FD)->getAssociatedConstraints(AC);
  for (unsigned I = 0; I < AC.size(); ++I)
    Buf[I] = reinterpret_cast<CXExpr>(const_cast<clang::Expr *>(AC[I]));
}

void clang_FunctionDecl_setPreviousDeclaration(CXFunctionDecl FD, CXFunctionDecl PrevDecl) {
  reinterpret_cast<clang::FunctionDecl *>(FD)->setPreviousDeclaration(
      reinterpret_cast<clang::FunctionDecl *>(PrevDecl));
}

CXFunctionDecl clang_FunctionDecl_getCanonicalDecl(CXFunctionDecl FD) {
  return reinterpret_cast<CXFunctionDecl>(reinterpret_cast<clang::FunctionDecl *>(FD)->getCanonicalDecl());
}

unsigned clang_FunctionDecl_getBuiltinID(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->getBuiltinID();
}

// parameters

// setParams (private in clang 18 — only Sema/deserialization may set params)

unsigned clang_FunctionDecl_getMinRequiredExplicitArguments(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->getMinRequiredExplicitArguments();
}

bool clang_FunctionDecl_hasCXXExplicitFunctionObjectParameter(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->hasCXXExplicitFunctionObjectParameter();
}

unsigned clang_FunctionDecl_getNumNonObjectParams(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->getNumNonObjectParams();
}

CXParmVarDecl clang_FunctionDecl_getNonObjectParameter(CXFunctionDecl FD, unsigned I) {
  return reinterpret_cast<CXParmVarDecl>(reinterpret_cast<clang::FunctionDecl *>(FD)->getNonObjectParameter(I));
}

unsigned clang_FunctionDecl_getNumParams(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->getNumParams();
}

CXParmVarDecl clang_FunctionDecl_getParamDecl(CXFunctionDecl FD, unsigned i) {
  return reinterpret_cast<CXParmVarDecl>(reinterpret_cast<clang::FunctionDecl *>(FD)->getParamDecl(i));
}

// setParams

unsigned clang_FunctionDecl_getMinRequiredArguments(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->getMinRequiredArguments();
}

bool clang_FunctionDecl_hasOneParamOrDefaultArgs(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->hasOneParamOrDefaultArgs();
}


CXTypeLoc clang_FunctionDecl_getFunctionTypeLoc(CXFunctionDecl FD) {
  return reinterpret_cast<CXTypeLoc>(new clang::TypeLoc( // NOLINT(*-owning-memory)
      reinterpret_cast<clang::FunctionDecl *>(FD)->getFunctionTypeLoc()));
}

CXQualType clang_FunctionDecl_getReturnType(CXFunctionDecl FD) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::FunctionDecl *>(FD)->getReturnType().getAsOpaquePtr());
}

CXSourceRange_ clang_FunctionDecl_getReturnTypeSourceRange(CXFunctionDecl FD) {
  auto rng = reinterpret_cast<clang::FunctionDecl *>(FD)->getReturnTypeSourceRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

CXSourceRange_ clang_FunctionDecl_getParametersSourceRange(CXFunctionDecl FD) {
  auto rng = reinterpret_cast<clang::FunctionDecl *>(FD)->getParametersSourceRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

CXQualType clang_FunctionDecl_getDeclaredReturnType(CXFunctionDecl FD) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::FunctionDecl *>(FD)->getDeclaredReturnType().getAsOpaquePtr());
}

CXExceptionSpecificationType clang_FunctionDecl_getExceptionSpecType(CXFunctionDecl FD) {
  return static_cast<CXExceptionSpecificationType>(
      reinterpret_cast<clang::FunctionDecl *>(FD)->getExceptionSpecType());
}

CXSourceRange_ clang_FunctionDecl_getExceptionSpecSourceRange(CXFunctionDecl FD) {
  auto rng = reinterpret_cast<clang::FunctionDecl *>(FD)->getExceptionSpecSourceRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

CXQualType clang_FunctionDecl_getCallResultType(CXFunctionDecl FD) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::FunctionDecl *>(FD)->getCallResultType().getAsOpaquePtr());
}

CXStorageClass clang_FunctionDecl_getStorageClass(CXFunctionDecl FD) {
  return static_cast<CXStorageClass>(
      reinterpret_cast<clang::FunctionDecl *>(FD)->getStorageClass());
}

void clang_FunctionDecl_setStorageClass(CXFunctionDecl FD, CXStorageClass SClass) {
  reinterpret_cast<clang::FunctionDecl *>(FD)->setStorageClass(
      static_cast<clang::StorageClass>(SClass));
}

bool clang_FunctionDecl_isInlineSpecified(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isInlineSpecified();
}

void clang_FunctionDecl_setInlineSpecified(CXFunctionDecl FD, bool I) {
  reinterpret_cast<clang::FunctionDecl *>(FD)->setInlineSpecified(I);
}

void clang_FunctionDecl_setImplicitlyInline(CXFunctionDecl FD, bool I) {
  reinterpret_cast<clang::FunctionDecl *>(FD)->setImplicitlyInline(I);
}

bool clang_FunctionDecl_isInlined(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isInlined();
}

bool clang_FunctionDecl_isInlineDefinitionExternallyVisible(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isInlineDefinitionExternallyVisible();
}

bool clang_FunctionDecl_isMSExternInline(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isMSExternInline();
}

bool clang_FunctionDecl_doesDeclarationForceExternallyVisibleDefinition(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)
      ->doesDeclarationForceExternallyVisibleDefinition();
}

bool clang_FunctionDecl_isStatic(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isStatic();
}

bool clang_FunctionDecl_isOverloadedOperator(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isOverloadedOperator();
}


CXOverloadedOperatorKind clang_FunctionDecl_getOverloadedOperator(CXFunctionDecl FD) {
  return static_cast<CXOverloadedOperatorKind>(
      reinterpret_cast<clang::FunctionDecl *>(FD)->getOverloadedOperator());
}

CXIdentifierInfo clang_FunctionDecl_getLiteralIdentifier(CXFunctionDecl FD) {
  return reinterpret_cast<CXIdentifierInfo>(const_cast<clang::IdentifierInfo *>(
      reinterpret_cast<clang::FunctionDecl *>(FD)->getLiteralIdentifier()));
}

CXFunctionDecl_TemplatedKind clang_FunctionDecl_getTemplatedKind(CXFunctionDecl FD) {
  return static_cast<CXFunctionDecl_TemplatedKind>(
      reinterpret_cast<clang::FunctionDecl *>(FD)->getTemplatedKind());
}

CXMemberSpecializationInfo
clang_FunctionDecl_getMemberSpecializationInfo(CXFunctionDecl FD) {
  return reinterpret_cast<CXMemberSpecializationInfo>(reinterpret_cast<clang::FunctionDecl *>(FD)->getMemberSpecializationInfo());
}

void clang_FunctionDecl_setInstantiationOfMemberFunction(CXFunctionDecl FD,
                                                         CXFunctionDecl FD2,
                                                         CXTemplateSpecializationKind TSK) {
  reinterpret_cast<clang::FunctionDecl *>(FD)->setInstantiationOfMemberFunction(
      reinterpret_cast<clang::FunctionDecl *>(FD2),
      static_cast<clang::TemplateSpecializationKind>(TSK));
}

CXFunctionTemplateDecl clang_FunctionDecl_getDescribedFunctionTemplate(CXFunctionDecl FD) {
  return reinterpret_cast<CXFunctionTemplateDecl>(reinterpret_cast<clang::FunctionDecl *>(FD)->getDescribedFunctionTemplate());
}

void clang_FunctionDecl_setDescribedFunctionTemplate(CXFunctionDecl FD,
                                                     CXFunctionTemplateDecl Template) {
  reinterpret_cast<clang::FunctionDecl *>(FD)->setDescribedFunctionTemplate(
      reinterpret_cast<clang::FunctionTemplateDecl *>(Template));
}

CXFunctionDecl clang_FunctionDecl_getInstantiatedFromMemberFunction(CXFunctionDecl FD) {
  return reinterpret_cast<CXFunctionDecl>(reinterpret_cast<clang::FunctionDecl *>(FD)->getInstantiatedFromMemberFunction());
}

bool clang_FunctionDecl_isFunctionTemplateSpecialization(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isFunctionTemplateSpecialization();
}

CXFunctionTemplateSpecializationInfo
clang_FunctionDecl_getTemplateSpecializationInfo(CXFunctionDecl FD) {
  return reinterpret_cast<CXFunctionTemplateSpecializationInfo>(reinterpret_cast<clang::FunctionDecl *>(FD)->getTemplateSpecializationInfo());
}

bool clang_FunctionDecl_isImplicitlyInstantiable(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isImplicitlyInstantiable();
}

bool clang_FunctionDecl_isTemplateInstantiation(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isTemplateInstantiation();
}

CXFunctionDecl clang_FunctionDecl_getTemplateInstantiationPattern(CXFunctionDecl FD,
                                                                  bool ForDefinition) {
  return reinterpret_cast<CXFunctionDecl>(reinterpret_cast<clang::FunctionDecl *>(FD)->getTemplateInstantiationPattern(
      ForDefinition));
}

CXFunctionTemplateDecl clang_FunctionDecl_getPrimaryTemplate(CXFunctionDecl FD) {
  return reinterpret_cast<CXFunctionTemplateDecl>(reinterpret_cast<clang::FunctionDecl *>(FD)->getPrimaryTemplate());
}

CXTemplateArgumentList clang_FunctionDecl_getTemplateSpecializationArgs(CXFunctionDecl FD) {
  return reinterpret_cast<CXTemplateArgumentList>(const_cast<clang::TemplateArgumentList *>(
      reinterpret_cast<clang::FunctionDecl *>(FD)->getTemplateSpecializationArgs()));
}

CXASTTemplateArgumentListInfo
clang_FunctionDecl_getTemplateSpecializationArgsAsWritten(CXFunctionDecl FD) {
  return reinterpret_cast<CXASTTemplateArgumentListInfo>(const_cast<clang::ASTTemplateArgumentListInfo *>(
      reinterpret_cast<clang::FunctionDecl *>(FD)->getTemplateSpecializationArgsAsWritten()));
}

// setFunctionTemplateSpecialization
// setDependentTemplateSpecialization

CXFunctionDecl clang_FunctionDecl_getInstantiatedFromDecl(CXFunctionDecl FD) {
  return reinterpret_cast<CXFunctionDecl>(reinterpret_cast<clang::FunctionDecl *>(FD)->getInstantiatedFromDecl());
}

void clang_FunctionDecl_setInstantiatedFromDecl(CXFunctionDecl FD, CXFunctionDecl FD2) {
  reinterpret_cast<clang::FunctionDecl *>(FD)->setInstantiatedFromDecl(
      reinterpret_cast<clang::FunctionDecl *>(FD2));
}

CXDependentFunctionTemplateSpecializationInfo
clang_FunctionDecl_getDependentSpecializationInfo(CXFunctionDecl FD) {
  return reinterpret_cast<CXDependentFunctionTemplateSpecializationInfo>(reinterpret_cast<clang::FunctionDecl *>(FD)->getDependentSpecializationInfo());
}

CXTemplateSpecializationKind
clang_FunctionDecl_getTemplateSpecializationKind(CXFunctionDecl FD) {
  return static_cast<CXTemplateSpecializationKind>(
      reinterpret_cast<clang::FunctionDecl *>(FD)->getTemplateSpecializationKind());
}

CXTemplateSpecializationKind
clang_FunctionDecl_getTemplateSpecializationKindForInstantiation(CXFunctionDecl FD) {
  return static_cast<CXTemplateSpecializationKind>(
      reinterpret_cast<clang::FunctionDecl *>(FD)
          ->getTemplateSpecializationKindForInstantiation());
}

void clang_FunctionDecl_setTemplateSpecializationKind(
    CXFunctionDecl FD, CXTemplateSpecializationKind TSK,
    CXSourceLocation_ PointOfInstantiation) {
  reinterpret_cast<clang::FunctionDecl *>(FD)->setTemplateSpecializationKind(
      static_cast<clang::TemplateSpecializationKind>(TSK),
      clang::SourceLocation::getFromPtrEncoding(PointOfInstantiation));
}

CXSourceLocation_ clang_FunctionDecl_getPointOfInstantiation(CXFunctionDecl FD) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::FunctionDecl *>(FD)->getPointOfInstantiation().getPtrEncoding());
}

bool clang_FunctionDecl_isOutOfLine(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->isOutOfLine();
}

unsigned clang_FunctionDecl_getMemoryFunctionKind(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->getMemoryFunctionKind();
}

unsigned clang_FunctionDecl_getODRHash(CXFunctionDecl FD) {
  return reinterpret_cast<clang::FunctionDecl *>(FD)->getODRHash();
}

bool clang_FunctionDecl_classofKind(CXDeclKind K) {
  return clang::FunctionDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// FunctionDecl Cast
CXDeclContext clang_FunctionDecl_castToDeclContext(CXFunctionDecl FD) {
  return reinterpret_cast<CXDeclContext>(clang::FunctionDecl::castToDeclContext(reinterpret_cast<clang::FunctionDecl *>(FD)));
}

CXFunctionDecl clang_FunctionDecl_castFromDeclContext(CXDeclContext DC) {
  return reinterpret_cast<CXFunctionDecl>(clang::FunctionDecl::castFromDeclContext(reinterpret_cast<clang::DeclContext *>(DC)));
}

// FieldDecl
bool clang_FieldDecl_isPotentiallyOverlapping(CXFieldDecl FD) {
  return reinterpret_cast<clang::FieldDecl *>(FD)->isPotentiallyOverlapping();
}

bool clang_FieldDecl_hasNonNullInClassInitializer(CXFieldDecl FD) {
  return reinterpret_cast<clang::FieldDecl *>(FD)->hasNonNullInClassInitializer();
}

CXFieldDecl clang_FieldDecl_Create(CXASTContext C, CXDeclContext DC,
                                   CXSourceLocation_ StartLoc, CXSourceLocation_ IdLoc,
                                   CXIdentifierInfo I, CXQualType T, CXTypeSourceInfo TInfo,
                                   CXExpr BW, bool Mutable, CXInClassInitStyle InitStyle) {
  return reinterpret_cast<CXFieldDecl>(clang::FieldDecl::Create(
      *reinterpret_cast<clang::ASTContext *>(C), reinterpret_cast<clang::DeclContext *>(DC),
      clang::SourceLocation::getFromPtrEncoding(StartLoc),
      clang::SourceLocation::getFromPtrEncoding(IdLoc),
      reinterpret_cast<clang::IdentifierInfo *>(I), clang::QualType::getFromOpaquePtr(T),
      reinterpret_cast<clang::TypeSourceInfo *>(TInfo), reinterpret_cast<clang::Expr *>(BW), Mutable,
      static_cast<clang::InClassInitStyle>(InitStyle)));
}

CXFieldDecl clang_FieldDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return reinterpret_cast<CXFieldDecl>(clang::FieldDecl::CreateDeserialized(*reinterpret_cast<clang::ASTContext *>(C), ID));
}

unsigned clang_FieldDecl_getFieldIndex(CXFieldDecl FD) {
  return reinterpret_cast<clang::FieldDecl *>(FD)->getFieldIndex();
}

bool clang_FieldDecl_isMutable(CXFieldDecl FD) {
  return reinterpret_cast<clang::FieldDecl *>(FD)->isMutable();
}

bool clang_FieldDecl_isBitField(CXFieldDecl FD) {
  return reinterpret_cast<clang::FieldDecl *>(FD)->isBitField();
}

bool clang_FieldDecl_isUnnamedBitfield(CXFieldDecl FD) {
  return reinterpret_cast<clang::FieldDecl *>(FD)->isUnnamedBitfield();
}

bool clang_FieldDecl_isAnonymousStructOrUnion(CXFieldDecl FD) {
  return reinterpret_cast<clang::FieldDecl *>(FD)->isAnonymousStructOrUnion();
}

CXExpr clang_FieldDecl_getBitWidth(CXFieldDecl FD) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::FieldDecl *>(FD)->getBitWidth());
}

unsigned clang_FieldDecl_getBitWidthValue(CXFieldDecl FD, CXASTContext Ctx) {
  return reinterpret_cast<clang::FieldDecl *>(FD)->getBitWidthValue(
      *reinterpret_cast<clang::ASTContext *>(Ctx));
}

void clang_FieldDecl_setBitWidth(CXFieldDecl FD, CXExpr Width) {
  reinterpret_cast<clang::FieldDecl *>(FD)->setBitWidth(reinterpret_cast<clang::Expr *>(Width));
}

void clang_FieldDecl_removeBitWidth(CXFieldDecl FD) {
  reinterpret_cast<clang::FieldDecl *>(FD)->removeBitWidth();
}

bool clang_FieldDecl_isZeroLengthBitField(CXFieldDecl FD, CXASTContext Ctx) {
  return reinterpret_cast<clang::FieldDecl *>(FD)->isZeroLengthBitField(
      *reinterpret_cast<clang::ASTContext *>(Ctx));
}

bool clang_FieldDecl_isZeroSize(CXFieldDecl FD, CXASTContext Ctx) {
  return reinterpret_cast<clang::FieldDecl *>(FD)->isZeroSize(
      *reinterpret_cast<clang::ASTContext *>(Ctx));
}

CXInClassInitStyle clang_FieldDecl_getInClassInitStyle(CXFieldDecl FD) {
  return static_cast<CXInClassInitStyle>(
      reinterpret_cast<clang::FieldDecl *>(FD)->getInClassInitStyle());
}

bool clang_FieldDecl_hasInClassInitializer(CXFieldDecl FD) {
  return reinterpret_cast<clang::FieldDecl *>(FD)->hasInClassInitializer();
}

CXExpr clang_FieldDecl_getInClassInitializer(CXFieldDecl FD) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::FieldDecl *>(FD)->getInClassInitializer());
}

void clang_FieldDecl_setInClassInitializer(CXFieldDecl FD, CXExpr Init) {
  reinterpret_cast<clang::FieldDecl *>(FD)->setInClassInitializer(
      reinterpret_cast<clang::Expr *>(Init));
}

void clang_FieldDecl_removeInClassInitializer(CXFieldDecl FD) {
  reinterpret_cast<clang::FieldDecl *>(FD)->removeInClassInitializer();
}

bool clang_FieldDecl_hasCapturedVLAType(CXFieldDecl FD) {
  return reinterpret_cast<clang::FieldDecl *>(FD)->hasCapturedVLAType();
}

CXVariableArrayType clang_FieldDecl_getCapturedVLAType(CXFieldDecl FD) {
  return reinterpret_cast<CXVariableArrayType>(const_cast<clang::VariableArrayType *>(
      reinterpret_cast<clang::FieldDecl *>(FD)->getCapturedVLAType()));
}

void clang_FieldDecl_setCapturedVLAType(CXFieldDecl FD, CXVariableArrayType VLAType) {
  reinterpret_cast<clang::FieldDecl *>(FD)->setCapturedVLAType(
      reinterpret_cast<clang::VariableArrayType *>(VLAType));
}

CXRecordDecl clang_FieldDecl_getParent(CXFieldDecl FD) {
  return reinterpret_cast<CXRecordDecl>(reinterpret_cast<clang::FieldDecl *>(FD)->getParent());
}

CXSourceRange_ clang_FieldDecl_getSourceRange(CXFieldDecl FD) {
  auto rng = reinterpret_cast<clang::FieldDecl *>(FD)->getSourceRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

CXFieldDecl clang_FieldDecl_getCanonicalDecl(CXFieldDecl FD) {
  return reinterpret_cast<CXFieldDecl>(reinterpret_cast<clang::FieldDecl *>(FD)->getCanonicalDecl());
}

bool clang_FieldDecl_classofKind(CXDeclKind K) {
  return clang::FieldDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// EnumConstantDecl
CXEnumConstantDecl clang_EnumConstantDecl_Create(CXASTContext C, CXEnumDecl DC,
                                                 CXSourceLocation_ L, CXIdentifierInfo Id,
                                                 CXQualType T, CXExpr E,
                                                 LLVMGenericValueRef V) {
  return reinterpret_cast<CXEnumConstantDecl>(clang::EnumConstantDecl::Create(
      *reinterpret_cast<clang::ASTContext *>(C), reinterpret_cast<clang::EnumDecl *>(DC),
      clang::SourceLocation::getFromPtrEncoding(L),
      reinterpret_cast<clang::IdentifierInfo *>(Id), clang::QualType::getFromOpaquePtr(T),
      reinterpret_cast<clang::Expr *>(E),
      llvm::APSInt(reinterpret_cast<llvm::GenericValue *>(V)->IntVal)));
}

CXEnumConstantDecl clang_EnumConstantDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return reinterpret_cast<CXEnumConstantDecl>(clang::EnumConstantDecl::CreateDeserialized(*reinterpret_cast<clang::ASTContext *>(C),
                                                     ID));
}

CXExpr clang_EnumConstantDecl_getInitExpr(CXEnumConstantDecl ECD) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::EnumConstantDecl *>(ECD)->getInitExpr());
}


LLVMGenericValueRef clang_EnumConstantDecl_getInitVal(CXEnumConstantDecl ECD) {
  auto *GV = new llvm::GenericValue; // NOLINT(*-owning-memory)
  GV->IntVal = reinterpret_cast<clang::EnumConstantDecl *>(ECD)->getInitVal();
  return reinterpret_cast<LLVMGenericValueRef>(GV);
}

void clang_EnumConstantDecl_setInitExpr(CXEnumConstantDecl ECD, CXExpr E) {
  reinterpret_cast<clang::EnumConstantDecl *>(ECD)->setInitExpr(reinterpret_cast<clang::Expr *>(E));
}


void clang_EnumConstantDecl_setInitVal(CXEnumConstantDecl ECD, CXASTContext C,
                                       LLVMGenericValueRef V, bool IsUnsigned) {
  auto *GV = reinterpret_cast<llvm::GenericValue *>(V);
  reinterpret_cast<clang::EnumConstantDecl *>(ECD)->setInitVal(
      *reinterpret_cast<const clang::ASTContext *>(C), llvm::APSInt(GV->IntVal, IsUnsigned));
}

CXSourceRange_ clang_EnumConstantDecl_getSourceRange(CXEnumConstantDecl ECD) {
  auto rng = reinterpret_cast<clang::EnumConstantDecl *>(ECD)->getSourceRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

CXEnumConstantDecl clang_EnumConstantDecl_getCanonicalDecl(CXEnumConstantDecl ECD) {
  return reinterpret_cast<CXEnumConstantDecl>(reinterpret_cast<clang::EnumConstantDecl *>(ECD)->getCanonicalDecl());
}

long long clang_EnumConstantDecl_getEnumConstantDeclValue(CXEnumConstantDecl ECD) {
  return reinterpret_cast<clang::EnumConstantDecl *>(ECD)->getInitVal().getSExtValue();
}

bool clang_EnumConstantDecl_isInitValSigned(CXEnumConstantDecl ECD) {
  return reinterpret_cast<clang::EnumConstantDecl *>(ECD)->getInitVal().isSigned();
}

unsigned long long clang_EnumConstantDecl_getZExtInitVal(CXEnumConstantDecl ECD) {
  return reinterpret_cast<clang::EnumConstantDecl *>(ECD)->getInitVal().getZExtValue();
}

bool clang_EnumConstantDecl_initValFitsInInt64(CXEnumConstantDecl ECD) {
  const llvm::APSInt &V = reinterpret_cast<clang::EnumConstantDecl *>(ECD)->getInitVal();
  return V.isSingleWord() || V.getSignificantBits() <= 64;
}

bool clang_EnumConstantDecl_initValFitsInUInt64(CXEnumConstantDecl ECD) {
  const llvm::APSInt &V = reinterpret_cast<clang::EnumConstantDecl *>(ECD)->getInitVal();
  return V.isSingleWord() || V.getActiveBits() <= 64;
}

bool clang_EnumConstantDecl_classofKind(CXDeclKind K) {
  return clang::EnumConstantDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// IndirectFieldDecl
CXIndirectFieldDecl clang_IndirectFieldDecl_Create(CXASTContext C, CXDeclContext DC,
                                                   CXSourceLocation_ L,
                                                   CXIdentifierInfo Id, CXQualType T,
                                                   CXNamedDecl *Chain,
                                                   unsigned ChainSize) {
  auto &Ctx = *reinterpret_cast<clang::ASTContext *>(C);
  // IndirectFieldDecl stores the chain by reference (NamedDecl **Chaining), so
  // it must live in the ASTContext arena, not in a shim-local buffer.
  auto **CH = new (Ctx) clang::NamedDecl *[ChainSize];
  for (unsigned I = 0; I < ChainSize; ++I)
    CH[I] = reinterpret_cast<clang::NamedDecl *>(Chain[I]);
  return reinterpret_cast<CXIndirectFieldDecl>(clang::IndirectFieldDecl::Create(
      Ctx, reinterpret_cast<clang::DeclContext *>(DC),
      clang::SourceLocation::getFromPtrEncoding(L),
      reinterpret_cast<clang::IdentifierInfo *>(Id), clang::QualType::getFromOpaquePtr(T),
      llvm::MutableArrayRef<clang::NamedDecl *>(CH, ChainSize)));
}

CXIndirectFieldDecl clang_IndirectFieldDecl_CreateDeserialized(CXASTContext C,
                                                               unsigned ID) {
  return reinterpret_cast<CXIndirectFieldDecl>(clang::IndirectFieldDecl::CreateDeserialized(*reinterpret_cast<clang::ASTContext *>(C),
                                                      ID));
}

// chain
CXNamedDecl clang_IndirectFieldDecl_getChainElement(CXIndirectFieldDecl IFD, unsigned i) {
  return reinterpret_cast<CXNamedDecl>(reinterpret_cast<clang::IndirectFieldDecl *>(IFD)->chain()[i]);
}

unsigned clang_IndirectFieldDecl_getChainingSize(CXIndirectFieldDecl IFD) {
  return reinterpret_cast<clang::IndirectFieldDecl *>(IFD)->getChainingSize();
}

CXFieldDecl clang_IndirectFieldDecl_getAnonField(CXIndirectFieldDecl IFD) {
  return reinterpret_cast<CXFieldDecl>(reinterpret_cast<clang::IndirectFieldDecl *>(IFD)->getAnonField());
}

CXVarDecl clang_IndirectFieldDecl_getVarDecl(CXIndirectFieldDecl IFD) {
  return reinterpret_cast<CXVarDecl>(reinterpret_cast<clang::IndirectFieldDecl *>(IFD)->getVarDecl());
}

CXIndirectFieldDecl clang_IndirectFieldDecl_getCanonicalDecl(CXIndirectFieldDecl IFD) {
  return reinterpret_cast<CXIndirectFieldDecl>(reinterpret_cast<clang::IndirectFieldDecl *>(IFD)->getCanonicalDecl());
}

bool clang_IndirectFieldDecl_classofKind(CXDeclKind K) {
  return clang::IndirectFieldDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// TypeDecl
CXType_ clang_TypeDecl_getTypeForDecl(CXTypeDecl TD) {
  return reinterpret_cast<CXType_>(const_cast<clang::Type *>(reinterpret_cast<clang::TypeDecl *>(TD)->getTypeForDecl()));
}

void clang_TypeDecl_setTypeForDecl(CXTypeDecl TD, CXType_ Ty) {
  reinterpret_cast<clang::TypeDecl *>(TD)->setTypeForDecl(reinterpret_cast<clang::Type *>(Ty));
}

CXSourceLocation_ clang_TypeDecl_getBeginLoc(CXTypeDecl TD) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::TypeDecl *>(TD)->getBeginLoc().getPtrEncoding());
}

void clang_TypeDecl_setLocStart(CXTypeDecl TD, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::TypeDecl *>(TD)->setLocStart(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

CXSourceRange_ clang_TypeDecl_getSourceRange(CXTypeDecl TD) {
  auto rng = reinterpret_cast<clang::TypeDecl *>(TD)->getSourceRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

bool clang_TypeDecl_classofKind(CXDeclKind K) {
  return clang::TypeDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// TypedefNameDecl
bool clang_TypedefNameDecl_isModed(CXTypedefNameDecl TND) {
  return reinterpret_cast<clang::TypedefNameDecl *>(TND)->isModed();
}

CXTypeSourceInfo clang_TypedefNameDecl_getTypeSourceInfo(CXTypedefNameDecl TND) {
  return reinterpret_cast<CXTypeSourceInfo>(reinterpret_cast<clang::TypedefNameDecl *>(TND)->getTypeSourceInfo());
}

CXQualType clang_TypedefNameDecl_getUnderlyingType(CXTypedefNameDecl TND) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::TypedefNameDecl *>(TND)->getUnderlyingType().getAsOpaquePtr());
}

void clang_TypedefNameDecl_setTypeSourceInfo(CXTypedefNameDecl TND,
                                             CXTypeSourceInfo newType) {
  reinterpret_cast<clang::TypedefNameDecl *>(TND)->setTypeSourceInfo(
      reinterpret_cast<clang::TypeSourceInfo *>(newType));
}

void clang_TypedefNameDecl_setModedTypeSourceInfo(CXTypedefNameDecl TND,
                                                  CXTypeSourceInfo unmodedTSI,
                                                  CXQualType modedTy) {
  reinterpret_cast<clang::TypedefNameDecl *>(TND)->setModedTypeSourceInfo(
      reinterpret_cast<clang::TypeSourceInfo *>(unmodedTSI),
      clang::QualType::getFromOpaquePtr(modedTy));
}

CXTypedefNameDecl clang_TypedefNameDecl_getCanonicalDecl(CXTypedefNameDecl TND) {
  return reinterpret_cast<CXTypedefNameDecl>(reinterpret_cast<clang::TypedefNameDecl *>(TND)->getCanonicalDecl());
}

CXTagDecl clang_TypedefNameDecl_getAnonDeclWithTypedefName(CXTypedefNameDecl TND,
                                                           bool AnyRedecl) {
  return reinterpret_cast<CXTagDecl>(reinterpret_cast<clang::TypedefNameDecl *>(TND)->getAnonDeclWithTypedefName(AnyRedecl));
}

bool clang_TypedefNameDecl_isTransparentTag(CXTypedefNameDecl TND) {
  return reinterpret_cast<clang::TypedefNameDecl *>(TND)->isTransparentTag();
}

bool clang_TypedefNameDecl_classofKind(CXDeclKind K) {
  return clang::TypedefNameDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// TypedefDecl
CXTypedefDecl clang_TypedefDecl_Create(CXASTContext C, CXDeclContext DC,
                                       CXSourceLocation_ StartLoc, CXSourceLocation_ IdLoc,
                                       CXIdentifierInfo Id, CXTypeSourceInfo TInfo) {
  return reinterpret_cast<CXTypedefDecl>(clang::TypedefDecl::Create(*reinterpret_cast<clang::ASTContext *>(C),
                                    reinterpret_cast<clang::DeclContext *>(DC),
                                    clang::SourceLocation::getFromPtrEncoding(StartLoc),
                                    clang::SourceLocation::getFromPtrEncoding(IdLoc),
                                    reinterpret_cast<clang::IdentifierInfo *>(Id),
                                    reinterpret_cast<clang::TypeSourceInfo *>(TInfo)));
}

CXTypedefDecl clang_TypedefDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return reinterpret_cast<CXTypedefDecl>(clang::TypedefDecl::CreateDeserialized(*reinterpret_cast<clang::ASTContext *>(C), ID));
}

CXSourceRange_ clang_TypedefDecl_getSourceRange(CXTypedefDecl TD) {
  auto rng = reinterpret_cast<clang::TypedefDecl *>(TD)->getSourceRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

bool clang_TypedefDecl_classofKind(CXDeclKind K) {
  return clang::TypedefDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// TypeAliasDecl
CXTypeAliasDecl clang_TypeAliasDecl_Create(CXASTContext C, CXDeclContext DC,
                                           CXSourceLocation_ StartLoc,
                                           CXSourceLocation_ IdLoc, CXIdentifierInfo Id,
                                           CXTypeSourceInfo TInfo) {
  return reinterpret_cast<CXTypeAliasDecl>(clang::TypeAliasDecl::Create(*reinterpret_cast<clang::ASTContext *>(C),
                                      reinterpret_cast<clang::DeclContext *>(DC),
                                      clang::SourceLocation::getFromPtrEncoding(StartLoc),
                                      clang::SourceLocation::getFromPtrEncoding(IdLoc),
                                      reinterpret_cast<clang::IdentifierInfo *>(Id),
                                      reinterpret_cast<clang::TypeSourceInfo *>(TInfo)));
}

CXTypeAliasDecl clang_TypeAliasDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return reinterpret_cast<CXTypeAliasDecl>(clang::TypeAliasDecl::CreateDeserialized(*reinterpret_cast<clang::ASTContext *>(C), ID));
}

CXSourceRange_ clang_TypeAliasDecl_getSourceRange(CXTypeAliasDecl TAD) {
  auto rng = reinterpret_cast<clang::TypeAliasDecl *>(TAD)->getSourceRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

CXTypeAliasTemplateDecl clang_TypeAliasDecl_getDescribedAliasTemplate(CXTypeAliasDecl TAD) {
  return reinterpret_cast<CXTypeAliasTemplateDecl>(reinterpret_cast<clang::TypeAliasDecl *>(TAD)->getDescribedAliasTemplate());
}

void clang_TypeAliasDecl_setDescribedAliasTemplate(CXTypeAliasDecl TAD,
                                                   CXTypeAliasTemplateDecl TAT) {
  reinterpret_cast<clang::TypeAliasDecl *>(TAD)->setDescribedAliasTemplate(
      reinterpret_cast<clang::TypeAliasTemplateDecl *>(TAT));
}

bool clang_TypeAliasDecl_classofKind(CXDeclKind K) {
  return clang::TypeAliasDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// TagDecl
CXSourceRange_ clang_TagDecl_getBraceRange(CXTagDecl TD) {
  auto rng = reinterpret_cast<clang::TagDecl *>(TD)->getBraceRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

void clang_TagDecl_setBraceRange(CXTagDecl TD, CXSourceRange_ R) {
  reinterpret_cast<clang::TagDecl *>(TD)->setBraceRange(
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(R.B),
                         clang::SourceLocation::getFromPtrEncoding(R.E)));
}

CXSourceLocation_ clang_TagDecl_getInnerLocStart(CXTagDecl TD) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::TagDecl *>(TD)->getInnerLocStart().getPtrEncoding());
}

CXSourceLocation_ clang_TagDecl_getOuterLocStart(CXTagDecl TD) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::TagDecl *>(TD)->getOuterLocStart().getPtrEncoding());
}

CXSourceRange_ clang_TagDecl_getSourceRange(CXTagDecl TD) {
  auto rng = reinterpret_cast<clang::TagDecl *>(TD)->getSourceRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

CXTagDecl clang_TagDecl_getCanonicalDecl(CXTagDecl TD) {
  return reinterpret_cast<CXTagDecl>(reinterpret_cast<clang::TagDecl *>(TD)->getCanonicalDecl());
}

bool clang_TagDecl_isThisDeclarationADefinition(CXTagDecl TD) {
  return reinterpret_cast<clang::TagDecl *>(TD)->isThisDeclarationADefinition();
}

bool clang_TagDecl_isCompleteDefinition(CXTagDecl TD) {
  return reinterpret_cast<clang::TagDecl *>(TD)->isCompleteDefinition();
}

void clang_TagDecl_setCompleteDefinition(CXTagDecl TD, bool V) {
  reinterpret_cast<clang::TagDecl *>(TD)->setCompleteDefinition(V);
}

bool clang_TagDecl_isCompleteDefinitionRequired(CXTagDecl TD) {
  return reinterpret_cast<clang::TagDecl *>(TD)->isCompleteDefinitionRequired();
}

void clang_TagDecl_setCompleteDefinitionRequired(CXTagDecl TD, bool V) {
  reinterpret_cast<clang::TagDecl *>(TD)->setCompleteDefinitionRequired(V);
}

bool clang_TagDecl_isBeingDefined(CXTagDecl TD) {
  return reinterpret_cast<clang::TagDecl *>(TD)->isBeingDefined();
}

bool clang_TagDecl_isEmbeddedInDeclarator(CXTagDecl TD) {
  return reinterpret_cast<clang::TagDecl *>(TD)->isEmbeddedInDeclarator();
}

void clang_TagDecl_setEmbeddedInDeclarator(CXTagDecl TD, bool isInDeclarator) {
  reinterpret_cast<clang::TagDecl *>(TD)->setEmbeddedInDeclarator(isInDeclarator);
}

bool clang_TagDecl_isFreeStanding(CXTagDecl TD) {
  return reinterpret_cast<clang::TagDecl *>(TD)->isFreeStanding();
}

void clang_TagDecl_setFreeStanding(CXTagDecl TD, bool isFreeStanding) {
  reinterpret_cast<clang::TagDecl *>(TD)->setFreeStanding(isFreeStanding);
}

bool clang_TagDecl_mayHaveOutOfDateDef(CXTagDecl TD) {
  return reinterpret_cast<clang::TagDecl *>(TD)->mayHaveOutOfDateDef();
}

bool clang_TagDecl_isDependentType(CXTagDecl TD) {
  return reinterpret_cast<clang::TagDecl *>(TD)->isDependentType();
}

void clang_TagDecl_startDefinition(CXTagDecl TD) {
  reinterpret_cast<clang::TagDecl *>(TD)->startDefinition();
}

CXTagDecl clang_TagDecl_getDefinition(CXTagDecl TD) {
  return reinterpret_cast<CXTagDecl>(reinterpret_cast<clang::TagDecl *>(TD)->getDefinition());
}

const char *clang_TagDecl_getKindName(CXTagDecl TD) {
  return reinterpret_cast<clang::TagDecl *>(TD)->getKindName().data();
}

CXTagTypeKind clang_TagDecl_getTagKind(CXTagDecl TD) {
  return static_cast<CXTagTypeKind>(reinterpret_cast<clang::TagDecl *>(TD)->getTagKind());
}

void clang_TagDecl_setTagKind(CXTagDecl TD, CXTagTypeKind TK) {
  reinterpret_cast<clang::TagDecl *>(TD)->setTagKind(static_cast<clang::TagTypeKind>(TK));
}

bool clang_TagDecl_isStruct(CXTagDecl TD) {
  return reinterpret_cast<clang::TagDecl *>(TD)->isStruct();
}

bool clang_TagDecl_isInterface(CXTagDecl TD) {
  return reinterpret_cast<clang::TagDecl *>(TD)->isInterface();
}

bool clang_TagDecl_isClass(CXTagDecl TD) {
  return reinterpret_cast<clang::TagDecl *>(TD)->isClass();
}

bool clang_TagDecl_isUnion(CXTagDecl TD) {
  return reinterpret_cast<clang::TagDecl *>(TD)->isUnion();
}

bool clang_TagDecl_isEnum(CXTagDecl TD) {
  return reinterpret_cast<clang::TagDecl *>(TD)->isEnum();
}

bool clang_TagDecl_hasNameForLinkage(CXTagDecl TD) {
  return reinterpret_cast<clang::TagDecl *>(TD)->hasNameForLinkage();
}

CXTypedefNameDecl clang_TagDecl_getTypedefNameForAnonDecl(CXTagDecl TD) {
  return reinterpret_cast<CXTypedefNameDecl>(reinterpret_cast<clang::TagDecl *>(TD)->getTypedefNameForAnonDecl());
}

void clang_TagDecl_setTypedefNameForAnonDecl(CXTagDecl TD, CXTypedefNameDecl TDD) {
  reinterpret_cast<clang::TagDecl *>(TD)->setTypedefNameForAnonDecl(
      reinterpret_cast<clang::TypedefNameDecl *>(TDD));
}

CXNestedNameSpecifier clang_TagDecl_getQualifier(CXTagDecl TD) {
  return reinterpret_cast<CXNestedNameSpecifier>(reinterpret_cast<clang::TagDecl *>(TD)->getQualifier());
}

// getQualifierLoc
// setQualifierInfo

CXSourceRange_ clang_TagDecl_getQualifierRange(CXTagDecl TD) {
  auto Q = reinterpret_cast<clang::TagDecl *>(TD)->getQualifierLoc();
  clang::SourceRange R = Q.getSourceRange();
  return CXSourceRange_{reinterpret_cast<CXSourceLocation_>(R.getBegin().getPtrEncoding()), reinterpret_cast<CXSourceLocation_>(R.getEnd().getPtrEncoding())};
}

unsigned clang_TagDecl_getNumTemplateParameterLists(CXTagDecl TD) {
  return reinterpret_cast<clang::TagDecl *>(TD)->getNumTemplateParameterLists();
}

CXTemplateParameterList clang_TagDecl_getTemplateParameterList(CXTagDecl TD, unsigned i) {
  return reinterpret_cast<CXTemplateParameterList>(reinterpret_cast<clang::TagDecl *>(TD)->getTemplateParameterList(i));
}


void clang_TagDecl_setTemplateParameterListsInfo(CXTagDecl TD, CXASTContext C,
                                                 CXTemplateParameterList *TPLists,
                                                 unsigned NumTPLists) {
  llvm::SmallVector<clang::TemplateParameterList *, 4> Lists;
  Lists.reserve(NumTPLists);
  for (unsigned I = 0; I != NumTPLists; ++I)
    Lists.push_back(reinterpret_cast<clang::TemplateParameterList *>(TPLists[I]));
  reinterpret_cast<clang::TagDecl *>(TD)->setTemplateParameterListsInfo(
      *reinterpret_cast<clang::ASTContext *>(C), Lists);
}

bool clang_TagDecl_classofKind(CXDeclKind K) {
  return clang::TagDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// TagDecl Cast
bool clang_TagDecl_isThisDeclarationADemotedDefinition(CXTagDecl TD) {
  return reinterpret_cast<clang::TagDecl *>(TD)->isThisDeclarationADemotedDefinition();
}

void clang_TagDecl_demoteThisDefinitionToDeclaration(CXTagDecl TD) {
  reinterpret_cast<clang::TagDecl *>(TD)->demoteThisDefinitionToDeclaration();
}

CXDeclContext clang_TagDecl_castToDeclContext(CXTagDecl TD) {
  return reinterpret_cast<CXDeclContext>(llvm::dyn_cast_or_null<clang::DeclContext>(reinterpret_cast<clang::TagDecl *>(TD)));
}

// EnumDecl
CXSourceRange_ clang_EnumDecl_getSourceRange(CXEnumDecl ED) {
  clang::SourceRange R = reinterpret_cast<clang::EnumDecl *>(ED)->getSourceRange();
  return CXSourceRange_{reinterpret_cast<CXSourceLocation_>(R.getBegin().getPtrEncoding()), reinterpret_cast<CXSourceLocation_>(R.getEnd().getPtrEncoding())};
}

void clang_EnumDecl_getValueRange(CXEnumDecl ED, LLVMGenericValueRef *Max,
                                  LLVMGenericValueRef *Min) {
  llvm::APInt MaxVal;
  llvm::APInt MinVal;
  reinterpret_cast<clang::EnumDecl *>(ED)->getValueRange(MaxVal, MinVal);
  auto *GVMax = new llvm::GenericValue; // NOLINT(*-owning-memory)
  GVMax->IntVal = MaxVal;
  auto *GVMin = new llvm::GenericValue; // NOLINT(*-owning-memory)
  GVMin->IntVal = MinVal;
  *Max = reinterpret_cast<LLVMGenericValueRef>(GVMax);
  *Min = reinterpret_cast<LLVMGenericValueRef>(GVMin);
}

CXEnumDecl clang_EnumDecl_Create(CXASTContext C, CXDeclContext DC,
                                 CXSourceLocation_ StartLoc, CXSourceLocation_ IdLoc,
                                 CXIdentifierInfo Id, CXEnumDecl PrevDecl, bool IsScoped,
                                 bool IsScopedUsingClassTag, bool IsFixed) {
  return reinterpret_cast<CXEnumDecl>(clang::EnumDecl::Create(
      *reinterpret_cast<clang::ASTContext *>(C), reinterpret_cast<clang::DeclContext *>(DC),
      clang::SourceLocation::getFromPtrEncoding(StartLoc),
      clang::SourceLocation::getFromPtrEncoding(IdLoc),
      reinterpret_cast<clang::IdentifierInfo *>(Id), reinterpret_cast<clang::EnumDecl *>(PrevDecl),
      IsScoped, IsScopedUsingClassTag, IsFixed));
}

CXEnumDecl clang_EnumDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return reinterpret_cast<CXEnumDecl>(clang::EnumDecl::CreateDeserialized(*reinterpret_cast<clang::ASTContext *>(C), ID));
}

void clang_EnumDecl_setScoped(CXEnumDecl ED, bool Scoped) {
  reinterpret_cast<clang::EnumDecl *>(ED)->setScoped(Scoped);
}

void clang_EnumDecl_setScopedUsingClassTag(CXEnumDecl ED, bool ScopedUCT) {
  reinterpret_cast<clang::EnumDecl *>(ED)->setScopedUsingClassTag(ScopedUCT);
}

void clang_EnumDecl_setFixed(CXEnumDecl ED, bool Fixed) {
  reinterpret_cast<clang::EnumDecl *>(ED)->setFixed(Fixed);
}

CXEnumDecl clang_EnumDecl_getCanonicalDecl(CXEnumDecl ED) {
  return reinterpret_cast<CXEnumDecl>(reinterpret_cast<clang::EnumDecl *>(ED)->getCanonicalDecl());
}

CXEnumDecl clang_EnumDecl_getPreviousDecl(CXEnumDecl ED) {
  return reinterpret_cast<CXEnumDecl>(reinterpret_cast<clang::EnumDecl *>(ED)->getPreviousDecl());
}

CXEnumDecl clang_EnumDecl_getMostRecentDecl(CXEnumDecl ED) {
  return reinterpret_cast<CXEnumDecl>(reinterpret_cast<clang::EnumDecl *>(ED)->getMostRecentDecl());
}

CXEnumDecl clang_EnumDecl_getDefinition(CXEnumDecl ED) {
  return reinterpret_cast<CXEnumDecl>(reinterpret_cast<clang::EnumDecl *>(ED)->getDefinition());
}

void clang_EnumDecl_completeDefinition(CXEnumDecl ED, CXQualType NewType,
                                       CXQualType PromotionType, unsigned NumPositiveBits,
                                       unsigned NumNegativeBits) {
  reinterpret_cast<clang::EnumDecl *>(ED)->completeDefinition(
      clang::QualType::getFromOpaquePtr(NewType),
      clang::QualType::getFromOpaquePtr(PromotionType), NumPositiveBits, NumNegativeBits);
}

CXQualType clang_EnumDecl_getPromotionType(CXEnumDecl ED) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::EnumDecl *>(ED)->getPromotionType().getAsOpaquePtr());
}

void clang_EnumDecl_setPromotionType(CXEnumDecl ED, CXQualType T) {
  reinterpret_cast<clang::EnumDecl *>(ED)->setPromotionType(
      clang::QualType::getFromOpaquePtr(T));
}

CXQualType clang_EnumDecl_getIntegerType(CXEnumDecl ED) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::EnumDecl *>(ED)->getIntegerType().getAsOpaquePtr());
}

void clang_EnumDecl_setIntegerType(CXEnumDecl ED, CXQualType T) {
  reinterpret_cast<clang::EnumDecl *>(ED)->setIntegerType(clang::QualType::getFromOpaquePtr(T));
}

void clang_EnumDecl_setIntegerTypeSourceInfo(CXEnumDecl ED, CXTypeSourceInfo TInfo) {
  reinterpret_cast<clang::EnumDecl *>(ED)->setIntegerTypeSourceInfo(
      reinterpret_cast<clang::TypeSourceInfo *>(TInfo));
}

CXTypeSourceInfo clang_EnumDecl_getIntegerTypeSourceInfo(CXEnumDecl ED) {
  return reinterpret_cast<CXTypeSourceInfo>(reinterpret_cast<clang::EnumDecl *>(ED)->getIntegerTypeSourceInfo());
}

CXSourceRange_ clang_EnumDecl_getIntegerTypeRange(CXEnumDecl ED) {
  auto rng = reinterpret_cast<clang::EnumDecl *>(ED)->getIntegerTypeRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

unsigned clang_EnumDecl_getNumPositiveBits(CXEnumDecl ED) {
  return reinterpret_cast<clang::EnumDecl *>(ED)->getNumPositiveBits();
}

unsigned clang_EnumDecl_getNumNegativeBits(CXEnumDecl ED) {
  return reinterpret_cast<clang::EnumDecl *>(ED)->getNumNegativeBits();
}

bool clang_EnumDecl_isScoped(CXEnumDecl ED) {
  return reinterpret_cast<clang::EnumDecl *>(ED)->isScoped();
}

bool clang_EnumDecl_isScopedUsingClassTag(CXEnumDecl ED) {
  return reinterpret_cast<clang::EnumDecl *>(ED)->isScopedUsingClassTag();
}

bool clang_EnumDecl_isFixed(CXEnumDecl ED) {
  return reinterpret_cast<clang::EnumDecl *>(ED)->isFixed();
}

unsigned clang_EnumDecl_getODRHash(CXEnumDecl ED) {
  return reinterpret_cast<clang::EnumDecl *>(ED)->getODRHash();
}

bool clang_EnumDecl_isComplete(CXEnumDecl ED) {
  return reinterpret_cast<clang::EnumDecl *>(ED)->isComplete();
}

bool clang_EnumDecl_isClosed(CXEnumDecl ED) {
  return reinterpret_cast<clang::EnumDecl *>(ED)->isClosed();
}

bool clang_EnumDecl_isClosedFlag(CXEnumDecl ED) {
  return reinterpret_cast<clang::EnumDecl *>(ED)->isClosedFlag();
}

bool clang_EnumDecl_isClosedNonFlag(CXEnumDecl ED) {
  return reinterpret_cast<clang::EnumDecl *>(ED)->isClosedNonFlag();
}

CXEnumDecl clang_EnumDecl_getTemplateInstantiationPattern(CXEnumDecl ED) {
  return reinterpret_cast<CXEnumDecl>(reinterpret_cast<clang::EnumDecl *>(ED)->getTemplateInstantiationPattern());
}

CXEnumDecl clang_EnumDecl_getInstantiatedFromMemberEnum(CXEnumDecl ED) {
  return reinterpret_cast<CXEnumDecl>(reinterpret_cast<clang::EnumDecl *>(ED)->getInstantiatedFromMemberEnum());
}

CXTemplateSpecializationKind clang_EnumDecl_getTemplateSpecializationKind(CXEnumDecl ED) {
  return static_cast<CXTemplateSpecializationKind>(
      reinterpret_cast<clang::EnumDecl *>(ED)->getTemplateSpecializationKind());
}

void clang_EnumDecl_setTemplateSpecializationKind(CXEnumDecl ED,
                                                  CXTemplateSpecializationKind TSK,
                                                  CXSourceLocation_ PointOfInstantiation) {
  reinterpret_cast<clang::EnumDecl *>(ED)->setTemplateSpecializationKind(
      static_cast<clang::TemplateSpecializationKind>(TSK),
      clang::SourceLocation::getFromPtrEncoding(PointOfInstantiation));
}

CXMemberSpecializationInfo clang_EnumDecl_getMemberSpecializationInfo(CXEnumDecl ED) {
  return reinterpret_cast<CXMemberSpecializationInfo>(reinterpret_cast<clang::EnumDecl *>(ED)->getMemberSpecializationInfo());
}

void clang_EnumDecl_setInstantiationOfMemberEnum(CXEnumDecl ED, CXEnumDecl ED2,
                                                 CXTemplateSpecializationKind TSK) {

  reinterpret_cast<clang::EnumDecl *>(ED)->setInstantiationOfMemberEnum(
      reinterpret_cast<clang::EnumDecl *>(ED2),
      static_cast<clang::TemplateSpecializationKind>(TSK));
}

unsigned clang_EnumDecl_getNumEnumerators(CXEnumDecl ED) {
  auto *D = reinterpret_cast<clang::EnumDecl *>(ED);
  unsigned N = 0;
  for (auto *E : D->enumerators()) {
    (void)E;
    ++N;
  }
  return N;
}

void clang_EnumDecl_getEnumerators(CXEnumDecl ED, CXEnumConstantDecl *Buf) {
  auto *D = reinterpret_cast<clang::EnumDecl *>(ED);
  unsigned I = 0;
  for (auto *E : D->enumerators())
    Buf[I++] = reinterpret_cast<CXEnumConstantDecl>(E);
}

bool clang_EnumDecl_classofKind(CXDeclKind K) {
  return clang::EnumDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// RecordDecl
CXRecordDecl clang_RecordDecl_Create(CXASTContext C, CXTagTypeKind TK, CXDeclContext DC,
                                     CXSourceLocation_ StartLoc, CXSourceLocation_ IdLoc,
                                     CXIdentifierInfo Id, CXRecordDecl PrevDecl) {
  return reinterpret_cast<CXRecordDecl>(clang::RecordDecl::Create(
      *reinterpret_cast<clang::ASTContext *>(C), static_cast<clang::TagTypeKind>(TK),
      reinterpret_cast<clang::DeclContext *>(DC),
      clang::SourceLocation::getFromPtrEncoding(StartLoc),
      clang::SourceLocation::getFromPtrEncoding(IdLoc),
      reinterpret_cast<clang::IdentifierInfo *>(Id), reinterpret_cast<clang::RecordDecl *>(PrevDecl)));
}

CXRecordDecl clang_RecordDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return reinterpret_cast<CXRecordDecl>(clang::RecordDecl::CreateDeserialized(*reinterpret_cast<clang::ASTContext *>(C), ID));
}

CXRecordDecl clang_RecordDecl_getPreviousDecl(CXRecordDecl RD) {
  return reinterpret_cast<CXRecordDecl>(reinterpret_cast<clang::RecordDecl *>(RD)->getPreviousDecl());
}

CXRecordDecl clang_RecordDecl_getMostRecentDecl(CXRecordDecl RD) {
  return reinterpret_cast<CXRecordDecl>(reinterpret_cast<clang::RecordDecl *>(RD)->getMostRecentDecl());
}

bool clang_RecordDecl_hasFlexibleArrayMember(CXRecordDecl RD) {
  return reinterpret_cast<clang::RecordDecl *>(RD)->hasFlexibleArrayMember();
}

void clang_RecordDecl_setHasFlexibleArrayMember(CXRecordDecl RD, bool V) {
  reinterpret_cast<clang::RecordDecl *>(RD)->setHasFlexibleArrayMember(V);
}

bool clang_RecordDecl_isAnonymousStructOrUnion(CXRecordDecl RD) {
  return reinterpret_cast<clang::RecordDecl *>(RD)->isAnonymousStructOrUnion();
}

void clang_RecordDecl_setAnonymousStructOrUnion(CXRecordDecl RD, bool Anon) {
  reinterpret_cast<clang::RecordDecl *>(RD)->setAnonymousStructOrUnion(Anon);
}

bool clang_RecordDecl_hasObjectMember(CXRecordDecl RD) {
  return reinterpret_cast<clang::RecordDecl *>(RD)->hasObjectMember();
}

void clang_RecordDecl_setHasObjectMember(CXRecordDecl RD, bool val) {
  reinterpret_cast<clang::RecordDecl *>(RD)->setHasObjectMember(val);
}

bool clang_RecordDecl_hasVolatileMember(CXRecordDecl RD) {
  return reinterpret_cast<clang::RecordDecl *>(RD)->hasVolatileMember();
}

void clang_RecordDecl_setHasVolatileMember(CXRecordDecl RD, bool val) {
  reinterpret_cast<clang::RecordDecl *>(RD)->setHasVolatileMember(val);
}

bool clang_RecordDecl_hasLoadedFieldsFromExternalStorage(CXRecordDecl RD) {
  return reinterpret_cast<clang::RecordDecl *>(RD)->hasLoadedFieldsFromExternalStorage();
}

void clang_RecordDecl_setHasLoadedFieldsFromExternalStorage(CXRecordDecl RD, bool val) {
  reinterpret_cast<clang::RecordDecl *>(RD)->setHasLoadedFieldsFromExternalStorage(val);
}

bool clang_RecordDecl_isNonTrivialToPrimitiveDefaultInitialize(CXRecordDecl RD) {
  return reinterpret_cast<clang::RecordDecl *>(RD)->isNonTrivialToPrimitiveDefaultInitialize();
}

void clang_RecordDecl_setNonTrivialToPrimitiveDefaultInitialize(CXRecordDecl RD, bool V) {
  reinterpret_cast<clang::RecordDecl *>(RD)->setNonTrivialToPrimitiveDefaultInitialize(V);
}

bool clang_RecordDecl_isNonTrivialToPrimitiveCopy(CXRecordDecl RD) {
  return reinterpret_cast<clang::RecordDecl *>(RD)->isNonTrivialToPrimitiveCopy();
}

void clang_RecordDecl_setNonTrivialToPrimitiveCopy(CXRecordDecl RD, bool V) {
  reinterpret_cast<clang::RecordDecl *>(RD)->setNonTrivialToPrimitiveCopy(V);
}

bool clang_RecordDecl_isNonTrivialToPrimitiveDestroy(CXRecordDecl RD) {
  return reinterpret_cast<clang::RecordDecl *>(RD)->isNonTrivialToPrimitiveDestroy();
}

void clang_RecordDecl_setNonTrivialToPrimitiveDestroy(CXRecordDecl RD, bool V) {
  reinterpret_cast<clang::RecordDecl *>(RD)->setNonTrivialToPrimitiveDestroy(V);
}

bool clang_RecordDecl_hasNonTrivialToPrimitiveDefaultInitializeCUnion(CXRecordDecl RD) {
  return reinterpret_cast<clang::RecordDecl *>(RD)
      ->hasNonTrivialToPrimitiveDefaultInitializeCUnion();
}

void clang_RecordDecl_setHasNonTrivialToPrimitiveDefaultInitializeCUnion(CXRecordDecl RD,
                                                                         bool V) {
  reinterpret_cast<clang::RecordDecl *>(RD)->setHasNonTrivialToPrimitiveDefaultInitializeCUnion(
      V);
}

bool clang_RecordDecl_hasNonTrivialToPrimitiveDestructCUnion(CXRecordDecl RD) {
  return reinterpret_cast<clang::RecordDecl *>(RD)->hasNonTrivialToPrimitiveDestructCUnion();
}

void clang_RecordDecl_setHasNonTrivialToPrimitiveDestructCUnion(CXRecordDecl RD, bool V) {
  reinterpret_cast<clang::RecordDecl *>(RD)->setHasNonTrivialToPrimitiveDestructCUnion(V);
}

bool clang_RecordDecl_hasNonTrivialToPrimitiveCopyCUnion(CXRecordDecl RD) {
  return reinterpret_cast<clang::RecordDecl *>(RD)->hasNonTrivialToPrimitiveCopyCUnion();
}

void clang_RecordDecl_setHasNonTrivialToPrimitiveCopyCUnion(CXRecordDecl RD, bool V) {
  reinterpret_cast<clang::RecordDecl *>(RD)->setHasNonTrivialToPrimitiveCopyCUnion(V);
}

bool clang_RecordDecl_canPassInRegisters(CXRecordDecl RD) {
  return reinterpret_cast<clang::RecordDecl *>(RD)->canPassInRegisters();
}

CXRecordArgPassingKind clang_RecordDecl_getArgPassingRestrictions(CXRecordDecl RD) {
  return static_cast<CXRecordArgPassingKind>(
      reinterpret_cast<clang::RecordDecl *>(RD)->getArgPassingRestrictions());
}

void clang_RecordDecl_setArgPassingRestrictions(CXRecordDecl RD,
                                                CXRecordArgPassingKind Kind) {
  reinterpret_cast<clang::RecordDecl *>(RD)->setArgPassingRestrictions(
      static_cast<clang::RecordArgPassingKind>(Kind));
}

bool clang_RecordDecl_isParamDestroyedInCallee(CXRecordDecl RD) {
  return reinterpret_cast<clang::RecordDecl *>(RD)->isParamDestroyedInCallee();
}

void clang_RecordDecl_setParamDestroyedInCallee(CXRecordDecl RD, bool V) {
  reinterpret_cast<clang::RecordDecl *>(RD)->setParamDestroyedInCallee(V);
}

bool clang_RecordDecl_isInjectedClassName(CXRecordDecl RD) {
  return reinterpret_cast<clang::RecordDecl *>(RD)->isInjectedClassName();
}

bool clang_RecordDecl_isLambda(CXRecordDecl RD) {
  return reinterpret_cast<clang::RecordDecl *>(RD)->isLambda();
}

bool clang_RecordDecl_isCapturedRecord(CXRecordDecl RD) {
  return reinterpret_cast<clang::RecordDecl *>(RD)->isCapturedRecord();
}

void clang_RecordDecl_setCapturedRecord(CXRecordDecl RD) {
  reinterpret_cast<clang::RecordDecl *>(RD)->setCapturedRecord();
}

CXRecordDecl clang_RecordDecl_getDefinition(CXRecordDecl RD) {
  return reinterpret_cast<CXRecordDecl>(reinterpret_cast<clang::RecordDecl *>(RD)->getDefinition());
}

bool clang_RecordDecl_isOrContainsUnion(CXRecordDecl RD) {
  return reinterpret_cast<clang::RecordDecl *>(RD)->isOrContainsUnion();
}

bool clang_RecordDecl_isMsStruct(CXRecordDecl RD, CXASTContext C) {
  return reinterpret_cast<clang::RecordDecl *>(RD)->isMsStruct(
      *reinterpret_cast<clang::ASTContext *>(C));
}

bool clang_RecordDecl_mayInsertExtraPadding(CXRecordDecl RD, bool EmitRemark) {
  return reinterpret_cast<clang::RecordDecl *>(RD)->mayInsertExtraPadding(EmitRemark);
}

CXFieldDecl clang_RecordDecl_findFirstNamedDataMember(CXRecordDecl RD) {
  return reinterpret_cast<CXFieldDecl>(const_cast<clang::FieldDecl *>(
      reinterpret_cast<clang::RecordDecl *>(RD)->findFirstNamedDataMember()));
}

unsigned clang_RecordDecl_getNumFields(CXRecordDecl RD) {
  auto *D = reinterpret_cast<clang::RecordDecl *>(RD);
  unsigned N = 0;
  for (auto *F : D->fields()) {
    (void)F;
    ++N;
  }
  return N;
}

void clang_RecordDecl_getFields(CXRecordDecl RD, CXFieldDecl *Buf) {
  auto *D = reinterpret_cast<clang::RecordDecl *>(RD);
  unsigned I = 0;
  for (auto *F : D->fields())
    Buf[I++] = reinterpret_cast<CXFieldDecl>(F);
}

bool clang_RecordDecl_field_empty(CXRecordDecl RD) {
  return reinterpret_cast<clang::RecordDecl *>(RD)->field_empty();
}

bool clang_RecordDecl_classofKind(CXDeclKind K) {
  return clang::RecordDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// RecordDecl Cast
bool clang_RecordDecl_isRandomized(CXRecordDecl RD) {
  return reinterpret_cast<clang::RecordDecl *>(RD)->isRandomized();
}

void clang_RecordDecl_setIsRandomized(CXRecordDecl RD, bool V) {
  reinterpret_cast<clang::RecordDecl *>(RD)->setIsRandomized(V);
}

void clang_RecordDecl_completeDefinition(CXRecordDecl RD) {
  reinterpret_cast<clang::RecordDecl *>(RD)->completeDefinition();
}

unsigned clang_RecordDecl_getODRHash(CXRecordDecl RD) {
  return reinterpret_cast<clang::RecordDecl *>(RD)->getODRHash();
}

// FileScopeAsmDecl
CXFileScopeAsmDecl clang_FileScopeAsmDecl_Create(CXASTContext C, CXDeclContext DC,
                                                 CXStringLiteral Str,
                                                 CXSourceLocation_ AsmLoc,
                                                 CXSourceLocation_ RParenLoc) {
  return reinterpret_cast<CXFileScopeAsmDecl>(clang::FileScopeAsmDecl::Create(
      *reinterpret_cast<clang::ASTContext *>(C), reinterpret_cast<clang::DeclContext *>(DC),
      reinterpret_cast<clang::StringLiteral *>(Str),
      clang::SourceLocation::getFromPtrEncoding(AsmLoc),
      clang::SourceLocation::getFromPtrEncoding(RParenLoc)));
}

CXFileScopeAsmDecl clang_FileScopeAsmDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return reinterpret_cast<CXFileScopeAsmDecl>(clang::FileScopeAsmDecl::CreateDeserialized(*reinterpret_cast<clang::ASTContext *>(C),
                                                     ID));
}

CXSourceLocation_ clang_FileScopeAsmDecl_getAsmLoc(CXFileScopeAsmDecl FSAD) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::FileScopeAsmDecl *>(FSAD)->getAsmLoc().getPtrEncoding());
}

CXSourceLocation_ clang_FileScopeAsmDecl_getRParenLoc(CXFileScopeAsmDecl FSAD) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::FileScopeAsmDecl *>(FSAD)->getRParenLoc().getPtrEncoding());
}

void clang_FileScopeAsmDecl_setRParenLoc(CXFileScopeAsmDecl FSAD, CXSourceLocation_ L) {
  reinterpret_cast<clang::FileScopeAsmDecl *>(FSAD)->setRParenLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

CXSourceRange_ clang_FileScopeAsmDecl_getSourceRange(CXFileScopeAsmDecl FSAD) {
  auto rng = reinterpret_cast<clang::FileScopeAsmDecl *>(FSAD)->getSourceRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

CXStringLiteral clang_FileScopeAsmDecl_getAsmString(CXFileScopeAsmDecl FSAD) {
  return reinterpret_cast<CXStringLiteral>(reinterpret_cast<clang::FileScopeAsmDecl *>(FSAD)->getAsmString());
}

void clang_FileScopeAsmDecl_setAsmString(CXFileScopeAsmDecl FSAD, CXStringLiteral Asm) {
  reinterpret_cast<clang::FileScopeAsmDecl *>(FSAD)->setAsmString(
      reinterpret_cast<clang::StringLiteral *>(Asm));
}

bool clang_FileScopeAsmDecl_classofKind(CXDeclKind K) {
  return clang::FileScopeAsmDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// BlockDecl
// TopLevelStmtDecl
CXTopLevelStmtDecl clang_TopLevelStmtDecl_Create(CXASTContext C, CXStmt Statement) {
  return reinterpret_cast<CXTopLevelStmtDecl>(clang::TopLevelStmtDecl::Create(*reinterpret_cast<clang::ASTContext *>(C),
                                         reinterpret_cast<clang::Stmt *>(Statement)));
}

CXTopLevelStmtDecl clang_TopLevelStmtDecl_CreateDeserialized(CXASTContext C,
                                                             unsigned ID) {
  return reinterpret_cast<CXTopLevelStmtDecl>(clang::TopLevelStmtDecl::CreateDeserialized(*reinterpret_cast<clang::ASTContext *>(C),
                                                     ID));
}

CXSourceRange_ clang_TopLevelStmtDecl_getSourceRange(CXTopLevelStmtDecl TLSD) {
  clang::SourceRange R = reinterpret_cast<clang::TopLevelStmtDecl *>(TLSD)->getSourceRange();
  return CXSourceRange_{reinterpret_cast<CXSourceLocation_>(R.getBegin().getPtrEncoding()), reinterpret_cast<CXSourceLocation_>(R.getEnd().getPtrEncoding())};
}

CXStmt clang_TopLevelStmtDecl_getStmt(CXTopLevelStmtDecl TLSD) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::TopLevelStmtDecl *>(TLSD)->getStmt());
}

void clang_TopLevelStmtDecl_setStmt(CXTopLevelStmtDecl TLSD, CXStmt S) {
  reinterpret_cast<clang::TopLevelStmtDecl *>(TLSD)->setStmt(reinterpret_cast<clang::Stmt *>(S));
}

bool clang_TopLevelStmtDecl_isSemiMissing(CXTopLevelStmtDecl TLSD) {
  return reinterpret_cast<clang::TopLevelStmtDecl *>(TLSD)->isSemiMissing();
}

void clang_TopLevelStmtDecl_setSemiMissing(CXTopLevelStmtDecl TLSD, bool Missing) {
  reinterpret_cast<clang::TopLevelStmtDecl *>(TLSD)->setSemiMissing(Missing);
}

bool clang_TopLevelStmtDecl_classofKind(CXDeclKind K) {
  return clang::TopLevelStmtDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

CXBlockDecl clang_BlockDecl_Create(CXASTContext C, CXDeclContext DC, CXSourceLocation_ L) {
  return reinterpret_cast<CXBlockDecl>(clang::BlockDecl::Create(*reinterpret_cast<clang::ASTContext *>(C),
                                  reinterpret_cast<clang::DeclContext *>(DC),
                                  clang::SourceLocation::getFromPtrEncoding(L)));
}

CXBlockDecl clang_BlockDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return reinterpret_cast<CXBlockDecl>(clang::BlockDecl::CreateDeserialized(*reinterpret_cast<clang::ASTContext *>(C), ID));
}

CXSourceLocation_ clang_BlockDecl_getCaretLocation(CXBlockDecl BD) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::BlockDecl *>(BD)->getCaretLocation().getPtrEncoding());
}

bool clang_BlockDecl_isVariadic(CXBlockDecl BD) {
  return reinterpret_cast<clang::BlockDecl *>(BD)->isVariadic();
}

void clang_BlockDecl_setBody(CXBlockDecl BD, CXCompoundStmt B) {
  reinterpret_cast<clang::BlockDecl *>(BD)->setBody(reinterpret_cast<clang::CompoundStmt *>(B));
}

void clang_BlockDecl_setSignatureAsWritten(CXBlockDecl BD, CXTypeSourceInfo Sig) {
  reinterpret_cast<clang::BlockDecl *>(BD)->setSignatureAsWritten(
      reinterpret_cast<clang::TypeSourceInfo *>(Sig));
}

CXTypeSourceInfo clang_BlockDecl_getSignatureAsWritten(CXBlockDecl BD) {
  return reinterpret_cast<CXTypeSourceInfo>(reinterpret_cast<clang::BlockDecl *>(BD)->getSignatureAsWritten());
}

unsigned clang_BlockDecl_getNumParams(CXBlockDecl BD) {
  return reinterpret_cast<clang::BlockDecl *>(BD)->getNumParams();
}

CXParmVarDecl clang_BlockDecl_getParamDecl(CXBlockDecl BD, unsigned i) {
  return reinterpret_cast<CXParmVarDecl>(reinterpret_cast<clang::BlockDecl *>(BD)->getParamDecl(i));
}

void clang_BlockDecl_setParams(CXBlockDecl BD, CXParmVarDecl *NewParamInfo,
                               unsigned NumParams) {
  llvm::SmallVector<clang::ParmVarDecl *, 8> Params;
  Params.reserve(NumParams);
  for (unsigned i = 0; i < NumParams; ++i)
    Params.push_back(reinterpret_cast<clang::ParmVarDecl *>(NewParamInfo[i]));
  reinterpret_cast<clang::BlockDecl *>(BD)->setParams(Params);
}

// setParams

bool clang_BlockDecl_hasCaptures(CXBlockDecl BD) {
  return reinterpret_cast<clang::BlockDecl *>(BD)->hasCaptures();
}

unsigned clang_BlockDecl_getNumCaptures(CXBlockDecl BD) {
  return reinterpret_cast<clang::BlockDecl *>(BD)->getNumCaptures();
}

bool clang_BlockDecl_capturesCXXThis(CXBlockDecl BD) {
  return reinterpret_cast<clang::BlockDecl *>(BD)->capturesCXXThis();
}

void clang_BlockDecl_setCapturesCXXThis(CXBlockDecl BD, bool B) {
  reinterpret_cast<clang::BlockDecl *>(BD)->setCapturesCXXThis(B);
}

bool clang_BlockDecl_blockMissingReturnType(CXBlockDecl BD) {
  return reinterpret_cast<clang::BlockDecl *>(BD)->blockMissingReturnType();
}

void clang_BlockDecl_setBlockMissingReturnType(CXBlockDecl BD, bool val) {
  reinterpret_cast<clang::BlockDecl *>(BD)->setBlockMissingReturnType(val);
}

bool clang_BlockDecl_isConversionFromLambda(CXBlockDecl BD) {
  return reinterpret_cast<clang::BlockDecl *>(BD)->isConversionFromLambda();
}

void clang_BlockDecl_setIsConversionFromLambda(CXBlockDecl BD, bool val) {
  reinterpret_cast<clang::BlockDecl *>(BD)->setIsConversionFromLambda(val);
}

bool clang_BlockDecl_doesNotEscape(CXBlockDecl BD) {
  return reinterpret_cast<clang::BlockDecl *>(BD)->doesNotEscape();
}

void clang_BlockDecl_setDoesNotEscape(CXBlockDecl BD, bool B) {
  reinterpret_cast<clang::BlockDecl *>(BD)->setDoesNotEscape(B);
}

bool clang_BlockDecl_canAvoidCopyToHeap(CXBlockDecl BD) {
  return reinterpret_cast<clang::BlockDecl *>(BD)->canAvoidCopyToHeap();
}

void clang_BlockDecl_setCanAvoidCopyToHeap(CXBlockDecl BD, bool B) {
  reinterpret_cast<clang::BlockDecl *>(BD)->setCanAvoidCopyToHeap(B);
}

bool clang_BlockDecl_capturesVariable(CXBlockDecl BD, CXVarDecl var) {
  return reinterpret_cast<clang::BlockDecl *>(BD)->capturesVariable(
      reinterpret_cast<clang::VarDecl *>(var));
}


void clang_BlockDecl_setCaptures(CXBlockDecl BD, CXASTContext C, CXVarDecl *Variables,
                                 bool *ByRefs, bool *Nesteds, CXExpr *CopyExprs,
                                 unsigned NumCaptures, bool CapturesCXXThis) {
  llvm::SmallVector<clang::BlockDecl::Capture, 4> Captures;
  Captures.reserve(NumCaptures);
  for (unsigned i = 0; i < NumCaptures; ++i)
    Captures.emplace_back(reinterpret_cast<clang::VarDecl *>(Variables[i]), ByRefs[i],
                          Nesteds[i], reinterpret_cast<clang::Expr *>(CopyExprs[i]));
  reinterpret_cast<clang::BlockDecl *>(BD)->setCaptures(*reinterpret_cast<clang::ASTContext *>(C),
                                                   Captures, CapturesCXXThis);
}

void clang_BlockDecl_setIsVariadic(CXBlockDecl BD, bool value) {
  reinterpret_cast<clang::BlockDecl *>(BD)->setIsVariadic(value);
}

CXCompoundStmt clang_BlockDecl_getCompoundBody(CXBlockDecl BD) {
  return reinterpret_cast<CXCompoundStmt>(reinterpret_cast<clang::BlockDecl *>(BD)->getCompoundBody());
}

CXStmt clang_BlockDecl_getBody(CXBlockDecl BD) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::BlockDecl *>(BD)->getBody());
}

CXVarDecl clang_BlockDecl_getCaptureVariable(CXBlockDecl BD, unsigned i) {
  return reinterpret_cast<CXVarDecl>(reinterpret_cast<clang::BlockDecl *>(BD)->capture_begin()[i].getVariable());
}

bool clang_BlockDecl_isCaptureByRef(CXBlockDecl BD, unsigned i) {
  return reinterpret_cast<clang::BlockDecl *>(BD)->capture_begin()[i].isByRef();
}

bool clang_BlockDecl_isCaptureNested(CXBlockDecl BD, unsigned i) {
  return reinterpret_cast<clang::BlockDecl *>(BD)->capture_begin()[i].isNested();
}

bool clang_BlockDecl_isCaptureEscapingByref(CXBlockDecl BD, unsigned i) {
  return reinterpret_cast<clang::BlockDecl *>(BD)->capture_begin()[i].isEscapingByref();
}

bool clang_BlockDecl_isCaptureNonEscapingByref(CXBlockDecl BD, unsigned i) {
  return reinterpret_cast<clang::BlockDecl *>(BD)->capture_begin()[i].isNonEscapingByref();
}

bool clang_BlockDecl_captureHasCopyExpr(CXBlockDecl BD, unsigned i) {
  return reinterpret_cast<clang::BlockDecl *>(BD)->capture_begin()[i].hasCopyExpr();
}

CXExpr clang_BlockDecl_getCaptureCopyExpr(CXBlockDecl BD, unsigned i) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::BlockDecl *>(BD)->capture_begin()[i].getCopyExpr());
}

void clang_BlockDecl_setCaptureCopyExpr(CXBlockDecl BD, unsigned i, CXExpr E) {
  const clang::BlockDecl::Capture *Captures =
      reinterpret_cast<clang::BlockDecl *>(BD)->capture_begin();
  const_cast<clang::BlockDecl::Capture *>(Captures)[i].setCopyExpr(
      reinterpret_cast<clang::Expr *>(E));
}

unsigned clang_BlockDecl_getBlockManglingNumber(CXBlockDecl BD) {
  return reinterpret_cast<clang::BlockDecl *>(BD)->getBlockManglingNumber();
}

CXDecl clang_BlockDecl_getBlockManglingContextDecl(CXBlockDecl BD) {
  return reinterpret_cast<CXDecl>(reinterpret_cast<clang::BlockDecl *>(BD)->getBlockManglingContextDecl());
}

void clang_BlockDecl_setBlockMangling(CXBlockDecl BD, unsigned Number, CXDecl Ctx) {
  reinterpret_cast<clang::BlockDecl *>(BD)->setBlockMangling(Number,
                                                        reinterpret_cast<clang::Decl *>(Ctx));
}

CXSourceRange_ clang_BlockDecl_getSourceRange(CXBlockDecl BD) {
  auto rng = reinterpret_cast<clang::BlockDecl *>(BD)->getSourceRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

bool clang_BlockDecl_classofKind(CXDeclKind K) {
  return clang::BlockDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// BlockDecl Cast
CXDeclContext clang_BlockDecl_castToDeclContext(CXBlockDecl BD) {
  return reinterpret_cast<CXDeclContext>(clang::BlockDecl::castToDeclContext(reinterpret_cast<clang::BlockDecl *>(BD)));
}

CXBlockDecl clang_BlockDecl_castFromDeclContext(CXDeclContext DC) {
  return reinterpret_cast<CXBlockDecl>(clang::BlockDecl::castFromDeclContext(reinterpret_cast<clang::DeclContext *>(DC)));
}

// CapturedDecl
CXCapturedDecl clang_CapturedDecl_Create(CXASTContext C, CXDeclContext DC,
                                         unsigned NumParams) {
  return reinterpret_cast<CXCapturedDecl>(clang::CapturedDecl::Create(*reinterpret_cast<clang::ASTContext *>(C),
                                     reinterpret_cast<clang::DeclContext *>(DC), NumParams));
}

CXCapturedDecl clang_CapturedDecl_CreateDeserialized(CXASTContext C, unsigned ID,
                                                     unsigned NumParams) {
  return reinterpret_cast<CXCapturedDecl>(clang::CapturedDecl::CreateDeserialized(*reinterpret_cast<clang::ASTContext *>(C), ID,
                                                 NumParams));
}

CXStmt clang_CapturedDecl_getBody(CXCapturedDecl CD) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::CapturedDecl *>(CD)->getBody());
}

void clang_CapturedDecl_setBody(CXCapturedDecl CD, CXStmt B) {
  reinterpret_cast<clang::CapturedDecl *>(CD)->setBody(reinterpret_cast<clang::Stmt *>(B));
}

bool clang_CapturedDecl_isNothrow(CXCapturedDecl CD) {
  return reinterpret_cast<clang::CapturedDecl *>(CD)->isNothrow();
}

void clang_CapturedDecl_setNothrow(CXCapturedDecl CD, bool Nothrow) {
  reinterpret_cast<clang::CapturedDecl *>(CD)->setNothrow(Nothrow);
}

unsigned clang_CapturedDecl_getNumParams(CXCapturedDecl CD) {
  return reinterpret_cast<clang::CapturedDecl *>(CD)->getNumParams();
}

CXImplicitParamDecl clang_CapturedDecl_getParam(CXCapturedDecl CD, unsigned i) {
  return reinterpret_cast<CXImplicitParamDecl>(reinterpret_cast<clang::CapturedDecl *>(CD)->getParam(i));
}

void clang_CapturedDecl_setParam(CXCapturedDecl CD, unsigned i, CXImplicitParamDecl P) {
  reinterpret_cast<clang::CapturedDecl *>(CD)->setParam(
      i, reinterpret_cast<clang::ImplicitParamDecl *>(P));
}

CXImplicitParamDecl clang_CapturedDecl_getContextParam(CXCapturedDecl CD) {
  return reinterpret_cast<CXImplicitParamDecl>(reinterpret_cast<clang::CapturedDecl *>(CD)->getContextParam());
}

void clang_CapturedDecl_setContextParam(CXCapturedDecl CD, unsigned i,
                                        CXImplicitParamDecl P) {
  reinterpret_cast<clang::CapturedDecl *>(CD)->setContextParam(
      i, reinterpret_cast<clang::ImplicitParamDecl *>(P));
}

unsigned clang_CapturedDecl_getContextParamPosition(CXCapturedDecl CD) {
  return reinterpret_cast<clang::CapturedDecl *>(CD)->getContextParamPosition();
}

bool clang_CapturedDecl_classofKind(CXDeclKind K) {
  return clang::CapturedDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// CapturedDecl Cast
CXDeclContext clang_CapturedDecl_castToDeclContext(CXCapturedDecl CD) {
  return reinterpret_cast<CXDeclContext>(clang::CapturedDecl::castToDeclContext(reinterpret_cast<clang::CapturedDecl *>(CD)));
}

CXCapturedDecl clang_CapturedDecl_castFromDeclContext(CXDeclContext DC) {
  return reinterpret_cast<CXCapturedDecl>(clang::CapturedDecl::castFromDeclContext(reinterpret_cast<clang::DeclContext *>(DC)));
}

// ImportDecl
CXImportDecl clang_ImportDecl_CreateImplicit(CXASTContext C, CXDeclContext DC,
                                             CXSourceLocation_ StartLoc, CXModule_ Imported,
                                             CXSourceLocation_ EndLoc) {
  return reinterpret_cast<CXImportDecl>(clang::ImportDecl::CreateImplicit(
      *reinterpret_cast<clang::ASTContext *>(C), reinterpret_cast<clang::DeclContext *>(DC),
      clang::SourceLocation::getFromPtrEncoding(StartLoc),
      reinterpret_cast<clang::Module *>(Imported),
      clang::SourceLocation::getFromPtrEncoding(EndLoc)));
}

CXImportDecl clang_ImportDecl_CreateDeserialized(CXASTContext C, unsigned ID,
                                                 unsigned NumLocations) {
  return reinterpret_cast<CXImportDecl>(clang::ImportDecl::CreateDeserialized(*reinterpret_cast<clang::ASTContext *>(C), ID,
                                               NumLocations));
}

CXModule_ clang_ImportDecl_getImportedModule(CXImportDecl ID) {
  return reinterpret_cast<CXModule_>(reinterpret_cast<clang::ImportDecl *>(ID)->getImportedModule());
}

// getIdentifierLocs
unsigned clang_ImportDecl_getNumIdentifierLocs(CXImportDecl ID) {
  return reinterpret_cast<clang::ImportDecl *>(ID)->getIdentifierLocs().size();
}

CXSourceLocation_ clang_ImportDecl_getIdentifierLoc(CXImportDecl ID, unsigned i) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::ImportDecl *>(ID)->getIdentifierLocs()[i].getPtrEncoding());
}

CXSourceRange_ clang_ImportDecl_getSourceRange(CXImportDecl ID) {
  auto rng = reinterpret_cast<clang::ImportDecl *>(ID)->getSourceRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

bool clang_ImportDecl_classofKind(CXDeclKind K) {
  return clang::ImportDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// ExportDecl
CXExportDecl clang_ExportDecl_Create(CXASTContext C, CXDeclContext DC,
                                     CXSourceLocation_ ExportLoc) {
  return reinterpret_cast<CXExportDecl>(clang::ExportDecl::Create(*reinterpret_cast<clang::ASTContext *>(C),
                                   reinterpret_cast<clang::DeclContext *>(DC),
                                   clang::SourceLocation::getFromPtrEncoding(ExportLoc)));
}

CXExportDecl clang_ExportDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return reinterpret_cast<CXExportDecl>(clang::ExportDecl::CreateDeserialized(*reinterpret_cast<clang::ASTContext *>(C), ID));
}

CXSourceLocation_ clang_ExportDecl_getExportLoc(CXExportDecl ED) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::ExportDecl *>(ED)->getExportLoc().getPtrEncoding());
}

CXSourceLocation_ clang_ExportDecl_getRBraceLoc(CXExportDecl ED) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::ExportDecl *>(ED)->getRBraceLoc().getPtrEncoding());
}

void clang_ExportDecl_setRBraceLoc(CXExportDecl ED, CXSourceLocation_ L) {
  reinterpret_cast<clang::ExportDecl *>(ED)->setRBraceLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

bool clang_ExportDecl_hasBraces(CXExportDecl ED) {
  return reinterpret_cast<clang::ExportDecl *>(ED)->hasBraces();
}

CXSourceLocation_ clang_ExportDecl_getEndLoc(CXExportDecl ED) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::ExportDecl *>(ED)->getEndLoc().getPtrEncoding());
}

CXSourceRange_ clang_ExportDecl_getSourceRange(CXExportDecl ED) {
  auto rng = reinterpret_cast<clang::ExportDecl *>(ED)->getSourceRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

bool clang_ExportDecl_classofKind(CXDeclKind K) {
  return clang::ExportDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// ExportDecl Cast
CXDeclContext clang_ExportDecl_castToDeclContext(CXExportDecl ED) {
  return reinterpret_cast<CXDeclContext>(clang::ExportDecl::castToDeclContext(reinterpret_cast<clang::ExportDecl *>(ED)));
}

CXExportDecl clang_ExportDecl_castFromDeclContext(CXDeclContext DC) {
  return reinterpret_cast<CXExportDecl>(clang::ExportDecl::castFromDeclContext(reinterpret_cast<clang::DeclContext *>(DC)));
}

// EmptyDecl
CXEmptyDecl clang_EmptyDecl_Create(CXASTContext C, CXDeclContext DC, CXSourceLocation_ L) {
  return reinterpret_cast<CXEmptyDecl>(clang::EmptyDecl::Create(*reinterpret_cast<clang::ASTContext *>(C),
                                  reinterpret_cast<clang::DeclContext *>(DC),
                                  clang::SourceLocation::getFromPtrEncoding(L)));
}

CXEmptyDecl clang_EmptyDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return reinterpret_cast<CXEmptyDecl>(clang::EmptyDecl::CreateDeserialized(*reinterpret_cast<clang::ASTContext *>(C), ID));
}

bool clang_EmptyDecl_classofKind(CXDeclKind K) {
  return clang::EmptyDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}
// HLSLBufferDecl
CXHLSLBufferDecl clang_HLSLBufferDecl_Create(CXASTContext C, CXDeclContext LexicalParent,
                                             bool CBuffer, CXSourceLocation_ KwLoc,
                                             CXIdentifierInfo ID, CXSourceLocation_ IDLoc,
                                             CXSourceLocation_ LBrace) {
  return reinterpret_cast<CXHLSLBufferDecl>(clang::HLSLBufferDecl::Create(*reinterpret_cast<clang::ASTContext *>(C),
                                       reinterpret_cast<clang::DeclContext *>(LexicalParent),
                                       CBuffer,
                                       clang::SourceLocation::getFromPtrEncoding(KwLoc),
                                       reinterpret_cast<clang::IdentifierInfo *>(ID),
                                       clang::SourceLocation::getFromPtrEncoding(IDLoc),
                                       clang::SourceLocation::getFromPtrEncoding(LBrace)));
}

CXHLSLBufferDecl clang_HLSLBufferDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return reinterpret_cast<CXHLSLBufferDecl>(clang::HLSLBufferDecl::CreateDeserialized(*reinterpret_cast<clang::ASTContext *>(C),
                                                   ID));
}

CXSourceRange_ clang_HLSLBufferDecl_getSourceRange(CXHLSLBufferDecl BD) {
  auto rng = reinterpret_cast<clang::HLSLBufferDecl *>(BD)->getSourceRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

CXSourceLocation_ clang_HLSLBufferDecl_getLocStart(CXHLSLBufferDecl BD) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::HLSLBufferDecl *>(BD)->getLocStart().getPtrEncoding());
}

CXSourceLocation_ clang_HLSLBufferDecl_getLBraceLoc(CXHLSLBufferDecl BD) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::HLSLBufferDecl *>(BD)->getLBraceLoc().getPtrEncoding());
}

CXSourceLocation_ clang_HLSLBufferDecl_getRBraceLoc(CXHLSLBufferDecl BD) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::HLSLBufferDecl *>(BD)->getRBraceLoc().getPtrEncoding());
}

void clang_HLSLBufferDecl_setRBraceLoc(CXHLSLBufferDecl BD, CXSourceLocation_ L) {
  reinterpret_cast<clang::HLSLBufferDecl *>(BD)->setRBraceLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

bool clang_HLSLBufferDecl_isCBuffer(CXHLSLBufferDecl BD) {
  return reinterpret_cast<clang::HLSLBufferDecl *>(BD)->isCBuffer();
}

bool clang_HLSLBufferDecl_classofKind(CXDeclKind K) {
  return clang::HLSLBufferDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// HLSLBufferDecl Cast
CXDeclContext clang_HLSLBufferDecl_castToDeclContext(CXHLSLBufferDecl BD) {
  return reinterpret_cast<CXDeclContext>(clang::HLSLBufferDecl::castToDeclContext(reinterpret_cast<clang::HLSLBufferDecl *>(BD)));
}

CXHLSLBufferDecl clang_HLSLBufferDecl_castFromDeclContext(CXDeclContext DC) {
  return reinterpret_cast<CXHLSLBufferDecl>(clang::HLSLBufferDecl::castFromDeclContext(reinterpret_cast<clang::DeclContext *>(DC)));
}
