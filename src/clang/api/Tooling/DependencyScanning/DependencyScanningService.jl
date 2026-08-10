# DependencyScanningService

"""
    DependencyScanningService(mode::CXScanningMode, format::CXScanningOutputFormat,
                              optimize_args::CXScanningOptimizations=CXScanningOptimizations_All,
                              eager_load_modules::Bool=false)
Create the shared configuration and filesystem cache the scanning workers run against.

`CXScanningMode_DependencyDirectivesScan` is the fast path clang-scan-deps uses: it lexes
only the preprocessor directives needed to evaluate includes, instead of running the
preprocessor over everything. `CXScanningOutputFormat_Make` produces what `-MD` writes.

`optimize_args` and `eager_load_modules` are Clang's defaulted parameters, and the defaults
here are Clang's own.

One service is meant to be shared across a whole build, and every `DependencyScanningTool`
holds a reference to it: dispose the tools first.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function DependencyScanningService(mode::CXScanningMode, format::CXScanningOutputFormat,
                                   optimize_args::CXScanningOptimizations=CXScanningOptimizations_All,
                                   eager_load_modules::Bool=false)
    ptr = clang_DependencyScanningService_create(mode, format, optimize_args,
                                                 eager_load_modules)
    @assert ptr != C_NULL "Failed to create DependencyScanningService"
    return DependencyScanningService(ptr)
end

dispose(x::DependencyScanningService) = clang_DependencyScanningService_dispose(x)

"""
    getMode(x::AbstractDependencyScanningService) -> CXScanningMode
Return how the service discovers dependencies.
"""
function getMode(x::AbstractDependencyScanningService)
    @check_ptrs x
    return clang_DependencyScanningService_getMode(x)
end

"""
    getFormat(x::AbstractDependencyScanningService) -> CXScanningOutputFormat
Return the format the scan results are produced in.
"""
function getFormat(x::AbstractDependencyScanningService)
    @check_ptrs x
    return clang_DependencyScanningService_getFormat(x)
end

"""
    getOptimizeArgs(x::AbstractDependencyScanningService) -> CXScanningOptimizations
Return which command-line optimisations the service applies to module builds.
"""
function getOptimizeArgs(x::AbstractDependencyScanningService)
    @check_ptrs x
    return clang_DependencyScanningService_getOptimizeArgs(x)
end

"""
    shouldEagerLoadModules(x::AbstractDependencyScanningService) -> Bool
Return whether generated command lines load PCM files eagerly.
"""
function shouldEagerLoadModules(x::AbstractDependencyScanningService)
    @check_ptrs x
    return clang_DependencyScanningService_shouldEagerLoadModules(x)
end
