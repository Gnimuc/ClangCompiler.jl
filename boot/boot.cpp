#include "boot.h"
#include "clang/CodeGen/ModuleBuilder.h"
#include "clang/Parse/Parser.h"
#include "clang/Sema/Sema.h"

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

void clang_Sema_processWeakTopLevelDecls(CXSema Sema, CXCodeGenerator CodeGen) {
  auto S = static_cast<clang::Sema *>(Sema);
  auto CG = static_cast<clang::CodeGenerator *>(CodeGen);
  for (clang::Decl *D : S->WeakTopLevelDecls())
    CG->HandleTopLevelDecl(clang::DeclGroupRef(D));
}