"""
    abstract type AbstractCrossTranslationUnitContext <: Any
Supertype for `clang::cross_tu::CrossTranslationUnitContext`.
"""
abstract type AbstractCrossTranslationUnitContext end

"""
    struct CrossTranslationUnitContext <: AbstractCrossTranslationUnitContext
Hold a pointer to a `clang::cross_tu::CrossTranslationUnitContext` object.
"""
struct CrossTranslationUnitContext <: AbstractCrossTranslationUnitContext
    ptr::CXCrossTranslationUnitContext
end

"""
    abstract type AbstractCrossTUIndex <: Any
Supertype for the C shim's box around a cross-TU `llvm::StringMap<std::string>` index.
"""
abstract type AbstractCrossTUIndex end

"""
    struct CrossTUIndex <: AbstractCrossTUIndex
Hold a pointer to the shim-owned `llvm::StringMap<std::string>` that maps a USR to the
path of the AST file defining it — the content of a cross-TU index file.
"""
struct CrossTUIndex <: AbstractCrossTUIndex
    ptr::CXCrossTUIndex
end
