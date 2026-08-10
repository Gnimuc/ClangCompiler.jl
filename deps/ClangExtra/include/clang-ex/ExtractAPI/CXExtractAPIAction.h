#ifndef LLVM_CLANG_C_EXTRA_CXEXTRACTAPIACTION_H
#define LLVM_CLANG_C_EXTRA_CXEXTRACTAPIACTION_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang::ExtractAPIAction (clang/ExtractAPI/FrontendActions.h).
//
// The file is named after the class rather than after the clang header: three different
// clang headers in this tree are called FrontendActions.h, and a clang-ex header's include
// guard is derived from its basename, so same-named files would silently collide.
//
// This is the -extract-api pipeline: it synthesizes one header including all of the
// invocation's inputs, walks the resulting AST, and writes the API surface as Symbol Graph
// JSON (the swift-docc-symbolkit format) to the invocation's output file. Nothing of
// clang's ExtractAPI C++ types (APISet, APIRecord, ...) crosses this boundary -- the
// deliverable is the JSON, which is versioned and far more stable than those classes, and
// which a caller parses in Julia.
//
// Like the clang_Emit*Action_create family, the factory hands back the BASE
// CXFrontendAction handle: the accessors in clang-ex/Frontend/CXFrontendAction.h apply,
// the run goes through clang_CompilerInstance_ExecuteAction, and the output path comes
// from the invocation (-o).
CXFrontendAction clang_ExtractAPIAction_create(void);

// Frees an action that was never executed, or one whose ExecuteAction has returned:
// clang_CompilerInstance_ExecuteAction borrows the action and does not adopt it.
void clang_ExtractAPIAction_dispose(CXFrontendAction FA);

// WrappingExtractAPIAction -- its only constructor consumes a
// `std::unique_ptr<FrontendAction>` for the action it wraps, i.e. an adoption of another
// handle; the plain action above is the one that needs no second action to exist.

LLVM_CLANG_C_EXTERN_C_END

#endif
