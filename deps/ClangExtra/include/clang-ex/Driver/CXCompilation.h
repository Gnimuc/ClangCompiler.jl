#ifndef LLVM_CLANG_C_EXTRA_CXCOMPILATION_H
#define LLVM_CLANG_C_EXTRA_CXCOMPILATION_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// A Compilation is produced by clang_Driver_BuildCompilation and owned by the caller.
// Its destructor reads the Driver that built it (to decide whether -save-temps keeps the
// temporary files), so dispose the Compilation BEFORE that Driver.
void clang_Compilation_dispose(CXCompilation C);

// Borrowed: the Driver that built this compilation, not a copy.
CXDriver clang_Compilation_getDriver(CXCompilation C);

// Borrowed: toolchains are created and cached by the Driver and live as long as it does.
CXToolChain clang_Compilation_getDefaultToolChain(CXCompilation C);

// Bit mask of the Action::OffloadKind values the host has to support in this
// compilation; 0 (OFK_None) for an ordinary host-only compilation.
unsigned clang_Compilation_getActiveOffloadKinds(CXCompilation C);

CXString clang_Compilation_getSysRoot(CXCompilation C);

// The temporary files registered with the compilation, as a count + index pair. The
// count is exact and no slot is null; the returned pointers are borrowed from the
// compilation's own argument storage and are never freed. The destructor deletes the
// files themselves unless -save-temps is in effect.
unsigned clang_Compilation_getNumTempFiles(CXCompilation C);

const char *clang_Compilation_getTempFile(CXCompilation C, unsigned i);

bool clang_Compilation_isForDiagnostics(CXCompilation C);

// Compilation::ContainsError has no in-class initializer, but it is a constructor
// parameter that every construction path assigns, and the only way to obtain a
// Compilation here is clang_Driver_BuildCompilation, so it is always initialized.
bool clang_Compilation_containsError(CXCompilation C);

// Sets the bit; there is no C++ API to clear it again.
void clang_Compilation_setContainsError(CXCompilation C);

// Borrowed: the compilation's own job list — one Command per subprocess the driver
// planned. Both it and every Command in it die with the Compilation; see
// clang-ex/Driver/CXJob.h.
CXJobList clang_Compilation_getJobs(CXCompilation C);

// Runs `Jobs` and reports which commands failed.
//
// `*NumFailing` receives the total number of failures; the first min(N, *NumFailing) of
// them are written into `FailingResults` (the child's result code) and `FailingCommands`
// (the Command, borrowed from the job list). No failure can come from a command that is
// not in `Jobs`, so sizing the two buffers at clang_JobList_size(Jobs) always reports
// every one of them. `NumFailing` may be NULL, and so may the buffers when N is 0.
//
// With `LogOnly` set nothing is executed and the commands are only logged, which is what
// makes this callable in a test.
void clang_Compilation_ExecuteJobs(CXCompilation C, CXJobList Jobs, bool LogOnly,
                                   unsigned *NumFailing, int *FailingResults,
                                   CXCommand *FailingCommands, unsigned N);

// Sends the child processes' stdin, stdout and stderr to the named files; a NULL path
// leaves that stream alone. clang stores the paths as non-owning StringRefs, so the shim
// first copies them into the compilation's own argument allocator — they then live exactly
// as long as the compilation does.
//
// clang's own comment: this can only be done once.
void clang_Compilation_Redirect(CXCompilation C, const char *In, const char *Out,
                                const char *Err);

// initCompilationForDiagnostics / getInputArgs / getArgs / getActions /
// getTempFiles' map-valued siblings / ExecuteCommand are deliberately not wrapped:
// they need ArgList or Action handles.

LLVM_CLANG_C_EXTERN_C_END

#endif
