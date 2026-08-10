abstract type AbstractLangStandard end

"""
    struct LangStandard <: AbstractLangStandard
Hold a pointer to a `clang::LangStandard` object.

The pointee is an entry of clang's static `LangStandards` table — one per `-std=` spelling,
with static storage duration — so a `LangStandard` is borrowed and never disposed.
"""
struct LangStandard <: AbstractLangStandard
    ptr::CXLangStandard
end
