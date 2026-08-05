#ifndef LLVM_CLANG_C_EXTRA_CXTOOLCHAIN_H
#define LLVM_CLANG_C_EXTRA_CXTOOLCHAIN_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// A ToolChain is created and cached by its Driver and lives as long as that Driver; every
// handle here is borrowed and there is no dispose. Reach one through
// clang_Compilation_getDefaultToolChain.

// Borrowed: the Driver that owns this toolchain.
CXDriver clang_ToolChain_getDriver(CXToolChain TC);

CXString clang_ToolChain_getTripleString(CXToolChain TC);

// The architecture component of the target triple. Copied rather than borrowed: the
// StringRef is a slice of the triple's own storage and is not NUL-terminated.
CXString clang_ToolChain_getArchName(CXToolChain TC);

// The OS *name* component of the target triple ("linux", "darwin", ...), empty for a
// triple that names no OS. Same copy rule as getArchName.
CXString clang_ToolChain_getOS(CXToolChain TC);

// Whether the toolchain targets something other than the host this library was built for.
bool clang_ToolChain_isCrossCompiling(CXToolChain TC);

// getTriple / getAuxTriple / getEffectiveTriple are deliberately not wrapped: they hand
// out llvm::Triple objects, and getEffectiveTriple additionally asserts that one has been
// computed. The string accessors above cover what a caller can use.

LLVM_CLANG_C_EXTERN_C_END

#endif
