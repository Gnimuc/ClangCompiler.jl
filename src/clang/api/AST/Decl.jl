# Decl
function dumpColor(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_dumpColor(x)
end

function getBeginLoc(x::AbstractDecl)
    @check_ptrs x
    return SourceLocation(clang_Decl_getBeginLoc(x))
end

function getEndLoc(x::AbstractDecl)
    @check_ptrs x
    return SourceLocation(clang_Decl_getEndLoc(x))
end

function getASTContext(x::AbstractDecl)
    @check_ptrs x
    return ASTContext(clang_Decl_getASTContext(x))
end

function isOutOfLine(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isOutOfLine(x)
end

function getLocation(x::AbstractDecl)
    @check_ptrs x
    return SourceLocation(clang_Decl_getLocation(x))
end

function getDeclKindName(x::AbstractDecl)
    @check_ptrs x
    return unsafe_string(clang_Decl_getDeclKindName(x))
end

function getNextDeclInContext(x::AbstractDecl)
    @check_ptrs x
    return Decl(clang_Decl_getNextDeclInContext(x))
end

function getDeclContext(x::AbstractDecl)
    @check_ptrs x
    return DeclContext(clang_Decl_getDeclContext(x))
end

function getNonClosureContext(x::AbstractDecl)
    @check_ptrs x
    return Decl(clang_Decl_getNonClosureContext(x))
end

function isInAnonymousNamespace(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isInAnonymousNamespace(x)
end

function isInStdNamespace(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isInStdNamespace(x)
end

function getLangOpts(x::AbstractDecl)
    @check_ptrs x
    return LangOptions(clang_Decl_getLangOpts(x))
end

function getLexicalDeclContext(x::AbstractDecl)
    @check_ptrs x
    return DeclContext(clang_Decl_getLexicalDeclContext(x))
end

function isTemplated(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isTemplated(x)
end

function isCanonicalDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isCanonicalDecl(x)
end

function getPreviousDecl(x::AbstractDecl)
    @check_ptrs x
    return Decl(clang_Decl_getPreviousDecl(x))
end

function isFirstDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isFirstDecl(x)
end

function getMostRecentDecl(x::AbstractDecl)
    @check_ptrs x
    return Decl(clang_Decl_getMostRecentDecl(x))
end

function isTemplateParameter(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isTemplateParameter(x)
end

function isTemplateDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isTemplateDecl(x)
end

function getDescribedTemplate(x::AbstractDecl)
    @check_ptrs x
    return TemplateDecl(clang_Decl_getDescribedTemplate(x))
end

function setDeclContext(decl::AbstractDecl, x::DeclContext)
    @check_ptrs x decl
    return clang_Decl_setDeclContext(decl, x)
end

function setLexicalDeclContext(decl::AbstractDecl, x::DeclContext)
    @check_ptrs x decl
    return clang_Decl_setLexicalDeclContext(decl, x)
end

function ClassTemplateDecl(x::AbstractDecl)
    @check_ptrs x
    return ClassTemplateDecl(clang_Decl_castToClassTemplateDecl(x))
end

function ValueDecl(x::AbstractDecl)
    @check_ptrs x
    return ValueDecl(clang_Decl_castToValueDecl(x))
end

# NamedDecl
function isOutOfLine(x::AbstractNamedDecl)
    @check_ptrs x
    return clang_NamedDecl_isOutOfLine(x)
end

function getIdentifier(x::AbstractNamedDecl)
    @check_ptrs x
    return IdentifierInfo(clang_NamedDecl_getIdentifier(x))
end

function getName(x::AbstractNamedDecl)
    @check_ptrs x
    return unsafe_string(clang_NamedDecl_getName(x))
end

function getDeclName(x::AbstractNamedDecl)
    @check_ptrs x
    return DeclarationName(clang_NamedDecl_getDeclName(x))
end

function setDeclName(x::AbstractNamedDecl, name::DeclarationName)
    @check_ptrs x
    return clang_NamedDecl_setDeclName(x, name)
end

function hasLinkage(x::AbstractNamedDecl)
    @check_ptrs x
    return clang_NamedDecl_hasLinkage(x)
end

function isCXXClassMember(x::AbstractNamedDecl)
    @check_ptrs x
    return clang_NamedDecl_isCXXClassMember(x)
end

function isCXXInstanceMember(x::AbstractNamedDecl)
    @check_ptrs x
    return clang_NamedDecl_isCXXInstanceMember(x)
end

function hasExternalFormalLinkage(x::AbstractNamedDecl)
    @check_ptrs x
    return clang_NamedDecl_hasExternalFormalLinkage(x)
end

function isExternallyVisible(x::AbstractNamedDecl)
    @check_ptrs x
    return clang_NamedDecl_isExternallyVisible(x)
end

function isExternallyDeclarable(x::AbstractNamedDecl)
    @check_ptrs x
    return clang_NamedDecl_isExternallyDeclarable(x)
end

function getUnderlyingDecl(x::AbstractNamedDecl)
    @check_ptrs x
    return NamedDecl(clang_NamedDecl_getUnderlyingDecl(x))
end

function getMostRecentDecl(x::AbstractNamedDecl)
    @check_ptrs x
    return clang_NamedDecl_getMostRecentDecl(x)
end

function TypeDecl(x::NamedDecl)
    @check_ptrs x
    return TypeDecl(clang_NamedDecl_castToTypeDecl(x))
end

# FunctionDecl
function getAsFunction(x::AbstractNamedDecl)::CXFunctionDecl
    @check_ptrs x
    return clang_Decl_getAsFunction(x)
end

# ValueDecl
function getType(x::AbstractValueDecl)
    @check_ptrs x
    return QualType(clang_ValueDecl_getType(x))
end

function setType(x::AbstractValueDecl, ty::AbstractQualType)
    @check_ptrs x
    return clang_ValueDecl_setType(x, ty)
end

function isWeak(x::AbstractValueDecl)
    @check_ptrs x
    return clang_ValueDecl_isWeak(x)
end

# TypeDecl
function getTypeForDecl(x::AbstractTypeDecl)::CXType_
    @check_ptrs x
    return clang_TypeDecl_getTypeForDecl(x)
end
getTypeForDecl(x::NamedDecl) = getTypeForDecl(TypeDecl(x))

function setTypeForDecl(x::AbstractTypeDecl, ty_ptr::CXType_)
    @check_ptrs x
    return clang_TypeDecl_setTypeForDecl(x, ty_ptr)
end
setTypeForDecl(x::AbstractTypeDecl, ty::AbstractQualType) = setTypeForDecl(x, get_type_ptr(ty))

function getBeginLoc(x::AbstractTypeDecl)
    @check_ptrs x
    return SourceLocation(clang_TypeDecl_getBeginLoc(x))
end

function setLocStart(x::AbstractTypeDecl, loc::SourceLocation)
    @check_ptrs x
    return clang_TypeDecl_setLocStart(x, loc)
end

# TypedefNameDecl
function getUnderlyingType(x::AbstractTypedefNameDecl)
    @check_ptrs x
    return QualType(clang_TypedefNameDecl_getUnderlyingType(x))
end

function getCanonicalDecl(x::AbstractTypedefNameDecl)
    @check_ptrs x
    return TypedefNameDecl(clang_TypedefNameDecl_getCanonicalDecl(x))
end

function getAnonDeclWithTypedefName(x::AbstractTypedefNameDecl, any_redecl::Bool=false)
    @check_ptrs x
    return TagDecl(clang_TypedefNameDecl_getAnonDeclWithTypedefName(x, any_redecl))
end

function isTransparentTag(x::AbstractTypedefNameDecl)
    @check_ptrs x
    return clang_TypedefNameDecl_isTransparentTag(x)
end

# TagDecl
function DeclContext(x::AbstractTagDecl)
    @check_ptrs x
    return DeclContext(clang_TagDecl_castToDeclContext(x))
end

function getCanonicalDecl(x::AbstractTagDecl)
    @check_ptrs x
    return TagDecl(clang_TagDecl_getCanonicalDecl(x))
end

function isThisDeclarationADefinition(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_isThisDeclarationADefinition(x)
end

function isCompleteDefinition(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_isCompleteDefinition(x)
end

function setCompleteDefinition(x::AbstractTagDecl, v::Bool)
    @check_ptrs x
    return clang_TagDecl_setCompleteDefinition(x, v)
end

function isBeingDefined(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_isBeingDefined(x)
end

function isFreeStanding(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_isFreeStanding(x)
end

function startDefinition(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_startDefinition(x)
end

function getDefinition(x::AbstractTagDecl)
    @check_ptrs x
    return TagDecl(clang_TagDecl_getDefinition(x))
end

function getKindName(x::AbstractTagDecl)
    @check_ptrs x
    return unsafe_string(clang_TagDecl_getKindName(x))
end

function getTagKind(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_getTagKind(x)
end

function isStruct(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_isStruct(x)
end

function isInterface(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_isInterface(x)
end

function isClass(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_isClass(x)
end

function isUnion(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_isUnion(x)
end

function isEnum(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_isEnum(x)
end

function hasNameForLinkage(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_hasNameForLinkage(x)
end

function getTypedefNameForAnonDecl(x::AbstractTagDecl)
    @check_ptrs x
    return TypedefNameDecl(clang_TagDecl_getTypedefNameForAnonDecl(x))
end

function getQualifier(x::AbstractTagDecl)
    @check_ptrs x
    return NestedNameSpecifier(clang_TagDecl_getQualifier(x))
end

# EnumDecl
function getCanonicalDecl(x::EnumDecl)
    @check_ptrs x
    return EnumDecl(clang_EnumDecl_getCanonicalDecl(x))
end

function getPreviousDecl(x::EnumDecl)
    @check_ptrs x
    return EnumDecl(clang_EnumDecl_getPreviousDecl(x))
end

function getMostRecentDecl(x::EnumDecl)
    @check_ptrs x
    return EnumDecl(clang_EnumDecl_getMostRecentDecl(x))
end

function getDefinition(x::EnumDecl)
    @check_ptrs x
    return EnumDecl(clang_EnumDecl_getDefinition(x))
end

function getIntegerType(x::EnumDecl)
    @check_ptrs x
    return QualType(clang_EnumDecl_getIntegerType(x))
end

# RecordDecl
function getPreviousDecl(x::AbstractRecordDecl)
    @check_ptrs x
    return RecordDecl(clang_RecordDecl_getPreviousDecl(x))
end

function getMostRecentDecl(x::AbstractRecordDecl)
    @check_ptrs x
    return RecordDecl(clang_RecordDecl_getMostRecentDecl(x))
end

function hasFlexibleArrayMember(x::AbstractRecordDecl)
    @check_ptrs x
    return clang_RecordDecl_hasFlexibleArrayMember(x)
end

function isAnonymousStructOrUnion(x::AbstractRecordDecl)
    @check_ptrs x
    return clang_RecordDecl_isAnonymousStructOrUnion(x)
end

function isInjectedClassName(x::AbstractRecordDecl)
    @check_ptrs x
    return clang_RecordDecl_isInjectedClassName(x)
end

function isLambda(x::AbstractRecordDecl)
    @check_ptrs x
    return clang_RecordDecl_isLambda(x)
end

function isCapturedRecord(x::AbstractRecordDecl)
    @check_ptrs x
    return clang_RecordDecl_isCapturedRecord(x)
end

function getDefinition(x::AbstractRecordDecl)
    @check_ptrs x
    return RecordDecl(clang_RecordDecl_getDefinition(x))
end

function isOrContainsUnion(x::AbstractRecordDecl)
    @check_ptrs x
    return clang_RecordDecl_isOrContainsUnion(x)
end
