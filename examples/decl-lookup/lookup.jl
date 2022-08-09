using ClangCompiler

const CC = ClangCompiler

# source file
src = joinpath(@__DIR__, "lookup.cpp")

# compilation flags
args = get_compiler_args()

cc = IncrementalIRGenerator(src, args)

decl_lookup = DeclFinder(cc.instance)

# @assert decl_lookup(cc, "vector", "std::vector")
@assert decl_lookup(cc, "f", "foo::bar::f")

decl = get_decl(decl_lookup)
CC.dump(decl)

func = ClangCompiler.getAsFunction(func)

# TODO: getMangledName(func)

# clean up
dispose(decl_lookup)
dispose(cc)
