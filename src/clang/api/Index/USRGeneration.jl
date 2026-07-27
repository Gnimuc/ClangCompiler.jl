# index (clang::index — the namespace-level free functions of clang/Index/USRGeneration.h)
#
# Marshalling contract, mirrored from CXUSRGeneration.h: upstream writes the USR into a
# `SmallVectorImpl<char>`/`raw_ostream` out-parameter and reports failure (or "ignore this
# result") through a `bool`. The C shim folds both into a single `CXString`, so every
# function here returns a `String` and `isempty(usr)` is the failure test — a successfully
# generated USR is never empty.

"""
    getUSRSpacePrefix() -> String
Return the prefix that every *full* USR starts with (`"c:"`).
"""
getUSRSpacePrefix() = get_string(clang_index_getUSRSpacePrefix())

"""
    generateUSRForDecl(x::AbstractDecl) -> String
Generate a USR for `x`, including the USR prefix.

Return an empty string when the result should be ignored (e.g. a decl with no stable
identity).
"""
function generateUSRForDecl(x::AbstractDecl)
    @check_ptrs x
    return get_string(clang_index_generateUSRForDecl(x))
end

"""
    generateUSRForObjCClass(cls; ext_symbol_defined_in="", category_context_ext_symbol_defined_in="") -> String
Generate a USR *fragment* for an Objective-C class.
"""
function generateUSRForObjCClass(cls::AbstractString; ext_symbol_defined_in::AbstractString="",
                                 category_context_ext_symbol_defined_in::AbstractString="")
    return get_string(clang_index_generateUSRForObjCClass(cls, ext_symbol_defined_in,
                                                          category_context_ext_symbol_defined_in))
end

"""
    generateUSRForObjCCategory(cls, cat; cls_ext_symbol_defined_in="", cat_ext_symbol_defined_in="") -> String
Generate a USR fragment for an Objective-C class category.
"""
function generateUSRForObjCCategory(cls::AbstractString, cat::AbstractString;
                                    cls_ext_symbol_defined_in::AbstractString="",
                                    cat_ext_symbol_defined_in::AbstractString="")
    return get_string(clang_index_generateUSRForObjCCategory(cls, cat, cls_ext_symbol_defined_in,
                                                             cat_ext_symbol_defined_in))
end

"""
    generateUSRForObjCIvar(ivar) -> String
Generate a USR fragment for an Objective-C instance variable. The complete USR is this
fragment concatenated after the encompassing class's USR.
"""
function generateUSRForObjCIvar(ivar::AbstractString)
    return get_string(clang_index_generateUSRForObjCIvar(ivar))
end

"""
    generateUSRForObjCMethod(sel, is_instance_method::Bool) -> String
Generate a USR fragment for an Objective-C method.
"""
function generateUSRForObjCMethod(sel::AbstractString, is_instance_method::Bool)
    return get_string(clang_index_generateUSRForObjCMethod(sel, is_instance_method))
end

"""
    generateUSRForObjCProperty(prop, is_class_prop::Bool) -> String
Generate a USR fragment for an Objective-C property.
"""
function generateUSRForObjCProperty(prop::AbstractString, is_class_prop::Bool)
    return get_string(clang_index_generateUSRForObjCProperty(prop, is_class_prop))
end

"""
    generateUSRForObjCProtocol(prot; ext_symbol_defined_in="") -> String
Generate a USR fragment for an Objective-C protocol.
"""
function generateUSRForObjCProtocol(prot::AbstractString;
                                    ext_symbol_defined_in::AbstractString="")
    return get_string(clang_index_generateUSRForObjCProtocol(prot, ext_symbol_defined_in))
end

"""
    generateUSRForGlobalEnum(enum_name; ext_symbol_defined_in="") -> String
Generate a USR fragment for a global (non-nested) enum.
"""
function generateUSRForGlobalEnum(enum_name::AbstractString;
                                  ext_symbol_defined_in::AbstractString="")
    return get_string(clang_index_generateUSRForGlobalEnum(enum_name, ext_symbol_defined_in))
end

"""
    generateUSRForEnumConstant(name) -> String
Generate a USR fragment for an enum constant.
"""
function generateUSRForEnumConstant(name::AbstractString)
    return get_string(clang_index_generateUSRForEnumConstant(name))
end

"""
    generateUSRForMacro(macro_name, loc::SourceLocation, sm::AbstractSourceManager) -> String
Generate a USR for a macro, including the USR prefix. Return an empty string on error
(in particular for an empty `macro_name`).

`loc` is deliberately not checked for NULL: an *invalid* `SourceLocation` is a supported
input and simply omits the location from the USR. When `loc` is valid it must be a location
owned by `sm` — the wrapped function calls `SourceManager::isInSystemHeader(loc)` and prints
the decomposed location, both of which index `sm`'s own tables and are undefined for a
foreign location.
"""
function generateUSRForMacro(macro_name::AbstractString, loc::SourceLocation,
                             sm::AbstractSourceManager)
    @check_ptrs sm
    return get_string(clang_index_generateUSRForMacro(macro_name, loc, sm))
end

"""
    generateUSRForType(t::QualType, ctx::AbstractASTContext) -> String
Generate a USR for the canonical form of the type `t`. Return an empty string on error.
"""
function generateUSRForType(t::QualType, ctx::AbstractASTContext)
    @check_ptrs t ctx
    return get_string(clang_index_generateUSRForType(t, ctx))
end

"""
    generateFullUSRForModule(x::AbstractModule) -> String
Generate a USR for a module, including the USR prefix. Return an empty string on error.

The wrapped function dereferences the module unconditionally (`Mod->Parent`, `Mod->Name`)
without a null check, so a NULL carrier is rejected here.
"""
function generateFullUSRForModule(x::AbstractModule)
    @check_ptrs x
    return get_string(clang_index_generateFullUSRForModule(x))
end

"""
    generateFullUSRForTopLevelModuleName(name) -> String
Generate a USR for a top-level module name, including the USR prefix. Return an empty
string on error.
"""
function generateFullUSRForTopLevelModuleName(name::AbstractString)
    return get_string(clang_index_generateFullUSRForTopLevelModuleName(name))
end

"""
    generateUSRFragmentForModule(x::AbstractModule) -> String
Generate a USR fragment for a module. Return an empty string on error.

The wrapped function reads `Mod->Name` unconditionally without a null check, so a NULL
carrier is rejected here.
"""
function generateUSRFragmentForModule(x::AbstractModule)
    @check_ptrs x
    return get_string(clang_index_generateUSRFragmentForModule(x))
end

"""
    generateUSRFragmentForModuleName(name) -> String
Generate a USR fragment for a module name. Return an empty string on error.
"""
function generateUSRFragmentForModuleName(name::AbstractString)
    return get_string(clang_index_generateUSRFragmentForModuleName(name))
end
