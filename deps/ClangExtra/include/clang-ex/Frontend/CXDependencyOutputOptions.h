#ifndef LLVM_CLANG_C_EXTRA_CXDEPENDENCYOUTPUTOPTIONS_H
#define LLVM_CLANG_C_EXTRA_CXDEPENDENCYOUTPUTOPTIONS_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "clang-c/CXString.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang/Frontend/DependencyOutputOptions.h: enum class clang::DependencyOutputFormat
typedef enum CXDependencyOutputFormat {
  CXDependencyOutputFormat_Make,
  CXDependencyOutputFormat_NMake
} CXDependencyOutputFormat;

// A standalone options object, for driving clang_DependencyFileGenerator_create without an
// invocation to borrow one from. Caller-owned; release it with
// clang_DependencyOutputOptions_dispose. The one an invocation hands back
// (clang_CompilerInvocation_getDependencyOutputOpts) is borrowed and must not be disposed,
// but every accessor below accepts either.
CXDependencyOutputOptions clang_DependencyOutputOptions_create(void);

void clang_DependencyOutputOptions_dispose(CXDependencyOutputOptions DOO);

// Flags
bool clang_DependencyOutputOptions_getIncludeSystemHeaders(CXDependencyOutputOptions DOO);
void clang_DependencyOutputOptions_setIncludeSystemHeaders(CXDependencyOutputOptions DOO,
                                                           bool Value);

bool clang_DependencyOutputOptions_getUsePhonyTargets(CXDependencyOutputOptions DOO);
void clang_DependencyOutputOptions_setUsePhonyTargets(CXDependencyOutputOptions DOO,
                                                      bool Value);

bool clang_DependencyOutputOptions_getAddMissingHeaderDeps(CXDependencyOutputOptions DOO);
void clang_DependencyOutputOptions_setAddMissingHeaderDeps(CXDependencyOutputOptions DOO,
                                                           bool Value);

bool clang_DependencyOutputOptions_getIncludeModuleFiles(CXDependencyOutputOptions DOO);
void clang_DependencyOutputOptions_setIncludeModuleFiles(CXDependencyOutputOptions DOO,
                                                         bool Value);

// ShowHeaderIncludes
// ShowSkippedHeaderIncludes
// HeaderIncludeFormat
// HeaderIncludeFiltering
// ShowIncludesDest

CXDependencyOutputFormat
clang_DependencyOutputOptions_getOutputFormat(CXDependencyOutputOptions DOO);
void clang_DependencyOutputOptions_setOutputFormat(CXDependencyOutputOptions DOO,
                                                   CXDependencyOutputFormat Format);

// OutputFile
// Where the generated .d file goes. Caller frees the string with clang_disposeString.
CXString clang_DependencyOutputOptions_getOutputFile(CXDependencyOutputOptions DOO);
void clang_DependencyOutputOptions_setOutputFile(CXDependencyOutputOptions DOO,
                                                 const char *Path);

// HeaderIncludeOutputFile

// Targets
// The make targets the dependency list is attached to. A dependency file wants at least
// one; with none, the generated file has an empty left-hand side.
unsigned clang_DependencyOutputOptions_getTargetsNum(CXDependencyOutputOptions DOO);

// PRECONDITION: Idx < clang_DependencyOutputOptions_getTargetsNum. Caller frees the string
// with clang_disposeString.
CXString clang_DependencyOutputOptions_getTarget(CXDependencyOutputOptions DOO,
                                                 unsigned Idx);

// helper — `Targets` is a plain vector with no member function to grow it.
void clang_DependencyOutputOptions_addTarget(CXDependencyOutputOptions DOO,
                                             const char *Target);

// ExtraDeps
// DOTOutputFile
// ModuleDependencyOutputDir

LLVM_CLANG_C_EXTERN_C_END

#endif
