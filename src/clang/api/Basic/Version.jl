# Version — what the libclang-cpp actually loaded says about itself.
#
# `lib/<major>/LibClangEx.jl` is generated against one clang release; the library loaded at
# run time is whichever the artifact provides. These are how a caller observes that.

"""
    getClangFullVersion() -> String
Return the complete clang version banner: the version number, the repository version and
the vendor tag.
"""
getClangFullVersion() = get_string(clang_getClangFullVersion())

"""
    getClangToolFullVersion(tool_name::AbstractString) -> String
Return [`getClangFullVersion`](@ref) with `tool_name` in place of `"clang"`.
"""
function getClangToolFullVersion(tool_name::AbstractString)
    return get_string(clang_getClangToolFullVersion(tool_name))
end

"""
    getClangRepositoryPath() -> String
Return the repository path clang was built from, or the empty string when the build
recorded none.
"""
getClangRepositoryPath() = get_string(clang_getClangRepositoryPath())

"""
    getClangRevision() -> String
Return the revision clang was built from, or the empty string when the build recorded none.
"""
getClangRevision() = get_string(clang_getClangRevision())

"""
    getLLVMRevision() -> String
Return the revision LLVM was built from. The same string as [`getClangRevision`](@ref) when
both live in one repository, which is the usual arrangement.
"""
getLLVMRevision() = get_string(clang_getLLVMRevision())

"""
    getClangVendor() -> String
Return the vendor tag, or the empty string for an unbranded build.
"""
getClangVendor() = get_string(clang_getClangVendor())

"""
    getClangFullCPPVersion() -> String
Return the string clang expands `__VERSION__` to.
"""
getClangFullCPPVersion() = get_string(clang_getClangFullCPPVersion())
