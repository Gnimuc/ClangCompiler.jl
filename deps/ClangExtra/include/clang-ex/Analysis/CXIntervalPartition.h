#ifndef LLVM_CLANG_C_EXTRA_CXINTERVALPARTITION_H
#define LLVM_CLANG_C_EXTRA_CXINTERVALPARTITION_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// A weak topological ordering (Bourdoncle) of G's blocks: loop heads are grouped with
// their bodies and the groups are ordered topologically, which bounds how often a
// widening fixpoint has to revisit a node. clang::WeakTopologicalOrdering is a plain
// std::vector<const CFGBlock *>, so it flattens into the caller's buffer; the ordering
// exists only for a reducible CFG, and clang returns std::nullopt otherwise.
//
// *Found receives whether G is reducible. When it is false the result is 0 and nothing is
// written. Otherwise the result is the exact length of the ordering and Buf receives
// min(N, length) blocks, none of them NULL (count+fill, MARSHALLING.md §6). The ordering
// covers a subset of G's blocks, so clang_CFG_getNumBlocks is a safe buffer size for a
// single call — which matters here, because each call re-partitions the graph.
//
// WTOCompare (the total order the ordering induces) and the internal:: interval-graph API
// are not wrapped.
unsigned clang_getIntervalWTO(CXCFG G, CXCFGBlock *Buf, unsigned N, bool *Found);

LLVM_CLANG_C_EXTERN_C_END

#endif
