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
    # The symbols on the package's own create → use → dispose path. They are
    # the floor the "report only" branch still holds the artifact to: a library
    # that cannot resolve these is not a lagging libclangex, it is the wrong
    # library or a load that silently produced nothing, and the loop above then
    # reports every bound name as missing while the branch stays quiet.
    core_syms = ["clang_IncrementalCompilerBuilder_create",
                 "clang_Interpreter_create",
                 "clang_Interpreter_getCompilerInstance",
                 "clang_Interpreter_ParseAndExecute",
                 "clang_Interpreter_getSymbolAddress",
                 "clang_Interpreter_dispose"]
    @test issubset(core_syms, binding_names)
    # The core symbols are the ones the package's own startup path calls, so whichever
    # library is loaded must export them. Asserting that outside the branch keeps
    # "bindings ahead of the release" distinguishable from "wrong library at this path",
    # and keeps the check alive on a local build where the is_jll arm never runs.
    @test isdisjoint(core_syms, missing_syms)
    if is_jll
        if !isempty(missing_syms)
            @info "bindings ahead of the released libclangex_jll (expected until the next JLL bump)" count =
                length(missing_syms)
        end
    else
        if !isempty(missing_syms)
            @error "locally-built libclangex is missing bound symbols" missing_syms
        end
        @test isempty(missing_syms)
    end
end

import ClangCompiler as CC

"Every `struct T; ptr::CX*; end` carrier the package defines, with its handle type."
function carriers_with_handles()
    out = Tuple{DataType,DataType}[]
    for nm in names(CC; all=true)
        isdefined(CC, nm) || continue
        T = getproperty(CC, nm)
        (T isa DataType && isstructtype(T) && fieldcount(T) == 1 &&
         fieldnames(T) == (:ptr,)) || continue
        H = fieldtype(T, 1)
        H <: Ptr || continue
        push!(out, (T, H))
    end
    return out
end

@testset "carrier constructors and converts" begin
    # Every carrier is `struct T; ptr::CXSomething; end`, and converts.jl gives its
    # handle a cconvert/unsafe_convert pair keyed on an abstract type above it. A null
    # carrier is a legal value, so the whole family is constructible and marshallable
    # without an AST.
    fam = carriers_with_handles()
    @test length(fam) >= 880
    for (T, H) in fam
        x = T(H(C_NULL))
        # cconvert must hand the ccall the carrier itself: it is what roots the object for
        # the duration of the call, so a copy or an early unwrap here is a use-after-free.
        @test Base.cconvert(H, x) === x
        @test Base.unsafe_convert(H, x) === H(C_NULL)
    end
end

@testset "the C widths this layer assumes match the build" begin
    # `time_t` is 64 bits on every target — that is why the two shim entry points taking one
    # spell `int64_t` and there is no alias to keep in step. It is an assumption, so pin it:
    # `const time_t = Clong` is what this package used to say, and it read 32 bits of a 64-bit
    # value on Windows alone until a review found it.
    @test CC.shim_type_width(:time_t) == 8

    # `off_t` would be 32 bits on mingw, where it is `long` under LLP64 — and a shim compiled
    # with a different width from the prebuilt clang-cpp asks for a C++ symbol that library does
    # not export. CMakeLists.txt sets `_FILE_OFFSET_BITS=64` so all three agree at 64; this is
    # the assertion that says the flag is actually reaching the compiler.
    @test CC.shim_type_width(:off_t) == 8
end

@testset "handle types keep the hierarchies apart" begin
    # What the opaque CX handles buy: widening to a base is spelled by a marshalling method,
    # so the absence of a method is a real statement about C++. `Decl` and `Stmt` are unrelated
    # in clang, so no carrier of one may marshal through the other's handle -- the two
    # ccalls that would then receive a pointer to the wrong class are unreachable.
    #
    # Only carriers hold this property; a bare `Ptr` still bitcasts through Base's own
    # `convert`, which is why wrapper bodies take carriers and not handles.
    stmts = [T for (T, _) in carriers_with_handles() if T <: CC.AbstractStmt]
    decls = [T for (T, _) in carriers_with_handles() if T <: CC.AbstractDecl]
    @test length(stmts) >= 100
    @test length(decls) >= 50
    for T in stmts
        x = T(fieldtype(T, 1)(C_NULL))
        @test Base.unsafe_convert(CC.LibClangEx.CXStmt, x) === CC.LibClangEx.CXStmt(C_NULL)
        @test !applicable(Base.unsafe_convert, CC.LibClangEx.CXDecl, x)
    end
    for T in decls
        x = T(fieldtype(T, 1)(C_NULL))
        @test Base.unsafe_convert(CC.LibClangEx.CXDecl, x) === CC.LibClangEx.CXDecl(C_NULL)
        @test !applicable(Base.unsafe_convert, CC.LibClangEx.CXStmt, x)
    end
end

@testset "carrier construction does not cross handle types silently" begin
    # A carrier's field type is the handle of the class it stands for, so building one
    # straight out of a ccall whose declared return is a *different* handle is a crossing.
    # Julia will not object -- `Base.convert` bitcasts between `Ptr` types -- so the crossing
    # has to be spelled, and `unchecked_cast` is the spelling. Its soundness argument is that
    # its callers established the class first, from the field clang's own `classof` reads: the
    # `resolve` tables, and the bulk walks that carry each node's kind back beside the node.
    # Anything else is a carrier whose Julia type no longer describes its pointee, which is
    # Invariant 1 broken at the source.
    root = pkgdir(CC)
    returns = Dict{String,String}()
    for line in eachline(joinpath(root, "lib", string(Base.libllvm_version.major), "LibClangEx.jl"))
        m = match(r"@ccall libclangex\.(\w+)\(.*\)::(\w+)$", line)
        m === nothing || (returns[m.captures[1]] = m.captures[2])
    end
    @test length(returns) > 4000        # the bindings really were read

    "The `CX*Impl` name behind carrier `nm`'s `ptr` field, or nothing if `nm` is not a carrier."
    function carrier_handle(nm)
        isdefined(CC, Symbol(nm)) || return nothing
        T = getproperty(CC, Symbol(nm))
        (T isa DataType && isstructtype(T) && :ptr in fieldnames(T)) || return nothing
        F = fieldtype(T, :ptr)
        F <: Ptr || return nothing
        return string(nameof(F.parameters[1]))
    end

    scanned, offenders = 0, String[]
    for (dir, _, files) in walkdir(joinpath(root, "src")), f in files
        endswith(f, ".jl") || continue
        relf = relpath(joinpath(dir, f), root)
        for (n, line) in enumerate(eachline(joinpath(dir, f)))
            # prose that names a bad pairing in order to explain it is not a bad pairing
            code = first(split(line, '#'))
            for m in eachmatch(r"\b([A-Z]\w*)\((clang_\w+)\(", code)
                carrier, fn = m.captures[1], m.captures[2]
                haskey(returns, fn) || continue
                got = carrier_handle(carrier)
                if got === nothing
                    # The name is not a carrier. That is ordinary when the binding hands back
                    # a value — a `Bool`, an enum, a count — and wrong when it hands back a
                    # `CX` handle, because a handle has to be wrapped in a carrier. Treating
                    # "resolves to something" as "not my business" is exactly how
                    # `Module(clang_ImportDecl_getImportedModule(x))` passed: `Module` names
                    # Julia's own module type, so the wrapper could never return.
                    startswith(returns[fn], "CX") || continue
                    scanned += 1
                    push!(offenders,
                          "$relf:$n wraps $fn, which returns $(returns[fn]), in $carrier — not a carrier")
                    continue
                end
                scanned += 1
                got == string(returns[fn], "Impl") && continue
                push!(offenders, "$relf:$n builds $carrier from $fn, which returns $(returns[fn])")
            end
        end
    end
    @test scanned >= 2000               # the pattern matches the bulk of the wrapper layer
    isempty(offenders) ||
        @error "carrier built from a foreign handle; wrap it in `unchecked_cast`" offenders
    @test isempty(offenders)
end

@testset "marshalling is keyed on abstract types, never per carrier" begin
    # The step this design replaced had one convert per carrier, and a generator that keeps
    # emitting them is invisible: the methods are merely redundant, so nothing fails. What
    # they cost is the property above -- a per-carrier method admits exactly one class, so a
    # subclass silently loses the route its base was supposed to give it, and the table stops
    # being the single description of what may marshal where.
    concrete = Method[]
    for m in methods(Base.unsafe_convert)
        occursin("ClangCompiler", string(m.file)) || continue
        sig = Base.unwrap_unionall(m.sig).parameters
        length(sig) == 3 || continue
        sig[2] <: Type{<:Ptr} || continue
        S = sig[3]
        (S isa DataType && isstructtype(S)) || continue     # abstract types and Unions are the point
        push!(concrete, m)
    end
    # `EvaluatedStmt` is the one carrier with no abstract type over it, so its handle has
    # nothing else to key on; `gen/handle_converts.jl` reports it as unclaimed.
    allowed = ["EvaluatedStmt"]
    offenders = ["$(m.file):$(m.line) $(Base.unwrap_unionall(m.sig).parameters[3])"
                 for m in concrete
                 if !(string(nameof(Base.unwrap_unionall(m.sig).parameters[3])) in allowed)]
    isempty(offenders) ||
        @error "unsafe_convert keyed on a concrete carrier; key it on the class's abstract type" offenders
    @test isempty(offenders)
    @test length(concrete) == length(allowed)   # and the allowance has not quietly grown
end

@testset "one handle is never another" begin
    # The static guard above covers `Carrier(clang_foo(...))`, where both names sit in one line
    # of source. It cannot see a handle that reached its destination through a local, a
    # container element or a caller -- and every one of those paths bottoms out in `convert` or
    # `unsafe_convert` on a `Ptr`, which bitcast. src/clang/handles.jl refuses that once, for
    # any two handles of this package, so all of them raise.
    fam = carriers_with_handles()
    @test length(fam) >= 880
    checked = 0
    for (T, H) in fam
        for foreign in (CC.LibClangEx.CXDecl, CC.LibClangEx.CXStmt, CC.LibClangEx.CXType_)
            H === foreign && continue
            f = foreign(C_NULL)
            @test_throws ArgumentError T(f)                       # building the wrong carrier
            @test_throws ArgumentError Base.unsafe_convert(H, f)  # a ccall argument
            @test_throws ArgumentError Ref{H}(f)                  # an out-param cell
            checked += 1
        end
        # its own handle, and a null void*, always work
        @test T(H(C_NULL)) isa T
        @test T(C_NULL) isa T
        @test Base.unsafe_convert(H, H(C_NULL)) === H(C_NULL)
    end
    @test checked > 2000

    # an address is not a handle either: Base converts Union{Int,UInt} to any Ptr, and that is
    # the one non-pointer route into the same hole
    @test_throws ArgumentError CC.IfStmt(0)
    @test_throws ArgumentError CC.IfStmt(UInt(4096))

    # a Vector element assignment converts too, so the same refusal reaches it
    @test_throws ArgumentError (v = Vector{CC.LibClangEx.CXWhileStmt}(undef, 1);
                                v[1] = CC.LibClangEx.CXIfStmt(C_NULL))

    # and the message says which class was wanted, rather than reporting no method
    msg = sprint(showerror, try CC.IfStmt(CC.LibClangEx.CXDecl(C_NULL)) catch e; e end)
    @test occursin("CXIfStmtImpl", msg)
    @test occursin("CXDeclImpl", msg)
end

@testset "every wrapper can return" begin
    # A method whose body always throws infers to `Union{}` — "no path returns". That is the
    # shape a latent wrapper bug takes once handles have distinct types: passing a receiver to
    # a binding that declares none, naming a handle no conversion route reaches, or wrapping a
    # return in a name that resolves to something other than the intended carrier. None of it
    # is visible to a green suite, because a wrapper nothing calls never throws.
    #
    # Inference answers for every method at once, including the ones no test reaches, and
    # needs no fixture, no AST and no ccall. The four it found — `Decl`'s two static methods
    # given a receiver, `getImportedModule` wrapping a `CXModule_` in Julia's `Base.Module`,
    # and `mergeDefinitionIntoModule` declaring a `Base.Module` parameter — had all been
    # unreachable since they were written.
    bottoms, scanned = String[], 0
    for name in names(CC; all=true)
        isdefined(CC, name) || continue
        f = getfield(CC, name)
        f isa Function || continue
        for m in methods(f)
            sig = m.sig
            # `where` parameters and varargs have no single concrete signature to infer
            (sig isa UnionAll || m.isva) && continue
            tt = Base.tuple_type_tail(sig)
            any(p -> p isa TypeVar || p === Union{}, tt.parameters) && continue
            rts = try
                Base.return_types(f, tt)
            catch
                continue
            end
            scanned += 1
            isempty(rts) && continue
            all(r -> r === Union{}, rts) || continue
            # `_wrong_handle` is the refusal itself: throwing is the whole of its body
            name === :_wrong_handle && continue
            push!(bottoms, "$name @ $(basename(string(m.file))):$(m.line)  $(tt)")
        end
    end
    @test scanned > 5000        # inference really ran over the layer, not over a handful
    isempty(bottoms) ||
        @error "wrapper can never return; every call to it throws" bottoms
    @test isempty(bottoms)
end
