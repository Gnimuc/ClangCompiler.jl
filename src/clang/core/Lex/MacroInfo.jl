"""
    struct MacroInfo <: AbstractMacroInfo
Hold a pointer to a `clang::MacroInfo` object.
"""
struct MacroInfo <: AbstractMacroInfo
    ptr::CXMacroInfo
end

"""
    struct MacroDirective <: AbstractMacroDirective
Hold a pointer to a `clang::MacroDirective` object.
"""
struct MacroDirective <: AbstractMacroDirective
    ptr::CXMacroDirective
end

abstract type AbstractDefMacroDirective <: AbstractMacroDirective end

"""
    struct DefMacroDirective <: AbstractDefMacroDirective
Hold a pointer to a `clang::DefMacroDirective` object.
"""
struct DefMacroDirective <: AbstractDefMacroDirective
    ptr::CXDefMacroDirective
end

abstract type AbstractDefInfo end

"""
    struct DefInfo <: AbstractDefInfo
Hold a pointer to an owned `clang::MacroDirective::DefInfo` value. The value is a by-value
triple — the `#define` directive the history resolved to, the location of the `#undef` that
cancelled it, and a module-visibility flag — with no pointer form, so libclangex heap-boxes
it and the box must be released with `dispose`. The invalid ("no definition found") form is
a box too, not a NULL carrier.
"""
struct DefInfo <: AbstractDefInfo
    ptr::CXDefInfo
end

abstract type AbstractModuleMacro end

"""
    struct ModuleMacro <: AbstractModuleMacro
Hold a pointer to a `clang::ModuleMacro` object.
"""
struct ModuleMacro <: AbstractModuleMacro
    ptr::CXModuleMacro
end
