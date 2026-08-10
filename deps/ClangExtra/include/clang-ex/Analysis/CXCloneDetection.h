#ifndef LLVM_CLANG_C_EXTRA_CXCLONEDETECTION_H
#define LLVM_CLANG_C_EXTRA_CXCLONEDETECTION_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// CloneDetector
// Duplicate-code search over parsed function bodies: feed it Decls with
// clang_CloneDetector_analyzeCodeBody, then run clang_CloneDetector_findClones and read
// the resulting clone groups back.
//
// clang::CloneDetector::findClones is a variadic template over constraint objects
// (MARSHALLING.md §10 keeps that off the C boundary), and it writes into a
// std::vector<CloneGroup> the caller has to own. Both are settled here: the handle stands
// for the detector together with the result vector of its last findClones, and exactly one
// constraint pipeline is offered — clang's standard type-II chain
//   RecursiveCloneTypeIIHashConstraint -> MinComplexityConstraint(MinComplexity)
//   -> MinGroupSizeConstraint(MinGroupSize) -> RecursiveCloneTypeIIVerifyConstraint
//   -> OnlyLargestCloneConstraint
// with the two numeric knobs exposed as parameters.

// The detector is CALLER-OWNED — pair with clang_CloneDetector_dispose. It stores
// clang::StmtSequences pointing into the ASTs it analysed, so it must not outlive them.
CXCloneDetector clang_CloneDetector_create(void);

void clang_CloneDetector_dispose(CXCloneDetector CD);

// clang::CloneDetector::analyzeCodeBody — collect search data for every statement in D's
// body. D must have a body. Call once per Decl; the detector accumulates, and clones are
// only ever found between statements that have both been analysed.
void clang_CloneDetector_analyzeCodeBody(CXCloneDetector CD, CXDecl D);

// constrainClones (a variadic template over constraint objects — MARSHALLING.md §10)

// clang::CloneDetector::findClones with the fixed type-II pipeline described above.
// MinComplexity is the smallest statement complexity (total child count) a clone may have
// — clang's own CloneChecker default is 50 — and MinGroupSize is the smallest number of
// clones a group may hold (clang::MinGroupSizeConstraint defaults it to 2). Replaces the
// results of any previous call.
void clang_CloneDetector_findClones(CXCloneDetector CD, unsigned MinComplexity,
                                    unsigned MinGroupSize); // helper

// The clone groups of the last clang_CloneDetector_findClones; zero before the first call.
// // helper
unsigned clang_CloneDetector_getNumCloneGroups(CXCloneDetector CD);

// The number of clones in group G, 0 <= G < clang_CloneDetector_getNumCloneGroups.
// // helper
unsigned clang_CloneDetector_getCloneGroupSize(CXCloneDetector CD, unsigned G);

// StmtSequence
// clang::StmtSequence is a value type — a Stmt, its containing Decl and a [start, end)
// window into that Stmt's children — and the detector owns every instance it produced, so
// the class is decomposed into the indexed accessors below rather than boxed
// (MARSHALLING.md §7). Each one names the I-th clone of group G, with
// 0 <= G < getNumCloneGroups and 0 <= I < getCloneGroupSize(G).

// clang::StmtSequence::getContainingDecl — the Decl whose body the statements live in.
// Never NULL for a sequence the detector produced. // helper
CXDecl clang_CloneDetector_getCloneContainingDecl(CXCloneDetector CD, unsigned G,
                                                  unsigned I);

// clang::StmtSequence::size — the number of top-level statements the clone spans. // helper
unsigned clang_CloneDetector_getCloneNumStmts(CXCloneDetector CD, unsigned G, unsigned I);

// clang::StmtSequence::holdsSequence — true when the clone is a run of children of a
// CompoundStmt rather than one standalone statement. // helper
bool clang_CloneDetector_cloneHoldsSequence(CXCloneDetector CD, unsigned G, unsigned I);

// The J-th top-level statement of the clone, 0 <= J < clang_CloneDetector_getCloneNumStmts.
// // helper
CXStmt clang_CloneDetector_getCloneStmt(CXCloneDetector CD, unsigned G, unsigned I,
                                        unsigned J);

// clang::StmtSequence::getSourceRange — from the start of the first statement to the end
// of the last. Both locations are invalid for an empty sequence, which clang's own
// getBeginLoc/getEndLoc would assert on and which the shim returns instead. // helper
CXSourceRange_ clang_CloneDetector_getCloneSourceRange(CXCloneDetector CD, unsigned G,
                                                       unsigned I);

// clang::StmtSequence::contains — whether the source range of one clone contains the
// other's. Both must be non-empty sequences; the shim returns false when either is empty,
// which is the case clang's own accessor asserts against. // helper
bool clang_CloneDetector_cloneContains(CXCloneDetector CD, unsigned G, unsigned I,
                                       unsigned OtherG, unsigned OtherI);

LLVM_CLANG_C_EXTERN_C_END

#endif
