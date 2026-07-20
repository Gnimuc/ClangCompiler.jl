# The clang::TypeLoc hierarchy as abstract types, front-loaded via abstract.jl
# before the TypeLoc carriers (TypeLoc.jl). `AbstractTypeLoc` is the family root;
# each wrapped subclass gets its own abstract so its wrapper receivers can be
# typed at the declaring class. `TypeLoc` (the base carrier) and the `AnyTypeLoc`
# union stay with the carriers, since the union references the `TypeLoc` struct.
abstract type AbstractTypeLoc end
abstract type AbstractQualifiedTypeLoc <: AbstractTypeLoc end
abstract type AbstractTypeSpecTypeLoc <: AbstractTypeLoc end
abstract type AbstractBuiltinTypeLoc <: AbstractTypeLoc end
abstract type AbstractAttributedTypeLoc <: AbstractTypeLoc end
abstract type AbstractParenTypeLoc <: AbstractTypeLoc end
abstract type AbstractAdjustedTypeLoc <: AbstractTypeLoc end
abstract type AbstractPointerTypeLoc <: AbstractTypeLoc end
abstract type AbstractMemberPointerTypeLoc <: AbstractTypeLoc end
abstract type AbstractLValueReferenceTypeLoc <: AbstractTypeLoc end
abstract type AbstractRValueReferenceTypeLoc <: AbstractTypeLoc end
abstract type AbstractFunctionTypeLoc <: AbstractTypeLoc end
abstract type AbstractArrayTypeLoc <: AbstractTypeLoc end
abstract type AbstractTemplateSpecializationTypeLoc <: AbstractTypeLoc end
abstract type AbstractElaboratedTypeLoc <: AbstractTypeLoc end
