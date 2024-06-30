# DiagnosticConsumer
function BeginSourceFile(consumer::AbstractDiagnosticConsumer, lang::LangOptions,
                         pp::Preprocessor)
    @check_ptrs consumer lang pp
    clang_DiagnosticConsumer_BeginSourceFile(consumer, lang, pp)
    return nothing
end

function EndSourceFile(consumer::AbstractDiagnosticConsumer)
    @check_ptrs consumer
    clang_DiagnosticConsumer_EndSourceFile(consumer)
    return nothing
end

dispose(x::AbstractDiagnosticConsumer) = clang_DiagnosticConsumer_dispose(x)

# IgnoringDiagConsumer
IgnoringDiagConsumer() = IgnoringDiagConsumer(create_ignoring_diagnostic_consumer())

"""
    create_ignoring_diagnostic_consumer() -> CXDiagnosticConsumer
Return a pointer to a `clang::IgnoringDiagConsumer` object.
"""
function create_ignoring_diagnostic_consumer()
    consumer = clang_IgnoringDiagConsumer_create()
    @assert consumer != C_NULL "Failed to create IgnoringDiagConsumer"
    return consumer
end

# DiagnosticsEngine
DiagnosticsEngine() = DiagnosticsEngine(create_diagnostics_engine())

function DiagnosticsEngine(opts::DiagnosticOptions,
                           client::AbstractDiagnosticConsumer=TextDiagnosticPrinter(opts),
                           should_own_client=true)
    ids = create_diagnostic_ids()
    engine = clang_DiagnosticsEngine_create(ids, opts, client, should_own_client)
    @assert engine != C_NULL "Failed to create DiagnosticsEngine"
    return DiagnosticsEngine(engine)
end

function DiagnosticsEngine(ids::DiagnosticIDs, opts::DiagnosticOptions,
                           client::AbstractDiagnosticConsumer=TextDiagnosticPrinter(opts),
                           should_own_client=true)
    engine = clang_DiagnosticsEngine_create(ids, opts, client, should_own_client)
    @assert engine != C_NULL "Failed to create DiagnosticsEngine"
    return DiagnosticsEngine(engine)
end

"""
    create_diagnostics_engine() -> CXDiagnosticsEngine
Return a pointer to a `clang::DiagnosticsEngine` object.
"""
function create_diagnostics_engine()
    ids = create_diagnostic_ids()
    opts = DiagnosticOptions()
    client = TextDiagnosticPrinter(opts)
    should_own_client = true
    engine = clang_DiagnosticsEngine_create(ids, opts, client, should_own_client)
    @assert engine != C_NULL "Failed to create DiagnosticsEngine"
    return engine
end

dispose(x::DiagnosticsEngine) = clang_DiagnosticsEngine_dispose(x)

function setShowColors(x::DiagnosticsEngine, should_show::Bool)
    @check_ptrs x
    return clang_DiagnosticsEngine_setShowColors(x, should_show)
end
