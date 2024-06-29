#include "clang-ex/Parse/CXParseAST.h"
#include "clang/CodeGen/ModuleBuilder.h"
#include "clang/Parse/ParseAST.h"
#include "clang/Parse/Parser.h"

void clang_ParseAST(CXSema Sema, bool PrintStats, bool SkipFunctionBodies) {
  clang::ParseAST(*static_cast<clang::Sema *>(Sema), PrintStats, SkipFunctionBodies);
}

bool clang_Parser_tryParseAndSkipInvalidOrParsedDecl(CXParser Parser,
                                                     CXCodeGenerator CodeGen) {
  auto P = static_cast<clang::Parser *>(Parser);
  auto CG = static_cast<clang::CodeGenerator *>(CodeGen);
  clang::Parser::DeclGroupPtrTy ADecl;
  for (bool AtEOF = P->ParseFirstTopLevelDecl(ADecl); !AtEOF;
       AtEOF = P->ParseTopLevelDecl(ADecl)) {
    if (ADecl && !CG->HandleTopLevelDecl(ADecl.get()))
      return false;
  }
  return true;
}