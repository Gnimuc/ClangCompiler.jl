# LangStandard — the static table describing every `-std=` clang accepts.

"""
    getLangKind(name::AbstractString) -> CXLangStandardKind
Return the standard `-std=name` selects, or `CXLangStandardKind_lang_unspecified` when
clang knows no standard by that name. Aliases resolve here too: `"c90"` answers
`lang_c89`, `"c++2b"` answers `lang_cxx23`.
"""
function getLangKind(name::AbstractString)
    return clang_LangStandard_getLangKind(name)
end

"""
    getLangStandardForKind(kind::CXLangStandardKind) -> LangStandard
Return the table entry for `kind`.

`kind` must not be `CXLangStandardKind_lang_unspecified`: clang answers that one with
`report_fatal_error`, which aborts the process rather than returning.
"""
function getLangStandardForKind(kind::CXLangStandardKind)
    @assert kind != CXLangStandardKind_lang_unspecified "there is no LangStandard for the unspecified kind"
    return LangStandard(clang_LangStandard_getLangStandardForKind(kind))
end

"""
    getLangStandardForName(name::AbstractString) -> Union{LangStandard,Nothing}
Return the table entry `-std=name` selects, or `nothing` when clang knows no standard by
that name.
"""
function getLangStandardForName(name::AbstractString)
    ptr = clang_LangStandard_getLangStandardForName(name)
    return ptr == C_NULL ? nothing : LangStandard(ptr)
end

"""
    getName(x::AbstractLangStandard) -> String
Return the `-std=` spelling of this standard, e.g. `"c++17"`.
"""
function getName(x::AbstractLangStandard)
    @check_ptrs x
    return unsafe_string(clang_LangStandard_getName(x))
end

"""
    getDescription(x::AbstractLangStandard) -> String
Return the human-readable description of this standard, e.g. `"ISO C++ 2017 with amendments"`.
"""
function getDescription(x::AbstractLangStandard)
    @check_ptrs x
    return unsafe_string(clang_LangStandard_getDescription(x))
end

"""
    getLanguage(x::AbstractLangStandard) -> CXLanguage
Return the input language this standard describes.
"""
function getLanguage(x::AbstractLangStandard)
    @check_ptrs x
    return clang_LangStandard_getLanguage(x)
end

"""
    hasLineComments(x::AbstractLangStandard) -> Bool
Return whether the standard supports `//` comments.
"""
function hasLineComments(x::AbstractLangStandard)
    @check_ptrs x
    return clang_LangStandard_hasLineComments(x)
end

"""
    isC99(x::AbstractLangStandard) -> Bool
Return whether the standard is a superset of C99.
"""
function isC99(x::AbstractLangStandard)
    @check_ptrs x
    return clang_LangStandard_isC99(x)
end

"""
    isC11(x::AbstractLangStandard) -> Bool
Return whether the standard is a superset of C11.
"""
function isC11(x::AbstractLangStandard)
    @check_ptrs x
    return clang_LangStandard_isC11(x)
end

"""
    isC17(x::AbstractLangStandard) -> Bool
Return whether the standard is a superset of C17.
"""
function isC17(x::AbstractLangStandard)
    @check_ptrs x
    return clang_LangStandard_isC17(x)
end

"""
    isC23(x::AbstractLangStandard) -> Bool
Return whether the standard is a superset of C23.
"""
function isC23(x::AbstractLangStandard)
    @check_ptrs x
    return clang_LangStandard_isC23(x)
end

"""
    isCPlusPlus(x::AbstractLangStandard) -> Bool
Return whether the standard is a C++ variant.
"""
function isCPlusPlus(x::AbstractLangStandard)
    @check_ptrs x
    return clang_LangStandard_isCPlusPlus(x)
end

"""
    isCPlusPlus11(x::AbstractLangStandard) -> Bool
Return whether the standard is C++11 or later.
"""
function isCPlusPlus11(x::AbstractLangStandard)
    @check_ptrs x
    return clang_LangStandard_isCPlusPlus11(x)
end

"""
    isCPlusPlus14(x::AbstractLangStandard) -> Bool
Return whether the standard is C++14 or later.
"""
function isCPlusPlus14(x::AbstractLangStandard)
    @check_ptrs x
    return clang_LangStandard_isCPlusPlus14(x)
end

"""
    isCPlusPlus17(x::AbstractLangStandard) -> Bool
Return whether the standard is C++17 or later.
"""
function isCPlusPlus17(x::AbstractLangStandard)
    @check_ptrs x
    return clang_LangStandard_isCPlusPlus17(x)
end

"""
    isCPlusPlus20(x::AbstractLangStandard) -> Bool
Return whether the standard is C++20 or later.
"""
function isCPlusPlus20(x::AbstractLangStandard)
    @check_ptrs x
    return clang_LangStandard_isCPlusPlus20(x)
end

"""
    isCPlusPlus23(x::AbstractLangStandard) -> Bool
Return whether the standard is C++23 or later.
"""
function isCPlusPlus23(x::AbstractLangStandard)
    @check_ptrs x
    return clang_LangStandard_isCPlusPlus23(x)
end

"""
    isCPlusPlus26(x::AbstractLangStandard) -> Bool
Return whether the standard is C++26 or later.
"""
function isCPlusPlus26(x::AbstractLangStandard)
    @check_ptrs x
    return clang_LangStandard_isCPlusPlus26(x)
end

"""
    hasDigraphs(x::AbstractLangStandard) -> Bool
Return whether the standard supports digraphs.
"""
function hasDigraphs(x::AbstractLangStandard)
    @check_ptrs x
    return clang_LangStandard_hasDigraphs(x)
end

"""
    isGNUMode(x::AbstractLangStandard) -> Bool
Return whether the standard includes the GNU extensions.
"""
function isGNUMode(x::AbstractLangStandard)
    @check_ptrs x
    return clang_LangStandard_isGNUMode(x)
end

"""
    hasHexFloats(x::AbstractLangStandard) -> Bool
Return whether the standard supports hexadecimal floating-point constants.
"""
function hasHexFloats(x::AbstractLangStandard)
    @check_ptrs x
    return clang_LangStandard_hasHexFloats(x)
end

"""
    isOpenCL(x::AbstractLangStandard) -> Bool
Return whether the standard is an OpenCL variant.
"""
function isOpenCL(x::AbstractLangStandard)
    @check_ptrs x
    return clang_LangStandard_isOpenCL(x)
end

"""
    languageToString(lang::CXLanguage) -> String
Return clang's own name for an input language, e.g. `"c++"` for `CXLanguage_CXX`.
"""
languageToString(lang::CXLanguage) = get_string(clang_languageToString(lang))

"""
    getDefaultLanguageStandard(lang::CXLanguage, triple::AbstractString) -> CXLangStandardKind
Return the standard clang would pick for `lang` on `triple` when no `-std=` is given.

`lang` must be neither `CXLanguage_Unknown` nor `CXLanguage_LLVM_IR`: clang answers both
with `llvm_unreachable`, which aborts the process rather than returning.
"""
function getDefaultLanguageStandard(lang::CXLanguage, triple::AbstractString)
    @assert lang != CXLanguage_Unknown && lang != CXLanguage_LLVM_IR "no language standard is defined for $lang"
    return clang_getDefaultLanguageStandard(lang, triple)
end
