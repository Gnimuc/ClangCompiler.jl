using ClangCompiler
using ClangCompiler: libclangex
using libclangex_jll
using Libdl
using Test

# Every symbol the generated bindings expect must exist in the library that
# ClangCompiler actually loads. This catches the silent drift bugs documented
# in deps/ClangExtra/CLAUDE.md: a definition whose signature drifts from its
# extern-C declaration (mangled C++ overload, extern-C symbol never emitted),
# a .cpp missing from its CMakeLists, a declaration with no definition, and
# bindings referencing renamed/removed symbols.
@testset "ABI parity" begin
    llvm_major = string(Base.libllvm_version.major)
    binding_file = joinpath(pkgdir(ClangCompiler), "lib", llvm_major, "LibClangEx.jl")
    binding_names = Set{String}()
    for line in eachline(binding_file)
        m = match(r"@ccall libclangex\.(\w+)\(", line)
        m === nothing || push!(binding_names, m.captures[1])
    end
    @test length(binding_names) > 1000  # sanity: the regex still matches the file

    handle = Libdl.dlopen(libclangex)
    missing_syms = String[]
    for name in sort!(collect(binding_names))
        if Libdl.dlsym(handle, name; throw_error=false) === nothing
            push!(missing_syms, name)
        end
    end

    # A locally-built library (the "libclangex" preference set by
    # deps/build_local.jl) must export every bound symbol — hard failure.
    # The released libclangex_jll artifact may legitimately lag freshly
    # regenerated bindings until the next JLL bump — report only.
    is_jll = isdefined(libclangex_jll, :libclangex) &&
             libclangex == libclangex_jll.libclangex
    if is_jll
        if !isempty(missing_syms)
            @info "bindings ahead of the released libclangex_jll (expected until the next JLL bump)" count =
                length(missing_syms)
        end
        @test true
    else
        if !isempty(missing_syms)
            @error "locally-built libclangex is missing bound symbols" missing_syms
        end
        @test isempty(missing_syms)
    end
end

import ClangCompiler as CC
@testset "carrier constructors and converts" begin
    # Every carrier is `struct T; ptr::Ptr{Cvoid}; end` + a cconvert/
    # unsafe_convert pair targeting its (Ptr{Cvoid}-aliased) CX handle type.
    # A null carrier is a legal value, so the whole family is constructible
    # and convertible without an AST.
    n = 0
    for nm in names(CC; all=true)
        isdefined(CC, nm) || continue
        T = getproperty(CC, nm)
        (T isa DataType && isstructtype(T) && fieldcount(T) == 1 &&
         fieldnames(T) == (:ptr,)) || continue
        fieldtype(T, 1) == Ptr{Cvoid} || continue
        x = T(C_NULL)
        @test Base.cconvert(Ptr{Cvoid}, x) === x
        @test Base.unsafe_convert(Ptr{Cvoid}, x) == C_NULL
        n += 1
    end
    @test n >= 880
end
