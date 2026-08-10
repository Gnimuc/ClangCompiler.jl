# ExprConcepts
#
# The two C++20 expression nodes whose classes the generated cast surface already names but
# which had no accessors: a concept-id (`Sortable<T>`) and a requires-expression. Between them
# they answer which concept was named, with which arguments, and whether it held.

# ConceptSpecializationExpr

"""
    getConceptReference(x::AbstractConceptSpecializationExpr) -> ConceptReference
The reference this expression was built from — the concept named, the qualifier it was named
through, and the arguments as written. Borrowed AST-arena memory.
"""
function getConceptReference(x::AbstractConceptSpecializationExpr)
    @check_ptrs x
    return ConceptReference(clang_ConceptSpecializationExpr_getConceptReference(x))
end

"""
    getNumTemplateArguments(x::AbstractConceptSpecializationExpr) -> Integer
How many *substituted* template arguments the specialization carries. These are the arguments
the concept was checked with, which is why they come from the implicit specialization
declaration rather than from what was written.
"""
function getNumTemplateArguments(x::AbstractConceptSpecializationExpr)
    @check_ptrs x
    return clang_ConceptSpecializationExpr_getNumTemplateArguments(x)
end

"""
    getTemplateArgument(x::AbstractConceptSpecializationExpr, i::Integer) -> TemplateArgument
The `i`-th substituted argument (0-based), borrowed from the specialization declaration's
array.

`i` must be less than [`getNumTemplateArguments`](@ref).
"""
function getTemplateArgument(x::AbstractConceptSpecializationExpr, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumTemplateArguments(x) "template argument index out of range"
    return TemplateArgument(clang_ConceptSpecializationExpr_getTemplateArgument(x, i))
end

"""
    getTemplateArguments(x::AbstractConceptSpecializationExpr) -> Vector{TemplateArgument}
Every substituted argument, in order.
"""
function getTemplateArguments(x::AbstractConceptSpecializationExpr)
    @check_ptrs x
    return [getTemplateArgument(x, i) for i = 0:(getNumTemplateArguments(x) - 1)]
end

function getNamedConcept(x::AbstractConceptSpecializationExpr)
    @check_ptrs x
    return ConceptDecl(clang_ConceptSpecializationExpr_getNamedConcept(x))
end

"""
    getSpecializationDecl(x::AbstractConceptSpecializationExpr) -> ImplicitConceptSpecializationDecl
The invented declaration holding the substituted arguments.
"""
function getSpecializationDecl(x::AbstractConceptSpecializationExpr)
    @check_ptrs x
    return ImplicitConceptSpecializationDecl(clang_ConceptSpecializationExpr_getSpecializationDecl(x))
end

function hasExplicitTemplateArgs(x::AbstractConceptSpecializationExpr)
    @check_ptrs x
    return clang_ConceptSpecializationExpr_hasExplicitTemplateArgs(x)
end

"""
    isSatisfied(x::AbstractConceptSpecializationExpr) -> Bool
Whether the concept held for these arguments, as decided when the expression was built.

PARTIAL: `x` must not be value-dependent — clang asserts it, because inside an uninstantiated
template there is nothing to have decided yet.
"""
function isSatisfied(x::AbstractConceptSpecializationExpr)
    @check_ptrs x
    @assert !isValueDependent(x) "a value-dependent concept-id has no satisfaction record"
    return clang_ConceptSpecializationExpr_isSatisfied(x)
end

# ConceptReference

function getNamedConcept(x::AbstractConceptReference)
    @check_ptrs x
    return ConceptDecl(clang_ConceptReference_getNamedConcept(x))
end

"""
    getFoundDecl(x::AbstractConceptReference) -> NamedDecl
What name lookup actually found — this differs from [`getNamedConcept`](@ref) when the concept
was reached through a using-declaration.
"""
function getFoundDecl(x::AbstractConceptReference)
    @check_ptrs x
    return NamedDecl(clang_ConceptReference_getFoundDecl(x))
end

function getConceptNameLoc(x::AbstractConceptReference)
    @check_ptrs x
    return SourceLocation(clang_ConceptReference_getConceptNameLoc(x))
end

function getTemplateKWLoc(x::AbstractConceptReference)
    @check_ptrs x
    return SourceLocation(clang_ConceptReference_getTemplateKWLoc(x))
end

function getLocation(x::AbstractConceptReference)
    @check_ptrs x
    return SourceLocation(clang_ConceptReference_getLocation(x))
end

function getBeginLoc(x::AbstractConceptReference)
    @check_ptrs x
    return SourceLocation(clang_ConceptReference_getBeginLoc(x))
end

function getEndLoc(x::AbstractConceptReference)
    @check_ptrs x
    return SourceLocation(clang_ConceptReference_getEndLoc(x))
end

function getSourceRange(x::AbstractConceptReference)
    @check_ptrs x
    r = clang_ConceptReference_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

"""
    getNestedNameSpecifierLoc(x::AbstractConceptReference) -> NestedNameSpecifierLoc
The qualifier written before the concept name; an unqualified reference gives an empty one.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function getNestedNameSpecifierLoc(x::AbstractConceptReference)
    @check_ptrs x
    return NestedNameSpecifierLoc(clang_ConceptReference_getNestedNameSpecifierLoc(x))
end

"""
    getTemplateArgsAsWritten(x::AbstractConceptReference) -> ASTTemplateArgumentListInfo
The arguments as written, or a NULL carrier — a type-constraint may name no arguments at all,
and then only the substituted arguments on the expression exist.
"""
function getTemplateArgsAsWritten(x::AbstractConceptReference)
    @check_ptrs x
    return ASTTemplateArgumentListInfo(clang_ConceptReference_getTemplateArgsAsWritten(x))
end

function hasExplicitTemplateArgs(x::AbstractConceptReference)
    @check_ptrs x
    return clang_ConceptReference_hasExplicitTemplateArgs(x)
end

# Requirement

function getKind(x::AbstractRequirement)
    @check_ptrs x
    return clang_Requirement_getKind(x)
end

function isDependent(x::AbstractRequirement)
    @check_ptrs x
    return clang_Requirement_isDependent(x)
end

function containsUnexpandedParameterPack(x::AbstractRequirement)
    @check_ptrs x
    return clang_Requirement_containsUnexpandedParameterPack(x)
end

"""
    isSatisfied(x::AbstractRequirement) -> Bool
Whether this one requirement held.

PARTIAL: `x` must not be dependent — clang asserts it.
"""
function isSatisfied(x::AbstractRequirement)
    @check_ptrs x
    @assert !isDependent(x) "a dependent requirement has no satisfaction record"
    return clang_Requirement_isSatisfied(x)
end

"""
    castToTypeRequirement(x::AbstractRequirement) -> TypeRequirement
The same requirement typed as a `typename` requirement, or a NULL carrier when its kind is
not `CXRequirement_RK_Type`.
"""
function castToTypeRequirement(x::AbstractRequirement)
    @check_ptrs x
    return TypeRequirement(clang_Requirement_castToTypeRequirement(x))
end

"""
    castToExprRequirement(x::AbstractRequirement) -> ExprRequirement
The same requirement typed as a simple or compound requirement, or a NULL carrier when its
kind is neither.
"""
function castToExprRequirement(x::AbstractRequirement)
    @check_ptrs x
    return ExprRequirement(clang_Requirement_castToExprRequirement(x))
end

"""
    castToNestedRequirement(x::AbstractRequirement) -> NestedRequirement
The same requirement typed as a nested `requires` clause, or a NULL carrier when its kind is
not `CXRequirement_RK_Nested`.
"""
function castToNestedRequirement(x::AbstractRequirement)
    @check_ptrs x
    return NestedRequirement(clang_Requirement_castToNestedRequirement(x))
end

# TypeRequirement

function getSatisfactionStatus(x::AbstractTypeRequirement)
    @check_ptrs x
    return clang_TypeRequirement_getSatisfactionStatus(x)
end

function isSubstitutionFailure(x::AbstractTypeRequirement)
    @check_ptrs x
    return clang_TypeRequirement_isSubstitutionFailure(x)
end

"""
    getType(x::AbstractTypeRequirement) -> TypeSourceInfo
The type named by a `typename T::foo;` requirement.

PARTIAL: `isSubstitutionFailure(x)` must be false — the other arm of the union holds a
diagnostic, and clang reads the type arm unconditionally after asserting.
"""
function getType(x::AbstractTypeRequirement)
    @check_ptrs x
    @assert !isSubstitutionFailure(x) "the type requirement holds a substitution diagnostic"
    return TypeSourceInfo(clang_TypeRequirement_getType(x))
end

# ExprRequirement

function isSimple(x::AbstractExprRequirement)
    @check_ptrs x
    return clang_ExprRequirement_isSimple(x)
end

function isCompound(x::AbstractExprRequirement)
    @check_ptrs x
    return clang_ExprRequirement_isCompound(x)
end

function hasNoexceptRequirement(x::AbstractExprRequirement)
    @check_ptrs x
    return clang_ExprRequirement_hasNoexceptRequirement(x)
end

function getNoexceptLoc(x::AbstractExprRequirement)
    @check_ptrs x
    return SourceLocation(clang_ExprRequirement_getNoexceptLoc(x))
end

function getSatisfactionStatus(x::AbstractExprRequirement)
    @check_ptrs x
    return clang_ExprRequirement_getSatisfactionStatus(x)
end

function isExprSubstitutionFailure(x::AbstractExprRequirement)
    @check_ptrs x
    return clang_ExprRequirement_isExprSubstitutionFailure(x)
end

"""
    getExpr(x::AbstractExprRequirement) -> Expr_
The expression the requirement checks.

PARTIAL: `isExprSubstitutionFailure(x)` must be false.
"""
function getExpr(x::AbstractExprRequirement)
    @check_ptrs x
    @assert !isExprSubstitutionFailure(x) "the requirement holds a substitution diagnostic"
    return Expr_(clang_ExprRequirement_getExpr(x))
end

# NestedRequirement

function hasInvalidConstraint(x::AbstractNestedRequirement)
    @check_ptrs x
    return clang_NestedRequirement_hasInvalidConstraint(x)
end

"""
    getInvalidConstraintEntity(x::AbstractNestedRequirement) -> String
The pre-rendered spelling of the constraint clang could not build.

PARTIAL: `hasInvalidConstraint(x)` must hold.
"""
function getInvalidConstraintEntity(x::AbstractNestedRequirement)
    @check_ptrs x
    @assert hasInvalidConstraint(x) "the nested requirement has a valid constraint"
    return get_string(clang_NestedRequirement_getInvalidConstraintEntity(x))
end

"""
    getConstraintExpr(x::AbstractNestedRequirement) -> Expr_
The constraint expression of a `requires expr;` entry.

PARTIAL: `hasInvalidConstraint(x)` must be false.
"""
function getConstraintExpr(x::AbstractNestedRequirement)
    @check_ptrs x
    @assert !hasInvalidConstraint(x) "the nested requirement's constraint could not be built"
    return Expr_(clang_NestedRequirement_getConstraintExpr(x))
end

# RequiresExpr

"""
    getNumLocalParameters(x::AbstractRequiresExpr) -> Integer
How many parameters the `requires (T a, T b)` list declares.
"""
function getNumLocalParameters(x::AbstractRequiresExpr)
    @check_ptrs x
    return clang_RequiresExpr_getNumLocalParameters(x)
end

"""
    getLocalParameter(x::AbstractRequiresExpr, i::Integer) -> ParmVarDecl
The `i`-th local parameter (0-based).

`i` must be less than [`getNumLocalParameters`](@ref).
"""
function getLocalParameter(x::AbstractRequiresExpr, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumLocalParameters(x) "local parameter index out of range"
    return ParmVarDecl(clang_RequiresExpr_getLocalParameter(x, i))
end

"""
    getLocalParameters(x::AbstractRequiresExpr) -> Vector{ParmVarDecl}
Every parameter of the `requires (...)` list, in order.
"""
function getLocalParameters(x::AbstractRequiresExpr)
    @check_ptrs x
    return [getLocalParameter(x, i) for i = 0:(getNumLocalParameters(x) - 1)]
end

function getBody(x::AbstractRequiresExpr)
    @check_ptrs x
    return RequiresExprBodyDecl(clang_RequiresExpr_getBody(x))
end

"""
    getNumRequirements(x::AbstractRequiresExpr) -> Integer
How many entries the requirement body holds.
"""
function getNumRequirements(x::AbstractRequiresExpr)
    @check_ptrs x
    return clang_RequiresExpr_getNumRequirements(x)
end

"""
    getRequirement(x::AbstractRequiresExpr, i::Integer) -> Requirement
The `i`-th requirement (0-based), borrowed from `x`. Discriminate it on
[`getKind`](@ref) and narrow it with [`castToTypeRequirement`](@ref),
[`castToExprRequirement`](@ref) or [`castToNestedRequirement`](@ref).

`i` must be less than [`getNumRequirements`](@ref).
"""
function getRequirement(x::AbstractRequiresExpr, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumRequirements(x) "requirement index out of range"
    return Requirement(clang_RequiresExpr_getRequirement(x, i))
end

"""
    getRequirements(x::AbstractRequiresExpr) -> Vector{Requirement}
Every entry of the requirement body, in order.
"""
function getRequirements(x::AbstractRequiresExpr)
    @check_ptrs x
    return [getRequirement(x, i) for i = 0:(getNumRequirements(x) - 1)]
end

"""
    isSatisfied(x::AbstractRequiresExpr) -> Bool
Whether every requirement in the body held.

PARTIAL: `x` must not be value-dependent — clang asserts it.
"""
function isSatisfied(x::AbstractRequiresExpr)
    @check_ptrs x
    @assert !isValueDependent(x) "a value-dependent requires-expression has no satisfaction record"
    return clang_RequiresExpr_isSatisfied(x)
end

function getRequiresKWLoc(x::AbstractRequiresExpr)
    @check_ptrs x
    return SourceLocation(clang_RequiresExpr_getRequiresKWLoc(x))
end

function getLParenLoc(x::AbstractRequiresExpr)
    @check_ptrs x
    return SourceLocation(clang_RequiresExpr_getLParenLoc(x))
end

function getRParenLoc(x::AbstractRequiresExpr)
    @check_ptrs x
    return SourceLocation(clang_RequiresExpr_getRParenLoc(x))
end

function getRBraceLoc(x::AbstractRequiresExpr)
    @check_ptrs x
    return SourceLocation(clang_RequiresExpr_getRBraceLoc(x))
end
