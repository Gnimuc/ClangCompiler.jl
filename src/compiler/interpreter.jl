"""
    struct CxxInterpreter <: AbstractClangCompiler
"""
struct CxxInterpreter <: AbstractClangCompiler
    interp::Interpreter
end

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
    SetCompilerArgs(builder, [default_args..., args..., "-include", "new"])
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
