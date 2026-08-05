#include "clang-ex/Basic/CXModule.h"
#include "utils.h"
#include "clang/Basic/Module.h"
#include "clang/Basic/LangOptions.h"
#include "clang/Basic/TargetInfo.h"
#include "llvm/Support/raw_ostream.h"

CXModule_ clang_Module_create(const char *Name, CXSourceLocation_ DefinitionLoc,
                             CXModule_ Parent, bool IsFramework, bool IsExplicit,
                             unsigned VisibilityID) {
  auto M = std::make_unique<clang::Module>(
      llvm::StringRef(Name), clang::SourceLocation::getFromPtrEncoding(DefinitionLoc),
      reinterpret_cast<clang::Module *>(Parent), IsFramework, IsExplicit, VisibilityID);
  return reinterpret_cast<CXModule_>(M.release());
}

void clang_Module_dispose(CXModule_ M) { delete reinterpret_cast<clang::Module *>(M); }

const char *clang_Module_getName(CXModule_ M) {
  return reinterpret_cast<clang::Module *>(M)->Name.c_str();
}

CXModuleKind clang_Module_getKind(CXModule_ M) {
  return static_cast<CXModuleKind>(reinterpret_cast<clang::Module *>(M)->Kind);
}

CXModule_ clang_Module_getParent(CXModule_ M) {
  return reinterpret_cast<CXModule_>(reinterpret_cast<clang::Module *>(M)->Parent);
}

bool clang_Module_isNamedModule(CXModule_ M) {
  return reinterpret_cast<clang::Module *>(M)->isNamedModule();
}

bool clang_Module_isGlobalModule(CXModule_ M) {
  return reinterpret_cast<clang::Module *>(M)->isGlobalModule();
}

bool clang_Module_isExplicitGlobalModule(CXModule_ M) {
  return reinterpret_cast<clang::Module *>(M)->isExplicitGlobalModule();
}

bool clang_Module_isImplicitGlobalModule(CXModule_ M) {
  return reinterpret_cast<clang::Module *>(M)->isImplicitGlobalModule();
}

bool clang_Module_isPrivateModule(CXModule_ M) {
  return reinterpret_cast<clang::Module *>(M)->isPrivateModule();
}

bool clang_Module_isModuleMapModule(CXModule_ M) {
  return reinterpret_cast<clang::Module *>(M)->isModuleMapModule();
}

bool clang_Module_isUnimportable(CXModule_ M) {
  return reinterpret_cast<clang::Module *>(M)->isUnimportable();
}

bool clang_Module_isForBuilding(CXModule_ M, CXLangOptions LangOpts) {
  return reinterpret_cast<clang::Module *>(M)->isForBuilding(
      *reinterpret_cast<clang::LangOptions *>(LangOpts));
}

bool clang_Module_isAvailable(CXModule_ M) {
  return reinterpret_cast<clang::Module *>(M)->isAvailable();
}

bool clang_Module_isSubModule(CXModule_ M) {
  return reinterpret_cast<clang::Module *>(M)->isSubModule();
}

bool clang_Module_isSubModuleOf(CXModule_ M, CXModule_ Other) {
  return reinterpret_cast<clang::Module *>(M)->isSubModuleOf(
      reinterpret_cast<clang::Module *>(Other));
}

bool clang_Module_isPartOfFramework(CXModule_ M) {
  return reinterpret_cast<clang::Module *>(M)->isPartOfFramework();
}

bool clang_Module_isSubFramework(CXModule_ M) {
  return reinterpret_cast<clang::Module *>(M)->isSubFramework();
}

void clang_Module_setParent(CXModule_ M, CXModule_ Parent) {
  reinterpret_cast<clang::Module *>(M)->setParent(reinterpret_cast<clang::Module *>(Parent));
}

bool clang_Module_isHeaderLikeModule(CXModule_ M) {
  return reinterpret_cast<clang::Module *>(M)->isHeaderLikeModule();
}

bool clang_Module_isModulePartition(CXModule_ M) {
  return reinterpret_cast<clang::Module *>(M)->isModulePartition();
}

bool clang_Module_isModuleImplementation(CXModule_ M) {
  return reinterpret_cast<clang::Module *>(M)->isModuleImplementation();
}

bool clang_Module_isHeaderUnit(CXModule_ M) {
  return reinterpret_cast<clang::Module *>(M)->isHeaderUnit();
}

bool clang_Module_isInterfaceOrPartition(CXModule_ M) {
  return reinterpret_cast<clang::Module *>(M)->isInterfaceOrPartition();
}

bool clang_Module_isNamedModuleUnit(CXModule_ M) {
  return reinterpret_cast<clang::Module *>(M)->isNamedModuleUnit();
}

bool clang_Module_isModuleInterfaceUnit(CXModule_ M) {
  return reinterpret_cast<clang::Module *>(M)->isModuleInterfaceUnit();
}

bool clang_Module_isNamedModuleInterfaceHasInit(CXModule_ M) {
  return reinterpret_cast<clang::Module *>(M)->isNamedModuleInterfaceHasInit();
}

CXString clang_Module_getPrimaryModuleInterfaceName(CXModule_ M) {
  return extra::makeCXString(
      reinterpret_cast<clang::Module *>(M)->getPrimaryModuleInterfaceName().str());
}

CXString clang_Module_getFullModuleName(CXModule_ M, bool AllowStringLiterals) {
  return extra::makeCXString(
      reinterpret_cast<clang::Module *>(M)->getFullModuleName(AllowStringLiterals));
}

bool clang_Module_fullModuleNameIs(CXModule_ M, const char **NameParts, unsigned NumParts) {
  llvm::SmallVector<llvm::StringRef, 8> Parts;
  Parts.reserve(NumParts);
  for (unsigned I = 0; I != NumParts; ++I)
    Parts.push_back(llvm::StringRef(NameParts[I]));
  return reinterpret_cast<clang::Module *>(M)->fullModuleNameIs(Parts);
}

CXModule_ clang_Module_getTopLevelModule(CXModule_ M) {
  return reinterpret_cast<CXModule_>(reinterpret_cast<clang::Module *>(M)->getTopLevelModule());
}

const char *clang_Module_getTopLevelModuleName(CXModule_ M) {
  return reinterpret_cast<clang::Module *>(M)->getTopLevelModuleName().data();
}

CXFileEntryRef clang_Module_getASTFile(CXModule_ M) {
  clang::OptionalFileEntryRef Ref = reinterpret_cast<clang::Module *>(M)->getASTFile();
  if (!Ref)
    return nullptr;
  return reinterpret_cast<CXFileEntryRef>(std::make_unique<clang::FileEntryRef>(*Ref).release());
}
// setASTFile
// getUmbrellaDirAsWritten
// getUmbrellaHeaderAsWritten
// getEffectiveUmbrellaDir
// addTopHeader
void clang_Module_addTopHeaderFilename(CXModule_ M, const char *Filename) {
  reinterpret_cast<clang::Module *>(M)->addTopHeaderFilename(llvm::StringRef(Filename));
}
// getTopHeaders

bool clang_Module_directlyUses(CXModule_ M, CXModule_ Requested) {
  return reinterpret_cast<clang::Module *>(M)->directlyUses(
      reinterpret_cast<clang::Module *>(Requested));
}

void clang_Module_addRequirement(CXModule_ M, const char *Feature, bool RequiredState,
                                 CXLangOptions LangOpts, CXTargetInfo_ Target) {
  reinterpret_cast<clang::Module *>(M)->addRequirement(
      llvm::StringRef(Feature), RequiredState, *reinterpret_cast<clang::LangOptions *>(LangOpts),
      *reinterpret_cast<clang::TargetInfo *>(Target));
}
void clang_Module_markUnavailable(CXModule_ M, bool Unimportable) {
  reinterpret_cast<clang::Module *>(M)->markUnavailable(Unimportable);
}

CXModule_ clang_Module_findSubmodule(CXModule_ M, const char *Name) {
  return reinterpret_cast<CXModule_>(reinterpret_cast<clang::Module *>(M)->findSubmodule(llvm::StringRef(Name)));
}

CXModule_ clang_Module_findOrInferSubmodule(CXModule_ M, const char *Name) {
  return reinterpret_cast<CXModule_>(reinterpret_cast<clang::Module *>(M)->findOrInferSubmodule(llvm::StringRef(Name)));
}
CXModule_ clang_Module_getGlobalModuleFragment(CXModule_ M) {
  return reinterpret_cast<CXModule_>(reinterpret_cast<clang::Module *>(M)->getGlobalModuleFragment());
}
CXModule_ clang_Module_getPrivateModuleFragment(CXModule_ M) {
  return reinterpret_cast<CXModule_>(reinterpret_cast<clang::Module *>(M)->getPrivateModuleFragment());
}

bool clang_Module_isModuleVisible(CXModule_ M, CXModule_ Other) {
  return reinterpret_cast<clang::Module *>(M)->isModuleVisible(
      reinterpret_cast<clang::Module *>(Other));
}
unsigned clang_Module_getVisibilityID(CXModule_ M) {
  return reinterpret_cast<clang::Module *>(M)->getVisibilityID();
}

unsigned clang_Module_getNumSubmodules(CXModule_ M) {
  return static_cast<unsigned>(
      llvm::size(reinterpret_cast<clang::Module *>(M)->submodules()));
}

CXModule_ clang_Module_getSubmodule(CXModule_ M, unsigned Index) {
  return reinterpret_cast<CXModule_>(*(reinterpret_cast<clang::Module *>(M)->submodules().begin() + Index));
}

// getExportedModules
unsigned clang_Module_getNumExportedModules(CXModule_ M) {
  llvm::SmallVector<clang::Module *, 8> Exported;
  reinterpret_cast<clang::Module *>(M)->getExportedModules(Exported);
  return static_cast<unsigned>(Exported.size());
}

void clang_Module_getExportedModules(CXModule_ M, CXModule_ *Buf) {
  llvm::SmallVector<clang::Module *, 8> Exported;
  reinterpret_cast<clang::Module *>(M)->getExportedModules(Exported);
  unsigned I = 0;
  for (clang::Module *E : Exported)
    Buf[I++] = reinterpret_cast<CXModule_>(E);
}
const char *clang_Module_getModuleInputBufferName(void) {
  return clang::Module::getModuleInputBufferName().data();
}
CXString clang_Module_print(CXModule_ M, unsigned Indent, bool Dump) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::Module *>(M)->print(OS, Indent, Dump);
  return extra::makeCXString(S);
}
void clang_Module_dump(CXModule_ M) { reinterpret_cast<clang::Module *>(M)->dump(); }
