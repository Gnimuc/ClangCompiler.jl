#ifndef LLVM_CLANG_C_EXTRA_CXTYPOCORRECTION_H
#define LLVM_CLANG_C_EXTRA_CXTYPOCORRECTION_H

#include "clang-ex/CXTypes.h"
#include "clang-ex/Sema/CXLookup.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "clang-c/CXString.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang/Sema/Sema.h: enum Sema::CorrectTypoKind. Declared here rather than in CXSema.h for
// the same reason CXRedeclarationKind is in CXLookup.h: CXSema.h includes this header.
typedef enum CXCorrectTypoKind {
  CXCorrectTypoKind_CTK_NonError,
  CXCorrectTypoKind_CTK_ErrorRecovery
} CXCorrectTypoKind;

// Which of clang's concrete CorrectionCandidateCallback filters to build. The callback is
// how CorrectTypo decides whether a near-miss name is an acceptable suggestion, and it is a
// virtual interface: only these three fixed subclasses are reachable from here, since a
// Julia-authored filter would need a callback trampoline the shim does not have.
typedef enum CXCorrectionCandidateCallbackKind {
  // Accepts any name that is not a keyword-only or unrelated match -- clang's default.
  CXCorrectionCandidateCallbackKind_Default,
  // Accepts only names that resolve to a declaration.
  CXCorrectionCandidateCallbackKind_Decl,
  // Accepts only names callable with a given argument count.
  CXCorrectionCandidateCallbackKind_FunctionCall
} CXCorrectionCandidateCallbackKind;

// Build one of the three fixed filters. NumArgs and HasExplicitTemplateArgs are read only
// by the FunctionCall kind and ignored by the other two. Caller-owned.
CXCorrectionCandidateCallback
clang_CorrectionCandidateCallback_create(CXCorrectionCandidateCallbackKind Kind, CXSema S,
                                         unsigned NumArgs, bool HasExplicitTemplateArgs);

void clang_CorrectionCandidateCallback_dispose(CXCorrectionCandidateCallback CCC);

// TypoCorrection

// Look for a declaration whose name is near Typo's and that CCC accepts. Returns a
// correction that may be empty -- clang_TypoCorrection_isEmpty is the check -- rather than
// null. Caller-owned: clang returns the correction by value, so this is a heap box.
//
// SS and MemberContext may be NULL for an ordinary unqualified lookup. Mode selects whether
// the lookup is part of error recovery, which is what decides if clang records the failure
// and suppresses later attempts on the same name.
CXTypoCorrection clang_Sema_CorrectTypo(CXSema S, CXDeclarationNameInfo Typo,
                                        CXLookupNameKind LookupKind, CXScope Scp,
                                        CXCXXScopeSpec SS,
                                        CXCorrectionCandidateCallback CCC,
                                        CXCorrectTypoKind Mode, CXDeclContext MemberContext,
                                        bool EnteringContext, bool RecordFailure);

void clang_TypoCorrection_dispose(CXTypoCorrection TC);

// Whether the correction names nothing -- what a failed lookup returns. clang spells this
// as the correction's operator bool.
bool clang_TypoCorrection_isEmpty(CXTypoCorrection TC);

// Whether the correction resolved to a keyword or to at least one declaration. An
// unresolved non-empty correction is a name clang suggests without having found what it
// names.
bool clang_TypoCorrection_isResolved(CXTypoCorrection TC);

bool clang_TypoCorrection_isOverloaded(CXTypoCorrection TC);

// The suggested name. Crosses as the DeclarationName opaque encoding.
CXDeclarationName clang_TypoCorrection_getCorrection(CXTypoCorrection TC);

// The suggested spelling. LO is needed because the rendering depends on the language.
CXString clang_TypoCorrection_getAsString(CXTypoCorrection TC, CXLangOptions LO);

// Edit distance from the typo to the suggestion. Normalized scales it by the name's length,
// which is how clang ranks candidates against each other.
unsigned clang_TypoCorrection_getEditDistance(CXTypoCorrection TC, bool Normalized);

// The declaration the correction names, NULL when it corrects to a keyword or names
// nothing.
CXNamedDecl clang_TypoCorrection_getCorrectionDecl(CXTypoCorrection TC);

// Whether the correction is a keyword rather than a declaration.
bool clang_TypoCorrection_isKeyword(CXTypoCorrection TC);

LLVM_CLANG_C_EXTERN_C_END

#endif
