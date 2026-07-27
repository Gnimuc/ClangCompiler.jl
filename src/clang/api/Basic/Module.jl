# Module (clang::Module — the header-modules type, not llvm::Module)

"""
    Module_(name, loc=SourceLocation(); parent=Module_(C_NULL), is_framework=false, is_explicit=false, visibility_id=0) -> Module_
Create a `clang::Module` (a submodule when `parent` holds a non-NULL module).

When `parent` is non-NULL the new module is registered as a submodule of `parent`, which
then owns it — never `dispose` a parent-owned submodule. This function allocates and one
should call `dispose` to release the resources after using this object (parentless
modules only; disposing a module also deletes all of its submodules).
"""
function Module_(name::AbstractString, loc::SourceLocation=SourceLocation();
                 parent::Module_=Module_(C_NULL), is_framework::Bool=false,
                 is_explicit::Bool=false, visibility_id::Integer=0)
    ptr = clang_Module_create(name, loc, parent, is_framework, is_explicit, visibility_id)
    @assert ptr != C_NULL "Failed to create clang::Module"
    return Module_(ptr)
end

dispose(x::Module_) = clang_Module_dispose(x)

function getName(x::AbstractModule)
    @check_ptrs x
    return unsafe_string(clang_Module_getName(x))
end

function getKind(x::AbstractModule)
    @check_ptrs x
    return clang_Module_getKind(x)
end

"""
    getParent(x::AbstractModule) -> Module_
Return the parent module. The returned carrier holds NULL for a top-level module.
"""
function getParent(x::AbstractModule)
    @check_ptrs x
    return Module_(clang_Module_getParent(x))
end

function isNamedModule(x::AbstractModule)
    @check_ptrs x
    return clang_Module_isNamedModule(x)
end

function isGlobalModule(x::AbstractModule)
    @check_ptrs x
    return clang_Module_isGlobalModule(x)
end

function isExplicitGlobalModule(x::AbstractModule)
    @check_ptrs x
    return clang_Module_isExplicitGlobalModule(x)
end

function isImplicitGlobalModule(x::AbstractModule)
    @check_ptrs x
    return clang_Module_isImplicitGlobalModule(x)
end

function isPrivateModule(x::AbstractModule)
    @check_ptrs x
    return clang_Module_isPrivateModule(x)
end

function isModuleMapModule(x::AbstractModule)
    @check_ptrs x
    return clang_Module_isModuleMapModule(x)
end

function isUnimportable(x::AbstractModule)
    @check_ptrs x
    return clang_Module_isUnimportable(x)
end

function isAvailable(x::AbstractModule)
    @check_ptrs x
    return clang_Module_isAvailable(x)
end

function isSubModule(x::AbstractModule)
    @check_ptrs x
    return clang_Module_isSubModule(x)
end

function isSubModuleOf(x::AbstractModule, other::AbstractModule)
    @check_ptrs x other
    return clang_Module_isSubModuleOf(x, other)
end

function isPartOfFramework(x::AbstractModule)
    @check_ptrs x
    return clang_Module_isPartOfFramework(x)
end

function isSubFramework(x::AbstractModule)
    @check_ptrs x
    return clang_Module_isSubFramework(x)
end

function isHeaderLikeModule(x::AbstractModule)
    @check_ptrs x
    return clang_Module_isHeaderLikeModule(x)
end

function isModulePartition(x::AbstractModule)
    @check_ptrs x
    return clang_Module_isModulePartition(x)
end

function isModuleImplementation(x::AbstractModule)
    @check_ptrs x
    return clang_Module_isModuleImplementation(x)
end

function isHeaderUnit(x::AbstractModule)
    @check_ptrs x
    return clang_Module_isHeaderUnit(x)
end

function isInterfaceOrPartition(x::AbstractModule)
    @check_ptrs x
    return clang_Module_isInterfaceOrPartition(x)
end

function isNamedModuleUnit(x::AbstractModule)
    @check_ptrs x
    return clang_Module_isNamedModuleUnit(x)
end

function isModuleInterfaceUnit(x::AbstractModule)
    @check_ptrs x
    return clang_Module_isModuleInterfaceUnit(x)
end

function getPrimaryModuleInterfaceName(x::AbstractModule)
    @check_ptrs x
    return get_string(clang_Module_getPrimaryModuleInterfaceName(x))
end

function getFullModuleName(x::AbstractModule, allow_string_literals::Bool=false)
    @check_ptrs x
    return get_string(clang_Module_getFullModuleName(x, allow_string_literals))
end

function getTopLevelModule(x::AbstractModule)
    @check_ptrs x
    return Module_(clang_Module_getTopLevelModule(x))
end

function getTopLevelModuleName(x::AbstractModule)
    @check_ptrs x
    return unsafe_string(clang_Module_getTopLevelModuleName(x))
end

function directlyUses(x::AbstractModule, requested::AbstractModule)
    @check_ptrs x requested
    return clang_Module_directlyUses(x, requested)
end

"""
    findSubmodule(x::AbstractModule, name::AbstractString) -> Module_
Find the submodule with the given name. The returned carrier holds NULL when there is
no such submodule.
"""
function findSubmodule(x::AbstractModule, name::AbstractString)
    @check_ptrs x
    return Module_(clang_Module_findSubmodule(x, name))
end

function getNumSubmodules(x::AbstractModule)
    @check_ptrs x
    return Int(clang_Module_getNumSubmodules(x))
end

function getSubmodule(x::AbstractModule, i::Integer)
    @check_ptrs x
    return Module_(clang_Module_getSubmodule(x, i))
end


"""
    isForBuilding(x::AbstractModule, lang_opts::AbstractLangOptions) -> Bool
Return `true` iff this module can be built in the compilation described by `lang_opts`.
"""
function isForBuilding(x::AbstractModule, lang_opts::AbstractLangOptions)
    @check_ptrs x lang_opts
    return clang_Module_isForBuilding(x, lang_opts)
end

function isNamedModuleInterfaceHasInit(x::AbstractModule)
    @check_ptrs x
    return clang_Module_isNamedModuleInterfaceHasInit(x)
end

"""
    getASTFile(x::AbstractModule) -> Union{FileEntryRef,Nothing}
Return a heap-boxed `FileEntryRef` for the serialized AST file of `x`'s top-level module,
or `nothing` when there is none.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function getASTFile(x::AbstractModule)
    @check_ptrs x
    ptr = clang_Module_getASTFile(x)
    return ptr == C_NULL ? nothing : FileEntryRef(ptr)
end

function addTopHeaderFilename(x::AbstractModule, filename::AbstractString)
    @check_ptrs x
    return clang_Module_addTopHeaderFilename(x, filename)
end

"""
    markUnavailable(x::AbstractModule, unimportable::Bool)
Mark this module and all of its submodules as unavailable.
"""
function markUnavailable(x::AbstractModule, unimportable::Bool)
    @check_ptrs x
    return clang_Module_markUnavailable(x, unimportable)
end

"""
    findOrInferSubmodule(x::AbstractModule, name::AbstractString) -> Module_
Find the submodule with the given name, inferring one when `x` allows submodule inference.
The returned carrier holds NULL when there is no such submodule and none can be inferred;
an inferred submodule is owned by `x` and must never be disposed on its own.
"""
function findOrInferSubmodule(x::AbstractModule, name::AbstractString)
    @check_ptrs x
    return Module_(clang_Module_findOrInferSubmodule(x, name))
end

function getVisibilityID(x::AbstractModule)
    @check_ptrs x
    return clang_Module_getVisibilityID(x)
end
