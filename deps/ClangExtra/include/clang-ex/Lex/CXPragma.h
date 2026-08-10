#ifndef LLVM_CLANG_C_EXTRA_CXPRAGMA_H
#define LLVM_CLANG_C_EXTRA_CXPRAGMA_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// The pragma handler tree. `clang_Preprocessor_IgnorePragmas` is the blunt version of
// this -- it swaps the whole tree for one that swallows everything; here a single noisy
// `#pragma foo` can be silenced while the rest keep their meaning.
//
// OWNERSHIP, and it is the opposite of what the raw pointer in the signature suggests:
// since the handler tree stores `std::unique_ptr<PragmaHandler>`, both `AddPragma` and
// `AddPragmaHandler` TRANSFER ownership of the handler into the tree, and
// `RemovePragmaHandler` releases it back to the caller. So a handler that is currently
// registered must NOT be disposed (that is a double delete when the tree is torn down),
// and must not be left registered past the preprocessor's own lifetime. Remove first,
// then dispose.
//
// Only clang's own EmptyPragmaHandler and PragmaNamespace are constructible here: a
// handler with a Julia-defined `HandlePragma` needs a callback trampoline, which the shim
// does not have.

// PragmaHandler

// The name the handler is registered under; empty for the null handler, which runs for
// any pragma no named handler matched.
CXString clang_PragmaHandler_getName(CXPragmaHandler H);

// HandlePragma

// Non-NULL exactly when `H` is a PragmaNamespace. This is clang's RTTI-free downcast, so
// it is also what turns a handler found by `FindHandler` back into a namespace to walk.
CXPragmaNamespace clang_PragmaHandler_getIfNamespace(CXPragmaHandler H);

// EmptyPragmaHandler

// A handler that does nothing, which is how a specific pragma is ignored rather than
// warned about. `Name` may be NULL, which makes it the namespace's null handler and so
// swallows every otherwise-unhandled pragma in that namespace. Release with
// `clang_EmptyPragmaHandler_dispose` -- but see the ownership note above.
CXEmptyPragmaHandler clang_EmptyPragmaHandler_create(const char *Name);

// ADOPTION: illegal while the handler is registered with a PragmaNamespace or a
// Preprocessor -- the tree deletes what it owns. Remove it first.
void clang_EmptyPragmaHandler_dispose(CXEmptyPragmaHandler H);

// PragmaNamespace

// A handler that is itself a table of handlers, which is how `#pragma GCC ...` and
// `#pragma omp ...` are structured.
CXPragmaNamespace clang_PragmaNamespace_create(const char *Name);

// ADOPTION: illegal while the namespace is registered with a Preprocessor. Disposing it
// also destroys every handler it owns.
void clang_PragmaNamespace_dispose(CXPragmaNamespace NS);

// The handler registered under `Name`, or NULL. When `IgnoreNull` is false a failed match
// falls back to the namespace's null handler (the one registered with an empty name)
// instead of returning NULL.
CXPragmaHandler clang_PragmaNamespace_FindHandler(CXPragmaNamespace NS, const char *Name,
                                                  bool IgnoreNull);

// ADOPTION: `NS` takes ownership of `Handler`. Precondition: no handler is registered
// under `Handler`'s name yet; clang asserts.
void clang_PragmaNamespace_AddPragma(CXPragmaNamespace NS, CXPragmaHandler Handler);

// Releases ownership of `Handler` back to the caller. Precondition: `Handler` is
// currently registered in `NS`; clang asserts.
void clang_PragmaNamespace_RemovePragmaHandler(CXPragmaNamespace NS,
                                               CXPragmaHandler Handler);

bool clang_PragmaNamespace_IsEmpty(CXPragmaNamespace NS);

// prepare_PragmaString

// Preprocessor
//
// Registration lives here rather than in CXPreprocessor.h because the ownership contract
// it participates in is the one documented above. The preprocessor's own root namespace
// is a private member with no accessor, so the installed tree cannot be walked from
// outside -- introspection reaches only namespaces the caller built.

// ADOPTION: the preprocessor takes ownership of `Handler`. `Namespace` may be NULL for
// the top level; a namespace that does not exist yet is created. Precondition: nothing is
// registered under `Handler`'s name in that namespace yet; clang asserts.
void clang_Preprocessor_AddPragmaHandler(CXPreprocessor PP, const char *Namespace,
                                         CXPragmaHandler Handler);

// Releases ownership of `Handler` back to the caller, and drops the namespace when it
// becomes empty. Precondition: `Handler` is currently registered under `Namespace`; clang
// asserts both that the namespace exists and that the handler is in it.
void clang_Preprocessor_RemovePragmaHandler(CXPreprocessor PP, const char *Namespace,
                                            CXPragmaHandler Handler);

LLVM_CLANG_C_EXTERN_C_END

#endif
