# CXXRecordDecl
function getCanonicalDecl(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return CXCXXRecordDecl(clang_CXXRecordDecl_getCanonicalDecl(x))
end

function getPreviousDecl(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return CXCXXRecordDecl(clang_CXXRecordDecl_getPreviousDecl(x))
end

function getMostRecentDecl(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return CXCXXRecordDecl(clang_CXXRecordDecl_getMostRecentDecl(x))
end

function getMostRecentNonInjectedDecl(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return CXCXXRecordDecl(clang_CXXRecordDecl_getMostRecentNonInjectedDecl(x))
end

function getDefinition(x::AbstractCXXRecordDecl)
    @check_ptrs x
    return CXCXXRecordDecl(clang_CXXRecordDecl_getDefinition(x))
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

