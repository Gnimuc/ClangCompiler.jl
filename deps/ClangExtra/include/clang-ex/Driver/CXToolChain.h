#ifndef LLVM_CLANG_C_EXTRA_CXTOOLCHAIN_H
#define LLVM_CLANG_C_EXTRA_CXTOOLCHAIN_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Mirror of `clang::driver::ToolChain::CXXStdlibType` (clang/Driver/ToolChain.h): which
// C++ standard library the toolchain links against by default. Synced by static_assert in
// lib/Basic/CXEnumSync.cpp.
typedef enum CXCXXStdlibType {
  CXCXXStdlibType_CST_Libcxx,
  CXCXXStdlibType_CST_Libstdcxx
} CXCXXStdlibType;

// Mirror of `clang::driver::ToolChain::RuntimeLibType` (clang/Driver/ToolChain.h): which
// compiler runtime the toolchain links against by default. Synced by static_assert in
// lib/Basic/CXEnumSync.cpp.
typedef enum CXRuntimeLibType {
  CXRuntimeLibType_RLT_CompilerRT,
  CXRuntimeLibType_RLT_Libgcc
} CXRuntimeLibType;

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

// The default architecture name -arch expects for this toolchain. Copied for the same
// reason as getArchName.
CXString clang_ToolChain_getDefaultUniversalArchName(CXToolChain TC);

// --- where the toolchain would look for things -----------------------------------------
//
// None of these needs an ArgList, which is what makes them reachable from here at all, and
// together they are how a caller finds the compiler-rt builtins or the C++ standard library
// the toolchain would have linked -- the discovery step in front of adding an object or a
// dylib to a JIT.
//
// Each of the four path lists crosses as an owned CXStringSet (release with
// clang_disposeStringSet) rather than as a borrowed count+index pair: getArchSpecificLibPaths
// computes a fresh list per call and returns it by value, and copying the other three keeps
// the whole family answering the same way.

// <resource-dir>/lib/<os> or its per-triple spelling: where compiler-rt lives.
CXString clang_ToolChain_getCompilerRTPath(CXToolChain TC);

// The target-specific runtime directory, empty when the toolchain reports none (clang
// answers std::nullopt, which is what "no such directory" means here).
CXString clang_ToolChain_getRuntimePath(CXToolChain TC);

// The target-specific standard library directory, empty on the same std::nullopt.
CXString clang_ToolChain_getStdlibPath(CXToolChain TC);

// <resource-dir>/lib/<os>/<arch> and its siblings, the paths runtimes such as OpenMP search
// for architecture-specific libraries.
CXStringSet *clang_ToolChain_getArchSpecificLibPaths(CXToolChain TC);

// The -L paths, the file search paths and the program search paths the toolchain accumulated.
CXStringSet *clang_ToolChain_getLibraryPaths(CXToolChain TC);
CXStringSet *clang_ToolChain_getFilePaths(CXToolChain TC);
CXStringSet *clang_ToolChain_getProgramPaths(CXToolChain TC);

// The linker the toolchain would invoke, honouring -fuse-ld=. `LinkerIsLLD` may be NULL;
// when it is not, it reports whether that linker is LLD built at clang's own revision.
CXString clang_ToolChain_GetLinkerPath(CXToolChain TC, bool *LinkerIsLLD);

// The archiver the toolchain would invoke to build a static library.
CXString clang_ToolChain_GetStaticLibToolPath(CXToolChain TC);

// The sysroot the toolchain computes for itself, which is not always the driver's --sysroot.
CXString clang_ToolChain_computeSysRoot(CXToolChain TC);

// The <osname> component of the compiler-rt path ("darwin", "linux", ...). Copied: the
// StringRef is a slice of the triple's storage and is not NUL-terminated.
CXString clang_ToolChain_getOSLibName(CXToolChain TC);

// --- platform defaults ------------------------------------------------------------------

// Borrowed: a string literal the concrete toolchain returns ("ld" for the base class).
const char *clang_ToolChain_getDefaultLinker(CXToolChain TC);

// Both are pure virtuals on ToolChain, but every ToolChain a Driver hands out is a concrete
// subclass that overrides them, so there is always an implementation to call.
bool clang_ToolChain_isPICDefault(CXToolChain TC);
bool clang_ToolChain_isPICDefaultForced(CXToolChain TC);

CXCXXStdlibType clang_ToolChain_GetDefaultCXXStdlibType(CXToolChain TC);
CXRuntimeLibType clang_ToolChain_GetDefaultRuntimeLibType(CXToolChain TC);

// The driver type the toolchain assigns to a file extension, as a raw
// clang::driver::types::ID -- the currency clang-ex/Driver/CXDriverTypes.h reads. `Ext` is
// the extension without its dot. Total: an extension the toolchain knows nothing about
// answers TY_INVALID (0).
unsigned clang_ToolChain_LookupTypeForExtension(CXToolChain TC, const char *Ext);

// getTriple / getAuxTriple / getEffectiveTriple are deliberately not wrapped: they hand
// out llvm::Triple objects, and getEffectiveTriple additionally asserts that one has been
// computed. The string accessors above cover what a caller can use.

LLVM_CLANG_C_EXTERN_C_END

#endif
