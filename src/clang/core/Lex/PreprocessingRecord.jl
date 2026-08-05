"""
    struct PreprocessingRecord <: AbstractPreprocessingRecord
Hold a pointer to a `clang::PreprocessingRecord` object.
"""
struct PreprocessingRecord <: AbstractPreprocessingRecord
    ptr::CXPreprocessingRecord
end

"""
    struct PreprocessedEntity <: AbstractPreprocessedEntity
Hold a pointer to a `clang::PreprocessedEntity` object.
"""
struct PreprocessedEntity <: AbstractPreprocessedEntity
    ptr::CXPreprocessedEntity
end

"""
    struct MacroDefinitionRecord <: AbstractMacroDefinitionRecord
Hold a pointer to a `clang::MacroDefinitionRecord` object.
"""
struct MacroDefinitionRecord <: AbstractMacroDefinitionRecord
    ptr::CXMacroDefinitionRecord
end

"""
    struct MacroExpansion <: AbstractMacroExpansion
Hold a pointer to a `clang::MacroExpansion` object.
"""
struct MacroExpansion <: AbstractMacroExpansion
    ptr::CXMacroExpansion
end

"""
    struct InclusionDirective <: AbstractInclusionDirective
Hold a pointer to a `clang::InclusionDirective` object.
"""
struct InclusionDirective <: AbstractInclusionDirective
    ptr::CXInclusionDirective
end

