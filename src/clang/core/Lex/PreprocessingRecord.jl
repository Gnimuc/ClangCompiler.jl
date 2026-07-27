"""
    struct PreprocessingRecord <: AbstractPreprocessingRecord
Hold a pointer to a `clang::PreprocessingRecord` object.
"""
struct PreprocessingRecord <: AbstractPreprocessingRecord
    ptr::CXPreprocessingRecord
end

Base.unsafe_convert(::Type{CXPreprocessingRecord}, x::PreprocessingRecord) = x.ptr
Base.cconvert(::Type{CXPreprocessingRecord}, x::PreprocessingRecord) = x


"""
    struct PreprocessedEntity <: AbstractPreprocessedEntity
Hold a pointer to a `clang::PreprocessedEntity` object.
"""
struct PreprocessedEntity <: AbstractPreprocessedEntity
    ptr::CXPreprocessedEntity
end

Base.unsafe_convert(::Type{CXPreprocessedEntity}, x::PreprocessedEntity) = x.ptr
Base.cconvert(::Type{CXPreprocessedEntity}, x::PreprocessedEntity) = x

"""
    struct MacroDefinitionRecord <: AbstractMacroDefinitionRecord
Hold a pointer to a `clang::MacroDefinitionRecord` object.
"""
struct MacroDefinitionRecord <: AbstractMacroDefinitionRecord
    ptr::CXMacroDefinitionRecord
end

Base.unsafe_convert(::Type{CXMacroDefinitionRecord}, x::MacroDefinitionRecord) = x.ptr
Base.cconvert(::Type{CXMacroDefinitionRecord}, x::MacroDefinitionRecord) = x

"""
    struct MacroExpansion <: AbstractMacroExpansion
Hold a pointer to a `clang::MacroExpansion` object.
"""
struct MacroExpansion <: AbstractMacroExpansion
    ptr::CXMacroExpansion
end

Base.unsafe_convert(::Type{CXMacroExpansion}, x::MacroExpansion) = x.ptr
Base.cconvert(::Type{CXMacroExpansion}, x::MacroExpansion) = x

"""
    struct InclusionDirective <: AbstractInclusionDirective
Hold a pointer to a `clang::InclusionDirective` object.
"""
struct InclusionDirective <: AbstractInclusionDirective
    ptr::CXInclusionDirective
end

Base.unsafe_convert(::Type{CXInclusionDirective}, x::InclusionDirective) = x.ptr
Base.cconvert(::Type{CXInclusionDirective}, x::InclusionDirective) = x
