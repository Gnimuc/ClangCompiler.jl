#include "clang-ex/Index/CXIndexSymbol.h"

#include "utils.h"

#include "clang/AST/DeclBase.h"
#include "clang/Basic/LangOptions.h"
#include "clang/Index/IndexSymbol.h"
#include "clang/Lex/MacroInfo.h"
#include "llvm/Support/raw_ostream.h"

#include <string>

static void unpack(const clang::index::SymbolInfo &Info, CXSymbolKind *Kind,
                   CXSymbolSubKind *SubKind, CXSymbolLanguage *Lang,
                   unsigned *Properties) {
  *Kind = static_cast<CXSymbolKind>(Info.Kind);
  *SubKind = static_cast<CXSymbolSubKind>(Info.SubKind);
  *Lang = static_cast<CXSymbolLanguage>(Info.Lang);
  *Properties = Info.Properties;
}

void clang_index_getSymbolInfo(CXDecl D, CXSymbolKind *Kind, CXSymbolSubKind *SubKind,
                               CXSymbolLanguage *Lang, unsigned *Properties) {
  unpack(clang::index::getSymbolInfo(reinterpret_cast<clang::Decl *>(D)), Kind, SubKind,
         Lang, Properties);
}

void clang_index_getSymbolInfoForMacro(CXMacroInfo MI, CXSymbolKind *Kind,
                                       CXSymbolSubKind *SubKind, CXSymbolLanguage *Lang,
                                       unsigned *Properties) {
  unpack(clang::index::getSymbolInfoForMacro(*reinterpret_cast<clang::MacroInfo *>(MI)),
         Kind, SubKind, Lang, Properties);
}

bool clang_index_isFunctionLocalSymbol(CXDecl D) {
  return clang::index::isFunctionLocalSymbol(reinterpret_cast<clang::Decl *>(D));
}

CXString clang_index_getSymbolKindString(CXSymbolKind K) {
  return extra::makeCXString(
      clang::index::getSymbolKindString(static_cast<clang::index::SymbolKind>(K)).str());
}

CXString clang_index_getSymbolSubKindString(CXSymbolSubKind K) {
  return extra::makeCXString(
      clang::index::getSymbolSubKindString(static_cast<clang::index::SymbolSubKind>(K))
          .str());
}

CXString clang_index_getSymbolLanguageString(CXSymbolLanguage K) {
  return extra::makeCXString(
      clang::index::getSymbolLanguageString(static_cast<clang::index::SymbolLanguage>(K))
          .str());
}

CXString clang_index_printSymbolName(CXDecl D, CXLangOptions LO) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  // The bool is "true if NO name was printed" -- folded into the empty string.
  if (clang::index::printSymbolName(reinterpret_cast<clang::Decl *>(D),
                                    *reinterpret_cast<clang::LangOptions *>(LO), OS))
    return extra::makeCXString("");
  return extra::makeCXString(S);
}

CXString clang_index_printSymbolRoles(unsigned Roles) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  clang::index::printSymbolRoles(Roles, OS);
  return extra::makeCXString(S);
}

CXString clang_index_printSymbolProperties(unsigned Props) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  clang::index::printSymbolProperties(
      static_cast<clang::index::SymbolPropertySet>(Props), OS);
  return extra::makeCXString(S);
}
