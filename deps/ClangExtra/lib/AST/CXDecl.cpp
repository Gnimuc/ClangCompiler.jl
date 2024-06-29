#include "clang-ex/AST/CXDecl.h"
#include "clang/AST/ASTContext.h"
#include "clang/AST/ASTContextAllocate.h"
#include "clang/AST/Decl.h"
#include "llvm/ExecutionEngine/GenericValue.h"

// TranslationUnitDecl
CXASTContext clang_TranslationUnitDecl_getASTContext(CXTranslationUnitDecl TUD) {
  return &static_cast<clang::TranslationUnitDecl *>(TUD)->getASTContext();
}

CXNamespaceDecl clang_TranslationUnitDecl_getAnonymousNamespace(CXTranslationUnitDecl TUD) {
  return static_cast<clang::TranslationUnitDecl *>(TUD)->getAnonymousNamespace();
}

void clang_TranslationUnitDecl_setAnonymousNamespace(CXTranslationUnitDecl TUD,
                                                     CXNamespaceDecl ND) {
  static_cast<clang::TranslationUnitDecl *>(TUD)->setAnonymousNamespace(
      static_cast<clang::NamespaceDecl *>(ND));
}

CXTranslationUnitDecl clang_TranslationUnitDecl_Create(CXASTContext C) {
  return clang::TranslationUnitDecl::Create(*static_cast<clang::ASTContext *>(C));
}

// PragmaCommentDecl
CXPragmaCommentDecl clang_PragmaCommentDecl_Create(CXASTContext C, CXTranslationUnitDecl DC,
                                                   CXSourceLocation_ CommentLoc,
                                                   CXPragmaMSCommentKind CommentKind,
                                                   const char *Arg) {
  return clang::PragmaCommentDecl::Create(
      *static_cast<clang::ASTContext *>(C), static_cast<clang::TranslationUnitDecl *>(DC),
      clang::SourceLocation::getFromPtrEncoding(CommentLoc),
      static_cast<clang::PragmaMSCommentKind>(CommentKind), llvm::StringRef(Arg));
}

CXPragmaCommentDecl clang_PragmaCommentDecl_CreateDeserialized(CXASTContext C, unsigned ID,
                                                               unsigned ArgSize) {
  return clang::PragmaCommentDecl::CreateDeserialized(*static_cast<clang::ASTContext *>(C),
                                                      ID, ArgSize);
}

CXPragmaMSCommentKind clang_PragmaCommentDecl_getCommentKind(CXPragmaCommentDecl PCD) {
  return static_cast<CXPragmaMSCommentKind>(
      static_cast<clang::PragmaCommentDecl *>(PCD)->getCommentKind());
}

const char *clang_PragmaCommentDecl_getArg(CXPragmaCommentDecl PCD) {
  return static_cast<clang::PragmaCommentDecl *>(PCD)->getArg().data();
}

// PragmaDetectMismatchDecl
CXPragmaDetectMismatchDecl clang_PragmaDetectMismatchDecl_Create(CXASTContext C,
                                                                 CXTranslationUnitDecl DC,
                                                                 CXSourceLocation_ Loc,
                                                                 const char *Name,
                                                                 const char *Value) {
  return clang::PragmaDetectMismatchDecl::Create(
      *static_cast<clang::ASTContext *>(C), static_cast<clang::TranslationUnitDecl *>(DC),
      clang::SourceLocation::getFromPtrEncoding(Loc), llvm::StringRef(Name),
      llvm::StringRef(Value));
}

CXPragmaDetectMismatchDecl
clang_PragmaDetectMismatchDecl_CreateDeserialized(CXASTContext C, unsigned ID,
                                                  unsigned NameValueSize) {
  return clang::PragmaDetectMismatchDecl::CreateDeserialized(
      *static_cast<clang::ASTContext *>(C), ID, NameValueSize);
}

const char *clang_PragmaDetectMismatchDecl_getName(CXPragmaDetectMismatchDecl PDMD) {
  return static_cast<clang::PragmaDetectMismatchDecl *>(PDMD)->getName().data();
}

const char *clang_PragmaDetectMismatchDecl_getValue(CXPragmaDetectMismatchDecl PDMD) {
  return static_cast<clang::PragmaDetectMismatchDecl *>(PDMD)->getValue().data();
}

// ExternCContextDecl
CXExternCContextDecl clang_ExternCContextDecl_Create(CXASTContext C,
                                                     CXTranslationUnitDecl TU) {
  return clang::ExternCContextDecl::Create(*static_cast<clang::ASTContext *>(C),
                                           static_cast<clang::TranslationUnitDecl *>(TU));
}

// NamedDecl
CXIdentifierInfo clang_NamedDecl_getIdentifier(CXNamedDecl ND) {
  return static_cast<clang::NamedDecl *>(ND)->getIdentifier();
}

const char *clang_NamedDecl_getName(CXNamedDecl ND) {
  return static_cast<clang::NamedDecl *>(ND)->getName().data();
}

CXDeclarationName clang_NamedDecl_getDeclName(CXNamedDecl ND) {
  return static_cast<clang::NamedDecl *>(ND)->getDeclName().getAsOpaquePtr();
}

void clang_NamedDecl_setDeclName(CXNamedDecl ND, CXDeclarationName DN) {
  return static_cast<clang::NamedDecl *>(ND)->setDeclName(
      clang::DeclarationName::getFromOpaquePtr(DN));
}

bool clang_NamedDecl_declarationReplaces(CXNamedDecl ND, CXNamedDecl OldD,
                                         bool IsKnownNewer) {
  return static_cast<clang::NamedDecl *>(ND)->declarationReplaces(
      static_cast<clang::NamedDecl *>(OldD), IsKnownNewer);
}

bool clang_NamedDecl_hasLinkage(CXNamedDecl ND) {
  return static_cast<clang::NamedDecl *>(ND)->hasLinkage();
}

bool clang_NamedDecl_isCXXClassMember(CXNamedDecl ND) {
  return static_cast<clang::NamedDecl *>(ND)->isCXXClassMember();
}

bool clang_NamedDecl_isCXXInstanceMember(CXNamedDecl ND) {
  return static_cast<clang::NamedDecl *>(ND)->isCXXInstanceMember();
}

CXLinkage clang_NamedDecl_getLinkageInternal(CXNamedDecl ND) {
  return static_cast<CXLinkage>(static_cast<clang::NamedDecl *>(ND)->getLinkageInternal());
}

CXLinkage clang_NamedDecl_getFormalLinkage(CXNamedDecl ND) {
  return static_cast<CXLinkage>(static_cast<clang::NamedDecl *>(ND)->getFormalLinkage());
}

bool clang_NamedDecl_hasExternalFormalLinkage(CXNamedDecl ND) {
  return static_cast<clang::NamedDecl *>(ND)->hasExternalFormalLinkage();
}

bool clang_NamedDecl_isExternallyVisible(CXNamedDecl ND) {
  return static_cast<clang::NamedDecl *>(ND)->isExternallyVisible();
}

bool clang_NamedDecl_isExternallyDeclarable(CXNamedDecl ND) {
  return static_cast<clang::NamedDecl *>(ND)->isExternallyDeclarable();
}

CXVisibility clang_NamedDecl_getVisibility(CXNamedDecl ND) {
  return static_cast<CXVisibility>(static_cast<clang::NamedDecl *>(ND)->getVisibility());
}

// getLinkageAndVisibility
// getExplicitVisibility

bool clang_NamedDecl_isLinkageValid(CXNamedDecl ND) {
  return static_cast<clang::NamedDecl *>(ND)->isLinkageValid();
}

bool clang_NamedDecl_hasLinkageBeenComputed(CXNamedDecl ND) {
  return static_cast<clang::NamedDecl *>(ND)->hasLinkageBeenComputed();
}

CXNamedDecl clang_NamedDecl_getUnderlyingDecl(CXNamedDecl ND) {
  return static_cast<clang::NamedDecl *>(ND)->getUnderlyingDecl();
}

CXNamedDecl clang_NamedDecl_getMostRecentDecl(CXNamedDecl ND) {
  return static_cast<clang::NamedDecl *>(ND)->getMostRecentDecl();
}

// getObjCFStringFormattingFamily

// NamedDecl Cast
CXTypeDecl clang_NamedDecl_castToTypeDecl(CXNamedDecl ND) {
  return llvm::dyn_cast<clang::TypeDecl>(static_cast<clang::NamedDecl *>(ND));
}

// LabelDecl
CXLabelDecl clang_LabelDecl_Create(CXASTContext C, CXDeclContext DC,
                                   CXSourceLocation_ IdentL, CXIdentifierInfo II) {
  return clang::LabelDecl::Create(*static_cast<clang::ASTContext *>(C),
                                  static_cast<clang::DeclContext *>(DC),
                                  clang::SourceLocation::getFromPtrEncoding(IdentL),
                                  static_cast<clang::IdentifierInfo *>(II));
}

CXLabelDecl clang_LabelDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return clang::LabelDecl::CreateDeserialized(*static_cast<clang::ASTContext *>(C), ID);
}

CXLabelStmt clang_LabelDecl_getStmt(CXLabelDecl LD) {
  return static_cast<clang::LabelDecl *>(LD)->getStmt();
}

void clang_LabelDecl_setStmt(CXLabelDecl LD, CXLabelStmt T) {
  static_cast<clang::LabelDecl *>(LD)->setStmt(static_cast<clang::LabelStmt *>(T));
}

bool clang_LabelDecl_isGnuLocal(CXLabelDecl LD) {
  return static_cast<clang::LabelDecl *>(LD)->isGnuLocal();
}

void clang_LabelDecl_setLocStart(CXLabelDecl LD, CXSourceLocation_ Loc) {
  static_cast<clang::LabelDecl *>(LD)->setLocStart(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

CXSourceRange_ clang_LabelDecl_getSourceRange(CXLabelDecl LD) {
  auto rng = static_cast<clang::LabelDecl *>(LD)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

bool clang_LabelDecl_isMSAsmLabel(CXLabelDecl LD) {
  return static_cast<clang::LabelDecl *>(LD)->isMSAsmLabel();
}

bool clang_LabelDecl_isResolvedMSAsmLabel(CXLabelDecl LD) {
  return static_cast<clang::LabelDecl *>(LD)->isResolvedMSAsmLabel();
}

// setMSAsmLabel

const char *clang_LabelDecl_getMSAsmLabel(CXLabelDecl LD) {
  return static_cast<clang::LabelDecl *>(LD)->getMSAsmLabel().data();
}

void clang_LabelDecl_setMSAsmLabelResolved(CXLabelDecl LD) {
  static_cast<clang::LabelDecl *>(LD)->setMSAsmLabelResolved();
}

// NamespaceDecl
CXNamespaceDecl clang_NamespaceDecl_Create(CXASTContext C, CXDeclContext DC, bool Inline,
                                           CXSourceLocation_ StartLoc,
                                           CXSourceLocation_ IdLoc, CXIdentifierInfo Id,
                                           CXNamespaceDecl PrevDecl) {
  return clang::NamespaceDecl::Create(*static_cast<clang::ASTContext *>(C),
                                      static_cast<clang::DeclContext *>(DC), Inline,
                                      clang::SourceLocation::getFromPtrEncoding(StartLoc),
                                      clang::SourceLocation::getFromPtrEncoding(IdLoc),
                                      static_cast<clang::IdentifierInfo *>(Id),
                                      static_cast<clang::NamespaceDecl *>(PrevDecl));
}

CXNamespaceDecl clang_NamespaceDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return clang::NamespaceDecl::CreateDeserialized(*static_cast<clang::ASTContext *>(C), ID);
}

bool clang_NamespaceDecl_isAnonymousNamespace(CXNamespaceDecl ND) {
  return static_cast<clang::NamespaceDecl *>(ND)->isAnonymousNamespace();
}

bool clang_NamespaceDecl_isInline(CXNamespaceDecl ND) {
  return static_cast<clang::NamespaceDecl *>(ND)->isInline();
}

void clang_NamespaceDecl_setInline(CXNamespaceDecl ND, bool Inline) {
  return static_cast<clang::NamespaceDecl *>(ND)->setInline(Inline);
}

CXNamespaceDecl clang_NamespaceDecl_getOriginalNamespace(CXNamespaceDecl ND) {
  return static_cast<clang::NamespaceDecl *>(ND)->getOriginalNamespace();
}

bool clang_NamespaceDecl_isOriginalNamespace(CXNamespaceDecl ND) {
  return static_cast<clang::NamespaceDecl *>(ND)->isOriginalNamespace();
}

CXNamespaceDecl clang_NamespaceDecl_getAnonymousNamespace(CXNamespaceDecl ND) {
  return static_cast<clang::NamespaceDecl *>(ND)->getAnonymousNamespace();
}

void clang_NamespaceDecl_setAnonymousNamespace(CXNamespaceDecl ND, CXNamespaceDecl D) {
  static_cast<clang::NamespaceDecl *>(ND)->setAnonymousNamespace(
      static_cast<clang::NamespaceDecl *>(D));
}

CXNamespaceDecl clang_NamespaceDecl_getCanonicalDecl(CXNamespaceDecl ND) {
  return static_cast<clang::NamespaceDecl *>(ND)->getCanonicalDecl();
}

CXSourceRange_ clang_NamespaceDecl_getSourceRange(CXNamespaceDecl ND) {
  auto rng = static_cast<clang::NamespaceDecl *>(ND)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

CXSourceLocation_ clang_NamespaceDecl_getBeginLoc(CXNamespaceDecl ND) {
  return static_cast<clang::NamespaceDecl *>(ND)->getBeginLoc().getPtrEncoding();
}

CXSourceLocation_ clang_NamespaceDecl_getRBraceLoc(CXNamespaceDecl ND) {
  return static_cast<clang::NamespaceDecl *>(ND)->getRBraceLoc().getPtrEncoding();
}

void clang_NamespaceDecl_setLocStart(CXNamespaceDecl ND, CXSourceLocation_ Loc) {
  static_cast<clang::NamespaceDecl *>(ND)->setLocStart(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_NamespaceDecl_setRBraceLoc(CXNamespaceDecl ND, CXSourceLocation_ Loc) {
  static_cast<clang::NamespaceDecl *>(ND)->setRBraceLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

// ValueDecl
CXQualType clang_ValueDecl_getType(CXValueDecl VD) {
  return static_cast<clang::ValueDecl *>(VD)->getType().getAsOpaquePtr();
}

void clang_ValueDecl_setType(CXValueDecl VD, CXQualType OpaquePtr) {
  static_cast<clang::ValueDecl *>(VD)->setType(
      clang::QualType::getFromOpaquePtr(OpaquePtr));
}

bool clang_ValueDecl_isWeak(CXValueDecl VD) {
  return static_cast<clang::ValueDecl *>(VD)->isWeak();
}

// DeclaratorDecl
CXTypeSourceInfo clang_DeclaratorDecl_getTypeSourceInfo(CXDeclaratorDecl DD) {
  return static_cast<clang::DeclaratorDecl *>(DD)->getTypeSourceInfo();
}

void clang_DeclaratorDecl_setTypeSourceInfo(CXDeclaratorDecl DD, CXTypeSourceInfo TI) {
  static_cast<clang::DeclaratorDecl *>(DD)->setTypeSourceInfo(
      static_cast<clang::TypeSourceInfo *>(TI));
}

CXSourceLocation_ clang_DeclaratorDecl_getInnerLocStart(CXDeclaratorDecl DD) {
  return static_cast<clang::DeclaratorDecl *>(DD)->getInnerLocStart().getPtrEncoding();
}

void clang_DeclaratorDecl_setInnerLocStart(CXDeclaratorDecl DD, CXSourceLocation_ Loc) {
  static_cast<clang::DeclaratorDecl *>(DD)->setInnerLocStart(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

CXSourceLocation_ clang_DeclaratorDecl_getOuterLocStart(CXDeclaratorDecl DD) {
  return static_cast<clang::DeclaratorDecl *>(DD)->getOuterLocStart().getPtrEncoding();
}

CXSourceLocation_ clang_DeclaratorDecl_getBeginLoc(CXDeclaratorDecl DD) {
  return static_cast<clang::DeclaratorDecl *>(DD)->getBeginLoc().getPtrEncoding();
}

CXNestedNameSpecifier clang_DeclaratorDecl_getQualifier(CXDeclaratorDecl DD) {
  return static_cast<clang::DeclaratorDecl *>(DD)->getQualifier();
}

// getQualifierLoc
// setQualifierInfo

CXExpr clang_DeclaratorDecl_getTrailingRequiresClause(CXDeclaratorDecl DD) {
  return static_cast<clang::DeclaratorDecl *>(DD)->getTrailingRequiresClause();
}

void clang_DeclaratorDecl_setTrailingRequiresClause(CXDeclaratorDecl DD,
                                                    CXExpr TrailingRequiresClause) {
  return static_cast<clang::DeclaratorDecl *>(DD)->setTrailingRequiresClause(
      static_cast<clang::Expr *>(TrailingRequiresClause));
}

unsigned clang_DeclaratorDecl_getNumTemplateParameterLists(CXDeclaratorDecl DD) {
  return static_cast<clang::DeclaratorDecl *>(DD)->getNumTemplateParameterLists();
}

CXTemplateParameterList clang_DeclaratorDecl_getTemplateParameterList(CXDeclaratorDecl DD,
                                                                      unsigned index) {
  return static_cast<clang::DeclaratorDecl *>(DD)->getTemplateParameterList(index);
}

// setTemplateParameterListsInfo

CXSourceLocation_ clang_DeclaratorDecl_getTypeSpecStartLoc(CXDeclaratorDecl DD) {
  return static_cast<clang::DeclaratorDecl *>(DD)->getTypeSpecStartLoc().getPtrEncoding();
}

CXSourceLocation_ clang_DeclaratorDecl_getTypeSpecEndLoc(CXDeclaratorDecl DD) {
  return static_cast<clang::DeclaratorDecl *>(DD)->getTypeSpecEndLoc().getPtrEncoding();
}

// VarDecl
CXVarDecl clang_VarDecl_Create(CXASTContext C, CXDeclContext DC, CXSourceLocation_ StartLoc,
                               CXSourceLocation_ IdLoc, CXIdentifierInfo Id, CXQualType T,
                               CXTypeSourceInfo TInfo, CXStorageClass S) {
  return clang::VarDecl::Create(
      *static_cast<clang::ASTContext *>(C), static_cast<clang::DeclContext *>(DC),
      clang::SourceLocation::getFromPtrEncoding(StartLoc),
      clang::SourceLocation::getFromPtrEncoding(IdLoc),
      static_cast<clang::IdentifierInfo *>(Id), clang::QualType::getFromOpaquePtr(T),
      static_cast<clang::TypeSourceInfo *>(TInfo), static_cast<clang::StorageClass>(S));
}

CXVarDecl clang_VarDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return clang::VarDecl::CreateDeserialized(*static_cast<clang::ASTContext *>(C), ID);
}

CXSourceRange_ clang_VarDecl_getSourceRange(CXVarDecl VD) {
  auto rng = static_cast<clang::VarDecl *>(VD)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

CXStorageClass clang_VarDecl_getStorageClass(CXVarDecl VD) {
  return static_cast<CXStorageClass>(static_cast<clang::VarDecl *>(VD)->getStorageClass());
}

void clang_VarDecl_setStorageClass(CXVarDecl VD, CXStorageClass SC) {
  static_cast<clang::VarDecl *>(VD)->setStorageClass(static_cast<clang::StorageClass>(SC));
}

void clang_VarDecl_setTSCSpec(CXVarDecl VD, CXThreadStorageClassSpecifier TSC) {
  static_cast<clang::VarDecl *>(VD)->setTSCSpec(
      static_cast<clang::ThreadStorageClassSpecifier>(TSC));
}

CXThreadStorageClassSpecifier clang_VarDecl_getTSCSpec(CXVarDecl VD) {
  return static_cast<CXThreadStorageClassSpecifier>(
      static_cast<clang::VarDecl *>(VD)->getTSCSpec());
}

// getTLSKind

bool clang_VarDecl_hasLocalStorage(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->hasLocalStorage();
}

bool clang_VarDecl_isStaticLocal(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->isStaticLocal();
}

bool clang_VarDecl_hasExternalStorage(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->hasExternalStorage();
}

bool clang_VarDecl_hasGlobalStorage(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->hasGlobalStorage();
}

CXStorageDuration clang_VarDecl_getStorageDuration(CXVarDecl VD) {
  return static_cast<CXStorageDuration>(
      static_cast<clang::VarDecl *>(VD)->getStorageDuration());
}

CXLanguageLinkage clang_VarDecl_getLanguageLinkage(CXVarDecl VD) {
  return static_cast<CXLanguageLinkage>(
      static_cast<clang::VarDecl *>(VD)->getLanguageLinkage());
}

bool clang_VarDecl_isExternC(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->isExternC();
}

bool clang_VarDecl_isInExternCContext(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->isInExternCContext();
}

bool clang_VarDecl_isInExternCXXContext(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->isInExternCXXContext();
}

bool clang_VarDecl_isLocalVarDecl(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->isLocalVarDecl();
}

bool clang_VarDecl_isLocalVarDeclOrParm(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->isLocalVarDeclOrParm();
}

bool clang_VarDecl_isFunctionOrMethodVarDecl(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->isFunctionOrMethodVarDecl();
}

bool clang_VarDecl_isStaticDataMember(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->isStaticDataMember();
}

CXVarDecl clang_VarDecl_getCanonicalDecl(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->getCanonicalDecl();
}

// isThisDeclarationADefinition
// hasDefinition

CXVarDecl clang_VarDecl_getActingDefinition(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->getActingDefinition();
}

CXVarDecl clang_VarDecl_getDefinition(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->getDefinition();
}

bool clang_VarDecl_isOutOfLine(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->isOutOfLine();
}

bool clang_VarDecl_isFileVarDecl(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->isFileVarDecl();
}

CXExpr clang_VarDecl_getAnyInitializer(CXVarDecl VD) {
  return const_cast<clang::Expr *>(static_cast<clang::VarDecl *>(VD)->getAnyInitializer());
}

bool clang_VarDecl_hasInit(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->hasInit();
}

CXExpr clang_VarDecl_getInit(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->getInit();
}

// getInitAddress

void clang_VarDecl_setInit(CXVarDecl VD, CXExpr I) {
  static_cast<clang::VarDecl *>(VD)->setInit(static_cast<clang::Expr *>(I));
}

CXVarDecl clang_VarDecl_getInitializingDeclaration(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->getInitializingDeclaration();
}

bool clang_VarDecl_mightBeUsableInConstantExpressions(CXVarDecl VD, CXASTContext C) {
  return static_cast<clang::VarDecl *>(VD)->mightBeUsableInConstantExpressions(
      *static_cast<clang::ASTContext *>(C));
}

bool clang_VarDecl_isUsableInConstantExpressions(CXVarDecl VD, CXASTContext C) {
  return static_cast<clang::VarDecl *>(VD)->isUsableInConstantExpressions(
      *static_cast<clang::ASTContext *>(C));
}

CXEvaluatedStmt clang_VarDecl_ensureEvaluatedStmt(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->ensureEvaluatedStmt();
}

CXEvaluatedStmt clang_VarDecl_getEvaluatedStmt(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->getEvaluatedStmt();
}

// evaluateValue
// getEvaluatedValue
// evaluateDestruction

bool clang_VarDecl_hasConstantInitialization(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->hasConstantInitialization();
}

bool clang_VarDecl_hasICEInitializer(CXVarDecl VD, CXASTContext Context) {
  return static_cast<clang::VarDecl *>(VD)->hasICEInitializer(
      *static_cast<clang::ASTContext *>(Context));
}

// checkForConstantInitialization
// setInitStyle
// getInitStyle

bool clang_VarDecl_isDirectInit(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->isDirectInit();
}

bool clang_VarDecl_isThisDeclarationADemotedDefinition(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->isThisDeclarationADemotedDefinition();
}

void clang_VarDecl_demoteThisDefinitionToDeclaration(CXVarDecl VD) {
  static_cast<clang::VarDecl *>(VD)->demoteThisDefinitionToDeclaration();
}

bool clang_VarDecl_isExceptionVariable(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->isExceptionVariable();
}

void clang_VarDecl_setExceptionVariable(CXVarDecl VD, bool EV) {
  static_cast<clang::VarDecl *>(VD)->setExceptionVariable(EV);
}

bool clang_VarDecl_isNRVOVariable(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->isNRVOVariable();
}

void clang_VarDecl_setNRVOVariable(CXVarDecl VD, bool NRVO) {
  static_cast<clang::VarDecl *>(VD)->setNRVOVariable(NRVO);
}

bool clang_VarDecl_isCXXForRangeDecl(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->isCXXForRangeDecl();
}

void clang_VarDecl_setCXXForRangeDecl(CXVarDecl VD, bool FRD) {
  static_cast<clang::VarDecl *>(VD)->setCXXForRangeDecl(FRD);
}

bool clang_VarDecl_isObjCForDecl(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->isObjCForDecl();
}

void clang_VarDecl_setObjCForDecl(CXVarDecl VD, bool FRD) {
  static_cast<clang::VarDecl *>(VD)->setObjCForDecl(FRD);
}

bool clang_VarDecl_isARCPseudoStrong(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->isARCPseudoStrong();
}

void clang_VarDecl_setARCPseudoStrong(CXVarDecl VD, bool PS) {
  static_cast<clang::VarDecl *>(VD)->setARCPseudoStrong(PS);
}

bool clang_VarDecl_isInline(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->isInline();
}

bool clang_VarDecl_isInlineSpecified(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->isInlineSpecified();
}

void clang_VarDecl_setInlineSpecified(CXVarDecl VD) {
  static_cast<clang::VarDecl *>(VD)->setInlineSpecified();
}

void clang_VarDecl_setImplicitlyInline(CXVarDecl VD) {
  static_cast<clang::VarDecl *>(VD)->setImplicitlyInline();
}

bool clang_VarDecl_isConstexpr(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->isConstexpr();
}

void clang_VarDecl_setConstexpr(CXVarDecl VD, bool IC) {
  static_cast<clang::VarDecl *>(VD)->setConstexpr(IC);
}

bool clang_VarDecl_isInitCapture(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->isInitCapture();
}

void clang_VarDecl_setInitCapture(CXVarDecl VD, bool IC) {
  static_cast<clang::VarDecl *>(VD)->setInitCapture(IC);
}

bool clang_VarDecl_isParameterPack(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->isParameterPack();
}

bool clang_VarDecl_isPreviousDeclInSameBlockScope(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->isPreviousDeclInSameBlockScope();
}

void clang_VarDecl_setPreviousDeclInSameBlockScope(CXVarDecl VD, bool Same) {
  static_cast<clang::VarDecl *>(VD)->setPreviousDeclInSameBlockScope(Same);
}

bool clang_VarDecl_isEscapingByref(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->isEscapingByref();
}

bool clang_VarDecl_isNonEscapingByref(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->isNonEscapingByref();
}

void clang_VarDecl_setEscapingByref(CXVarDecl VD) {
  static_cast<clang::VarDecl *>(VD)->setEscapingByref();
}

CXVarDecl clang_VarDecl_getTemplateInstantiationPattern(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->getTemplateInstantiationPattern();
}

CXVarDecl clang_VarDecl_getInstantiatedFromStaticDataMember(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->getInstantiatedFromStaticDataMember();
}

CXTemplateSpecializationKind clang_VarDecl_getTemplateSpecializationKind(CXVarDecl VD) {
  return static_cast<CXTemplateSpecializationKind>(
      static_cast<clang::VarDecl *>(VD)->getTemplateSpecializationKind());
}

CXTemplateSpecializationKind
clang_VarDecl_getTemplateSpecializationKindForInstantiation(CXVarDecl VD) {
  return static_cast<CXTemplateSpecializationKind>(
      static_cast<clang::VarDecl *>(VD)->getTemplateSpecializationKindForInstantiation());
}

CXSourceLocation_ clang_VarDecl_getPointOfInstantiation(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->getPointOfInstantiation().getPtrEncoding();
}

// getMemberSpecializationInfo

void clang_VarDecl_setTemplateSpecializationKind(CXVarDecl VD,
                                                 CXTemplateSpecializationKind TSK,
                                                 CXSourceLocation_ PointOfInstantiation) {
  static_cast<clang::VarDecl *>(VD)->setTemplateSpecializationKind(
      static_cast<clang::TemplateSpecializationKind>(TSK),
      clang::SourceLocation::getFromPtrEncoding(PointOfInstantiation));
}

void clang_VarDecl_setInstantiationOfStaticDataMember(CXVarDecl VD, CXVarDecl VD2,
                                                      CXTemplateSpecializationKind TSK) {
  static_cast<clang::VarDecl *>(VD)->setInstantiationOfStaticDataMember(
      static_cast<clang::VarDecl *>(VD2),
      static_cast<clang::TemplateSpecializationKind>(TSK));
}

CXVarTemplateDecl clang_VarDecl_getDescribedVarTemplate(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->getDescribedVarTemplate();
}

void clang_VarDecl_setDescribedVarTemplate(CXVarDecl VD, CXVarTemplateDecl Template) {
  static_cast<clang::VarDecl *>(VD)->setDescribedVarTemplate(
      static_cast<clang::VarTemplateDecl *>(Template));
}

bool clang_VarDecl_isKnownToBeDefined(CXVarDecl VD) {
  return static_cast<clang::VarDecl *>(VD)->isKnownToBeDefined();
}

bool clang_VarDecl_isNoDestroy(CXVarDecl VD, CXASTContext AST) {
  return static_cast<clang::VarDecl *>(VD)->isNoDestroy(
      *static_cast<clang::ASTContext *>(AST));
}

// needsDestruction

// ImplicitParamDecl
CXImplicitParamDecl
clang_ImplicitParamDecl_Create(CXASTContext C, CXDeclContext DC, CXSourceLocation_ IdLoc,
                               CXIdentifierInfo Id, CXQualType T,
                               CXImplicitParamDecl_ImplicitParamKind ParamKind) {
  return clang::ImplicitParamDecl::Create(
      *static_cast<clang::ASTContext *>(C), static_cast<clang::DeclContext *>(DC),
      clang::SourceLocation::getFromPtrEncoding(IdLoc),
      static_cast<clang::IdentifierInfo *>(Id), clang::QualType::getFromOpaquePtr(T),
      static_cast<clang::ImplicitParamDecl::ImplicitParamKind>(ParamKind));
}

CXImplicitParamDecl clang_ImplicitParamDecl_CreateDeserialized(CXASTContext C,
                                                               unsigned ID) {
  return clang::ImplicitParamDecl::CreateDeserialized(*static_cast<clang::ASTContext *>(C),
                                                      ID);
}

CXImplicitParamDecl_ImplicitParamKind
clang_ImplicitParamDecl_getParameterKind(CXImplicitParamDecl IPD) {
  return static_cast<CXImplicitParamDecl_ImplicitParamKind>(
      static_cast<clang::ImplicitParamDecl *>(IPD)->getParameterKind());
}

// ParmVarDecl
CXParmVarDecl clang_ParmVarDecl_Create(CXASTContext C, CXDeclContext DC,
                                       CXSourceLocation_ StartLoc, CXSourceLocation_ IdLoc,
                                       CXIdentifierInfo Id, CXQualType T,
                                       CXTypeSourceInfo TInfo, CXStorageClass S,
                                       CXExpr DefArg) {
  return clang::ParmVarDecl::Create(
      *static_cast<clang::ASTContext *>(C), static_cast<clang::DeclContext *>(DC),
      clang::SourceLocation::getFromPtrEncoding(StartLoc),
      clang::SourceLocation::getFromPtrEncoding(IdLoc),
      static_cast<clang::IdentifierInfo *>(Id), clang::QualType::getFromOpaquePtr(T),
      static_cast<clang::TypeSourceInfo *>(TInfo), static_cast<clang::StorageClass>(S),
      static_cast<clang::Expr *>(DefArg));
}

CXParmVarDecl clang_ParmVarDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return clang::ParmVarDecl::CreateDeserialized(*static_cast<clang::ASTContext *>(C), ID);
}

void clang_ParmVarDecl_setObjCMethodScopeInfo(CXParmVarDecl PVD, unsigned parameterIndex) {
  static_cast<clang::ParmVarDecl *>(PVD)->setObjCMethodScopeInfo(parameterIndex);
}

void clang_ParmVarDecl_setScopeInfo(CXParmVarDecl PVD, unsigned scopeDepth,
                                    unsigned parameterIndex) {
  static_cast<clang::ParmVarDecl *>(PVD)->setScopeInfo(scopeDepth, parameterIndex);
}

bool clang_ParmVarDecl_isObjCMethodParameter(CXParmVarDecl PVD) {
  return static_cast<clang::ParmVarDecl *>(PVD)->isObjCMethodParameter();
}

bool clang_ParmVarDecl_isDestroyedInCallee(CXParmVarDecl PVD) {
  return static_cast<clang::ParmVarDecl *>(PVD)->isDestroyedInCallee();
}

unsigned clang_ParmVarDecl_getFunctionScopeDepth(CXParmVarDecl PVD) {
  return static_cast<clang::ParmVarDecl *>(PVD)->getFunctionScopeDepth();
}

unsigned clang_ParmVarDecl_getFunctionScopeIndex(CXParmVarDecl PVD) {
  return static_cast<clang::ParmVarDecl *>(PVD)->getFunctionScopeIndex();
}

// getObjCDeclQualifier
// setObjCDeclQualifier

bool clang_ParmVarDecl_isKNRPromoted(CXParmVarDecl PVD) {
  return static_cast<clang::ParmVarDecl *>(PVD)->isKNRPromoted();
}

void clang_ParmVarDecl_setKNRPromoted(CXParmVarDecl PVD, bool promoted) {
  static_cast<clang::ParmVarDecl *>(PVD)->setKNRPromoted(promoted);
}

CXExpr clang_ParmVarDecl_getDefaultArg(CXParmVarDecl PVD) {
  return static_cast<clang::ParmVarDecl *>(PVD)->getDefaultArg();
}

void clang_ParmVarDecl_setDefaultArg(CXParmVarDecl PVD, CXExpr defarg) {
  static_cast<clang::ParmVarDecl *>(PVD)->setDefaultArg(static_cast<clang::Expr *>(defarg));
}

CXSourceRange_ clang_ParmVarDecl_getDefaultArgRange(CXParmVarDecl PVD) {
  auto rng = static_cast<clang::ParmVarDecl *>(PVD)->getDefaultArgRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

void clang_ParmVarDecl_setUninstantiatedDefaultArg(CXParmVarDecl PVD, CXExpr arg) {
  static_cast<clang::ParmVarDecl *>(PVD)->setUninstantiatedDefaultArg(
      static_cast<clang::Expr *>(arg));
}

CXExpr clang_ParmVarDecl_getUninstantiatedDefaultArg(CXParmVarDecl PVD) {
  return static_cast<clang::ParmVarDecl *>(PVD)->getUninstantiatedDefaultArg();
}

bool clang_ParmVarDecl_hasDefaultArg(CXParmVarDecl PVD) {
  return static_cast<clang::ParmVarDecl *>(PVD)->hasDefaultArg();
}

bool clang_ParmVarDecl_hasUnparsedDefaultArg(CXParmVarDecl PVD) {
  return static_cast<clang::ParmVarDecl *>(PVD)->hasUnparsedDefaultArg();
}

bool clang_ParmVarDecl_hasUninstantiatedDefaultArg(CXParmVarDecl PVD) {
  return static_cast<clang::ParmVarDecl *>(PVD)->hasUninstantiatedDefaultArg();
}

void clang_ParmVarDecl_setUnparsedDefaultArg(CXParmVarDecl PVD) {
  static_cast<clang::ParmVarDecl *>(PVD)->setUnparsedDefaultArg();
}

bool clang_ParmVarDecl_hasInheritedDefaultArg(CXParmVarDecl PVD) {
  return static_cast<clang::ParmVarDecl *>(PVD)->hasInheritedDefaultArg();
}

void clang_ParmVarDecl_setHasInheritedDefaultArg(CXParmVarDecl PVD, bool I) {
  static_cast<clang::ParmVarDecl *>(PVD)->setHasInheritedDefaultArg(I);
}

CXQualType clang_ParmVarDecl_getOriginalType(CXParmVarDecl PVD) {
  return static_cast<clang::ParmVarDecl *>(PVD)->getOriginalType().getAsOpaquePtr();
}

void clang_ParmVarDecl_setOwningFunction(CXParmVarDecl PVD, CXDeclContext FD) {
  static_cast<clang::ParmVarDecl *>(PVD)->setOwningFunction(
      static_cast<clang::DeclContext *>(FD));
}

// FunctionDecl
CXFunctionDecl clang_FunctionDecl_Create(CXASTContext C, CXDeclContext DC,
                                         CXSourceLocation_ StartLoc, CXSourceLocation_ NLoc,
                                         CXDeclarationName N, CXQualType T,
                                         CXTypeSourceInfo TInfo, CXStorageClass SC,
                                         bool isInlineSpecified, bool hasWrittenPrototype) {
  return clang::FunctionDecl::Create(
      *static_cast<clang::ASTContext *>(C), static_cast<clang::DeclContext *>(DC),
      clang::SourceLocation::getFromPtrEncoding(StartLoc),
      clang::SourceLocation::getFromPtrEncoding(NLoc),
      clang::DeclarationName::getFromOpaquePtr(N), clang::QualType::getFromOpaquePtr(T),
      static_cast<clang::TypeSourceInfo *>(TInfo), static_cast<clang::StorageClass>(SC),
      isInlineSpecified, hasWrittenPrototype);
}

CXFunctionDecl clang_FunctionDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return clang::FunctionDecl::CreateDeserialized(*static_cast<clang::ASTContext *>(C), ID);
}

// getNameInfo
// getNameForDiagnostic

void clang_FunctionDecl_setRangeEnd(CXFunctionDecl FD, CXSourceLocation_ Loc) {
  static_cast<clang::FunctionDecl *>(FD)->setRangeEnd(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

CXSourceLocation_ clang_FunctionDecl_getEllipsisLoc(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->getEllipsisLoc().getPtrEncoding();
}

CXSourceRange_ clang_FunctionDecl_getSourceRange(CXFunctionDecl FD) {
  auto rng = static_cast<clang::FunctionDecl *>(FD)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

// bool clang_FunctionDecl_hasBody(CXFunctionDecl FD, CXFunctionDecl Definition) {
//   return static_cast<clang::FunctionDecl *>(FD)->hasBody(
//       static_cast<clang::FunctionDecl *>(Definition));
// }

bool clang_FunctionDecl_hasBody(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->hasBody();
}

bool clang_FunctionDecl_hasTrivialBody(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->hasTrivialBody();
}

bool clang_FunctionDecl_isDefined(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isDefined();
}

CXFunctionDecl clang_FunctionDecl_getDefinition(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->getDefinition();
}

CXStmt clang_FunctionDecl_getBody(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->getBody();
}

bool clang_FunctionDecl_isThisDeclarationADefinition(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isThisDeclarationADefinition();
}

bool clang_FunctionDecl_isThisDeclarationInstantiatedFromAFriendDefinition(
    CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)
      ->isThisDeclarationInstantiatedFromAFriendDefinition();
}

bool clang_FunctionDecl_doesThisDeclarationHaveABody(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->doesThisDeclarationHaveABody();
}

void clang_FunctionDecl_setBody(CXFunctionDecl FD, CXStmt B) {
  static_cast<clang::FunctionDecl *>(FD)->setBody(static_cast<clang::Stmt *>(B));
}

void clang_FunctionDecl_setLazyBody(CXFunctionDecl FD, uint64_t Offset) {
  static_cast<clang::FunctionDecl *>(FD)->setLazyBody(Offset);
}

void clang_FunctionDecl_setDefaultedFunctionInfo(
    CXFunctionDecl FD, CXFunctionDecl_DefaultedFunctionInfo Info) {
  static_cast<clang::FunctionDecl *>(FD)->setDefaultedFunctionInfo(
      static_cast<clang::FunctionDecl::DefaultedFunctionInfo *>(Info));
}

bool clang_FunctionDecl_isVariadic(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isVariadic();
}

bool clang_FunctionDecl_isVirtualAsWritten(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isVirtualAsWritten();
}

void clang_FunctionDecl_setVirtualAsWritten(CXFunctionDecl FD, bool V) {
  static_cast<clang::FunctionDecl *>(FD)->setVirtualAsWritten(V);
}

bool clang_FunctionDecl_isPure(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isPure();
}

void clang_FunctionDecl_setPure(CXFunctionDecl FD, bool P) {
  static_cast<clang::FunctionDecl *>(FD)->setPure(P);
}

bool clang_FunctionDecl_isLateTemplateParsed(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isLateTemplateParsed();
}

void clang_FunctionDecl_setLateTemplateParsed(CXFunctionDecl FD, bool ILT) {
  static_cast<clang::FunctionDecl *>(FD)->setLateTemplateParsed(ILT);
}

bool clang_FunctionDecl_isTrivial(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isTrivial();
}

void clang_FunctionDecl_setTrivial(CXFunctionDecl FD, bool IT) {
  static_cast<clang::FunctionDecl *>(FD)->setTrivial(IT);
}

bool clang_FunctionDecl_isTrivialForCall(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isTrivialForCall();
}

void clang_FunctionDecl_setTrivialForCall(CXFunctionDecl FD, bool IT) {
  static_cast<clang::FunctionDecl *>(FD)->setTrivialForCall(IT);
}

bool clang_FunctionDecl_isDefaulted(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isDefaulted();
}

void clang_FunctionDecl_setDefaulted(CXFunctionDecl FD, bool D) {
  static_cast<clang::FunctionDecl *>(FD)->setDefaulted(D);
}

bool clang_FunctionDecl_isExplicitlyDefaulted(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isExplicitlyDefaulted();
}

void clang_FunctionDecl_setExplicitlyDefaulted(CXFunctionDecl FD, bool ED) {
  static_cast<clang::FunctionDecl *>(FD)->setExplicitlyDefaulted(ED);
}

bool clang_FunctionDecl_isUserProvided(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isUserProvided();
}

bool clang_FunctionDecl_hasImplicitReturnZero(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->hasImplicitReturnZero();
}

void clang_FunctionDecl_setHasImplicitReturnZero(CXFunctionDecl FD, bool IRZ) {
  static_cast<clang::FunctionDecl *>(FD)->setHasImplicitReturnZero(IRZ);
}

bool clang_FunctionDecl_hasPrototype(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->hasPrototype();
}

bool clang_FunctionDecl_hasWrittenPrototype(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->hasWrittenPrototype();
}

void clang_FunctionDecl_setHasWrittenPrototype(CXFunctionDecl FD, bool P) {
  static_cast<clang::FunctionDecl *>(FD)->setHasWrittenPrototype(P);
}

bool clang_FunctionDecl_hasInheritedPrototype(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->hasInheritedPrototype();
}

void clang_FunctionDecl_setHasInheritedPrototype(CXFunctionDecl FD, bool P) {
  static_cast<clang::FunctionDecl *>(FD)->setHasInheritedPrototype(P);
}

bool clang_FunctionDecl_isConstexpr(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isConstexpr();
}

void clang_FunctionDecl_setConstexprKind(CXFunctionDecl FD, CXConstexprSpecKind CSK) {
  static_cast<clang::FunctionDecl *>(FD)->setConstexprKind(
      static_cast<clang::ConstexprSpecKind>(CSK));
}

CXConstexprSpecKind clang_FunctionDecl_getConstexprKind(CXFunctionDecl FD) {
  return static_cast<CXConstexprSpecKind>(
      static_cast<clang::FunctionDecl *>(FD)->getConstexprKind());
}

bool clang_FunctionDecl_isConstexprSpecified(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isConstexprSpecified();
}

bool clang_FunctionDecl_isConsteval(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isConsteval();
}

bool clang_FunctionDecl_instantiationIsPending(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->instantiationIsPending();
}

void clang_FunctionDecl_setInstantiationIsPending(CXFunctionDecl FD, bool IC) {
  static_cast<clang::FunctionDecl *>(FD)->setInstantiationIsPending(IC);
}

bool clang_FunctionDecl_usesSEHTry(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->usesSEHTry();
}

void clang_FunctionDecl_setUsesSEHTry(CXFunctionDecl FD, bool UST) {
  static_cast<clang::FunctionDecl *>(FD)->setUsesSEHTry(UST);
}

bool clang_FunctionDecl_isDeleted(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isDeleted();
}

bool clang_FunctionDecl_isDeletedAsWritten(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isDeletedAsWritten();
}

void clang_FunctionDecl_setDeletedAsWritten(CXFunctionDecl FD, bool D) {
  static_cast<clang::FunctionDecl *>(FD)->setDeletedAsWritten(D);
}

bool clang_FunctionDecl_isMain(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isMain();
}

bool clang_FunctionDecl_isMSVCRTEntryPoint(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isMSVCRTEntryPoint();
}

bool clang_FunctionDecl_isReservedGlobalPlacementOperator(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isReservedGlobalPlacementOperator();
}

bool clang_FunctionDecl_isReplaceableGlobalAllocationFunction(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isReplaceableGlobalAllocationFunction();
}

bool clang_FunctionDecl_isInlineBuiltinDeclaration(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isInlineBuiltinDeclaration();
}

bool clang_FunctionDecl_isDestroyingOperatorDelete(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isDestroyingOperatorDelete();
}

CXLanguageLinkage clang_FunctionDecl_getLanguageLinkage(CXFunctionDecl FD) {
  return static_cast<CXLanguageLinkage>(
      static_cast<clang::FunctionDecl *>(FD)->getLanguageLinkage());
}

bool clang_FunctionDecl_isExternC(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isExternC();
}

bool clang_FunctionDecl_isInExternCContext(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isInExternCContext();
}

bool clang_FunctionDecl_isInExternCXXContext(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isInExternCXXContext();
}

bool clang_FunctionDecl_isGlobal(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isGlobal();
}

bool clang_FunctionDecl_isNoReturn(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isNoReturn();
}

bool clang_FunctionDecl_hasSkippedBody(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->hasSkippedBody();
}

void clang_FunctionDecl_setHasSkippedBody(CXFunctionDecl FD, bool Skipped) {
  static_cast<clang::FunctionDecl *>(FD)->setHasSkippedBody(Skipped);
}

bool clang_FunctionDecl_willHaveBody(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->willHaveBody();
}

void clang_FunctionDecl_setWillHaveBody(CXFunctionDecl FD, bool V) {
  static_cast<clang::FunctionDecl *>(FD)->setWillHaveBody(V);
}

bool clang_FunctionDecl_isMultiVersion(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isMultiVersion();
}

void clang_FunctionDecl_setIsMultiVersion(CXFunctionDecl FD, bool V) {
  static_cast<clang::FunctionDecl *>(FD)->setIsMultiVersion(V);
}

CXMultiVersionKind clang_FunctionDecl_getMultiVersionKind(CXFunctionDecl FD) {
  return static_cast<CXMultiVersionKind>(
      static_cast<clang::FunctionDecl *>(FD)->getMultiVersionKind());
}

bool clang_FunctionDecl_isCPUDispatchMultiVersion(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isCPUDispatchMultiVersion();
}

bool clang_FunctionDecl_isCPUSpecificMultiVersion(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isCPUSpecificMultiVersion();
}

bool clang_FunctionDecl_isTargetMultiVersion(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isTargetMultiVersion();
}

// getAssociatedConstraints

void clang_FunctionDecl_setPreviousDeclaration(CXFunctionDecl FD, CXFunctionDecl PrevDecl) {
  static_cast<clang::FunctionDecl *>(FD)->setPreviousDeclaration(
      static_cast<clang::FunctionDecl *>(PrevDecl));
}

CXFunctionDecl clang_FunctionDecl_getCanonicalDecl(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->getCanonicalDecl();
}

unsigned clang_FunctionDecl_getBuiltinID(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->getBuiltinID();
}

// parameters

unsigned clang_FunctionDecl_getNumParams(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->getNumParams();
}

CXParmVarDecl clang_FunctionDecl_getParamDecl(CXFunctionDecl FD, unsigned i) {
  return static_cast<clang::FunctionDecl *>(FD)->getParamDecl(i);
}

// setParams

unsigned clang_FunctionDecl_getMinRequiredArguments(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->getMinRequiredArguments();
}

bool clang_FunctionDecl_hasOneParamOrDefaultArgs(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->hasOneParamOrDefaultArgs();
}

// getFunctionTypeLoc

CXQualType clang_FunctionDecl_getReturnType(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->getReturnType().getAsOpaquePtr();
}

CXSourceRange_ clang_FunctionDecl_getReturnTypeSourceRange(CXFunctionDecl FD) {
  auto rng = static_cast<clang::FunctionDecl *>(FD)->getReturnTypeSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

CXSourceRange_ clang_FunctionDecl_getParametersSourceRange(CXFunctionDecl FD) {
  auto rng = static_cast<clang::FunctionDecl *>(FD)->getParametersSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

CXQualType clang_FunctionDecl_getDeclaredReturnType(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->getDeclaredReturnType().getAsOpaquePtr();
}

CXExceptionSpecificationType clang_FunctionDecl_getExceptionSpecType(CXFunctionDecl FD) {
  return static_cast<CXExceptionSpecificationType>(
      static_cast<clang::FunctionDecl *>(FD)->getExceptionSpecType());
}

CXSourceRange_ clang_FunctionDecl_getExceptionSpecSourceRange(CXFunctionDecl FD) {
  auto rng = static_cast<clang::FunctionDecl *>(FD)->getExceptionSpecSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

CXQualType clang_FunctionDecl_getCallResultType(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->getCallResultType().getAsOpaquePtr();
}

CXStorageClass clang_FunctionDecl_getStorageClass(CXFunctionDecl FD) {
  return static_cast<CXStorageClass>(
      static_cast<clang::FunctionDecl *>(FD)->getStorageClass());
}

void clang_FunctionDecl_setStorageClass(CXFunctionDecl FD, CXStorageClass SClass) {
  static_cast<clang::FunctionDecl *>(FD)->setStorageClass(
      static_cast<clang::StorageClass>(SClass));
}

bool clang_FunctionDecl_isInlineSpecified(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isInlineSpecified();
}

void clang_FunctionDecl_setInlineSpecified(CXFunctionDecl FD, bool I) {
  static_cast<clang::FunctionDecl *>(FD)->setInlineSpecified(I);
}

void clang_FunctionDecl_setImplicitlyInline(CXFunctionDecl FD, bool I) {
  static_cast<clang::FunctionDecl *>(FD)->setImplicitlyInline(I);
}

bool clang_FunctionDecl_isInlined(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isInlined();
}

bool clang_FunctionDecl_isInlineDefinitionExternallyVisible(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isInlineDefinitionExternallyVisible();
}

bool clang_FunctionDecl_isMSExternInline(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isMSExternInline();
}

bool clang_FunctionDecl_doesDeclarationForceExternallyVisibleDefinition(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)
      ->doesDeclarationForceExternallyVisibleDefinition();
}

bool clang_FunctionDecl_isStatic(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isStatic();
}

bool clang_FunctionDecl_isOverloadedOperator(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isOverloadedOperator();
}

// getOverloadedOperator

CXIdentifierInfo clang_FunctionDecl_getLiteralIdentifier(CXFunctionDecl FD) {
  return const_cast<clang::IdentifierInfo *>(
      static_cast<clang::FunctionDecl *>(FD)->getLiteralIdentifier());
}

CXFunctionDecl_TemplatedKind clang_FunctionDecl_getTemplatedKind(CXFunctionDecl FD) {
  return static_cast<CXFunctionDecl_TemplatedKind>(
      static_cast<clang::FunctionDecl *>(FD)->getTemplatedKind());
}

CXMemberSpecializationInfo
clang_FunctionDecl_getMemberSpecializationInfo(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->getMemberSpecializationInfo();
}

void clang_FunctionDecl_setInstantiationOfMemberFunction(CXFunctionDecl FD,
                                                         CXFunctionDecl FD2,
                                                         CXTemplateSpecializationKind TSK) {
  static_cast<clang::FunctionDecl *>(FD)->setInstantiationOfMemberFunction(
      static_cast<clang::FunctionDecl *>(FD2),
      static_cast<clang::TemplateSpecializationKind>(TSK));
}

CXFunctionTemplateDecl clang_FunctionDecl_getDescribedFunctionTemplate(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->getDescribedFunctionTemplate();
}

void clang_FunctionDecl_setDescribedFunctionTemplate(CXFunctionDecl FD,
                                                     CXFunctionTemplateDecl Template) {
  static_cast<clang::FunctionDecl *>(FD)->setDescribedFunctionTemplate(
      static_cast<clang::FunctionTemplateDecl *>(Template));
}

CXFunctionDecl clang_FunctionDecl_getInstantiatedFromMemberFunction(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->getInstantiatedFromMemberFunction();
}

bool clang_FunctionDecl_isFunctionTemplateSpecialization(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isFunctionTemplateSpecialization();
}

CXFunctionTemplateSpecializationInfo
clang_FunctionDecl_getTemplateSpecializationInfo(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->getTemplateSpecializationInfo();
}

bool clang_FunctionDecl_isImplicitlyInstantiable(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isImplicitlyInstantiable();
}

bool clang_FunctionDecl_isTemplateInstantiation(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isTemplateInstantiation();
}

CXFunctionDecl clang_FunctionDecl_getTemplateInstantiationPattern(CXFunctionDecl FD,
                                                                  bool ForDefinition) {
  return static_cast<clang::FunctionDecl *>(FD)->getTemplateInstantiationPattern(
      ForDefinition);
}

CXFunctionTemplateDecl clang_FunctionDecl_getPrimaryTemplate(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->getPrimaryTemplate();
}

CXTemplateArgumentList clang_FunctionDecl_getTemplateSpecializationArgs(CXFunctionDecl FD) {
  return const_cast<clang::TemplateArgumentList *>(
      static_cast<clang::FunctionDecl *>(FD)->getTemplateSpecializationArgs());
}

CXASTTemplateArgumentListInfo
clang_FunctionDecl_getTemplateSpecializationArgsAsWritten(CXFunctionDecl FD) {
  return const_cast<clang::ASTTemplateArgumentListInfo *>(
      static_cast<clang::FunctionDecl *>(FD)->getTemplateSpecializationArgsAsWritten());
}

// setFunctionTemplateSpecialization
// setDependentTemplateSpecialization

CXDependentFunctionTemplateSpecializationInfo
clang_FunctionDecl_getDependentSpecializationInfo(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->getDependentSpecializationInfo();
}

CXTemplateSpecializationKind
clang_FunctionDecl_getTemplateSpecializationKind(CXFunctionDecl FD) {
  return static_cast<CXTemplateSpecializationKind>(
      static_cast<clang::FunctionDecl *>(FD)->getTemplateSpecializationKind());
}

CXTemplateSpecializationKind
clang_FunctionDecl_getTemplateSpecializationKindForInstantiation(CXFunctionDecl FD) {
  return static_cast<CXTemplateSpecializationKind>(
      static_cast<clang::FunctionDecl *>(FD)
          ->getTemplateSpecializationKindForInstantiation());
}

void clang_FunctionDecl_setTemplateSpecializationKind(
    CXFunctionDecl FD, CXTemplateSpecializationKind TSK,
    CXSourceLocation_ PointOfInstantiation) {
  static_cast<clang::FunctionDecl *>(FD)->setTemplateSpecializationKind(
      static_cast<clang::TemplateSpecializationKind>(TSK),
      clang::SourceLocation::getFromPtrEncoding(PointOfInstantiation));
}

CXSourceLocation_ clang_FunctionDecl_getPointOfInstantiation(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->getPointOfInstantiation().getPtrEncoding();
}

bool clang_FunctionDecl_isOutOfLine(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->isOutOfLine();
}

unsigned clang_FunctionDecl_getMemoryFunctionKind(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->getMemoryFunctionKind();
}

unsigned clang_FunctionDecl_getODRHash(CXFunctionDecl FD) {
  return static_cast<clang::FunctionDecl *>(FD)->getODRHash();
}

// FieldDecl
CXFieldDecl clang_FieldDecl_Create(CXASTContext C, CXDeclContext DC,
                                   CXSourceLocation_ StartLoc, CXSourceLocation_ IdLoc,
                                   CXIdentifierInfo I, CXQualType T, CXTypeSourceInfo TInfo,
                                   CXExpr BW, bool Mutable, CXInClassInitStyle InitStyle) {
  return clang::FieldDecl::Create(
      *static_cast<clang::ASTContext *>(C), static_cast<clang::DeclContext *>(DC),
      clang::SourceLocation::getFromPtrEncoding(StartLoc),
      clang::SourceLocation::getFromPtrEncoding(IdLoc),
      static_cast<clang::IdentifierInfo *>(I), clang::QualType::getFromOpaquePtr(T),
      static_cast<clang::TypeSourceInfo *>(TInfo), static_cast<clang::Expr *>(BW), Mutable,
      static_cast<clang::InClassInitStyle>(InitStyle));
}

CXFieldDecl clang_FieldDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return clang::FieldDecl::CreateDeserialized(*static_cast<clang::ASTContext *>(C), ID);
}

unsigned clang_FieldDecl_getFieldIndex(CXFieldDecl FD) {
  return static_cast<clang::FieldDecl *>(FD)->getFieldIndex();
}

bool clang_FieldDecl_isMutable(CXFieldDecl FD) {
  return static_cast<clang::FieldDecl *>(FD)->isMutable();
}

bool clang_FieldDecl_isBitField(CXFieldDecl FD) {
  return static_cast<clang::FieldDecl *>(FD)->isBitField();
}

bool clang_FieldDecl_isUnnamedBitfield(CXFieldDecl FD) {
  return static_cast<clang::FieldDecl *>(FD)->isUnnamedBitfield();
}

bool clang_FieldDecl_isAnonymousStructOrUnion(CXFieldDecl FD) {
  return static_cast<clang::FieldDecl *>(FD)->isAnonymousStructOrUnion();
}

CXExpr clang_FieldDecl_getBitWidth(CXFieldDecl FD) {
  return static_cast<clang::FieldDecl *>(FD)->getBitWidth();
}

unsigned clang_FieldDecl_getBitWidthValue(CXFieldDecl FD, CXASTContext Ctx) {
  return static_cast<clang::FieldDecl *>(FD)->getBitWidthValue(
      *static_cast<clang::ASTContext *>(Ctx));
}

void clang_FieldDecl_setBitWidth(CXFieldDecl FD, CXExpr Width) {
  static_cast<clang::FieldDecl *>(FD)->setBitWidth(static_cast<clang::Expr *>(Width));
}

void clang_FieldDecl_removeBitWidth(CXFieldDecl FD) {
  static_cast<clang::FieldDecl *>(FD)->removeBitWidth();
}

bool clang_FieldDecl_isZeroLengthBitField(CXFieldDecl FD, CXASTContext Ctx) {
  return static_cast<clang::FieldDecl *>(FD)->isZeroLengthBitField(
      *static_cast<clang::ASTContext *>(Ctx));
}

bool clang_FieldDecl_isZeroSize(CXFieldDecl FD, CXASTContext Ctx) {
  return static_cast<clang::FieldDecl *>(FD)->isZeroSize(
      *static_cast<clang::ASTContext *>(Ctx));
}

CXInClassInitStyle clang_FieldDecl_getInClassInitStyle(CXFieldDecl FD) {
  return static_cast<CXInClassInitStyle>(
      static_cast<clang::FieldDecl *>(FD)->getInClassInitStyle());
}

bool clang_FieldDecl_hasInClassInitializer(CXFieldDecl FD) {
  return static_cast<clang::FieldDecl *>(FD)->hasInClassInitializer();
}

CXExpr clang_FieldDecl_getInClassInitializer(CXFieldDecl FD) {
  return static_cast<clang::FieldDecl *>(FD)->getInClassInitializer();
}

void clang_FieldDecl_setInClassInitializer(CXFieldDecl FD, CXExpr Init) {
  static_cast<clang::FieldDecl *>(FD)->setInClassInitializer(
      static_cast<clang::Expr *>(Init));
}

void clang_FieldDecl_removeInClassInitializer(CXFieldDecl FD) {
  static_cast<clang::FieldDecl *>(FD)->removeInClassInitializer();
}

bool clang_FieldDecl_hasCapturedVLAType(CXFieldDecl FD) {
  return static_cast<clang::FieldDecl *>(FD)->hasCapturedVLAType();
}

CXVariableArrayType clang_FieldDecl_getCapturedVLAType(CXFieldDecl FD) {
  return const_cast<clang::VariableArrayType *>(
      static_cast<clang::FieldDecl *>(FD)->getCapturedVLAType());
}

void clang_FieldDecl_setCapturedVLAType(CXFieldDecl FD, CXVariableArrayType VLAType) {
  static_cast<clang::FieldDecl *>(FD)->setCapturedVLAType(
      static_cast<clang::VariableArrayType *>(VLAType));
}

CXRecordDecl clang_FieldDecl_getParent(CXFieldDecl FD) {
  return static_cast<clang::FieldDecl *>(FD)->getParent();
}

CXSourceRange_ clang_FieldDecl_getSourceRange(CXFieldDecl FD) {
  auto rng = static_cast<clang::FieldDecl *>(FD)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

CXFieldDecl clang_FieldDecl_getCanonicalDecl(CXFieldDecl FD) {
  return static_cast<clang::FieldDecl *>(FD)->getCanonicalDecl();
}

// EnumConstantDecl
CXEnumConstantDecl clang_EnumConstantDecl_Create(CXASTContext C, CXEnumDecl DC,
                                                 CXSourceLocation_ L, CXIdentifierInfo Id,
                                                 CXQualType T, CXExpr E,
                                                 LLVMGenericValueRef V) {
  return clang::EnumConstantDecl::Create(
      *static_cast<clang::ASTContext *>(C), static_cast<clang::EnumDecl *>(DC),
      clang::SourceLocation::getFromPtrEncoding(L),
      static_cast<clang::IdentifierInfo *>(Id), clang::QualType::getFromOpaquePtr(T),
      static_cast<clang::Expr *>(E),
      llvm::APSInt(reinterpret_cast<llvm::GenericValue *>(V)->IntVal));
}

CXEnumConstantDecl clang_EnumConstantDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return clang::EnumConstantDecl::CreateDeserialized(*static_cast<clang::ASTContext *>(C),
                                                     ID);
}

CXExpr clang_EnumConstantDecl_getInitExpr(CXEnumConstantDecl ECD) {
  return static_cast<clang::EnumConstantDecl *>(ECD)->getInitExpr();
}

// getInitVal

void clang_EnumConstantDecl_setInitExpr(CXEnumConstantDecl ECD, CXExpr E) {
  static_cast<clang::EnumConstantDecl *>(ECD)->setInitExpr(static_cast<clang::Expr *>(E));
}

// setInitVal

CXSourceRange_ clang_EnumConstantDecl_getSourceRange(CXEnumConstantDecl ECD) {
  auto rng = static_cast<clang::EnumConstantDecl *>(ECD)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

CXEnumConstantDecl clang_EnumConstantDecl_getCanonicalDecl(CXEnumConstantDecl ECD) {
  return static_cast<clang::EnumConstantDecl *>(ECD)->getCanonicalDecl();
}

// IndirectFieldDecl
CXIndirectFieldDecl clang_IndirectFieldDecl_CreateDeserialized(CXASTContext C,
                                                               unsigned ID) {
  return clang::IndirectFieldDecl::CreateDeserialized(*static_cast<clang::ASTContext *>(C),
                                                      ID);
}

// chain

unsigned clang_IndirectFieldDecl_getChainingSize(CXIndirectFieldDecl IFD) {
  return static_cast<clang::IndirectFieldDecl *>(IFD)->getChainingSize();
}

CXFieldDecl clang_IndirectFieldDecl_getAnonField(CXIndirectFieldDecl IFD) {
  return static_cast<clang::IndirectFieldDecl *>(IFD)->getAnonField();
}

CXVarDecl clang_IndirectFieldDecl_getVarDecl(CXIndirectFieldDecl IFD) {
  return static_cast<clang::IndirectFieldDecl *>(IFD)->getVarDecl();
}

CXIndirectFieldDecl clang_IndirectFieldDecl_getCanonicalDecl(CXIndirectFieldDecl IFD) {
  return static_cast<clang::IndirectFieldDecl *>(IFD)->getCanonicalDecl();
}

// TypeDecl
CXType_ clang_TypeDecl_getTypeForDecl(CXTypeDecl TD) {
  return const_cast<clang::Type *>(static_cast<clang::TypeDecl *>(TD)->getTypeForDecl());
}

void clang_TypeDecl_setTypeForDecl(CXTypeDecl TD, CXType_ Ty) {
  static_cast<clang::TypeDecl *>(TD)->setTypeForDecl(static_cast<clang::Type *>(Ty));
}

CXSourceLocation_ clang_TypeDecl_getBeginLoc(CXTypeDecl TD) {
  return static_cast<clang::TypeDecl *>(TD)->getBeginLoc().getPtrEncoding();
}

void clang_TypeDecl_setLocStart(CXTypeDecl TD, CXSourceLocation_ Loc) {
  static_cast<clang::TypeDecl *>(TD)->setLocStart(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

CXSourceRange_ clang_TypeDecl_getSourceRange(CXTypeDecl TD) {
  auto rng = static_cast<clang::TypeDecl *>(TD)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

// TypedefNameDecl
bool clang_TypedefNameDecl_isModed(CXTypedefNameDecl TND) {
  return static_cast<clang::TypedefNameDecl *>(TND)->isModed();
}

CXTypeSourceInfo clang_TypedefNameDecl_getTypeSourceInfo(CXTypedefNameDecl TND) {
  return static_cast<clang::TypedefNameDecl *>(TND)->getTypeSourceInfo();
}

CXQualType clang_TypedefNameDecl_getUnderlyingType(CXTypedefNameDecl TND) {
  return static_cast<clang::TypedefNameDecl *>(TND)->getUnderlyingType().getAsOpaquePtr();
}

void clang_TypedefNameDecl_setTypeSourceInfo(CXTypedefNameDecl TND,
                                             CXTypeSourceInfo newType) {
  static_cast<clang::TypedefNameDecl *>(TND)->setTypeSourceInfo(
      static_cast<clang::TypeSourceInfo *>(newType));
}

void clang_TypedefNameDecl_setModedTypeSourceInfo(CXTypedefNameDecl TND,
                                                  CXTypeSourceInfo unmodedTSI,
                                                  CXQualType modedTy) {
  static_cast<clang::TypedefNameDecl *>(TND)->setModedTypeSourceInfo(
      static_cast<clang::TypeSourceInfo *>(unmodedTSI),
      clang::QualType::getFromOpaquePtr(modedTy));
}

CXTypedefNameDecl clang_TypedefNameDecl_getCanonicalDecl(CXTypedefNameDecl TND) {
  return static_cast<clang::TypedefNameDecl *>(TND)->getCanonicalDecl();
}

CXTagDecl clang_TypedefNameDecl_getAnonDeclWithTypedefName(CXTypedefNameDecl TND,
                                                           bool AnyRedecl) {
  return static_cast<clang::TypedefNameDecl *>(TND)->getAnonDeclWithTypedefName(AnyRedecl);
}

bool clang_TypedefNameDecl_isTransparentTag(CXTypedefNameDecl TND) {
  return static_cast<clang::TypedefNameDecl *>(TND)->isTransparentTag();
}

// TypedefDecl
CXTypedefDecl clang_TypedefDecl_Create(CXASTContext C, CXDeclContext DC,
                                       CXSourceLocation_ StartLoc, CXSourceLocation_ IdLoc,
                                       CXIdentifierInfo Id, CXTypeSourceInfo TInfo) {
  return clang::TypedefDecl::Create(*static_cast<clang::ASTContext *>(C),
                                    static_cast<clang::DeclContext *>(DC),
                                    clang::SourceLocation::getFromPtrEncoding(StartLoc),
                                    clang::SourceLocation::getFromPtrEncoding(IdLoc),
                                    static_cast<clang::IdentifierInfo *>(Id),
                                    static_cast<clang::TypeSourceInfo *>(TInfo));
}

CXTypedefDecl clang_TypedefDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return clang::TypedefDecl::CreateDeserialized(*static_cast<clang::ASTContext *>(C), ID);
}

CXSourceRange_ clang_TypedefDecl_getSourceRange(CXTypedefDecl TD) {
  auto rng = static_cast<clang::TypedefDecl *>(TD)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

// TypeAliasDecl
CXTypeAliasDecl clang_TypeAliasDecl_Create(CXASTContext C, CXDeclContext DC,
                                           CXSourceLocation_ StartLoc,
                                           CXSourceLocation_ IdLoc, CXIdentifierInfo Id,
                                           CXTypeSourceInfo TInfo) {
  return clang::TypeAliasDecl::Create(*static_cast<clang::ASTContext *>(C),
                                      static_cast<clang::DeclContext *>(DC),
                                      clang::SourceLocation::getFromPtrEncoding(StartLoc),
                                      clang::SourceLocation::getFromPtrEncoding(IdLoc),
                                      static_cast<clang::IdentifierInfo *>(Id),
                                      static_cast<clang::TypeSourceInfo *>(TInfo));
}

CXTypeAliasDecl clang_TypeAliasDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return clang::TypeAliasDecl::CreateDeserialized(*static_cast<clang::ASTContext *>(C), ID);
}

CXSourceRange_ clang_TypeAliasDecl_getSourceRange(CXTypeAliasDecl TAD) {
  auto rng = static_cast<clang::TypeAliasDecl *>(TAD)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

CXTypeAliasTemplateDecl clang_TypeAliasDecl_getDescribedAliasTemplate(CXTypeAliasDecl TAD) {
  return static_cast<clang::TypeAliasDecl *>(TAD)->getDescribedAliasTemplate();
}

void clang_TypeAliasDecl_setDescribedAliasTemplate(CXTypeAliasDecl TAD,
                                                   CXTypeAliasTemplateDecl TAT) {
  static_cast<clang::TypeAliasDecl *>(TAD)->setDescribedAliasTemplate(
      static_cast<clang::TypeAliasTemplateDecl *>(TAT));
}

// TagDecl
CXSourceRange_ clang_TagDecl_getBraceRange(CXTagDecl TD) {
  auto rng = static_cast<clang::TagDecl *>(TD)->getBraceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

void clang_TagDecl_setBraceRange(CXTagDecl TD, CXSourceRange_ R) {
  static_cast<clang::TagDecl *>(TD)->setBraceRange(
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(R.B),
                         clang::SourceLocation::getFromPtrEncoding(R.E)));
}

CXSourceLocation_ clang_TagDecl_getInnerLocStart(CXTagDecl TD) {
  return static_cast<clang::TagDecl *>(TD)->getInnerLocStart().getPtrEncoding();
}

CXSourceLocation_ clang_TagDecl_getOuterLocStart(CXTagDecl TD) {
  return static_cast<clang::TagDecl *>(TD)->getOuterLocStart().getPtrEncoding();
}

CXSourceRange_ clang_TagDecl_getSourceRange(CXTagDecl TD) {
  auto rng = static_cast<clang::TagDecl *>(TD)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

CXTagDecl clang_TagDecl_getCanonicalDecl(CXTagDecl TD) {
  return static_cast<clang::TagDecl *>(TD)->getCanonicalDecl();
}

bool clang_TagDecl_isThisDeclarationADefinition(CXTagDecl TD) {
  return static_cast<clang::TagDecl *>(TD)->isThisDeclarationADefinition();
}

bool clang_TagDecl_isCompleteDefinition(CXTagDecl TD) {
  return static_cast<clang::TagDecl *>(TD)->isCompleteDefinition();
}

void clang_TagDecl_setCompleteDefinition(CXTagDecl TD, bool V) {
  static_cast<clang::TagDecl *>(TD)->setCompleteDefinition(V);
}

bool clang_TagDecl_isCompleteDefinitionRequired(CXTagDecl TD) {
  return static_cast<clang::TagDecl *>(TD)->isCompleteDefinitionRequired();
}

void clang_TagDecl_setCompleteDefinitionRequired(CXTagDecl TD, bool V) {
  static_cast<clang::TagDecl *>(TD)->setCompleteDefinitionRequired(V);
}

bool clang_TagDecl_isBeingDefined(CXTagDecl TD) {
  return static_cast<clang::TagDecl *>(TD)->isBeingDefined();
}

bool clang_TagDecl_isEmbeddedInDeclarator(CXTagDecl TD) {
  return static_cast<clang::TagDecl *>(TD)->isEmbeddedInDeclarator();
}

void clang_TagDecl_setEmbeddedInDeclarator(CXTagDecl TD, bool isInDeclarator) {
  static_cast<clang::TagDecl *>(TD)->setEmbeddedInDeclarator(isInDeclarator);
}

bool clang_TagDecl_isFreeStanding(CXTagDecl TD) {
  return static_cast<clang::TagDecl *>(TD)->isFreeStanding();
}

void clang_TagDecl_setFreeStanding(CXTagDecl TD, bool isFreeStanding) {
  static_cast<clang::TagDecl *>(TD)->setFreeStanding(isFreeStanding);
}

bool clang_TagDecl_mayHaveOutOfDateDef(CXTagDecl TD) {
  return static_cast<clang::TagDecl *>(TD)->mayHaveOutOfDateDef();
}

bool clang_TagDecl_isDependentType(CXTagDecl TD) {
  return static_cast<clang::TagDecl *>(TD)->isDependentType();
}

void clang_TagDecl_startDefinition(CXTagDecl TD) {
  static_cast<clang::TagDecl *>(TD)->startDefinition();
}

CXTagDecl clang_TagDecl_getDefinition(CXTagDecl TD) {
  return static_cast<clang::TagDecl *>(TD)->getDefinition();
}

const char *clang_TagDecl_getKindName(CXTagDecl TD) {
  return static_cast<clang::TagDecl *>(TD)->getKindName().data();
}

CXTagTypeKind clang_TagDecl_getTagKind(CXTagDecl TD) {
  return static_cast<CXTagTypeKind>(static_cast<clang::TagDecl *>(TD)->getTagKind());
}

void clang_TagDecl_setTagKind(CXTagDecl TD, CXTagTypeKind TK) {
  static_cast<clang::TagDecl *>(TD)->setTagKind(static_cast<clang::TagTypeKind>(TK));
}

bool clang_TagDecl_isStruct(CXTagDecl TD) {
  return static_cast<clang::TagDecl *>(TD)->isStruct();
}

bool clang_TagDecl_isInterface(CXTagDecl TD) {
  return static_cast<clang::TagDecl *>(TD)->isInterface();
}

bool clang_TagDecl_isClass(CXTagDecl TD) {
  return static_cast<clang::TagDecl *>(TD)->isClass();
}

bool clang_TagDecl_isUnion(CXTagDecl TD) {
  return static_cast<clang::TagDecl *>(TD)->isUnion();
}

bool clang_TagDecl_isEnum(CXTagDecl TD) {
  return static_cast<clang::TagDecl *>(TD)->isEnum();
}

bool clang_TagDecl_hasNameForLinkage(CXTagDecl TD) {
  return static_cast<clang::TagDecl *>(TD)->hasNameForLinkage();
}

CXTypedefNameDecl clang_TagDecl_getTypedefNameForAnonDecl(CXTagDecl TD) {
  return static_cast<clang::TagDecl *>(TD)->getTypedefNameForAnonDecl();
}

void clang_TagDecl_setTypedefNameForAnonDecl(CXTagDecl TD, CXTypedefNameDecl TDD) {
  static_cast<clang::TagDecl *>(TD)->setTypedefNameForAnonDecl(
      static_cast<clang::TypedefNameDecl *>(TDD));
}

CXNestedNameSpecifier clang_TagDecl_getQualifier(CXTagDecl TD) {
  return static_cast<clang::TagDecl *>(TD)->getQualifier();
}

// getQualifierLoc
// setQualifierInfo

unsigned clang_TagDecl_getNumTemplateParameterLists(CXTagDecl TD) {
  return static_cast<clang::TagDecl *>(TD)->getNumTemplateParameterLists();
}

CXTemplateParameterList clang_TagDecl_getTemplateParameterList(CXTagDecl TD, unsigned i) {
  return static_cast<clang::TagDecl *>(TD)->getTemplateParameterList(i);
}

// setTemplateParameterListsInfo

// TagDecl Cast
CXDeclContext clang_TagDecl_castToDeclContext(CXTagDecl TD) {
  return llvm::dyn_cast<clang::DeclContext>(static_cast<clang::TagDecl *>(TD));
}

// EnumDecl
CXEnumDecl clang_EnumDecl_Create(CXASTContext C, CXDeclContext DC,
                                 CXSourceLocation_ StartLoc, CXSourceLocation_ IdLoc,
                                 CXIdentifierInfo Id, CXEnumDecl PrevDecl, bool IsScoped,
                                 bool IsScopedUsingClassTag, bool IsFixed) {
  return clang::EnumDecl::Create(
      *static_cast<clang::ASTContext *>(C), static_cast<clang::DeclContext *>(DC),
      clang::SourceLocation::getFromPtrEncoding(StartLoc),
      clang::SourceLocation::getFromPtrEncoding(IdLoc),
      static_cast<clang::IdentifierInfo *>(Id), static_cast<clang::EnumDecl *>(PrevDecl),
      IsScoped, IsScopedUsingClassTag, IsFixed);
}

CXEnumDecl clang_EnumDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return clang::EnumDecl::CreateDeserialized(*static_cast<clang::ASTContext *>(C), ID);
}

void clang_EnumDecl_setScoped(CXEnumDecl ED, bool Scoped) {
  static_cast<clang::EnumDecl *>(ED)->setScoped(Scoped);
}

void clang_EnumDecl_setScopedUsingClassTag(CXEnumDecl ED, bool ScopedUCT) {
  static_cast<clang::EnumDecl *>(ED)->setScopedUsingClassTag(ScopedUCT);
}

void clang_EnumDecl_setFixed(CXEnumDecl ED, bool Fixed) {
  static_cast<clang::EnumDecl *>(ED)->setFixed(Fixed);
}

CXEnumDecl clang_EnumDecl_getCanonicalDecl(CXEnumDecl ED) {
  return static_cast<clang::EnumDecl *>(ED)->getCanonicalDecl();
}

CXEnumDecl clang_EnumDecl_getPreviousDecl(CXEnumDecl ED) {
  return static_cast<clang::EnumDecl *>(ED)->getPreviousDecl();
}

CXEnumDecl clang_EnumDecl_getMostRecentDecl(CXEnumDecl ED) {
  return static_cast<clang::EnumDecl *>(ED)->getMostRecentDecl();
}

CXEnumDecl clang_EnumDecl_getDefinition(CXEnumDecl ED) {
  return static_cast<clang::EnumDecl *>(ED)->getDefinition();
}

void clang_EnumDecl_completeDefinition(CXEnumDecl ED, CXQualType NewType,
                                       CXQualType PromotionType, unsigned NumPositiveBits,
                                       unsigned NumNegativeBits) {
  static_cast<clang::EnumDecl *>(ED)->completeDefinition(
      clang::QualType::getFromOpaquePtr(NewType),
      clang::QualType::getFromOpaquePtr(PromotionType), NumPositiveBits, NumNegativeBits);
}

CXQualType clang_EnumDecl_getPromotionType(CXEnumDecl ED) {
  return static_cast<clang::EnumDecl *>(ED)->getPromotionType().getAsOpaquePtr();
}

void clang_EnumDecl_setPromotionType(CXEnumDecl ED, CXQualType T) {
  static_cast<clang::EnumDecl *>(ED)->setPromotionType(
      clang::QualType::getFromOpaquePtr(T));
}

CXQualType clang_EnumDecl_getIntegerType(CXEnumDecl ED) {
  return static_cast<clang::EnumDecl *>(ED)->getIntegerType().getAsOpaquePtr();
}

void clang_EnumDecl_setIntegerType(CXEnumDecl ED, CXQualType T) {
  static_cast<clang::EnumDecl *>(ED)->setIntegerType(clang::QualType::getFromOpaquePtr(T));
}

void clang_EnumDecl_setIntegerTypeSourceInfo(CXEnumDecl ED, CXTypeSourceInfo TInfo) {
  static_cast<clang::EnumDecl *>(ED)->setIntegerTypeSourceInfo(
      static_cast<clang::TypeSourceInfo *>(TInfo));
}

CXTypeSourceInfo clang_EnumDecl_getIntegerTypeSourceInfo(CXEnumDecl ED) {
  return static_cast<clang::EnumDecl *>(ED)->getIntegerTypeSourceInfo();
}

CXSourceRange_ clang_EnumDecl_getIntegerTypeRange(CXEnumDecl ED) {
  auto rng = static_cast<clang::EnumDecl *>(ED)->getIntegerTypeRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

unsigned clang_EnumDecl_getNumPositiveBits(CXEnumDecl ED) {
  return static_cast<clang::EnumDecl *>(ED)->getNumPositiveBits();
}

unsigned clang_EnumDecl_getNumNegativeBits(CXEnumDecl ED) {
  return static_cast<clang::EnumDecl *>(ED)->getNumNegativeBits();
}

bool clang_EnumDecl_isScoped(CXEnumDecl ED) {
  return static_cast<clang::EnumDecl *>(ED)->isScoped();
}

bool clang_EnumDecl_isScopedUsingClassTag(CXEnumDecl ED) {
  return static_cast<clang::EnumDecl *>(ED)->isScopedUsingClassTag();
}

bool clang_EnumDecl_isFixed(CXEnumDecl ED) {
  return static_cast<clang::EnumDecl *>(ED)->isFixed();
}

unsigned clang_EnumDecl_getODRHash(CXEnumDecl ED) {
  return static_cast<clang::EnumDecl *>(ED)->getODRHash();
}

bool clang_EnumDecl_isComplete(CXEnumDecl ED) {
  return static_cast<clang::EnumDecl *>(ED)->isComplete();
}

bool clang_EnumDecl_isClosed(CXEnumDecl ED) {
  return static_cast<clang::EnumDecl *>(ED)->isClosed();
}

bool clang_EnumDecl_isClosedFlag(CXEnumDecl ED) {
  return static_cast<clang::EnumDecl *>(ED)->isClosedFlag();
}

bool clang_EnumDecl_isClosedNonFlag(CXEnumDecl ED) {
  return static_cast<clang::EnumDecl *>(ED)->isClosedNonFlag();
}

CXEnumDecl clang_EnumDecl_getTemplateInstantiationPattern(CXEnumDecl ED) {
  return static_cast<clang::EnumDecl *>(ED)->getTemplateInstantiationPattern();
}

CXEnumDecl clang_EnumDecl_getInstantiatedFromMemberEnum(CXEnumDecl ED) {
  return static_cast<clang::EnumDecl *>(ED)->getInstantiatedFromMemberEnum();
}

CXTemplateSpecializationKind clang_EnumDecl_getTemplateSpecializationKind(CXEnumDecl ED) {
  return static_cast<CXTemplateSpecializationKind>(
      static_cast<clang::EnumDecl *>(ED)->getTemplateSpecializationKind());
}

void clang_EnumDecl_setTemplateSpecializationKind(CXEnumDecl ED,
                                                  CXTemplateSpecializationKind TSK,
                                                  CXSourceLocation_ PointOfInstantiation) {
  static_cast<clang::EnumDecl *>(ED)->setTemplateSpecializationKind(
      static_cast<clang::TemplateSpecializationKind>(TSK),
      clang::SourceLocation::getFromPtrEncoding(PointOfInstantiation));
}

CXMemberSpecializationInfo clang_EnumDecl_getMemberSpecializationInfo(CXEnumDecl ED) {
  return static_cast<clang::EnumDecl *>(ED)->getMemberSpecializationInfo();
}

void clang_EnumDecl_setInstantiationOfMemberEnum(CXEnumDecl ED, CXEnumDecl ED2,
                                                 CXTemplateSpecializationKind TSK) {

  static_cast<clang::EnumDecl *>(ED)->setInstantiationOfMemberEnum(
      static_cast<clang::EnumDecl *>(ED2),
      static_cast<clang::TemplateSpecializationKind>(TSK));
}

// RecordDecl
CXRecordDecl clang_RecordDecl_Create(CXASTContext C, CXTagTypeKind TK, CXDeclContext DC,
                                     CXSourceLocation_ StartLoc, CXSourceLocation_ IdLoc,
                                     CXIdentifierInfo Id, CXRecordDecl PrevDecl) {
  return clang::RecordDecl::Create(
      *static_cast<clang::ASTContext *>(C), static_cast<clang::TagTypeKind>(TK),
      static_cast<clang::DeclContext *>(DC),
      clang::SourceLocation::getFromPtrEncoding(StartLoc),
      clang::SourceLocation::getFromPtrEncoding(IdLoc),
      static_cast<clang::IdentifierInfo *>(Id), static_cast<clang::RecordDecl *>(PrevDecl));
}

CXRecordDecl clang_RecordDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return clang::RecordDecl::CreateDeserialized(*static_cast<clang::ASTContext *>(C), ID);
}

CXRecordDecl clang_RecordDecl_getPreviousDecl(CXRecordDecl RD) {
  return static_cast<clang::RecordDecl *>(RD)->getPreviousDecl();
}

CXRecordDecl clang_RecordDecl_getMostRecentDecl(CXRecordDecl RD) {
  return static_cast<clang::RecordDecl *>(RD)->getMostRecentDecl();
}

bool clang_RecordDecl_hasFlexibleArrayMember(CXRecordDecl RD) {
  return static_cast<clang::RecordDecl *>(RD)->hasFlexibleArrayMember();
}

void clang_RecordDecl_setHasFlexibleArrayMember(CXRecordDecl RD, bool V) {
  static_cast<clang::RecordDecl *>(RD)->setHasFlexibleArrayMember(V);
}

bool clang_RecordDecl_isAnonymousStructOrUnion(CXRecordDecl RD) {
  return static_cast<clang::RecordDecl *>(RD)->isAnonymousStructOrUnion();
}

void clang_RecordDecl_setAnonymousStructOrUnion(CXRecordDecl RD, bool Anon) {
  static_cast<clang::RecordDecl *>(RD)->setAnonymousStructOrUnion(Anon);
}

bool clang_RecordDecl_hasObjectMember(CXRecordDecl RD) {
  return static_cast<clang::RecordDecl *>(RD)->hasObjectMember();
}

void clang_RecordDecl_setHasObjectMember(CXRecordDecl RD, bool val) {
  static_cast<clang::RecordDecl *>(RD)->setHasObjectMember(val);
}

bool clang_RecordDecl_hasVolatileMember(CXRecordDecl RD) {
  return static_cast<clang::RecordDecl *>(RD)->hasVolatileMember();
}

void clang_RecordDecl_setHasVolatileMember(CXRecordDecl RD, bool val) {
  static_cast<clang::RecordDecl *>(RD)->setHasVolatileMember(val);
}

bool clang_RecordDecl_hasLoadedFieldsFromExternalStorage(CXRecordDecl RD) {
  return static_cast<clang::RecordDecl *>(RD)->hasLoadedFieldsFromExternalStorage();
}

void clang_RecordDecl_setHasLoadedFieldsFromExternalStorage(CXRecordDecl RD, bool val) {
  static_cast<clang::RecordDecl *>(RD)->setHasLoadedFieldsFromExternalStorage(val);
}

bool clang_RecordDecl_isNonTrivialToPrimitiveDefaultInitialize(CXRecordDecl RD) {
  return static_cast<clang::RecordDecl *>(RD)->isNonTrivialToPrimitiveDefaultInitialize();
}

void clang_RecordDecl_setNonTrivialToPrimitiveDefaultInitialize(CXRecordDecl RD, bool V) {
  static_cast<clang::RecordDecl *>(RD)->setNonTrivialToPrimitiveDefaultInitialize(V);
}

bool clang_RecordDecl_isNonTrivialToPrimitiveCopy(CXRecordDecl RD) {
  return static_cast<clang::RecordDecl *>(RD)->isNonTrivialToPrimitiveCopy();
}

void clang_RecordDecl_setNonTrivialToPrimitiveCopy(CXRecordDecl RD, bool V) {
  static_cast<clang::RecordDecl *>(RD)->setNonTrivialToPrimitiveCopy(V);
}

bool clang_RecordDecl_isNonTrivialToPrimitiveDestroy(CXRecordDecl RD) {
  return static_cast<clang::RecordDecl *>(RD)->isNonTrivialToPrimitiveDestroy();
}

void clang_RecordDecl_setNonTrivialToPrimitiveDestroy(CXRecordDecl RD, bool V) {
  static_cast<clang::RecordDecl *>(RD)->setNonTrivialToPrimitiveDestroy(V);
}

bool clang_RecordDecl_hasNonTrivialToPrimitiveDefaultInitializeCUnion(CXRecordDecl RD) {
  return static_cast<clang::RecordDecl *>(RD)
      ->hasNonTrivialToPrimitiveDefaultInitializeCUnion();
}

void clang_RecordDecl_setHasNonTrivialToPrimitiveDefaultInitializeCUnion(CXRecordDecl RD,
                                                                         bool V) {
  static_cast<clang::RecordDecl *>(RD)->setHasNonTrivialToPrimitiveDefaultInitializeCUnion(
      V);
}

bool clang_RecordDecl_hasNonTrivialToPrimitiveDestructCUnion(CXRecordDecl RD) {
  return static_cast<clang::RecordDecl *>(RD)->hasNonTrivialToPrimitiveDestructCUnion();
}

void clang_RecordDecl_setHasNonTrivialToPrimitiveDestructCUnion(CXRecordDecl RD, bool V) {
  static_cast<clang::RecordDecl *>(RD)->setHasNonTrivialToPrimitiveDestructCUnion(V);
}

bool clang_RecordDecl_hasNonTrivialToPrimitiveCopyCUnion(CXRecordDecl RD) {
  return static_cast<clang::RecordDecl *>(RD)->hasNonTrivialToPrimitiveCopyCUnion();
}

void clang_RecordDecl_setHasNonTrivialToPrimitiveCopyCUnion(CXRecordDecl RD, bool V) {
  static_cast<clang::RecordDecl *>(RD)->setHasNonTrivialToPrimitiveCopyCUnion(V);
}

bool clang_RecordDecl_canPassInRegisters(CXRecordDecl RD) {
  return static_cast<clang::RecordDecl *>(RD)->canPassInRegisters();
}

CXRecordDecl_ArgPassingKind clang_RecordDecl_getArgPassingRestrictions(CXRecordDecl RD) {
  return static_cast<CXRecordDecl_ArgPassingKind>(
      static_cast<clang::RecordDecl *>(RD)->getArgPassingRestrictions());
}

void clang_RecordDecl_setArgPassingRestrictions(CXRecordDecl RD,
                                                CXRecordDecl_ArgPassingKind Kind) {
  static_cast<clang::RecordDecl *>(RD)->setArgPassingRestrictions(
      static_cast<clang::RecordDecl::ArgPassingKind>(Kind));
}

bool clang_RecordDecl_isParamDestroyedInCallee(CXRecordDecl RD) {
  return static_cast<clang::RecordDecl *>(RD)->isParamDestroyedInCallee();
}

void clang_RecordDecl_setParamDestroyedInCallee(CXRecordDecl RD, bool V) {
  static_cast<clang::RecordDecl *>(RD)->setParamDestroyedInCallee(V);
}

bool clang_RecordDecl_isInjectedClassName(CXRecordDecl RD) {
  return static_cast<clang::RecordDecl *>(RD)->isInjectedClassName();
}

bool clang_RecordDecl_isLambda(CXRecordDecl RD) {
  return static_cast<clang::RecordDecl *>(RD)->isLambda();
}

bool clang_RecordDecl_isCapturedRecord(CXRecordDecl RD) {
  return static_cast<clang::RecordDecl *>(RD)->isCapturedRecord();
}

void clang_RecordDecl_setCapturedRecord(CXRecordDecl RD) {
  static_cast<clang::RecordDecl *>(RD)->setCapturedRecord();
}

CXRecordDecl clang_RecordDecl_getDefinition(CXRecordDecl RD) {
  return static_cast<clang::RecordDecl *>(RD)->getDefinition();
}

bool clang_RecordDecl_isOrContainsUnion(CXRecordDecl RD) {
  return static_cast<clang::RecordDecl *>(RD)->isOrContainsUnion();
}

bool clang_RecordDecl_isMsStruct(CXRecordDecl RD, CXASTContext C) {
  return static_cast<clang::RecordDecl *>(RD)->isMsStruct(
      *static_cast<clang::ASTContext *>(C));
}

bool clang_RecordDecl_mayInsertExtraPadding(CXRecordDecl RD, bool EmitRemark) {
  return static_cast<clang::RecordDecl *>(RD)->mayInsertExtraPadding(EmitRemark);
}

CXFieldDecl clang_RecordDecl_findFirstNamedDataMember(CXRecordDecl RD) {
  return const_cast<clang::FieldDecl *>(
      static_cast<clang::RecordDecl *>(RD)->findFirstNamedDataMember());
}

// FileScopeAsmDecl
CXFileScopeAsmDecl clang_FileScopeAsmDecl_Create(CXASTContext C, CXDeclContext DC,
                                                 CXStringLiteral Str,
                                                 CXSourceLocation_ AsmLoc,
                                                 CXSourceLocation_ RParenLoc) {
  return clang::FileScopeAsmDecl::Create(
      *static_cast<clang::ASTContext *>(C), static_cast<clang::DeclContext *>(DC),
      static_cast<clang::StringLiteral *>(DC),
      clang::SourceLocation::getFromPtrEncoding(AsmLoc),
      clang::SourceLocation::getFromPtrEncoding(RParenLoc));
}

CXFileScopeAsmDecl clang_FileScopeAsmDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return clang::FileScopeAsmDecl::CreateDeserialized(*static_cast<clang::ASTContext *>(C),
                                                     ID);
}

CXSourceLocation_ clang_FileScopeAsmDecl_getAsmLoc(CXFileScopeAsmDecl FSAD) {
  return static_cast<clang::FileScopeAsmDecl *>(FSAD)->getAsmLoc().getPtrEncoding();
}

CXSourceLocation_ clang_FileScopeAsmDecl_getRParenLoc(CXFileScopeAsmDecl FSAD) {
  return static_cast<clang::FileScopeAsmDecl *>(FSAD)->getRParenLoc().getPtrEncoding();
}

void clang_FileScopeAsmDecl_setRParenLoc(CXFileScopeAsmDecl FSAD, CXSourceLocation_ L) {
  static_cast<clang::FileScopeAsmDecl *>(FSAD)->setRParenLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

CXSourceRange_ clang_FileScopeAsmDecl_getSourceRange(CXFileScopeAsmDecl FSAD) {
  auto rng = static_cast<clang::FileScopeAsmDecl *>(FSAD)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

CXStringLiteral clang_FileScopeAsmDecl_getAsmString(CXFileScopeAsmDecl FSAD) {
  return static_cast<clang::FileScopeAsmDecl *>(FSAD)->getAsmString();
}

void clang_FileScopeAsmDecl_setAsmString(CXFileScopeAsmDecl FSAD, CXStringLiteral Asm) {
  static_cast<clang::FileScopeAsmDecl *>(FSAD)->setAsmString(
      static_cast<clang::StringLiteral *>(Asm));
}

// BlockDecl
CXBlockDecl clang_BlockDecl_Create(CXASTContext C, CXDeclContext DC, CXSourceLocation_ L) {
  return clang::BlockDecl::Create(*static_cast<clang::ASTContext *>(C),
                                  static_cast<clang::DeclContext *>(DC),
                                  clang::SourceLocation::getFromPtrEncoding(L));
}

CXBlockDecl clang_BlockDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return clang::BlockDecl::CreateDeserialized(*static_cast<clang::ASTContext *>(C), ID);
}

CXSourceLocation_ clang_BlockDecl_getCaretLocation(CXBlockDecl BD) {
  return static_cast<clang::BlockDecl *>(BD)->getCaretLocation().getPtrEncoding();
}

bool clang_BlockDecl_isVariadic(CXBlockDecl BD) {
  return static_cast<clang::BlockDecl *>(BD)->isVariadic();
}

void clang_BlockDecl_setBody(CXBlockDecl BD, CXCompoundStmt B) {
  static_cast<clang::BlockDecl *>(BD)->setBody(static_cast<clang::CompoundStmt *>(B));
}

void clang_BlockDecl_setSignatureAsWritten(CXBlockDecl BD, CXTypeSourceInfo Sig) {
  static_cast<clang::BlockDecl *>(BD)->setSignatureAsWritten(
      static_cast<clang::TypeSourceInfo *>(Sig));
}

CXTypeSourceInfo clang_BlockDecl_getSignatureAsWritten(CXBlockDecl BD) {
  return static_cast<clang::BlockDecl *>(BD)->getSignatureAsWritten();
}

unsigned clang_BlockDecl_getNumParams(CXBlockDecl BD) {
  return static_cast<clang::BlockDecl *>(BD)->getNumParams();
}

CXParmVarDecl clang_BlockDecl_getParamDecl(CXBlockDecl BD, unsigned i) {
  return static_cast<clang::BlockDecl *>(BD)->getParamDecl(i);
}

// setParams

bool clang_BlockDecl_hasCaptures(CXBlockDecl BD) {
  return static_cast<clang::BlockDecl *>(BD)->hasCaptures();
}

unsigned clang_BlockDecl_getNumCaptures(CXBlockDecl BD) {
  return static_cast<clang::BlockDecl *>(BD)->getNumCaptures();
}

bool clang_BlockDecl_capturesCXXThis(CXBlockDecl BD) {
  return static_cast<clang::BlockDecl *>(BD)->capturesCXXThis();
}

void clang_BlockDecl_setCapturesCXXThis(CXBlockDecl BD, bool B) {
  static_cast<clang::BlockDecl *>(BD)->setCapturesCXXThis(B);
}

bool clang_BlockDecl_blockMissingReturnType(CXBlockDecl BD) {
  return static_cast<clang::BlockDecl *>(BD)->blockMissingReturnType();
}

void clang_BlockDecl_setBlockMissingReturnType(CXBlockDecl BD, bool val) {
  static_cast<clang::BlockDecl *>(BD)->setBlockMissingReturnType(val);
}

bool clang_BlockDecl_isConversionFromLambda(CXBlockDecl BD) {
  return static_cast<clang::BlockDecl *>(BD)->isConversionFromLambda();
}

void clang_BlockDecl_setIsConversionFromLambda(CXBlockDecl BD, bool val) {
  static_cast<clang::BlockDecl *>(BD)->setIsConversionFromLambda(val);
}

bool clang_BlockDecl_doesNotEscape(CXBlockDecl BD) {
  return static_cast<clang::BlockDecl *>(BD)->doesNotEscape();
}

void clang_BlockDecl_setDoesNotEscape(CXBlockDecl BD, bool B) {
  static_cast<clang::BlockDecl *>(BD)->setDoesNotEscape(B);
}

bool clang_BlockDecl_canAvoidCopyToHeap(CXBlockDecl BD) {
  return static_cast<clang::BlockDecl *>(BD)->canAvoidCopyToHeap();
}

void clang_BlockDecl_setCanAvoidCopyToHeap(CXBlockDecl BD, bool B) {
  static_cast<clang::BlockDecl *>(BD)->setCanAvoidCopyToHeap(B);
}

bool clang_BlockDecl_capturesVariable(CXBlockDecl BD, CXVarDecl var) {
  return static_cast<clang::BlockDecl *>(BD)->capturesVariable(
      static_cast<clang::VarDecl *>(var));
}

// setCaptures

unsigned clang_BlockDecl_getBlockManglingNumber(CXBlockDecl BD) {
  return static_cast<clang::BlockDecl *>(BD)->getBlockManglingNumber();
}

CXDecl clang_BlockDecl_getBlockManglingContextDecl(CXBlockDecl BD) {
  return static_cast<clang::BlockDecl *>(BD)->getBlockManglingContextDecl();
}

void clang_BlockDecl_setBlockMangling(CXBlockDecl BD, unsigned Number, CXDecl Ctx) {
  static_cast<clang::BlockDecl *>(BD)->setBlockMangling(Number,
                                                        static_cast<clang::Decl *>(Ctx));
}

CXSourceRange_ clang_BlockDecl_getSourceRange(CXBlockDecl BD) {
  auto rng = static_cast<clang::BlockDecl *>(BD)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

// CapturedDecl
CXCapturedDecl clang_CapturedDecl_Create(CXASTContext C, CXDeclContext DC,
                                         unsigned NumParams) {
  return clang::CapturedDecl::Create(*static_cast<clang::ASTContext *>(C),
                                     static_cast<clang::DeclContext *>(DC), NumParams);
}

CXCapturedDecl clang_CapturedDecl_CreateDeserialized(CXASTContext C, unsigned ID,
                                                     unsigned NumParams) {
  return clang::CapturedDecl::CreateDeserialized(*static_cast<clang::ASTContext *>(C), ID,
                                                 NumParams);
}

CXStmt clang_CapturedDecl_getBody(CXCapturedDecl CD) {
  return static_cast<clang::CapturedDecl *>(CD)->getBody();
}

void clang_CapturedDecl_setBody(CXCapturedDecl CD, CXStmt B) {
  static_cast<clang::CapturedDecl *>(CD)->setBody(static_cast<clang::Stmt *>(B));
}

bool clang_CapturedDecl_isNothrow(CXCapturedDecl CD) {
  return static_cast<clang::CapturedDecl *>(CD)->isNothrow();
}

void clang_CapturedDecl_setNothrow(CXCapturedDecl CD, bool Nothrow) {
  static_cast<clang::CapturedDecl *>(CD)->setNothrow(Nothrow);
}

unsigned clang_CapturedDecl_getNumParams(CXCapturedDecl CD) {
  return static_cast<clang::CapturedDecl *>(CD)->getNumParams();
}

CXImplicitParamDecl clang_CapturedDecl_getParam(CXCapturedDecl CD, unsigned i) {
  return static_cast<clang::CapturedDecl *>(CD)->getParam(i);
}

void clang_CapturedDecl_setParam(CXCapturedDecl CD, unsigned i, CXImplicitParamDecl P) {
  static_cast<clang::CapturedDecl *>(CD)->setParam(
      i, static_cast<clang::ImplicitParamDecl *>(P));
}

CXImplicitParamDecl clang_CapturedDecl_getContextParam(CXCapturedDecl CD) {
  return static_cast<clang::CapturedDecl *>(CD)->getContextParam();
}

void clang_CapturedDecl_setContextParam(CXCapturedDecl CD, unsigned i,
                                        CXImplicitParamDecl P) {
  static_cast<clang::CapturedDecl *>(CD)->setContextParam(
      i, static_cast<clang::ImplicitParamDecl *>(P));
}

unsigned clang_CapturedDecl_getContextParamPosition(CXCapturedDecl CD) {
  return static_cast<clang::CapturedDecl *>(CD)->getContextParamPosition();
}

// ImportDecl
CXImportDecl clang_ImportDecl_CreateImplicit(CXASTContext C, CXDeclContext DC,
                                             CXSourceLocation_ StartLoc, CXModule Imported,
                                             CXSourceLocation_ EndLoc) {
  return clang::ImportDecl::CreateImplicit(
      *static_cast<clang::ASTContext *>(C), static_cast<clang::DeclContext *>(DC),
      clang::SourceLocation::getFromPtrEncoding(StartLoc),
      static_cast<clang::Module *>(Imported),
      clang::SourceLocation::getFromPtrEncoding(EndLoc));
}

CXImportDecl clang_ImportDecl_CreateDeserialized(CXASTContext C, unsigned ID,
                                                 unsigned NumLocations) {
  return clang::ImportDecl::CreateDeserialized(*static_cast<clang::ASTContext *>(C), ID,
                                               NumLocations);
}

CXModule clang_ImportDecl_getImportedModule(CXImportDecl ID) {
  return static_cast<clang::ImportDecl *>(ID)->getImportedModule();
}

// getIdentifierLocs

CXSourceRange_ clang_ImportDecl_getSourceRange(CXImportDecl ID) {
  auto rng = static_cast<clang::ImportDecl *>(ID)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

// ExportDecl
CXExportDecl clang_ExportDecl_Create(CXASTContext C, CXDeclContext DC,
                                     CXSourceLocation_ ExportLoc) {
  return clang::ExportDecl::Create(*static_cast<clang::ASTContext *>(C),
                                   static_cast<clang::DeclContext *>(DC),
                                   clang::SourceLocation::getFromPtrEncoding(ExportLoc));
}

CXExportDecl clang_ExportDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return clang::ExportDecl::CreateDeserialized(*static_cast<clang::ASTContext *>(C), ID);
}

CXSourceLocation_ clang_ExportDecl_getExportLoc(CXExportDecl ED) {
  return static_cast<clang::ExportDecl *>(ED)->getExportLoc().getPtrEncoding();
}

CXSourceLocation_ clang_ExportDecl_getRBraceLoc(CXExportDecl ED) {
  return static_cast<clang::ExportDecl *>(ED)->getRBraceLoc().getPtrEncoding();
}

void clang_ExportDecl_setRBraceLoc(CXExportDecl ED, CXSourceLocation_ L) {
  static_cast<clang::ExportDecl *>(ED)->setRBraceLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

bool clang_ExportDecl_hasBraces(CXExportDecl ED) {
  return static_cast<clang::ExportDecl *>(ED)->hasBraces();
}

CXSourceLocation_ clang_ExportDecl_getEndLoc(CXExportDecl ED) {
  return static_cast<clang::ExportDecl *>(ED)->getEndLoc().getPtrEncoding();
}

CXSourceRange_ clang_ExportDecl_getSourceRange(CXExportDecl ED) {
  auto rng = static_cast<clang::ExportDecl *>(ED)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

// EmptyDecl
CXEmptyDecl clang_EmptyDecl_Create(CXASTContext C, CXDeclContext DC, CXSourceLocation_ L) {
  return clang::EmptyDecl::Create(*static_cast<clang::ASTContext *>(C),
                                  static_cast<clang::DeclContext *>(DC),
                                  clang::SourceLocation::getFromPtrEncoding(L));
}

CXEmptyDecl clang_EmptyDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return clang::EmptyDecl::CreateDeserialized(*static_cast<clang::ASTContext *>(C), ID);
}