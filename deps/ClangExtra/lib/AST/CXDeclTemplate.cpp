#include "clang-ex/AST/CXDeclTemplate.h"
#include "clang/AST/DeclTemplate.h"

// TemplateParameterList
CXNamedDecl clang_TemplateParameterList_getParam(CXTemplateParameterList TPL,
                                                 unsigned Idx) {
  return static_cast<clang::TemplateParameterList *>(TPL)->getParam(Idx);
}

unsigned clang_TemplateParameterList_size(CXTemplateParameterList TPL) {
  return static_cast<clang::TemplateParameterList *>(TPL)->size();
}

// TemplateArgumentList
CXTemplateArgumentList clang_TemplateArgumentList_CreateCopy(CXASTContext Context,
                                                             CXTemplateArgument Args,
                                                             size_t ArgNum) {
  return clang::TemplateArgumentList::CreateCopy(
      *static_cast<clang::ASTContext *>(Context),
      llvm::ArrayRef(static_cast<clang::TemplateArgument *>(Args), ArgNum));
}

unsigned clang_TemplateArgumentList_size(CXTemplateArgumentList TAL) {
  return static_cast<clang::TemplateArgumentList *>(TAL)->size();
}

CXTemplateArgument clang_TemplateArgumentList_data(CXTemplateArgumentList TAL) {
  return const_cast<clang::TemplateArgument *>(
      static_cast<clang::TemplateArgumentList *>(TAL)->data());
}

CXTemplateArgument clang_TemplateArgumentList_get(CXTemplateArgumentList TAL,
                                                  unsigned Idx) {
  return const_cast<clang::TemplateArgument *>(
      &static_cast<clang::TemplateArgumentList *>(TAL)->get(Idx));
}

// TemplateDecl
// void clang_TemplateDecl_init(CXTemplateDecl TD, CXNamedDecl ND,
//                              CXTemplateParameterList TP) {
//   static_cast<clang::TemplateDecl *>(TD)->init(
//       static_cast<clang::NamedDecl *>(ND), static_cast<clang::TemplateParameterList
//       *>(ND));
// }

// RedeclarableTemplateDecl
CXRedeclarableTemplateDecl
clang_RedeclarableTemplateDecl_getCanonicalDecl(CXRedeclarableTemplateDecl RTD) {
  return static_cast<clang::RedeclarableTemplateDecl *>(RTD)->getCanonicalDecl();
}

bool clang_RedeclarableTemplateDecl_isMemberSpecialization(CXRedeclarableTemplateDecl RTD) {
  return static_cast<clang::RedeclarableTemplateDecl *>(RTD)->isMemberSpecialization();
}

void clang_RedeclarableTemplateDecl_setMemberSpecialization(
    CXRedeclarableTemplateDecl RTD) {
  static_cast<clang::RedeclarableTemplateDecl *>(RTD)->setMemberSpecialization();
}

// ClassTemplateDecl
CXCXXRecordDecl clang_ClassTemplateDecl_getTemplatedDecl(CXClassTemplateDecl CTD) {
  return static_cast<clang::ClassTemplateDecl *>(CTD)->getTemplatedDecl();
}

bool clang_ClassTemplateDecl_isThisDeclarationADefinition(CXClassTemplateDecl CTD) {
  return static_cast<clang::ClassTemplateDecl *>(CTD)->isThisDeclarationADefinition();
}

CXClassTemplateSpecializationDecl
clang_ClassTemplateDecl_findSpecialization(CXClassTemplateDecl CTD,
                                           CXTemplateArgumentList TAL, void *InsertPos) {
  return static_cast<clang::ClassTemplateDecl *>(CTD)->findSpecialization(
      static_cast<clang::TemplateArgumentList *>(TAL)->asArray(), InsertPos);
}

void clang_ClassTemplateDecl_AddSpecialization(CXClassTemplateDecl CTD,
                                               CXClassTemplateSpecializationDecl CTSD,
                                               void *InsertPos) {
  return static_cast<clang::ClassTemplateDecl *>(CTD)->AddSpecialization(
      static_cast<clang::ClassTemplateSpecializationDecl *>(CTSD), InsertPos);
}

CXClassTemplateDecl clang_ClassTemplateDecl_getCanonicalDecl(CXClassTemplateDecl CTD) {
  return static_cast<clang::ClassTemplateDecl *>(CTD)->getCanonicalDecl();
}

CXClassTemplateDecl clang_ClassTemplateDecl_getPreviousDecl(CXClassTemplateDecl CTD) {
  return static_cast<clang::ClassTemplateDecl *>(CTD)->getPreviousDecl();
}

CXClassTemplateDecl clang_ClassTemplateDecl_getMostRecentDecl(CXClassTemplateDecl CTD) {
  return static_cast<clang::ClassTemplateDecl *>(CTD)->getMostRecentDecl();
}

// ClassTemplateSpecializationDecl
CXClassTemplateSpecializationDecl clang_ClassTemplateSpecializationDecl_Create(
    CXASTContext Context, CXTagTypeKind TK, CXDeclContext DC, CXSourceLocation_ StartLoc,
    CXSourceLocation_ IdLoc, CXClassTemplateDecl SpecializedTemplate,
    CXTemplateArgumentList Args, CXClassTemplateSpecializationDecl PrevDecl) {
  return clang::ClassTemplateSpecializationDecl::Create(
      *static_cast<clang::ASTContext *>(Context), static_cast<clang::TagTypeKind>(TK),
      static_cast<clang::DeclContext *>(DC),
      clang::SourceLocation::getFromPtrEncoding(StartLoc),
      clang::SourceLocation::getFromPtrEncoding(IdLoc),
      static_cast<clang::ClassTemplateDecl *>(SpecializedTemplate),
      static_cast<clang::TemplateArgumentList *>(Args)->asArray(),
      static_cast<clang::ClassTemplateSpecializationDecl *>(PrevDecl));
}

CXTemplateArgumentList clang_ClassTemplateSpecializationDecl_getTemplateArgs(
    CXClassTemplateSpecializationDecl CTSD) {
  return const_cast<clang::TemplateArgumentList *>(
      &static_cast<clang::ClassTemplateSpecializationDecl *>(CTSD)->getTemplateArgs());
}

void clang_ClassTemplateSpecializationDecl_setTemplateArgs(
    CXClassTemplateSpecializationDecl CTSD, CXTemplateArgumentList TAL) {
  static_cast<clang::ClassTemplateSpecializationDecl *>(CTSD)->setTemplateArgs(
      static_cast<clang::TemplateArgumentList *>(TAL));
}
// TemplateDecl navigation
CXNamedDecl clang_TemplateDecl_getTemplatedDecl(CXTemplateDecl TD) {
  return static_cast<clang::TemplateDecl *>(TD)->getTemplatedDecl();
}

CXTemplateParameterList clang_TemplateDecl_getTemplateParameters(CXTemplateDecl TD) {
  return static_cast<clang::TemplateDecl *>(TD)->getTemplateParameters();
}

// TemplateParameterList
unsigned clang_TemplateParameterList_getDepth(CXTemplateParameterList L) {
  return static_cast<clang::TemplateParameterList *>(L)->getDepth();
}

unsigned clang_TemplateParameterList_getMinRequiredArguments(CXTemplateParameterList L) {
  return static_cast<clang::TemplateParameterList *>(L)->getMinRequiredArguments();
}

bool clang_TemplateParameterList_hasParameterPack(CXTemplateParameterList L) {
  return static_cast<clang::TemplateParameterList *>(L)->hasParameterPack();
}

// TemplateTypeParmDecl
unsigned clang_TemplateTypeParmDecl_getDepth(CXTemplateTypeParmDecl D) {
  return static_cast<clang::TemplateTypeParmDecl *>(D)->getDepth();
}

unsigned clang_TemplateTypeParmDecl_getIndex(CXTemplateTypeParmDecl D) {
  return static_cast<clang::TemplateTypeParmDecl *>(D)->getIndex();
}

bool clang_TemplateTypeParmDecl_isParameterPack(CXTemplateTypeParmDecl D) {
  return static_cast<clang::TemplateTypeParmDecl *>(D)->isParameterPack();
}

// NonTypeTemplateParmDecl
unsigned clang_NonTypeTemplateParmDecl_getDepth(CXNonTypeTemplateParmDecl D) {
  return static_cast<clang::NonTypeTemplateParmDecl *>(D)->getDepth();
}

unsigned clang_NonTypeTemplateParmDecl_getIndex(CXNonTypeTemplateParmDecl D) {
  return static_cast<clang::NonTypeTemplateParmDecl *>(D)->getIndex();
}

bool clang_NonTypeTemplateParmDecl_isParameterPack(CXNonTypeTemplateParmDecl D) {
  return static_cast<clang::NonTypeTemplateParmDecl *>(D)->isParameterPack();
}

// ClassTemplateSpecializationDecl navigation
CXClassTemplateDecl
clang_ClassTemplateSpecializationDecl_getSpecializedTemplate(CXClassTemplateSpecializationDecl D) {
  return static_cast<clang::ClassTemplateSpecializationDecl *>(D)->getSpecializedTemplate();
}

CXTemplateSpecializationKind
clang_ClassTemplateSpecializationDecl_getSpecializationKind(CXClassTemplateSpecializationDecl D) {
  return static_cast<CXTemplateSpecializationKind>(
      static_cast<clang::ClassTemplateSpecializationDecl *>(D)->getSpecializationKind());
}
