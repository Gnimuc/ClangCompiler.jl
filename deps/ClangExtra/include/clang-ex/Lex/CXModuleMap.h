#ifndef LLVM_CLANG_C_EXTRA_CXMODULEMAP_H
#define LLVM_CLANG_C_EXTRA_CXMODULEMAP_H

#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang::ModuleMap::ModuleHeaderRole.
//
// This is a BITMASK, not a discriminated kind. Clang packs it into a 3-bit PointerIntPair
// and tests it with `Role & (TextualHeader | ExcludedHeader)` (ModuleMap::isModular), so a
// combination such as PrivateHeader|TextualHeader (0x3) is a legal runtime value that
// matches none of the enumerators below. Every crossing that carries a role therefore
// declares it `unsigned`, never this type; the enum exists only to name the four constants
// on both sides of the boundary.
typedef enum CXModuleHeaderRole {
  CXModuleHeaderRole_NormalHeader = 0x0,
  CXModuleHeaderRole_PrivateHeader = 0x1,
  CXModuleHeaderRole_TextualHeader = 0x2,
  CXModuleHeaderRole_ExcludedHeader = 0x4
} CXModuleHeaderRole;

LLVM_CLANG_C_EXTERN_C_END

#endif
