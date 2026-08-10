#ifndef LLVM_CLANG_C_EXTRA_CXSERIALIZEDDIAGNOSTICPRINTER_H
#define LLVM_CLANG_C_EXTRA_CXSERIALIZEDDIAGNOSTICPRINTER_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// A diagnostic consumer that writes each diagnostic to `OutputFile` in the `.dia` bitcode
// format libclang's own diagnostic reader understands, so a build system or IDE gets
// structured diagnostics without parsing clang's text output.
//
// The file is written incrementally and finished in the consumer's `finish()`, which
// clang_DiagnosticConsumer_finish reaches: a consumer that is disposed without a parse
// having ended still leaves a valid, empty `.dia`, but a caller driving the pipeline by
// hand should call finish before reading the file.
//
// `Diags` is the DiagnosticOptions the serializer reads its formatting settings from; it is
// stored by reference and must outlive the consumer.
//
// MergeChildRecords folds diagnostics from an already-existing `.dia` at the same path into
// the new one, which is what clang does for a driver run whose cc1 subprocesses each wrote
// their own file.
//
// Returns the base handle; released with clang_DiagnosticConsumer_dispose unless an engine
// that owns its client has since taken it.
CXDiagnosticConsumer clang_serialized_diags_create(const char *OutputFile,
                                                   CXDiagnosticOptions Diags,
                                                   bool MergeChildRecords);

LLVM_CLANG_C_EXTERN_C_END

#endif
