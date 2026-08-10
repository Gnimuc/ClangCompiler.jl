#include "clang-ex/Tooling/Inclusions/CXStandardLibrary.h"

#include "utils.h"

#include "clang/AST/DeclBase.h"
#include "clang/Tooling/Inclusions/StandardLibrary.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"

#include <memory>
#include <optional>
#include <string>
#include <vector>

namespace {

using StdlibHeader = clang::tooling::stdlib::Header;
using StdlibSymbol = clang::tooling::stdlib::Symbol;
using HeaderVec = std::vector<StdlibHeader>;
using SymbolVec = std::vector<StdlibSymbol>;

clang::tooling::stdlib::Lang toLang(CXStdlibLang L) {
  return static_cast<clang::tooling::stdlib::Lang>(L);
}

} // namespace

// stdlib::Header

CXStdlibHeaderList clang_stdlib_Header_all(CXStdlibLang L) {
  return reinterpret_cast<CXStdlibHeaderList>(
      std::make_unique<HeaderVec>(StdlibHeader::all(toLang(L))).release());
}

CXStdlibHeader clang_stdlib_Header_named(const char *Name, CXStdlibLang Language) {
  std::optional<StdlibHeader> H =
      StdlibHeader::named(llvm::StringRef(Name), toLang(Language));
  if (!H)
    return nullptr;
  return reinterpret_cast<CXStdlibHeader>(std::make_unique<StdlibHeader>(*H).release());
}

CXString clang_stdlib_Header_name(CXStdlibHeader H) {
  return extra::makeCXString(reinterpret_cast<StdlibHeader *>(H)->name().str());
}

void clang_stdlib_Header_dispose(CXStdlibHeader H) {
  delete reinterpret_cast<StdlibHeader *>(H);
}

unsigned clang_stdlib_HeaderList_getNumHeaders(CXStdlibHeaderList HL) {
  return static_cast<unsigned>(reinterpret_cast<HeaderVec *>(HL)->size());
}

CXStdlibHeader clang_stdlib_HeaderList_getHeader(CXStdlibHeaderList HL, unsigned I) {
  HeaderVec *V = reinterpret_cast<HeaderVec *>(HL);
  if (I >= V->size())
    return nullptr;
  return reinterpret_cast<CXStdlibHeader>(&(*V)[I]);
}

void clang_stdlib_HeaderList_dispose(CXStdlibHeaderList HL) {
  delete reinterpret_cast<HeaderVec *>(HL);
}

// stdlib::Symbol

CXStdlibSymbolList clang_stdlib_Symbol_all(CXStdlibLang L) {
  return reinterpret_cast<CXStdlibSymbolList>(
      std::make_unique<SymbolVec>(StdlibSymbol::all(toLang(L))).release());
}

CXStdlibSymbol clang_stdlib_Symbol_named(const char *Scope, const char *Name,
                                         CXStdlibLang Language) {
  std::optional<StdlibSymbol> S = StdlibSymbol::named(
      llvm::StringRef(Scope), llvm::StringRef(Name), toLang(Language));
  if (!S)
    return nullptr;
  return reinterpret_cast<CXStdlibSymbol>(std::make_unique<StdlibSymbol>(*S).release());
}

CXString clang_stdlib_Symbol_scope(CXStdlibSymbol S) {
  return extra::makeCXString(reinterpret_cast<StdlibSymbol *>(S)->scope().str());
}

CXString clang_stdlib_Symbol_name(CXStdlibSymbol S) {
  return extra::makeCXString(reinterpret_cast<StdlibSymbol *>(S)->name().str());
}

CXString clang_stdlib_Symbol_qualifiedName(CXStdlibSymbol S) {
  return extra::makeCXString(reinterpret_cast<StdlibSymbol *>(S)->qualifiedName().str());
}

CXStdlibHeader clang_stdlib_Symbol_header(CXStdlibSymbol S) {
  std::optional<StdlibHeader> H = reinterpret_cast<StdlibSymbol *>(S)->header();
  if (!H)
    return nullptr;
  return reinterpret_cast<CXStdlibHeader>(std::make_unique<StdlibHeader>(*H).release());
}

CXStdlibHeaderList clang_stdlib_Symbol_headers(CXStdlibSymbol S) {
  llvm::SmallVector<StdlibHeader> Hs = reinterpret_cast<StdlibSymbol *>(S)->headers();
  return reinterpret_cast<CXStdlibHeaderList>(
      std::make_unique<HeaderVec>(Hs.begin(), Hs.end()).release());
}

void clang_stdlib_Symbol_dispose(CXStdlibSymbol S) {
  delete reinterpret_cast<StdlibSymbol *>(S);
}

unsigned clang_stdlib_SymbolList_getNumSymbols(CXStdlibSymbolList SL) {
  return static_cast<unsigned>(reinterpret_cast<SymbolVec *>(SL)->size());
}

CXStdlibSymbol clang_stdlib_SymbolList_getSymbol(CXStdlibSymbolList SL, unsigned I) {
  SymbolVec *V = reinterpret_cast<SymbolVec *>(SL);
  if (I >= V->size())
    return nullptr;
  return reinterpret_cast<CXStdlibSymbol>(&(*V)[I]);
}

void clang_stdlib_SymbolList_dispose(CXStdlibSymbolList SL) {
  delete reinterpret_cast<SymbolVec *>(SL);
}

// stdlib::Recognizer

CXStdlibRecognizer clang_stdlib_Recognizer_create(void) {
  return reinterpret_cast<CXStdlibRecognizer>(
      std::make_unique<clang::tooling::stdlib::Recognizer>().release());
}

CXStdlibSymbol clang_stdlib_Recognizer_recognize(CXStdlibRecognizer R, CXDecl D) {
  std::optional<StdlibSymbol> S =
      (*reinterpret_cast<clang::tooling::stdlib::Recognizer *>(R))(
          reinterpret_cast<const clang::Decl *>(D));
  if (!S)
    return nullptr;
  return reinterpret_cast<CXStdlibSymbol>(std::make_unique<StdlibSymbol>(*S).release());
}

void clang_stdlib_Recognizer_dispose(CXStdlibRecognizer R) {
  delete reinterpret_cast<clang::tooling::stdlib::Recognizer *>(R);
}
