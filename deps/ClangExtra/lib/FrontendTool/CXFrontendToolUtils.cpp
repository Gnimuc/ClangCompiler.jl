#include "clang-ex/FrontendTool/CXFrontendToolUtils.h"
#include "clang/Frontend/CompilerInstance.h"
#include "clang/Frontend/FrontendAction.h"
#include "clang/FrontendTool/Utils.h"

CXFrontendAction clang_CreateFrontendAction(CXCompilerInstance CI) {
  auto FA = clang::CreateFrontendAction(*reinterpret_cast<clang::CompilerInstance *>(CI));
  return reinterpret_cast<CXFrontendAction>(FA.release());
}

bool clang_ExecuteCompilerInvocation(CXCompilerInstance CI) {
  return clang::ExecuteCompilerInvocation(reinterpret_cast<clang::CompilerInstance *>(CI));
}
