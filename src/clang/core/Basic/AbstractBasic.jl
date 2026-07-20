# Abstract types for the Basic subsystem, front-loaded via abstract.jl.

"""
    abstract type AbstractDiagnosticConsumer <: Any
Supertype for `clang::DiagnosticConsumer`s.
"""
abstract type AbstractDiagnosticConsumer end
