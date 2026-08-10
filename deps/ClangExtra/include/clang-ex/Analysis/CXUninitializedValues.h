#ifndef LLVM_CLANG_C_EXTRA_CXUNINITIALIZEDVALUES_H
#define LLVM_CLANG_C_EXTRA_CXUNINITIALIZEDVALUES_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Mirrors clang::UninitUse::Kind (a plain enum nested in UninitUse). CXEnumSync.cpp proves
// value-for-value equality.
typedef enum CXUninitUseKind {
  CXUninitUseKind_Maybe,
  CXUninitUseKind_Sometimes,
  CXUninitUseKind_AfterDecl,
  CXUninitUseKind_AfterCall,
  CXUninitUseKind_Always
} CXUninitUseKind;

// runUninitializedVariablesAnalysis
// The -Wuninitialized dataflow. clang reports through clang::UninitVariablesHandler, whose
// three callbacks are virtual, and hands each report out as a clang::UninitUse temporary
// that dies with the callback; neither survives the C boundary. The shim therefore compiles
// ONE fixed subclass of that handler which copies every report into a buffer, and the whole
// analysis crosses as that caller-owned buffer instead of as a callback (MARSHALLING.md
// §10). No Julia function pointer is involved, and nothing has to stay alive during the
// run. UninitUse itself, its Branch struct and UninitVariablesAnalysisStats are read out of
// the buffer field by field below rather than getting handles of their own.

// Runs clang::runUninitializedVariablesAnalysis over G and returns the recorded reports.
// CALLER-OWNED — pair with clang_UninitVariablesResult_dispose. DC supplies the variables
// to analyze and G the graph to walk them over; clang's own caller passes
// cast<DeclContext>(ADC->getDecl()) and ADC->getCFG(), and G must be that graph, because
// the analysis indexes it by the block IDs of ADC's own post-order view. The result holds
// only borrowed AST pointers, so it stays valid exactly as long as the AST does.
CXUninitVariablesResult clang_UninitVariablesResult_create(CXDeclContext DC, CXCFG G,
                                                           CXAnalysisDeclContext ADC);

void clang_UninitVariablesResult_dispose(CXUninitVariablesResult R);

// clang::UninitVariablesAnalysisStats, filled by the run.
unsigned clang_UninitVariablesResult_getNumVariablesAnalyzed(CXUninitVariablesResult R);

unsigned clang_UninitVariablesResult_getNumBlockVisits(CXUninitVariablesResult R);

// The recorded uses, in the order clang reported them; 0 <= I < getNumUses for every
// accessor below. // helper
unsigned clang_UninitVariablesResult_getNumUses(CXUninitVariablesResult R);

// The variable used uninitialized — the handler's `vd`. Never NULL. // helper
CXVarDecl clang_UninitVariablesResult_getVarDecl(CXUninitVariablesResult R, unsigned I);

// clang::UninitUse::getUser — the expression that reads it. // helper
CXExpr clang_UninitVariablesResult_getUser(CXUninitVariablesResult R, unsigned I);

// clang::UninitUse::getKind. // helper
CXUninitUseKind clang_UninitVariablesResult_getKind(CXUninitVariablesResult R, unsigned I);

// Whether the report came through handleConstRefUseOfUninitVariable (the variable was
// passed as a const reference) rather than handleUseOfUninitVariable. // helper
bool clang_UninitVariablesResult_isConstRefUse(CXUninitVariablesResult R, unsigned I);

// clang::UninitUse::Branch — the branches after which the use is inevitably
// uninitialized, non-empty exactly for the Sometimes kind. The Branch value type is
// decomposed into its terminator statement and its output index (MARSHALLING.md §7);
// 0 <= J < getNumBranches(R, I). // helper
unsigned clang_UninitVariablesResult_getNumBranches(CXUninitVariablesResult R, unsigned I);

CXStmt clang_UninitVariablesResult_getBranchTerminator(CXUninitVariablesResult R,
                                                       unsigned I, unsigned J); // helper

unsigned clang_UninitVariablesResult_getBranchOutput(CXUninitVariablesResult R, unsigned I,
                                                     unsigned J); // helper

// The variables clang reported through handleSelfInit — the `int x = x` idiom. These are
// a separate list: the callback carries no UninitUse. 0 <= I < getNumSelfInits. // helper
unsigned clang_UninitVariablesResult_getNumSelfInits(CXUninitVariablesResult R);

CXVarDecl clang_UninitVariablesResult_getSelfInit(CXUninitVariablesResult R,
                                                  unsigned I); // helper

LLVM_CLANG_C_EXTERN_C_END

#endif
