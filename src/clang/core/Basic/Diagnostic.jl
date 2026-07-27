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


"""
    struct DiagnosticErrorTrap <: AbstractDiagnosticErrorTrap
Hold a pointer to a `clang::DiagnosticErrorTrap` object.
"""
struct DiagnosticErrorTrap <: AbstractDiagnosticErrorTrap
    ptr::CXDiagnosticErrorTrap
end

Base.unsafe_convert(::Type{CXDiagnosticErrorTrap}, x::DiagnosticErrorTrap) = x.ptr
Base.cconvert(::Type{CXDiagnosticErrorTrap}, x::DiagnosticErrorTrap) = x

"""
    struct StoredDiagnostic <: AbstractStoredDiagnostic
Hold a pointer to a `clang::StoredDiagnostic` object.
"""
struct StoredDiagnostic <: AbstractStoredDiagnostic
    ptr::CXStoredDiagnostic
end

Base.unsafe_convert(::Type{CXStoredDiagnostic}, x::StoredDiagnostic) = x.ptr
Base.cconvert(::Type{CXStoredDiagnostic}, x::StoredDiagnostic) = x
