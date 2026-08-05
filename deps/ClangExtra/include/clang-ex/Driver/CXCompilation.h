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

// initCompilationForDiagnostics / getInputArgs / getArgs / getActions / getJobs /
// getTempFiles' map-valued siblings / ExecuteCommand / ExecuteJobs / Redirect are
// deliberately not wrapped: they need ArgList, Action, Job or Command handles.

LLVM_CLANG_C_EXTERN_C_END

#endif
