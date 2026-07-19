"""
    struct CxxInterpreter <: AbstractClangCompiler
"""
struct CxxInterpreter <: AbstractClangCompiler
    interp::Interpreter
end

CxxInterpreter(x::CXInterpreter) = CxxInterpreter(Interpreter(x))

"""
    create_interpreter(args=String[]; is_cxx=true, version=JLLEnvs.GCC_MIN_VER) -> Interpreter
Create a C/C++ interpreter.

# Arguments
- `args::Vector{String}`: Additional compiler flags.
- `is_cxx::Bool`: Whether to use the C++ compiler build environment.
- `version::String`: The compiler version.
"""
function create_interpreter(args=String[]; is_cxx=true, version=JLLEnvs.GCC_MIN_VER)
    LLVM.InitializeNativeTarget()
    LLVM.InitializeAllTargetInfos()
    LLVM.InitializeAllTargetMCs()
    LLVM.InitializeNativeAsmPrinter()
    default_args = get_default_args(; is_cxx, version)
    builder = IncrementalCompilerBuilder()
    SetCompilerArgs(builder, [default_args..., args...])
    ci = CreateCpp(builder)
    @check_ptrs ci
    I = Interpreter(ci)
    dispose(builder)
    return CxxInterpreter(I)
end

dispose(x::CxxInterpreter) = dispose(x.interp)

get_instance(x::CxxInterpreter) = getCompilerInstance(x.interp)
get_ast_context(x::CxxInterpreter) = getASTContext(get_instance(x))
get_codegen_module(x::CxxInterpreter) = CGM(getCodeGen(x.interp))
get_parser(x::CxxInterpreter) = getParser(x.interp)
get_sema(x::CxxInterpreter) = getSema(get_parser(x))
get_execution_engine(x::CxxInterpreter) = getExecutionEngine(x.interp)
get_symbol_address(x::CxxInterpreter, name::AbstractString) = getSymbolAddress(x.interp, name)
get_symbol_address_from_linker_name(x::CxxInterpreter, name::AbstractString) = getSymbolAddressFromLinkerName(x.interp, name)
get_function_pointer(x::CxxInterpreter, name::AbstractString) = Ptr{Cvoid}(get_symbol_address(x, name))

parse(x::CxxInterpreter, code::String) = Parse(x.interp, code)
execute(x::CxxInterpreter, tu::PartialTranslationUnit) = Execute(x.interp, tu)
compile(x::CxxInterpreter, code::String) = execute(x, parse(x, code))

parse_cxx_scope_spec(x::CxxInterpreter, ss::CXXScopeSpec, code::String) = parse_cxx_scope_spec(x.interp, ss, code)
