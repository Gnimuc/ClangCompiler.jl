#ifndef LLVM_CLANG_C_EXTRA_CXFRONTENDACTION_H
#define LLVM_CLANG_C_EXTRA_CXFRONTENDACTION_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "clang-c/CXString.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang::FrontendAction is abstract and has no creation entry point of its own:
// every handle reaching these accessors comes from a concrete action factory
// (the clang_Emit*Action_create family in clang-ex/CodeGen/CXCodeGenAction.h)
// and is released through that class's own dispose.

// Compiler instance access
// PRECONDITION: an instance must already be registered, either by
// clang_FrontendAction_setCompilerInstance or by a BeginSourceFile run. The C++
// accessor asserts on a private member that no accessor publishes, so this one
// is documented rather than checkable.
CXCompilerInstance clang_FrontendAction_getCompilerInstance(CXFrontendAction FA);

// Not an adoption: the action stores the raw pointer and never frees it, so the
// caller keeps ownership of the instance.
void clang_FrontendAction_setCompilerInstance(CXFrontendAction FA,
                                              CXCompilerInstance Value);

// Current file information
// helper — publishes FrontendAction::getCurrentInput().isEmpty(), the gate the
// two accessors below assert on.
bool clang_FrontendAction_isCurrentInputEmpty(CXFrontendAction FA);

// PRECONDITION for both: the action must have a current input
// (!clang_FrontendAction_isCurrentInputEmpty), which only holds between
// BeginSourceFile and EndSourceFile.
bool clang_FrontendAction_isCurrentFileAST(CXFrontendAction FA);

// Caller frees the string with clang_disposeString.
CXString clang_FrontendAction_getCurrentFileOrBufferName(CXFrontendAction FA);

// Supported modes
bool clang_FrontendAction_isModelParsingAction(CXFrontendAction FA);

bool clang_FrontendAction_usesPreprocessorOnly(CXFrontendAction FA);

CXTranslationUnitKind clang_FrontendAction_getTranslationUnitKind(CXFrontendAction FA);

bool clang_FrontendAction_hasPCHSupport(CXFrontendAction FA);

bool clang_FrontendAction_hasASTFileSupport(CXFrontendAction FA);

bool clang_FrontendAction_hasIRSupport(CXFrontendAction FA);

bool clang_FrontendAction_hasCodeCompletionSupport(CXFrontendAction FA);

LLVM_CLANG_C_EXTERN_C_END

#endif
