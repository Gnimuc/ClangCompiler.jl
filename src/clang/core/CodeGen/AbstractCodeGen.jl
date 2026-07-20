# Abstract types for the CodeGen subsystem, front-loaded via abstract.jl. Note
# this subtypes `AbstractFrontendAction` from the backbone, so abstract.jl
# includes this file after the backbone.

"""
    abstract type AbstractCodeGenAction <: AbstractFrontendAction
Supertype for `CodeGenAction`s.
"""
abstract type AbstractCodeGenAction <: AbstractFrontendAction end
