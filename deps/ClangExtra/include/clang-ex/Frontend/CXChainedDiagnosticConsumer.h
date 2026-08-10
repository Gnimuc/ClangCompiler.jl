#ifndef LLVM_CLANG_C_EXTRA_CXCHAINEDDIAGNOSTICCONSUMER_H
#define LLVM_CLANG_C_EXTRA_CXCHAINEDDIAGNOSTICCONSUMER_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Sends every diagnostic to two clients in turn, which is how a program both echoes
// diagnostics to the terminal and keeps them for inspection: a DiagnosticsEngine has room
// for exactly one client.
//
// `Primary` is the client whose IncludeInDiagnosticCounts() decides whether a diagnostic
// counts, and it is NOT adopted -- this uses clang::ChainedDiagnosticConsumer's
// non-owning-primary constructor, so the caller still disposes it and must keep it alive at
// least as long as the chain.
//
// ADOPTION: `Secondary` IS adopted (the constructor takes it by unique_ptr), so its own
// dispose becomes a double free the moment this returns.
//
// The chain itself returns the base handle and is released with
// clang_DiagnosticConsumer_dispose -- unless it has since been handed to an engine that
// owns its client, the usual DiagnosticConsumer rule.
CXDiagnosticConsumer clang_ChainedDiagnosticConsumer_create(CXDiagnosticConsumer Primary,
                                                            CXDiagnosticConsumer Secondary);

LLVM_CLANG_C_EXTERN_C_END

#endif
