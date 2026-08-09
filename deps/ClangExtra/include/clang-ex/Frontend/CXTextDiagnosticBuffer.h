#ifndef LLVM_CLANG_C_EXTRA_CXTEXTDIAGNOSTICBUFFER_H
#define LLVM_CLANG_C_EXTRA_CXTEXTDIAGNOSTICBUFFER_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// A diagnostic consumer that records every diagnostic instead of printing it, so the
// message text and location of each one can be read back -- which
// clang_DiagnosticsEngine_getNumErrors, a count, cannot give. Like the other consumer
// creates, this returns the base handle and is released with
// clang_DiagnosticConsumer_dispose.
CXDiagnosticConsumer clang_TextDiagnosticBuffer_create(void);

// clang buffers into exactly four lists. This is its own enum rather than
// CXDiagnosticsEngine_Level because that one also names Ignored, which is buffered
// nowhere, and Fatal, which shares the error list -- selecting a list is total over these
// four and partial over those six. Indices are 0-origin within a level, in the order the
// diagnostics were emitted; clang keeps a fifth list interleaving the levels but exposes
// no accessor for it, so cross-level order cannot be recovered here.
typedef enum CXTextDiagnosticBuffer_Level {
  CXTextDiagnosticBuffer_Note,
  CXTextDiagnosticBuffer_Remark,
  CXTextDiagnosticBuffer_Warning,
  // Fatal diagnostics land here too.
  CXTextDiagnosticBuffer_Error
} CXTextDiagnosticBuffer_Level;

// Every accessor below downcasts DC to clang::TextDiagnosticBuffer unchecked: it must be a
// handle clang_TextDiagnosticBuffer_create returned.
unsigned clang_TextDiagnosticBuffer_size(CXDiagnosticConsumer DC,
                                         CXTextDiagnosticBuffer_Level Level);

// PRECONDITION: Idx < clang_TextDiagnosticBuffer_size for the same level.
CXString clang_TextDiagnosticBuffer_getMessage(CXDiagnosticConsumer DC,
                                               CXTextDiagnosticBuffer_Level Level,
                                               unsigned Idx);

// PRECONDITION: Idx < clang_TextDiagnosticBuffer_size for the same level. The location is
// only meaningful against the SourceManager that was live when the diagnostic was emitted,
// and is invalid for a diagnostic raised before any file was entered.
CXSourceLocation_ clang_TextDiagnosticBuffer_getLocation(CXDiagnosticConsumer DC,
                                                         CXTextDiagnosticBuffer_Level Level,
                                                         unsigned Idx);

// Replays every buffered diagnostic into DE, which reports them through its own consumer.
// PRECONDITION: DE's client must not be DC. clang walks the interleaved list while
// reporting, and reporting into this same buffer appends to that list mid-walk, so the
// iteration runs off the end of a reallocated vector.
void clang_TextDiagnosticBuffer_FlushDiagnostics(CXDiagnosticConsumer DC,
                                                 CXDiagnosticsEngine DE);

LLVM_CLANG_C_EXTERN_C_END

#endif
