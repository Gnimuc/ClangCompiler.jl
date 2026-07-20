"""
    abstract type AbstractCodeGenAction <: AbstractFrontendAction
Supertype for `CodeGenAction`s.
"""
abstract type AbstractCodeGenAction <: AbstractFrontendAction end

Base.unsafe_convert(::Type{CXCodeGenAction}, x::T) where {T<:AbstractCodeGenAction} = x.ptr
Base.cconvert(::Type{CXCodeGenAction}, x::T) where {T<:AbstractCodeGenAction} = x

struct LLVMOnlyAction <: AbstractCodeGenAction
    ptr::CXCodeGenAction
end

for sym in [:EmitAssemblyAction, :EmitBCAction, :EmitLLVMAction, :EmitCodeGenOnlyAction,
            :EmitObjAction]
    @eval begin
        """
            struct $($(QuoteNode(sym))) <: AbstractCodeGenAction
        Hold a pointer to a `clang::$($(QuoteNode(sym)))` object.
        """
        struct $sym <: AbstractCodeGenAction
            ptr::CXCodeGenAction
        end
    end
end
