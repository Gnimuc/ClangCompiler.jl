"""
    struct DeclContext <: Any
Hold a pointer to a `clang::DeclContext` object.
"""
struct DeclContext
    ptr::CXDeclContext
end

function getDeclKindName(x::DeclContext)
    @check_ptrs x
    return unsafe_string(clang_DeclContext_getDeclKindName(x.ptr))
end

function get_parent(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_getParent(x.ptr)
end

function get_lexical_parent(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_getLexicalParent(x.ptr)
end

function get_lookup_parent(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_getLookupParent(x.ptr)
end

function is_closure(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isClosure(x.ptr)
end

function is_function_or_method(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isFunctionOrMethod(x.ptr)
end

function is_lookup_context(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isLookupContext(x.ptr)
end

function is_file_context(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isFileContext(x.ptr)
end

function is_translation_unit(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isTranslationUnit(x.ptr)
end

function is_record(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isRecord(x.ptr)
end

function is_namespace(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isNamespace(x.ptr)
end

function is_std_namespace(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isStdNamespace(x.ptr)
end

function is_inline_namespace(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isInlineNamespace(x.ptr)
end

function is_dependent_context(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isDependentContext(x.ptr)
end

function is_transparent_context(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isTransparentContext(x.ptr)
end

function is_extern_c_context(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isExternCContext(x.ptr)
end

function is_extern_cxx_context(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isExternCXXContext(x.ptr)
end

function is_equal(x::DeclContext, y::DeclContext)
    @check_ptrs x y
    return clang_DeclContext_Equals(x.ptr, y.ptr)
end

function get_primary_context(x::DeclContext)
    @check_ptrs x
    return DeclContext(clang_DeclContext_getPrimaryContext(x.ptr))
end

function dump(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_dumpDeclContext(x.ptr)
end

function dump_lookups(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_dumpLookups(x.ptr)
end
