#include "clang-ex/Tooling/Syntax/CXTokens.h"

#include "utils.h"

#include "clang/Basic/LangOptions.h"
#include "clang/Basic/SourceLocation.h"
#include "clang/Basic/SourceManager.h"
#include "clang/Lex/Preprocessor.h"
#include "clang/Tooling/Syntax/Tokens.h"
#include "llvm/ADT/ArrayRef.h"

#include <memory>
#include <optional>
#include <utility>
#include <vector>

namespace {

using SyntaxToken = clang::syntax::Token;
using TokenVec = std::vector<SyntaxToken>;

CXSyntaxTokenList boxTokens(TokenVec V) {
  return reinterpret_cast<CXSyntaxTokenList>(
      std::make_unique<TokenVec>(std::move(V)).release());
}

CXSyntaxTokenList boxTokens(llvm::ArrayRef<SyntaxToken> A) {
  return reinterpret_cast<CXSyntaxTokenList>(
      std::make_unique<TokenVec>(A.begin(), A.end()).release());
}

} // namespace

// syntax::Token

unsigned clang_syntax_Token_kind(CXSyntaxToken T) {
  return static_cast<unsigned>(reinterpret_cast<SyntaxToken *>(T)->kind());
}

CXSourceLocation_ clang_syntax_Token_location(CXSyntaxToken T) {
  return reinterpret_cast<CXSourceLocation_>(
      reinterpret_cast<SyntaxToken *>(T)->location().getPtrEncoding());
}

CXSourceLocation_ clang_syntax_Token_endLocation(CXSyntaxToken T) {
  return reinterpret_cast<CXSourceLocation_>(
      reinterpret_cast<SyntaxToken *>(T)->endLocation().getPtrEncoding());
}

unsigned clang_syntax_Token_length(CXSyntaxToken T) {
  return reinterpret_cast<SyntaxToken *>(T)->length();
}

CXString clang_syntax_Token_text(CXSyntaxToken T, CXSourceManager SM) {
  return extra::makeCXString(
      reinterpret_cast<SyntaxToken *>(T)
          ->text(*reinterpret_cast<clang::SourceManager *>(SM))
          .str());
}

CXString clang_syntax_Token_str(CXSyntaxToken T) {
  return extra::makeCXString(reinterpret_cast<SyntaxToken *>(T)->str());
}

// the shim-owned token vector

unsigned clang_syntax_TokenList_getNumTokens(CXSyntaxTokenList TL) {
  return static_cast<unsigned>(reinterpret_cast<TokenVec *>(TL)->size());
}

CXSyntaxToken clang_syntax_TokenList_getToken(CXSyntaxTokenList TL, unsigned I) {
  TokenVec *V = reinterpret_cast<TokenVec *>(TL);
  if (I >= V->size())
    return nullptr;
  return reinterpret_cast<CXSyntaxToken>(&(*V)[I]);
}

void clang_syntax_TokenList_dispose(CXSyntaxTokenList TL) {
  delete reinterpret_cast<TokenVec *>(TL);
}

CXSyntaxTokenList clang_syntax_tokenize(CXFileID FID, CXSourceManager SM,
                                        CXLangOptions LO) {
  return boxTokens(clang::syntax::tokenize(*reinterpret_cast<clang::FileID *>(FID),
                                           *reinterpret_cast<clang::SourceManager *>(SM),
                                           *reinterpret_cast<clang::LangOptions *>(LO)));
}

CXSyntaxTokenList clang_syntax_tokenizeFileRange(CXFileID FID, unsigned BeginOffset,
                                                 unsigned EndOffset, CXSourceManager SM,
                                                 CXLangOptions LO) {
  clang::syntax::FileRange FR(*reinterpret_cast<clang::FileID *>(FID), BeginOffset,
                              EndOffset);
  return boxTokens(clang::syntax::tokenize(FR,
                                           *reinterpret_cast<clang::SourceManager *>(SM),
                                           *reinterpret_cast<clang::LangOptions *>(LO)));
}

// syntax::TokenBuffer

CXSyntaxTokenList clang_syntax_TokenBuffer_expandedTokens(CXTokenBuffer TB) {
  return boxTokens(reinterpret_cast<clang::syntax::TokenBuffer *>(TB)->expandedTokens());
}

CXSyntaxTokenList clang_syntax_TokenBuffer_expandedTokensInRange(CXTokenBuffer TB,
                                                                 CXSourceRange_ R) {
  clang::SourceRange SR(clang::SourceLocation::getFromPtrEncoding(R.B),
                        clang::SourceLocation::getFromPtrEncoding(R.E));
  return boxTokens(reinterpret_cast<clang::syntax::TokenBuffer *>(TB)->expandedTokens(SR));
}

void clang_syntax_TokenBuffer_indexExpandedTokens(CXTokenBuffer TB) {
  reinterpret_cast<clang::syntax::TokenBuffer *>(TB)->indexExpandedTokens();
}

CXSyntaxTokenList clang_syntax_TokenBuffer_spelledTokens(CXTokenBuffer TB, CXFileID FID) {
  return boxTokens(reinterpret_cast<clang::syntax::TokenBuffer *>(TB)->spelledTokens(
      *reinterpret_cast<clang::FileID *>(FID)));
}

CXSyntaxToken clang_syntax_TokenBuffer_spelledTokenAt(CXTokenBuffer TB,
                                                      CXSourceLocation_ Loc) {
  const SyntaxToken *T =
      reinterpret_cast<clang::syntax::TokenBuffer *>(TB)->spelledTokenAt(
          clang::SourceLocation::getFromPtrEncoding(Loc));
  return reinterpret_cast<CXSyntaxToken>(const_cast<SyntaxToken *>(T));
}

CXSyntaxTokenList clang_syntax_TokenBuffer_spelledForExpanded(CXTokenBuffer TB,
                                                              unsigned Begin,
                                                              unsigned Count) {
  clang::syntax::TokenBuffer *Buf = reinterpret_cast<clang::syntax::TokenBuffer *>(TB);
  llvm::ArrayRef<SyntaxToken> Expanded = Buf->expandedTokens();
  // spelledForExpanded EXPECTS a non-empty subrange of expandedTokens(); anything else is
  // out of contract, so it is rejected here rather than passed on.
  if (Count == 0 || Begin >= Expanded.size() || Count > Expanded.size() - Begin)
    return nullptr;
  std::optional<llvm::ArrayRef<SyntaxToken>> Spelled =
      Buf->spelledForExpanded(Expanded.slice(Begin, Count));
  if (!Spelled)
    return nullptr;
  return boxTokens(*Spelled);
}

CXSourceManager clang_syntax_TokenBuffer_sourceManager(CXTokenBuffer TB) {
  return reinterpret_cast<CXSourceManager>(const_cast<clang::SourceManager *>(
      &reinterpret_cast<clang::syntax::TokenBuffer *>(TB)->sourceManager()));
}

CXString clang_syntax_TokenBuffer_dumpForTests(CXTokenBuffer TB) {
  return extra::makeCXString(
      reinterpret_cast<clang::syntax::TokenBuffer *>(TB)->dumpForTests());
}

void clang_syntax_TokenBuffer_dispose(CXTokenBuffer TB) {
  delete reinterpret_cast<clang::syntax::TokenBuffer *>(TB);
}

// syntax::TokenCollector

CXTokenCollector clang_syntax_TokenCollector_create(CXPreprocessor PP) {
  return reinterpret_cast<CXTokenCollector>(
      std::make_unique<clang::syntax::TokenCollector>(
          *reinterpret_cast<clang::Preprocessor *>(PP))
          .release());
}

CXTokenBuffer clang_syntax_TokenCollector_consume(CXTokenCollector TC) {
  clang::syntax::TokenCollector *C = reinterpret_cast<clang::syntax::TokenCollector *>(TC);
  return reinterpret_cast<CXTokenBuffer>(
      std::make_unique<clang::syntax::TokenBuffer>(std::move(*C).consume()).release());
}

void clang_syntax_TokenCollector_dispose(CXTokenCollector TC) {
  delete reinterpret_cast<clang::syntax::TokenCollector *>(TC);
}
