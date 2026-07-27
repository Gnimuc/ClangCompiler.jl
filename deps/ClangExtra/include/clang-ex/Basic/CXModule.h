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

// isForBuilding

bool clang_Module_isAvailable(CXModule M);

bool clang_Module_isSubModule(CXModule M);

bool clang_Module_isSubModuleOf(CXModule M, CXModule Other);

bool clang_Module_isPartOfFramework(CXModule M);

bool clang_Module_isSubFramework(CXModule M);

// setParent

bool clang_Module_isHeaderLikeModule(CXModule M);

bool clang_Module_isModulePartition(CXModule M);

bool clang_Module_isModuleImplementation(CXModule M);

bool clang_Module_isHeaderUnit(CXModule M);

bool clang_Module_isInterfaceOrPartition(CXModule M);

bool clang_Module_isNamedModuleUnit(CXModule M);

bool clang_Module_isModuleInterfaceUnit(CXModule M);

// isNamedModuleInterfaceHasInit

CXString clang_Module_getPrimaryModuleInterfaceName(CXModule M);

CXString clang_Module_getFullModuleName(CXModule M, bool AllowStringLiterals);

// fullModuleNameIs

CXModule clang_Module_getTopLevelModule(CXModule M);

const char *clang_Module_getTopLevelModuleName(CXModule M);

// getASTFile
// setASTFile
// getUmbrellaDirAsWritten
// getUmbrellaHeaderAsWritten
// getEffectiveUmbrellaDir
// addTopHeader
// addTopHeaderFilename
// getTopHeaders

bool clang_Module_directlyUses(CXModule M, CXModule Requested);

// addRequirement
// markUnavailable

// returns NULL when no submodule has that name
CXModule clang_Module_findSubmodule(CXModule M, const char *Name);

// findOrInferSubmodule
// getGlobalModuleFragment
// getPrivateModuleFragment

// isModuleVisible
// getVisibilityID

// helper: count+index over Module::submodules() (random-access; count is exact,
// slots are never null)
unsigned clang_Module_getNumSubmodules(CXModule M);

CXModule clang_Module_getSubmodule(CXModule M, unsigned Index);

// getExportedModules
// getModuleInputBufferName
// print
// dump

LLVM_CLANG_C_EXTERN_C_END

#endif
