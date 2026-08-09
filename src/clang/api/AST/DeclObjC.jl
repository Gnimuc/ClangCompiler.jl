# A `clang::Selector` is a `DeclarationName` variant, so identity crosses through the
# pivot that already exists: `getDeclName` of an `ObjCMethodDecl` is the selector, and two
# selectors are equal iff those `DeclarationName`s are. The accessors below give the other
# half — the spelling, `"initWithFoo:bar:"` — which the pivot cannot.

# ObjCMethodDecl
function getCanonicalDecl(x::AbstractObjCMethodDecl)
    @check_ptrs x
    return ObjCMethodDecl(clang_ObjCMethodDecl_getCanonicalDecl(x))
end

"""
    getClassInterface(x::AbstractObjCMethodDecl) -> ObjCInterfaceDecl
The interface this method belongs to. Wraps `C_NULL` for a method whose container is not
one — a protocol's, for instance.
"""
function getClassInterface(x::AbstractObjCMethodDecl)
    @check_ptrs x
    return ObjCInterfaceDecl(clang_ObjCMethodDecl_getClassInterface(x))
end

"""
    getCategory(x::AbstractObjCMethodDecl) -> ObjCCategoryDecl
The category this method was declared in, or a `C_NULL` carrier when it was declared on the
interface itself.
"""
function getCategory(x::AbstractObjCMethodDecl)
    @check_ptrs x
    return ObjCCategoryDecl(clang_ObjCMethodDecl_getCategory(x))
end

"""
    getSelector(x::AbstractObjCMethodDecl) -> String
The selector's printed form, colons included (`"initWithFoo:bar:"`).
"""
function getSelector(x::AbstractObjCMethodDecl)
    @check_ptrs x
    return get_string(clang_ObjCMethodDecl_getSelector(x))
end

function getReturnType(x::AbstractObjCMethodDecl)
    @check_ptrs x
    return QualType(clang_ObjCMethodDecl_getReturnType(x))
end

function getReturnTypeSourceInfo(x::AbstractObjCMethodDecl)
    @check_ptrs x
    return TypeSourceInfo(clang_ObjCMethodDecl_getReturnTypeSourceInfo(x))
end

function param_size(x::AbstractObjCMethodDecl)
    @check_ptrs x
    return clang_ObjCMethodDecl_param_size(x)
end

function getParamDecl(x::AbstractObjCMethodDecl, i::Integer)
    @check_ptrs x
    @assert 0 <= i < param_size(x) "parameter index $i out of range"
    return ParmVarDecl(clang_ObjCMethodDecl_getParamDecl(x, i))
end

"""
    getNumSelectorLocs(x::AbstractObjCMethodDecl) -> UInt32
The number of selector name segments the source wrote: `param_size` for a method taking
arguments and `1` for a nullary one, but `0` for an implicitly-declared method such as a
synthesized property accessor, which has no written selector to locate.
"""
function getNumSelectorLocs(x::AbstractObjCMethodDecl)
    @check_ptrs x
    return clang_ObjCMethodDecl_getNumSelectorLocs(x)
end

function isInstanceMethod(x::AbstractObjCMethodDecl)
    @check_ptrs x
    return clang_ObjCMethodDecl_isInstanceMethod(x)
end

function isClassMethod(x::AbstractObjCMethodDecl)
    @check_ptrs x
    return clang_ObjCMethodDecl_isClassMethod(x)
end

function isVariadic(x::AbstractObjCMethodDecl)
    @check_ptrs x
    return clang_ObjCMethodDecl_isVariadic(x)
end

function isPropertyAccessor(x::AbstractObjCMethodDecl)
    @check_ptrs x
    return clang_ObjCMethodDecl_isPropertyAccessor(x)
end

"""
    isDefined(x::AbstractObjCMethodDecl) -> Bool
Whether this method is implemented **anywhere in the program**, which is not the same question
as whether this declaration has a body.

Sema sets the bit on the whole redeclaration chain, so an `@interface` declaration of a method
that some `@implementation` defines reports `true` while [`hasBody`](@ref) on that same
declaration reports `false`. A protocol method nobody implements is what reports `false` here.
"""
function isDefined(x::AbstractObjCMethodDecl)
    @check_ptrs x
    return clang_ObjCMethodDecl_isDefined(x)
end

function isThisDeclarationADesignatedInitializer(x::AbstractObjCMethodDecl)
    @check_ptrs x
    return clang_ObjCMethodDecl_isThisDeclarationADesignatedInitializer(x)
end

function hasRelatedResultType(x::AbstractObjCMethodDecl)
    @check_ptrs x
    return clang_ObjCMethodDecl_hasRelatedResultType(x)
end

"""
    isOptional(x::AbstractObjCMethodDecl) -> Bool
Whether the method sits under `@optional` in a protocol. Always `false` on an interface,
where every method is required.
"""
function isOptional(x::AbstractObjCMethodDecl)
    @check_ptrs x
    return clang_ObjCMethodDecl_isOptional(x)
end

# ObjCTypeParamDecl
function getVariance(x::AbstractObjCTypeParamDecl)
    @check_ptrs x
    return clang_ObjCTypeParamDecl_getVariance(x)
end

function getIndex(x::AbstractObjCTypeParamDecl)
    @check_ptrs x
    return clang_ObjCTypeParamDecl_getIndex(x)
end

function hasExplicitBound(x::AbstractObjCTypeParamDecl)
    @check_ptrs x
    return clang_ObjCTypeParamDecl_hasExplicitBound(x)
end

# ObjCContainerDecl
"""
    prop_size(x::AbstractObjCContainerDecl) -> UInt32
The number of `@property` declarations the container holds.
"""
function prop_size(x::AbstractObjCContainerDecl)
    @check_ptrs x
    return clang_ObjCContainerDecl_prop_size(x)
end

function getProperty(x::AbstractObjCContainerDecl, i::Integer)
    @check_ptrs x
    @assert 0 <= i < prop_size(x) "property index $i out of range"
    return ObjCPropertyDecl(clang_ObjCContainerDecl_getProperty(x, i))
end

"""
    meth_size(x::AbstractObjCContainerDecl) -> UInt32
The number of methods the container declares, instance and class alike.
"""
function meth_size(x::AbstractObjCContainerDecl)
    @check_ptrs x
    return clang_ObjCContainerDecl_meth_size(x)
end

function getMethodAt(x::AbstractObjCContainerDecl, i::Integer)
    @check_ptrs x
    @assert 0 <= i < meth_size(x) "method index $i out of range"
    return ObjCMethodDecl(clang_ObjCContainerDecl_getMethodAt(x, i))
end

"""
    getMethod(x::AbstractObjCContainerDecl, selector::AbstractString, ctx::ASTContext;
              is_instance=true, allow_hidden=false) -> ObjCMethodDecl
Look a method up by selector spelling. `ctx` is needed because a selector is interned in
its `ASTContext`. Wraps `C_NULL` when the container declares no such method.
"""
function getMethod(x::AbstractObjCContainerDecl, selector::AbstractString, ctx::ASTContext; is_instance::Bool=true, allow_hidden::Bool=false)
    @check_ptrs x ctx
    return ObjCMethodDecl(clang_ObjCContainerDecl_getMethod(x, String(selector), ctx, is_instance, allow_hidden))
end

function getAtEndRange(x::AbstractObjCContainerDecl)
    @check_ptrs x
    r = clang_ObjCContainerDecl_getAtEndRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

# ObjCInterfaceDecl
"""
    protocol_size(x::AbstractObjCInterfaceDecl) -> UInt32
The number of protocols written on the `@interface` line. `0` on a `@class` forward
declaration, which carries none.
"""
function protocol_size(x::AbstractObjCInterfaceDecl)
    @check_ptrs x
    return clang_ObjCInterfaceDecl_protocol_size(x)
end

function getProtocol(x::AbstractObjCInterfaceDecl, i::Integer)
    @check_ptrs x
    @assert 0 <= i < protocol_size(x) "protocol index $i out of range"
    return ObjCProtocolDecl(clang_ObjCInterfaceDecl_getProtocol(x, i))
end

"""
    all_referenced_protocol_size(x::AbstractObjCInterfaceDecl) -> UInt32
As [`protocol_size`](@ref), plus the protocols a class extension brought in. The two agree
on a class with no extensions.
"""
function all_referenced_protocol_size(x::AbstractObjCInterfaceDecl)
    @check_ptrs x
    return clang_ObjCInterfaceDecl_all_referenced_protocol_size(x)
end

function getAllReferencedProtocol(x::AbstractObjCInterfaceDecl, i::Integer)
    @check_ptrs x
    @assert 0 <= i < all_referenced_protocol_size(x) "protocol index $i out of range"
    return ObjCProtocolDecl(clang_ObjCInterfaceDecl_getAllReferencedProtocol(x, i))
end

"""
    ivar_size(x::AbstractObjCInterfaceDecl) -> UInt32
The number of instance variables in the `@interface` body.
"""
function ivar_size(x::AbstractObjCInterfaceDecl)
    @check_ptrs x
    return clang_ObjCInterfaceDecl_ivar_size(x)
end

function getIvar(x::AbstractObjCInterfaceDecl, i::Integer)
    @check_ptrs x
    @assert 0 <= i < ivar_size(x) "ivar index $i out of range"
    return ObjCIvarDecl(clang_ObjCInterfaceDecl_getIvar(x, i))
end

function hasDefinition(x::AbstractObjCInterfaceDecl)
    @check_ptrs x
    return clang_ObjCInterfaceDecl_hasDefinition(x)
end

function isThisDeclarationADefinition(x::AbstractObjCInterfaceDecl)
    @check_ptrs x
    return clang_ObjCInterfaceDecl_isThisDeclarationADefinition(x)
end

"""
    getDefinition(x::AbstractObjCInterfaceDecl) -> ObjCInterfaceDecl
The declaration carrying the `@interface` body. Wraps `C_NULL` when only a `@class` forward
declaration has been seen, which is what [`hasDefinition`](@ref) reports.
"""
function getDefinition(x::AbstractObjCInterfaceDecl)
    @check_ptrs x
    return ObjCInterfaceDecl(clang_ObjCInterfaceDecl_getDefinition(x))
end

"""
    getSuperClass(x::AbstractObjCInterfaceDecl) -> ObjCInterfaceDecl
The superclass. Wraps `C_NULL` on a root class such as `NSObject`, and on a forward
declaration.
"""
function getSuperClass(x::AbstractObjCInterfaceDecl)
    @check_ptrs x
    return ObjCInterfaceDecl(clang_ObjCInterfaceDecl_getSuperClass(x))
end

"""
    getSuperClassType(x::AbstractObjCInterfaceDecl) -> ObjCObjectType
The superclass as written, with any type arguments. Wraps `C_NULL` on a root class, and on a
forward `@class` declaration — `getSuperClassTInfo` opens with its own `hasDefinition` test
and this reads the result of that, so both are total rather than gated.
"""
function getSuperClassType(x::AbstractObjCInterfaceDecl)
    @check_ptrs x
    return ObjCObjectType(clang_ObjCInterfaceDecl_getSuperClassType(x))
end

function getSuperClassTInfo(x::AbstractObjCInterfaceDecl)
    @check_ptrs x
    return TypeSourceInfo(clang_ObjCInterfaceDecl_getSuperClassTInfo(x))
end

"""
    getNumTypeParams(x::AbstractObjCInterfaceDecl) -> UInt32
The number of type parameters of a generic class (`@interface NSArray<T>`); `0` on a
non-generic one.
"""
function getNumTypeParams(x::AbstractObjCInterfaceDecl)
    @check_ptrs x
    return clang_ObjCInterfaceDecl_getNumTypeParams(x)
end

function getTypeParam(x::AbstractObjCInterfaceDecl, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumTypeParams(x) "type parameter index $i out of range"
    return ObjCTypeParamDecl(clang_ObjCInterfaceDecl_getTypeParam(x, i))
end

function getCanonicalDecl(x::AbstractObjCInterfaceDecl)
    @check_ptrs x
    return ObjCInterfaceDecl(clang_ObjCInterfaceDecl_getCanonicalDecl(x))
end

# ObjCProtocolDecl
"""
    protocol_size(x::AbstractObjCProtocolDecl) -> UInt32
The number of protocols this one inherits. `0` on a forward `@protocol` declaration.
"""
function protocol_size(x::AbstractObjCProtocolDecl)
    @check_ptrs x
    return clang_ObjCProtocolDecl_protocol_size(x)
end

function getProtocol(x::AbstractObjCProtocolDecl, i::Integer)
    @check_ptrs x
    @assert 0 <= i < protocol_size(x) "protocol index $i out of range"
    return ObjCProtocolDecl(clang_ObjCProtocolDecl_getProtocol(x, i))
end

function hasDefinition(x::AbstractObjCProtocolDecl)
    @check_ptrs x
    return clang_ObjCProtocolDecl_hasDefinition(x)
end

function isThisDeclarationADefinition(x::AbstractObjCProtocolDecl)
    @check_ptrs x
    return clang_ObjCProtocolDecl_isThisDeclarationADefinition(x)
end

function getDefinition(x::AbstractObjCProtocolDecl)
    @check_ptrs x
    return ObjCProtocolDecl(clang_ObjCProtocolDecl_getDefinition(x))
end

function getCanonicalDecl(x::AbstractObjCProtocolDecl)
    @check_ptrs x
    return ObjCProtocolDecl(clang_ObjCProtocolDecl_getCanonicalDecl(x))
end

# ObjCCategoryDecl
function getClassInterface(x::AbstractObjCCategoryDecl)
    @check_ptrs x
    return ObjCInterfaceDecl(clang_ObjCCategoryDecl_getClassInterface(x))
end

function protocol_size(x::AbstractObjCCategoryDecl)
    @check_ptrs x
    return clang_ObjCCategoryDecl_protocol_size(x)
end

function getProtocol(x::AbstractObjCCategoryDecl, i::Integer)
    @check_ptrs x
    @assert 0 <= i < protocol_size(x) "protocol index $i out of range"
    return ObjCProtocolDecl(clang_ObjCCategoryDecl_getProtocol(x, i))
end

function getNextClassCategory(x::AbstractObjCCategoryDecl)
    @check_ptrs x
    return ObjCCategoryDecl(clang_ObjCCategoryDecl_getNextClassCategory(x))
end

"""
    IsClassExtension(x::AbstractObjCCategoryDecl) -> Bool
Whether this is an unnamed category, i.e. a class extension `@interface Foo ()`.
"""
function IsClassExtension(x::AbstractObjCCategoryDecl)
    @check_ptrs x
    return clang_ObjCCategoryDecl_IsClassExtension(x)
end

function ivar_size(x::AbstractObjCCategoryDecl)
    @check_ptrs x
    return clang_ObjCCategoryDecl_ivar_size(x)
end

function getIvar(x::AbstractObjCCategoryDecl, i::Integer)
    @check_ptrs x
    @assert 0 <= i < ivar_size(x) "ivar index $i out of range"
    return ObjCIvarDecl(clang_ObjCCategoryDecl_getIvar(x, i))
end

function getCategoryNameLoc(x::AbstractObjCCategoryDecl)
    @check_ptrs x
    return SourceLocation(clang_ObjCCategoryDecl_getCategoryNameLoc(x))
end

# ObjCPropertyDecl
function getType(x::AbstractObjCPropertyDecl)
    @check_ptrs x
    return QualType(clang_ObjCPropertyDecl_getType(x))
end

function getTypeSourceInfo(x::AbstractObjCPropertyDecl)
    @check_ptrs x
    return TypeSourceInfo(clang_ObjCPropertyDecl_getTypeSourceInfo(x))
end

"""
    getPropertyAttributes(x::AbstractObjCPropertyDecl) -> UInt32
The attributes in force, written or defaulted, OR-ed into one bit set. The
`CXObjCPropertyAttributeKind_*` enumerators name the individual bits, so test with
`attrs & UInt32(CXObjCPropertyAttributeKind_readonly) != 0` rather than with `==`. The bits
come back as a plain integer because an OR of two of them is not itself an enumerator, and
a Julia `@enum` value holding one prints as `<invalid #N>`.
"""
function getPropertyAttributes(x::AbstractObjCPropertyDecl)
    @check_ptrs x
    bits = clang_ObjCPropertyDecl_getPropertyAttributes(x)
    return UInt32(bits)
end

"""
    getPropertyAttributesAsWritten(x::AbstractObjCPropertyDecl) -> UInt32
As [`getPropertyAttributes`](@ref), but only the attributes the source spelled out.
"""
function getPropertyAttributesAsWritten(x::AbstractObjCPropertyDecl)
    @check_ptrs x
    bits = clang_ObjCPropertyDecl_getPropertyAttributesAsWritten(x)
    return UInt32(bits)
end

"""
    getGetterName(x::AbstractObjCPropertyDecl) -> String
The getter selector's printed form, whether written with `getter=` or defaulted.
"""
function getGetterName(x::AbstractObjCPropertyDecl)
    @check_ptrs x
    return get_string(clang_ObjCPropertyDecl_getGetterName(x))
end

"""
    getSetterName(x::AbstractObjCPropertyDecl) -> String
The setter selector's printed form. Non-empty on a `readonly` property too: clang derives the
default selector from the property name whatever the attributes say, so `readonly int count`
still reports `"setCount:"`. It is [`getSetterMethodDecl`](@ref) that is null when no setter
exists.
"""
function getSetterName(x::AbstractObjCPropertyDecl)
    @check_ptrs x
    return get_string(clang_ObjCPropertyDecl_getSetterName(x))
end

"""
    getGetterMethodDecl(x::AbstractObjCPropertyDecl) -> ObjCMethodDecl
The method the getter resolves to. Wraps `C_NULL` until Sema has synthesized it.
"""
function getGetterMethodDecl(x::AbstractObjCPropertyDecl)
    @check_ptrs x
    return ObjCMethodDecl(clang_ObjCPropertyDecl_getGetterMethodDecl(x))
end

"""
    getSetterMethodDecl(x::AbstractObjCPropertyDecl) -> ObjCMethodDecl
The method the setter resolves to. Always wraps `C_NULL` on a `readonly` property.
"""
function getSetterMethodDecl(x::AbstractObjCPropertyDecl)
    @check_ptrs x
    return ObjCMethodDecl(clang_ObjCPropertyDecl_getSetterMethodDecl(x))
end

function isReadOnly(x::AbstractObjCPropertyDecl)
    @check_ptrs x
    return clang_ObjCPropertyDecl_isReadOnly(x)
end

function isAtomic(x::AbstractObjCPropertyDecl)
    @check_ptrs x
    return clang_ObjCPropertyDecl_isAtomic(x)
end

function isInstanceProperty(x::AbstractObjCPropertyDecl)
    @check_ptrs x
    return clang_ObjCPropertyDecl_isInstanceProperty(x)
end

function isClassProperty(x::AbstractObjCPropertyDecl)
    @check_ptrs x
    return clang_ObjCPropertyDecl_isClassProperty(x)
end

function isOptional(x::AbstractObjCPropertyDecl)
    @check_ptrs x
    return clang_ObjCPropertyDecl_isOptional(x)
end

function getAtLoc(x::AbstractObjCPropertyDecl)
    @check_ptrs x
    return SourceLocation(clang_ObjCPropertyDecl_getAtLoc(x))
end

# ObjCIvarDecl
"""
    getAccessControl(x::AbstractObjCIvarDecl) -> CXObjCIvarDecl_AccessControl
The access control as written. `CXObjCIvarDecl_None` when the ivar was written without one;
[`getCanonicalAccessControl`](@ref) resolves that to the default clang applies.
"""
function getAccessControl(x::AbstractObjCIvarDecl)
    @check_ptrs x
    return clang_ObjCIvarDecl_getAccessControl(x)
end

"""
    getCanonicalAccessControl(x::AbstractObjCIvarDecl) -> CXObjCIvarDecl_AccessControl
The effective access control, never `CXObjCIvarDecl_None`: `@protected` for an ivar in an
`@interface`, `@private` for one in an `@implementation`.
"""
function getCanonicalAccessControl(x::AbstractObjCIvarDecl)
    @check_ptrs x
    return clang_ObjCIvarDecl_getCanonicalAccessControl(x)
end

"""
    getContainingInterface(x::AbstractObjCIvarDecl) -> ObjCInterfaceDecl
The interface this ivar belongs to.

Clang reaches it through an unchecked `cast<ObjCContainerDecl>` of the declaration context and
is `llvm_unreachable` for a protocol or a category implementation, so the container is asserted
here rather than checked there. A category is only a valid container when it is a class
extension — a named category cannot declare ivars — which is clang's own assertion.
"""
function getContainingInterface(x::AbstractObjCIvarDecl)
    @check_ptrs x
    dc = resolve(castFromDeclContext(getDeclContext(x)))
    ok = dc isa AbstractObjCInterfaceDecl || dc isa AbstractObjCImplementationDecl ||
         (dc isa AbstractObjCCategoryDecl && IsClassExtension(dc))
    @assert ok "ivar container must be an @interface, an @implementation or a class extension"
    return ObjCInterfaceDecl(clang_ObjCIvarDecl_getContainingInterface(x))
end

"""
    getNextIvar(x::AbstractObjCIvarDecl) -> ObjCIvarDecl
The next ivar in the containing interface's chain. Wraps `C_NULL` at the end.
"""
function getNextIvar(x::AbstractObjCIvarDecl)
    @check_ptrs x
    return ObjCIvarDecl(clang_ObjCIvarDecl_getNextIvar(x))
end

function getSynthesize(x::AbstractObjCIvarDecl)
    @check_ptrs x
    return clang_ObjCIvarDecl_getSynthesize(x)
end

# ObjCCompatibleAliasDecl
function getClassInterface(x::AbstractObjCCompatibleAliasDecl)
    @check_ptrs x
    return ObjCInterfaceDecl(clang_ObjCCompatibleAliasDecl_getClassInterface(x))
end

# ObjCImplDecl
function getClassInterface(x::AbstractObjCImplDecl)
    @check_ptrs x
    return ObjCInterfaceDecl(clang_ObjCImplDecl_getClassInterface(x))
end

# ObjCImplementationDecl
function getSuperClass(x::AbstractObjCImplementationDecl)
    @check_ptrs x
    return ObjCInterfaceDecl(clang_ObjCImplementationDecl_getSuperClass(x))
end

# ObjCCategoryImplDecl
function getCategoryDecl(x::AbstractObjCCategoryImplDecl)
    @check_ptrs x
    return ObjCCategoryDecl(clang_ObjCCategoryImplDecl_getCategoryDecl(x))
end
