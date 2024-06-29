#include "clang-ex/Parse/CXParseAST.h"
#include "clang/CodeGen/ModuleBuilder.h"
#include "clang/Parse/ParseAST.h"
#include "clang/Parse/Parser.h"

void clang_ParseAST(CXSema Sema, bool PrintStats, bool SkipFunctionBodies) {
  clang::ParseAST(*static_cast<clang::Sema *>(Sema), PrintStats, SkipFunctionBodies);
}