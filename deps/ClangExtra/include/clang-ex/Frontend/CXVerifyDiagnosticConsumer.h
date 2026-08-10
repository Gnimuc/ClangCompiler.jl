#ifndef LLVM_CLANG_C_EXTRA_CXVERIFYDIAGNOSTICCONSUMER_H
#define LLVM_CLANG_C_EXTRA_CXVERIFYDIAGNOSTICCONSUMER_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// The consumer behind `-verify`: it reads `expected-error`, `expected-warning`,
// `expected-note` and `expected-remark` comments out of the source being parsed and, when
// the source file ends, reports a diagnostic of its own for every mismatch between what was
// expected and what clang actually emitted.
//
// PRECONDITION: Diags's DiagnosticOptions must already list at least one verify prefix
// (clang_DiagnosticOptions_addVerifyPrefix). clang fills VerifyPrefixes from `-verify`
// alone, and a consumer installed by hand therefore starts with none -- in which case no
// comment in any source is a directive and the consumer reports that as an error.
//
// The engine is stored by reference and must outlive the consumer. It is also where the
// mismatch reports go: the consumer takes over the engine's current client as its own
// primary at construction (DiagnosticsEngine::takeClient), so `Diags` must already have the
// client that should print them.
//
// The destructor runs one final check through both the engine and that captured client, so
// neither may be released first -- and the consumer must be off the engine before it is
// disposed, or the engine is left with a dangling client.
//
// Verification runs in EndSourceFile, so a caller driving the parse by hand only gets an
// answer once the source file has been ended -- through
// clang_DiagnosticConsumer_EndSourceFile if nothing else does it.
//
// Returns the base handle; released with clang_DiagnosticConsumer_dispose unless an engine
// that owns its client has since taken it.
CXDiagnosticConsumer clang_VerifyDiagnosticConsumer_create(CXDiagnosticsEngine Diags);

LLVM_CLANG_C_EXTERN_C_END

#endif
