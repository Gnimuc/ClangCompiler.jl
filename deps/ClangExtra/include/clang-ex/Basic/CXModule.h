#ifndef LLVM_CLANG_C_EXTRA_CXMODULE_H
#define LLVM_CLANG_C_EXTRA_CXMODULE_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// mirrors clang::Module::ModuleKind (clang/Basic/Module.h).
// Synced by static_assert in lib/Basic/CXEnumSync.cpp.
typedef enum CXModuleKind {
  CXModuleKind_ModuleMapModule,
  CXModuleKind_ModuleHeaderUnit,
  CXModuleKind_ModuleInterfaceUnit,
  CXModuleKind_ModuleImplementationUnit,
  CXModuleKind_ModulePartitionInterface,
  CXModuleKind_ModulePartitionImplementation,
  CXModuleKind_ExplicitGlobalModuleFragment,
  CXModuleKind_PrivateModuleFragment,
  CXModuleKind_ImplicitGlobalModuleFragment
} CXModuleKind;

// heap-allocates a clang::Module. When Parent is non-NULL the new module is
// registered as a submodule of Parent, which then owns it — call
// clang_Module_dispose only on parentless modules (disposing a module also
// deletes all of its submodules). LLVM 20 hid the constructor behind
// ModuleConstructorTag (private to ModuleMap); the tag is an empty access
// token and is reconstructed here.
CXModule_ clang_Module_create(const char *Name, CXSourceLocation_ DefinitionLoc,
                             CXModule_ Parent, bool IsFramework, bool IsExplicit,
                             unsigned VisibilityID);

void clang_Module_dispose(CXModule_ M);

// helper: the Module::Name field
const char *clang_Module_getName(CXModule_ M);

// helper: the Module::Kind field
CXModuleKind clang_Module_getKind(CXModule_ M);

// helper: the Module::Parent field (NULL for a top-level module)
CXModule_ clang_Module_getParent(CXModule_ M);

bool clang_Module_isNamedModule(CXModule_ M);

bool clang_Module_isGlobalModule(CXModule_ M);

bool clang_Module_isExplicitGlobalModule(CXModule_ M);

bool clang_Module_isImplicitGlobalModule(CXModule_ M);

bool clang_Module_isPrivateModule(CXModule_ M);

bool clang_Module_isModuleMapModule(CXModule_ M);

bool clang_Module_isUnimportable(CXModule_ M);

bool clang_Module_isForBuilding(CXModule_ M, CXLangOptions LangOpts);

bool clang_Module_isAvailable(CXModule_ M);

bool clang_Module_isSubModule(CXModule_ M);

bool clang_Module_isSubModuleOf(CXModule_ M, CXModule_ Other);

bool clang_Module_isPartOfFramework(CXModule_ M);

bool clang_Module_isSubFramework(CXModule_ M);

// asserts that M has no parent yet, then registers M as a submodule of Parent, which
// from then on owns M (disposing Parent deletes M too).
void clang_Module_setParent(CXModule_ M, CXModule_ Parent);

bool clang_Module_isHeaderLikeModule(CXModule_ M);

bool clang_Module_isModulePartition(CXModule_ M);

bool clang_Module_isModuleImplementation(CXModule_ M);

bool clang_Module_isHeaderUnit(CXModule_ M);

bool clang_Module_isInterfaceOrPartition(CXModule_ M);

bool clang_Module_isNamedModuleUnit(CXModule_ M);

bool clang_Module_isModuleInterfaceUnit(CXModule_ M);

bool clang_Module_isNamedModuleInterfaceHasInit(CXModule_ M);

CXString clang_Module_getPrimaryModuleInterfaceName(CXModule_ M);

CXString clang_Module_getFullModuleName(CXModule_ M, bool AllowStringLiterals);

// NameParts is an array of NUL-terminated name components joined with "."s; the
// strings are only read for the duration of the call.
bool clang_Module_fullModuleNameIs(CXModule_ M, const char **NameParts, unsigned NumParts);

CXModule_ clang_Module_getTopLevelModule(CXModule_ M);

const char *clang_Module_getTopLevelModuleName(CXModule_ M);

// heap-boxes the `clang::FileEntryRef` (call `clang_FileEntryRef_dispose` to release);
// returns nullptr when the top-level module has no serialized AST file.
CXFileEntryRef clang_Module_getASTFile(CXModule_ M);
// setASTFile
// getUmbrellaDirAsWritten
// getUmbrellaHeaderAsWritten
// getEffectiveUmbrellaDir
// addTopHeader
void clang_Module_addTopHeaderFilename(CXModule_ M, const char *Filename);
// getTopHeaders

bool clang_Module_directlyUses(CXModule_ M, CXModule_ Requested);

// addRequirement
// a requirement that does not hold marks M and all of its submodules unavailable and
// unimportable
void clang_Module_addRequirement(CXModule_ M, const char *Feature, bool RequiredState,
                                 CXLangOptions LangOpts, CXTargetInfo_ Target);
void clang_Module_markUnavailable(CXModule_ M, bool Unimportable);

// returns NULL when no submodule has that name
CXModule_ clang_Module_findSubmodule(CXModule_ M, const char *Name);

// returns NULL when no submodule has that name and none can be inferred; an inferred
// submodule is owned by M. LLVM 20 moved inference onto ModuleMap, so this is a
// lookup of already-attached submodules for a module that has no map.
CXModule_ clang_Module_findOrInferSubmodule(CXModule_ M, const char *Name);
// asserts that M is a C++20 named module unit (clang_Module_isNamedModuleUnit);
// returns NULL when M has no global module fragment.
CXModule_ clang_Module_getGlobalModuleFragment(CXModule_ M);
// asserts that M is a C++20 named module unit (clang_Module_isNamedModuleUnit);
// returns NULL when M has no private module fragment.
CXModule_ clang_Module_getPrivateModuleFragment(CXModule_ M);

// builds and caches M's visible-module set on the first call; imports added afterwards
// are not reflected
bool clang_Module_isModuleVisible(CXModule_ M, CXModule_ Other);
unsigned clang_Module_getVisibilityID(CXModule_ M);

// helper: count+index over Module::submodules() (random-access; count is exact,
// slots are never null)
unsigned clang_Module_getNumSubmodules(CXModule_ M);

CXModule_ clang_Module_getSubmodule(CXModule_ M, unsigned Index);

// getExportedModules
// count+fill over Module::getExportedModules (forward-only; the count is exact and no
// slot is null). Each call redoes the walk, so count once and fill once.
unsigned clang_Module_getNumExportedModules(CXModule_ M);

void clang_Module_getExportedModules(CXModule_ M, CXModule_ *Buf);
// static; borrowed pointer into a string literal
const char *clang_Module_getModuleInputBufferName(void);
CXString clang_Module_print(CXModule_ M, unsigned Indent, bool Dump);
// writes the module map to llvm::errs()
void clang_Module_dump(CXModule_ M);

LLVM_CLANG_C_EXTERN_C_END

#endif
