#ifndef LLVM_CLANG_C_EXTRA_CXVERSION_H
#define LLVM_CLANG_C_EXTRA_CXVERSION_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// The version strings of the clang this shim is linked against, all free functions in
// namespace clang. Each returns a freshly built std::string on the C++ side, so each
// crosses as an owned CXString; release with clang_disposeString.
//
// These answer a question the pinned bindings cannot: lib/<major>/LibClangEx.jl is
// generated against one clang release, and the library actually loaded at run time is
// whichever libclang-cpp the artifact provides. clang_getClangFullVersion is what makes
// that mismatch observable instead of latent.

// "clang version 18.1.7 (...)" — the banner, including the repository version and the
// vendor tag.
CXString clang_getClangFullVersion(void);

// The same banner with a caller-chosen tool name substituted for "clang".
CXString clang_getClangToolFullVersion(const char *ToolName);

// The repository path clang was built from; empty when the build recorded none.
CXString clang_getClangRepositoryPath(void);

// The revision (a git hash, for a git build) clang was built from; empty when the build
// recorded none.
CXString clang_getClangRevision(void);

// The revision LLVM was built from. The same string as clang_getClangRevision when both
// live in one repository, which is the usual arrangement.
CXString clang_getLLVMRevision(void);

// The vendor tag, e.g. "Apple " for Apple's clang; empty for an unbranded build.
CXString clang_getClangVendor(void);

// The version string clang expands __VERSION__ to.
CXString clang_getClangFullCPPVersion(void);

LLVM_CLANG_C_EXTERN_C_END

#endif
