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

using LLVM
using LLVM.Interop: call_function
export call_function
import LLVM: dispose, name, value

import Base: dump, string

const llvm_version = string(Base.libllvm_version.major)

const libdir = joinpath(@__DIR__, "..", "lib")

include(joinpath(libdir, "LibClang.jl"))

include(joinpath(libdir, llvm_version, "LibClangEx.jl"))
using .LibClangEx

include("platform/JLLEnvs.jl")
using .JLLEnvs

include("env.jl")
export get_compiler_flags, get_default_args

# low-level
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
include("clang/sema.jl")

# high-level
include("types.jl")
export jlty_to_clty, clty_to_jlty, jlty_to_llvmty

include("parse.jl")
include("lookup.jl")
export DeclFinder, get_decl

include("template.jl")
export specialize

# compiler
include("compiler/compiler.jl")
export AbstractClangCompiler
export AbstractIRGenerator, IRGenerator
export take_module
export ClangCompiler
export get_instance, get_context
export compile, dispose
export get_jit, get_dylib, get_codegen
export link_process_symbols

include("utils.jl")
export jlty2llvmty
export lookup_function, link, link_crt
export get_buffer

end
