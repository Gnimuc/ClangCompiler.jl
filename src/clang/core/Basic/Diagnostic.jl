"""
    struct DiagnosticConsumer <: AbstractDiagnosticConsumer
"""
struct DiagnosticConsumer <: AbstractDiagnosticConsumer
    ptr::CXDiagnosticConsumer
end

Base.unsafe_convert(::Type{CXDiagnosticConsumer}, x::DiagnosticConsumer) = x.ptr
Base.cconvert(::Type{CXDiagnosticConsumer}, x::DiagnosticConsumer) = x

"""
    struct IgnoringDiagConsumer <: AbstractIgnoringDiagConsumer
Hold a pointer to a `clang::IgnoringDiagConsumer` object.
"""
struct IgnoringDiagConsumer <: AbstractIgnoringDiagConsumer
    ptr::CXDiagnosticConsumer
end

Base.unsafe_convert(::Type{CXDiagnosticConsumer}, x::IgnoringDiagConsumer) = x.ptr
Base.cconvert(::Type{CXDiagnosticConsumer}, x::IgnoringDiagConsumer) = x

"""
    struct DiagnosticsEngine <: AbstractDiagnosticsEngine
Hold a pointer to a `clang::DiagnosticsEngine` object.
"""
struct DiagnosticsEngine <: AbstractDiagnosticsEngine
    ptr::CXDiagnosticsEngine
end

Base.unsafe_convert(::Type{CXDiagnosticsEngine}, x::DiagnosticsEngine) = x.ptr
Base.cconvert(::Type{CXDiagnosticsEngine}, x::DiagnosticsEngine) = x
