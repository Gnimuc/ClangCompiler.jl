"""
    mutable struct DiagnosticIDs <: Any
Holds a pointer to a `clang::DiagnosticIDs` object.
"""
mutable struct DiagnosticIDs
    ptr::CXDiagnosticIDs
end
DiagnosticIDs() = DiagnosticIDs(create_diagnostic_ids())

"""
    create_diagnostic_ids() -> CXDiagnosticIDs
Return a pointer to a `clang::DiagnosticIDs` object.
"""
function create_diagnostic_ids()
    status = Ref{CXInit_Error}(CXInit_NoError)
    ids = clang_DiagnosticIDs_create(status)
    @assert status[] == CXInit_NoError
    return ids
end

"""
    mutable struct DiagnosticOptions <: Any
Holds a pointer to a `clang::DiagnosticIDs` object.
"""
mutable struct DiagnosticOptions
    ptr::CXDiagnosticOptions
end
DiagnosticOptions() = DiagnosticOptions(create_diagnostic_opts())

"""
    create_diagnostic_opts() -> CXDiagnosticOptions
Return a pointer to a `clang::DiagnosticOptions` object.
"""
function create_diagnostic_opts()
    status = Ref{CXInit_Error}(CXInit_NoError)
    opts = clang_DiagnosticOptions_create(status)
    @assert status[] == CXInit_NoError
    return opts
end

function status(x::DiagnosticOptions)
    @assert x.ptr != C_NULL "diagnostic options has a NULL pointer."
    return clang_DiagnosticOptions_PrintStats(x.ptr)
end

"""
    AbstractDiagnosticConsumer <: Any
Supretype for DiagnosticConsumers.
"""
abstract type AbstractDiagnosticConsumer end

"""
    mutable struct DiagnosticConsumer <: AbstractDiagnosticConsumer
Holds a pointer to a `clang::DiagnosticConsumer` object.
"""
mutable struct DiagnosticConsumer <: AbstractDiagnosticConsumer
    ptr::CXDiagnosticConsumer
end
DiagnosticConsumer() = DiagnosticConsumer(create_diagnostic_consumer())

"""
    create_diagnostic_consumer() -> CXDiagnosticConsumer
Return a pointer to a `clang::DiagnosticConsumer` object.
"""
function create_diagnostic_consumer()
    status = Ref{CXInit_Error}(CXInit_NoError)
    consumer = clang_DiagnosticConsumer_create(status)
    @assert status[] == CXInit_NoError
    return consumer
end

function destroy(x::DiagnosticConsumer)
    if x.ptr != C_NULL
        clang_DiagnosticConsumer_dispose(x.ptr)
        x.ptr = C_NULL
    end
    return x
end

"""
    mutable struct IgnoringDiagConsumer <: AbstractDiagnosticConsumer
Holds a pointer to a `clang::IgnoringDiagConsumer` object.
"""
mutable struct IgnoringDiagConsumer <: AbstractDiagnosticConsumer
    ptr::CXIgnoringDiagConsumer
end
IgnoringDiagConsumer() = IgnoringDiagConsumer(create_ignoring_diagnostic_consumer())

"""
    create_ignoring_diagnostic_consumer() -> CXIgnoringDiagConsumer
Return a pointer to a `clang::IgnoringDiagConsumer` object.
"""
function create_ignoring_diagnostic_consumer()
    status = Ref{CXInit_Error}(CXInit_NoError)
    consumer = clang_IgnoringDiagConsumer_create(status)
    @assert status[] == CXInit_NoError
    return consumer
end

function destroy(x::IgnoringDiagConsumer)
    if x.ptr != C_NULL
        clang_IgnoringDiagConsumer_dispose(x.ptr)
        x.ptr = C_NULL
    end
    return x
end

"""
    mutable struct DiagnosticsEngine <: Any
Holds a pointer to a `clang::DiagnosticsEngine` object.
"""
mutable struct DiagnosticsEngine
    ptr::CXDiagnosticsEngine
end
DiagnosticsEngine() = DiagnosticsEngine(create_diagnostics_engine())

function DiagnosticsEngine(opts::DiagnosticOptions,
                           client::AbstractDiagnosticConsumer=DiagnosticConsumer(),
                           should_own_client=true)
    status = Ref{CXInit_Error}(CXInit_NoError)
    ids = create_diagnostic_ids()
    engine = clang_DiagnosticsEngine_create(ids, opts.ptr, client.ptr, should_own_client,
                                            status)
    @assert status[] == CXInit_NoError
    return DiagnosticsEngine(engine)
end

function DiagnosticsEngine(ids::DiagnosticIDs, opts::DiagnosticOptions,
                           client::AbstractDiagnosticConsumer=DiagnosticConsumer(),
                           should_own_client=true)
    status = Ref{CXInit_Error}(CXInit_NoError)
    engine = clang_DiagnosticsEngine_create(ids.ptr, opts.ptr, client.ptr,
                                            should_own_client, status)
    @assert status[] == CXInit_NoError
    return DiagnosticsEngine(engine)
end

"""
    create_diagnostics_engine() -> CXDiagnosticsEngine
Return a pointer to a `clang::DiagnosticsEngine` object.
"""
function create_diagnostics_engine()
    status = Ref{CXInit_Error}(CXInit_NoError)
    ids = create_diagnostic_ids()
    opts = create_diagnostic_opts()
    client = create_diagnostic_consumer()
    should_own_client = true
    engine = clang_DiagnosticsEngine_create(ids, opts, client, should_own_client, status)
    @assert status[] == CXInit_NoError
    return engine
end

function destroy(x::DiagnosticsEngine)
    if x.ptr != C_NULL
        clang_DiagnosticsEngine_dispose(x.ptr)
        x.ptr = C_NULL
    end
    return x
end
