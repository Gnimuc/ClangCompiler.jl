"""
    struct TextDiagnosticBuffer <: AbstractTextDiagnosticBuffer
Hold a pointer to a `clang::TextDiagnosticBuffer` object.
"""
struct TextDiagnosticBuffer <: AbstractTextDiagnosticBuffer
    ptr::CXDiagnosticConsumer
end
