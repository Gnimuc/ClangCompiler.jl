"""
    CXString

A character string.

The [`CXString`](@ref) type is used to return strings from the interface when the ownership of that string might differ from one call to the next. Use [`clang_getCString`](@ref)() to retrieve the string data and, once finished with the string data, call [`clang_disposeString`](@ref)() to free the string.
"""
struct CXString
    data::Ptr{Cvoid}
    private_flags::Cuint
end

struct CXStringSet
    Strings::Ptr{CXString}
    Count::Cuint
end

"""
    clang_getCString(string)

Retrieve the character data associated with the given string.
"""
function clang_getCString(string)
    @ccall libclang.clang_getCString(string::CXString)::Cstring
end

"""
    clang_disposeString(string)

Free the given string.
"""
function clang_disposeString(string)
    @ccall libclang.clang_disposeString(string::CXString)::Cvoid
end

"""
    clang_disposeStringSet(set)

Free the given string set.
"""
function clang_disposeStringSet(set)
    @ccall libclang.clang_disposeStringSet(set::Ptr{CXStringSet})::Cvoid
end

"""
    clang_toggleCrashRecovery(isEnabled)

Enable/disable crash recovery.

# Arguments
* `isEnabled`: Flag to indicate if crash recovery is enabled. A non-zero value enables crash recovery, while 0 disables it.
"""
function clang_toggleCrashRecovery(isEnabled)
    @ccall libclang.clang_toggleCrashRecovery(isEnabled::Cuint)::Cvoid
end
