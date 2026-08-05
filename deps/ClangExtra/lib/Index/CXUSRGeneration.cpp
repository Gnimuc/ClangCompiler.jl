#include "clang-ex/Index/CXUSRGeneration.h"

#include "utils.h"

#include "clang/AST/ASTContext.h"
#include "clang/AST/DeclBase.h"
#include "clang/AST/Type.h"
#include "clang/Basic/Module.h"
#include "clang/Basic/SourceLocation.h"
#include "clang/Basic/SourceManager.h"
#include "clang/Index/USRGeneration.h"
#include "llvm/ADT/SmallString.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Support/raw_ostream.h"

#include <string>

// See the marshalling contract in CXUSRGeneration.h: the bool every upstream
// generator returns is folded into the empty CXString.
static CXString usrFromBuf(const llvm::SmallVectorImpl<char> &Buf, bool Failed) {
  return Failed ? extra::makeCXString("")
                : extra::makeCXString(std::string(Buf.begin(), Buf.end()));
}

CXString clang_index_getUSRSpacePrefix(void) {
  return extra::makeCXString(clang::index::getUSRSpacePrefix().str());
}

CXString clang_index_generateUSRForDecl(CXDecl D) {
  llvm::SmallString<128> Buf;
  bool Ignore = clang::index::generateUSRForDecl(reinterpret_cast<clang::Decl *>(D), Buf);
  return usrFromBuf(Buf, Ignore);
}

CXString clang_index_generateUSRForObjCClass(
    const char *Cls, const char *ExtSymbolDefinedIn,
    const char *CategoryContextExtSymbolDefinedIn) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  clang::index::generateUSRForObjCClass(
      llvm::StringRef(Cls), OS, llvm::StringRef(ExtSymbolDefinedIn),
      llvm::StringRef(CategoryContextExtSymbolDefinedIn));
  return extra::makeCXString(S);
}

CXString clang_index_generateUSRForObjCCategory(const char *Cls, const char *Cat,
                                                const char *ClsExtSymbolDefinedIn,
                                                const char *CatExtSymbolDefinedIn) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  clang::index::generateUSRForObjCCategory(
      llvm::StringRef(Cls), llvm::StringRef(Cat), OS,
      llvm::StringRef(ClsExtSymbolDefinedIn), llvm::StringRef(CatExtSymbolDefinedIn));
  return extra::makeCXString(S);
}

CXString clang_index_generateUSRForObjCIvar(const char *Ivar) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  clang::index::generateUSRForObjCIvar(llvm::StringRef(Ivar), OS);
  return extra::makeCXString(S);
}

CXString clang_index_generateUSRForObjCMethod(const char *Sel, bool IsInstanceMethod) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  clang::index::generateUSRForObjCMethod(llvm::StringRef(Sel), IsInstanceMethod, OS);
  return extra::makeCXString(S);
}

CXString clang_index_generateUSRForObjCProperty(const char *Prop, bool isClassProp) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  clang::index::generateUSRForObjCProperty(llvm::StringRef(Prop), isClassProp, OS);
  return extra::makeCXString(S);
}

CXString clang_index_generateUSRForObjCProtocol(const char *Prot,
                                                const char *ExtSymbolDefinedIn) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  clang::index::generateUSRForObjCProtocol(llvm::StringRef(Prot), OS,
                                           llvm::StringRef(ExtSymbolDefinedIn));
  return extra::makeCXString(S);
}

CXString clang_index_generateUSRForGlobalEnum(const char *EnumName,
                                              const char *ExtSymbolDefinedIn) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  clang::index::generateUSRForGlobalEnum(llvm::StringRef(EnumName), OS,
                                         llvm::StringRef(ExtSymbolDefinedIn));
  return extra::makeCXString(S);
}

CXString clang_index_generateUSRForEnumConstant(const char *EnumConstantName) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  clang::index::generateUSRForEnumConstant(llvm::StringRef(EnumConstantName), OS);
  return extra::makeCXString(S);
}

// generateUSRForMacro (MacroDefinitionRecord overload)

CXString clang_index_generateUSRForMacro(const char *MacroName, CXSourceLocation_ Loc,
                                         CXSourceManager SM) {
  llvm::SmallString<128> Buf;
  bool Failed = clang::index::generateUSRForMacro(
      llvm::StringRef(MacroName), clang::SourceLocation::getFromPtrEncoding(Loc),
      *reinterpret_cast<clang::SourceManager *>(SM), Buf);
  return usrFromBuf(Buf, Failed);
}

CXString clang_index_generateUSRForType(CXQualType T, CXASTContext Ctx) {
  llvm::SmallString<128> Buf;
  bool Failed = clang::index::generateUSRForType(clang::QualType::getFromOpaquePtr(T),
                                                 *reinterpret_cast<clang::ASTContext *>(Ctx),
                                                 Buf);
  return usrFromBuf(Buf, Failed);
}

CXString clang_index_generateFullUSRForModule(CXModule_ Mod) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  if (clang::index::generateFullUSRForModule(reinterpret_cast<clang::Module *>(Mod), OS))
    return extra::makeCXString("");
  return extra::makeCXString(S);
}

CXString clang_index_generateFullUSRForTopLevelModuleName(const char *ModName) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  if (clang::index::generateFullUSRForTopLevelModuleName(llvm::StringRef(ModName), OS))
    return extra::makeCXString("");
  return extra::makeCXString(S);
}

CXString clang_index_generateUSRFragmentForModule(CXModule_ Mod) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  if (clang::index::generateUSRFragmentForModule(reinterpret_cast<clang::Module *>(Mod), OS))
    return extra::makeCXString("");
  return extra::makeCXString(S);
}

CXString clang_index_generateUSRFragmentForModuleName(const char *ModName) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  if (clang::index::generateUSRFragmentForModuleName(llvm::StringRef(ModName), OS))
    return extra::makeCXString("");
  return extra::makeCXString(S);
}
