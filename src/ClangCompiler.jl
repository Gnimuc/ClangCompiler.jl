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
#
# NOTHING IN THIS LAYER IS `public`, DELIBERATELY, AND THAT IS THE STARTING POSITION RATHER
# THAN AN OVERSIGHT.
#
# `public` is a compatibility promise, and an audit of the thirty-two names that used to carry
# one found most of them unable to keep it across an LLVM major bump. Three shapes of promise
# were being made that this package cannot honour:
#
#   - Values that are line ordinals in clang's TableGen output. `getStmtClass`, `getKind` and
#     `get_attr_kind` renumber wholesale every release -- one of 86 Decl kinds and one of 396
#     attribute kinds kept its number from LLVM 18 to 20.
#   - Carrier type names, which are clang's AST class names. Classes get renamed and deleted
#     (`OMPArraySectionExpr` -> `ArraySectionExpr` in 20, `TypoExpr` gone by 22), taking the
#     Julia binding with them, so `resolve`'s return and `CastError`'s `want` are per-major.
#   - Generated union membership. `AbstractDeclContextDecl` is `DECL_CONTEXT` intersected with
#     what this package wraps, so an `isa` answer can flip not only on an LLVM bump but on a
#     patch release of this package that wraps one more carrier.
#
# A third of the surface was also unreachable from itself: `CastError` is raised only by
# per-class cast constructors that were never public, and `qualifiers`, `enclosing`,
# `module_ancestors` and `macro_history` take argument types no public name produces.
#
# So the first version promises almost nothing here. Every name below is still reachable as
# `ClangCompiler.name` and is what the package is built on; what is withheld is the promise
# that it will not change. Add a `public` line when a downstream package asks for a specific
# name, once what that name can promise across a bump has been written down.
#
# THE ONE EXCEPTION is the six Decl abstracts below. A public function returning a non-public
# type is fine when the caller never has to name it -- `create_interpreter` returns a
# `CxxInterpreter` wrapping a non-public `Interpreter` and nothing is lost. It is NOT fine for
# the AST half, where `find_decl` and `members` hand back declarations whose only useful
# operations were demoted with them; the correct spelling of C++'s `isa<FunctionDecl>` is the
# abstract, carriers being leaves, so without these six there is no portable way to ask what
# came back. They are also the safe end of the hierarchy to promise: the concrete carriers
# follow clang's class names, but these six abstracts are hand-written here, and the Decl
# family gained classes without renaming or deleting one across LLVM 18, 20 and 22 -- unlike
# Stmt (`OMPArraySectionExpr` renamed, `TypoExpr` deleted) and Type (`Elaborated` deleted).
# What they promise is `isa`, and the caveat is that the sets GROW: a later clang may make one
# true for a value it was not true for before.
#
# refuse a conversion between two different CX handles, once, for the whole layer
include("clang/handles.jl")
include("clang/utils.jl")
include("clang/core/core.jl")
# the six the AST half of the public surface cannot be used without -- see above
public AbstractDecl, AbstractNamedDecl, AbstractFunctionDecl
public AbstractTagDecl, AbstractVarDecl, AbstractRecordDecl
# how a carrier crosses the hierarchy: implicit widening, checked narrowing, and the one
# unchecked reinterpretation the resolve machinery is built from
include("clang/casts.jl")
include("clang/api/api.jl")
include("clang/ast.jl")
# node identity: `==`/`hash` on carriers, and the raw base pointer behind them
include("clang/identity.jl")
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
include("clang/decl.jl")
include("clang/attr.jl")

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
public take_module, has_module, get_llvm_context

# ... and that module on a JIT.
include("compiler/compiler.jl")
public CxxCompiler, create_compiler, link_process_symbols
public get_jit, get_dylib, get_irgenerator

include("types.jl")
public clty_to_jlty, jlty_to_clty

include("parse.jl")
public parse_cxx_scope_spec

include("lookup.jl")
# `reset` is deliberately absent: it extends `Base.reset`, which is already exported from
# Base, so it needs no declaration here and re-declaring another module's name would be
# meaningless. `ClangCompiler.reset(f)` and a bare `reset(f)` both reach it.
public AbstractFinder, DeclFinder, get_decl

# the chants every caller writes before it can ask clang anything
include("highlevel.jl")
public translation_unit, top_level_decls, find_decl, find_decls, source_location
public definition, members, signature, mangled_name
public decl_name, qualified_name

include("utils.jl")

include("template.jl")
public specialize

end
