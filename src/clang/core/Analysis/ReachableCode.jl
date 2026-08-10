abstract type AbstractUnreachableCodeResult end

"""
    struct UnreachableCodeResult <: AbstractUnreachableCodeResult
Hold a pointer to the buffer one `clang::reachable_code::FindUnreachableCode` run recorded.

There is no `clang::UnreachableCodeResult`: clang reports each dead region through the pure
virtual `reachable_code::Callback::HandleUnreachable`, so the shim runs the analysis behind
one fixed callback subclass and keeps the reports. The pointee is caller-owned — call
`dispose` after use.
"""
struct UnreachableCodeResult <: AbstractUnreachableCodeResult
    ptr::CXUnreachableCodeResult
end
