#ifndef LLVM_CLANG_C_EXTRA_CXOBJECTFILEPCHCONTAINEROPERATIONS_H
#define LLVM_CLANG_C_EXTRA_CXOBJECTFILEPCHCONTAINEROPERATIONS_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang/CodeGen/ObjectFilePCHContainerOperations.h declares only two classes -- the writer
// and reader that wrap a serialized AST in a COFF/ELF/Mach-O container, which is the format
// `-gmodules` (and Xcode) produce. Both are abstract-interface implementations with private
// virtual overrides, so the only thing a C surface can do with them is instantiate one and
// hand it to the registry that will call those overrides. That registry
// (clang::PCHContainerOperations, clang/Serialization/PCHContainerOperations.h) is wrapped
// here alongside them for the same reason: it is what the writer and reader are for.

// A registry pre-populated with the raw pass-through writer and reader. Caller-owned:
// release it with clang_PCHContainerOperations_dispose.
CXPCHContainerOperations clang_PCHContainerOperations_create(void);

void clang_PCHContainerOperations_dispose(CXPCHContainerOperations Ops);

// helper: build an ObjectFilePCHContainerWriter (resp. Reader) and register it under the
// "obj" format. Registration is where the object goes -- registerWriter/registerReader
// consume a unique_ptr -- so creating one without registering it would hand back a handle
// with no owner and nothing able to use it.
void clang_PCHContainerOperations_registerObjectFilePCHContainerWriter(
    CXPCHContainerOperations Ops);

void clang_PCHContainerOperations_registerObjectFilePCHContainerReader(
    CXPCHContainerOperations Ops);

// The writer/reader registered for Format, or NULL when none is. Both are BORROWED from the
// registry and must not outlive it.
CXPCHContainerWriter clang_PCHContainerOperations_getWriterOrNull(CXPCHContainerOperations Ops,
                                                                  const char *Format);

CXPCHContainerReader clang_PCHContainerOperations_getReaderOrNull(CXPCHContainerOperations Ops,
                                                                  const char *Format);

// The "raw" reader every registry is created with. Borrowed, as above.
CXPCHContainerReader clang_PCHContainerOperations_getRawReader(CXPCHContainerOperations Ops);

// The `-fmodule-format=` spelling this writer produces. The CXString is caller-owned.
CXString clang_PCHContainerWriter_getFormat(CXPCHContainerWriter W);

// CreatePCHContainerGenerator -- needs a raw_pwrite_stream and a shared PCHBuffer, neither
// of which has a C form; the registry hands the generator to the PCH writer itself.

// The `-fmodule-format=` spellings this reader accepts, as a count-then-index pair.
// PRECONDITION on the second: I < clang_PCHContainerReader_getNumFormats(R). The CXString is
// caller-owned.
unsigned clang_PCHContainerReader_getNumFormats(CXPCHContainerReader R);

CXString clang_PCHContainerReader_getFormat(CXPCHContainerReader R, unsigned I);

// ExtractPCH -- takes an llvm::MemoryBufferRef and returns a StringRef into it, i.e. a
// borrowed slice of a buffer the caller owns; the ASTReader is what consumes it.

LLVM_CLANG_C_EXTERN_C_END

#endif
