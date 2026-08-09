#ifndef LLVM_CLANG_C_EXTRA_CXDECLOBJC_H
#define LLVM_CLANG_C_EXTRA_CXDECLOBJC_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// A clang::Selector is a DeclarationName variant, so its identity crosses through the
// existing pivot: clang_NamedDecl_getDeclName on an ObjCMethodDecl yields the
// CXDeclarationName holding it, and two selectors are equal iff those are. What that pivot
// cannot give is the spelling, so the accessors below hand back the printed form
// ("initWithFoo:bar:") as an owned CXString. There is no CXSelector handle: a selector is
// never anything but a name here.

// ObjCMethodDecl
CXObjCMethodDecl clang_ObjCMethodDecl_getCanonicalDecl(CXObjCMethodDecl MD);

// The interface this method belongs to. Null when the declaration context is a protocol,
// which has no interface. Partial the other way round: the context must be one of
// interface/category/implementation/protocol, and upstream is llvm_unreachable on anything
// else -- a method whose context is not an ObjCContainerDecl at all aborts rather than
// returning null.
CXObjCInterfaceDecl clang_ObjCMethodDecl_getClassInterface(CXObjCMethodDecl MD);

CXObjCCategoryDecl clang_ObjCMethodDecl_getCategory(CXObjCMethodDecl MD);

// The selector's printed form, colons included.
CXString clang_ObjCMethodDecl_getSelector(CXObjCMethodDecl MD);

CXQualType clang_ObjCMethodDecl_getReturnType(CXObjCMethodDecl MD);

CXTypeSourceInfo clang_ObjCMethodDecl_getReturnTypeSourceInfo(CXObjCMethodDecl MD);

unsigned clang_ObjCMethodDecl_param_size(CXObjCMethodDecl MD);

// PRECONDITION: I < clang_ObjCMethodDecl_param_size.
CXParmVarDecl clang_ObjCMethodDecl_getParamDecl(CXObjCMethodDecl MD, unsigned I);

// The number of selector name segments the source wrote: param_size for a method with
// arguments and 1 for a nullary one, but 0 for an implicitly-declared method such as a
// synthesized property accessor, which has no written selector to locate.
unsigned clang_ObjCMethodDecl_getNumSelectorLocs(CXObjCMethodDecl MD);

bool clang_ObjCMethodDecl_isInstanceMethod(CXObjCMethodDecl MD);

bool clang_ObjCMethodDecl_isClassMethod(CXObjCMethodDecl MD);

bool clang_ObjCMethodDecl_isVariadic(CXObjCMethodDecl MD);

bool clang_ObjCMethodDecl_isPropertyAccessor(CXObjCMethodDecl MD);

bool clang_ObjCMethodDecl_isDefined(CXObjCMethodDecl MD);

bool clang_ObjCMethodDecl_isThisDeclarationADesignatedInitializer(CXObjCMethodDecl MD);

bool clang_ObjCMethodDecl_hasRelatedResultType(CXObjCMethodDecl MD);

bool clang_ObjCMethodDecl_isOptional(CXObjCMethodDecl MD);

// ObjCTypeParamDecl
// clang/AST/DeclObjC.h: enum class clang::ObjCTypeParamVariance
typedef enum CXObjCTypeParamVariance {
  CXObjCTypeParamVariance_Invariant,
  CXObjCTypeParamVariance_Covariant,
  CXObjCTypeParamVariance_Contravariant
} CXObjCTypeParamVariance;

CXObjCTypeParamVariance clang_ObjCTypeParamDecl_getVariance(CXObjCTypeParamDecl TPD);

unsigned clang_ObjCTypeParamDecl_getIndex(CXObjCTypeParamDecl TPD);

bool clang_ObjCTypeParamDecl_hasExplicitBound(CXObjCTypeParamDecl TPD);

// ObjCContainerDecl
// The properties and methods of an interface, protocol, category or implementation. Both
// families are also reachable by walking the container as a DeclContext and filtering by
// class; these narrow the walk to one kind and give it an index. Both iterators are
// forward-only over the decl chain, so an indexed read is O(index).
unsigned clang_ObjCContainerDecl_prop_size(CXObjCContainerDecl CD);

// PRECONDITION: I < clang_ObjCContainerDecl_prop_size.
CXObjCPropertyDecl clang_ObjCContainerDecl_getProperty(CXObjCContainerDecl CD, unsigned I);

unsigned clang_ObjCContainerDecl_meth_size(CXObjCContainerDecl CD);

// PRECONDITION: I < clang_ObjCContainerDecl_meth_size.
CXObjCMethodDecl clang_ObjCContainerDecl_getMethodAt(CXObjCContainerDecl CD, unsigned I);

// Looks a method up by selector spelling ("initWithFoo:bar:"). Null when the container
// declares no such method.
CXObjCMethodDecl clang_ObjCContainerDecl_getMethod(CXObjCContainerDecl CD, const char *Sel,
                                                   CXASTContext C, bool IsInstance,
                                                   bool AllowHidden);

CXSourceRange_ clang_ObjCContainerDecl_getAtEndRange(CXObjCContainerDecl CD);

// ObjCInterfaceDecl
// The protocols written on the @interface line. all_referenced adds the ones a class
// extension brought in; on a class with no extensions the two agree. All four accessors
// are total on a forward @class declaration, where clang reports an empty list rather than
// reaching for definition data it does not have.
unsigned clang_ObjCInterfaceDecl_protocol_size(CXObjCInterfaceDecl ID);

// PRECONDITION: I < clang_ObjCInterfaceDecl_protocol_size.
CXObjCProtocolDecl clang_ObjCInterfaceDecl_getProtocol(CXObjCInterfaceDecl ID, unsigned I);

unsigned clang_ObjCInterfaceDecl_all_referenced_protocol_size(CXObjCInterfaceDecl ID);

// PRECONDITION: I < clang_ObjCInterfaceDecl_all_referenced_protocol_size.
CXObjCProtocolDecl
clang_ObjCInterfaceDecl_getAllReferencedProtocol(CXObjCInterfaceDecl ID, unsigned I);

// The instance variables declared in the @interface body, as a count + index pair. Also
// total on a forward declaration, which has none.
unsigned clang_ObjCInterfaceDecl_ivar_size(CXObjCInterfaceDecl ID);

// PRECONDITION: I < clang_ObjCInterfaceDecl_ivar_size.
CXObjCIvarDecl clang_ObjCInterfaceDecl_getIvar(CXObjCInterfaceDecl ID, unsigned I);

bool clang_ObjCInterfaceDecl_hasDefinition(CXObjCInterfaceDecl ID);

bool clang_ObjCInterfaceDecl_isThisDeclarationADefinition(CXObjCInterfaceDecl ID);

// The declaration that carries the @interface body, or null when only a @class forward
// declaration has been seen.
CXObjCInterfaceDecl clang_ObjCInterfaceDecl_getDefinition(CXObjCInterfaceDecl ID);

// Null on a root class (NSObject), and on a forward declaration.
CXObjCInterfaceDecl clang_ObjCInterfaceDecl_getSuperClass(CXObjCInterfaceDecl ID);

// Null on a root class, and on a forward @class declaration: getSuperClassTInfo opens with
// its own hasDefinition test and getSuperClassType only dereferences what it returns, so
// neither reaches the definition data unguarded.
CXObjCObjectType clang_ObjCInterfaceDecl_getSuperClassType(CXObjCInterfaceDecl ID);

CXTypeSourceInfo clang_ObjCInterfaceDecl_getSuperClassTInfo(CXObjCInterfaceDecl ID);

// The type parameters of a generic class (`@interface NSArray<T>`), as a count + index
// pair; 0 on a non-generic class. clang falls back to the definition's list when this
// particular declaration has none written, so a forward declaration still reports them.
unsigned clang_ObjCInterfaceDecl_getNumTypeParams(CXObjCInterfaceDecl ID);

// PRECONDITION: I < clang_ObjCInterfaceDecl_getNumTypeParams.
CXObjCTypeParamDecl clang_ObjCInterfaceDecl_getTypeParam(CXObjCInterfaceDecl ID, unsigned I);

CXObjCInterfaceDecl clang_ObjCInterfaceDecl_getCanonicalDecl(CXObjCInterfaceDecl ID);

// ObjCProtocolDecl
// The protocols this one inherits. Total on a forward @protocol declaration, which
// reports none.
unsigned clang_ObjCProtocolDecl_protocol_size(CXObjCProtocolDecl PD);

// PRECONDITION: I < clang_ObjCProtocolDecl_protocol_size.
CXObjCProtocolDecl clang_ObjCProtocolDecl_getProtocol(CXObjCProtocolDecl PD, unsigned I);

bool clang_ObjCProtocolDecl_hasDefinition(CXObjCProtocolDecl PD);

bool clang_ObjCProtocolDecl_isThisDeclarationADefinition(CXObjCProtocolDecl PD);

CXObjCProtocolDecl clang_ObjCProtocolDecl_getDefinition(CXObjCProtocolDecl PD);

CXObjCProtocolDecl clang_ObjCProtocolDecl_getCanonicalDecl(CXObjCProtocolDecl PD);

// ObjCCategoryDecl
CXObjCInterfaceDecl clang_ObjCCategoryDecl_getClassInterface(CXObjCCategoryDecl CD);

unsigned clang_ObjCCategoryDecl_protocol_size(CXObjCCategoryDecl CD);

// PRECONDITION: I < clang_ObjCCategoryDecl_protocol_size.
CXObjCProtocolDecl clang_ObjCCategoryDecl_getProtocol(CXObjCCategoryDecl CD, unsigned I);

CXObjCCategoryDecl clang_ObjCCategoryDecl_getNextClassCategory(CXObjCCategoryDecl CD);

// True for an unnamed category, i.e. a class extension `@interface Foo ()`.
bool clang_ObjCCategoryDecl_IsClassExtension(CXObjCCategoryDecl CD);

unsigned clang_ObjCCategoryDecl_ivar_size(CXObjCCategoryDecl CD);

// PRECONDITION: I < clang_ObjCCategoryDecl_ivar_size.
CXObjCIvarDecl clang_ObjCCategoryDecl_getIvar(CXObjCCategoryDecl CD, unsigned I);

CXSourceLocation_ clang_ObjCCategoryDecl_getCategoryNameLoc(CXObjCCategoryDecl CD);

// ObjCPropertyDecl
// clang/AST/DeclObjCCommon.h: enum clang::ObjCPropertyAttribute::Kind. A bit set, not a
// sequence: the enumerators are disjoint bits and getPropertyAttributes returns their OR.
typedef enum CXObjCPropertyAttributeKind {
  CXObjCPropertyAttributeKind_noattr = 0x00,
  CXObjCPropertyAttributeKind_readonly = 0x01,
  CXObjCPropertyAttributeKind_getter = 0x02,
  CXObjCPropertyAttributeKind_assign = 0x04,
  CXObjCPropertyAttributeKind_readwrite = 0x08,
  CXObjCPropertyAttributeKind_retain = 0x10,
  CXObjCPropertyAttributeKind_copy = 0x20,
  CXObjCPropertyAttributeKind_nonatomic = 0x40,
  CXObjCPropertyAttributeKind_setter = 0x80,
  CXObjCPropertyAttributeKind_atomic = 0x100,
  CXObjCPropertyAttributeKind_weak = 0x200,
  CXObjCPropertyAttributeKind_strong = 0x400,
  CXObjCPropertyAttributeKind_unsafe_unretained = 0x800,
  CXObjCPropertyAttributeKind_nullability = 0x1000,
  CXObjCPropertyAttributeKind_null_resettable = 0x2000,
  CXObjCPropertyAttributeKind_class = 0x4000,
  CXObjCPropertyAttributeKind_direct = 0x8000
} CXObjCPropertyAttributeKind;

CXQualType clang_ObjCPropertyDecl_getType(CXObjCPropertyDecl PD);

CXTypeSourceInfo clang_ObjCPropertyDecl_getTypeSourceInfo(CXObjCPropertyDecl PD);

// The OR of the attributes in force, written or defaulted.
CXObjCPropertyAttributeKind
clang_ObjCPropertyDecl_getPropertyAttributes(CXObjCPropertyDecl PD);

// The OR of only those the source spelled out.
CXObjCPropertyAttributeKind
clang_ObjCPropertyDecl_getPropertyAttributesAsWritten(CXObjCPropertyDecl PD);

// Selector spellings, as for ObjCMethodDecl.
CXString clang_ObjCPropertyDecl_getGetterName(CXObjCPropertyDecl PD);

CXString clang_ObjCPropertyDecl_getSetterName(CXObjCPropertyDecl PD);

// The methods the property resolves to. Null until Sema has synthesized them, and the
// setter is always null on a readonly property.
CXObjCMethodDecl clang_ObjCPropertyDecl_getGetterMethodDecl(CXObjCPropertyDecl PD);

CXObjCMethodDecl clang_ObjCPropertyDecl_getSetterMethodDecl(CXObjCPropertyDecl PD);

bool clang_ObjCPropertyDecl_isReadOnly(CXObjCPropertyDecl PD);

bool clang_ObjCPropertyDecl_isAtomic(CXObjCPropertyDecl PD);

bool clang_ObjCPropertyDecl_isInstanceProperty(CXObjCPropertyDecl PD);

bool clang_ObjCPropertyDecl_isClassProperty(CXObjCPropertyDecl PD);

bool clang_ObjCPropertyDecl_isOptional(CXObjCPropertyDecl PD);

CXSourceLocation_ clang_ObjCPropertyDecl_getAtLoc(CXObjCPropertyDecl PD);

// ObjCIvarDecl
// clang/AST/DeclObjC.h: enum clang::ObjCIvarDecl::AccessControl
typedef enum CXObjCIvarDecl_AccessControl {
  CXObjCIvarDecl_None,
  CXObjCIvarDecl_Private,
  CXObjCIvarDecl_Protected,
  CXObjCIvarDecl_Public,
  CXObjCIvarDecl_Package
} CXObjCIvarDecl_AccessControl;

CXObjCIvarDecl_AccessControl clang_ObjCIvarDecl_getAccessControl(CXObjCIvarDecl IVD);

// None resolved to the default clang applies to an ivar written without one (@protected in
// an @interface, @private in an @implementation).
CXObjCIvarDecl_AccessControl
clang_ObjCIvarDecl_getCanonicalAccessControl(CXObjCIvarDecl IVD);

// Partial: upstream casts the declaration context to ObjCContainerDecl unchecked, is
// llvm_unreachable on a protocol or category-implementation container, and asserts that a
// category container is a class extension. Only an @interface, an @implementation or a class
// extension is a valid container.
CXObjCInterfaceDecl clang_ObjCIvarDecl_getContainingInterface(CXObjCIvarDecl IVD);

CXObjCIvarDecl clang_ObjCIvarDecl_getNextIvar(CXObjCIvarDecl IVD);

bool clang_ObjCIvarDecl_getSynthesize(CXObjCIvarDecl IVD);

// ObjCCompatibleAliasDecl
CXObjCInterfaceDecl
clang_ObjCCompatibleAliasDecl_getClassInterface(CXObjCCompatibleAliasDecl AD);

// ObjCImplDecl
CXObjCInterfaceDecl clang_ObjCImplDecl_getClassInterface(CXObjCImplDecl ID);

// ObjCImplementationDecl
CXObjCInterfaceDecl
clang_ObjCImplementationDecl_getSuperClass(CXObjCImplementationDecl ID);

// ObjCCategoryImplDecl
CXObjCCategoryDecl clang_ObjCCategoryImplDecl_getCategoryDecl(CXObjCCategoryImplDecl ID);

LLVM_CLANG_C_EXTERN_C_END

#endif
