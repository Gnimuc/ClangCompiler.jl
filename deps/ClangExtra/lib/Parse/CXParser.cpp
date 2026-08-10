#include "clang-ex/Parse/CXParser.h"
#include "clang/Parse/Parser.h"
#include "llvm/ADT/SmallVector.h"

#include <memory>

CXParser clang_Parser_create(CXPreprocessor PP, CXSema Actions, bool SkipFunctionBodies) {
  auto P = std::make_unique<clang::Parser>(*reinterpret_cast<clang::Preprocessor *>(PP),
                                           *reinterpret_cast<clang::Sema *>(Actions),
                                           SkipFunctionBodies);
  return reinterpret_cast<CXParser>(P.release());
}

void clang_Parser_dispose(CXParser P) { delete reinterpret_cast<clang::Parser *>(P); }

void clang_Parser_Initialize(CXParser P) { reinterpret_cast<clang::Parser *>(P)->Initialize(); }

CXLangOptions clang_Parser_getLangOpts(CXParser P) {
  return reinterpret_cast<CXLangOptions>(const_cast<clang::LangOptions *>(&reinterpret_cast<clang::Parser *>(P)->getLangOpts()));
}

CXTargetInfo_ clang_Parser_getTargetInfo(CXParser P) {
  return reinterpret_cast<CXTargetInfo_>(const_cast<clang::TargetInfo *>(&reinterpret_cast<clang::Parser *>(P)->getTargetInfo()));
}

CXPreprocessor clang_Parser_getPreprocessor(CXParser P) {
  return reinterpret_cast<CXPreprocessor>(&reinterpret_cast<clang::Parser *>(P)->getPreprocessor());
}

CXSema clang_Parser_getActions(CXParser P) {
  return reinterpret_cast<CXSema>(&reinterpret_cast<clang::Parser *>(P)->getActions());
}

CXToken_ clang_Parser_getCurToken(CXParser P) {
  return reinterpret_cast<CXToken_>(const_cast<clang::Token *>(&reinterpret_cast<clang::Parser *>(P)->getCurToken()));
}

CXToken_ clang_Parser_NextToken(CXParser P) {
  return reinterpret_cast<CXToken_>(const_cast<clang::Token *>(&reinterpret_cast<clang::Parser *>(P)->NextToken()));
}

CXScope clang_Parser_getCurScope(CXParser P) {
  return reinterpret_cast<CXScope>(reinterpret_cast<clang::Parser *>(P)->getCurScope());
}

CXSourceLocation_ clang_Parser_ConsumeToken(CXParser P) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::Parser *>(P)->ConsumeToken().getPtrEncoding());
}

CXSourceLocation_ clang_Parser_ConsumeAnyToken(CXParser P) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::Parser *>(P)->ConsumeAnyToken(true).getPtrEncoding());
}

bool clang_Parser_TryAnnotateTypeOrScopeToken(CXParser P, bool AllowImplicitTypename) {
  return reinterpret_cast<clang::Parser *>(P)->TryAnnotateTypeOrScopeToken(
      AllowImplicitTypename ? clang::ImplicitTypenameContext::Yes
                            : clang::ImplicitTypenameContext::No);
}

bool clang_Parser_TryAnnotateTypeOrScopeTokenAfterScopeSpec(CXParser P, CXCXXScopeSpec SS,
                                                            bool IsNewScope,
                                                            bool AllowImplicitTypename) {
  return reinterpret_cast<clang::Parser *>(P)->TryAnnotateTypeOrScopeTokenAfterScopeSpec(
      *reinterpret_cast<clang::CXXScopeSpec *>(SS), IsNewScope,
      AllowImplicitTypename ? clang::ImplicitTypenameContext::Yes
                            : clang::ImplicitTypenameContext::No);
}

bool clang_Parser_TryAnnotateCXXScopeToken(CXParser P, bool EnteringContext) {
  return reinterpret_cast<clang::Parser *>(P)->TryAnnotateCXXScopeToken(EnteringContext);
}

bool clang_Parser_TryAnnotateOptionalCXXScopeToken(CXParser P, bool EnteringContext) {
  return reinterpret_cast<clang::Parser *>(P)->TryAnnotateOptionalCXXScopeToken(EnteringContext);
}

CXQualType clang_Parser_getTypeAnnotation(CXToken_ Tok) {
  return reinterpret_cast<CXQualType>(clang::Parser::getTypeAnnotation(*reinterpret_cast<clang::Token *>(Tok))
      .get()
      .getAsOpaquePtr());
}

// CXDeclGroupRef clang_Parser_parseOneTopLevelDecl(CXParser Parser, bool IsFirstDecl) {
//   clang::Parser::DeclGroupPtrTy ADecl;
//   static_cast<clang::Parser *>(Parser)->ParseTopLevelDecl(ADecl, IsFirstDecl);
//   if (ADecl)
//     return ADecl.get().getAsOpaquePtr();
//   else
//     return nullptr;
// }
bool clang_Parser_ParseFirstTopLevelDecl(CXParser P, CXDeclGroupRef *Result,
                                         unsigned *ImportState) {
  clang::Parser::DeclGroupPtrTy ADecl;
  auto IS = static_cast<clang::Sema::ModuleImportState>(*ImportState);
  bool AtEOF = reinterpret_cast<clang::Parser *>(P)->ParseFirstTopLevelDecl(ADecl, IS);
  *ImportState = static_cast<unsigned>(IS);
  *Result = reinterpret_cast<CXDeclGroupRef>(ADecl.getAsOpaquePtr());
  return AtEOF;
}

bool clang_Parser_ParseTopLevelDecl(CXParser P, CXDeclGroupRef *Result,
                                    unsigned *ImportState) {
  clang::Parser::DeclGroupPtrTy ADecl;
  auto IS = static_cast<clang::Sema::ModuleImportState>(*ImportState);
  bool AtEOF = reinterpret_cast<clang::Parser *>(P)->ParseTopLevelDecl(ADecl, IS);
  *ImportState = static_cast<unsigned>(IS);
  *Result = reinterpret_cast<CXDeclGroupRef>(ADecl.getAsOpaquePtr());
  return AtEOF;
}

bool clang_Parser_SkipUntil(CXParser P, const unsigned *Toks, unsigned NumToks,
                            unsigned Flags) {
  llvm::SmallVector<clang::tok::TokenKind, 8> Kinds;
  Kinds.reserve(NumToks);
  for (unsigned I = 0; I < NumToks; ++I)
    Kinds.push_back(static_cast<clang::tok::TokenKind>(Toks[I]));
  return reinterpret_cast<clang::Parser *>(P)->SkipUntil(
      Kinds, static_cast<clang::Parser::SkipUntilFlags>(Flags));
}
