"""
    mutable struct IncrementalIRGenerator <: AbstractIRGenerator
Incremental LLVM IR Generator.
"""
mutable struct IncrementalIRGenerator <: AbstractIRGenerator
    ts_ctx::ThreadSafeContext
    instance::CompilerInstance
    parser::Parser
    modules::Vector{LLVM.Module}
    current_module::Int
    src_counter::Int
end

get_parser(x::IncrementalIRGenerator) = x.parser
get_modules(x::IncrementalIRGenerator) = x.modules
get_current_module(x::IncrementalIRGenerator) = x.modules[x.current_module]
get_codegen_module(x::IncrementalIRGenerator) = CGM(CodeGenerator(getASTConsumer(get_instance(x)).ptr))

function IncrementalIRGenerator(src::String, args::Vector{String}; diag_show_colors=true)
    ts_ctx = ThreadSafeContext()
    ctx = context(ts_ctx)
    instance = CompilerInstance()
    # diagnostics
    setShowPresumedLoc(instance, true)
    setShowColors(instance, diag_show_colors)
    createDiagnostics(instance)
    diag = getDiagnostics(instance)
    # invocation
    invok = create_compiler_invocation_from_cmd(src, args, diag)
    setInvocation(instance, invok)
    setTargetAndLangOpts(instance)
    # source
    createFileManager(instance)
    createSourceManager(instance)
    setMainFileID(instance, src)
    # preprocessor & AST & sema
    createPreprocessor(instance, CXTranslationUnitKind_TU_Prefix)
    createASTContext(instance)
    codegen = CreateLLVMCodeGen(instance, ctx, "JLCC_Incremental_1")
    setASTConsumer(instance, codegen)
    createSema(instance, CXTranslationUnitKind_TU_Prefix)
    # parser
    preprocessor = getPreprocessor(instance)
    enable_incremental(preprocessor)
    sema = getSema(instance)
    parser = Parser(preprocessor, sema)
    begin_diag(instance)
    try
        InitializeBuiltins(preprocessor)
        EnterMainSourceFile(preprocessor)
        Initialize(parser)

        ast_ctx = getASTContext(instance)

        if tryParseAndSkipInvalidOrParsedDecl(parser, codegen)
            processWeakTopLevelDecls(sema, codegen)
            HandleTranslationUnit(codegen, ast_ctx)
        end
    finally
        end_diag(instance)
    end

    # generate llvm modules
    m_cur = release_llvm_module(codegen)
    m_cur.ref == C_NULL && error("failed to generate IR.")

    m_next = start_llvm_module(codegen, context(m_cur), "JLCC_Incremental_2")

    return IncrementalIRGenerator(ts_ctx, instance, parser, [m_cur, m_next], 2, 1)
end

function incremental_parse(irgen::IncrementalIRGenerator, code::String)
    ci = get_instance(irgen)
    parser = get_parser(irgen)
    pp = getPreprocessor(ci)
    src_mgr = getSourceManager(ci)
    codegen = getASTConsumer(ci)
    buffer = get_buffer(code)
    fid = FileID(src_mgr, buffer)
    begin_diag(ci)
    loc = get_loc_with_offset(get_main_file_begin_loc(src_mgr), irgen.src_counter)
    EnterSourceFile(pp, fid, loc)
    try
        if tryParseAndSkipInvalidOrParsedDecl(parser, codegen)
            processWeakTopLevelDecls(getSema(ci), codegen)
            HandleTranslationUnit(codegen, getASTContext(ci))
        end
    finally
        dispose(fid)
        EndSourceFile(pp)
        end_diag(ci)
        irgen.src_counter += 1
    end
    # generate llvm modules
    m_cur = release_llvm_module(codegen)
    m_cur.ref == C_NULL && error("failed to generate IR.")
    irgen.current_module += 1
    m_next = start_llvm_module(codegen, context(m_cur), "JLCC_Incremental_$(irgen.current_module)")
    push!(irgen.modules, m_next)

    return m_cur
end

function dispose(x::IncrementalIRGenerator)
    dispose(x.parser)
    dispose(x.instance)
    pop!(x.modules)  # we don't have the ownership of the latest module
    dispose.(x.modules)
    dispose(x.ts_ctx)
end

function parse_cxx_scope_spec(irgen::IncrementalIRGenerator, str::String, spec::CXXScopeSpec)
    ci = get_instance(irgen)
    parser = get_parser(irgen)
    parse_cxx_scope_spec(ci, parser, str, spec)
end

function (x::DeclFinder)(irgen::IncrementalIRGenerator, decl::String, scope::String="")
    ci = get_instance(irgen)
    parser = get_parser(irgen)
    return x(ci, parser, decl, scope)
end
