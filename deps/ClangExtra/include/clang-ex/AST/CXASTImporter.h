#ifndef LLVM_CLANG_C_EXTRA_CXASTIMPORTER_H
#define LLVM_CLANG_C_EXTRA_CXASTIMPORTER_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang/AST/ASTImportError.h: enum clang::ASTImportError::ErrorKind — why an import of a
// declaration failed. Read back per decl with clang_ASTImporter_getImportDeclErrorIfAny.
typedef enum CXASTImportError_ErrorKind {
  CXASTImportError_NameConflict,
  CXASTImportError_UnsupportedConstruct,
  CXASTImportError_Unknown
} CXASTImportError_ErrorKind;

// clang/AST/ASTImporter.h: enum class ASTImporter::ODRHandlingType — whether a
// structural mismatch between two definitions of the same entity is an error
// (Conservative) or tolerated (Liberal).
typedef enum CXASTImporter_ODRHandlingType {
  CXASTImporter_Conservative,
  CXASTImporter_Liberal
} CXASTImporter_ODRHandlingType;

// getCanonicalForwardRedeclChain

// ASTImporter
//
// The one supported way to move AST nodes between two ASTContexts: every Import overload
// below maps a node of the "from" context onto an equivalent node of the "to" context,
// creating it there when it is not already present and reusing it when it is. That is what
// makes declarations parsed in a side translation unit — different flags, a separate parse —
// usable inside another context's AST.
//
// Caller-owned: clang_ASTImporter_create returns a heap object, release it with
// clang_ASTImporter_dispose. It must not outlive either context or either file manager, and
// the nodes it hands back are arena memory of the "to" context (borrowed).
//
// ERRORS. Every Import overload is llvm::Expected in C++. Nothing throws across this
// boundary: the shim consumes the error, logs it, and answers the null
// sentinel — a null handle, a null QualType, an invalid SourceLocation. Which failure it was
// is recorded per declaration and readable with clang_ASTImporter_getImportDeclErrorIfAny.
// clang_ASTImporter_ImportDefinition, whose C++ result is a bare llvm::Error, instead
// returns the message: an EMPTY CXString is success.
//
// MinimalImport true asks the importer to create to-be-completed forward declarations
// wherever it can rather than pulling in whole definitions; SharedState (the cross-importer
// lookup table) is not exposed and is always null, so each importer uses the plain C/C++
// lookup of the destination context.
CXASTImporter clang_ASTImporter_create(CXASTContext ToContext, CXFileManager ToFileManager,
                                       CXASTContext FromContext,
                                       CXFileManager FromFileManager, bool MinimalImport);

void clang_ASTImporter_dispose(CXASTImporter Importer);

bool clang_ASTImporter_isMinimalImport(CXASTImporter Importer);

void clang_ASTImporter_setODRHandling(CXASTImporter Importer,
                                      CXASTImporter_ODRHandlingType T);

// importInto

// Import(ExprWithCleanups::CleanupObject)

// The imported form of a bare Type. NULL on failure.
CXType_ clang_ASTImporter_ImportType(CXASTImporter Importer, CXType_ FromT);

// The imported form of a qualified type. A null QualType imports as a null QualType with no
// error, so a NULL answer here is either "nothing was asked for" or a failure; the log line
// distinguishes them.
CXQualType clang_ASTImporter_ImportQualType(CXASTImporter Importer, CXQualType FromT);

CXTypeSourceInfo clang_ASTImporter_ImportTypeSourceInfo(CXASTImporter Importer,
                                                        CXTypeSourceInfo FromTSI);

CXAttr clang_ASTImporter_ImportAttr(CXASTImporter Importer, CXAttr FromAttr);

// The imported form of a declaration — the entry point the whole class exists for. The
// result belongs to the "to" context's arena and is already attached to its DeclContext
// there. NULL on failure.
CXDecl clang_ASTImporter_ImportDecl(CXASTImporter Importer, CXDecl FromD);

// Import(const InheritedConstructor &)

// The copy of FromD already made in the "to" context, or NULL when it has not been imported
// yet. Unlike clang_ASTImporter_ImportDecl this never imports anything.
CXDecl clang_ASTImporter_GetAlreadyImportedOrNull(CXASTImporter Importer, CXDecl FromD);

// The translation unit ToD was imported from, or NULL.
CXTranslationUnitDecl clang_ASTImporter_GetFromTU(CXASTImporter Importer, CXDecl ToD);

// getImportedFromDecl

CXDeclContext clang_ASTImporter_ImportContext(CXASTImporter Importer,
                                              CXDeclContext FromDC);

CXExpr clang_ASTImporter_ImportExpr(CXASTImporter Importer, CXExpr FromE);

CXStmt clang_ASTImporter_ImportStmt(CXASTImporter Importer, CXStmt FromS);

CXNestedNameSpecifier
clang_ASTImporter_ImportNestedNameSpecifier(CXASTImporter Importer,
                                            CXNestedNameSpecifier FromNNS);

// Import(NestedNameSpecifierLoc)

// The imported template name. Value class, crossing as its void-pointer encoding.
CXTemplateName clang_ASTImporter_ImportTemplateName(CXASTImporter Importer,
                                                    CXTemplateName From);

// The same location expressed in the "to" context's SourceManager — the file it came from
// is entered there on demand. An invalid (NULL) location is the failure sentinel and also
// the faithful import of an invalid location.
CXSourceLocation_ clang_ASTImporter_ImportSourceLocation(CXASTImporter Importer,
                                                         CXSourceLocation_ FromLoc);

CXSourceRange_ clang_ASTImporter_ImportSourceRange(CXASTImporter Importer,
                                                   CXSourceRange_ FromRange);

CXDeclarationName clang_ASTImporter_ImportDeclarationName(CXASTImporter Importer,
                                                          CXDeclarationName FromName);

// The identifier of the same spelling in the "to" context's identifier table. This one
// overload is not fallible in C++ either: it answers NULL only for a NULL argument.
CXIdentifierInfo clang_ASTImporter_ImportIdentifierInfo(CXASTImporter Importer,
                                                        CXIdentifierInfo FromId);

// Import(Selector)
// Import(FileID, bool)

CXCXXCtorInitializer clang_ASTImporter_ImportCXXCtorInitializer(CXASTImporter Importer,
                                                                CXCXXCtorInitializer FromInit);

CXCXXBaseSpecifier clang_ASTImporter_ImportCXXBaseSpecifier(CXASTImporter Importer,
                                                            CXCXXBaseSpecifier FromSpec);

// The imported value. APValue is a value class, so the result is a heap box the CALLER
// owns: release it with clang_APValue_dispose. NULL on failure.
CXAPValue clang_ASTImporter_ImportAPValue(CXASTImporter Importer, CXAPValue FromValue);

// Import From and then fill the copy in with everything From's definition contains -- the
// completion clang_ASTImporter_ImportDecl leaves out under MinimalImport. From is a
// "from"-context declaration, not the copy.
// PRECONDITION: From must be a DeclContext (a record, an enum, a namespace, an ObjC
// interface...) -- clang opens with cast<DeclContext>(From). The Julia layer restates it as
// dispatch over the decls clang marks DECL_CONTEXT.
// The C++ result is a bare llvm::Error, so this returns its message: an EMPTY CXString is
// success. The CXString is caller-owned either way.
CXString clang_ASTImporter_ImportDefinition(CXASTImporter Importer, CXDecl From);

// HandleNameConflict

CXASTContext clang_ASTImporter_getToContext(CXASTImporter Importer);

CXASTContext clang_ASTImporter_getFromContext(CXASTImporter Importer);

CXFileManager clang_ASTImporter_getToFileManager(CXASTImporter Importer);

CXFileManager clang_ASTImporter_getFromFileManager(CXASTImporter Importer);

// ToDiag
// FromDiag
// getNonEquivalentDecls

// Fill D in as much as possible; D lives in the "to" context.
// PRECONDITION: D must be an ObjCInterfaceDecl, an ObjCProtocolDecl or a TagDecl -- the
// dispatch chain ends in `assert(0 && "CompleteDecl called on a Decl that can't be
// completed")`. Restated as an @assert in the Julia layer.
void clang_ASTImporter_CompleteDecl(CXASTImporter Importer, CXDecl D);

// Record FromD -> ToD in the importer's map and add ToD to the lookup table, without
// importing anything. Carries MapImported's precondition below.
void clang_ASTImporter_RegisterImportedDecl(CXASTImporter Importer, CXDecl FromD,
                                            CXDecl ToD);

// Record From -> To and return To. Several "from" decls may map onto the same "to" decl.
// PRECONDITION: From must not already be mapped to a DIFFERENT decl -- clang asserts
// "Try to import an already imported Decl". Restated as an @assert in the Julia layer,
// where clang_ASTImporter_GetAlreadyImportedOrNull answers exactly what the assert reads.
CXDecl clang_ASTImporter_MapImported(CXASTImporter Importer, CXDecl From, CXDecl To);

// Imported
// GetOriginalDecl

// The first error the import of FromD hit, if any. HasError is an out-parameter and must
// not be NULL: the return value is meaningless when it comes back false, because clang's
// answer is a std::optional and Unknown is a real error kind (MARSHALLING.md §8).
CXASTImportError_ErrorKind
clang_ASTImporter_getImportDeclErrorIfAny(CXASTImporter Importer, CXDecl FromD,
                                          bool *HasError);

// PRECONDITION: From must have no error recorded yet, or the SAME error -- clang asserts
// that the insertion either happened or found an equal kind. Restated as an @assert in the
// Julia layer.
void clang_ASTImporter_setImportDeclError(CXASTImporter Importer, CXDecl From,
                                          CXASTImportError_ErrorKind Error);

// Whether the two types are structurally equivalent, using the importer's own
// non-equivalence cache. Complain routes the mismatch through the "to" context's
// diagnostics.
bool clang_ASTImporter_IsStructurallyEquivalent(CXASTImporter Importer, CXQualType From,
                                                CXQualType To, bool Complain);

// getFieldIndex -- the static answers the same number clang_FieldDecl_getFieldIndex
// already does, and the Julia layer spells that one `getFieldIndex` over an
// AbstractFieldDecl. A second method of that name over AbstractDecl with a different
// return convention (an index or nothing, because the static's std::optional is empty for
// a non-record parent) would make one name mean two things, so it is left unwrapped until
// an IndirectFieldDecl caller needs it.

LLVM_CLANG_C_EXTERN_C_END

#endif
