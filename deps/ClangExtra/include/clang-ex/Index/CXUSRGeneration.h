#ifndef LLVM_CLANG_C_EXTRA_CXUSRGENERATION_H
#define LLVM_CLANG_C_EXTRA_CXUSRGENERATION_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang::index — namespace-level free functions; the namespace is the class
// segment of every name below.
//
// Marshalling contract for this whole file: upstream writes the USR into a
// SmallVectorImpl<char> / raw_ostream out-parameter and reports failure (or
// "ignore this result") through a bool return. Neither shape crosses the C
// boundary: every wrapper here returns the USR as a CXString and folds the bool
// into the EMPTY string. A successfully generated USR is never empty, so "" is
// an unambiguous failure/ignore sentinel. Strings in are `const char *` rebuilt
// as llvm::StringRef; the trailing StringRef parameters that default to ""
// upstream are required here and the Julia wrapper supplies "".

CXString clang_index_getUSRSpacePrefix(void);

CXString clang_index_generateUSRForDecl(CXDecl D);

CXString clang_index_generateUSRForObjCClass(const char *Cls,
                                             const char *ExtSymbolDefinedIn,
                                             const char *CategoryContextExtSymbolDefinedIn);

CXString clang_index_generateUSRForObjCCategory(const char *Cls, const char *Cat,
                                                const char *ClsExtSymbolDefinedIn,
                                                const char *CatExtSymbolDefinedIn);

CXString clang_index_generateUSRForObjCIvar(const char *Ivar);

CXString clang_index_generateUSRForObjCMethod(const char *Sel, bool IsInstanceMethod);

CXString clang_index_generateUSRForObjCProperty(const char *Prop, bool isClassProp);

CXString clang_index_generateUSRForObjCProtocol(const char *Prot,
                                                const char *ExtSymbolDefinedIn);

CXString clang_index_generateUSRForGlobalEnum(const char *EnumName,
                                              const char *ExtSymbolDefinedIn);

CXString clang_index_generateUSRForEnumConstant(const char *EnumConstantName);

// generateUSRForMacro (MacroDefinitionRecord overload)

// Precondition: when Loc is valid it must be a location owned by SM — the callee
// runs SourceManager::isInSystemHeader(Loc) and prints the decomposed location,
// both of which index SM's own tables. An INVALID Loc is explicitly supported
// (the location is then simply omitted from the USR), so the encoding may be
// NULL here; SM may not. An empty MacroName yields "".
CXString clang_index_generateUSRForMacro(const char *MacroName, CXSourceLocation_ Loc,
                                         CXSourceManager SM);

// Precondition: T may be a null QualType (the callee returns early, yielding ""),
// but Ctx binds to an `ASTContext &` and must be non-NULL.
CXString clang_index_generateUSRForType(CXQualType T, CXASTContext Ctx);

// Precondition: Mod must be non-NULL — the callee dereferences it unconditionally
// (Mod->Parent, Mod->Name); it does not null-check.
CXString clang_index_generateFullUSRForModule(CXModule Mod);

CXString clang_index_generateFullUSRForTopLevelModuleName(const char *ModName);

// Precondition: Mod must be non-NULL — the callee reads Mod->Name unconditionally.
CXString clang_index_generateUSRFragmentForModule(CXModule Mod);

CXString clang_index_generateUSRFragmentForModuleName(const char *ModName);

LLVM_CLANG_C_EXTERN_C_END

#endif
