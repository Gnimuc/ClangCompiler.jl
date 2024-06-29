#include "clang-ex/Parse/CXParser.h"
#include "clang/Parse/Parser.h"
#include <cstdio>

CXParser clang_Parser_create(CXPreprocessor PP, CXSema Actions, bool SkipFunctionBodies,
                             CXInit_Error *ErrorCode) {
  CXInit_Error Err = CXInit_NoError;
  std::unique_ptr<clang::Parser> ptr = std::make_unique<clang::Parser>(
      *static_cast<clang::Preprocessor *>(PP), *static_cast<clang::Sema *>(Actions),
      SkipFunctionBodies);

  if (!ptr) {
    fprintf(stderr, "LIBCLANGEX ERROR: failed to create `clang::Parser`\n");
    Err = CXInit_CanNotCreate;
  }

  if (ErrorCode)
    *ErrorCode = Err;

  return ptr.release();
}

void clang_Parser_dispose(CXParser P) { delete static_cast<clang::Parser *>(P); }

void clang_Parser_Initialize(CXParser P) { static_cast<clang::Parser *>(P)->Initialize(); }

CXLangOptions clang_Parser_getLangOpts(CXParser P) {
  return const_cast<clang::LangOptions *>(&static_cast<clang::Parser *>(P)->getLangOpts());
}

CXTargetInfo_ clang_Parser_getTargetInfo(CXParser P) {
  return const_cast<clang::TargetInfo *>(&static_cast<clang::Parser *>(P)->getTargetInfo());
}

CXPreprocessor clang_Parser_getPreprocessor(CXParser P) {
  return &static_cast<clang::Parser *>(P)->getPreprocessor();
}

CXSema clang_Parser_getActions(CXParser P) {
  return &static_cast<clang::Parser *>(P)->getActions();
}

CXToken_ clang_Parser_getCurToken(CXParser P) {
  return const_cast<clang::Token *>(&static_cast<clang::Parser *>(P)->getCurToken());
}

CXToken_ clang_Parser_NextToken(CXParser P) {
  return const_cast<clang::Token *>(&static_cast<clang::Parser *>(P)->NextToken());
}

CXScope clang_Parser_getCurScope(CXParser P) {
  return static_cast<clang::Parser *>(P)->getCurScope();
}

CXSourceLocation_ clang_Parser_ConsumeToken(CXParser P) {
  return static_cast<clang::Parser *>(P)->ConsumeToken().getPtrEncoding();
}

CXSourceLocation_ clang_Parser_ConsumeAnyToken(CXParser P) {
  return static_cast<clang::Parser *>(P)->ConsumeAnyToken(true).getPtrEncoding();
}

bool clang_Parser_TryAnnotateCXXScopeToken(CXParser P, bool EnteringContext) {
  return static_cast<clang::Parser *>(P)->TryAnnotateCXXScopeToken(EnteringContext);
}

bool clang_Parser_TryAnnotateTypeOrScopeTokenAfterScopeSpec(CXParser P, CXCXXScopeSpec SS,
                                                            bool IsNewScope) {
  return static_cast<clang::Parser *>(P)->TryAnnotateTypeOrScopeTokenAfterScopeSpec(
      *static_cast<clang::CXXScopeSpec *>(SS), IsNewScope);
}

CXDeclGroupRef clang_Parser_parseOneTopLevelDecl(CXParser Parser, bool IsFirstDecl) {
  clang::Parser::DeclGroupPtrTy ADecl;
  static_cast<clang::Parser *>(Parser)->ParseTopLevelDecl(ADecl, IsFirstDecl);
  if (ADecl)
    return ADecl.get().getAsOpaquePtr();
  else
    return nullptr;
}