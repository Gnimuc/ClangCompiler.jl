#ifndef LLVM_CLANG_C_EXTRA_CXFRONTENDTOOLUTILS_H
#define LLVM_CLANG_C_EXTRA_CXFRONTENDTOOLUTILS_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Mirrors clang/FrontendTool/Utils.h. The file is not called CXUtils.h because
// clang-ex/Frontend/CXUtils.h already is: include guards here are derived from the
// basename alone and have to be unique, so two mirrors of two different Utils.h
// cannot both keep the plain name.

// Builds the FrontendAction that FrontendOpts.ProgramAction names -- the whole cc1 action
// zoo, including the ones this library has no factory for (-E, -ast-dump, the rewriters,
// the analyzer, plugin actions), plus the AST-merge and FixIt wrappers clang layers on top
// of them.
//
// Set the action first with clang_FrontendOptions_setProgramAction on
// clang_CompilerInstance_getFrontendOpts; the default is ParseSyntaxOnly.
//
// PRECONDITION: the instance must have both diagnostics and an invocation. It reads
// FrontendOpts through `Invocation->`, an unchecked dereference, and reports an
// unrecognised or unavailable action through getDiagnostics(), which asserts on a null
// member; such an action is answered with NULL.
//
// The action is caller-owned. Its dynamic type is whatever clang chose, so it is released
// with the base clang_FrontendAction_dispose from clang-ex/Frontend/CXFrontendAction.h and
// not with any per-class dispose.
CXFrontendAction clang_CreateFrontendAction(CXCompilerInstance CI);

// CreateFrontendAction followed by ExecuteAction, plus the cc1 preamble clang runs around
// them: -help/-version handling, the LLVM command-line arguments in FrontendOpts.LLVMArgs,
// plugin loading, and the statistics report. This is "run this invocation the way
// `clang -cc1` would" in one call.
//
// The instance keeps ownership of everything; the action is built and destroyed inside.
// Returns false when the action could not be created or the run failed.
//
// PRECONDITION: the instance must have both diagnostics and an invocation -- it reads
// getFrontendOpts() through the invocation and reports through getDiagnostics(), and each
// of those dereferences its member unchecked.
bool clang_ExecuteCompilerInvocation(CXCompilerInstance CI);

LLVM_CLANG_C_EXTERN_C_END

#endif
