#ifndef LLVM_CLANG_C_EXTRA_CXINDEXSYMBOL_H
#define LLVM_CLANG_C_EXTRA_CXINDEXSYMBOL_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang::index (clang/Index/IndexSymbol.h) -- namespace-level free functions, so the
// namespace is the class segment of every name below.
//
// This is clang's own canonical taxonomy for a declaration: one call turns any Decl into
// the (kind, sub-kind, language, properties) quadruple the indexer uses, which is what an
// isa-chain over Decl classes is trying to reconstruct by hand.

// clang/Index/IndexSymbol.h: enum class clang::index::SymbolKind : uint8_t
typedef enum CXSymbolKind {
  CXSymbolKind_Unknown,
  CXSymbolKind_Module,
  CXSymbolKind_Namespace,
  CXSymbolKind_NamespaceAlias,
  CXSymbolKind_Macro,
  CXSymbolKind_Enum,
  CXSymbolKind_Struct,
  CXSymbolKind_Class,
  CXSymbolKind_Protocol,
  CXSymbolKind_Extension,
  CXSymbolKind_Union,
  CXSymbolKind_TypeAlias,
  CXSymbolKind_Function,
  CXSymbolKind_Variable,
  CXSymbolKind_Field,
  CXSymbolKind_EnumConstant,
  CXSymbolKind_InstanceMethod,
  CXSymbolKind_ClassMethod,
  CXSymbolKind_StaticMethod,
  CXSymbolKind_InstanceProperty,
  CXSymbolKind_ClassProperty,
  CXSymbolKind_StaticProperty,
  CXSymbolKind_Constructor,
  CXSymbolKind_Destructor,
  CXSymbolKind_ConversionFunction,
  CXSymbolKind_Parameter,
  CXSymbolKind_Using,
  CXSymbolKind_TemplateTypeParm,
  CXSymbolKind_TemplateTemplateParm,
  CXSymbolKind_NonTypeTemplateParm,
  CXSymbolKind_Concept,
} CXSymbolKind;

// clang/Index/IndexSymbol.h: enum class clang::index::SymbolLanguage : uint8_t
typedef enum CXSymbolLanguage {
  CXSymbolLanguage_C,
  CXSymbolLanguage_ObjC,
  CXSymbolLanguage_CXX,
  CXSymbolLanguage_Swift,
} CXSymbolLanguage;

// clang/Index/IndexSymbol.h: enum class clang::index::SymbolSubKind : uint8_t
typedef enum CXSymbolSubKind {
  CXSymbolSubKind_None,
  CXSymbolSubKind_CXXCopyConstructor,
  CXSymbolSubKind_CXXMoveConstructor,
  CXSymbolSubKind_AccessorGetter,
  CXSymbolSubKind_AccessorSetter,
  CXSymbolSubKind_UsingTypename,
  CXSymbolSubKind_UsingValue,
  CXSymbolSubKind_UsingEnum,
} CXSymbolSubKind;

// clang/Index/IndexSymbol.h: enum class clang::index::SymbolProperty : uint16_t. A BITSET
// -- upstream's SymbolPropertySet is the uint16_t these bits are or'd into, and that is
// what crosses as `unsigned Props` below.
typedef enum CXSymbolProperty {
  CXSymbolProperty_Generic = 1 << 0,
  CXSymbolProperty_TemplatePartialSpecialization = 1 << 1,
  CXSymbolProperty_TemplateSpecialization = 1 << 2,
  CXSymbolProperty_UnitTest = 1 << 3,
  CXSymbolProperty_IBAnnotated = 1 << 4,
  CXSymbolProperty_IBOutletCollection = 1 << 5,
  CXSymbolProperty_GKInspectable = 1 << 6,
  CXSymbolProperty_Local = 1 << 7,
  CXSymbolProperty_ProtocolInterface = 1 << 8,
} CXSymbolProperty;

// clang/Index/IndexSymbol.h: enum class clang::index::SymbolRole : uint32_t. A BITSET --
// upstream's SymbolRoleSet is the `unsigned` these bits are or'd into, and that is what
// crosses as `unsigned Roles` here and in CXIndexingAction.h.
//
// Trailing underscore: libclang's clang-c/Index.h defines its own `enum CXSymbolRole`,
// whose low nine bits are a partial mirror of this one (clang says so at IndexSymbol.h:97)
// but which stops there. Everything from Undefinition up exists only here.
typedef enum CXSymbolRole_ {
  CXSymbolRole_Declaration = 1 << 0,
  CXSymbolRole_Definition = 1 << 1,
  CXSymbolRole_Reference = 1 << 2,
  CXSymbolRole_Read = 1 << 3,
  CXSymbolRole_Write = 1 << 4,
  CXSymbolRole_Call = 1 << 5,
  CXSymbolRole_Dynamic = 1 << 6,
  CXSymbolRole_AddressOf = 1 << 7,
  CXSymbolRole_Implicit = 1 << 8,
  CXSymbolRole_Undefinition = 1 << 9,
  CXSymbolRole_RelationChildOf = 1 << 10,
  CXSymbolRole_RelationBaseOf = 1 << 11,
  CXSymbolRole_RelationOverrideOf = 1 << 12,
  CXSymbolRole_RelationReceivedBy = 1 << 13,
  CXSymbolRole_RelationCalledBy = 1 << 14,
  CXSymbolRole_RelationExtendedBy = 1 << 15,
  CXSymbolRole_RelationAccessorOf = 1 << 16,
  CXSymbolRole_RelationContainedBy = 1 << 17,
  CXSymbolRole_RelationIBTypeOf = 1 << 18,
  CXSymbolRole_RelationSpecializationOf = 1 << 19,
  CXSymbolRole_NameReference = 1 << 20,
} CXSymbolRole_;

// getSymbolInfo returns a four-field POD; it crosses as four out-parameters, each of which
// must be non-NULL. Properties is the SymbolPropertySet bitset, i.e. an or of
// CXSymbolProperty values.
//
// PRECONDITION: D must be non-NULL -- the callee opens with `assert(D)` and then reads
// D->getKind() unconditionally. Every Decl class is handled or falls through to
// CXSymbolKind_Unknown, so no decl is out of range.
void clang_index_getSymbolInfo(CXDecl D, CXSymbolKind *Kind, CXSymbolSubKind *SubKind,
                               CXSymbolLanguage *Lang, unsigned *Properties);

// PRECONDITION: MI must be non-NULL -- upstream takes `const MacroInfo &`.
void clang_index_getSymbolInfoForMacro(CXMacroInfo MI, CXSymbolKind *Kind,
                                       CXSymbolSubKind *SubKind, CXSymbolLanguage *Lang,
                                       unsigned *Properties);

// Whether the decl is local to a function body (a parameter, or anything declared inside
// one). Total over any non-NULL Decl.
bool clang_index_isFunctionLocalSymbol(CXDecl D);

// The three enum-to-string helpers return a StringRef into static storage, which is NOT
// null-terminated, so each is copied into a CXString here rather than borrowed.
//
// PRECONDITION for all three: the argument must be one of the enumerators above. Each
// callee is a `switch` with no default that ends in llvm_unreachable, so an out-of-range
// value is undefined behaviour rather than a diagnosable error.
CXString clang_index_getSymbolKindString(CXSymbolKind K);
CXString clang_index_getSymbolSubKindString(CXSymbolSubKind K);
CXString clang_index_getSymbolLanguageString(CXSymbolLanguage K);

// The decl's name as the indexer spells it. Upstream returns "true if no name was
// printed"; that bool is folded into the EMPTY string here.
//
// PRECONDITION: D must be non-NULL; LO is the LangOptions the decl was parsed with.
CXString clang_index_printSymbolName(CXDecl D, CXLangOptions LO);

// Comma-separated names of the set bits. Any bit pattern is accepted: unknown bits are
// skipped, and an empty set gives "".
CXString clang_index_printSymbolRoles(unsigned Roles);
CXString clang_index_printSymbolProperties(unsigned Props);

// applyForEachSymbolRole
// applyForEachSymbolRoleInterruptible
// applyForEachSymbolProperty
//   -- all three take an `llvm::function_ref` callback; the printers above are the same
//   enumeration already folded to text, and a real callback needs the trampoline this
//   library does not have.

LLVM_CLANG_C_EXTERN_C_END

#endif
