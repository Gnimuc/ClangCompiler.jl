#ifndef LLVM_CLANG_C_EXTRA_CXMODULELOADER_H
#define LLVM_CLANG_C_EXTRA_CXMODULELOADER_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// ModuleLoader

// buildingModule
// setBuildingModule
// loadModule
// createModuleFromSource
// makeModuleVisible
// loadGlobalModuleIndex
// lookupMissingImports
// HadFatalFailure

// TrivialModuleLoader

// The module loader that loads nothing: every override is a no-op, so importing a module
// through it simply fails. `Preprocessor`'s constructor takes a `ModuleLoader &`, and this
// is what satisfies it when a preprocessor is stood up without the CompilerInstance that
// would otherwise supply one. Release with `clang_TrivialModuleLoader_dispose`; it must
// outlive every preprocessor built on it.
CXModuleLoader clang_TrivialModuleLoader_create(void);

void clang_TrivialModuleLoader_dispose(CXModuleLoader ML);

LLVM_CLANG_C_EXTERN_C_END

#endif
