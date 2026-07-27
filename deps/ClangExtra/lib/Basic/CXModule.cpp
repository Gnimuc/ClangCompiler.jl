#include "clang-ex/Basic/CXModule.h"
#include "utils.h"
#include "clang/Basic/Module.h"
#include "clang/Basic/LangOptions.h"
#include "clang/Basic/TargetInfo.h"
#include "llvm/Support/raw_ostream.h"

CXModule clang_Module_create(const char *Name, CXSourceLocation_ DefinitionLoc,
                             CXModule Parent, bool IsFramework, bool IsExplicit,
                             unsigned VisibilityID) {
  auto M = std::make_unique<clang::Module>(
      llvm::StringRef(Name), clang::SourceLocation::getFromPtrEncoding(DefinitionLoc),
      static_cast<clang::Module *>(Parent), IsFramework, IsExplicit, VisibilityID);
  return M.release();
}

void clang_Module_dispose(CXModule M) { delete static_cast<clang::Module *>(M); }

const char *clang_Module_getName(CXModule M) {
  return static_cast<clang::Module *>(M)->Name.c_str();
}

CXModuleKind clang_Module_getKind(CXModule M) {
  return static_cast<CXModuleKind>(static_cast<clang::Module *>(M)->Kind);
}

CXModule clang_Module_getParent(CXModule M) {
  return static_cast<clang::Module *>(M)->Parent;
}

bool clang_Module_isNamedModule(CXModule M) {
  return static_cast<clang::Module *>(M)->isNamedModule();
}

bool clang_Module_isGlobalModule(CXModule M) {
  return static_cast<clang::Module *>(M)->isGlobalModule();
}

bool clang_Module_isExplicitGlobalModule(CXModule M) {
  return static_cast<clang::Module *>(M)->isExplicitGlobalModule();
}

bool clang_Module_isImplicitGlobalModule(CXModule M) {
  return static_cast<clang::Module *>(M)->isImplicitGlobalModule();
}

bool clang_Module_isPrivateModule(CXModule M) {
  return static_cast<clang::Module *>(M)->isPrivateModule();
}

bool clang_Module_isModuleMapModule(CXModule M) {
  return static_cast<clang::Module *>(M)->isModuleMapModule();
}

bool clang_Module_isUnimportable(CXModule M) {
  return static_cast<clang::Module *>(M)->isUnimportable();
}

// isForBuilding
bool clang_Module_isForBuilding(CXModule M, CXLangOptions LangOpts) {
  return static_cast<clang::Module *>(M)->isForBuilding(
      *static_cast<clang::LangOptions *>(LangOpts));
}

bool clang_Module_isAvailable(CXModule M) {
  return static_cast<clang::Module *>(M)->isAvailable();
}

bool clang_Module_isSubModule(CXModule M) {
  return static_cast<clang::Module *>(M)->isSubModule();
}

bool clang_Module_isSubModuleOf(CXModule M, CXModule Other) {
  return static_cast<clang::Module *>(M)->isSubModuleOf(
      static_cast<clang::Module *>(Other));
}

bool clang_Module_isPartOfFramework(CXModule M) {
  return static_cast<clang::Module *>(M)->isPartOfFramework();
}

bool clang_Module_isSubFramework(CXModule M) {
  return static_cast<clang::Module *>(M)->isSubFramework();
}

// setParent
void clang_Module_setParent(CXModule M, CXModule Parent) {
  static_cast<clang::Module *>(M)->setParent(static_cast<clang::Module *>(Parent));
}

bool clang_Module_isHeaderLikeModule(CXModule M) {
  return static_cast<clang::Module *>(M)->isHeaderLikeModule();
}

bool clang_Module_isModulePartition(CXModule M) {
  return static_cast<clang::Module *>(M)->isModulePartition();
}

bool clang_Module_isModuleImplementation(CXModule M) {
  return static_cast<clang::Module *>(M)->isModuleImplementation();
}

bool clang_Module_isHeaderUnit(CXModule M) {
  return static_cast<clang::Module *>(M)->isHeaderUnit();
}

bool clang_Module_isInterfaceOrPartition(CXModule M) {
  return static_cast<clang::Module *>(M)->isInterfaceOrPartition();
}

bool clang_Module_isNamedModuleUnit(CXModule M) {
  return static_cast<clang::Module *>(M)->isNamedModuleUnit();
}

bool clang_Module_isModuleInterfaceUnit(CXModule M) {
  return static_cast<clang::Module *>(M)->isModuleInterfaceUnit();
}

// isNamedModuleInterfaceHasInit
bool clang_Module_isNamedModuleInterfaceHasInit(CXModule M) {
  return static_cast<clang::Module *>(M)->isNamedModuleInterfaceHasInit();
}

CXString clang_Module_getPrimaryModuleInterfaceName(CXModule M) {
  return extra::makeCXString(
      static_cast<clang::Module *>(M)->getPrimaryModuleInterfaceName().str());
}

CXString clang_Module_getFullModuleName(CXModule M, bool AllowStringLiterals) {
  return extra::makeCXString(
      static_cast<clang::Module *>(M)->getFullModuleName(AllowStringLiterals));
}

// fullModuleNameIs
bool clang_Module_fullModuleNameIs(CXModule M, const char **NameParts, unsigned NumParts) {
  llvm::SmallVector<llvm::StringRef, 8> Parts;
  Parts.reserve(NumParts);
  for (unsigned I = 0; I != NumParts; ++I)
    Parts.push_back(llvm::StringRef(NameParts[I]));
  return static_cast<clang::Module *>(M)->fullModuleNameIs(Parts);
}

CXModule clang_Module_getTopLevelModule(CXModule M) {
  return static_cast<clang::Module *>(M)->getTopLevelModule();
}

const char *clang_Module_getTopLevelModuleName(CXModule M) {
  return static_cast<clang::Module *>(M)->getTopLevelModuleName().data();
}

// getASTFile
CXFileEntryRef clang_Module_getASTFile(CXModule M) {
  clang::OptionalFileEntryRef Ref = static_cast<clang::Module *>(M)->getASTFile();
  if (!Ref)
    return nullptr;
  return std::make_unique<clang::FileEntryRef>(*Ref).release();
}
// setASTFile
// getUmbrellaDirAsWritten
// getUmbrellaHeaderAsWritten
// getEffectiveUmbrellaDir
// addTopHeader
// addTopHeaderFilename
void clang_Module_addTopHeaderFilename(CXModule M, const char *Filename) {
  static_cast<clang::Module *>(M)->addTopHeaderFilename(llvm::StringRef(Filename));
}
// getTopHeaders

bool clang_Module_directlyUses(CXModule M, CXModule Requested) {
  return static_cast<clang::Module *>(M)->directlyUses(
      static_cast<clang::Module *>(Requested));
}

// addRequirement
void clang_Module_addRequirement(CXModule M, const char *Feature, bool RequiredState,
                                 CXLangOptions LangOpts, CXTargetInfo_ Target) {
  static_cast<clang::Module *>(M)->addRequirement(
      llvm::StringRef(Feature), RequiredState, *static_cast<clang::LangOptions *>(LangOpts),
      *static_cast<clang::TargetInfo *>(Target));
}
// markUnavailable
void clang_Module_markUnavailable(CXModule M, bool Unimportable) {
  static_cast<clang::Module *>(M)->markUnavailable(Unimportable);
}

CXModule clang_Module_findSubmodule(CXModule M, const char *Name) {
  return static_cast<clang::Module *>(M)->findSubmodule(llvm::StringRef(Name));
}

// findOrInferSubmodule
CXModule clang_Module_findOrInferSubmodule(CXModule M, const char *Name) {
  return static_cast<clang::Module *>(M)->findOrInferSubmodule(llvm::StringRef(Name));
}
// getGlobalModuleFragment
CXModule clang_Module_getGlobalModuleFragment(CXModule M) {
  return static_cast<clang::Module *>(M)->getGlobalModuleFragment();
}
// getPrivateModuleFragment
CXModule clang_Module_getPrivateModuleFragment(CXModule M) {
  return static_cast<clang::Module *>(M)->getPrivateModuleFragment();
}

// isModuleVisible
bool clang_Module_isModuleVisible(CXModule M, CXModule Other) {
  return static_cast<clang::Module *>(M)->isModuleVisible(
      static_cast<clang::Module *>(Other));
}
// getVisibilityID
unsigned clang_Module_getVisibilityID(CXModule M) {
  return static_cast<clang::Module *>(M)->getVisibilityID();
}

unsigned clang_Module_getNumSubmodules(CXModule M) {
  return static_cast<unsigned>(
      llvm::size(static_cast<clang::Module *>(M)->submodules()));
}

CXModule clang_Module_getSubmodule(CXModule M, unsigned Index) {
  return *(static_cast<clang::Module *>(M)->submodules().begin() + Index);
}

// getExportedModules
unsigned clang_Module_getNumExportedModules(CXModule M) {
  llvm::SmallVector<clang::Module *, 8> Exported;
  static_cast<clang::Module *>(M)->getExportedModules(Exported);
  return static_cast<unsigned>(Exported.size());
}

void clang_Module_getExportedModules(CXModule M, CXModule *Buf) {
  llvm::SmallVector<clang::Module *, 8> Exported;
  static_cast<clang::Module *>(M)->getExportedModules(Exported);
  unsigned I = 0;
  for (clang::Module *E : Exported)
    Buf[I++] = E;
}
// getModuleInputBufferName
const char *clang_Module_getModuleInputBufferName(void) {
  return clang::Module::getModuleInputBufferName().data();
}
// print
CXString clang_Module_print(CXModule M, unsigned Indent, bool Dump) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  static_cast<clang::Module *>(M)->print(OS, Indent, Dump);
  return extra::makeCXString(S);
}
// dump
void clang_Module_dump(CXModule M) { static_cast<clang::Module *>(M)->dump(); }
