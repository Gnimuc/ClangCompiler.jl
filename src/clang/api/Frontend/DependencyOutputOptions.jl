# DependencyOutputOptions
"""
    DependencyOutputOptions() -> DependencyOutputOptions
Build a standalone options object, for driving [`DependencyFileGenerator`](@ref) without an
invocation to borrow one from.

This function allocates and one should call `dispose` to release the resources after using
this object. The one an invocation hands back
([`getDependencyOutputOpts`](@ref)) is borrowed instead and must not be disposed, but every
accessor below accepts either.
"""
function DependencyOutputOptions()
    opts = clang_DependencyOutputOptions_create()
    @assert opts != C_NULL "Failed to create DependencyOutputOptions"
    return DependencyOutputOptions(opts)
end

dispose(x::DependencyOutputOptions) = clang_DependencyOutputOptions_dispose(x)

"""
    getIncludeSystemHeaders(x::AbstractDependencyOutputOptions) -> Bool
Whether system headers are listed among the dependencies.
"""
function getIncludeSystemHeaders(x::AbstractDependencyOutputOptions)
    @check_ptrs x
    return clang_DependencyOutputOptions_getIncludeSystemHeaders(x)
end

"""
    setIncludeSystemHeaders(x::AbstractDependencyOutputOptions, value::Bool)
List system headers among the dependencies too. This is also what a generator built from
these options reports through [`needSystemDependencies`](@ref).
"""
function setIncludeSystemHeaders(x::AbstractDependencyOutputOptions, value::Bool)
    @check_ptrs x
    return clang_DependencyOutputOptions_setIncludeSystemHeaders(x, value)
end

"""
    getUsePhonyTargets(x::AbstractDependencyOutputOptions) -> Bool
Whether a phony target is emitted for each dependency.
"""
function getUsePhonyTargets(x::AbstractDependencyOutputOptions)
    @check_ptrs x
    return clang_DependencyOutputOptions_getUsePhonyTargets(x)
end

"""
    setUsePhonyTargets(x::AbstractDependencyOutputOptions, value::Bool)
Emit a phony target for each dependency, which keeps `make` from failing when a header is
deleted.
"""
function setUsePhonyTargets(x::AbstractDependencyOutputOptions, value::Bool)
    @check_ptrs x
    return clang_DependencyOutputOptions_setUsePhonyTargets(x, value)
end

"""
    getAddMissingHeaderDeps(x::AbstractDependencyOutputOptions) -> Bool
Whether headers that were looked for and not found are listed too.
"""
function getAddMissingHeaderDeps(x::AbstractDependencyOutputOptions)
    @check_ptrs x
    return clang_DependencyOutputOptions_getAddMissingHeaderDeps(x)
end

"""
    setAddMissingHeaderDeps(x::AbstractDependencyOutputOptions, value::Bool)
List headers that were looked for and not found among the dependencies.
"""
function setAddMissingHeaderDeps(x::AbstractDependencyOutputOptions, value::Bool)
    @check_ptrs x
    return clang_DependencyOutputOptions_setAddMissingHeaderDeps(x, value)
end

"""
    getIncludeModuleFiles(x::AbstractDependencyOutputOptions) -> Bool
Whether imported module files are listed among the dependencies.
"""
function getIncludeModuleFiles(x::AbstractDependencyOutputOptions)
    @check_ptrs x
    return clang_DependencyOutputOptions_getIncludeModuleFiles(x)
end

"""
    setIncludeModuleFiles(x::AbstractDependencyOutputOptions, value::Bool)
List imported module files among the dependencies.
"""
function setIncludeModuleFiles(x::AbstractDependencyOutputOptions, value::Bool)
    @check_ptrs x
    return clang_DependencyOutputOptions_setIncludeModuleFiles(x, value)
end

"""
    getOutputFormat(x::AbstractDependencyOutputOptions) -> CXDependencyOutputFormat
Whether the dependency file is written in `make` or `nmake` syntax.
"""
function getOutputFormat(x::AbstractDependencyOutputOptions)
    @check_ptrs x
    return clang_DependencyOutputOptions_getOutputFormat(x)
end

"""
    setOutputFormat(x::AbstractDependencyOutputOptions, format::CXDependencyOutputFormat)
Choose `make` or `nmake` syntax for the dependency file.
"""
function setOutputFormat(x::AbstractDependencyOutputOptions,
                         format::CXDependencyOutputFormat)
    @check_ptrs x
    return clang_DependencyOutputOptions_setOutputFormat(x, format)
end

"""
    getOutputFile(x::AbstractDependencyOutputOptions) -> String
Where the generated `.d` file goes; empty when nothing was set.
"""
function getOutputFile(x::AbstractDependencyOutputOptions)
    @check_ptrs x
    return get_string(clang_DependencyOutputOptions_getOutputFile(x))
end

"""
    setOutputFile(x::AbstractDependencyOutputOptions, path::AbstractString)
Set where the generated `.d` file goes. With an empty path
[`finishedMainFile`](@ref) writes nothing.
"""
function setOutputFile(x::AbstractDependencyOutputOptions, path::AbstractString)
    @check_ptrs x
    return clang_DependencyOutputOptions_setOutputFile(x, path)
end

"""
    getTargetsNum(x::AbstractDependencyOutputOptions) -> UInt32
How many make targets the dependency list will be attached to.
"""
function getTargetsNum(x::AbstractDependencyOutputOptions)
    @check_ptrs x
    return clang_DependencyOutputOptions_getTargetsNum(x)
end

"""
    getTarget(x::AbstractDependencyOutputOptions, i::Integer) -> String
The `i`-th make target (0-origin).
"""
function getTarget(x::AbstractDependencyOutputOptions, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getTargetsNum(x) "target index $i out of range"
    return get_string(clang_DependencyOutputOptions_getTarget(x, i))
end

"""
    addTarget(x::AbstractDependencyOutputOptions, target::AbstractString)
Append a make target. `Targets` is a plain vector with no member function to grow it, and a
dependency file wants at least one entry.
"""
function addTarget(x::AbstractDependencyOutputOptions, target::AbstractString)
    @check_ptrs x
    return clang_DependencyOutputOptions_addTarget(x, target)
end
