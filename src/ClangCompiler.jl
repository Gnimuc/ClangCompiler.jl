module ClangCompiler

using Clang_jll
using libclangex_jll

using Preferences

if has_preference(ClangCompiler, "libclangex")
    const libclangex = load_preference(ClangCompiler, "libclangex")
else
    if isdefined(libclangex_jll, :libclangex)
        import libclangex_jll: libclangex
    end
end

include("jllshim.jl")
using .JLLShim

using LLVM: LLVM
using LLVM.Interop: call_function

const llvm_version = string(Base.libllvm_version.major)

const libdir = joinpath(@__DIR__, "..", "lib")

include(joinpath(libdir, "LibClang.jl"))

include(joinpath(libdir, llvm_version, "LibClangEx.jl"))
using .LibClangEx

include("platform/JLLEnvs.jl")
using .JLLEnvs

include("env.jl")
public get_compiler_flags, get_default_args

# clang
include("clang/utils.jl")
include("clang/core/core.jl")
include("clang/api/api.jl")
include("clang/ast.jl")
include("clang/basic.jl")
include("clang/codegen.jl")
include("clang/frontend.jl")
include("clang/lex.jl")
include("clang/parse.jl")
include("clang/qualtype.jl")
include("clang/type.jl")
include("clang/sema.jl")

# public
include("compiler/compiler.jl")
public AbstractClangCompiler

include("compiler/interpreter.jl")
public CxxInterpreter, create_interpreter, dispose
public get_instance, get_ast_context, get_codegen_module, get_parser, get_sema

# include("compiler/irgen.jl")

include("types.jl")
public clty_to_jlty, jlty_to_clty

include("parse.jl")
public parse_cxx_scope_spec

include("lookup.jl")
public AbstractFinder, DeclFinder, reset, get_decl

include("utils.jl")

# include("template.jl")

end
