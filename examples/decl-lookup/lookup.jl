using ClangCompiler

const CC = ClangCompiler

# source file
src = joinpath(@__DIR__, "lookup.cpp")

# compilation flags
args = get_compiler_args()

cc = create_incremental_compiler(src, args)

decl_lookup = CC.DeclFinder(cc.instance)

# @assert decl_lookup(cc, "vector", "std::vector")
@assert decl_lookup(cc, "f", "foo::bar::f")

decl = CC.get_decl(decl_lookup)
CC.dump(decl)

# clean up
dispose(decl_lookup)
dispose(cc)
