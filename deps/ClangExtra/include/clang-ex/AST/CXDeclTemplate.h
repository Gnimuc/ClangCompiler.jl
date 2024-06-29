#ifndef LIBCLANGEX_CXDECLTEMPLATE_H
#define LIBCLANGEX_CXDECLTEMPLATE_H

#include "clang-ex/AST/CXDecl.h"
#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"

#ifdef __cplusplus
extern "C" {
#endif

// TemplateParameterList
CINDEX_LINKAGE CXNamedDecl clang_TemplateParameterList_getParam(CXTemplateParameterList TPL,
                                                                unsigned Idx);

CINDEX_LINKAGE unsigned clang_TemplateParameterList_size(CXTemplateParameterList TPL);

// TemplateArgumentList
CINDEX_LINKAGE CXTemplateArgumentList clang_TemplateArgumentList_CreateCopy(
    CXASTContext Context, CXTemplateArgument Args, size_t ArgNum);

CINDEX_LINKAGE unsigned clang_TemplateArgumentList_size(CXTemplateArgumentList TAL);

CINDEX_LINKAGE CXTemplateArgument
clang_TemplateArgumentList_data(CXTemplateArgumentList TAL);

CINDEX_LINKAGE CXTemplateArgument clang_TemplateArgumentList_get(CXTemplateArgumentList TAL,
                                                                 unsigned Idx);

// TemplateDecl
CINDEX_LINKAGE void clang_TemplateDecl_init(CXTemplateDecl TD, CXNamedDecl ND,
                                            CXTemplateParameterList TP);

// RedeclarableTemplateDecl
CINDEX_LINKAGE CXRedeclarableTemplateDecl
clang_RedeclarableTemplateDecl_getCanonicalDecl(CXRedeclarableTemplateDecl RTD);

CINDEX_LINKAGE bool
clang_RedeclarableTemplateDecl_isMemberSpecialization(CXRedeclarableTemplateDecl RTD);

CINDEX_LINKAGE void
clang_RedeclarableTemplateDecl_setMemberSpecialization(CXRedeclarableTemplateDecl RTD);

// ClassTemplateDecl
CINDEX_LINKAGE CXCXXRecordDecl
clang_ClassTemplateDecl_getTemplatedDecl(CXClassTemplateDecl CTD);

CINDEX_LINKAGE bool
clang_ClassTemplateDecl_isThisDeclarationADefinition(CXClassTemplateDecl CTD);

CINDEX_LINKAGE CXClassTemplateSpecializationDecl clang_ClassTemplateDecl_findSpecialization(
    CXClassTemplateDecl CTD, CXTemplateArgumentList TAL, void *InsertPos);

CINDEX_LINKAGE void clang_ClassTemplateDecl_AddSpecialization(
    CXClassTemplateDecl CTD, CXClassTemplateSpecializationDecl CTSD, void *InsertPos);

CINDEX_LINKAGE CXClassTemplateDecl
clang_ClassTemplateDecl_getCanonicalDecl(CXClassTemplateDecl CTD);

CINDEX_LINKAGE CXClassTemplateDecl
clang_ClassTemplateDecl_getPreviousDecl(CXClassTemplateDecl CTD);

CINDEX_LINKAGE CXClassTemplateDecl
clang_ClassTemplateDecl_getMostRecentDecl(CXClassTemplateDecl CTD);

// ClassTemplateSpecializationDecl
CINDEX_LINKAGE CXClassTemplateSpecializationDecl
clang_ClassTemplateSpecializationDecl_Create(CXASTContext Context, CXTagTypeKind TK,
                                             CXDeclContext DC, CXSourceLocation_ StartLoc,
                                             CXSourceLocation_ IdLoc,
                                             CXClassTemplateDecl SpecializedTemplate,
                                             CXTemplateArgumentList Args,
                                             CXClassTemplateSpecializationDecl PrevDecl);

CINDEX_LINKAGE CXTemplateArgumentList clang_ClassTemplateSpecializationDecl_getTemplateArgs(
    CXClassTemplateSpecializationDecl CTSD);

CINDEX_LINKAGE void clang_ClassTemplateSpecializationDecl_setTemplateArgs(
    CXClassTemplateSpecializationDecl CTSD, CXTemplateArgumentList TAL);

#ifdef __cplusplus
}
#endif
#endif