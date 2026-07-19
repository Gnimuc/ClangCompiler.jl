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

