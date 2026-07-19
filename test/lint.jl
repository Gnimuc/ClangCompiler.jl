using Test

# Pure-text layout lint for the ClangExtra C shim — catches the drift classes
# that need no compiler to detect (see deps/ClangExtra/CLAUDE.md): duplicate
# opaque typedefs, include-guard collisions (a colliding guard silently drops a
# header from the generated bindings), unregistered .cpp files (which build to
# nothing and fail only at ccall time), and un-underscored uses of the five
# libclang-colliding type names.
const CLANGEX_DIR = normpath(joinpath(@__DIR__, "..", "deps", "ClangExtra"))
const CLANGEX_INC = joinpath(CLANGEX_DIR, "include", "clang-ex")
const CLANGEX_LIB = joinpath(CLANGEX_DIR, "lib")

function clangex_headers()
    headers = String[]
    for (root, _, files) in walkdir(CLANGEX_INC), f in files
        endswith(f, ".h") && push!(headers, joinpath(root, f))
    end
    return headers
end

strip_line_comment(line) = first(split(line, "//"; limit=2))

@testset "ClangExtra layout lint" begin
    @testset "no duplicate typedefs in CXTypes.h" begin
        typedefs = filter(startswith("typedef void *"),
                          readlines(joinpath(CLANGEX_INC, "CXTypes.h")))
        dups = [t for t in unique(typedefs) if count(==(t), typedefs) > 1]
        @test isempty(dups)
    end

    @testset "include guards unique and filename-derived" begin
        seen = Dict{String,String}()
        for h in clangex_headers()
            m = nothing
            for line in eachline(h)
                m = match(r"^#ifndef\s+(\w+)", line)
                m === nothing || break
            end
            @test m !== nothing
            guard = m.captures[1]
            expected = "LLVM_CLANG_C_EXTRA_" * uppercase(splitext(basename(h))[1]) * "_H"
            @test guard == expected
            @test !haskey(seen, guard)
            seen[guard] = h
        end
    end

    @testset "every .cpp is registered; every registered file exists" begin
        for (root, _, files) in walkdir(CLANGEX_LIB)
            "CMakeLists.txt" in files || continue
            cmake = read(joinpath(root, "CMakeLists.txt"), String)
            registered = [m.captures[1]
                          for m in eachmatch(r"\$\{CMAKE_CURRENT_LIST_DIR\}/([\w.]+)", cmake)]
            for f in files
                endswith(f, ".cpp") || continue
                @test f in registered
            end
            for r in registered
                @test isfile(joinpath(root, r))
            end
        end
        for (root, _, files) in walkdir(CLANGEX_INC)
            "CMakeLists.txt" in files || continue
            cmake = read(joinpath(root, "CMakeLists.txt"), String)
            for m in eachmatch(r"\$\{CMAKE_CURRENT_LIST_DIR\}/([\w.]+)", cmake)
                @test isfile(joinpath(root, m.captures[1]))
            end
        end
    end

    @testset "no bare libclang-colliding type names in headers" begin
        # These five names exist in libclang with different (by-value!) layouts;
        # the libclangex spellings carry a trailing underscore.
        bare = r"\b(CXType|CXSourceLocation|CXSourceRange|CXTargetInfo|CXToken)\b"
        for h in clangex_headers()
            for (i, line) in enumerate(eachline(h))
                # file names in #include lines legitimately contain "CXType.h"
                startswith(lstrip(line), "#include") && continue
                m = match(bare, strip_line_comment(line))
                if m !== nothing
                    @error "bare collision-prone name" file = h line = i name = m.match
                end
                @test m === nothing
            end
        end
    end
end
