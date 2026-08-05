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
const SRC_DIR = normpath(joinpath(@__DIR__, "..", "src"))

function clangex_headers()
    headers = String[]
    for (root, _, files) in walkdir(CLANGEX_INC), f in files
        endswith(f, ".h") && push!(headers, joinpath(root, f))
    end
    return headers
end

strip_line_comment(line) = first(split(line, "//"; limit=2))

isdefined(@__MODULE__, :strip_jl_comments) || include("util.jl")

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

    @testset "every clang_* reference in src/ resolves to a binding" begin
        # The generated bindings and the Julia wrappers drift silently: a wrapper
        # calling a binding that does not exist passes coverage.jl (which checks
        # the opposite direction) and abi.jl (which checks bindings, not
        # references), then fails at call time as UndefVarError — three wrappers
        # shipped that way. Comment-stripped so a commented-out reference is not
        # required to resolve.
        root = normpath(joinpath(@__DIR__, ".."))
        llvm_major = string(Base.libllvm_version.major)
        defined = Set{String}()
        for lib in (joinpath(root, "lib", llvm_major, "LibClangEx.jl"),
                    joinpath(root, "lib", "LibClang.jl"))
            for m in eachmatch(r"function (clang_\w+)\(", read(lib, String))
                push!(defined, m.captures[1])
            end
        end
        @test length(defined) > 2000

        # Call-shaped references only (`clang_foo(`): plain-variable names like
        # `clang_inc` in env.jl are not binding references.
        unresolved = Dict{String,Vector{String}}()
        for (r, _, files) in walkdir(joinpath(root, "src")), f in files
            endswith(f, ".jl") || continue
            path = joinpath(r, f)
            for m in eachmatch(r"\b(clang_\w+)\(", strip_jl_comments(read(path, String)))
                name = m.captures[1]
                name in defined && continue
                push!(get!(Vector{String}, unresolved, name), relpath(path, root))
            end
        end
        if !isempty(unresolved)
            @error "src/ references clang_* names with no binding" unresolved
        end
        @test isempty(unresolved)
    end

    @testset "every declared C function has a definition" begin
        # extern "C" + void*-typedef signatures mean neither the compiler nor the
        # linker catches a declaration whose definition was never written: the
        # generator still emits a binding for it, and the failure surfaces only
        # when Julia first calls it (dlsym error). Catch it here instead.
        root = normpath(joinpath(@__DIR__, ".."))
        inc = joinpath(root, "deps", "ClangExtra", "include", "clang-ex")
        decl_re = r"^\s*(?:[A-Za-z_][\w:*\s]*?[\s*])(clang_\w+)\s*\("m

        undefined = Dict{String,Vector{String}}()
        for (r, _, files) in walkdir(inc), f in files
            endswith(f, ".h") || continue
            hdr = joinpath(r, f)
            cpp = replace(replace(hdr, joinpath("include", "clang-ex") => "lib"),
                          ".h" => ".cpp")
            isfile(cpp) || continue          # pure-enum headers have no impl
            htext = replace(read(hdr, String), r"//[^\n]*" => "")
            ctext = read(cpp, String)
            for m in eachmatch(decl_re, htext)
                name = m.captures[1]
                occursin(Regex("\\b" * name * "\\s*\\("), ctext) && continue
                push!(get!(Vector{String}, undefined, relpath(hdr, root)), name)
            end
        end
        if !isempty(undefined)
            @error "C functions declared in a header with no definition in its .cpp" undefined
        end
        @test isempty(undefined)
    end

    @testset "every libclangex binding is wrapped or stamped" begin
        # The reverse of the reference-resolution check above: every generated
        # binding must be referenced by the Julia layer (comment-stripped — a
        # clang_* token in a comment is not a wrapper), or belong to a downcast
        # helper family reached indirectly through resolve()/getKind table
        # lookups rather than per-class calls.
        root = normpath(joinpath(@__DIR__, ".."))
        llvm_major = string(Base.libllvm_version.major)
        binding_names = Set{String}()
        for line in eachline(joinpath(root, "lib", llvm_major, "LibClangEx.jl"))
            m = match(r"@ccall libclangex\.(\w+)\(", line)
            m === nothing || push!(binding_names, m.captures[1])
        end
        @test length(binding_names) > 2000

        referenced = Set{String}()
        for (r, _, files) in walkdir(joinpath(root, "src")), f in files
            endswith(f, ".jl") || continue
            for m in eachmatch(r"clang_\w+",
                               strip_jl_comments(read(joinpath(r, f), String)))
                push!(referenced, m.match)
            end
        end

        stamped(n) = occursin(r"^clang_Stmt_(castTo|is)[A-Z]", n) ||
                     occursin(r"^clang_Decl_(castTo|is)[A-Z]\w*Decl$", n) ||
                     occursin(r"^clang_Type_castTo[A-Z]\w*Type$", n) ||
                     occursin(r"^clang_Attr_(castTo|is)[A-Z]\w*Attr$", n) ||
                     occursin(r"^clang_TypeLoc_castTo[A-Z]\w*TypeLoc$", n)

        unaccounted = sort!([n for n in binding_names
                             if !(n in referenced) && !stamped(n)])
        if !isempty(unaccounted)
            @error "libclangex bindings with no Julia wrapper (wrap them)" unaccounted
        end
        @test isempty(unaccounted)
    end

    @testset "MARSHALLING.md anchors resolve" begin
        # Each pattern's "In the tree" / "Partly in the tree" / "Not yet in the
        # tree" anchor cites its canonical wrapper(s) as `clang_*` name then
        # `lib/...` file. Assert every cited symbol is still defined in its cited
        # file, so the playbook cannot silently rot away from the code — a renamed
        # or removed wrapper fails here. Convention the parser enforces: write
        # "`clang_foo` (`lib/.../CXBar.cpp`)", symbol before file.
        doc = read(joinpath(CLANGEX_DIR, "MARSHALLING.md"), String)
        token = r"`(clang_\w+|makeCXString)`|`(lib/[\w/]+\.(?:cpp|h))`"
        anchor_start = r"^\*\*(?:In the tree|Partly in the tree|Not yet in the tree)\."

        anchors = String[]
        buf, inblock = IOBuffer(), false
        for line in split(doc, "\n")
            occursin(anchor_start, line) && (inblock = true)
            inblock || continue
            if isempty(strip(line))
                push!(anchors, String(take!(buf)))
                inblock = false
            else
                println(buf, line)
            end
        end
        inblock && push!(anchors, String(take!(buf)))
        @test !isempty(anchors)

        checked = 0
        for anchor in anchors
            pending = String[]  # `clang_*` symbols awaiting the file that follows
            for m in eachmatch(token, anchor)
                if m.captures[1] !== nothing
                    push!(pending, m.captures[1])
                else
                    relpath = m.captures[2]
                    file = joinpath(CLANGEX_DIR, relpath)
                    @test isfile(file)
                    src = isfile(file) ? read(file, String) : ""
                    for sym in pending
                        occursin(sym, src) || @error "MARSHALLING.md cites a symbol absent from its file" symbol = sym file = relpath
                        @test occursin(sym, src)
                        checked += 1
                    end
                    empty!(pending)
                end
            end
            # a cited `clang_*` with no file after it means the anchor is malformed
            @test isempty(pending)
        end
        @test checked >= 20  # guard against the parser silently matching nothing
    end

    @testset "every statically-true `isa` assertion is marked" begin
        # `@test f(x) isa T` where the wrapper's own return expression fixes T cannot fail:
        # it restates the source, not anything Clang decided, and `test/abi.jl` already owns
        # the question of whether carriers wrap. Where the value genuinely is not assertable
        # -- the host decides it, it varies across the objects the test walks, or it is an
        # integer the target chooses -- the line carries `# shape-only` and its reason.
        #
        # The marker sits at the site on purpose. A per-file baseline recorded the same
        # information three directories from the code, went stale the moment a file was
        # cleaned up, and made two branches conflict over a generated artifact.
        script = joinpath(@__DIR__, "tautologies.jl")
        @test isfile(script)
        # the script exits 1 whenever it reports anything
        out = read(ignorestatus(`$(Base.julia_cmd()) $script`), String)
        unmarked = [m.captures[1] for m in eachmatch(r"^    (\S+:\d+)"m, out)]
        isempty(unmarked) ||
            @error "assertions that cannot fail and are not marked `# shape-only`" unmarked
        @test isempty(unmarked)
    end

    @testset "no unguarded getType read on an arbitrary Expr operand" begin
        # `Expr::getType()` returns a null `QualType` for an unevaluated string
        # literal — what the parser builds for a `static_assert` message — and
        # `QualType::getTypePtr()` asserts rather than returning null. A wrapper
        # that accepts an `AbstractExpr` and reaches for its type pointer without
        # first ruling the null out therefore aborts the process on a valid
        # operand (MARSHALLING.md §13). Wrappers narrowed to a subclass that
        # always carries a type are exempt, so the receiver spelling is what is
        # matched here.
        # The read is matched against the *argument* it is applied to, not merely
        # against the enclosing signature: a wrapper may legitimately take both an
        # expression and a `TypeLoc` and read the latter's type directly.
        direct = r"getTypePtr\(\s*getType\((\w+)\)\s*\)"
        offenders, scanned = String[], 0
        for (root, _, files) in walkdir(joinpath(SRC_DIR, "clang", "api")),
            f in filter(endswith(".jl"), files)

            relf = relpath(joinpath(root, f), SRC_DIR)
            sig = ""
            for (n, line) in enumerate(eachline(joinpath(root, f)))
                if startswith(line, "function ")
                    sig = line
                elseif !isempty(sig) && startswith(line, " "^8) && occursin("::", line)
                    sig *= " " * strip(line)   # continuation of a wrapped parameter list
                end
                for m in eachmatch(direct, line)
                    scanned += 1
                    ty = match(Regex("\\b$(m.captures[1])::(\\w+)"), sig)
                    ty !== nothing && occursin("Expr", ty.captures[1]) || continue
                    push!(offenders, "$relf:$n reads $(m.match)")
                end
            end
        end
        @test scanned >= 5  # guard against the pattern silently matching nothing
        isempty(offenders) ||
            @error "wrapper reads an Expr's type pointer directly; use `expr_type_ptr`" offenders
        @test isempty(offenders)
    end
end
