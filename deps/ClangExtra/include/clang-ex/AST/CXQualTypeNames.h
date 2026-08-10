#ifndef LLVM_CLANG_C_EXTRA_CXQUALTYPENAMES_H
#define LLVM_CLANG_C_EXTRA_CXQUALTYPENAMES_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "clang-c/CXString.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang::TypeName is a namespace of two free functions, so the namespace stands in for the
// class segment. Both re-spell a type as it would have to be written at the end of the
// translation unit: namespaces expanded, using-declarations resolved, template arguments
// qualified. This is what a printer's own output cannot give, since a printer spells the
// type as it was written.

// The fully-qualified spelling. WithGlobalNsPrefix prepends "::".
CXString clang_TypeName_getFullyQualifiedName(CXQualType QT, CXASTContext Ctx,
                                              CXPrintingPolicy_ Policy,
                                              bool WithGlobalNsPrefix);

// The same requalification as a QualType rather than a string, for feeding back into the
// AST rather than displaying.
CXQualType clang_TypeName_getFullyQualifiedType(CXQualType QT, CXASTContext Ctx,
                                                bool WithGlobalNsPrefix);

LLVM_CLANG_C_EXTERN_C_END

#endif
