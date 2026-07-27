function PrintStats(x::LangOptions)
    @check_ptrs x
    return clang_LangOptions_PrintStats(x)
end


function isCompilingModule(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_isCompilingModule(x)
end

function isCompilingModuleInterface(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_isCompilingModuleInterface(x)
end

function isCompilingModuleImplementation(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_isCompilingModuleImplementation(x)
end

function isSignedOverflowDefined(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_isSignedOverflowDefined(x)
end

function isSubscriptPointerArithmetic(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_isSubscriptPointerArithmetic(x)
end

function isNoBuiltinFunc(x::AbstractLangOptions, name::AbstractString)
    @check_ptrs x
    return clang_LangOptions_isNoBuiltinFunc(x, name)
end

"""
    getBorland(x::AbstractLangOptions) -> Bool
Whether Borland extensions (`-fborland-extensions`) are enabled. This gates the
SEH identifier surface — see [`PoisonSEHIdentifiers`](@ref).
"""
function getBorland(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_getBorland(x)
end

function assumeFunctionsAreConvergent(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_assumeFunctionsAreConvergent(x)
end

function getOpenCLCompatibleVersion(x::AbstractLangOptions)
    @check_ptrs x
    return Int(clang_LangOptions_getOpenCLCompatibleVersion(x))
end

function getOpenCLVersionString(x::AbstractLangOptions)
    @check_ptrs x
    return get_string(clang_LangOptions_getOpenCLVersionString(x))
end

function requiresStrictPrototypes(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_requiresStrictPrototypes(x)
end

function implicitFunctionsAllowed(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_implicitFunctionsAllowed(x)
end

function hasAtExit(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_hasAtExit(x)
end

function isImplicitIntRequired(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_isImplicitIntRequired(x)
end

function isImplicitIntAllowed(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_isImplicitIntAllowed(x)
end

function hasSjLjExceptions(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_hasSjLjExceptions(x)
end

function hasSEHExceptions(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_hasSEHExceptions(x)
end

function hasDWARFExceptions(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_hasDWARFExceptions(x)
end

function hasWasmExceptions(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_hasWasmExceptions(x)
end

function isSYCL(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_isSYCL(x)
end
