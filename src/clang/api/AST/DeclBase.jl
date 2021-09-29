# DeclContext
function getParentASTContext(x::DeclContext)
    @check_ptrs x
    return ASTContext(clang_DeclContext_getParentASTContext(x))
end

function addDecl(x::DeclContext, decl::AbstractDecl)
    @check_ptrs x decl
    return clang_DeclContext_addDecl(x, decl)
end

function addDeclInternal(x::DeclContext, decl::AbstractDecl)
    @check_ptrs x decl
    return clang_DeclContext_addDeclInternal(x, decl)
end

function addHiddenDecl(x::DeclContext, decl::AbstractDecl)
    @check_ptrs x decl
    return clang_DeclContext_addHiddenDecl(x, decl)
end

function removeDecl(x::DeclContext, decl::AbstractDecl)
    @check_ptrs x decl
    return clang_DeclContext_removeDecl(x, decl)
end

function containsDecl(x::DeclContext, decl::AbstractDecl)
    @check_ptrs x decl
    return clang_DeclContext_containsDecl(x, decl)
end

function getDeclKindName(x::DeclContext)
    @check_ptrs x
    return unsafe_string(clang_DeclContext_getDeclKindName(x))
end

function getParent(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_getParent(x)
end

function getLexicalParent(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_getLexicalParent(x)
end

function getLookupParent(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_getLookupParent(x)
end

function isClosure(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isClosure(x)
end

function isFunctionOrMethod(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isFunctionOrMethod(x)
end

function isLookupContext(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isLookupContext(x)
end

function isFileContext(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isFileContext(x)
end

function isTranslationUnit(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isTranslationUnit(x)
end

function isRecord(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isRecord(x)
end

function isNamespace(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isNamespace(x)
end

function isStdNamespace(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isStdNamespace(x)
end

function isInlineNamespace(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isInlineNamespace(x)
end

function is_dependent_context(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isDependentContext(x)
end

function isTransparentContext(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isTransparentContext(x)
end

function isExternCContext(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isExternCContext(x)
end

function isExternCXXContext(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isExternCXXContext(x)
end

function Equals(x::DeclContext, y::DeclContext)
    @check_ptrs x y
    return clang_DeclContext_Equals(x, y)
end

function getPrimaryContext(x::DeclContext)
    @check_ptrs x
    return DeclContext(clang_DeclContext_getPrimaryContext(x))
end

function dumpDeclContext(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_dumpDeclContext(x)
end

function dumpLookups(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_dumpLookups(x)
end

# cast
function TagDecl(x::DeclContext)
    @check_ptrs x
    return TagDecl(clang_DeclContext_castToTagDecl(x))
end

function RecordDecl(x::DeclContext)
    @check_ptrs x
    return RecordDecl(clang_DeclContext_castToRecordDecl(x))
end

function CXXRecordDecl(x::DeclContext)
    @check_ptrs x
    return CXXRecordDecl(clang_DeclContext_castToCXXRecordDecl(x))
end
