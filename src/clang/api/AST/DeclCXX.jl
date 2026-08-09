# CXXRecordDecl
function getCanonicalDecl(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return CXXRecordDecl(clang_CXXRecordDecl_getCanonicalDecl(x))
end

function getPreviousDecl(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return CXXRecordDecl(clang_CXXRecordDecl_getPreviousDecl(x))
end

function getMostRecentDecl(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return CXXRecordDecl(clang_CXXRecordDecl_getMostRecentDecl(x))
end

function getMostRecentNonInjectedDecl(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return CXXRecordDecl(clang_CXXRecordDecl_getMostRecentNonInjectedDecl(x))
end

function getDefinition(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return CXXRecordDecl(clang_CXXRecordDecl_getDefinition(x))
end

function hasDefinition(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasDefinition(x)
end

function isLambda(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_isLambda(x)
end

function isGenericLambda(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_isGenericLambda(x)
end

function getGenericLambdaTemplateParameterList(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return TemplateParameterList(clang_CXXRecordDecl_getGenericLambdaTemplateParameterList(x))
end

function isAggregate(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_isAggregate(x)
end

function isPOD(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_isPOD(x)
end

function isCLike(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_isCLike(x)
end

function isEmpty(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_isEmpty(x)
end

function isDynamicClass(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_isDynamicClass(x)
end

function allowConstDefaultInit(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_allowConstDefaultInit(x)
end

function defaultedCopyConstructorIsDeleted(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_defaultedCopyConstructorIsDeleted(x)
end

function defaultedDefaultConstructorIsConstexpr(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_defaultedDefaultConstructorIsConstexpr(x)
end

function defaultedDestructorIsConstexpr(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_defaultedDestructorIsConstexpr(x)
end

function defaultedDestructorIsDeleted(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_defaultedDestructorIsDeleted(x)
end

function defaultedMoveConstructorIsDeleted(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_defaultedMoveConstructorIsDeleted(x)
end

function hasAnyDependentBases(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasAnyDependentBases(x)
end

function hasConstexprDefaultConstructor(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasConstexprDefaultConstructor(x)
end

function hasConstexprDestructor(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasConstexprDestructor(x)
end

function hasConstexprNonCopyMoveConstructor(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasConstexprNonCopyMoveConstructor(x)
end

function hasCopyAssignmentWithConstParam(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasCopyAssignmentWithConstParam(x)
end

function hasCopyConstructorWithConstParam(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasCopyConstructorWithConstParam(x)
end

function hasDefaultConstructor(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasDefaultConstructor(x)
end

function hasDirectFields(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasDirectFields(x)
end

function hasFriends(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasFriends(x)
end

function hasInClassInitializer(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasInClassInitializer(x)
end

function hasInheritedAssignment(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasInheritedAssignment(x)
end

function hasInheritedConstructor(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasInheritedConstructor(x)
end

function hasInitMethod(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasInitMethod(x)
end

function hasIrrelevantDestructor(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasIrrelevantDestructor(x)
end

function hasKnownLambdaInternalLinkage(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasKnownLambdaInternalLinkage(x)
end

function hasMoveAssignment(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasMoveAssignment(x)
end

function hasMoveConstructor(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasMoveConstructor(x)
end

function hasMutableFields(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasMutableFields(x)
end

function hasNonLiteralTypeFieldsOrBases(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasNonLiteralTypeFieldsOrBases(x)
end

function hasNonTrivialCopyAssignment(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasNonTrivialCopyAssignment(x)
end

function hasNonTrivialCopyConstructor(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasNonTrivialCopyConstructor(x)
end

function hasNonTrivialCopyConstructorForCall(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasNonTrivialCopyConstructorForCall(x)
end

function hasNonTrivialDefaultConstructor(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasNonTrivialDefaultConstructor(x)
end

function hasNonTrivialDestructor(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasNonTrivialDestructor(x)
end

function hasNonTrivialDestructorForCall(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasNonTrivialDestructorForCall(x)
end

function hasNonTrivialMoveAssignment(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasNonTrivialMoveAssignment(x)
end

function hasNonTrivialMoveConstructor(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasNonTrivialMoveConstructor(x)
end

function hasNonTrivialMoveConstructorForCall(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasNonTrivialMoveConstructorForCall(x)
end

function hasPrivateFields(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasPrivateFields(x)
end

function hasProtectedFields(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasProtectedFields(x)
end

function hasSimpleCopyAssignment(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasSimpleCopyAssignment(x)
end

function hasSimpleCopyConstructor(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasSimpleCopyConstructor(x)
end

function hasSimpleDestructor(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasSimpleDestructor(x)
end

function hasSimpleMoveAssignment(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasSimpleMoveAssignment(x)
end

function hasSimpleMoveConstructor(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasSimpleMoveConstructor(x)
end

function hasTrivialCopyAssignment(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasTrivialCopyAssignment(x)
end

function hasTrivialCopyConstructor(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasTrivialCopyConstructor(x)
end

function hasTrivialCopyConstructorForCall(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasTrivialCopyConstructorForCall(x)
end

function hasTrivialDefaultConstructor(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasTrivialDefaultConstructor(x)
end

function hasTrivialDestructor(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasTrivialDestructor(x)
end

function hasTrivialDestructorForCall(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasTrivialDestructorForCall(x)
end

function hasTrivialMoveAssignment(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasTrivialMoveAssignment(x)
end

function hasTrivialMoveConstructor(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasTrivialMoveConstructor(x)
end

function hasTrivialMoveConstructorForCall(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasTrivialMoveConstructorForCall(x)
end

function hasUninitializedReferenceMember(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasUninitializedReferenceMember(x)
end

function hasUserDeclaredConstructor(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasUserDeclaredConstructor(x)
end

function hasUserDeclaredCopyAssignment(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasUserDeclaredCopyAssignment(x)
end

function hasUserDeclaredCopyConstructor(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasUserDeclaredCopyConstructor(x)
end

function hasUserDeclaredDestructor(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasUserDeclaredDestructor(x)
end

function hasUserDeclaredMoveAssignment(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasUserDeclaredMoveAssignment(x)
end

function hasUserDeclaredMoveConstructor(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasUserDeclaredMoveConstructor(x)
end

function hasUserDeclaredMoveOperation(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasUserDeclaredMoveOperation(x)
end

function hasUserProvidedDefaultConstructor(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasUserProvidedDefaultConstructor(x)
end

function hasVariantMembers(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_hasVariantMembers(x)
end

function isAbstract(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_isAbstract(x)
end

function isAnyDestructorNoReturn(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_isAnyDestructorNoReturn(x)
end

function isCXX11StandardLayout(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_isCXX11StandardLayout(x)
end

function isCapturelessLambda(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_isCapturelessLambda(x)
end

function isDependentLambda(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_isDependentLambda(x)
end

"""
    isDerivedFrom(x::AbstractCXXRecordDecl, base::AbstractCXXRecordDecl) -> Bool
Return `true` when `x` is (transitively) derived from `base`. Both records must
have complete definitions; the base walk runs entirely on the C++ side.
"""
function isDerivedFrom(x::AbstractCXXRecordDecl, base::AbstractCXXRecordDecl)
    @check_ptrs x base
    @assert hasDefinition(x) "CXXRecordDecl has no definition."
    return clang_CXXRecordDecl_isDerivedFrom(x, base)
end

function isEffectivelyFinal(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_isEffectivelyFinal(x)
end

function isInterfaceLike(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_isInterfaceLike(x)
end

function isLiteral(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_isLiteral(x)
end

function isNeverDependentLambda(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_isNeverDependentLambda(x)
end

function isParsingBaseSpecifiers(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_isParsingBaseSpecifiers(x)
end

function isPolymorphic(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_isPolymorphic(x)
end

function isStandardLayout(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_isStandardLayout(x)
end

function isStructural(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_isStructural(x)
end

function isTrivial(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_isTrivial(x)
end

function isTriviallyCopyConstructible(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_isTriviallyCopyConstructible(x)
end

function isTriviallyCopyable(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_isTriviallyCopyable(x)
end

function isVirtuallyDerivedFrom(x::AbstractCXXRecordDecl, base::AbstractCXXRecordDecl)
    @check_ptrs x base
    @assert hasDefinition(x) "CXXRecordDecl has no definition."
    return clang_CXXRecordDecl_isVirtuallyDerivedFrom(x, base)
end

function mayBeAbstract(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_mayBeAbstract(x)
end

function mayBeDynamicClass(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_mayBeDynamicClass(x)
end

function mayBeNonDynamicClass(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_mayBeNonDynamicClass(x)
end

function needsImplicitCopyAssignment(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_needsImplicitCopyAssignment(x)
end

function needsImplicitCopyConstructor(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_needsImplicitCopyConstructor(x)
end

function needsImplicitDefaultConstructor(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_needsImplicitDefaultConstructor(x)
end

function needsImplicitDestructor(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_needsImplicitDestructor(x)
end

function needsImplicitMoveAssignment(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_needsImplicitMoveAssignment(x)
end

function needsImplicitMoveConstructor(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_needsImplicitMoveConstructor(x)
end

function needsOverloadResolutionForCopyAssignment(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_needsOverloadResolutionForCopyAssignment(x)
end

function needsOverloadResolutionForCopyConstructor(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_needsOverloadResolutionForCopyConstructor(x)
end

function needsOverloadResolutionForDestructor(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_needsOverloadResolutionForDestructor(x)
end

function needsOverloadResolutionForMoveAssignment(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_needsOverloadResolutionForMoveAssignment(x)
end

function needsOverloadResolutionForMoveConstructor(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_needsOverloadResolutionForMoveConstructor(x)
end

function getNumBases(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return Int(clang_CXXRecordDecl_getNumBases(x))
end

function getBase(x::AbstractCXXRecordDecl, i::Integer)
    @check_ptrs x
    return CXXBaseSpecifier(clang_CXXRecordDecl_getBase(x, i))
end

"""
    getBases(x::AbstractCXXRecordDecl) -> Vector{CXXBaseSpecifier}
Return the direct base-class specifiers. Requires a complete definition.
"""

function getBases(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return [getBase(x, i) for i = 0:(clang_CXXRecordDecl_getNumBases(x) - 1)]
end

function getNumVBases(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return Int(clang_CXXRecordDecl_getNumVBases(x))
end

function getVBase(x::AbstractCXXRecordDecl, i::Integer)
    @check_ptrs x
    return CXXBaseSpecifier(clang_CXXRecordDecl_getVBase(x, i))
end

"""
    getVBases(x::AbstractCXXRecordDecl) -> Vector{CXXBaseSpecifier}
Return the virtual base-class specifiers. Requires a complete definition.
"""

function getVBases(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return [getVBase(x, i) for i = 0:(clang_CXXRecordDecl_getNumVBases(x) - 1)]
end

function getNumMethods(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return Int(clang_CXXRecordDecl_getNumMethods(x))
end

"""
    getMethods(x::AbstractCXXRecordDecl) -> Vector{CXXMethodDecl}
Return the member functions declared in the class (requires a definition).
"""

function getMethods(x::AbstractCXXRecordDecl)
    @check_ptrs x
    n = clang_CXXRecordDecl_getNumMethods(x)
    buf = Vector{CXCXXMethodDecl}(undef, n)
    n > 0 && clang_CXXRecordDecl_getMethods(x, buf)
    return [CXXMethodDecl(p) for p in buf]
end

function getNumCtors(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return Int(clang_CXXRecordDecl_getNumCtors(x))
end

"""
    getCtors(x::AbstractCXXRecordDecl) -> Vector{CXXConstructorDecl}
Return the constructors declared in the class (requires a definition).
"""

function getCtors(x::AbstractCXXRecordDecl)
    @check_ptrs x
    n = clang_CXXRecordDecl_getNumCtors(x)
    buf = Vector{CXCXXConstructorDecl}(undef, n)
    n > 0 && clang_CXXRecordDecl_getCtors(x, buf)
    return [CXXConstructorDecl(p) for p in buf]
end

# AccessSpecDecl
function getAccessSpecifierLoc(x::AbstractAccessSpecDecl)
    @check_ptrs x
    return SourceLocation(clang_AccessSpecDecl_getAccessSpecifierLoc(x))
end

function getColonLoc(x::AbstractAccessSpecDecl)
    @check_ptrs x
    return SourceLocation(clang_AccessSpecDecl_getColonLoc(x))
end

function getSourceRange(x::AbstractAccessSpecDecl)
    @check_ptrs x
    r = clang_AccessSpecDecl_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

# CXXMethodDecl
function addOverriddenMethod(x::AbstractCXXMethodDecl, md::AbstractCXXMethodDecl)
    @check_ptrs x md
    return clang_CXXMethodDecl_addOverriddenMethod(x, md)
end

function getCorrespondingMethodDeclaredInClass(x::AbstractCXXMethodDecl, rd::AbstractCXXRecordDecl, may_be_base::Bool=false)
    @check_ptrs x rd
    return CXXMethodDecl(clang_CXXMethodDecl_getCorrespondingMethodDeclaredInClass(x, rd, may_be_base))
end

function getCorrespondingMethodInClass(x::AbstractCXXMethodDecl, rd::AbstractCXXRecordDecl, may_be_base::Bool=false)
    @check_ptrs x rd
    return CXXMethodDecl(clang_CXXMethodDecl_getCorrespondingMethodInClass(x, rd, may_be_base))
end

function getDevirtualizedMethod(x::AbstractCXXMethodDecl, base::AbstractExpr, is_apple_kext::Bool=false)
    @check_ptrs x base
    return CXXMethodDecl(clang_CXXMethodDecl_getDevirtualizedMethod(x, base, is_apple_kext))
end
function getCanonicalDecl(x::AbstractCXXMethodDecl)
    @check_ptrs x
    return CXXMethodDecl(clang_CXXMethodDecl_getCanonicalDecl(x))
end

function getMostRecentDecl(x::AbstractCXXMethodDecl)
    @check_ptrs x
    return CXXMethodDecl(clang_CXXMethodDecl_getMostRecentDecl(x))
end

function getParent(x::AbstractCXXMethodDecl)
    @check_ptrs x
    return CXXRecordDecl(clang_CXXMethodDecl_getParent(x))
end

function getThisType(x::AbstractCXXMethodDecl)
    @check_ptrs x
    return QualType(clang_CXXMethodDecl_getThisType(x))
end

function hasInlineBody(x::AbstractCXXMethodDecl)
    @check_ptrs x
    return clang_CXXMethodDecl_hasInlineBody(x)
end

function isConst(x::AbstractCXXMethodDecl)
    @check_ptrs x
    return clang_CXXMethodDecl_isConst(x)
end

function isCopyAssignmentOperator(x::AbstractCXXMethodDecl)
    @check_ptrs x
    return clang_CXXMethodDecl_isCopyAssignmentOperator(x)
end

function isInstance(x::AbstractCXXMethodDecl)
    @check_ptrs x
    return clang_CXXMethodDecl_isInstance(x)
end

function isLambdaStaticInvoker(x::AbstractCXXMethodDecl)
    @check_ptrs x
    return clang_CXXMethodDecl_isLambdaStaticInvoker(x)
end

function isMoveAssignmentOperator(x::AbstractCXXMethodDecl)
    @check_ptrs x
    return clang_CXXMethodDecl_isMoveAssignmentOperator(x)
end

function isStatic(x::AbstractCXXMethodDecl)
    @check_ptrs x
    return clang_CXXMethodDecl_isStatic(x)
end

function isVirtual(x::AbstractCXXMethodDecl)
    @check_ptrs x
    return clang_CXXMethodDecl_isVirtual(x)
end

function isVolatile(x::AbstractCXXMethodDecl)
    @check_ptrs x
    return clang_CXXMethodDecl_isVolatile(x)
end

# LinkageSpecDecl
function getEndLoc(x::AbstractLinkageSpecDecl)
    @check_ptrs x
    return SourceLocation(clang_LinkageSpecDecl_getEndLoc(x))
end

function getExternLoc(x::AbstractLinkageSpecDecl)
    @check_ptrs x
    return SourceLocation(clang_LinkageSpecDecl_getExternLoc(x))
end

function getLanguage(x::AbstractLinkageSpecDecl)
    @check_ptrs x
    return clang_LinkageSpecDecl_getLanguage(x)
end

function getRBraceLoc(x::AbstractLinkageSpecDecl)
    @check_ptrs x
    return SourceLocation(clang_LinkageSpecDecl_getRBraceLoc(x))
end

function getSourceRange(x::AbstractLinkageSpecDecl)
    @check_ptrs x
    r = clang_LinkageSpecDecl_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

function hasBraces(x::AbstractLinkageSpecDecl)
    @check_ptrs x
    return clang_LinkageSpecDecl_hasBraces(x)
end

# LinkageSpecDecl Cast
function DeclContext(x::AbstractLinkageSpecDecl)
    @check_ptrs x
    return DeclContext(clang_LinkageSpecDecl_castToDeclContext(x))
end

function LinkageSpecDecl(x::DeclContext)
    @check_ptrs x
    return LinkageSpecDecl(clang_LinkageSpecDecl_castFromDeclContext(x))
end

# CXXBaseSpecifier
function getAccessSpecifier(x::CXXBaseSpecifier)
    @check_ptrs x
    return clang_CXXBaseSpecifier_getAccessSpecifier(x)
end

function getAccessSpecifierAsWritten(x::CXXBaseSpecifier)
    @check_ptrs x
    return clang_CXXBaseSpecifier_getAccessSpecifierAsWritten(x)
end

function getBaseTypeLoc(x::CXXBaseSpecifier)
    @check_ptrs x
    return SourceLocation(clang_CXXBaseSpecifier_getBaseTypeLoc(x))
end

function getEllipsisLoc(x::CXXBaseSpecifier)
    @check_ptrs x
    return SourceLocation(clang_CXXBaseSpecifier_getEllipsisLoc(x))
end

function getEndLoc(x::CXXBaseSpecifier)
    @check_ptrs x
    return SourceLocation(clang_CXXBaseSpecifier_getEndLoc(x))
end

function getInheritConstructors(x::CXXBaseSpecifier)
    @check_ptrs x
    return clang_CXXBaseSpecifier_getInheritConstructors(x)
end

function getSourceRange(x::CXXBaseSpecifier)
    @check_ptrs x
    r = clang_CXXBaseSpecifier_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

function getType(x::CXXBaseSpecifier)
    @check_ptrs x
    return QualType(clang_CXXBaseSpecifier_getType(x))
end

function getTypeSourceInfo(x::CXXBaseSpecifier)
    @check_ptrs x
    return TypeSourceInfo(clang_CXXBaseSpecifier_getTypeSourceInfo(x))
end

function isBaseOfClass(x::CXXBaseSpecifier)
    @check_ptrs x
    return clang_CXXBaseSpecifier_isBaseOfClass(x)
end

function isPackExpansion(x::CXXBaseSpecifier)
    @check_ptrs x
    return clang_CXXBaseSpecifier_isPackExpansion(x)
end

function isVirtual(x::CXXBaseSpecifier)
    @check_ptrs x
    return clang_CXXBaseSpecifier_isVirtual(x)
end

# ExplicitSpecifier
function getExpr(x::ExplicitSpecifier)
    @check_ptrs x
    return Expr_(clang_ExplicitSpecifier_getExpr(x))
end

function getKind(x::ExplicitSpecifier)
    @check_ptrs x
    return clang_ExplicitSpecifier_getKind(x)
end

function isExplicit(x::ExplicitSpecifier)
    @check_ptrs x
    return clang_ExplicitSpecifier_isExplicit(x)
end

function isInvalid(x::ExplicitSpecifier)
    @check_ptrs x
    return clang_ExplicitSpecifier_isInvalid(x)
end

function isSpecified(x::ExplicitSpecifier)
    @check_ptrs x
    return clang_ExplicitSpecifier_isSpecified(x)
end

# CXXConstructorDecl
function isExplicit(x::AbstractCXXConstructorDecl)
    @check_ptrs x
    return clang_CXXConstructorDecl_isExplicit(x)
end

function isDefaultConstructor(x::AbstractCXXConstructorDecl)
    @check_ptrs x
    return clang_CXXConstructorDecl_isDefaultConstructor(x)
end

function isCopyConstructor(x::AbstractCXXConstructorDecl)
    @check_ptrs x
    return clang_CXXConstructorDecl_isCopyConstructor(x)
end

function isMoveConstructor(x::AbstractCXXConstructorDecl)
    @check_ptrs x
    return clang_CXXConstructorDecl_isMoveConstructor(x)
end

function isCopyOrMoveConstructor(x::AbstractCXXConstructorDecl)
    @check_ptrs x
    return clang_CXXConstructorDecl_isCopyOrMoveConstructor(x)
end

function isDelegatingConstructor(x::AbstractCXXConstructorDecl)
    @check_ptrs x
    return clang_CXXConstructorDecl_isDelegatingConstructor(x)
end

function isInheritingConstructor(x::AbstractCXXConstructorDecl)
    @check_ptrs x
    return clang_CXXConstructorDecl_isInheritingConstructor(x)
end

function isSpecializationCopyingObject(x::AbstractCXXConstructorDecl)
    @check_ptrs x
    return clang_CXXConstructorDecl_isSpecializationCopyingObject(x)
end

function getNumCtorInitializers(x::AbstractCXXConstructorDecl)
    @check_ptrs x
    return clang_CXXConstructorDecl_getNumCtorInitializers(x)
end

function getCtorInitializer(x::AbstractCXXConstructorDecl, i::Integer)
    @check_ptrs x
    return CXXCtorInitializer(clang_CXXConstructorDecl_getCtorInitializer(x, i))
end

"""
    getCtorInitializers(x::AbstractCXXConstructorDecl) -> Vector{CXXCtorInitializer}
Return the base/member initializers written in the constructor's init list.
"""

function getCtorInitializers(x::AbstractCXXConstructorDecl)
    @check_ptrs x
    return [getCtorInitializer(x, i) for i = 0:(clang_CXXConstructorDecl_getNumCtorInitializers(x) - 1)]
end

function getTargetConstructor(x::AbstractCXXConstructorDecl)
    @check_ptrs x
    # `CXXConstructorDecl::getTargetConstructor` opens with `assert(isDelegatingConstructor())`
    # and then dereferences `*init_begin()`. The assert is compiled out of the release
    # libclang-cpp, so an ordinary constructor -- which has a null initializer array -- faults
    # rather than returning anything. The predicate is total over any constructor: clang tests
    # the initializer count before it reads the list.
    @assert isDelegatingConstructor(x) "the constructor does not delegate, so it targets nothing"
    return CXXConstructorDecl(clang_CXXConstructorDecl_getTargetConstructor(x))
end

# CXXDestructorDecl
function getOperatorDelete(x::AbstractCXXDestructorDecl)
    @check_ptrs x
    return FunctionDecl(clang_CXXDestructorDecl_getOperatorDelete(x))
end

# CXXConversionDecl
function getConversionType(x::AbstractCXXConversionDecl)
    @check_ptrs x
    return QualType(clang_CXXConversionDecl_getConversionType(x))
end

function isExplicit(x::AbstractCXXConversionDecl)
    @check_ptrs x
    return clang_CXXConversionDecl_isExplicit(x)
end

function isLambdaToBlockPointerConversion(x::AbstractCXXConversionDecl)
    @check_ptrs x
    return clang_CXXConversionDecl_isLambdaToBlockPointerConversion(x)
end

# CXXDeductionGuideDecl
function isExplicit(x::AbstractCXXDeductionGuideDecl)
    @check_ptrs x
    return clang_CXXDeductionGuideDecl_isExplicit(x)
end

function getCorrespondingConstructor(x::AbstractCXXDeductionGuideDecl)
    @check_ptrs x
    return CXXConstructorDecl(clang_CXXDeductionGuideDecl_getCorrespondingConstructor(x))
end

function getDeducedTemplate(x::AbstractCXXDeductionGuideDecl)
    @check_ptrs x
    return TemplateDecl(clang_CXXDeductionGuideDecl_getDeducedTemplate(x))
end

function getDeductionCandidateKind(x::AbstractCXXDeductionGuideDecl)
    @check_ptrs x
    return clang_CXXDeductionGuideDecl_getDeductionCandidateKind(x)
end

# CXXCtorInitializer
function isBaseInitializer(x::CXXCtorInitializer)
    @check_ptrs x
    return clang_CXXCtorInitializer_isBaseInitializer(x)
end

function isMemberInitializer(x::CXXCtorInitializer)
    @check_ptrs x
    return clang_CXXCtorInitializer_isMemberInitializer(x)
end

function isAnyMemberInitializer(x::CXXCtorInitializer)
    @check_ptrs x
    return clang_CXXCtorInitializer_isAnyMemberInitializer(x)
end

function isDelegatingInitializer(x::CXXCtorInitializer)
    @check_ptrs x
    return clang_CXXCtorInitializer_isDelegatingInitializer(x)
end

function getMember(x::CXXCtorInitializer)
    @check_ptrs x
    return FieldDecl(clang_CXXCtorInitializer_getMember(x))
end

function getBaseClass(x::CXXCtorInitializer)
    @check_ptrs x
    return Type_(clang_CXXCtorInitializer_getBaseClass(x))
end

function getInit(x::CXXCtorInitializer)
    @check_ptrs x
    return Expr_(clang_CXXCtorInitializer_getInit(x))
end

function getSourceLocation(x::CXXCtorInitializer)
    @check_ptrs x
    return SourceLocation(clang_CXXCtorInitializer_getSourceLocation(x))
end

# UsingDirectiveDecl
function getNominatedNamespace(x::AbstractUsingDirectiveDecl)
    @check_ptrs x
    return NamespaceDecl(clang_UsingDirectiveDecl_getNominatedNamespace(x))
end

# UsingShadowDecl
function getTargetDecl(x::AbstractUsingShadowDecl)
    @check_ptrs x
    return NamedDecl(clang_UsingShadowDecl_getTargetDecl(x))
end

# BaseUsingDecl
function shadow_size(x::AbstractBaseUsingDecl)
    @check_ptrs x
    return Int(clang_BaseUsingDecl_shadow_size(x))
end

"""
    getShadows(x::AbstractBaseUsingDecl) -> Vector{UsingShadowDecl}
Return the using-shadow declarations introduced by this using-declaration.
"""

function getShadows(x::AbstractBaseUsingDecl)
    @check_ptrs x
    n = clang_BaseUsingDecl_shadow_size(x)
    buf = Vector{CXUsingShadowDecl}(undef, n)
    n > 0 && clang_BaseUsingDecl_getShadows(x, buf)
    return [UsingShadowDecl(p) for p in buf]
end

# --- SetFactory sweep: skiplisted set*/Create*/CreateDeserialized ---

# AccessSpecDecl
function AccessSpecDecl(ctx::ASTContext, as::CXAccessSpecifier, dc::AnyDeclContext, as_loc::SourceLocation, colon_loc::SourceLocation)
    @check_ptrs ctx dc
    return AccessSpecDecl(clang_AccessSpecDecl_Create(ctx, as, dc, as_loc, colon_loc))
end

function AccessSpecDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    return AccessSpecDecl(clang_AccessSpecDecl_CreateDeserialized(ctx, id))
end

function setAccessSpecifierLoc(x::AbstractAccessSpecDecl, loc::SourceLocation)
    @check_ptrs x
    return clang_AccessSpecDecl_setAccessSpecifierLoc(x, loc)
end

function setColonLoc(x::AbstractAccessSpecDecl, loc::SourceLocation)
    @check_ptrs x
    return clang_AccessSpecDecl_setColonLoc(x, loc)
end

# LinkageSpecDecl
function LinkageSpecDecl(ctx::ASTContext, dc::AnyDeclContext, extern_loc::SourceLocation, lang_loc::SourceLocation, lang::CXLinkageSpecLanguageIDs, has_braces::Bool)
    @check_ptrs ctx dc
    return LinkageSpecDecl(clang_LinkageSpecDecl_Create(ctx, dc, extern_loc, lang_loc, lang, has_braces))
end

function LinkageSpecDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    return LinkageSpecDecl(clang_LinkageSpecDecl_CreateDeserialized(ctx, id))
end

function setLanguage(x::AbstractLinkageSpecDecl, lang::CXLinkageSpecLanguageIDs)
    @check_ptrs x
    return clang_LinkageSpecDecl_setLanguage(x, lang)
end

function setExternLoc(x::AbstractLinkageSpecDecl, loc::SourceLocation)
    @check_ptrs x
    return clang_LinkageSpecDecl_setExternLoc(x, loc)
end

function setRBraceLoc(x::AbstractLinkageSpecDecl, loc::SourceLocation)
    @check_ptrs x
    return clang_LinkageSpecDecl_setRBraceLoc(x, loc)
end

# AccessSpecDecl setters

# AccessSpecDecl factories

# CXXRecordDecl factories
function CXXRecordDecl(ctx::ASTContext, tk::CXTagTypeKind, dc::AnyDeclContext, start_loc::SourceLocation, id_loc::SourceLocation, id::IdentifierInfo, prev_decl::AbstractCXXRecordDecl=CXXRecordDecl(C_NULL), delay_type_creation::Bool=false)
    @check_ptrs ctx dc
    rd = clang_CXXRecordDecl_Create(ctx, tk, dc, start_loc, id_loc, id, prev_decl, delay_type_creation)
    return CXXRecordDecl(rd)
end

function CXXRecordDecl(ctx::ASTContext, dc::AnyDeclContext, info::TypeSourceInfo, loc::SourceLocation, dependency_kind::CXLambdaDependencyKind, is_generic::Bool, capture_default::CXLambdaCaptureDefault)
    @check_ptrs ctx dc info
    rd = clang_CXXRecordDecl_CreateLambda(ctx, dc, info, loc, dependency_kind, is_generic, capture_default)
    return CXXRecordDecl(rd)
end

# CXXMethodDecl factories
function CXXMethodDecl(ctx::ASTContext, rd::AbstractCXXRecordDecl, start_loc::SourceLocation, name_info::DeclarationNameInfo, ty::QualType, tinfo::TypeSourceInfo, sc::CXStorageClass, uses_fp_intrin::Bool, is_inline::Bool, constexpr_kind::CXConstexprSpecKind, end_loc::SourceLocation, trailing_requires_clause::AbstractExpr=Expr_(C_NULL))
    @check_ptrs ctx rd tinfo
    md = clang_CXXMethodDecl_Create(ctx, rd, start_loc, name_info, ty, tinfo, sc, uses_fp_intrin, is_inline, constexpr_kind, end_loc, trailing_requires_clause)
    return CXXMethodDecl(md)
end

function CXXMethodDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    return CXXMethodDecl(clang_CXXMethodDecl_CreateDeserialized(ctx, id))
end

# CXXBaseSpecifier setter
function setInheritConstructors(x::CXXBaseSpecifier, inherit::Bool=true)
    @check_ptrs x
    return clang_CXXBaseSpecifier_setInheritConstructors(x, inherit)
end

# ExplicitSpecifier setters
function setKind(x::ExplicitSpecifier, kind::CXExplicitSpecKind)
    @check_ptrs x
    return clang_ExplicitSpecifier_setKind(x, kind)
end

function setExpr(x::ExplicitSpecifier, e::AbstractExpr)
    @check_ptrs x e
    return clang_ExplicitSpecifier_setExpr(x, e)
end

# LinkageSpecDecl factories

# LinkageSpecDecl setters

# RequiresExprBodyDecl factories
function RequiresExprBodyDecl(ctx::ASTContext, dc::AnyDeclContext, start_loc::SourceLocation)
    @check_ptrs ctx dc
    return RequiresExprBodyDecl(clang_RequiresExprBodyDecl_Create(ctx, dc, start_loc))
end

function RequiresExprBodyDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    return RequiresExprBodyDecl(clang_RequiresExprBodyDecl_CreateDeserialized(ctx, id))
end

# StaticAssertDecl
function StaticAssertDecl(ctx::ASTContext, dc::AnyDeclContext, static_assert_loc::SourceLocation, assert_expr::AbstractExpr, message::AbstractExpr, rparen_loc::SourceLocation, failed::Bool)
    @check_ptrs ctx dc assert_expr
    return StaticAssertDecl(clang_StaticAssertDecl_Create(ctx, dc, static_assert_loc, assert_expr, message, rparen_loc, failed))
end

function StaticAssertDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    return StaticAssertDecl(clang_StaticAssertDecl_CreateDeserialized(ctx, id))
end

function getAssertExpr(x::AbstractStaticAssertDecl)
    @check_ptrs x
    return Expr_(clang_StaticAssertDecl_getAssertExpr(x))
end

# The returned `Expr_` wraps C_NULL for a message-less `static_assert`.
function getMessage(x::AbstractStaticAssertDecl)
    @check_ptrs x
    return Expr_(clang_StaticAssertDecl_getMessage(x))
end

function isFailed(x::AbstractStaticAssertDecl)
    @check_ptrs x
    return clang_StaticAssertDecl_isFailed(x)
end

function getRParenLoc(x::AbstractStaticAssertDecl)
    @check_ptrs x
    return SourceLocation(clang_StaticAssertDecl_getRParenLoc(x))
end

function getSourceRange(x::AbstractStaticAssertDecl)
    @check_ptrs x
    r = clang_StaticAssertDecl_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

# The lambda accessors below all reach clang::CXXRecordDecl::getLambdaData(),
# which asserts the class is a closure type; on any other class the C++ side
# reinterprets a plain DefinitionData as a LambdaDefinitionData, so the
# precondition is restated here (Invariant 3).
function getLambdaCallOperator(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert isLambda(x) "the record must be a lambda closure type"
    return CXXMethodDecl(clang_CXXRecordDecl_getLambdaCallOperator(x))
end

"""
    getDependentLambdaCallOperator(x::AbstractCXXRecordDecl) -> FunctionTemplateDecl
Return the templated call operator of a generic closure type. The returned
carrier wraps `C_NULL` for a non-generic lambda.
"""
function getDependentLambdaCallOperator(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert isLambda(x) "the record must be a lambda closure type"
    return FunctionTemplateDecl(clang_CXXRecordDecl_getDependentLambdaCallOperator(x))
end

function getLambdaStaticInvoker(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert isLambda(x) "the record must be a lambda closure type"
    return CXXMethodDecl(clang_CXXRecordDecl_getLambdaStaticInvoker(x))
end

function getLambdaCaptureDefault(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert isLambda(x) "the record must be a lambda closure type"
    return clang_CXXRecordDecl_getLambdaCaptureDefault(x)
end

function getLambdaManglingNumber(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert isLambda(x) "the record must be a lambda closure type"
    return Int(clang_CXXRecordDecl_getLambdaManglingNumber(x))
end

function getLambdaIndexInContext(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert isLambda(x) "the record must be a lambda closure type"
    return Int(clang_CXXRecordDecl_getLambdaIndexInContext(x))
end

"""
    getLambdaContextDecl(x::AbstractCXXRecordDecl) -> Decl
Return the declaration that provides the extra mangling context of a lambda. The
returned carrier wraps `C_NULL` when the declaration context suffices.
"""
function getLambdaContextDecl(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert isLambda(x) "the record must be a lambda closure type"
    return Decl(clang_CXXRecordDecl_getLambdaContextDecl(x))
end

function getLambdaTypeInfo(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert isLambda(x) "the record must be a lambda closure type"
    return TypeSourceInfo(clang_CXXRecordDecl_getLambdaTypeInfo(x))
end

# getDestructor and the conversion-function range read clang's definition data,
# which asserts a complete definition (Invariant 3).
function getDestructor(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert hasDefinition(x) "the record must have a complete definition"
    return CXXDestructorDecl(clang_CXXRecordDecl_getDestructor(x))
end

function getNumVisibleConversionFunctions(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert hasDefinition(x) "the record must have a complete definition"
    return Int(clang_CXXRecordDecl_getNumVisibleConversionFunctions(x))
end

"""
    getVisibleConversionFunctions(x::AbstractCXXRecordDecl) -> Vector{NamedDecl}
Return the conversion functions visible in the class, including inherited ones
and conversion function templates. Entries are `CXXConversionDecl`s or
`FunctionTemplateDecl`s, so they are wrapped at their common `NamedDecl` base.
Requires a complete definition.
"""
function getVisibleConversionFunctions(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert hasDefinition(x) "the record must have a complete definition"
    n = clang_CXXRecordDecl_getNumVisibleConversionFunctions(x)
    buf = Vector{CXNamedDecl}(undef, n)
    n > 0 && clang_CXXRecordDecl_getVisibleConversionFunctions(x, buf)
    return [NamedDecl(p) for p in buf]
end

"""
    getTemplateInstantiationPattern(x::AbstractCXXRecordDecl) -> CXXRecordDecl
Return the record this one was instantiated from. The returned carrier wraps
`C_NULL` when the class is not a template instantiation.
"""
function getTemplateInstantiationPattern(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return CXXRecordDecl(clang_CXXRecordDecl_getTemplateInstantiationPattern(x))
end

function getTemplateSpecializationKind(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_getTemplateSpecializationKind(x)
end

"""
    getInstantiatedFromMemberClass(x::AbstractCXXRecordDecl) -> CXXRecordDecl
Return the member class of a class template this one was instantiated from. The
returned carrier wraps `C_NULL` otherwise.
"""
function getInstantiatedFromMemberClass(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return CXXRecordDecl(clang_CXXRecordDecl_getInstantiatedFromMemberClass(x))
end

"""
    isLocalClass(x::AbstractCXXRecordDecl) -> FunctionDecl
Return the enclosing function of a local class. The returned carrier wraps
`C_NULL` when the class is not local to a function.
"""
function isLocalClass(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return FunctionDecl(clang_CXXRecordDecl_isLocalClass(x))
end

"""
    getODRHash(x::AbstractCXXRecordDecl) -> UInt32
Return the ODR hash of the class. `CXXRecordDecl` declares its own `getODRHash`,
which hides `RecordDecl`'s, so this method routes to the C++ one. Requires a
complete definition.
"""
function getODRHash(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert hasDefinition(x) "the record must have a complete definition"
    return clang_CXXRecordDecl_getODRHash(x)
end

# The implicit-copy const-param queries read clang's definition data, which
# asserts a complete definition (Invariant 3).
function implicitCopyConstructorHasConstParam(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert hasDefinition(x) "the record must have a complete definition"
    return clang_CXXRecordDecl_implicitCopyConstructorHasConstParam(x)
end

function implicitCopyAssignmentHasConstParam(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert hasDefinition(x) "the record must have a complete definition"
    return clang_CXXRecordDecl_implicitCopyAssignmentHasConstParam(x)
end

function lambdaIsDefaultConstructibleAndAssignable(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert isLambda(x) "the record must be a lambda closure type"
    return clang_CXXRecordDecl_lambdaIsDefaultConstructibleAndAssignable(x)
end

function getNumLambdaExplicitTemplateParameters(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return Int(clang_CXXRecordDecl_getNumLambdaExplicitTemplateParameters(x))
end

"""
    getLambdaExplicitTemplateParameter(x::AbstractCXXRecordDecl, i) -> NamedDecl
Return the `i`-th (0-based) explicitly written template parameter of a generic
lambda's call operator. The count is 0 for anything that is not a generic lambda.
"""
function getLambdaExplicitTemplateParameter(x::AbstractCXXRecordDecl, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumLambdaExplicitTemplateParameters(x) "index out of range"
    return NamedDecl(clang_CXXRecordDecl_getLambdaExplicitTemplateParameter(x, i))
end

"""
    getLambdaExplicitTemplateParameters(x::AbstractCXXRecordDecl) -> Vector{NamedDecl}
Return the explicitly written template parameters of a generic lambda's call
operator, empty for anything that is not a generic lambda.
"""
function getLambdaExplicitTemplateParameters(x::AbstractCXXRecordDecl)
    @check_ptrs x
    n = getNumLambdaExplicitTemplateParameters(x)
    return [getLambdaExplicitTemplateParameter(x, i) for i = 0:(n - 1)]
end

function capture_size(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert isLambda(x) "the record must be a lambda closure type"
    return Int(clang_CXXRecordDecl_capture_size(x))
end

"""
    getCapture(x::AbstractCXXRecordDecl, i) -> LambdaCapture
Return the `i`-th (0-based) capture of a lambda closure type. The wrapped pointer
borrows into the closure type's capture list; do not dispose it.
"""
function getCapture(x::AbstractCXXRecordDecl, i::Integer)
    @check_ptrs x
    @assert isLambda(x) "the record must be a lambda closure type"
    @assert 0 <= i < capture_size(x) "capture index out of range"
    return LambdaCapture(clang_CXXRecordDecl_getCapture(x, i))
end

"""
    getMemberSpecializationInfo(x::AbstractCXXRecordDecl) -> MemberSpecializationInfo
Return the member specialization info of a member class of a class template
specialization. The returned carrier wraps `C_NULL` otherwise.
"""
function getMemberSpecializationInfo(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return MemberSpecializationInfo(clang_CXXRecordDecl_getMemberSpecializationInfo(x))
end

"""
    getDescribedClassTemplate(x::AbstractCXXRecordDecl) -> ClassTemplateDecl
Return the class template this record is the pattern of. The returned carrier
wraps `C_NULL` when the record does not describe a class template.
"""
function getDescribedClassTemplate(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return ClassTemplateDecl(clang_CXXRecordDecl_getDescribedClassTemplate(x))
end

"""
    isCurrentInstantiation(x::AbstractCXXRecordDecl, ctx::AnyDeclContext) -> Bool
Return whether this dependent class is the current instantiation as seen from
`ctx`. Clang asserts that the receiver is itself a dependent context.
"""
function isCurrentInstantiation(x::AbstractCXXRecordDecl, ctx::AnyDeclContext)
    @check_ptrs x ctx
    @assert is_dependent_context(castToDeclContext(x)) "the record must be a dependent context"
    return clang_CXXRecordDecl_isCurrentInstantiation(x, ctx)
end

"""
    isProvablyNotDerivedFrom(x::AbstractCXXRecordDecl, base::AbstractCXXRecordDecl) -> Bool
Return whether the class is provably not derived from `base`. The base walk runs
on the C++ side, so the receiver needs a complete definition.
"""
function isProvablyNotDerivedFrom(x::AbstractCXXRecordDecl, base::AbstractCXXRecordDecl)
    @check_ptrs x base
    @assert hasDefinition(x) "CXXRecordDecl has no definition."
    return clang_CXXRecordDecl_isProvablyNotDerivedFrom(x, base)
end

"""
    hasMemberName(x::AbstractCXXRecordDecl, name::DeclarationName) -> Bool
Return whether the class, or a non-dependent base of it, has a member named
`name`. No ambiguity check is performed, so this is only appropriate for
warnings, static analysis or indexing. Requires a complete definition.
"""
function hasMemberName(x::AbstractCXXRecordDecl, name::DeclarationName)
    @check_ptrs x
    @assert hasDefinition(x) "CXXRecordDecl has no definition."
    return clang_CXXRecordDecl_hasMemberName(x, name)
end

"""
    MergeAccess(path::CXAccessSpecifier, decl::CXAccessSpecifier) -> CXAccessSpecifier
Combine the access along an inheritance path with a declaration's own access.
`clang::CXXRecordDecl::MergeAccess` is a static member and asserts that `decl` is
not `AS_none`.
"""
function MergeAccess(path::CXAccessSpecifier, decl::CXAccessSpecifier)
    @assert decl != CXAccessSpecifier_AS_none "the declaration's access must not be AS_none"
    return clang_CXXRecordDecl_MergeAccess(path, decl)
end

function getDeviceLambdaManglingNumber(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert isLambda(x) "the record must be a lambda closure type"
    return clang_CXXRecordDecl_getDeviceLambdaManglingNumber(x)
end

"""
    getLambdaDependencyKind(x::AbstractCXXRecordDecl) -> CXLambdaDependencyKind
Return the dependency kind recorded for a lambda closure type at creation time;
`CXLambdaDependencyKind_Unknown` for anything that is not a lambda.
"""
function getLambdaDependencyKind(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_getLambdaDependencyKind(x)
end

# CXXCtorInitializer (read-surface continued)
function isIndirectMemberInitializer(x::CXXCtorInitializer)
    @check_ptrs x
    return clang_CXXCtorInitializer_isIndirectMemberInitializer(x)
end

function isInClassMemberInitializer(x::CXXCtorInitializer)
    @check_ptrs x
    return clang_CXXCtorInitializer_isInClassMemberInitializer(x)
end

function isPackExpansion(x::CXXCtorInitializer)
    @check_ptrs x
    return clang_CXXCtorInitializer_isPackExpansion(x)
end

function getEllipsisLoc(x::CXXCtorInitializer)
    @check_ptrs x
    return SourceLocation(clang_CXXCtorInitializer_getEllipsisLoc(x))
end

"""
    isBaseVirtual(x::CXXCtorInitializer) -> Bool
Whether the initialized base class is virtual. The initializer must initialize a
base class; guarded by `isBaseInitializer`.
"""
function isBaseVirtual(x::CXXCtorInitializer)
    @check_ptrs x
    @assert isBaseInitializer(x) "the initializer must initialize a base class"
    return clang_CXXCtorInitializer_isBaseVirtual(x)
end

function getTypeSourceInfo(x::CXXCtorInitializer)
    @check_ptrs x
    return TypeSourceInfo(clang_CXXCtorInitializer_getTypeSourceInfo(x))
end

function getAnyMember(x::CXXCtorInitializer)
    @check_ptrs x
    return FieldDecl(clang_CXXCtorInitializer_getAnyMember(x))
end

function getIndirectMember(x::CXXCtorInitializer)
    @check_ptrs x
    return IndirectFieldDecl(clang_CXXCtorInitializer_getIndirectMember(x))
end

function getMemberLocation(x::CXXCtorInitializer)
    @check_ptrs x
    return SourceLocation(clang_CXXCtorInitializer_getMemberLocation(x))
end

function getSourceRange(x::CXXCtorInitializer)
    @check_ptrs x
    r = clang_CXXCtorInitializer_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

function isWritten(x::CXXCtorInitializer)
    @check_ptrs x
    return clang_CXXCtorInitializer_isWritten(x)
end

function getSourceOrder(x::CXXCtorInitializer)
    @check_ptrs x
    return clang_CXXCtorInitializer_getSourceOrder(x)
end

function getLParenLoc(x::CXXCtorInitializer)
    @check_ptrs x
    return SourceLocation(clang_CXXCtorInitializer_getLParenLoc(x))
end

function getRParenLoc(x::CXXCtorInitializer)
    @check_ptrs x
    return SourceLocation(clang_CXXCtorInitializer_getRParenLoc(x))
end

# NamespaceAliasDecl
function getCanonicalDecl(x::AbstractNamespaceAliasDecl)
    @check_ptrs x
    return NamespaceAliasDecl(clang_NamespaceAliasDecl_getCanonicalDecl(x))
end

function getNamespace(x::AbstractNamespaceAliasDecl)
    @check_ptrs x
    return NamespaceDecl(clang_NamespaceAliasDecl_getNamespace(x))
end

function getAliasLoc(x::AbstractNamespaceAliasDecl)
    @check_ptrs x
    return SourceLocation(clang_NamespaceAliasDecl_getAliasLoc(x))
end

function getNamespaceLoc(x::AbstractNamespaceAliasDecl)
    @check_ptrs x
    return SourceLocation(clang_NamespaceAliasDecl_getNamespaceLoc(x))
end

function getTargetNameLoc(x::AbstractNamespaceAliasDecl)
    @check_ptrs x
    return SourceLocation(clang_NamespaceAliasDecl_getTargetNameLoc(x))
end

function getAliasedNamespace(x::AbstractNamespaceAliasDecl)
    @check_ptrs x
    return NamedDecl(clang_NamespaceAliasDecl_getAliasedNamespace(x))
end

# CXXMethodDecl (explicit/implicit object-parameter surface)
function isExplicitObjectMemberFunction(x::AbstractCXXMethodDecl)
    @check_ptrs x
    return clang_CXXMethodDecl_isExplicitObjectMemberFunction(x)
end

function isImplicitObjectMemberFunction(x::AbstractCXXMethodDecl)
    @check_ptrs x
    return clang_CXXMethodDecl_isImplicitObjectMemberFunction(x)
end

function size_overridden_methods(x::AbstractCXXMethodDecl)
    @check_ptrs x
    return Int(clang_CXXMethodDecl_size_overridden_methods(x))
end

function getNumExplicitParams(x::AbstractCXXMethodDecl)
    @check_ptrs x
    return Int(clang_CXXMethodDecl_getNumExplicitParams(x))
end

# UsingDecl
function getUsingLoc(x::AbstractUsingDecl)
    @check_ptrs x
    return SourceLocation(clang_UsingDecl_getUsingLoc(x))
end

function getQualifier(x::AbstractUsingDecl)
    @check_ptrs x
    return NestedNameSpecifier(clang_UsingDecl_getQualifier(x))
end

function isAccessDeclaration(x::AbstractUsingDecl)
    @check_ptrs x
    return clang_UsingDecl_isAccessDeclaration(x)
end

function hasTypename(x::AbstractUsingDecl)
    @check_ptrs x
    return clang_UsingDecl_hasTypename(x)
end

function getSourceRange(x::AbstractUsingDecl)
    @check_ptrs x
    r = clang_UsingDecl_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

function getCanonicalDecl(x::AbstractUsingDecl)
    @check_ptrs x
    return UsingDecl(clang_UsingDecl_getCanonicalDecl(x))
end

# ConstructorUsingShadowDecl
function getIntroducer(x::AbstractConstructorUsingShadowDecl)
    @check_ptrs x
    return UsingDecl(clang_ConstructorUsingShadowDecl_getIntroducer(x))
end

function getParent(x::AbstractConstructorUsingShadowDecl)
    @check_ptrs x
    return CXXRecordDecl(clang_ConstructorUsingShadowDecl_getParent(x))
end

function getNominatedBaseClassShadowDecl(x::AbstractConstructorUsingShadowDecl)
    @check_ptrs x
    return ConstructorUsingShadowDecl(clang_ConstructorUsingShadowDecl_getNominatedBaseClassShadowDecl(x))
end

function getConstructedBaseClassShadowDecl(x::AbstractConstructorUsingShadowDecl)
    @check_ptrs x
    return ConstructorUsingShadowDecl(clang_ConstructorUsingShadowDecl_getConstructedBaseClassShadowDecl(x))
end

function getNominatedBaseClass(x::AbstractConstructorUsingShadowDecl)
    @check_ptrs x
    return CXXRecordDecl(clang_ConstructorUsingShadowDecl_getNominatedBaseClass(x))
end

function getConstructedBaseClass(x::AbstractConstructorUsingShadowDecl)
    @check_ptrs x
    return CXXRecordDecl(clang_ConstructorUsingShadowDecl_getConstructedBaseClass(x))
end

function constructsVirtualBase(x::AbstractConstructorUsingShadowDecl)
    @check_ptrs x
    return clang_ConstructorUsingShadowDecl_constructsVirtualBase(x)
end

# UsingDirectiveDecl (qualifier / ancestry / source locations)
function getQualifier(x::AbstractUsingDirectiveDecl)
    @check_ptrs x
    return NestedNameSpecifier(clang_UsingDirectiveDecl_getQualifier(x))
end

function getNominatedNamespaceAsWritten(x::AbstractUsingDirectiveDecl)
    @check_ptrs x
    return NamedDecl(clang_UsingDirectiveDecl_getNominatedNamespaceAsWritten(x))
end

function getCommonAncestor(x::AbstractUsingDirectiveDecl)
    @check_ptrs x
    return DeclContext(clang_UsingDirectiveDecl_getCommonAncestor(x))
end

function getUsingLoc(x::AbstractUsingDirectiveDecl)
    @check_ptrs x
    return SourceLocation(clang_UsingDirectiveDecl_getUsingLoc(x))
end

function getNamespaceKeyLocation(x::AbstractUsingDirectiveDecl)
    @check_ptrs x
    return SourceLocation(clang_UsingDirectiveDecl_getNamespaceKeyLocation(x))
end

function getIdentLocation(x::AbstractUsingDirectiveDecl)
    @check_ptrs x
    return SourceLocation(clang_UsingDirectiveDecl_getIdentLocation(x))
end

function getSourceRange(x::AbstractUsingDirectiveDecl)
    @check_ptrs x
    r = clang_UsingDirectiveDecl_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

# UsingShadowDecl (canonical decl / introducer / shadow chain)
function getCanonicalDecl(x::AbstractUsingShadowDecl)
    @check_ptrs x
    return UsingShadowDecl(clang_UsingShadowDecl_getCanonicalDecl(x))
end

function getIntroducer(x::AbstractUsingShadowDecl)
    @check_ptrs x
    return BaseUsingDecl(clang_UsingShadowDecl_getIntroducer(x))
end

# NULL-pointer carrier when no further shadow of the same using-declaration follows.
function getNextUsingShadowDecl(x::AbstractUsingShadowDecl)
    @check_ptrs x
    return UsingShadowDecl(clang_UsingShadowDecl_getNextUsingShadowDecl(x))
end

# UnresolvedUsingValueDecl
function getUsingLoc(x::AbstractUnresolvedUsingValueDecl)
    @check_ptrs x
    return SourceLocation(clang_UnresolvedUsingValueDecl_getUsingLoc(x))
end

function isAccessDeclaration(x::AbstractUnresolvedUsingValueDecl)
    @check_ptrs x
    return clang_UnresolvedUsingValueDecl_isAccessDeclaration(x)
end

function getQualifier(x::AbstractUnresolvedUsingValueDecl)
    @check_ptrs x
    return NestedNameSpecifier(clang_UnresolvedUsingValueDecl_getQualifier(x))
end

function isPackExpansion(x::AbstractUnresolvedUsingValueDecl)
    @check_ptrs x
    return clang_UnresolvedUsingValueDecl_isPackExpansion(x)
end

# Invalid `SourceLocation` unless `isPackExpansion(x)`.
function getEllipsisLoc(x::AbstractUnresolvedUsingValueDecl)
    @check_ptrs x
    return SourceLocation(clang_UnresolvedUsingValueDecl_getEllipsisLoc(x))
end

# UnresolvedUsingTypenameDecl
function getUsingLoc(x::AbstractUnresolvedUsingTypenameDecl)
    @check_ptrs x
    return SourceLocation(clang_UnresolvedUsingTypenameDecl_getUsingLoc(x))
end

function getTypenameLoc(x::AbstractUnresolvedUsingTypenameDecl)
    @check_ptrs x
    return SourceLocation(clang_UnresolvedUsingTypenameDecl_getTypenameLoc(x))
end

function getQualifier(x::AbstractUnresolvedUsingTypenameDecl)
    @check_ptrs x
    return NestedNameSpecifier(clang_UnresolvedUsingTypenameDecl_getQualifier(x))
end

function isPackExpansion(x::AbstractUnresolvedUsingTypenameDecl)
    @check_ptrs x
    return clang_UnresolvedUsingTypenameDecl_isPackExpansion(x)
end

# Invalid `SourceLocation` unless `isPackExpansion(x)`.
function getEllipsisLoc(x::AbstractUnresolvedUsingTypenameDecl)
    @check_ptrs x
    return SourceLocation(clang_UnresolvedUsingTypenameDecl_getEllipsisLoc(x))
end

# --- DeclCXX-f sweep: ExplicitSpecifier producers, method object parameters,
# overridden methods and structured bindings ---

# ExplicitSpecifier
"""
    ExplicitSpecifier(x::AbstractFunctionDecl) -> ExplicitSpecifier
Return the explicit-specifier of `x` (`clang::ExplicitSpecifier::getFromDecl`), or an
unspecified one when `x` is not a constructor, conversion function or deduction guide.

This function allocates and one should call `dispose` to release the resources after using
this object. The specifier is a copy of the declaration's own value, so `setKind`/`setExpr`
on it do not modify `x`.
"""
function ExplicitSpecifier(x::AbstractFunctionDecl)
    @check_ptrs x
    return ExplicitSpecifier(clang_ExplicitSpecifier_getFromDecl(x))
end

"""
    ExplicitSpecifier() -> ExplicitSpecifier
Return the invalid explicit specifier (`clang::ExplicitSpecifier::Invalid`), the state a
specifier is left in after a substitution failure.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
ExplicitSpecifier() = ExplicitSpecifier(clang_ExplicitSpecifier_Invalid())

dispose(x::ExplicitSpecifier) = clang_ExplicitSpecifier_dispose(x)

"""
    isEquivalent(x::ExplicitSpecifier, other::ExplicitSpecifier) -> Bool
Return whether the two explicit specifiers are equivalent.
"""
function isEquivalent(x::ExplicitSpecifier, other::ExplicitSpecifier)
    @check_ptrs x other
    return clang_ExplicitSpecifier_isEquivalent(x, other)
end

# CXXDeductionGuideDecl
"""
    getExplicitSpecifier(x::AbstractCXXDeductionGuideDecl) -> ExplicitSpecifier
Return the deduction guide's explicit-specifier.

This function allocates and one should call `dispose` to release the resources after using
this object; the copy is detached from the declaration.
"""
function getExplicitSpecifier(x::AbstractCXXDeductionGuideDecl)
    @check_ptrs x
    return ExplicitSpecifier(clang_CXXDeductionGuideDecl_getExplicitSpecifier(x))
end

# CXXMethodDecl
"""
    getFunctionObjectParameterReferenceType(x::AbstractCXXMethodDecl) -> QualType
Return the type of the method's object parameter as a reference type, carrying the
method's cv- and ref-qualifiers.

`clang::CXXMethodDecl::getFunctionObjectParameterReferenceType` reaches the prototype
through an unchecked `castAs<FunctionProtoType>` and is only meaningful for instance
methods (the same restriction as `getThisType`); both preconditions are restated here.
"""
function getFunctionObjectParameterReferenceType(x::AbstractCXXMethodDecl)
    @check_ptrs x
    @assert isInstance(x) "the object parameter is only defined for instance methods"
    @assert isFunctionProtoType(getTypePtr(getType(x))) "the method must have a prototype"
    return QualType(clang_CXXMethodDecl_getFunctionObjectParameterReferenceType(x))
end

"""
    getFunctionObjectParameterType(x::AbstractCXXMethodDecl) -> QualType
Return the type of the object the method's `this` points at, with the reference stripped.

Same preconditions as [`getFunctionObjectParameterReferenceType`](@ref).
"""
function getFunctionObjectParameterType(x::AbstractCXXMethodDecl)
    @check_ptrs x
    @assert isInstance(x) "the object parameter is only defined for instance methods"
    @assert isFunctionProtoType(getTypePtr(getType(x))) "the method must have a prototype"
    return QualType(clang_CXXMethodDecl_getFunctionObjectParameterType(x))
end

"""
    getMethodQualifiers(x::AbstractCXXMethodDecl) -> UInt32
Return the method's cv-qualifiers as the opaque `clang::Qualifiers` encoding, the same
encoding `getQualifiersAsOpaqueValue(::QualType)` and `getMethodQuals` return (inspect it
with `hasConst`/`hasVolatile`/`hasRestrict`).

`clang::CXXMethodDecl::getMethodQualifiers` reaches the prototype through an unchecked
`castAs<FunctionProtoType>`; the precondition is restated here.
"""
function getMethodQualifiers(x::AbstractCXXMethodDecl)
    @check_ptrs x
    @assert isFunctionProtoType(getTypePtr(getType(x))) "the method must have a prototype"
    return clang_CXXMethodDecl_getMethodQualifiers(x)
end

"""
    getRefQualifier(x::AbstractCXXMethodDecl) -> CXRefQualifierKind
Return the method's ref-qualifier (`&`, `&&`, or none).

`clang::CXXMethodDecl::getRefQualifier` reaches the prototype through an unchecked
`castAs<FunctionProtoType>`; the precondition is restated here.
"""
function getRefQualifier(x::AbstractCXXMethodDecl)
    @check_ptrs x
    @assert isFunctionProtoType(getTypePtr(getType(x))) "the method must have a prototype"
    return clang_CXXMethodDecl_getRefQualifier(x)
end

"""
    getOverriddenMethods(x::AbstractCXXMethodDecl) -> Vector{CXXMethodDecl}
Return the virtual member functions this method overrides. Empty when the method overrides
nothing.
"""
function getOverriddenMethods(x::AbstractCXXMethodDecl)
    @check_ptrs x
    n = clang_CXXMethodDecl_size_overridden_methods(x)
    buf = Vector{CXCXXMethodDecl}(undef, n)
    n > 0 && clang_CXXMethodDecl_getOverriddenMethods(x, buf)
    return [CXXMethodDecl(p) for p in buf]
end

# CXXConstructorDecl
"""
    getExplicitSpecifier(x::AbstractCXXConstructorDecl) -> ExplicitSpecifier
Return the constructor's explicit-specifier.

This function allocates and one should call `dispose` to release the resources after using
this object; the copy is detached from the declaration.
"""
function getExplicitSpecifier(x::AbstractCXXConstructorDecl)
    @check_ptrs x
    return ExplicitSpecifier(clang_CXXConstructorDecl_getExplicitSpecifier(x))
end

# CXXDestructorDecl
# Null `Expr_` unless the destructor's `operator delete` takes a `this` argument.
function getOperatorDeleteThisArg(x::AbstractCXXDestructorDecl)
    @check_ptrs x
    return Expr_(clang_CXXDestructorDecl_getOperatorDeleteThisArg(x))
end

# CXXConversionDecl
"""
    getExplicitSpecifier(x::AbstractCXXConversionDecl) -> ExplicitSpecifier
Return the conversion function's explicit-specifier.

This function allocates and one should call `dispose` to release the resources after using
this object; the copy is detached from the declaration.
"""
function getExplicitSpecifier(x::AbstractCXXConversionDecl)
    @check_ptrs x
    return ExplicitSpecifier(clang_CXXConversionDecl_getExplicitSpecifier(x))
end

# BindingDecl
# Null `Expr_` while the decomposition initializer is being parsed and for a
# type-dependent initializer.
function getBinding(x::AbstractBindingDecl)
    @check_ptrs x
    return Expr_(clang_BindingDecl_getBinding(x))
end

function getDecomposedDecl(x::AbstractBindingDecl)
    @check_ptrs x
    return ValueDecl(clang_BindingDecl_getDecomposedDecl(x))
end

# Null `VarDecl` unless the binding is a user-defined (tuple-like) binding whose value is
# held by an implicit variable.
function getHoldingVar(x::AbstractBindingDecl)
    @check_ptrs x
    return VarDecl(clang_BindingDecl_getHoldingVar(x))
end

function setBinding(x::AbstractBindingDecl, ty::QualType, e::AbstractExpr)
    @check_ptrs x e
    return clang_BindingDecl_setBinding(x, ty, e)
end

function setDecomposedDecl(x::AbstractBindingDecl, decomposed::AbstractValueDecl)
    @check_ptrs x decomposed
    return clang_BindingDecl_setDecomposedDecl(x, decomposed)
end

# DecompositionDecl
function getNumBindings(x::AbstractDecompositionDecl)
    @check_ptrs x
    return Int(clang_DecompositionDecl_getNumBindings(x))
end

function getBinding(x::AbstractDecompositionDecl, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumBindings(x) "binding index $i out of range"
    return BindingDecl(clang_DecompositionDecl_getBinding(x, i))
end

"""
    getBindings(x::AbstractDecompositionDecl) -> Vector{BindingDecl}
Return the bindings introduced by the structured-binding declaration, in source order.
"""
function getBindings(x::AbstractDecompositionDecl)
    @check_ptrs x
    n = Int(clang_DecompositionDecl_getNumBindings(x))
    return [getBinding(x, i) for i = 0:(n - 1)]
end

# --- DeclCXX-g sweep: the UsingEnumDecl / UsingPackDecl / MSPropertyDecl surface,
# plus the CXXBaseSpecifier, CXXCtorInitializer and constructor/destructor tails ---

# CXXBaseSpecifier
function getBeginLoc(x::CXXBaseSpecifier)
    @check_ptrs x
    return SourceLocation(clang_CXXBaseSpecifier_getBeginLoc(x))
end

# CXXCtorInitializer
"""
    getID(x::CXXCtorInitializer, ctx::ASTContext) -> Int64
Return a reproducible identifier for the initializer, unique among the objects
allocated in `ctx`.
"""
function getID(x::CXXCtorInitializer, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_CXXCtorInitializer_getID(x, ctx)
end

# CXXConstructorDecl
"""
    isConvertingConstructor(x::AbstractCXXConstructorDecl, allow_explicit::Bool) -> Bool
Return whether the constructor is a converting constructor (C++ [class.conv.ctor]),
which can be used for user-defined conversions. `allow_explicit` decides whether an
`explicit` constructor still counts.
"""
function isConvertingConstructor(x::AbstractCXXConstructorDecl, allow_explicit::Bool)
    @check_ptrs x
    return clang_CXXConstructorDecl_isConvertingConstructor(x, allow_explicit)
end

function getCanonicalDecl(x::AbstractCXXConstructorDecl)
    @check_ptrs x
    return CXXConstructorDecl(clang_CXXConstructorDecl_getCanonicalDecl(x))
end

# CXXDestructorDecl
function getCanonicalDecl(x::AbstractCXXDestructorDecl)
    @check_ptrs x
    return CXXDestructorDecl(clang_CXXDestructorDecl_getCanonicalDecl(x))
end

# UsingEnumDecl
function getUsingLoc(x::AbstractUsingEnumDecl)
    @check_ptrs x
    return SourceLocation(clang_UsingEnumDecl_getUsingLoc(x))
end

function getEnumLoc(x::AbstractUsingEnumDecl)
    @check_ptrs x
    return SourceLocation(clang_UsingEnumDecl_getEnumLoc(x))
end

# NULL-pointer carrier when the enumeration is named without a nested-name-specifier.
function getQualifier(x::AbstractUsingEnumDecl)
    @check_ptrs x
    return NestedNameSpecifier(clang_UsingEnumDecl_getQualifier(x))
end

function getEnumType(x::AbstractUsingEnumDecl)
    @check_ptrs x
    return TypeSourceInfo(clang_UsingEnumDecl_getEnumType(x))
end

"""
    getEnumDecl(x::AbstractUsingEnumDecl) -> EnumDecl
Return the enumeration named by the using-enum-declaration.

`clang::UsingEnumDecl::getEnumDecl` casts the tag the written type designates to an
`EnumDecl` unchecked, so the declaration must still carry the enumeration type it was
built with — true for any using-enum-declaration Clang parsed or instantiated.
"""
function getEnumDecl(x::AbstractUsingEnumDecl)
    @check_ptrs x
    return EnumDecl(clang_UsingEnumDecl_getEnumDecl(x))
end

function getSourceRange(x::AbstractUsingEnumDecl)
    @check_ptrs x
    r = clang_UsingEnumDecl_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

function getCanonicalDecl(x::AbstractUsingEnumDecl)
    @check_ptrs x
    return UsingEnumDecl(clang_UsingEnumDecl_getCanonicalDecl(x))
end

# UsingPackDecl
# The `UnresolvedUsing{Value,Typename}Decl` pack expansion this pack came from.
function getInstantiatedFromUsingDecl(x::AbstractUsingPackDecl)
    @check_ptrs x
    return NamedDecl(clang_UsingPackDecl_getInstantiatedFromUsingDecl(x))
end

function getNumExpansions(x::AbstractUsingPackDecl)
    @check_ptrs x
    return Int(clang_UsingPackDecl_getNumExpansions(x))
end

function getExpansion(x::AbstractUsingPackDecl, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumExpansions(x) "expansion index $i out of range"
    return NamedDecl(clang_UsingPackDecl_getExpansion(x, i))
end

"""
    getExpansions(x::AbstractUsingPackDecl) -> Vector{NamedDecl}
Return the using-declarations the pack expanded into, in order. Some of them may
themselves still be unresolved.
"""
function getExpansions(x::AbstractUsingPackDecl)
    @check_ptrs x
    n = Int(clang_UsingPackDecl_getNumExpansions(x))
    return [getExpansion(x, i) for i = 0:(n - 1)]
end

"""
    getSourceRange(x::AbstractUsingPackDecl) -> SourceRange
Return the source range of the using-declaration this pack was instantiated from.

`clang::UsingPackDecl::getSourceRange` forwards through `getInstantiatedFromUsingDecl()`
without a null check, so that declaration must be present (Invariant 3).
"""
function getSourceRange(x::AbstractUsingPackDecl)
    @check_ptrs x
    @assert clang_UsingPackDecl_getInstantiatedFromUsingDecl(x) != C_NULL "no instantiated-from using-declaration"
    r = clang_UsingPackDecl_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

function getCanonicalDecl(x::AbstractUsingPackDecl)
    @check_ptrs x
    return UsingPackDecl(clang_UsingPackDecl_getCanonicalDecl(x))
end

# MSPropertyDecl
function hasGetter(x::AbstractMSPropertyDecl)
    @check_ptrs x
    return clang_MSPropertyDecl_hasGetter(x)
end

# NULL-pointer carrier unless `hasGetter(x)`.
function getGetterId(x::AbstractMSPropertyDecl)
    @check_ptrs x
    return IdentifierInfo(clang_MSPropertyDecl_getGetterId(x))
end

function hasSetter(x::AbstractMSPropertyDecl)
    @check_ptrs x
    return clang_MSPropertyDecl_hasSetter(x)
end

# NULL-pointer carrier unless `hasSetter(x)`.
function getSetterId(x::AbstractMSPropertyDecl)
    @check_ptrs x
    return IdentifierInfo(clang_MSPropertyDecl_getSetterId(x))
end

# --- DeclCXX-g sweep: the LifetimeExtendedTemporaryDecl surface, the inherited-constructor
# halves, and the CXXMethodDecl / NamespaceAlias / UnresolvedUsing tails ---

# CXXMethodDecl
"""
    isStaticOverloadedOperator(kind::CXOverloadedOperatorKind) -> Bool
Return whether an overloaded operator of `kind` is implicitly a static member when it is
declared in a class (`clang::CXXMethodDecl::isStaticOverloadedOperator`) — that is, whether
it is one of the allocation or deallocation operators.
"""
function isStaticOverloadedOperator(kind::CXOverloadedOperatorKind)
    return clang_CXXMethodDecl_isStaticOverloadedOperator(kind)
end

"""
    isUsualDeallocationFunction(x::AbstractCXXMethodDecl) -> Bool
Return whether `x` is a usual deallocation function ([basic.stc.dynamic.deallocation]p2).
The C shim runs `clang::CXXMethodDecl::isUsualDeallocationFunction` with a throw-away
buffer, so the declarations that prevented a `false` answer are not reported.
"""
function isUsualDeallocationFunction(x::AbstractCXXMethodDecl)
    @check_ptrs x
    return clang_CXXMethodDecl_isUsualDeallocationFunction(x)
end

# CXXConstructorDecl
# The two halves of the by-value `clang::InheritedConstructor`; both are NULL-pointer
# carriers unless `isInheritingConstructor(x)`.
function getInheritedConstructorShadowDecl(x::AbstractCXXConstructorDecl)
    @check_ptrs x
    return ConstructorUsingShadowDecl(clang_CXXConstructorDecl_getInheritedConstructorShadowDecl(x))
end

function getInheritedConstructorBaseCtor(x::AbstractCXXConstructorDecl)
    @check_ptrs x
    return CXXConstructorDecl(clang_CXXConstructorDecl_getInheritedConstructorBaseCtor(x))
end

# NamespaceAliasDecl
# NULL-pointer carrier when the aliased namespace is named without a qualifier.
function getQualifier(x::AbstractNamespaceAliasDecl)
    @check_ptrs x
    return NestedNameSpecifier(clang_NamespaceAliasDecl_getQualifier(x))
end

function getSourceRange(x::AbstractNamespaceAliasDecl)
    @check_ptrs x
    r = clang_NamespaceAliasDecl_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

# LifetimeExtendedTemporaryDecl
# The `VarDecl` (or, for a ctor-initializer, the `FieldDecl`) that extends the temporary.
function getExtendingDecl(x::AbstractLifetimeExtendedTemporaryDecl)
    @check_ptrs x
    return ValueDecl(clang_LifetimeExtendedTemporaryDecl_getExtendingDecl(x))
end

function getStorageDuration(x::AbstractLifetimeExtendedTemporaryDecl)
    @check_ptrs x
    return clang_LifetimeExtendedTemporaryDecl_getStorageDuration(x)
end

"""
    hasTemporaryExpr(x::AbstractLifetimeExtendedTemporaryDecl) -> Bool
Return whether the materialized-expression slot of `x` is filled in. This is the gate for
[`getTemporaryExpr`](@ref), which reaches that slot through an unchecked `cast<Expr>`; it
is false only for a declaration whose deserialization has not populated it yet.
"""
function hasTemporaryExpr(x::AbstractLifetimeExtendedTemporaryDecl)
    @check_ptrs x
    return clang_LifetimeExtendedTemporaryDecl_hasTemporaryExpr(x)
end

"""
    getTemporaryExpr(x::AbstractLifetimeExtendedTemporaryDecl) -> Expr_
Return the expression the temporary-materialization conversion was applied to.

`clang::LifetimeExtendedTemporaryDecl::getTemporaryExpr` is a `cast<Expr>` of the slot
[`hasTemporaryExpr`](@ref) reports, so that must hold (Invariant 3).
"""
function getTemporaryExpr(x::AbstractLifetimeExtendedTemporaryDecl)
    @check_ptrs x
    @assert hasTemporaryExpr(x) "the extended temporary has no materialized expression"
    return Expr_(clang_LifetimeExtendedTemporaryDecl_getTemporaryExpr(x))
end

"""
    getManglingNumber(x::AbstractLifetimeExtendedTemporaryDecl) -> UInt32
Return the mangling number of the extended temporary.

PRECONDITION, document-only (MARSHALLING.md §13): `clang::LifetimeExtendedTemporaryDecl`
leaves `ManglingNumber` without an initializer on its `EmptyShell` deserialization path,
where only the AST reader fills it in. Every declaration reachable from a parsed AST — via
[`getLifetimeExtendedTemporaryDecl`](@ref) or a decl traversal — carries it, and the class
exposes no flag for the shell state, so this wrapper documents rather than asserts.
"""
function getManglingNumber(x::AbstractLifetimeExtendedTemporaryDecl)
    @check_ptrs x
    return clang_LifetimeExtendedTemporaryDecl_getManglingNumber(x)
end

"""
    getOrCreateValue(x::AbstractLifetimeExtendedTemporaryDecl, may_create::Bool) -> APValue
Return the storage holding the temporary's constant value, creating it when `may_create` is
true. Clang asserts that the storage duration is static and that the result is non-NULL, so
a value must already be cached when `may_create` is false (Invariant 3). The `APValue` is
owned by `x` — borrowed, never `dispose` it.
"""
function getOrCreateValue(x::AbstractLifetimeExtendedTemporaryDecl, may_create::Bool)
    @check_ptrs x
    @assert getStorageDuration(x) == CXStorageDuration_SD_Static "only a static-duration temporary caches a value"
    @assert may_create || getValue(x).ptr != C_NULL "no constant value has been cached yet"
    return APValue(clang_LifetimeExtendedTemporaryDecl_getOrCreateValue(x, may_create))
end

# NULL-pointer carrier until the constant value has been cached; borrowed, never disposed.
function getValue(x::AbstractLifetimeExtendedTemporaryDecl)
    @check_ptrs x
    return APValue(clang_LifetimeExtendedTemporaryDecl_getValue(x))
end

# UnresolvedUsingValueDecl
function getSourceRange(x::AbstractUnresolvedUsingValueDecl)
    @check_ptrs x
    r = clang_UnresolvedUsingValueDecl_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

function getCanonicalDecl(x::AbstractUnresolvedUsingValueDecl)
    @check_ptrs x
    return UnresolvedUsingValueDecl(clang_UnresolvedUsingValueDecl_getCanonicalDecl(x))
end

# UnresolvedUsingTypenameDecl
function getCanonicalDecl(x::AbstractUnresolvedUsingTypenameDecl)
    @check_ptrs x
    return UnresolvedUsingTypenameDecl(clang_UnresolvedUsingTypenameDecl_getCanonicalDecl(x))
end

# --- Batch declcxx-i: value-type returns + the RequiresExprBodyDecl pivot ---

# CXXRecordDecl
"""
    getNumIndirectPrimaryBases(x::AbstractCXXRecordDecl) -> Integer
Return how many of `x`'s virtual base classes are the primary base of one of its own bases.
The walk lays out every base class, so `x` must carry a complete, non-dependent definition
(Invariant 3). It is 0 for a class with no virtual bases, on every ABI.
"""
function getNumIndirectPrimaryBases(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert hasDefinition(x) "the record must have a definition"
    @assert !is_dependent_context(castToDeclContext(x)) "the record must not be a dependent context"
    return clang_CXXRecordDecl_getNumIndirectPrimaryBases(x)
end

"""
    getIndirectPrimaryBases(x::AbstractCXXRecordDecl) -> Vector{CXXRecordDecl}
Collect the indirect primary base classes of `x`, under the same precondition as
`getNumIndirectPrimaryBases`. The order is the underlying set's iteration order and carries
no meaning; no entry is NULL.
"""
function getIndirectPrimaryBases(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert hasDefinition(x) "the record must have a definition"
    @assert !is_dependent_context(castToDeclContext(x)) "the record must not be a dependent context"
    n = clang_CXXRecordDecl_getNumIndirectPrimaryBases(x)
    buf = Vector{CXCXXRecordDecl}(undef, n)
    n > 0 && clang_CXXRecordDecl_getIndirectPrimaryBases(x, buf)
    return [CXXRecordDecl(p) for p in buf]
end

# RequiresExprBodyDecl Cast
function DeclContext(x::AbstractRequiresExprBodyDecl)
    @check_ptrs x
    return DeclContext(clang_RequiresExprBodyDecl_castToDeclContext(x))
end

function RequiresExprBodyDecl(x::DeclContext)
    @check_ptrs x
    return RequiresExprBodyDecl(clang_RequiresExprBodyDecl_castFromDeclContext(x))
end

# CXXCtorInitializer
"""
    getBaseClassLoc(x::CXXCtorInitializer) -> TypeLoc
Return the written base-class type of a base-class initializer together with its source
locations, and a NULL (`isNull`) `TypeLoc` for any other initializer. The result is an owned
heap box: call `dispose` on it after use.
"""
function getBaseClassLoc(x::CXXCtorInitializer)
    @check_ptrs x
    return TypeLoc(clang_CXXCtorInitializer_getBaseClassLoc(x))
end

# CXXConversionDecl
"""
    getCanonicalDecl(x::AbstractCXXConversionDecl) -> CXXConversionDecl
Return the canonical declaration of a conversion function. `CXXConversionDecl` redeclares
`getCanonicalDecl` with its own return type, so the result carries the derived class.
"""
function getCanonicalDecl(x::AbstractCXXConversionDecl)
    @check_ptrs x
    return CXXConversionDecl(clang_CXXConversionDecl_getCanonicalDecl(x))
end

# UsingDirectiveDecl
"""
    getQualifierRange(x::AbstractUsingDirectiveDecl) -> SourceRange
Return the extent of the nested-name-specifier that qualifies the nominated namespace.
`NestedNameSpecifierLoc` has no handle of its own, so it crosses as its two parts: the
qualifier through `getQualifier`, its written extent here. Invalid when unqualified.
"""
function getQualifierRange(x::AbstractUsingDirectiveDecl)
    @check_ptrs x
    r = clang_UsingDirectiveDecl_getQualifierRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

# NamespaceAliasDecl
"""
    getQualifierRange(x::AbstractNamespaceAliasDecl) -> SourceRange
Return the extent of the nested-name-specifier that qualifies the aliased namespace; the
companion of `getQualifier`, as above. Invalid when the namespace is named unqualified.
"""
function getQualifierRange(x::AbstractNamespaceAliasDecl)
    @check_ptrs x
    r = clang_NamespaceAliasDecl_getQualifierRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

# UsingDecl
"""
    getQualifierRange(x::AbstractUsingDecl) -> SourceRange
Return the extent of the nested-name-specifier that qualifies the named declaration; the
companion of `getQualifier`, as above.
"""
function getQualifierRange(x::AbstractUsingDecl)
    @check_ptrs x
    r = clang_UsingDecl_getQualifierRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

"""
    getNameInfo(x::AbstractUsingDecl) -> DeclarationNameInfo
Return the named declaration's name with its source locations. The result is an owned heap
box: call `dispose` on it after use.
"""
function getNameInfo(x::AbstractUsingDecl)
    @check_ptrs x
    return DeclarationNameInfo(clang_UsingDecl_getNameInfo(x))
end

# UsingEnumDecl
"""
    getEnumTypeLoc(x::AbstractUsingEnumDecl) -> TypeLoc
Return the `qualifier::Name` part of a using-enum-declaration as a `TypeLoc`. Clang reaches
through the written enumeration type without checking it, so `getEnumType(x)` must be
non-NULL (Invariant 3). The result is an owned heap box: call `dispose` on it after use.
"""
function getEnumTypeLoc(x::AbstractUsingEnumDecl)
    @check_ptrs x
    @assert getEnumType(x).ptr != C_NULL "the declaration must carry a written enumeration type"
    return TypeLoc(clang_UsingEnumDecl_getEnumTypeLoc(x))
end

# UnresolvedUsingValueDecl
"""
    getQualifierRange(x::AbstractUnresolvedUsingValueDecl) -> SourceRange
Return the extent of the nested-name-specifier that qualifies the name; the companion of
`getQualifier`, as above.
"""
function getQualifierRange(x::AbstractUnresolvedUsingValueDecl)
    @check_ptrs x
    r = clang_UnresolvedUsingValueDecl_getQualifierRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

"""
    getNameInfo(x::AbstractUnresolvedUsingValueDecl) -> DeclarationNameInfo
Return the named declaration's name with its source locations. The result is an owned heap
box: call `dispose` on it after use.
"""
function getNameInfo(x::AbstractUnresolvedUsingValueDecl)
    @check_ptrs x
    return DeclarationNameInfo(clang_UnresolvedUsingValueDecl_getNameInfo(x))
end

# UnresolvedUsingTypenameDecl
"""
    getQualifierRange(x::AbstractUnresolvedUsingTypenameDecl) -> SourceRange
Return the extent of the nested-name-specifier that qualifies the name; the companion of
`getQualifier`, as above.
"""
function getQualifierRange(x::AbstractUnresolvedUsingTypenameDecl)
    @check_ptrs x
    r = clang_UnresolvedUsingTypenameDecl_getQualifierRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

"""
    getNameInfo(x::AbstractUnresolvedUsingTypenameDecl) -> DeclarationNameInfo
Return the named type's name with its source location. The result is an owned heap box: call
`dispose` on it after use.
"""
function getNameInfo(x::AbstractUnresolvedUsingTypenameDecl)
    @check_ptrs x
    return DeclarationNameInfo(clang_UnresolvedUsingTypenameDecl_getNameInfo(x))
end

# --- DeclCXX-j sweep: the conversions declared directly in a class, plus the
# remaining Create / CreateDeserialized factories ---

# CXXRecordDecl
"""
    getNumConversions(x::AbstractCXXRecordDecl) -> Int
Return the number of conversion functions declared directly in this class, i.e. the extent of
`clang::CXXRecordDecl::conversion_begin`/`conversion_end`. Conversions inherited from bases are
not counted — `getNumVisibleConversionFunctions` is the wider query.

Both iterators read the class's definition data, so the class must have a definition
(Invariant 3).
"""
function getNumConversions(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert hasDefinition(x) "the record must have a complete definition"
    return Int(clang_CXXRecordDecl_getNumConversions(x))
end

"""
    getConversion(x::AbstractCXXRecordDecl, i::Integer) -> NamedDecl
Return the `i`-th (0-based) conversion function declared in this class. Entries are
`CXXConversionDecl`s or `FunctionTemplateDecl`s, so they are wrapped at their common `NamedDecl`
base. Requires a complete definition.
"""
function getConversion(x::AbstractCXXRecordDecl, i::Integer)
    @check_ptrs x
    @assert hasDefinition(x) "the record must have a complete definition"
    @assert 0 <= i < getNumConversions(x) "conversion index out of range"
    return NamedDecl(clang_CXXRecordDecl_getConversion(x, i))
end

"""
    getConversions(x::AbstractCXXRecordDecl) -> Vector{NamedDecl}
Return every conversion function declared directly in this class, in declaration order.
Requires a complete definition.
"""
function getConversions(x::AbstractCXXRecordDecl)
    @check_ptrs x
    n = getNumConversions(x)
    return [getConversion(x, i) for i = 0:(n - 1)]
end

function CXXRecordDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    return CXXRecordDecl(clang_CXXRecordDecl_CreateDeserialized(ctx, id))
end

# CXXDeductionGuideDecl
function CXXDeductionGuideDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    return CXXDeductionGuideDecl(clang_CXXDeductionGuideDecl_CreateDeserialized(ctx, id))
end

"""
    CXXConstructorDecl(ctx::ASTContext, id::Integer, alloc_kind::Integer=0) -> CXXConstructorDecl
Allocate a deserialization placeholder constructor. `alloc_kind` is the trailing-object bitmask
clang serialises alongside the declaration; `0` reserves neither the inherited-constructor nor
the explicit-specifier tail, which is what a freshly built placeholder wants.
"""
function CXXConstructorDecl(ctx::ASTContext, id::Integer, alloc_kind::Integer=0)
    @check_ptrs ctx
    cd = clang_CXXConstructorDecl_CreateDeserialized(ctx, id, alloc_kind)
    return CXXConstructorDecl(cd)
end

# CXXDestructorDecl
function CXXDestructorDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    return CXXDestructorDecl(clang_CXXDestructorDecl_CreateDeserialized(ctx, id))
end

# CXXConversionDecl
function CXXConversionDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    return CXXConversionDecl(clang_CXXConversionDecl_CreateDeserialized(ctx, id))
end

"""
    UsingShadowDecl(ctx::ASTContext, dc::AnyDeclContext, loc::SourceLocation, name::DeclarationName,
                    introducer::AbstractBaseUsingDecl, target::AbstractNamedDecl) -> UsingShadowDecl
Build the shadow declaration that makes `target` visible under `name` through `introducer`.

`clang::UsingShadowDecl`'s constructor asserts that the target is not itself a shadow
declaration, so that case is rejected here rather than reaching the shim (Invariant 3).
"""
function UsingShadowDecl(ctx::ASTContext, dc::AnyDeclContext, loc::SourceLocation, name::DeclarationName, introducer::AbstractBaseUsingDecl, target::AbstractNamedDecl)
    @check_ptrs ctx dc introducer target
    @assert !(target isa AbstractUsingShadowDecl) "the target may not be a shadow declaration"
    usd = clang_UsingShadowDecl_Create(ctx, dc, loc, name, introducer, target)
    return UsingShadowDecl(usd)
end

function UsingShadowDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    return UsingShadowDecl(clang_UsingShadowDecl_CreateDeserialized(ctx, id))
end

# UsingDecl
function UsingDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    return UsingDecl(clang_UsingDecl_CreateDeserialized(ctx, id))
end

"""
    ConstructorUsingShadowDecl(ctx::ASTContext, dc::AnyDeclContext, loc::SourceLocation,
                               using_decl::AbstractUsingDecl, target::AbstractNamedDecl,
                               is_virtual::Bool) -> ConstructorUsingShadowDecl
Build the shadow declaration an inheriting `using Base::Base;` introduces for `target`.

The clang constructor dereferences `using_decl` (for the shadow's name) and `target` (for its
underlying declaration) with no null check, so both are asserted non-NULL here (Invariant 3).
"""
function ConstructorUsingShadowDecl(ctx::ASTContext, dc::AnyDeclContext, loc::SourceLocation, using_decl::AbstractUsingDecl, target::AbstractNamedDecl, is_virtual::Bool)
    @check_ptrs ctx dc using_decl target
    cusd = clang_ConstructorUsingShadowDecl_Create(ctx, dc, loc, using_decl, target, is_virtual)
    return ConstructorUsingShadowDecl(cusd)
end

function ConstructorUsingShadowDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    return ConstructorUsingShadowDecl(clang_ConstructorUsingShadowDecl_CreateDeserialized(ctx, id))
end

"""
    UsingEnumDecl(ctx::ASTContext, dc::AnyDeclContext, using_loc::SourceLocation,
                  enum_loc::SourceLocation, name_loc::SourceLocation,
                  enum_type::TypeSourceInfo) -> UsingEnumDecl
Build a `using enum E;` declaration for the enumeration `enum_type` designates.

`clang::UsingEnumDecl::Create` reads the declaration's name straight out of `enum_type`, so it
must be non-NULL and must designate a tag type (Invariant 3).
"""
function UsingEnumDecl(ctx::ASTContext, dc::AnyDeclContext, using_loc::SourceLocation, enum_loc::SourceLocation, name_loc::SourceLocation, enum_type::TypeSourceInfo)
    @check_ptrs ctx dc enum_type
    ued = clang_UsingEnumDecl_Create(ctx, dc, using_loc, enum_loc, name_loc, enum_type)
    return UsingEnumDecl(ued)
end

function UsingEnumDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    return UsingEnumDecl(clang_UsingEnumDecl_CreateDeserialized(ctx, id))
end

"""
    UsingPackDecl(ctx::ASTContext, dc::AnyDeclContext, instantiated_from::AbstractNamedDecl,
                  using_decls::AbstractVector{<:AbstractNamedDecl}) -> UsingPackDecl
Build the declaration a pack-expanded `using Ts::f...;` instantiates to. `using_decls` crosses
as a (buffer, count) pair and clang copies it into the declaration's trailing-object array.

`instantiated_from` is asserted non-NULL because `getSourceRange` forwards through it.
"""
function UsingPackDecl(ctx::ASTContext, dc::AnyDeclContext, instantiated_from::AbstractNamedDecl, using_decls::AbstractVector{<:AbstractNamedDecl})
    @check_ptrs ctx dc instantiated_from
    buf = CXNamedDecl[Base.unsafe_convert(CXNamedDecl, d) for d in using_decls]
    upd = clang_UsingPackDecl_Create(ctx, dc, instantiated_from, buf, length(buf))
    return UsingPackDecl(upd)
end

function UsingPackDecl(ctx::ASTContext, id::Integer, num_expansions::Integer)
    @check_ptrs ctx
    return UsingPackDecl(clang_UsingPackDecl_CreateDeserialized(ctx, id, num_expansions))
end

# BindingDecl
function BindingDecl(ctx::ASTContext, dc::AnyDeclContext, id_loc::SourceLocation, id::IdentifierInfo)
    @check_ptrs ctx dc id
    return BindingDecl(clang_BindingDecl_Create(ctx, dc, id_loc, id))
end

function BindingDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    return BindingDecl(clang_BindingDecl_CreateDeserialized(ctx, id))
end

"""
    MSPropertyDecl(ctx::ASTContext, dc::AnyDeclContext, loc::SourceLocation, name::DeclarationName,
                   ty::QualType, tinfo::TypeSourceInfo, start_loc::SourceLocation,
                   getter::IdentifierInfo, setter::IdentifierInfo) -> MSPropertyDecl
Build a `__declspec(property(...))` data member. `getter` and `setter` are the accessor names
and may each wrap `C_NULL` — that is how a write-only or read-only property is spelled, and it
is what `hasGetter`/`hasSetter` report on.
"""
function MSPropertyDecl(ctx::ASTContext, dc::AnyDeclContext, loc::SourceLocation, name::DeclarationName, ty::QualType, tinfo::TypeSourceInfo, start_loc::SourceLocation, getter::IdentifierInfo, setter::IdentifierInfo)
    @check_ptrs ctx dc tinfo
    mpd = clang_MSPropertyDecl_Create(ctx, dc, loc, name, ty, tinfo, start_loc, getter, setter)
    return MSPropertyDecl(mpd)
end

function MSPropertyDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    return MSPropertyDecl(clang_MSPropertyDecl_CreateDeserialized(ctx, id))
end

"""
    setInitMethod(x::AbstractCXXRecordDecl, val::Bool)
Set the definition-data flag `hasInitMethod` reports on.

PARTIAL: the flag lives in the class's definition data, whose accessor asserts a complete
definition, so `hasDefinition(x)` must hold.
"""
function setInitMethod(x::AbstractCXXRecordDecl, val::Bool)
    @check_ptrs x
    @assert hasDefinition(x) "the class must have a definition"
    return clang_CXXRecordDecl_setInitMethod(x, val)
end

"""
    setInheritingConstructor(x::AbstractCXXConstructorDecl, is_ic::Bool)
Set the flag `isInheritingConstructor` reports on.

Only the bit is written: the inherited-constructor trailing object is allocated when the
declaration is created, so setting this `true` on a constructor built without it leaves
`getInheritedConstructorBaseCtor`/`getInheritedConstructorShadowDecl` reading unallocated
storage. Nothing in the C API exposes whether the tail was allocated, so use this to clear
the flag, or to restore it on a declaration that already carries the trailing object.
"""
function setInheritingConstructor(x::AbstractCXXConstructorDecl, is_ic::Bool)
    @check_ptrs x
    return clang_CXXConstructorDecl_setInheritingConstructor(x, is_ic)
end

function setDeductionCandidateKind(x::AbstractCXXDeductionGuideDecl, k::CXDeductionCandidate)
    @check_ptrs x
    return clang_CXXDeductionGuideDecl_setDeductionCandidateKind(x, k)
end

"""
    setTargetDecl(x::AbstractUsingShadowDecl, nd::AbstractNamedDecl)
Set the declaration the shadow brings into the local scope.

PARTIAL: clang asserts the target is non-NULL (`@check_ptrs` covers that) and rebuilds the
shadow's identifier namespace from the target's, so `nd` must be the declaration this
shadow really names.
"""
function setTargetDecl(x::AbstractUsingShadowDecl, nd::AbstractNamedDecl)
    @check_ptrs x nd
    return clang_UsingShadowDecl_setTargetDecl(x, nd)
end

"""
    setSourceOrder(x::CXXCtorInitializer, pos::Integer)
Record the initializer as written in the source at position `pos`, counting from 0.

PARTIAL: clang asserts the initializer is still implicit and that `pos` is non-negative.
The call is one-way — it makes `isWritten` true, which is also what makes a second call
illegal, so the `isWritten` assertion below covers both preconditions.
"""
function setSourceOrder(x::CXXCtorInitializer, pos::Integer)
    @check_ptrs x
    @assert !isWritten(x) "the initializer must still be implicit"
    @assert pos >= 0 "the source order must be non-negative"
    return clang_CXXCtorInitializer_setSourceOrder(x, pos)
end

"""
    setExplicitSpecifier(x::AbstractCXXConstructorDecl, es::ExplicitSpecifier)
Overwrite the constructor's explicit-specifier. `es` is read, not adopted: dispose it as
usual.

PARTIAL: a specifier carrying an expression needs trailing storage clang allocates only at
`Create` time, and no accessor exposes whether it was allocated, so only an
expression-less specifier is accepted here.
"""
function setExplicitSpecifier(x::AbstractCXXConstructorDecl, es::ExplicitSpecifier)
    @check_ptrs x es
    @assert getExpr(es).ptr == C_NULL "the specifier must not carry an expression"
    return clang_CXXConstructorDecl_setExplicitSpecifier(x, es)
end

"""
    setExplicitSpecifier(x::AbstractCXXConversionDecl, es::ExplicitSpecifier)
Overwrite the conversion function's explicit-specifier. `es` is read, not adopted: the
declaration stores its own copy, so dispose `es` as usual.
"""
function setExplicitSpecifier(x::AbstractCXXConversionDecl, es::ExplicitSpecifier)
    @check_ptrs x es
    return clang_CXXConversionDecl_setExplicitSpecifier(x, es)
end

function setUsingLoc(x::AbstractUsingDecl, loc::SourceLocation)
    @check_ptrs x
    return clang_UsingDecl_setUsingLoc(x, loc)
end

function setTypename(x::AbstractUsingDecl, tn::Bool)
    @check_ptrs x
    return clang_UsingDecl_setTypename(x, tn)
end

function setUsingLoc(x::AbstractUnresolvedUsingValueDecl, loc::SourceLocation)
    @check_ptrs x
    return clang_UnresolvedUsingValueDecl_setUsingLoc(x, loc)
end

function setUsingLoc(x::AbstractUsingEnumDecl, loc::SourceLocation)
    @check_ptrs x
    return clang_UsingEnumDecl_setUsingLoc(x, loc)
end

function setEnumLoc(x::AbstractUsingEnumDecl, loc::SourceLocation)
    @check_ptrs x
    return clang_UsingEnumDecl_setEnumLoc(x, loc)
end

function setEnumType(x::AbstractUsingEnumDecl, tsi::TypeSourceInfo)
    @check_ptrs x tsi
    return clang_UsingEnumDecl_setEnumType(x, tsi)
end

"""
    getQualifierRange(x::AbstractUsingEnumDecl) -> SourceRange
Return the extent of the nested-name-specifier that qualifies the named enumeration; the
companion of `getQualifier`, as above. Invalid when the enumeration is named unqualified.

PARTIAL: the qualifier is read out of the written enumeration type, so `getEnumType(x)`
must be non-NULL.
"""
function getQualifierRange(x::AbstractUsingEnumDecl)
    @check_ptrs x
    @assert getEnumType(x).ptr != C_NULL "the declaration must carry its written enum type"
    r = clang_UsingEnumDecl_getQualifierRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

function UsingDirectiveDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    return UsingDirectiveDecl(clang_UsingDirectiveDecl_CreateDeserialized(ctx, id))
end

function NamespaceAliasDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    return NamespaceAliasDecl(clang_NamespaceAliasDecl_CreateDeserialized(ctx, id))
end

function LifetimeExtendedTemporaryDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    letd = clang_LifetimeExtendedTemporaryDecl_CreateDeserialized(ctx, id)
    return LifetimeExtendedTemporaryDecl(letd)
end

function UnresolvedUsingValueDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    return UnresolvedUsingValueDecl(clang_UnresolvedUsingValueDecl_CreateDeserialized(ctx, id))
end

function UnresolvedUsingTypenameDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    uutd = clang_UnresolvedUsingTypenameDecl_CreateDeserialized(ctx, id)
    return UnresolvedUsingTypenameDecl(uutd)
end

function DecompositionDecl(ctx::ASTContext, id::Integer, num_bindings::Integer)
    @check_ptrs ctx
    return DecompositionDecl(clang_DecompositionDecl_CreateDeserialized(ctx, id, num_bindings))
end

# --- DeclCXX-l sweep: CXXRecordDecl setters, the CXXMethodDecl-family factories and the
# MSGuidDecl accessors ---

"""
    setIsParsingBaseSpecifiers(x::AbstractCXXRecordDecl)
Mark `x` as being in the middle of parsing its base-specifier list
(`clang::CXXRecordDecl::setIsParsingBaseSpecifiers`), the setter behind
`isParsingBaseSpecifiers`. The flag only ever goes from `false` to `true`; the class
exposes no way to clear it.

PARTIAL: the flag lives in the record's definition data, so `hasDefinition(x)` must hold.
"""
function setIsParsingBaseSpecifiers(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert hasDefinition(x) "the record must have a definition"
    return clang_CXXRecordDecl_setIsParsingBaseSpecifiers(x)
end

"""
    setDescribedClassTemplate(x::AbstractCXXRecordDecl, tmpl::AbstractClassTemplateDecl)
Record that `x` is the pattern of `tmpl` (`clang::CXXRecordDecl::setDescribedClassTemplate`),
the setter behind `getDescribedClassTemplate`. The template is stored, not adopted; pass a
carrier wrapping `C_NULL` to clear the association.
"""
function setDescribedClassTemplate(x::AbstractCXXRecordDecl, tmpl::AbstractClassTemplateDecl)
    @check_ptrs x
    return clang_CXXRecordDecl_setDescribedClassTemplate(x, tmpl)
end

"""
    CXXDeductionGuideDecl(ctx::ASTContext, dc::AnyDeclContext, start_loc::SourceLocation,
                          es::ExplicitSpecifier, name_info::DeclarationNameInfo,
                          ty::QualType, tinfo::TypeSourceInfo, end_loc::SourceLocation,
                          ctor::AbstractCXXConstructorDecl, kind::CXDeductionCandidate)
Build a deduction guide (`clang::CXXDeductionGuideDecl::Create`). `es` is read, not
adopted - the guide keeps its own copy - and must be non-NULL. `ctor` is the constructor an
implicit guide was generated from and may wrap `C_NULL`.
"""
function CXXDeductionGuideDecl(ctx::ASTContext, dc::AnyDeclContext, start_loc::SourceLocation, es::ExplicitSpecifier, name_info::DeclarationNameInfo, ty::QualType, tinfo::TypeSourceInfo, end_loc::SourceLocation, ctor::AbstractCXXConstructorDecl=CXXConstructorDecl(C_NULL), kind::CXDeductionCandidate=CXDeductionCandidate_Normal)
    @check_ptrs ctx dc es name_info tinfo
    dgd = clang_CXXDeductionGuideDecl_Create(ctx, dc, start_loc, es, name_info, ty, tinfo, end_loc, ctor, kind)
    return CXXDeductionGuideDecl(dgd)
end

"""
    CXXConstructorDecl(ctx::ASTContext, rd::AbstractCXXRecordDecl, start_loc::SourceLocation,
                       name_info::DeclarationNameInfo, ty::QualType, tinfo::TypeSourceInfo,
                       es::ExplicitSpecifier, uses_fp_intrin::Bool, is_inline::Bool,
                       is_implicitly_declared::Bool, constexpr_kind::CXConstexprSpecKind,
                       inherited_shadow, inherited_base_ctor, trailing_requires_clause)
Build a constructor (`clang::CXXConstructorDecl::Create`). `es` is read, not adopted, and
must be non-NULL. `inherited_shadow`/`inherited_base_ctor` are the two halves of the
by-value `clang::InheritedConstructor`; leaving both NULL builds an ordinary,
non-inheriting constructor.

PARTIAL: clang asserts `name_info` names a constructor, which this wrapper restates.
"""
function CXXConstructorDecl(ctx::ASTContext, rd::AbstractCXXRecordDecl, start_loc::SourceLocation, name_info::DeclarationNameInfo, ty::QualType, tinfo::TypeSourceInfo, es::ExplicitSpecifier, uses_fp_intrin::Bool, is_inline::Bool, is_implicitly_declared::Bool, constexpr_kind::CXConstexprSpecKind, inherited_shadow::AbstractConstructorUsingShadowDecl=ConstructorUsingShadowDecl(C_NULL), inherited_base_ctor::AbstractCXXConstructorDecl=CXXConstructorDecl(C_NULL), trailing_requires_clause::AbstractExpr=Expr_(C_NULL))
    @check_ptrs ctx rd name_info tinfo es
    named_ok = getNameKind(getName(name_info)) == CXDeclarationName_CXXConstructorName
    @assert named_ok "name_info must name a constructor"
    cd = clang_CXXConstructorDecl_Create(ctx, rd, start_loc, name_info, ty, tinfo, es, uses_fp_intrin, is_inline, is_implicitly_declared, constexpr_kind, inherited_shadow, inherited_base_ctor, trailing_requires_clause)
    return CXXConstructorDecl(cd)
end

"""
    CXXDestructorDecl(ctx::ASTContext, rd::AbstractCXXRecordDecl, start_loc::SourceLocation,
                      name_info::DeclarationNameInfo, ty::QualType, tinfo::TypeSourceInfo,
                      uses_fp_intrin::Bool, is_inline::Bool, is_implicitly_declared::Bool,
                      constexpr_kind::CXConstexprSpecKind, trailing_requires_clause)
Build a destructor (`clang::CXXDestructorDecl::Create`).

PARTIAL: clang asserts `name_info` names a destructor, which this wrapper restates.
"""
function CXXDestructorDecl(ctx::ASTContext, rd::AbstractCXXRecordDecl, start_loc::SourceLocation, name_info::DeclarationNameInfo, ty::QualType, tinfo::TypeSourceInfo, uses_fp_intrin::Bool, is_inline::Bool, is_implicitly_declared::Bool, constexpr_kind::CXConstexprSpecKind, trailing_requires_clause::AbstractExpr=Expr_(C_NULL))
    @check_ptrs ctx rd name_info tinfo
    named_ok = getNameKind(getName(name_info)) == CXDeclarationName_CXXDestructorName
    @assert named_ok "name_info must name a destructor"
    dd = clang_CXXDestructorDecl_Create(ctx, rd, start_loc, name_info, ty, tinfo, uses_fp_intrin, is_inline, is_implicitly_declared, constexpr_kind, trailing_requires_clause)
    return CXXDestructorDecl(dd)
end

"""
    CXXConversionDecl(ctx::ASTContext, rd::AbstractCXXRecordDecl, start_loc::SourceLocation,
                      name_info::DeclarationNameInfo, ty::QualType, tinfo::TypeSourceInfo,
                      uses_fp_intrin::Bool, is_inline::Bool, es::ExplicitSpecifier,
                      constexpr_kind::CXConstexprSpecKind, end_loc::SourceLocation,
                      trailing_requires_clause)
Build a conversion function (`clang::CXXConversionDecl::Create`). `es` is read, not adopted
- the conversion function stores its own copy - and must be non-NULL.

PARTIAL: clang asserts `name_info` names a conversion function, which this wrapper
restates.
"""
function CXXConversionDecl(ctx::ASTContext, rd::AbstractCXXRecordDecl, start_loc::SourceLocation, name_info::DeclarationNameInfo, ty::QualType, tinfo::TypeSourceInfo, uses_fp_intrin::Bool, is_inline::Bool, es::ExplicitSpecifier, constexpr_kind::CXConstexprSpecKind, end_loc::SourceLocation, trailing_requires_clause::AbstractExpr=Expr_(C_NULL))
    @check_ptrs ctx rd name_info tinfo es
    kind = getNameKind(getName(name_info))
    @assert kind == CXDeclarationName_CXXConversionFunctionName "name_info must name a conversion function"
    cvd = clang_CXXConversionDecl_Create(ctx, rd, start_loc, name_info, ty, tinfo, uses_fp_intrin, is_inline, es, constexpr_kind, end_loc, trailing_requires_clause)
    return CXXConversionDecl(cvd)
end

"""
    LifetimeExtendedTemporaryDecl(temp::AbstractExpr, extending::AbstractValueDecl,
                                  mangling::Integer) -> LifetimeExtendedTemporaryDecl
Build the declaration that records a lifetime-extended temporary
(`clang::LifetimeExtendedTemporaryDecl::Create`). The node is allocated in `extending`'s
ASTContext and declaration context.

PARTIAL: clang dereferences `extending` for its context and `temp` for its expression
location, so both are asserted non-NULL.
"""
function LifetimeExtendedTemporaryDecl(temp::AbstractExpr, extending::AbstractValueDecl, mangling::Integer)
    @check_ptrs temp extending
    letd = clang_LifetimeExtendedTemporaryDecl_Create(temp, extending, mangling)
    return LifetimeExtendedTemporaryDecl(letd)
end

"""
    DecompositionDecl(ctx::ASTContext, dc::AnyDeclContext, start_loc::SourceLocation,
                      lsquare_loc::SourceLocation, ty::QualType, tinfo::TypeSourceInfo,
                      sc::CXStorageClass,
                      bindings::AbstractVector{<:AbstractBindingDecl}) -> DecompositionDecl
Build the variable behind a structured binding (`clang::DecompositionDecl::Create`).
`bindings` crosses as a (buffer, count) pair and clang copies it into the declaration's
trailing-object array.
"""
function DecompositionDecl(ctx::ASTContext, dc::AnyDeclContext, start_loc::SourceLocation, lsquare_loc::SourceLocation, ty::QualType, tinfo::TypeSourceInfo, sc::CXStorageClass, bindings::AbstractVector{<:AbstractBindingDecl})
    @check_ptrs ctx dc tinfo
    buf = CXBindingDecl[Base.unsafe_convert(CXBindingDecl, b) for b in bindings]
    dd = clang_DecompositionDecl_Create(ctx, dc, start_loc, lsquare_loc, ty, tinfo, sc, buf, length(buf))
    return DecompositionDecl(dd)
end

# MSGuidDecl
"""
    getPart1(x::AbstractMSGuidDecl) -> UInt32
Return the first field of the decomposed UUID (`clang::MSGuidDecl::getParts().Part1`) - the
`{01234567-` group.
"""
function getPart1(x::AbstractMSGuidDecl)
    @check_ptrs x
    return clang_MSGuidDecl_getPart1(x)
end

"""
    getPart2(x::AbstractMSGuidDecl) -> UInt16
Return the second field of the decomposed UUID (`clang::MSGuidDecl::getParts().Part2`) -
the `-89ab-` group.
"""
function getPart2(x::AbstractMSGuidDecl)
    @check_ptrs x
    return clang_MSGuidDecl_getPart2(x)
end

"""
    getPart3(x::AbstractMSGuidDecl) -> UInt16
Return the third field of the decomposed UUID (`clang::MSGuidDecl::getParts().Part3`) - the
`-cdef-` group.
"""
function getPart3(x::AbstractMSGuidDecl)
    @check_ptrs x
    return clang_MSGuidDecl_getPart3(x)
end

"""
    getPart4And5AsUint64(x::AbstractMSGuidDecl) -> UInt64
Return the last eight UUID bytes packed into one integer
(`clang::MSGuidDeclParts::getPart4And5AsUint64`). The packing is a `memcpy`, so the value is
byte-order dependent - compare it against another value read the same way, not a literal.
"""
function getPart4And5AsUint64(x::AbstractMSGuidDecl)
    @check_ptrs x
    return clang_MSGuidDecl_getPart4And5AsUint64(x)
end

"""
    getAsAPValue(x::AbstractMSGuidDecl) -> APValue
Return the UUID as an `APValue` (`clang::MSGuidDecl::getAsAPValue`), computed on demand and
cached inside the declaration. The value is borrowed - never `dispose` it. The result is an
absent `APValue` when the declaration's type is not of the expected `_GUID` shape.
"""
function getAsAPValue(x::AbstractMSGuidDecl)
    @check_ptrs x
    return APValue(clang_MSGuidDecl_getAsAPValue(x))
end

# --- Definition-data, lambda-numbering and shadow-list mutators ---

"""
    setImplicitCopyConstructorIsDeleted(x::AbstractCXXRecordDecl)
Record that overload resolution deleted the implicitly-declared copy constructor
(`clang::CXXRecordDecl::setImplicitCopyConstructorIsDeleted`), the setter behind
`defaultedCopyConstructorIsDeleted`.

PARTIAL: the flag lives in the class's definition data, so `hasDefinition(x)` must hold, and
clang asserts the class either already carries the flag or still needs overload resolution
for its copy constructor. Only the second half is observable, so that is what is asserted
here. Note that `defaultedCopyConstructorIsDeleted` itself only becomes readable once Sema
has declared the special member.
"""
function setImplicitCopyConstructorIsDeleted(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert hasDefinition(x) "the class must have a definition"
    @assert needsOverloadResolutionForCopyConstructor(x) "copy construction still needs overload resolution"
    return clang_CXXRecordDecl_setImplicitCopyConstructorIsDeleted(x)
end

"""
    setImplicitMoveConstructorIsDeleted(x::AbstractCXXRecordDecl)
Record that overload resolution deleted the implicitly-declared move constructor
(`clang::CXXRecordDecl::setImplicitMoveConstructorIsDeleted`).

PARTIAL: `hasDefinition(x)` must hold, and clang asserts the class either already carries
the flag or still needs overload resolution for its move constructor; only the second half
is observable.
"""
function setImplicitMoveConstructorIsDeleted(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert hasDefinition(x) "the class must have a definition"
    @assert needsOverloadResolutionForMoveConstructor(x) "move construction still needs overload resolution"
    return clang_CXXRecordDecl_setImplicitMoveConstructorIsDeleted(x)
end

"""
    setImplicitDestructorIsDeleted(x::AbstractCXXRecordDecl)
Record that overload resolution deleted the implicitly-declared destructor
(`clang::CXXRecordDecl::setImplicitDestructorIsDeleted`).

PARTIAL: `hasDefinition(x)` must hold, and clang asserts the class either already carries
the flag or still needs overload resolution for its destructor; only the second half is
observable.
"""
function setImplicitDestructorIsDeleted(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert hasDefinition(x) "the class must have a definition"
    @assert needsOverloadResolutionForDestructor(x) "destruction still needs overload resolution"
    return clang_CXXRecordDecl_setImplicitDestructorIsDeleted(x)
end

"""
    setImplicitCopyAssignmentIsDeleted(x::AbstractCXXRecordDecl)
Record that overload resolution deleted the implicitly-declared copy assignment operator
(`clang::CXXRecordDecl::setImplicitCopyAssignmentIsDeleted`).

PARTIAL: `hasDefinition(x)` must hold, and clang asserts the class either already carries
the flag or still needs overload resolution for its copy assignment; only the second half is
observable.
"""
function setImplicitCopyAssignmentIsDeleted(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert hasDefinition(x) "the class must have a definition"
    @assert needsOverloadResolutionForCopyAssignment(x) "copy assignment still needs overload resolution"
    return clang_CXXRecordDecl_setImplicitCopyAssignmentIsDeleted(x)
end

"""
    setImplicitMoveAssignmentIsDeleted(x::AbstractCXXRecordDecl)
Record that overload resolution deleted the implicitly-declared move assignment operator
(`clang::CXXRecordDecl::setImplicitMoveAssignmentIsDeleted`).

PARTIAL: `hasDefinition(x)` must hold, and clang asserts the class either already carries
the flag or still needs overload resolution for its move assignment; only the second half is
observable.
"""
function setImplicitMoveAssignmentIsDeleted(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert hasDefinition(x) "the class must have a definition"
    @assert needsOverloadResolutionForMoveAssignment(x) "move assignment still needs overload resolution"
    return clang_CXXRecordDecl_setImplicitMoveAssignmentIsDeleted(x)
end

"""
    removeConversion(x::AbstractCXXRecordDecl, old::AbstractNamedDecl)
Drop `old` from the conversion functions declared directly in this class
(`clang::CXXRecordDecl::removeConversion`).

PARTIAL: clang walks the conversion set and `llvm_unreachable`s when `old` is not in it, so
the wrapper restates that as an assertion over `getConversions(x)`; the class must also have
a definition.
"""
function removeConversion(x::AbstractCXXRecordDecl, old::AbstractNamedDecl)
    @check_ptrs x old
    @assert hasDefinition(x) "the class must have a definition"
    @assert any(c -> c.ptr == old.ptr, getConversions(x)) "old must be a conversion of this class"
    return clang_CXXRecordDecl_removeConversion(x, old)
end

"""
    markEmpty(x::AbstractCXXRecordDecl)
Mark the class as empty (`clang::CXXRecordDecl::markEmpty`), the setter behind `isEmpty`.
The flag only ever goes from `false` to `true`; the class exposes no way to clear it.

PARTIAL: the flag lives in the class's definition data, so `hasDefinition(x)` must hold.
"""
function markEmpty(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert hasDefinition(x) "the class must have a definition"
    return clang_CXXRecordDecl_markEmpty(x)
end

"""
    setHasTrivialSpecialMemberForCall(x::AbstractCXXRecordDecl)
Mark the copy constructor, the move constructor and the destructor as trivial for the
purpose of passing the class by value (`clang::CXXRecordDecl::setHasTrivialSpecialMemberForCall`).
All three flags are set at once, as clang's own setter does.

PARTIAL: the flags live in the class's definition data, so `hasDefinition(x)` must hold.
"""
function setHasTrivialSpecialMemberForCall(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert hasDefinition(x) "the class must have a definition"
    return clang_CXXRecordDecl_setHasTrivialSpecialMemberForCall(x)
end

"""
    finishedDefaultedOrDeletedMember(x::AbstractCXXRecordDecl, md::AbstractCXXMethodDecl)
Tell the class that the explicitly defaulted or deleted special member `md` is now complete,
so its definition data can be updated (`clang::CXXRecordDecl::finishedDefaultedOrDeletedMember`).

PARTIAL: clang asserts `md` is neither implicit nor user-provided, and the flags live in the
class's definition data, so `hasDefinition(x)` must hold.
"""
function finishedDefaultedOrDeletedMember(x::AbstractCXXRecordDecl, md::AbstractCXXMethodDecl)
    @check_ptrs x md
    @assert hasDefinition(x) "the class must have a definition"
    @assert !isImplicit(md) && !isUserProvided(md) "the member must be defaulted or deleted"
    return clang_CXXRecordDecl_finishedDefaultedOrDeletedMember(x, md)
end

"""
    setTrivialForCallFlags(x::AbstractCXXRecordDecl, md::AbstractCXXMethodDecl)
Fold `md`'s trivial-for-call bit into the class's flags
(`clang::CXXRecordDecl::setTrivialForCallFlags`). Only a copy constructor, a move
constructor or a destructor contributes; any other method leaves the flags unchanged.

PARTIAL: the flags live in the class's definition data, so `hasDefinition(x)` must hold.
"""
function setTrivialForCallFlags(x::AbstractCXXRecordDecl, md::AbstractCXXMethodDecl)
    @check_ptrs x md
    @assert hasDefinition(x) "the class must have a definition"
    return clang_CXXRecordDecl_setTrivialForCallFlags(x, md)
end

"""
    setLambdaNumbering(x::AbstractCXXRecordDecl, context_decl::AbstractDecl,
                       index_in_context::Integer, mangling_number::Integer,
                       device_mangling_number::Integer, has_known_internal_linkage::Bool)
Set the mangling numbers and context declaration of a closure type
(`clang::CXXRecordDecl::setLambdaNumbering`). The by-value `LambdaNumbering` aggregate is
passed as its five fields, read back by `getLambdaContextDecl`, `getLambdaIndexInContext`,
`getLambdaManglingNumber`, `getDeviceLambdaManglingNumber` and
`hasKnownLambdaInternalLinkage`. `context_decl` may wrap `C_NULL`, and
`device_mangling_number` is only recorded when it is non-zero.

PARTIAL: clang asserts the class is a lambda closure type.
"""
function setLambdaNumbering(x::AbstractCXXRecordDecl, context_decl::AbstractDecl, index_in_context::Integer, mangling_number::Integer, device_mangling_number::Integer, has_known_internal_linkage::Bool)
    @check_ptrs x
    @assert isLambda(x) "the class must be a lambda closure type"
    return clang_CXXRecordDecl_setLambdaNumbering(x, context_decl, index_in_context, mangling_number, device_mangling_number, has_known_internal_linkage)
end

"""
    setLambdaIsGeneric(x::AbstractCXXRecordDecl, is_generic::Bool)
Set whether the closure type's call operator is a template
(`clang::CXXRecordDecl::setLambdaIsGeneric`), the setter behind `isGenericLambda`.

PARTIAL: clang asserts the class is a lambda closure type.
"""
function setLambdaIsGeneric(x::AbstractCXXRecordDecl, is_generic::Bool)
    @check_ptrs x
    @assert isLambda(x) "the class must be a lambda closure type"
    return clang_CXXRecordDecl_setLambdaIsGeneric(x, is_generic)
end

"""
    markAbstract(x::AbstractCXXRecordDecl)
Mark the class as abstract (`clang::CXXRecordDecl::markAbstract`), the setter behind
`isAbstract`. The flag only ever goes from `false` to `true`; the class exposes no way to
clear it.

PARTIAL: the flag lives in the class's definition data, so `hasDefinition(x)` must hold.
"""
function markAbstract(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert hasDefinition(x) "the class must have a definition"
    return clang_CXXRecordDecl_markAbstract(x)
end

"""
    setOperatorDelete(x::AbstractCXXDestructorDecl, od::AbstractFunctionDecl,
                      this_arg::AbstractExpr=Expr_(C_NULL))
Record the deallocation function this destructor is paired with
(`clang::CXXDestructorDecl::setOperatorDelete`), read back by `getOperatorDelete` and
`getOperatorDeleteThisArg`. `this_arg` may wrap `C_NULL`.

Total: clang stores the pair on the first declaration and keeps whatever is already there,
so the call does nothing when an operator delete has already been recorded.
"""
function setOperatorDelete(x::AbstractCXXDestructorDecl, od::AbstractFunctionDecl, this_arg::AbstractExpr=Expr_(C_NULL))
    @check_ptrs x od
    return clang_CXXDestructorDecl_setOperatorDelete(x, od, this_arg)
end

"""
    addShadowDecl(x::AbstractBaseUsingDecl, s::AbstractUsingShadowDecl)
Put `s` back at the front of the shadow declarations of this using-declaration
(`clang::BaseUsingDecl::addShadowDecl`).

PARTIAL: clang asserts `s` was introduced by `x` and is not already in the list, so both are
restated here against `getIntroducer` and `getShadows`.
"""
function addShadowDecl(x::AbstractBaseUsingDecl, s::AbstractUsingShadowDecl)
    @check_ptrs x s
    @assert getIntroducer(s).ptr == x.ptr "the shadow must be introduced by this declaration"
    @assert !any(sh -> sh.ptr == s.ptr, getShadows(x)) "the shadow is already in the list"
    return clang_BaseUsingDecl_addShadowDecl(x, s)
end

"""
    removeShadowDecl(x::AbstractBaseUsingDecl, s::AbstractUsingShadowDecl)
Drop `s` from the shadow declarations of this using-declaration
(`clang::BaseUsingDecl::removeShadowDecl`). The shadow keeps its introducer, so it can be
put back with `addShadowDecl`.

PARTIAL: clang asserts `s` was introduced by `x` and is currently in the list, so both are
restated here against `getIntroducer` and `getShadows`.
"""
function removeShadowDecl(x::AbstractBaseUsingDecl, s::AbstractUsingShadowDecl)
    @check_ptrs x s
    @assert getIntroducer(s).ptr == x.ptr "the shadow must be introduced by this declaration"
    @assert any(sh -> sh.ptr == s.ptr, getShadows(x)) "the shadow is not in the list"
    return clang_BaseUsingDecl_removeShadowDecl(x, s)
end

"""
    getNumFriends(x::AbstractCXXRecordDecl) -> Int
Return the number of friend declarations in the class (`clang::CXXRecordDecl::friends`).

PARTIAL: the range reaches the record's definition data, so a definition is required.
"""
function getNumFriends(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert hasDefinition(x) "the class must have a definition"
    return Int(clang_CXXRecordDecl_getNumFriends(x))
end

"""
    getFriends(x::AbstractCXXRecordDecl) -> Vector{Decl}
Return the friend declarations of the class. `clang::FriendDecl` has no carrier of its own,
so the entries come back at their `Decl` base; `getDeclKindName` reports `"Friend"` for each.

PARTIAL: the range reaches the record's definition data, so a definition is required.
"""
function getFriends(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert hasDefinition(x) "the class must have a definition"
    n = clang_CXXRecordDecl_getNumFriends(x)
    buf = Vector{CXDecl}(undef, n)
    n > 0 && clang_CXXRecordDecl_getFriends(x, buf)
    return [Decl(p) for p in buf]
end

"""
    setLambdaTypeInfo(x::AbstractCXXRecordDecl, info::TypeSourceInfo)
Record the written type of the closure type's call operator
(`clang::CXXRecordDecl::setLambdaTypeInfo`), the setter behind `getLambdaTypeInfo`.

PARTIAL: clang asserts the class is a lambda closure type.
"""
function setLambdaTypeInfo(x::AbstractCXXRecordDecl, info::TypeSourceInfo)
    @check_ptrs x info
    @assert isLambda(x) "the class must be a lambda closure type"
    return clang_CXXRecordDecl_setLambdaTypeInfo(x, info)
end

"""
    setTemplateSpecializationKind(x::AbstractCXXRecordDecl, tsk::CXTemplateSpecializationKind)
Record how this class came about as a specialization or instantiation
(`clang::CXXRecordDecl::setTemplateSpecializationKind`).

PARTIAL: clang `llvm_unreachable`s unless the class is a class template specialization or
carries a `MemberSpecializationInfo`; on the latter path the info object encodes `tsk - 1`
in two bits, so `TSK_Undeclared` trips a clang assert. Both are restated here.
"""
function setTemplateSpecializationKind(x::AbstractCXXRecordDecl, tsk::CXTemplateSpecializationKind)
    @check_ptrs x
    is_spec = getDeclKindName(x) in ("ClassTemplateSpecialization", "ClassTemplatePartialSpecialization")
    @assert is_spec || getMemberSpecializationInfo(x).ptr != C_NULL "not a specialization or instantiated member"
    @assert is_spec || tsk != CXTemplateSpecializationKind_TSK_Undeclared "TSK_Undeclared has no encoding here"
    return clang_CXXRecordDecl_setTemplateSpecializationKind(x, tsk)
end

"""
    setInstantiationOfMemberClass(x::AbstractCXXRecordDecl, rd::AbstractCXXRecordDecl,
                                  tsk::CXTemplateSpecializationKind)
Record that this class is an instantiation of the member class `rd`
(`clang::CXXRecordDecl::setInstantiationOfMemberClass`), the setter behind
`getInstantiatedFromMemberClass`.

PARTIAL: clang asserts the template/instantiation slot is still empty, that the receiver is
not a class template partial specialization, and - through the `MemberSpecializationInfo` it
builds - that `tsk` is not `TSK_Undeclared`. The call is one-way: clang exposes no way to
clear the slot again.
"""
function setInstantiationOfMemberClass(x::AbstractCXXRecordDecl, rd::AbstractCXXRecordDecl, tsk::CXTemplateSpecializationKind)
    @check_ptrs x rd
    @assert getDescribedClassTemplate(x).ptr == C_NULL "the class already describes a template"
    @assert getMemberSpecializationInfo(x).ptr == C_NULL "the instantiation slot is taken"
    @assert getDeclKindName(x) != "ClassTemplatePartialSpecialization" "not for a partial specialization"
    @assert tsk != CXTemplateSpecializationKind_TSK_Undeclared "TSK_Undeclared has no encoding here"
    return clang_CXXRecordDecl_setInstantiationOfMemberClass(x, rd, tsk)
end

"""
    calculateInheritanceModel(x::AbstractCXXRecordDecl) -> CXMSInheritanceModel
Return the Microsoft C++ ABI member-pointer inheritance model this class would be given
(`clang::CXXRecordDecl::calculateInheritanceModel`).

PARTIAL: reads the record's definition data, so a definition is required.
"""
function calculateInheritanceModel(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert hasDefinition(x) "the class must have a definition"
    return clang_CXXRecordDecl_calculateInheritanceModel(x)
end

"""
    nullFieldOffsetIsZero(x::AbstractCXXRecordDecl) -> Bool
Return whether a null data member pointer to this class may use a zero field offset under
the Microsoft C++ ABI (`clang::CXXRecordDecl::nullFieldOffsetIsZero`).

PARTIAL: runs `calculateInheritanceModel`, so a definition is required.

!!! warning
    Microsoft C++ ABI only. The inheritance model it computes lives behind
    `MSInheritanceAttr`, which no other ABI populates, so calling this on an Itanium
    (or any non-Microsoft) target segfaults rather than returning a value. The ABI
    kind is the gate, and it is observable, so it is asserted here.
"""
function nullFieldOffsetIsZero(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert hasDefinition(x) "the class must have a definition"
    ms = CXTargetCXXABI_Microsoft
    @assert getCXXABIKind(getASTContext(x)) == ms "requires the Microsoft C++ ABI"
    return clang_CXXRecordDecl_nullFieldOffsetIsZero(x)
end

# UnresolvedUsingIfExistsDecl
"""
    UnresolvedUsingIfExistsDecl(ctx::ASTContext, dc::AnyDeclContext, loc::SourceLocation,
                                name::DeclarationName) -> UnresolvedUsingIfExistsDecl
Build the marker declaration Sema uses when a using-declaration marked
`__attribute__((using_if_exists))` fails to resolve
(`clang::UnresolvedUsingIfExistsDecl::Create`). The declaration is allocated in `ctx` and is
not added to `dc`.
"""
function UnresolvedUsingIfExistsDecl(ctx::ASTContext, dc::AnyDeclContext, loc::SourceLocation, name::DeclarationName)
    @check_ptrs ctx dc
    d = clang_UnresolvedUsingIfExistsDecl_Create(ctx, dc, loc, name)
    return UnresolvedUsingIfExistsDecl(d)
end

function UnresolvedUsingIfExistsDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    d = clang_UnresolvedUsingIfExistsDecl_CreateDeserialized(ctx, id)
    return UnresolvedUsingIfExistsDecl(d)
end

# --- CXXRecordDecl: closure capture fields, imprecise base lookup, Microsoft C++ ABI ---

"""
    getNumCaptureFields(x::AbstractCXXRecordDecl) -> Integer
Return how many of the closure type `x`'s captured variables have a corresponding field
(`clang::CXXRecordDecl::getCaptureFields`). Init-captures contribute no entry and the `this`
capture is reported separately, so this is not `capture_size`.

PARTIAL: `x` must be a lambda closure type - clang reaches the closure's definition data
behind an `isLambda()` assert.
"""
function getNumCaptureFields(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert isLambda(x) "the record must be a lambda closure type"
    return clang_CXXRecordDecl_getNumCaptureFields(x)
end

"""
    getCaptureFields(x::AbstractCXXRecordDecl) -> Tuple{Vector{ValueDecl},Vector{FieldDecl},FieldDecl}
Map the captured variables of the closure type `x` onto the fields that hold them, under the
same precondition as `getNumCaptureFields`. The two vectors are in lockstep - the `i`-th
variable is captured into the `i`-th field - and their order carries no meaning. The third
result is the field holding the `this` capture, a NULL carrier when `this` is not captured.
"""
function getCaptureFields(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert isLambda(x) "the record must be a lambda closure type"
    n = clang_CXXRecordDecl_getNumCaptureFields(x)
    vars = Vector{CXValueDecl}(undef, n)
    fields = Vector{CXFieldDecl}(undef, n)
    this_field = Ref{CXFieldDecl}(C_NULL)
    # unconditional: the `this` capture is reported even when the map is empty
    clang_CXXRecordDecl_getCaptureFields(x, vars, fields, this_field)
    return ([ValueDecl(p) for p in vars], [FieldDecl(p) for p in fields], FieldDecl(this_field[]))
end

"""
    getNumDependentNameLookupResults(x::AbstractCXXRecordDecl, name::DeclarationName) -> Integer
Return how many declarations an imprecise lookup of `name` in the class `x` finds
(`clang::CXXRecordDecl::lookupDependentName`, run with an accept-all filter). The class's own
ordinary members win; only when it declares none of that name are the base classes searched.
The lookup does not follow strict semantic rules and is meant for indexing, not for language
semantics. Requires a complete definition.
"""
function getNumDependentNameLookupResults(x::AbstractCXXRecordDecl, name::DeclarationName)
    @check_ptrs x
    @assert hasDefinition(x) "CXXRecordDecl has no definition."
    return clang_CXXRecordDecl_getNumDependentNameLookupResults(x, name)
end

"""
    lookupDependentName(x::AbstractCXXRecordDecl, name::DeclarationName) -> Vector{NamedDecl}
Collect the declarations an imprecise lookup of `name` in the class `x` finds, under the same
precondition and with the same semantics as `getNumDependentNameLookupResults`. No entry is
NULL.
"""
function lookupDependentName(x::AbstractCXXRecordDecl, name::DeclarationName)
    @check_ptrs x
    @assert hasDefinition(x) "CXXRecordDecl has no definition."
    n = clang_CXXRecordDecl_getNumDependentNameLookupResults(x, name)
    buf = Vector{CXNamedDecl}(undef, n)
    n > 0 && clang_CXXRecordDecl_lookupDependentName(x, name, buf)
    return [NamedDecl(p) for p in buf]
end

"""
    getMSInheritanceModel(x::AbstractCXXRecordDecl) -> CXMSInheritanceModel
Return the Microsoft C++ ABI member-pointer inheritance model recorded on this class
(`clang::CXXRecordDecl::getMSInheritanceModel`).

PARTIAL: clang dereferences the class's `MSInheritanceAttr` unconditionally, so the attribute
must be present; only the Microsoft C++ ABI ever attaches it. Both the ABI and the attribute
are asserted here. `calculateInheritanceModel` computes the model a class would be given and
needs neither.
"""
function getMSInheritanceModel(x::AbstractCXXRecordDecl)
    @check_ptrs x
    ms = CXTargetCXXABI_Microsoft
    @assert getCXXABIKind(getASTContext(x)) == ms "requires the Microsoft C++ ABI"
    @assert hasAttrOfKind(x, CXAttrKind_MSInheritance) "the record carries no MSInheritanceAttr"
    return clang_CXXRecordDecl_getMSInheritanceModel(x)
end

"""
    getMSVtorDispMode(x::AbstractCXXRecordDecl) -> CXMSVtorDispMode
Return when vtordisps are emitted for this record used as a virtual base
(`clang::CXXRecordDecl::getMSVtorDispMode`): the nearest `__declspec(vtordisp)` on the class
or on a class it was instantiated from, falling back to the translation unit's vtordisp
language option.

The lookup itself is total, but a vtordisp is a Microsoft C++ ABI construct and the fallback
is a language option no other ABI acts on, so the wrapper rejects the call on a non-Microsoft
target rather than hand back a value that means nothing there.
"""
function getMSVtorDispMode(x::AbstractCXXRecordDecl)
    @check_ptrs x
    ms = CXTargetCXXABI_Microsoft
    @assert getCXXABIKind(getASTContext(x)) == ms "requires the Microsoft C++ ABI"
    return clang_CXXRecordDecl_getMSVtorDispMode(x)
end

# --- Final overriders, whole qualifier locations, and the factories that take one ---

"""
    getNumFinalOverriders(x::AbstractCXXRecordDecl) -> Integer
Return how many (overridden method, final overrider) pairs the class `x` tops
(`clang::CXXRecordDecl::getFinalOverriders`). A class that neither declares nor inherits a
virtual member function has none.

PARTIAL: the walk reads the class's definition data, so `x` must have a definition.
"""
function getNumFinalOverriders(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert hasDefinition(x) "the class must have a definition"
    return clang_CXXRecordDecl_getNumFinalOverriders(x)
end

"""
    getFinalOverriders(x::AbstractCXXRecordDecl) -> Tuple{Vector{CXXMethodDecl},Vector{UInt32},Vector{CXXMethodDecl},Vector{UInt32},Vector{CXXRecordDecl}}
Resolve, for every virtual member function in the hierarchy `x` tops, which declaration
finally overrides it, under the same precondition as `getNumFinalOverriders`. The five
vectors are in lockstep: entry `i` says that the `i`-th overridden method, found in the
subobject the second vector numbers, is finally overridden by the `i`-th overrider, which
lives in the subobject the fourth vector numbers, inside the virtual base subobject the
fifth vector names — a NULL carrier when the overrider is not inside a virtual base.
Subobject 0 is the virtual base subobject of its type; higher numbers are the non-virtual
ones. The order is clang's insertion order, which carries no language meaning.
"""
function getFinalOverriders(x::AbstractCXXRecordDecl)
    @check_ptrs x
    @assert hasDefinition(x) "the class must have a definition"
    n = Int(clang_CXXRecordDecl_getNumFinalOverriders(x))
    overridden = Vector{CXCXXMethodDecl}(undef, n)
    overridden_subobject = Vector{Cuint}(undef, n)
    overrider = Vector{CXCXXMethodDecl}(undef, n)
    overrider_subobject = Vector{Cuint}(undef, n)
    in_virtual_subobject = Vector{CXCXXRecordDecl}(undef, n)
    n > 0 && clang_CXXRecordDecl_getFinalOverriders(x, overridden, overridden_subobject, overrider, overrider_subobject, in_virtual_subobject)
    return ([CXXMethodDecl(p) for p in overridden], overridden_subobject, [CXXMethodDecl(p) for p in overrider], overrider_subobject, [CXXRecordDecl(p) for p in in_virtual_subobject])
end

# The getQualifierLoc family. `getQualifierRange` flattens a qualifier to its outer extent;
# these return the whole `NestedNameSpecifierLoc`, which is the only way to reach the
# per-component locations, the prefix chain and the qualifier's `TypeLoc`. Every result is an
# owned box, and a name written without a nested-name-specifier yields an empty box rather
# than a NULL one.

# UsingDirectiveDecl (cont.)
"""
    getQualifierLoc(x::AbstractUsingDirectiveDecl) -> NestedNameSpecifierLoc
Return the nested-name-specifier that qualifies the nominated namespace's name, together with
the source location of every component that was written.
This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function getQualifierLoc(x::AbstractUsingDirectiveDecl)
    @check_ptrs x
    return NestedNameSpecifierLoc(clang_UsingDirectiveDecl_getQualifierLoc(x))
end

# NamespaceAliasDecl (cont.)
"""
    getQualifierLoc(x::AbstractNamespaceAliasDecl) -> NestedNameSpecifierLoc
Return the nested-name-specifier that qualifies the aliased namespace's name, together with
the source location of every component that was written.
This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function getQualifierLoc(x::AbstractNamespaceAliasDecl)
    @check_ptrs x
    return NestedNameSpecifierLoc(clang_NamespaceAliasDecl_getQualifierLoc(x))
end

# UsingDecl (cont.)
"""
    getQualifierLoc(x::AbstractUsingDecl) -> NestedNameSpecifierLoc
Return the nested-name-specifier that qualifies the introduced name, together with the source
location of every component that was written.
This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function getQualifierLoc(x::AbstractUsingDecl)
    @check_ptrs x
    return NestedNameSpecifierLoc(clang_UsingDecl_getQualifierLoc(x))
end

# UsingEnumDecl (cont.)
"""
    getQualifierLoc(x::AbstractUsingEnumDecl) -> NestedNameSpecifierLoc
Return the nested-name-specifier that qualifies the named enumeration, together with the
source location of every component that was written. An enumeration named without a
nested-name-specifier yields an empty location.

clang reads the qualifier out of the written enumeration type, so `getEnumType(x)` must be
non-NULL (Invariant 3).
This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function getQualifierLoc(x::AbstractUsingEnumDecl)
    @check_ptrs x
    @assert getEnumType(x).ptr != C_NULL "the declaration must carry its written enum type"
    return NestedNameSpecifierLoc(clang_UsingEnumDecl_getQualifierLoc(x))
end

# UnresolvedUsingValueDecl (cont.)
"""
    getQualifierLoc(x::AbstractUnresolvedUsingValueDecl) -> NestedNameSpecifierLoc
Return the nested-name-specifier that qualifies the named value, together with the source
location of every component that was written.
This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function getQualifierLoc(x::AbstractUnresolvedUsingValueDecl)
    @check_ptrs x
    return NestedNameSpecifierLoc(clang_UnresolvedUsingValueDecl_getQualifierLoc(x))
end

# UnresolvedUsingTypenameDecl (cont.)
"""
    getQualifierLoc(x::AbstractUnresolvedUsingTypenameDecl) -> NestedNameSpecifierLoc
Return the nested-name-specifier that qualifies the named type, together with the source
location of every component that was written.
This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function getQualifierLoc(x::AbstractUnresolvedUsingTypenameDecl)
    @check_ptrs x
    return NestedNameSpecifierLoc(clang_UnresolvedUsingTypenameDecl_getQualifierLoc(x))
end

# The factories that take a nested-name-specifier. `qualifier_loc` is read, not adopted:
# clang copies the value out of the box, which stays the caller's to `dispose`. The only way
# to obtain one is a `getQualifierLoc` accessor, whose empty box spells a name written
# without a nested-name-specifier. None of these register the new declaration with `dc`.

"""
    UsingDirectiveDecl(ctx::ASTContext, dc::AnyDeclContext, using_loc::SourceLocation,
                       namespace_loc::SourceLocation,
                       qualifier_loc::AbstractNestedNameSpecifierLoc,
                       ident_loc::SourceLocation, nominated::AbstractNamedDecl,
                       common_ancestor::DeclContext) -> UsingDirectiveDecl
Build a `using namespace N;` directive naming `nominated`, whose innermost context shared
with the directive is `common_ancestor`.
"""
function UsingDirectiveDecl(ctx::ASTContext, dc::AnyDeclContext, using_loc::SourceLocation, namespace_loc::SourceLocation, qualifier_loc::AbstractNestedNameSpecifierLoc, ident_loc::SourceLocation, nominated::AbstractNamedDecl, common_ancestor::DeclContext)
    @check_ptrs ctx dc qualifier_loc nominated common_ancestor
    udd = clang_UsingDirectiveDecl_Create(ctx, dc, using_loc, namespace_loc, qualifier_loc, ident_loc, nominated, common_ancestor)
    return UsingDirectiveDecl(udd)
end

"""
    NamespaceAliasDecl(ctx::ASTContext, dc::AnyDeclContext, namespace_loc::SourceLocation,
                       alias_loc::SourceLocation, alias::IdentifierInfo,
                       qualifier_loc::AbstractNestedNameSpecifierLoc,
                       ident_loc::SourceLocation, ns::AbstractNamedDecl) -> NamespaceAliasDecl
Build a `namespace A = N;` alias introducing the identifier `alias` for the namespace `ns`.
"""
function NamespaceAliasDecl(ctx::ASTContext, dc::AnyDeclContext, namespace_loc::SourceLocation, alias_loc::SourceLocation, alias::IdentifierInfo, qualifier_loc::AbstractNestedNameSpecifierLoc, ident_loc::SourceLocation, ns::AbstractNamedDecl)
    @check_ptrs ctx dc alias qualifier_loc ns
    nad = clang_NamespaceAliasDecl_Create(ctx, dc, namespace_loc, alias_loc, alias, qualifier_loc, ident_loc, ns)
    return NamespaceAliasDecl(nad)
end

"""
    UsingDecl(ctx::ASTContext, dc::AnyDeclContext, using_loc::SourceLocation,
              qualifier_loc::AbstractNestedNameSpecifierLoc,
              name_info::DeclarationNameInfo, has_typename::Bool) -> UsingDecl
Build a `using N::f;` declaration. `has_typename` spells the `typename` keyword a
dependent using-declaration may carry. `name_info` is read, not adopted.
"""
function UsingDecl(ctx::ASTContext, dc::AnyDeclContext, using_loc::SourceLocation, qualifier_loc::AbstractNestedNameSpecifierLoc, name_info::DeclarationNameInfo, has_typename::Bool)
    @check_ptrs ctx dc qualifier_loc name_info
    ud = clang_UsingDecl_Create(ctx, dc, using_loc, qualifier_loc, name_info, has_typename)
    return UsingDecl(ud)
end

"""
    UnresolvedUsingValueDecl(ctx::ASTContext, dc::AnyDeclContext, using_loc::SourceLocation,
                             qualifier_loc::AbstractNestedNameSpecifierLoc,
                             name_info::DeclarationNameInfo,
                             ellipsis_loc::SourceLocation) -> UnresolvedUsingValueDecl
Build the declaration a `using T::v;` over a dependent base names. A valid `ellipsis_loc` is
what makes the declaration a pack expansion; pass an invalid one for the ordinary case.
`name_info` is read, not adopted.
"""
function UnresolvedUsingValueDecl(ctx::ASTContext, dc::AnyDeclContext, using_loc::SourceLocation, qualifier_loc::AbstractNestedNameSpecifierLoc, name_info::DeclarationNameInfo, ellipsis_loc::SourceLocation)
    @check_ptrs ctx dc qualifier_loc name_info
    uuvd = clang_UnresolvedUsingValueDecl_Create(ctx, dc, using_loc, qualifier_loc, name_info, ellipsis_loc)
    return UnresolvedUsingValueDecl(uuvd)
end

"""
    UnresolvedUsingTypenameDecl(ctx::ASTContext, dc::AnyDeclContext, using_loc::SourceLocation,
                                typename_loc::SourceLocation,
                                qualifier_loc::AbstractNestedNameSpecifierLoc,
                                target_name_loc::SourceLocation,
                                target_name::DeclarationName,
                                ellipsis_loc::SourceLocation) -> UnresolvedUsingTypenameDecl
Build the declaration a `using typename T::t;` over a dependent base names. A valid
`ellipsis_loc` is what makes the declaration a pack expansion.

clang stores `target_name` reduced to its `IdentifierInfo`, so a name that is not a plain
identifier would produce an unnamed declaration; the wrapper rejects it instead
(Invariant 3).
"""
function UnresolvedUsingTypenameDecl(ctx::ASTContext, dc::AnyDeclContext, using_loc::SourceLocation, typename_loc::SourceLocation, qualifier_loc::AbstractNestedNameSpecifierLoc, target_name_loc::SourceLocation, target_name::DeclarationName, ellipsis_loc::SourceLocation)
    @check_ptrs ctx dc qualifier_loc
    @assert getAsIdentifierInfo(target_name).ptr != C_NULL "the name must be an identifier"
    uutd = clang_UnresolvedUsingTypenameDecl_Create(ctx, dc, using_loc, typename_loc, qualifier_loc, target_name_loc, target_name, ellipsis_loc)
    return UnresolvedUsingTypenameDecl(uutd)
end

# --- Base paths, and the selected-destructor notification ---

# `isDerivedFrom` answers whether a class derives from a base; these answer how. clang records
# the search into a `CXXBasePaths` whose storage dies with the call, so the shim runs the
# search and flattens the recorded paths to one row per `CXXBasePathElement`, the same
# count+fill-over-parallel-buffers shape as `getFinalOverriders`.

"""
    getNumBasePathElements(x::AbstractCXXRecordDecl, base::AbstractCXXRecordDecl) -> Integer
Return how many derived-to-base steps `getBasePathElements(x, base)` will report, summed over
every path clang records from `x` to `base` (`clang::CXXRecordDecl::isDerivedFrom`'s
`CXXBasePaths` overload). It is 0 exactly when `isDerivedFrom(x, base)` is `false`, a class
being neither derived from itself nor from an unrelated class.

PARTIAL: the walk reads the definition data of `x` and of every base it visits, so
`hasDefinition(x)` must hold.
"""
function getNumBasePathElements(x::AbstractCXXRecordDecl, base::AbstractCXXRecordDecl)
    @check_ptrs x base
    @assert hasDefinition(x) "the class must have a definition"
    return clang_CXXRecordDecl_getNumBasePathElements(x, base)
end

"""
    getBasePathElements(x::AbstractCXXRecordDecl, base::AbstractCXXRecordDecl)
        -> Tuple{Vector{UInt32},Vector{CXAccessSpecifier},Vector{CXXBaseSpecifier},
                 Vector{CXXRecordDecl},Vector{Int32}}
Resolve every inheritance path from `x` to `base`, under the same precondition as
`getNumBasePathElements`. The five vectors are in lockstep, one entry per step of a path;
destructured as `paths, accesses, specifiers, classes, subobjects`, entry `i` reads:

  - `paths[i]` numbers the path entry `i` belongs to. Entries of one path are contiguous and
    paths are numbered from 0, so more than one path number means `base` is an *ambiguous*
    base of `x`;
  - `accesses[i]` is that path's merged access, repeated on every entry of the path.
    `CXAccessSpecifier_AS_none` is clang's marker for a path that permits no legal
    derived-to-base conversion, which is what a private base reached past the first step
    produces (see [`MergeAccess`](@ref));
  - `specifiers[i]` is the base specifier this step follows and `classes[i]` the class that
    specifier is written on: from `classes[i]`, follow `specifiers[i]`;
  - `subobjects[i]` is the base subobject the step designates. clang defines it only when
    `isVirtual(specifiers[i])` is `false` — it is 0 on a virtual edge, since a type has at
    most one virtual base subobject — and numbers the non-virtual subobjects of a base type
    from 1 otherwise, which is what distinguishes two same-typed base subobjects of one class.

The order is clang's depth-first walk of `bases()` in declaration order, so it is the order
the base specifiers are written in.
"""
function getBasePathElements(x::AbstractCXXRecordDecl, base::AbstractCXXRecordDecl)
    @check_ptrs x base
    @assert hasDefinition(x) "the class must have a definition"
    n = Int(clang_CXXRecordDecl_getNumBasePathElements(x, base))
    paths = Vector{Cuint}(undef, n)
    accesses = Vector{CXAccessSpecifier}(undef, n)
    specifiers = Vector{CXCXXBaseSpecifier}(undef, n)
    classes = Vector{CXCXXRecordDecl}(undef, n)
    subobjects = Vector{Cint}(undef, n)
    n > 0 && clang_CXXRecordDecl_getBasePathElements(x, base, paths, accesses, specifiers, classes, subobjects)
    return (paths, accesses, [CXXBaseSpecifier(p) for p in specifiers], [CXXRecordDecl(p) for p in classes], subobjects)
end

"""
    addedSelectedDestructor(x::AbstractCXXRecordDecl, dd::AbstractCXXDestructorDecl)
Tell the class that `dd` is now its selected destructor
(`clang::CXXRecordDecl::addedSelectedDestructor`), recomputing the triviality and
destructor-derived flags — `hasTrivialDestructor`, `hasNonTrivialDestructorForCall`,
`hasIrrelevantDestructor`, `isAnyDestructorNoReturn` — from it. Since C++20 a class may
declare several destructors of which one is selected at the end, which is why clang defers
this past `addedMember` to class completion. It also clears `dd`'s own
`isIneligibleOrNotSelected` bit.

PARTIAL: the flags live in the class's definition data, so `hasDefinition(x)` must hold.
Nothing checks that `dd` is a destructor *of this class*: another class's destructor does not
crash, it silently folds its own triviality into `x`'s flags.
"""
function addedSelectedDestructor(x::AbstractCXXRecordDecl, dd::AbstractCXXDestructorDecl)
    @check_ptrs x dd
    @assert hasDefinition(x) "the class must have a definition"
    return clang_CXXRecordDecl_addedSelectedDestructor(x, dd)
end
