"""
    struct DiagnosticConsumer <: AbstractDiagnosticConsumer
"""
struct DiagnosticConsumer <: AbstractDiagnosticConsumer
    ptr::CXDiagnosticConsumer
end

"""
    struct IgnoringDiagConsumer <: AbstractIgnoringDiagConsumer
Hold a pointer to a `clang::IgnoringDiagConsumer` object.
"""
struct IgnoringDiagConsumer <: AbstractIgnoringDiagConsumer
    ptr::CXDiagnosticConsumer
end

"""
    struct DiagnosticsEngine <: AbstractDiagnosticsEngine
Hold a pointer to a `clang::DiagnosticsEngine` object.
"""
struct DiagnosticsEngine <: AbstractDiagnosticsEngine
    ptr::CXDiagnosticsEngine
end

"""
    struct DiagnosticErrorTrap <: AbstractDiagnosticErrorTrap
Hold a pointer to a `clang::DiagnosticErrorTrap` object.
"""
struct DiagnosticErrorTrap <: AbstractDiagnosticErrorTrap
    ptr::CXDiagnosticErrorTrap
end

"""
    struct StoredDiagnostic <: AbstractStoredDiagnostic
Hold a pointer to a `clang::StoredDiagnostic` object.
"""
struct StoredDiagnostic <: AbstractStoredDiagnostic
    ptr::CXStoredDiagnostic
end

"""
    struct ForwardingDiagnosticConsumer <: AbstractForwardingDiagnosticConsumer
Hold a pointer to a `clang::ForwardingDiagnosticConsumer` object.
"""
struct ForwardingDiagnosticConsumer <: AbstractForwardingDiagnosticConsumer
    ptr::CXDiagnosticConsumer
end

"""
    struct FixItHint <: AbstractFixItHint
Hold a pointer to a `clang::FixItHint` object.
"""
struct FixItHint <: AbstractFixItHint
    ptr::CXFixItHint
end

"""
    struct DiagnosticBuilder <: AbstractDiagnosticBuilder
Hold a pointer to a `clang::DiagnosticBuilder` object.
"""
struct DiagnosticBuilder <: AbstractDiagnosticBuilder
    ptr::CXDiagnosticBuilder
end

"""
    struct Diagnostic <: AbstractDiagnostic
Hold a pointer to a `clang::Diagnostic` object.
"""
struct Diagnostic <: AbstractDiagnostic
    ptr::CXDiagnostic_
end

