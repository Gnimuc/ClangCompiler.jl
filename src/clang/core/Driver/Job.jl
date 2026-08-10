abstract type AbstractJobList end

"""
    struct JobList <: AbstractJobList
Hold a pointer to a `clang::driver::JobList` object.

A job list is a member of the `Compilation` that built it, so it is borrowed and dies with
that compilation.
"""
struct JobList <: AbstractJobList
    ptr::CXJobList
end

abstract type AbstractCommand end

"""
    struct Command <: AbstractCommand
Hold a pointer to a `clang::driver::Command` object.

A command is owned by the [`JobList`](@ref) it came from, so it is borrowed and dies with
the compilation.
"""
struct Command <: AbstractCommand
    ptr::CXCommand
end

abstract type AbstractTool end

"""
    struct Tool <: AbstractTool
Hold a pointer to a `clang::driver::Tool` object.

A tool is created and cached by its toolchain, so it is borrowed and lives as long as the
driver does.
"""
struct Tool <: AbstractTool
    ptr::CXTool
end
