using ClangCompiler
using Test

# Coverage accounting: every libclangex binding must be either referenced by
# the hand-written Julia layer, stamped by the table-driven cast/predicate
# machinery, or explicitly parked in test/api_skiplist.txt. The skiplist is a
# ratchet — wrapping a symbol requires deleting its line (a listed-but-now-
# referenced entry fails), so the wrapper debt is visible and can only shrink.
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

    # wrapped-by-construction: the Stmt/Decl/Attr castTo/is families and the
    # Type/TypeLoc castTo families are stamped from their vendored node tables
    # (reached from Julia via resolve/getKind @eval loops), so none appears as
    # literal text in src/
    stamped(n) = occursin(r"^clang_Stmt_(castTo|is)[A-Z]", n) ||
                 occursin(r"^clang_Decl_(castTo|is)[A-Z]\w*Decl$", n) ||
                 occursin(r"^clang_Type_castTo[A-Z]\w*Type$", n) ||
                 occursin(r"^clang_Attr_(castTo|is)[A-Z]\w*Attr$", n) ||
                 occursin(r"^clang_TypeLoc_castTo[A-Z]\w*TypeLoc$", n)

    skiplist_file = joinpath(@__DIR__, "api_skiplist.txt")
    skiplist = Set{String}(l for l in readlines(skiplist_file)
                           if !isempty(l) && !startswith(l, "#"))

    unaccounted = sort!([n for n in binding_names
                         if !(n in referenced) && !stamped(n) && !(n in skiplist)])
    if !isempty(unaccounted)
        @error "bindings with neither a Julia wrapper nor a skiplist entry (wrap them or add to test/api_skiplist.txt)" unaccounted
    end
    @test isempty(unaccounted)

    stale = sort!([n for n in skiplist if n in referenced])
    if !isempty(stale)
        @error "skiplist entries that now have wrappers — delete their lines (ratchet)" stale
    end
    @test isempty(stale)

    dead = sort!([n for n in skiplist if !(n in binding_names)])
    if !isempty(dead)
        @error "skiplist entries that are no longer bindings — delete their lines" dead
    end
    @test isempty(dead)
end
