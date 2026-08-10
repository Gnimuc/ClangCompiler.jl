#include "clang-ex/Tooling/DependencyScanning/CXDependencyScanningService.h"

#include "clang/Tooling/DependencyScanning/DependencyScanningService.h"

#include <memory>

CXDependencyScanningService
clang_DependencyScanningService_create(CXScanningMode Mode, CXScanningOutputFormat Format,
                                       CXScanningOptimizations OptimizeArgs,
                                       bool EagerLoadModules) {
  return reinterpret_cast<CXDependencyScanningService>(
      std::make_unique<clang::tooling::dependencies::DependencyScanningService>(
          static_cast<clang::tooling::dependencies::ScanningMode>(Mode),
          static_cast<clang::tooling::dependencies::ScanningOutputFormat>(Format),
          static_cast<clang::tooling::dependencies::ScanningOptimizations>(OptimizeArgs),
          EagerLoadModules)
          .release());
}

void clang_DependencyScanningService_dispose(CXDependencyScanningService S) {
  delete reinterpret_cast<clang::tooling::dependencies::DependencyScanningService *>(S);
}

CXScanningMode clang_DependencyScanningService_getMode(CXDependencyScanningService S) {
  return static_cast<CXScanningMode>(
      reinterpret_cast<clang::tooling::dependencies::DependencyScanningService *>(S)
          ->getMode());
}

CXScanningOutputFormat
clang_DependencyScanningService_getFormat(CXDependencyScanningService S) {
  return static_cast<CXScanningOutputFormat>(
      reinterpret_cast<clang::tooling::dependencies::DependencyScanningService *>(S)
          ->getFormat());
}

CXScanningOptimizations
clang_DependencyScanningService_getOptimizeArgs(CXDependencyScanningService S) {
  return static_cast<CXScanningOptimizations>(
      reinterpret_cast<clang::tooling::dependencies::DependencyScanningService *>(S)
          ->getOptimizeArgs());
}

bool clang_DependencyScanningService_shouldEagerLoadModules(CXDependencyScanningService S) {
  return reinterpret_cast<clang::tooling::dependencies::DependencyScanningService *>(S)
      ->shouldEagerLoadModules();
}
