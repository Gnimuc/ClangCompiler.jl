#ifndef LLVM_CLANG_C_EXTRA_CXDEPENDENCYSCANNINGTOOL_H
#define LLVM_CLANG_C_EXTRA_CXDEPENDENCYSCANNINGTOOL_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// TranslationUnitDeps
// P1689Rule
// The module-graph result structs are not mirrored: the calls that produce them all take
// an llvm::function_ref that C cannot supply.

// DependencyScanningTool

/// One worker over Service. Caller-owned: pair with clang_DependencyScanningTool_dispose,
/// and dispose it BEFORE the service, whose shared cache it holds a reference to. The
/// physical file system is used, which is clang's own default argument.
CXDependencyScanningTool
clang_DependencyScanningTool_create(CXDependencyScanningService Service);

void clang_DependencyScanningTool_dispose(CXDependencyScanningTool T);

/// Scans the translation unit named by a full clang driver command line -- CommandLine[0]
/// is the driver name, as in a compilation database entry -- and returns its header
/// dependencies in the format the service was configured for (Make by default, i.e. what
/// -MD writes). CWD is the directory the command line's relative paths resolve against.
///
/// clang returns llvm::Expected<std::string>; the shim flattens it: on success the CXString
/// is the dependency file and *OutSuccess is true, on failure it is the diagnostic output
/// clang produced and *OutSuccess is false. Caller-owned either way. OutSuccess may be
/// NULL.
CXString clang_DependencyScanningTool_getDependencyFile(CXDependencyScanningTool T,
                                                        const char **CommandLine,
                                                        unsigned NumArgs, const char *CWD,
                                                        bool *OutSuccess);

// getP1689ModuleDependencyFile
// getTranslationUnitDependencies
// getModuleDependencies

// FullDependencyConsumer
// CallbackActionController

LLVM_CLANG_C_EXTERN_C_END

#endif
