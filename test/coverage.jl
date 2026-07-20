using ClangCompiler
using Test

# Coverage accounting: every libclangex binding must be referenced by the Julia
# layer (hand-written or generated), or be one of the downcast helper families
# reached indirectly through resolve()/getKind rather than a per-class call.
# Anything else is an unwrapped binding and fails the test.
@testset "binding coverage" begin
    llvm_major = string(Base.libllvm_version.major)
    binding_file = joinpath(pkgdir(ClangCompiler), "lib", llvm_major, "LibClangEx.jl")
    binding_names = Set{String}()
    for line in eachline(binding_file)
        m = match(r"@ccall libclangex\.(\w+)\(", line)
        m === nothing || push!(binding_names, m.captures[1])
    end

    src = joinpath(pkgdir(ClangCompiler), "src")
    referenced = Set{String}()
    for (root, _, files) in walkdir(src), f in files
        endswith(f, ".jl") || continue
        for m in eachmatch(r"clang_\w+", read(joinpath(root, f), String))
            push!(referenced, m.match)
        end
    end

    # Downcast helper families that need no separate accounting: the Decl/Type
    # castTo and Decl-is predicates are reached from Julia through resolve()+
    # getKind (a table lookup) rather than per-class calls, so they need not
    # appear as literal text in src/. The Stmt/Attr/TypeLoc cast+predicate
    # wrappers ARE generated as explicit source (already in `referenced`);
    # listing them here too is a harmless belt-and-suspenders.
    stamped(n) = occursin(r"^clang_Stmt_(castTo|is)[A-Z]", n) ||
                 occursin(r"^clang_Decl_(castTo|is)[A-Z]\w*Decl$", n) ||
                 occursin(r"^clang_Type_castTo[A-Z]\w*Type$", n) ||
                 occursin(r"^clang_Attr_(castTo|is)[A-Z]\w*Attr$", n) ||
                 occursin(r"^clang_TypeLoc_castTo[A-Z]\w*TypeLoc$", n)

    unaccounted = sort!([n for n in binding_names if !(n in referenced) && !stamped(n)])
    if !isempty(unaccounted)
        @error "libclangex bindings with no Julia wrapper (wrap them)" unaccounted
    end
    @test isempty(unaccounted)
end
