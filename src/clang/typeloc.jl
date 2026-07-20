# Higher-level helpers over the TypeLoc carriers.

# CXTypeLocClass value -> concrete TypeLoc carrier, for the classes whose
# payload accessors are wrapped. Several classes share one carrier because the
# payload lives on a clang intermediate class: the Function/Array leaves
# collapse onto FunctionTypeLoc/ArrayTypeLoc, the type-specifier leaves onto
# TypeSpecTypeLoc, and Decayed onto AdjustedTypeLoc (where getOriginalLoc is
# declared).
const TYPE_LOC_CLASS_TO_TYPE = Dict{CXTypeLocClass,Any}()
for (cls, T) in [(CXTypeLocClass_Qualified, QualifiedTypeLoc),
                 (CXTypeLocClass_Builtin, BuiltinTypeLoc),
                 (CXTypeLocClass_Attributed, AttributedTypeLoc),
                 (CXTypeLocClass_Paren, ParenTypeLoc),
                 (CXTypeLocClass_Adjusted, AdjustedTypeLoc),
                 (CXTypeLocClass_Decayed, AdjustedTypeLoc),
                 (CXTypeLocClass_Pointer, PointerTypeLoc),
                 (CXTypeLocClass_MemberPointer, MemberPointerTypeLoc),
                 (CXTypeLocClass_LValueReference, LValueReferenceTypeLoc),
                 (CXTypeLocClass_RValueReference, RValueReferenceTypeLoc),
                 (CXTypeLocClass_FunctionProto, FunctionTypeLoc),
                 (CXTypeLocClass_FunctionNoProto, FunctionTypeLoc),
                 (CXTypeLocClass_ConstantArray, ArrayTypeLoc),
                 (CXTypeLocClass_IncompleteArray, ArrayTypeLoc),
                 (CXTypeLocClass_VariableArray, ArrayTypeLoc),
                 (CXTypeLocClass_DependentSizedArray, ArrayTypeLoc),
                 (CXTypeLocClass_TemplateSpecialization, TemplateSpecializationTypeLoc),
                 (CXTypeLocClass_Elaborated, ElaboratedTypeLoc),
                 # the TypeSpecTypeLoc subfamily: type-specifier classes whose
                 # location payload is a single name location
                 (CXTypeLocClass_Using, TypeSpecTypeLoc),
                 (CXTypeLocClass_Typedef, TypeSpecTypeLoc),
                 (CXTypeLocClass_InjectedClassName, TypeSpecTypeLoc),
                 (CXTypeLocClass_UnresolvedUsing, TypeSpecTypeLoc),
                 (CXTypeLocClass_Record, TypeSpecTypeLoc),
                 (CXTypeLocClass_Enum, TypeSpecTypeLoc),
                 (CXTypeLocClass_TemplateTypeParm, TypeSpecTypeLoc),
                 (CXTypeLocClass_SubstTemplateTypeParm, TypeSpecTypeLoc),
                 (CXTypeLocClass_SubstTemplateTypeParmPack, TypeSpecTypeLoc),
                 (CXTypeLocClass_Complex, TypeSpecTypeLoc)]
    TYPE_LOC_CLASS_TO_TYPE[cls] = T
end

"""
    resolve(x::TypeLoc)
Return `x` re-cast as the concrete TypeLoc carrier for the class reported by
[`getTypeLocClass`](@ref). A hit is a NEW owned heap box — `dispose` it in
addition to `x`; classes without a wrapped carrier return `x` itself (no new
box, dispose only once).
"""
function resolve(x::TypeLoc)
    T = get(TYPE_LOC_CLASS_TO_TYPE, getTypeLocClass(x), nothing)
    return T === nothing ? x : T(x)
end
