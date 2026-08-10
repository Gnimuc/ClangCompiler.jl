# MacroExpansionContext — what each macro expansion of one translation unit turned into
# (clang/Analysis/MacroExpansionContext.h), so a macro-expansion `SourceLocation` can be
# mapped back to the substituted text.
#
# ORDERING CONSTRAINT. The context learns nothing from a finished AST: it records by
# installing callbacks on a `Preprocessor`, so `registerForPreprocessor` MUST run BEFORE
# the code of interest is preprocessed. With the interpreter that means registering on
# `getPreprocessor(get_instance(I))` and only then calling `parse`; macros already lexed
# are invisible, and both getters simply report "nothing here" for those locations.
#
# LIFETIME. `registerForPreprocessor` hands the preprocessor pointers back into the
# context, so the context must OUTLIVE the `Preprocessor`; and it stores the `LangOptions`
# by reference, so those must outlive the context. It also installs itself as the
# preprocessor's single token watcher, so registering a second context on one preprocessor
# silently unhooks the first.

"""
    MacroExpansionContext(lang_opts::AbstractLangOptions) -> MacroExpansionContext
Return a macro-expansion recorder that has not been registered yet.

This function allocates and one should call `dispose` to release the resources after using
this object — after the `Preprocessor` it was registered on is gone.
"""
function MacroExpansionContext(lang_opts::AbstractLangOptions)
    @check_ptrs lang_opts
    return MacroExpansionContext(clang_MacroExpansionContext_create(lang_opts))
end

dispose(x::MacroExpansionContext) = clang_MacroExpansionContext_dispose(x)

"""
    registerForPreprocessor(x::AbstractMacroExpansionContext, pp::AbstractPreprocessor)
Install the recording callbacks on `pp`. Call this before `pp` lexes the tokens of
interest — see the ordering constraint at the top of this file.
"""
function registerForPreprocessor(x::AbstractMacroExpansionContext, pp::AbstractPreprocessor)
    @check_ptrs x pp
    return clang_MacroExpansionContext_registerForPreprocessor(x, pp)
end

"""
    getExpandedText(x::AbstractMacroExpansionContext,
                    loc::SourceLocation) -> Union{Nothing,String}
Return the text the macro expanded at `loc` was replaced by, after the whole expansion
chain, or `nothing` when no expansion was recorded there.

`nothing` and `""` are different answers: an expansion that produced no tokens is a
recorded expansion whose text is empty. `nothing` covers a location inside a macro body, a
location with no expansion, and every location preprocessed before
[`registerForPreprocessor`](@ref) ran.
"""
function getExpandedText(x::AbstractMacroExpansionContext, loc::SourceLocation)
    @check_ptrs x
    s = clang_MacroExpansionContext_getExpandedText(x, loc)
    clang_getCString(s) == C_NULL && return nothing
    return get_string(s)
end

"""
    getOriginalText(x::AbstractMacroExpansionContext,
                    loc::SourceLocation) -> Union{Nothing,String}
Return the original spelling the expansion at `loc` replaced, taken back out of the source
buffer, or `nothing` when no expansion was recorded there.
"""
function getOriginalText(x::AbstractMacroExpansionContext, loc::SourceLocation)
    @check_ptrs x
    s = clang_MacroExpansionContext_getOriginalText(x, loc)
    clang_getCString(s) == C_NULL && return nothing
    return get_string(s)
end

"""
    dumpExpansionRangesToString(x::AbstractMacroExpansionContext) -> String
Return one line per recorded expansion, giving the source range it substituted.

Every rendering opens with a header line, so the output of a context that recorded nothing
is not the empty string.
"""
function dumpExpansionRangesToString(x::AbstractMacroExpansionContext)
    @check_ptrs x
    return get_string(clang_MacroExpansionContext_dumpExpansionRangesToString(x))
end

"""
    dumpExpandedTextsToString(x::AbstractMacroExpansionContext) -> String
Return one line per recorded expansion, giving the text it expanded to.
"""
function dumpExpandedTextsToString(x::AbstractMacroExpansionContext)
    @check_ptrs x
    return get_string(clang_MacroExpansionContext_dumpExpandedTextsToString(x))
end

# The same two renderings written straight to `stderr`.
function dumpExpansionRanges(x::AbstractMacroExpansionContext)
    @check_ptrs x
    return clang_MacroExpansionContext_dumpExpansionRanges(x)
end

function dumpExpandedTexts(x::AbstractMacroExpansionContext)
    @check_ptrs x
    return clang_MacroExpansionContext_dumpExpandedTexts(x)
end
