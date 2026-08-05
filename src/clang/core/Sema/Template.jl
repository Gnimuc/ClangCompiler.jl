"""
    abstract type AbstractMultiLevelTemplateArgumentList <: Any
Supertype for `clang::MultiLevelTemplateArgumentList` carriers.
"""
abstract type AbstractMultiLevelTemplateArgumentList end

"""
    struct MultiLevelTemplateArgumentList <: AbstractMultiLevelTemplateArgumentList
Hold a pointer to a `clang::MultiLevelTemplateArgumentList` object.

The handle is a box that owns the argument levels the value borrows: the C++ class stores
each level as an `ArrayRef<TemplateArgument>` and never copies its elements.
"""
struct MultiLevelTemplateArgumentList <: AbstractMultiLevelTemplateArgumentList
    ptr::CXMultiLevelTemplateArgumentList
end

"""
    abstract type AbstractLocalInstantiationScope <: Any
Supertype for `clang::LocalInstantiationScope` carriers.
"""
abstract type AbstractLocalInstantiationScope end

"""
    struct LocalInstantiationScope <: AbstractLocalInstantiationScope
Hold a pointer to a `clang::LocalInstantiationScope` object.

The scope is the map from a pattern's local declarations - parameters, local variables,
template parameters - onto the ones being created for an instantiation. Constructing it
makes it `Sema`'s current scope and disposing it restores the previous one.
"""
struct LocalInstantiationScope <: AbstractLocalInstantiationScope
    ptr::CXLocalInstantiationScope
end

