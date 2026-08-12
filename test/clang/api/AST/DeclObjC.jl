using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose
using Test

const LXO = CC.LibClangEx

# `-fobjc-runtime=macosx` rather than the default, and it is not about macOS. Clang picks the
# runtime from the target: Darwin gets the non-fragile ABI, every other platform gets the
# fragile GNU one, where `instance variables may not be placed in class extension` is an error.
# A class extension is the only category that may declare ivars, so without this pin the
# category-side `getIvar` is unreachable on two of the three CI hosts — and the fixture below
# does not parse there at all. Pinning is the same move `pinned_target.jl` makes for the
# target: it takes the host out of the answer. Nothing here executes, so the runtime only has
# to be one clang will parse for.
const OBJC_ARGS = ["-x", "objective-c++", "-fobjc-runtime=macosx"]

# Objective-C++ rather than plain Objective-C: `-x objective-c` puts the incremental parser
# in C mode, where the builtin `id` is as unreachable as `__builtin_va_list` is (see
# `create_interpreter`). Nothing below is C++-specific, and nothing below includes a header,
# so the default C++ build environment is left alone — `is_cxx=false` would only swap which
# shard's system includes are on a search path this source never uses.
const OBJC_SRC = """
@protocol NSCopying
- (id)copyWithZone:(void *)zone;
@end

@protocol Extra <NSCopying>
@optional
- (int)extraValue;
@end

@interface Base <NSCopying>
{
    int _ivarA;
  @public
    double _ivarB;
}
@property (readonly, nonatomic) int count;
@property (copy) id name;
+ (instancetype)create;
- (int)addTo:(int)a with:(int)b;
@end

@interface Derived : Base <Extra>
@end

@interface TwoProto <NSCopying, Extra>
@end

@interface Ext : Base
@end

@interface Ext () <NSCopying, Extra>
{
    int _extIvar;
    int _extIvar2;
}
@end

@interface Base (Cat)
- (void)catMethod;
@end

@interface Base (Cat2)
- (void)cat2Method;
@end

@interface Gen<__covariant T, U : Base *> : Base
- (T)item;
@end

@interface Impl : Base
- (instancetype)initWithValue:(int)v __attribute__((objc_designated_initializer));
@end

@implementation Impl
- (instancetype)initWithValue:(int)v { return self; }
@end

@interface Impl (ICat)
- (void)icatMethod;
@end

@implementation Impl (ICat)
- (void)icatMethod {}
@end

@class Fwd;
@compatibility_alias AliasName Base;

__attribute__((availability(macos, introduced=10.9, deprecated=11.0,
                            obsoleted=12.0, message="gone")))
@interface Old : Base
@end

__attribute__((availability(macos, unavailable, replacement="NewThing")))
@interface Gone : Base
@end

__attribute__((availability(macos, introduced=10.9, strict)))
@interface Strictly : Base
@end

Base *g_base;
Derived<Extra> *g_qual;
id<NSCopying> g_idq;
Gen<Base *, Base *> *g_spec;
Base<NSCopying> *g_qualobj;
id g_id;
Class g_cls;
"""

@testset "DeclObjC | interfaces, protocols, categories, properties, methods, ivars" begin
    I = create_interpreter(OBJC_ARGS)
    ptu = CC.parse(I, OBJC_SRC)
    @test !CC.is_null_handle(ptu)
    ctx = CC.get_ast_context(I)
    # A TU scan rather than `DeclFinder`: ordinary lookup does not reach @protocol names,
    # which live in their own namespace, and it resolves a @compatibility_alias to the
    # interface it aliases rather than to the alias declaration.
    top = collect(CC.decls_in(CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))))
    lookup(name) = only(filter(d -> d isa CC.AbstractNamedDecl && CC.getNameAsString(d) == name, top))

    # ---- resolve reaches the ObjC carriers, which it could not before -------------------
    base = lookup("Base")
    @test base isa CC.ObjCInterfaceDecl
    @test lookup("NSCopying") isa CC.ObjCProtocolDecl
    @test lookup("AliasName") isa CC.ObjCCompatibleAliasDecl

    # ---- ObjCInterfaceDecl -------------------------------------------------------------
    @test CC.hasDefinition(base) == true
    @test CC.isThisDeclarationADefinition(base) == true
    @test CC.getDefinition(base).ptr == base.ptr
    @test CC.getCanonicalDecl(base).ptr == base.ptr
    # A root class: no superclass, and the type accessors say so rather than pointing at one.
    @test CC.is_null_handle(CC.getSuperClass(base))
    @test CC.is_null_handle(CC.getSuperClassType(base))
    @test CC.getNumTypeParams(base) == 0

    @test CC.protocol_size(base) == 1
    @test CC.getNameAsString(CC.getProtocol(base, 0)) == "NSCopying"
    @test CC.all_referenced_protocol_size(base) == 1
    @test CC.getNameAsString(CC.getAllReferencedProtocol(base, 0)) == "NSCopying"
    @test_throws AssertionError CC.getProtocol(base, 1)
    @test_throws AssertionError CC.getAllReferencedProtocol(base, 1)

    # `Base` alone cannot tell an indexing accessor from one that always returns the first
    # protocol: with a single-element list the two are the same function. Two protocols, read
    # in the written order, is what makes the index load-bearing.
    two = lookup("TwoProto")
    @test CC.protocol_size(two) == 2
    @test CC.getNameAsString(CC.getProtocol(two, 0)) == "NSCopying"
    @test CC.getNameAsString(CC.getProtocol(two, 1)) == "Extra"
    @test_throws AssertionError CC.getProtocol(two, 2)

    # ---- a forward @class declaration ---------------------------------------------------
    fwd = lookup("Fwd")
    @test fwd isa CC.ObjCInterfaceDecl
    @test CC.hasDefinition(fwd) == false
    @test CC.is_null_handle(CC.getDefinition(fwd))
    # Total on a forward declaration, where clang reports an empty list...
    @test CC.protocol_size(fwd) == 0
    @test CC.ivar_size(fwd) == 0
    @test CC.is_null_handle(CC.getSuperClass(fwd))
    # ...and so are the two superclass-type accessors, which guard themselves upstream.
    @test CC.is_null_handle(CC.getSuperClassType(fwd))
    @test CC.is_null_handle(CC.getSuperClassTInfo(fwd))

    # ---- ivars --------------------------------------------------------------------------
    @test CC.ivar_size(base) == 2
    iva, ivb = CC.getIvar(base, 0), CC.getIvar(base, 1)
    @test CC.getNameAsString(iva) == "_ivarA"
    @test CC.getNameAsString(ivb) == "_ivarB"
    # `_ivarA` is written without an access specifier and defaults to @protected in an
    # @interface; `_ivarB` is written @public. Both accessors agree once one is written.
    @test CC.getAccessControl(iva) == LXO.CXObjCIvarDecl_Protected
    @test CC.getCanonicalAccessControl(iva) == LXO.CXObjCIvarDecl_Protected
    @test CC.getAccessControl(ivb) == LXO.CXObjCIvarDecl_Public
    @test CC.getCanonicalAccessControl(ivb) == LXO.CXObjCIvarDecl_Public
    @test CC.getContainingInterface(iva).ptr == base.ptr
    @test CC.getNameAsString(CC.getNextIvar(iva)) == "_ivarB"
    @test CC.is_null_handle(CC.getNextIvar(ivb))
    @test CC.getSynthesize(iva) == false
    # The ivar type comes through the inherited FieldDecl/ValueDecl surface.
    @test CC.getAsString(CC.getType(iva)) == "int"
    @test_throws AssertionError CC.getIvar(base, 2)

    # ---- properties ---------------------------------------------------------------------
    @test CC.prop_size(base) == 2
    props = Dict(CC.getNameAsString(CC.getProperty(base, i)) => CC.getProperty(base, i)
                 for i = 0:(CC.prop_size(base) - 1))
    count_p, name_p = props["count"], props["name"]

    @test CC.getAsString(CC.getType(count_p)) == "int"
    @test CC.getGetterName(count_p) == "count"
    @test CC.isReadOnly(count_p) == true
    @test CC.isAtomic(count_p) == false            # (nonatomic)
    @test CC.isInstanceProperty(count_p) == true
    @test CC.isClassProperty(count_p) == false
    @test CC.isOptional(count_p) == false
    @test !CC.is_null_handle(CC.getAtLoc(count_p))
    @test !CC.is_null_handle(CC.getTypeSourceInfo(count_p))
    # A readonly property has a getter and no setter method, whatever name clang defaults.
    @test !CC.is_null_handle(CC.getGetterMethodDecl(count_p))
    @test CC.is_null_handle(CC.getSetterMethodDecl(count_p))

    @test CC.getSetterName(name_p) == "setName:"
    @test CC.isReadOnly(name_p) == false
    @test CC.isAtomic(name_p) == true              # no (nonatomic) written
    @test !CC.is_null_handle(CC.getSetterMethodDecl(name_p))

    # The attributes are a bit set, so each is tested by masking. `readonly` and `nonatomic`
    # are both written on `count`; `copy` is written on `name` and `readonly` is not.
    ro = UInt32(LXO.CXObjCPropertyAttributeKind_readonly)
    na = UInt32(LXO.CXObjCPropertyAttributeKind_nonatomic)
    cp = UInt32(LXO.CXObjCPropertyAttributeKind_copy)
    @test CC.getPropertyAttributes(count_p) & ro != 0
    @test CC.getPropertyAttributes(count_p) & na != 0
    @test CC.getPropertyAttributes(count_p) & cp == 0
    @test CC.getPropertyAttributes(name_p) & cp != 0
    @test CC.getPropertyAttributes(name_p) & ro == 0
    # As-written is a subset of in-force: `count` gets `readwrite`-family defaults it never
    # spelled, so the two differ while every written bit survives in both.
    @test CC.getPropertyAttributesAsWritten(count_p) & ro != 0
    @test CC.getPropertyAttributesAsWritten(count_p) & na != 0
    @test CC.getPropertyAttributesAsWritten(count_p) & CC.getPropertyAttributes(count_p) ==
          CC.getPropertyAttributesAsWritten(count_p)
    @test_throws AssertionError CC.getProperty(base, 2)

    # ---- methods -------------------------------------------------------------------------
    # Five: the two written, plus the three accessors Sema synthesized for the properties.
    @test CC.meth_size(base) == 5
    meths = Dict(CC.getSelector(CC.getMethodAt(base, i)) => CC.getMethodAt(base, i) for i = 0:(CC.meth_size(base) - 1))
    @test sort(collect(keys(meths))) == ["addTo:with:", "count", "create", "name", "setName:"]

    add = meths["addTo:with:"]
    @test CC.isInstanceMethod(add) == true
    @test CC.isClassMethod(add) == false
    @test CC.getAsString(CC.getReturnType(add)) == "int"
    @test CC.param_size(add) == 2
    @test CC.getNameAsString(CC.getParamDecl(add, 0)) == "a"
    @test CC.getNameAsString(CC.getParamDecl(add, 1)) == "b"
    @test_throws AssertionError CC.getParamDecl(add, 2)
    @test CC.getNumSelectorLocs(add) == 2          # two written segments
    @test CC.isVariadic(add) == false
    @test CC.isPropertyAccessor(add) == false
    @test CC.getClassInterface(add).ptr == base.ptr
    @test CC.is_null_handle(CC.getCategory(add))   # declared on the interface, not a category
    @test CC.getCanonicalDecl(add).ptr == add.ptr
    @test CC.isOptional(add) == false

    create = meths["create"]
    @test CC.isClassMethod(create) == true
    @test CC.isInstanceMethod(create) == false
    @test CC.getNumSelectorLocs(create) == 1       # nullary selector
    @test CC.hasRelatedResultType(create) == true  # `instancetype`

    getter = meths["count"]
    @test CC.isPropertyAccessor(getter) == true
    @test CC.getGetterMethodDecl(count_p).ptr == getter.ptr
    # Implicitly declared, so there is no written selector to locate.
    @test CC.getNumSelectorLocs(getter) == 0

    # Lookup by spelling finds the same nodes, and distinguishes instance from class.
    @test CC.getMethod(base, "addTo:with:", ctx).ptr == add.ptr
    @test CC.getMethod(base, "create", ctx; is_instance=false).ptr == create.ptr
    @test CC.is_null_handle(CC.getMethod(base, "create", ctx))               # not an instance method
    @test CC.is_null_handle(CC.getMethod(base, "addTo:with:", ctx; is_instance=false))
    @test CC.is_null_handle(CC.getMethod(base, "nosuchSelector", ctx))
    @test_throws AssertionError CC.getMethodAt(base, CC.meth_size(base))
    @test !CC.is_null_handle(CC.getAtEndRange(base).begin_loc)

    # ---- inheritance and protocols ---------------------------------------------------------
    derived = lookup("Derived")
    @test derived isa CC.ObjCInterfaceDecl
    @test CC.getSuperClass(derived).ptr == base.ptr
    @test CC.getNameAsString(CC.getInterface(CC.getSuperClassType(derived))) == "Base"
    @test !CC.is_null_handle(CC.getSuperClassTInfo(derived))
    @test CC.protocol_size(derived) == 1
    @test CC.getNameAsString(CC.getProtocol(derived, 0)) == "Extra"

    extra = lookup("Extra")
    @test extra isa CC.ObjCProtocolDecl
    @test CC.hasDefinition(extra) == true
    @test CC.isThisDeclarationADefinition(extra) == true
    @test CC.getDefinition(extra).ptr == extra.ptr
    @test CC.getCanonicalDecl(extra).ptr == extra.ptr
    @test CC.protocol_size(extra) == 1             # inherits NSCopying
    @test CC.getNameAsString(CC.getProtocol(extra, 0)) == "NSCopying"
    @test_throws AssertionError CC.getProtocol(extra, 1)
    # @optional is the one thing that distinguishes a protocol method from an interface's.
    @test CC.meth_size(extra) == 1
    @test CC.isOptional(CC.getMethodAt(extra, 0)) == true
    @test CC.protocol_size(lookup("NSCopying")) == 0

    # ---- category --------------------------------------------------------------------------
    # A category's methods are its own, not the interface's: looking `catMethod` up through
    # `Base` finds nothing even with hidden methods allowed.
    @test CC.is_null_handle(CC.getMethod(base, "catMethod", ctx; allow_hidden=true))
    category = lookup("Cat")
    @test category isa CC.ObjCCategoryDecl
    @test CC.getClassInterface(category).ptr == base.ptr
    catmeth = CC.getMethod(category, "catMethod", ctx)
    @test !CC.is_null_handle(catmeth)
    @test CC.getCategory(catmeth).ptr == category.ptr
    @test CC.getClassInterface(catmeth).ptr == base.ptr
    @test CC.IsClassExtension(category) == false
    @test CC.protocol_size(category) == 0
    @test CC.ivar_size(category) == 0
    @test !CC.is_null_handle(CC.getCategoryNameLoc(category))
    @test CC.meth_size(category) == 1
    @test CC.getSelector(CC.getMethodAt(category, 0)) == "catMethod"

    # A class extension — an unnamed category — is the only category that may declare ivars,
    # and is the only route to the two category accessors below. `Cat` above exercises the
    # empty case for both, which passes just as well against an accessor that always says
    # empty.
    ext = only(filter(d -> d isa CC.ObjCCategoryDecl && CC.IsClassExtension(d), top))
    @test CC.getNameAsString(CC.getClassInterface(ext)) == "Ext"
    @test CC.getNameAsString(ext) == ""             # a class extension is unnamed
    @test CC.protocol_size(ext) == 2
    @test CC.getNameAsString(CC.getProtocol(ext, 0)) == "NSCopying"
    @test CC.getNameAsString(CC.getProtocol(ext, 1)) == "Extra"
    @test_throws AssertionError CC.getProtocol(ext, 2)
    @test CC.ivar_size(ext) == 2
    ext_ivar = CC.getIvar(ext, 0)
    @test CC.getNameAsString(ext_ivar) == "_extIvar"
    @test CC.getNameAsString(CC.getIvar(ext, 1)) == "_extIvar2"
    @test_throws AssertionError CC.getIvar(ext, 2)
    # The ivar's container is the extension, but the interface it belongs to is the class the
    # extension extends — which is the whole reason this accessor is not `getDeclContext`.
    @test CC.getNameAsString(CC.getContainingInterface(ext_ivar)) == "Ext"

    # `allReferencedProtocols` is the written list PLUS whatever the class extensions add — not
    # the transitive closure through protocol inheritance, which is what it looks like. `Ext`
    # writes no protocols of its own and its extension adds two, so this is the one fixture
    # here where the two accessors disagree; on `Base`, `Derived` and `TwoProto` they return
    # the same list, and asserting there cannot tell them apart.
    ext_iface = lookup("Ext")
    @test CC.protocol_size(ext_iface) == 0
    @test CC.all_referenced_protocol_size(ext_iface) == 2
    @test [CC.getNameAsString(CC.getAllReferencedProtocol(ext_iface, i)) for i = 0:1] == ["NSCopying", "Extra"]
    @test_throws AssertionError CC.getAllReferencedProtocol(ext_iface, 2)

    # ---- generics ----------------------------------------------------------------------------
    # Two parameters, differing in variance and in whether a bound is written: read on a
    # single unbounded invariant parameter, all three accessors answer the value they would
    # answer if they ignored their subject entirely.
    gen = lookup("Gen")
    @test CC.getNumTypeParams(gen) == 2
    tp, up = CC.getTypeParam(gen, 0), CC.getTypeParam(gen, 1)
    @test CC.getNameAsString(tp) == "T"
    @test CC.getNameAsString(up) == "U"
    @test CC.getIndex(tp) == 0
    @test CC.getIndex(up) == 1
    @test CC.getVariance(tp) == LXO.CXObjCTypeParamVariance_Covariant
    @test CC.getVariance(up) == LXO.CXObjCTypeParamVariance_Invariant
    @test CC.hasExplicitBound(tp) == false
    @test CC.hasExplicitBound(up) == true
    @test_throws AssertionError CC.getTypeParam(gen, 2)

    # ---- @implementation ------------------------------------------------------------------------
    # An interface and its implementation share a name, so these come off the class rather
    # than out of `lookup`.
    impl = only(filter(d -> d isa CC.ObjCImplementationDecl, top))
    @test CC.getNameAsString(CC.getClassInterface(impl)) == "Impl"
    # `@implementation Impl` does not restate the superclass, and clang records only what
    # was written -- so this is null even though the interface has one.
    @test CC.is_null_handle(CC.getSuperClass(impl))

    catimpl = only(filter(d -> d isa CC.ObjCCategoryImplDecl, top))
    @test CC.getNameAsString(CC.getCategoryDecl(catimpl)) == "ICat"
    @test CC.getNameAsString(CC.getClassInterface(catimpl)) == "Impl"

    # A class's categories are a chain, most recently declared first, so `Cat2` -> `Cat` and
    # `Cat` ends it. One category alone cannot tell a working accessor from a null one.
    cat2 = lookup("Cat2")
    @test CC.getNextClassCategory(cat2).ptr == category.ptr
    @test CC.is_null_handle(CC.getNextClassCategory(category))

    # ---- designated initializer ------------------------------------------------------------------
    impl_iface = only(filter(d -> d isa CC.ObjCInterfaceDecl && CC.getNameAsString(d) == "Impl", top))
    init = CC.getMethod(impl_iface, "initWithValue:", ctx)
    @test !CC.is_null_handle(init)
    @test CC.isThisDeclarationADesignatedInitializer(init) == true
    @test CC.isThisDeclarationADesignatedInitializer(add) == false
    # `isDefined` is a program-wide question, not a per-declaration one: Sema sets it along
    # the whole chain, so the bodyless @interface declaration reports true and `hasBody` is
    # what separates the two declarations. A protocol method nobody implements is the false
    # case, and without it this pair of trues would also fit an accessor stuck on.
    impl_init = CC.getMethod(impl, "initWithValue:", ctx)
    @test CC.isDefined(init) == true
    @test CC.isDefined(impl_init) == true
    @test CC.hasBody(init) == false
    @test CC.hasBody(impl_init) == true
    @test CC.isDefined(CC.getMethod(lookup("NSCopying"), "copyWithZone:", ctx)) == false
    @test !CC.is_null_handle(CC.getReturnTypeSourceInfo(init))

    # ---- compatibility alias -------------------------------------------------------------------
    @test CC.getClassInterface(lookup("AliasName")).ptr == base.ptr

    dispose(I)
end

@testset "DeclObjC | the four object types and AvailabilityAttr" begin
    I = create_interpreter(OBJC_ARGS)
    @test !CC.is_null_handle(CC.parse(I, OBJC_SRC))
    ctx = CC.get_ast_context(I)
    top = collect(CC.decls_in(CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))))
    lookup(name) = only(filter(d -> d isa CC.AbstractNamedDecl && CC.getNameAsString(d) == name, top))
    vartype(name) = CC.resolve(CC.getTypePtr(CC.getType(lookup(name))))

    # `Base *` — an unqualified, unspecialized interface pointer. Its pointee resolving to
    # ObjCInterfaceType rather than UnexposedType is what the new carrier buys.
    bp = vartype("g_base")
    @test bp isa CC.ObjCObjectPointerType
    pointee = CC.resolve(CC.getTypePtr(CC.getPointeeType(bp)))
    @test pointee isa CC.ObjCInterfaceType
    @test CC.getNameAsString(CC.getDecl(pointee)) == "Base"
    # The stamped cast for the new carrier, both directions. `resolve` above asked clang the
    # class; this is the same question spelled `cast<T>`, and the refusal is what says the
    # cast is checked against clang's `classof` rather than reinterpreting a pointer.
    bp_pointee = CC.getTypePtr(CC.getPointeeType(bp))
    @test CC.ObjCInterfaceType(bp_pointee).ptr == pointee.ptr
    @test_throws CC.CastError CC.ObjCTypeParamType(bp_pointee)
    @test CC.isSugared(pointee) == false
    @test CC.getAsString(CC.desugar(pointee)) == "Base"
    @test CC.getNameAsString(CC.getInterfaceDecl(bp)) == "Base"
    @test CC.isObjCIdType(bp) == false
    @test CC.isObjCClassType(bp) == false
    @test CC.isObjCQualifiedIdType(bp) == false
    @test CC.getNumProtocols(bp) == 0
    @test_throws AssertionError CC.getProtocol(bp, 0)
    @test CC.isSugared(bp) == false
    @test CC.getAsString(CC.desugar(bp)) == "Base *"

    bobj = CC.getObjectType(bp)
    @test CC.getAsString(CC.getBaseType(bobj)) == "Base"
    @test CC.getNameAsString(CC.getInterface(bobj)) == "Base"
    @test CC.isObjCId(bobj) == false
    @test CC.isObjCClass(bobj) == false
    @test CC.isSpecialized(bobj) == false
    @test CC.isKindOfType(bobj) == false
    @test CC.getNumTypeArgs(bobj) == 0
    @test_throws AssertionError CC.getTypeArg(bobj, 0)
    @test CC.getNumProtocols(bobj) == 0
    @test CC.isSugared(bobj) == false
    # Base is a root class, so the substituted superclass is a null QualType.
    @test CC.is_null_handle(CC.getSuperClassType(bobj))

    # `Derived<Extra> *` — protocol-qualified, so the pointee is an ObjCObjectType carrying
    # the qualifier rather than a bare interface type.
    qp = vartype("g_qual")
    @test CC.resolve(CC.getTypePtr(CC.getPointeeType(qp))) isa CC.ObjCObjectType
    @test CC.getNumProtocols(qp) == 1
    @test CC.getNameAsString(CC.getProtocol(qp, 0)) == "Extra"
    @test CC.getNameAsString(CC.getInterfaceDecl(qp)) == "Derived"
    qobj = CC.getObjectType(qp)
    @test CC.getNumProtocols(qobj) == 1
    @test CC.getNameAsString(CC.getProtocol(qobj, 0)) == "Extra"
    @test_throws AssertionError CC.getProtocol(qobj, 1)
    # Derived's superclass is Base, so here the substituted superclass is not null.
    @test CC.getAsString(CC.getSuperClassType(qobj)) == "Base"

    # `id<NSCopying>` — a qualified id: no interface at all, and the id predicates fire.
    idq = vartype("g_idq")
    @test CC.isObjCQualifiedIdType(idq) == true
    @test CC.is_null_handle(CC.getInterfaceDecl(idq))
    idobj = CC.getObjectType(idq)
    @test CC.isObjCId(idobj) == true
    @test CC.isObjCUnqualifiedId(idobj) == false   # a protocol is written
    @test CC.isObjCQualifiedId(idobj) == true
    @test CC.is_null_handle(CC.getInterface(idobj))
    @test CC.getNumProtocols(idobj) == 1
    @test CC.getNameAsString(CC.getProtocol(idobj, 0)) == "NSCopying"

    # `Gen<Base *> *` — specialized, so the type argument list is populated.
    sp = CC.getObjectType(vartype("g_spec"))
    @test CC.isSpecialized(sp) == true
    @test CC.getNumTypeArgs(sp) == 2
    @test CC.getAsString(CC.getTypeArg(sp, 0)) == "Base *"
    @test CC.getAsString(CC.getTypeArg(sp, 1)) == "Base *"
    @test_throws AssertionError CC.getTypeArg(sp, 2)

    # ObjCTypeParamType: `- (T)item` inside a generic interface returns the parameter itself.
    gen = lookup("Gen")
    item = CC.getMethod(gen, "item", ctx)
    @test !CC.is_null_handle(item)
    tpt = CC.resolve(CC.getTypePtr(CC.getReturnType(item)))
    @test tpt isa CC.ObjCTypeParamType
    @test CC.getNameAsString(CC.getDecl(tpt)) == "T"
    ret_ptr = CC.getTypePtr(CC.getReturnType(item))
    @test CC.ObjCTypeParamType(ret_ptr).ptr == tpt.ptr
    @test_throws CC.CastError CC.ObjCInterfaceType(ret_ptr)
    @test CC.getNumProtocols(tpt) == 0
    @test_throws AssertionError CC.getProtocol(tpt, 0)
    # An unbounded parameter is sugar for `id`, which is what makes it sugared where the
    # object types above are not.
    @test CC.isSugared(tpt) == true
    @test CC.getAsString(CC.desugar(tpt)) == "id"

    # ---- the ObjC-ness predicates, both ways ----------------------------------------------
    # Five predicates were asserted only false above, which a predicate stuck at `false`
    # satisfies. `id` and `Class` partition three of them, and `id<NSCopying>` the fourth.
    id_t = vartype("g_id")
    cls_t = vartype("g_cls")
    @test CC.isObjCIdType(id_t) == true
    @test CC.isObjCClassType(id_t) == false
    @test CC.isObjCClassType(cls_t) == true
    @test CC.isObjCIdType(cls_t) == false
    @test CC.isObjCObjectPointerType(id_t) == true
    @test CC.isObjCObjectPointerType(cls_t) == true
    @test CC.isObjCQualifiedIdType(id_t) == false
    @test CC.isObjCQualifiedIdType(vartype("g_idq")) == true

    # `Base<NSCopying> *` points at an ObjCObjectType that is NOT an ObjCInterfaceType, which
    # is the only way to reach the base class's own `desugar` — `Base *` above dispatches to
    # the interface-type override instead.
    qualobj = vartype("g_qualobj")
    obj = CC.resolve(CC.getTypePtr(CC.getPointeeType(qualobj)))
    @test obj isa CC.ObjCObjectType
    @test !(obj isa CC.ObjCInterfaceType)
    @test CC.isSugared(obj) == false
    @test CC.getAsString(CC.desugar(obj)) == "Base<NSCopying>"

    # ---- AvailabilityAttr ------------------------------------------------------------------
    old = lookup("Old")
    avail = only(filter(a -> a isa CC.AvailabilityAttr, map(CC.resolve, CC.getAttrs(old))))
    @test CC.getName(CC.getPlatform(avail)) == "macos"
    @test CC.getIntroduced(avail) == (0x0a, 0x09, 0x00)
    @test CC.getDeprecated(avail) == (0x0b, 0x00, 0x00)
    @test CC.getObsoleted(avail) == (0x0c, 0x00, 0x00)
    @test CC.getUnavailable(avail) == false
    @test CC.getMessage(avail) == "gone"
    @test CC.getReplacement(avail) == ""
    @test CC.getStrict(avail) == false
    @test CC.getPriority(avail) == 0

    # `Old` reads all three of these at their default, which a stuck accessor also gives.
    # `unavailable` and `replacement=` are spellable, and so is `strict` — so each has a
    # written non-default to answer for.
    availof(name) = only(filter(a -> a isa CC.AvailabilityAttr, map(CC.resolve, CC.getAttrs(lookup(name)))))
    gone = availof("Gone")
    @test CC.getUnavailable(gone) == true
    @test CC.getReplacement(gone) == "NewThing"
    @test CC.getStrict(gone) == false           # written on `Strictly`, not here
    strictly = availof("Strictly")
    @test CC.getStrict(strictly) == true
    @test CC.getUnavailable(strictly) == false
    @test CC.getReplacement(strictly) == ""

    # An interface with no availability attribute at all: every version reads as absent
    # rather than as version 0, which is a legal written value.
    @test isempty(filter(a -> a isa CC.AvailabilityAttr, map(CC.resolve, CC.getAttrs(lookup("Base")))))

    dispose(I)
end
