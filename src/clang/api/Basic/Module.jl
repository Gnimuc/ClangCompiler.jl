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

"""
    setParent(x::AbstractModule, parent::AbstractModule)
Register `x` as a submodule of `parent`, which from then on owns `x` — never `dispose`
`x` afterwards, only `parent`.

`clang::Module::setParent` asserts that the module has no parent yet, so `x` must be a
top-level module (`getParent(x).ptr == C_NULL`).
"""
function setParent(x::AbstractModule, parent::AbstractModule)
    @check_ptrs x parent
    @assert getParent(x).ptr == C_NULL "module already has a parent"
    return clang_Module_setParent(x, parent)
end

"""
    fullModuleNameIs(x::AbstractModule, name_parts::AbstractVector{<:AbstractString}) -> Bool
Whether the module's full name equals `name_parts` joined with `"."`s. Cheaper than
comparing against `getFullModuleName(x)`, which builds the joined string.
"""
function fullModuleNameIs(x::AbstractModule, name_parts::AbstractVector{<:AbstractString})
    @check_ptrs x
    parts = collect(String, name_parts)
    return clang_Module_fullModuleNameIs(x, parts, length(parts))
end

"""
    addRequirement(x::AbstractModule, feature::AbstractString, required_state::Bool,
                   lang_opts::AbstractLangOptions, target::AbstractTargetInfo)
Record that the module requires `feature` to be present (`required_state === true`) or
absent, evaluated against `lang_opts` and `target`. A requirement that does not hold
marks the module and all of its submodules unavailable and unimportable.
"""
function addRequirement(x::AbstractModule, feature::AbstractString, required_state::Bool,
                        lang_opts::AbstractLangOptions, target::AbstractTargetInfo)
    @check_ptrs x lang_opts target
    return clang_Module_addRequirement(x, feature, required_state, lang_opts, target)
end

"""
    getGlobalModuleFragment(x::AbstractModule) -> Module_
Return the global module fragment submodule. The returned carrier holds NULL when the
module has none.

`clang::Module::getGlobalModuleFragment` asserts that the receiver is a C++20 named
module unit, so `isNamedModuleUnit(x)` must hold.
"""
function getGlobalModuleFragment(x::AbstractModule)
    @check_ptrs x
    @assert isNamedModuleUnit(x) "requires a C++20 named module unit"
    return Module_(clang_Module_getGlobalModuleFragment(x))
end

"""
    getPrivateModuleFragment(x::AbstractModule) -> Module_
Return the private module fragment submodule. The returned carrier holds NULL when the
module has none.

`clang::Module::getPrivateModuleFragment` asserts that the receiver is a C++20 named
module unit, so `isNamedModuleUnit(x)` must hold.
"""
function getPrivateModuleFragment(x::AbstractModule)
    @check_ptrs x
    @assert isNamedModuleUnit(x) "requires a C++20 named module unit"
    return Module_(clang_Module_getPrivateModuleFragment(x))
end

"""
    isModuleVisible(x::AbstractModule, other::AbstractModule) -> Bool
Whether `other` would be visible to a lookup at the end of `x`.

The first call builds and caches `x`'s visible-module set; imports added to `x`
afterwards are not reflected in later answers.
"""
function isModuleVisible(x::AbstractModule, other::AbstractModule)
    @check_ptrs x other
    return clang_Module_isModuleVisible(x, other)
end

function getNumExportedModules(x::AbstractModule)
    @check_ptrs x
    return Int(clang_Module_getNumExportedModules(x))
end

"""
    getExportedModules(x::AbstractModule) -> Vector{Module_}
Return the modules `x` exports directly — its non-explicit submodules plus the modules
named by its export declarations. This is a subset of the immediately imported modules,
not the transitive closure.
"""
function getExportedModules(x::AbstractModule)
    @check_ptrs x
    n = clang_Module_getNumExportedModules(x)
    buf = Vector{CXModule_}(undef, n)
    n > 0 && clang_Module_getExportedModules(x, buf)
    return [Module_(p) for p in buf]
end

"""
    getModuleInputBufferName() -> String
Return the name Clang gives the synthetic buffer that includes a module's headers.
"""
getModuleInputBufferName() = unsafe_string(clang_Module_getModuleInputBufferName())

"""
    print(x::AbstractModule, indent::Integer=0, dump_state::Bool=false) -> String
Render the module map for `x`, indented by `indent` columns. `dump_state` adds the
internal state Clang only prints when dumping.
"""
function print(x::AbstractModule, indent::Integer=0, dump_state::Bool=false)
    @check_ptrs x
    return get_string(clang_Module_print(x, indent, dump_state))
end

"""
    dump(x::AbstractModule)
Print the module map for `x` to `llvm::errs()`.
"""
function dump(x::AbstractModule)
    @check_ptrs x
    return clang_Module_dump(x)
end
