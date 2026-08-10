#ifndef LLVM_CLANG_C_EXTRA_CXPOSTORDERCFGVIEW_H
#define LLVM_CLANG_C_EXTRA_CXPOSTORDERCFGVIEW_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// PostOrderCFGView
// The canonical block order for a forward fixed-point analysis over a CFG. The view object
// itself has no handle: it holds nothing but the ordering, so it is built, drained into the
// caller's buffer and destroyed inside the one call below. CFGBlockSet, the iterators and
// BlockOrderCompare are consequently not wrapped either, and neither are the
// create/getTag ManagedAnalysis hooks (getAnalysis<T> is not wrapped).

// The blocks of G in reverse post order — clang::PostOrderCFGView(G) walked from begin() to
// end(). Returns the exact length of that order and writes min(N, length) blocks into Buf,
// no slot NULL (count+fill, MARSHALLING.md §6). The order visits only the blocks reachable
// from the entry, so the length can be smaller than clang_CFG_getNumBlocks and is never
// larger — that count is a safe buffer size for a single call. // helper
unsigned clang_PostOrderCFGView_getBlocksInReversePostOrder(CXCFG G, CXCFGBlock *Buf,
                                                            unsigned N);

LLVM_CLANG_C_EXTERN_C_END

#endif
