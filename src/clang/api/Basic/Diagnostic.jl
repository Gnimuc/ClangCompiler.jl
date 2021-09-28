# DiagnosticConsumer
function BeginSourceFile(consumer::AbstractDiagnosticConsumer, lang::LangOptions,
                           pp::CXPreprocessor)
    @check_ptrs consumer lang
    @assert pp != C_NULL
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
    status = Ref{CXInit_Error}(CXInit_NoError)
    consumer = clang_IgnoringDiagConsumer_create(status)
    @assert status[] == CXInit_NoError
    return consumer
end

# DiagnosticsEngine
DiagnosticsEngine() = DiagnosticsEngine(create_diagnostics_engine())

function DiagnosticsEngine(opts::DiagnosticOptions,
                           client::AbstractDiagnosticConsumer=TextDiagnosticPrinter(opts),
                           should_own_client=true)
    status = Ref{CXInit_Error}(CXInit_NoError)
    ids = create_diagnostic_ids()
    engine = clang_DiagnosticsEngine_create(ids, opts, client, should_own_client,
                                            status)
    @assert status[] == CXInit_NoError
    return DiagnosticsEngine(engine)
end

function DiagnosticsEngine(ids::DiagnosticIDs, opts::DiagnosticOptions,
                           client::AbstractDiagnosticConsumer=TextDiagnosticPrinter(opts),
                           should_own_client=true)
    status = Ref{CXInit_Error}(CXInit_NoError)
    engine = clang_DiagnosticsEngine_create(ids, opts, client,
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
    engine = clang_DiagnosticsEngine_create(ids, opts, client, should_own_client,
                                            status)
    @assert status[] == CXInit_NoError
    return engine
end

dispose(x::DiagnosticsEngine) = clang_DiagnosticsEngine_dispose(x)

function setShowColors(x::DiagnosticsEngine, should_show::Bool)
    @check_ptrs x
    return clang_DiagnosticsEngine_setShowColors(x, should_show)
end
