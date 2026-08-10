#ifndef LLVM_CLANG_C_EXTRA_CXDEPENDENCYSCANNINGSERVICE_H
#define LLVM_CLANG_C_EXTRA_CXDEPENDENCYSCANNINGSERVICE_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Mirror of `clang::tooling::dependencies::ScanningMode`
// (clang/Tooling/DependencyScanning/DependencyScanningService.h).
typedef enum CXScanningMode {
  CXScanningMode_CanonicalPreprocessing,
  CXScanningMode_DependencyDirectivesScan
} CXScanningMode;

// Mirror of `clang::tooling::dependencies::ScanningOutputFormat`.
typedef enum CXScanningOutputFormat {
  CXScanningOutputFormat_Make,
  CXScanningOutputFormat_Full,
  CXScanningOutputFormat_P1689
} CXScanningOutputFormat;

// Mirror of `clang::tooling::dependencies::ScanningOptimizations`, a bitmask enum. clang's
// `Default` is an alias of `All` and `LLVM_BITMASK_LARGEST_ENUMERATOR` an alias of
// `SystemWarnings`; neither is mirrored, because a duplicate value is what Julia's `@enum`
// refuses.
typedef enum CXScanningOptimizations {
  CXScanningOptimizations_None = 0,
  CXScanningOptimizations_HeaderSearch = 1,
  CXScanningOptimizations_SystemWarnings = 2,
  CXScanningOptimizations_All = 3
} CXScanningOptimizations;

// DependencyScanningService
//
// The configuration and the shared filesystem cache that the workers run against. One
// service is meant to be shared by every scan in a build; a DependencyScanningTool holds a
// reference to it, so the service must outlive every tool built from it.

/// Caller-owned: pair with clang_DependencyScanningService_dispose. OptimizeArgs and
/// EagerLoadModules are clang's defaulted parameters -- pass
/// CXScanningOptimizations_All and false for clang's own defaults.
CXDependencyScanningService
clang_DependencyScanningService_create(CXScanningMode Mode, CXScanningOutputFormat Format,
                                       CXScanningOptimizations OptimizeArgs,
                                       bool EagerLoadModules);

void clang_DependencyScanningService_dispose(CXDependencyScanningService S);

CXScanningMode clang_DependencyScanningService_getMode(CXDependencyScanningService S);

CXScanningOutputFormat
clang_DependencyScanningService_getFormat(CXDependencyScanningService S);

CXScanningOptimizations
clang_DependencyScanningService_getOptimizeArgs(CXDependencyScanningService S);

bool clang_DependencyScanningService_shouldEagerLoadModules(CXDependencyScanningService S);

// getSharedCache -- the cache is an implementation detail of the service and has no
// accessor worth crossing here.

LLVM_CLANG_C_EXTERN_C_END

#endif
