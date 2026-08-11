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

# The Attr/Stmt/Decl/Type hierarchies are emitted as explicit source (carriers,
# wrappers, and resolve maps) from the vendored *.inc files by gen/*_nodes.jl
# into src/, beside the hand-written files of each subsystem — there is no
# runtime node-table mirror.

include("platform/JLLEnvs.jl")
using .JLLEnvs

include("env.jl")
public get_compiler_flags, get_default_args

# clang
# refuse a conversion between two different CX handles, once, for the whole layer
include("clang/handles.jl")
include("clang/utils.jl")
include("clang/core/core.jl")
# how a carrier crosses the hierarchy: implicit widening, checked narrowing, and the one
# unchecked reinterpretation the resolve machinery is built from
include("clang/casts.jl")
public CastError
include("clang/api/api.jl")
# what a DeclContext parameter accepts: a context, or a decl that is also one
public AnyDeclContext, AbstractDeclContextDecl
include("clang/ast.jl")
include("clang/identity.jl")
# node identity: `==`/`hash` on carriers, and the raw base pointer behind them
public decl_id, stmt_id, type_id, attr_id
public get_record_layout, field_offsets, is_derived_from
public shim_type_width
include("clang/basic.jl")
include("clang/codegen.jl")
include("clang/frontend.jl")
include("clang/lex.jl")
include("clang/parse.jl")
include("clang/qualtype.jl")
include("clang/type.jl")
include("clang/sema.jl")
include("clang/stmt.jl")
include("clang/typeloc.jl")
public getStmtClass, getChildren, children, subtree, resolve, dump_ast
include("clang/decl.jl")
public getKind, decls
public ChainIterator, DeclIterator, decls_in, redecls, qualifiers, parents, lexical_parents
public enclosing, module_ancestors, macro_history
include("clang/attr.jl")
public getAttrs, get_attr_kind, get_attr_spelling

# public
include("compiler/types.jl")
public AbstractClangCompiler, AbstractCxxInterpreter, AbstractIncrementalParser
public AbstractIRGenerator, AbstractCxxCompiler

include("compiler/utils.jl")

include("compiler/interpreter.jl")
public CxxInterpreter, create_interpreter, dispose
public get_instance, get_ast_context, get_codegen_module, get_parser, get_sema
# the verbs every driver that runs code shares
public compile, get_symbol_address, get_function_pointer

# The incremental driver clang's own Interpreter cannot provide outside C++.
include("compiler/parser.jl")
public IncrementalParser, create_parser

# The batch driver: one translation unit in, one LLVM module out.
include("compiler/irgen.jl")
public IRGenerator, create_irgenerator
public take_module, has_module, get_context

# ... and that module on a JIT.
include("compiler/compiler.jl")
public CxxCompiler, create_compiler, link_process_symbols
public get_jit, get_dylib, get_irgenerator

include("types.jl")
public clty_to_jlty, jlty_to_clty

include("parse.jl")
public parse_cxx_scope_spec

include("lookup.jl")
public AbstractFinder, DeclFinder, reset, get_decl

# the chants every caller writes before it can ask clang anything
include("highlevel.jl")
public translation_unit, top_level_decls, find_decl, find_decls, source_location
public definition, members, signature, mangled_name

include("utils.jl")

include("template.jl")
public specialize

end
