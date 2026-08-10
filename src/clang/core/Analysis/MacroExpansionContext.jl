# Local abstract type: `clang::MacroExpansionContext` is a standalone class in
# clang/Analysis/MacroExpansionContext.h with no base, so it is not part of
# core/abstract.jl.
abstract type AbstractMacroExpansionContext end

"""
    struct MacroExpansionContext <: AbstractMacroExpansionContext
Hold a pointer to a `clang::MacroExpansionContext` object.

Records what every macro expansion in one translation unit turned into, so that a
`SourceLocation` can later be mapped back to the substituted text. It learns nothing from
a finished AST: it works by installing callbacks on a `Preprocessor`, so
`registerForPreprocessor` has to run **before** the code of interest is preprocessed.

The pointee is caller-owned (`MacroExpansionContext(::LangOptions)` heap-allocates it) —
call `dispose` after use. It must outlive the `Preprocessor` it was registered on, and the
`LangOptions` it was built from must outlive it.
"""
struct MacroExpansionContext <: AbstractMacroExpansionContext
    ptr::CXMacroExpansionContext
end
