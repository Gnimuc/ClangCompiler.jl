#ifndef LLVM_CLANG_C_EXTRA_CXMULTIPLEXCONSUMER_H
#define LLVM_CLANG_C_EXTRA_CXMULTIPLEXCONSUMER_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// MultiplexASTDeserializationListener

// MultiplexConsumer
// An ASTConsumer that forwards every callback to a list of children, which is the only way
// to run two consumers over one parse: a CompilerInstance holds exactly one.
//
// ADOPTION (children): the multiplexer takes ownership of every consumer in `Consumers`,
// exactly as clang::MultiplexConsumer's vector<unique_ptr<ASTConsumer>> constructor does.
// Each child's own dispose becomes a double free the moment this returns, whether or not
// the multiplexer itself is ever installed. `Consumers` itself is only read here; the
// caller keeps the array.
//
// ADOPTION (the multiplexer): clang_CompilerInstance_setASTConsumer rewraps this in a
// unique_ptr, so once installed the instance frees it and clang_ASTConsumer_dispose below
// is a double free -- use clang_CompilerInstance_takeASTConsumer to get ownership back
// first. Until it is installed, the returned handle is caller-owned and is released with
// clang_ASTConsumer_dispose from clang-ex/AST/CXASTConsumer.h, which deletes through
// ASTConsumer's virtual destructor and so takes the children with it.
//
// The handle is the base CXASTConsumer: the class adds nothing a caller of this library can
// reach that ASTConsumer does not already declare.
CXASTConsumer clang_MultiplexConsumer_create(CXASTConsumer *Consumers, unsigned NumConsumers);

LLVM_CLANG_C_EXTERN_C_END

#endif
