"""
    AbstractDiagnosticConsumer <: Any
Supretype for DiagnosticConsumers.
"""
abstract type AbstractDiagnosticConsumer end

function begin_source_file(consumer::T, lang::LangOptions,
                           pp::CXPreprocessor) where {T<:AbstractDiagnosticConsumer}
    @assert consumer.ptr != C_NULL "$T has a NULL pointer."
    @assert lang.ptr != C_NULL "LangOptions has a NULL pointer."
    @assert pp != C_NULL
    clang_DiagnosticConsumer_BeginSourceFile(consumer.ptr, lang.ptr, pp)
    return nothing
end

function end_source_file(consumer::T) where {T<:AbstractDiagnosticConsumer}
    @assert consumer.ptr != C_NULL "$T has a NULL pointer."
    clang_DiagnosticConsumer_EndSourceFile(consumer.ptr)
    return nothing
end

dispose(x::AbstractDiagnosticConsumer) = clang_DiagnosticConsumer_dispose(x.ptr)

"""
    struct DiagnosticConsumer <: AbstractDiagnosticConsumer
"""
struct DiagnosticConsumer <: AbstractDiagnosticConsumer
    ptr::CXDiagnosticConsumer
end

"""
    struct IgnoringDiagConsumer <: AbstractDiagnosticConsumer
Hold a pointer to a `clang::IgnoringDiagConsumer` object.
"""
struct IgnoringDiagConsumer <: AbstractDiagnosticConsumer
    ptr::CXDiagnosticConsumer
end
IgnoringDiagConsumer() = IgnoringDiagConsumer(create_ignoring_diagnostic_consumer())

"""
    create_ignoring_diagnostic_consumer() -> CXDiagnosticConsumer
Return a pointer to a `clang::IgnoringDiagConsumer` object.
"""
function create_ignoring_diagnostic_consumer()
    status = Ref{CXInit_Error}(CXInit_NoError)
    consumer = clang_IgnoringDiagConsumer_create(status)
    @assert status[] == CXInit_NoError
    return consumer
end

"""
    struct DiagnosticsEngine <: Any
Hold a pointer to a `clang::DiagnosticsEngine` object.
"""
struct DiagnosticsEngine
    ptr::CXDiagnosticsEngine
end
DiagnosticsEngine() = DiagnosticsEngine(create_diagnostics_engine())

function DiagnosticsEngine(opts::DiagnosticOptions,
                           client::AbstractDiagnosticConsumer=TextDiagnosticPrinter(opts),
                           should_own_client=true)
    status = Ref{CXInit_Error}(CXInit_NoError)
    ids = create_diagnostic_ids()
    engine = clang_DiagnosticsEngine_create(ids, opts.ptr, client.ptr, should_own_client,
                                            status)
    @assert status[] == CXInit_NoError
    return DiagnosticsEngine(engine)
end

function DiagnosticsEngine(ids::DiagnosticIDs, opts::DiagnosticOptions,
                           client::AbstractDiagnosticConsumer=TextDiagnosticPrinter(opts),
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
    opts = DiagnosticOptions()
    client = TextDiagnosticPrinter(opts)
    should_own_client = true
    engine = clang_DiagnosticsEngine_create(ids, opts.ptr, client.ptr, should_own_client,
                                            status)
    @assert status[] == CXInit_NoError
    return engine
end

dispose(x::DiagnosticsEngine) = clang_DiagnosticsEngine_dispose(x.ptr)

function set_show_colors(x::DiagnosticsEngine, should_show::Bool)
    @assert x.ptr != C_NULL "DiagnosticsEngine has a NULL pointer."
    return clang_DiagnosticsEngine_setShowColors(x.ptr, should_show)
end
