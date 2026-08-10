#ifndef LLVM_CLANG_C_EXTRA_CXREACHABLECODE_H
#define LLVM_CLANG_C_EXTRA_CXREACHABLECODE_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Mirrors clang::reachable_code::UnreachableKind. CXEnumSync.cpp proves value-for-value
// equality.
typedef enum CXUnreachableKind {
  CXUnreachableKind_UK_Return,
  CXUnreachableKind_UK_Break,
  CXUnreachableKind_UK_Loop_Increment,
  CXUnreachableKind_UK_Other
} CXUnreachableKind;

// clang::reachable_code::ScanReachableFromBlock — every block reachable from Start. clang
// marks them in a caller-supplied llvm::BitVector indexed by block ID; the shim allocates
// that vector at the graph's ID count, runs the scan and turns the marked IDs back into
// blocks, so the BitVector never crosses. Returns the number of reachable blocks and writes
// min(N, that) of them into Buf, in clang_CFG_getBlock order and never NULL (count+fill,
// MARSHALLING.md §6). Start's own parent graph is the one scanned, so
// clang_CFG_getNumBlocks of it is a safe buffer size for a single call.
unsigned clang_reachable_code_ScanReachableFromBlock(CXCFGBlock Start, CXCFGBlock *Buf,
                                                     unsigned N);

// FindUnreachableCode
// The -Wunreachable-code dead-code analysis. clang reports through
// clang::reachable_code::Callback::HandleUnreachable, a pure virtual taking six values that
// live only for the duration of the call. As for the uninitialized-values analysis, the
// shim compiles ONE fixed subclass of that callback which copies every report into a
// buffer, and the analysis crosses as that caller-owned buffer rather than as a function
// pointer (MARSHALLING.md §10).

// Runs clang::reachable_code::FindUnreachableCode over ADC's CFG and returns the recorded
// reports. CALLER-OWNED — pair with clang_UnreachableCodeResult_dispose. An ADC with no CFG
// produces an empty result rather than an error. PP is the preprocessor whose macro
// expansion history the analysis consults to suppress reports inside configuration macros;
// it must be the one that produced ADC's translation unit.
CXUnreachableCodeResult clang_UnreachableCodeResult_create(CXAnalysisDeclContext ADC,
                                                           CXPreprocessor PP);

void clang_UnreachableCodeResult_dispose(CXUnreachableCodeResult R);

// The recorded reports, in the order clang produced them; 0 <= I < getNumUnreachable for
// every accessor below. // helper
unsigned clang_UnreachableCodeResult_getNumUnreachable(CXUnreachableCodeResult R);

// HandleUnreachable's UK — what kind of statement the dead region starts with. // helper
CXUnreachableKind clang_UnreachableCodeResult_getKind(CXUnreachableCodeResult R,
                                                      unsigned I);

// HandleUnreachable's L — where the dead region starts. // helper
CXSourceLocation_ clang_UnreachableCodeResult_getLocation(CXUnreachableCodeResult R,
                                                          unsigned I);

// HandleUnreachable's ConditionVal — the condition that made the region dead, invalid when
// none was identified. // helper
CXSourceRange_ clang_UnreachableCodeResult_getConditionValRange(CXUnreachableCodeResult R,
                                                                unsigned I);

// HandleUnreachable's R1 and R2 — the two ranges clang would underline in the diagnostic;
// either may be invalid. // helper
CXSourceRange_ clang_UnreachableCodeResult_getR1(CXUnreachableCodeResult R, unsigned I);

CXSourceRange_ clang_UnreachableCodeResult_getR2(CXUnreachableCodeResult R,
                                                 unsigned I); // helper

// HandleUnreachable's HasFallThroughAttr — whether the dead region carries
// [[fallthrough]]. // helper
bool clang_UnreachableCodeResult_getHasFallThroughAttr(CXUnreachableCodeResult R,
                                                       unsigned I);

LLVM_CLANG_C_EXTERN_C_END

#endif
