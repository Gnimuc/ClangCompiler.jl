# PartialTranslationUnit
function Base.getproperty(x::PartialTranslationUnit, name::Symbol)
    name === :TUPart && return clang_PartialTranslationUnit_get_TUPart(x)
    name === :TheModule && return clang_PartialTranslationUnit_get_TheModule(x)
    return getfield(x, name)
end
