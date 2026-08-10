# Local abstract type: `clang::CloneDetector` is a standalone class in
# clang/Analysis/CloneDetection.h with no base, so it is not part of core/abstract.jl.
abstract type AbstractCloneDetector end

"""
    struct CloneDetector <: AbstractCloneDetector
Hold a pointer to a `clang::CloneDetector` object together with the clone groups its last
`findClones` produced.

`clang::CloneDetector::findClones` writes into a `std::vector` the caller has to own and
keeps no copy of it, so the handle stands for the detector and that vector at once —
otherwise the results would die before the first accessor ran.

The pointee is caller-owned (`CloneDetector()` heap-allocates it) — call `dispose` after
use. It stores statement sequences pointing into the ASTs it analysed, so it must not
outlive them.
"""
struct CloneDetector <: AbstractCloneDetector
    ptr::CXCloneDetector
end

"""
    struct CloneSequence <: Any
One clone of one clone group: a `clang::StmtSequence` copied out of the detector.

`clang::StmtSequence` is a value type — a statement, its containing declaration and a
window into that statement's children — and every instance belongs to the `CloneDetector`
that produced it, so it is reproduced structurally in Julia (as `SourceRange` is) instead
of crossing the C boundary as a handle.

  - `decl` is the declaration whose body the statements live in.
  - `stmts` are the top-level statements the clone spans, in source order.
  - `holds_sequence` is true when those statements are a run of children of a
    `CompoundStmt` rather than one standalone statement.
  - `range` runs from the start of the first statement to the end of the last.
"""
struct CloneSequence
    decl::Decl
    stmts::Vector{Stmt}
    holds_sequence::Bool
    range::SourceRange
end
