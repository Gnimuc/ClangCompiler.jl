#ifndef LLVM_CLANG_C_EXTRA_LIB_SEMA_CXTEMPLATEBOX_H
#define LLVM_CLANG_C_EXTRA_LIB_SEMA_CXTEMPLATEBOX_H

#include "clang-ex/CXTypes.h"
#include "clang/Sema/Template.h"

// Private to lib/ — never included from include/clang-ex, never installed, and never seen
// by the binding generator (which walks include/clang-ex only).
//
// A CXMultiLevelTemplateArgumentList is not a bare clang::MultiLevelTemplateArgumentList:
// the C++ class stores every level as a borrowed ArrayRef<TemplateArgument>, so the handle
// is a box that owns a copy of each level and holds the value last (MARSHALLING.md §10).
// That box type is file-local to lib/Sema/CXTemplate.cpp. Any other translation unit that
// must pass the list on to a clang API — lib/Sema/CXSema.cpp and the Sema::Subst* family —
// goes through this one accessor instead of redeclaring the box layout, which would be
// type punning across two anonymous namespaces.
namespace extra {

clang::MultiLevelTemplateArgumentList &
unboxMultiLevelTemplateArgumentList(CXMultiLevelTemplateArgumentList ML);

} // namespace extra

#endif
