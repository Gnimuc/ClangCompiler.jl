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
// deletes all of its submodules).
CXModule clang_Module_create(const char *Name, CXSourceLocation_ DefinitionLoc,
                             CXModule Parent, bool IsFramework, bool IsExplicit,
                             unsigned VisibilityID);

void clang_Module_dispose(CXModule M);

// helper: the Module::Name field
const char *clang_Module_getName(CXModule M);

// helper: the Module::Kind field
CXModuleKind clang_Module_getKind(CXModule M);

// helper: the Module::Parent field (NULL for a top-level module)
CXModule clang_Module_getParent(CXModule M);

bool clang_Module_isNamedModule(CXModule M);

bool clang_Module_isGlobalModule(CXModule M);

bool clang_Module_isExplicitGlobalModule(CXModule M);

bool clang_Module_isImplicitGlobalModule(CXModule M);

bool clang_Module_isPrivateModule(CXModule M);

bool clang_Module_isModuleMapModule(CXModule M);

bool clang_Module_isUnimportable(CXModule M);

bool clang_Module_isForBuilding(CXModule M, CXLangOptions LangOpts);

bool clang_Module_isAvailable(CXModule M);

bool clang_Module_isSubModule(CXModule M);

bool clang_Module_isSubModuleOf(CXModule M, CXModule Other);

bool clang_Module_isPartOfFramework(CXModule M);

bool clang_Module_isSubFramework(CXModule M);

// asserts that M has no parent yet, then registers M as a submodule of Parent, which
// from then on owns M (disposing Parent deletes M too).
void clang_Module_setParent(CXModule M, CXModule Parent);

bool clang_Module_isHeaderLikeModule(CXModule M);

bool clang_Module_isModulePartition(CXModule M);

bool clang_Module_isModuleImplementation(CXModule M);

bool clang_Module_isHeaderUnit(CXModule M);

bool clang_Module_isInterfaceOrPartition(CXModule M);

bool clang_Module_isNamedModuleUnit(CXModule M);

bool clang_Module_isModuleInterfaceUnit(CXModule M);

bool clang_Module_isNamedModuleInterfaceHasInit(CXModule M);

CXString clang_Module_getPrimaryModuleInterfaceName(CXModule M);

CXString clang_Module_getFullModuleName(CXModule M, bool AllowStringLiterals);

// NameParts is an array of NUL-terminated name components joined with "."s; the
// strings are only read for the duration of the call.
bool clang_Module_fullModuleNameIs(CXModule M, const char **NameParts, unsigned NumParts);

CXModule clang_Module_getTopLevelModule(CXModule M);

const char *clang_Module_getTopLevelModuleName(CXModule M);

// heap-boxes the `clang::FileEntryRef` (call `clang_FileEntryRef_dispose` to release);
// returns nullptr when the top-level module has no serialized AST file.
CXFileEntryRef clang_Module_getASTFile(CXModule M);
// setASTFile
// getUmbrellaDirAsWritten
// getUmbrellaHeaderAsWritten
// getEffectiveUmbrellaDir
// addTopHeader
void clang_Module_addTopHeaderFilename(CXModule M, const char *Filename);
// getTopHeaders

bool clang_Module_directlyUses(CXModule M, CXModule Requested);

// addRequirement
// a requirement that does not hold marks M and all of its submodules unavailable and
// unimportable
void clang_Module_addRequirement(CXModule M, const char *Feature, bool RequiredState,
                                 CXLangOptions LangOpts, CXTargetInfo_ Target);
void clang_Module_markUnavailable(CXModule M, bool Unimportable);

// returns NULL when no submodule has that name
CXModule clang_Module_findSubmodule(CXModule M, const char *Name);

// returns NULL when no submodule has that name and none can be inferred; an inferred
// submodule is owned by M.
CXModule clang_Module_findOrInferSubmodule(CXModule M, const char *Name);
// asserts that M is a C++20 named module unit (clang_Module_isNamedModuleUnit);
// returns NULL when M has no global module fragment.
CXModule clang_Module_getGlobalModuleFragment(CXModule M);
// asserts that M is a C++20 named module unit (clang_Module_isNamedModuleUnit);
// returns NULL when M has no private module fragment.
CXModule clang_Module_getPrivateModuleFragment(CXModule M);

// builds and caches M's visible-module set on the first call; imports added afterwards
// are not reflected
bool clang_Module_isModuleVisible(CXModule M, CXModule Other);
unsigned clang_Module_getVisibilityID(CXModule M);

// helper: count+index over Module::submodules() (random-access; count is exact,
// slots are never null)
unsigned clang_Module_getNumSubmodules(CXModule M);

CXModule clang_Module_getSubmodule(CXModule M, unsigned Index);

// getExportedModules
// count+fill over Module::getExportedModules (forward-only; the count is exact and no
// slot is null). Each call redoes the walk, so count once and fill once.
unsigned clang_Module_getNumExportedModules(CXModule M);

void clang_Module_getExportedModules(CXModule M, CXModule *Buf);
// static; borrowed pointer into a string literal
const char *clang_Module_getModuleInputBufferName(void);
CXString clang_Module_print(CXModule M, unsigned Indent, bool Dump);
// writes the module map to llvm::errs()
void clang_Module_dump(CXModule M);

LLVM_CLANG_C_EXTERN_C_END

#endif
