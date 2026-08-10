#include "clang-ex/Lex/CXModuleLoader.h"

#include "clang/Lex/ModuleLoader.h"

#include <memory>

CXModuleLoader clang_TrivialModuleLoader_create(void) {
  return reinterpret_cast<CXModuleLoader>(
      std::make_unique<clang::TrivialModuleLoader>().release());
}

void clang_TrivialModuleLoader_dispose(CXModuleLoader ML) {
  // `ModuleLoader`'s destructor is virtual, so deleting through the base is what tears the
  // TrivialModuleLoader down.
  delete reinterpret_cast<clang::ModuleLoader *>(ML);
}
