# Generates src/clang/core/converts.jl: the marshalling table that turns a carrier
# into a `CX*` handle at a ccall boundary.
#
# One `unsafe_convert`/`cconvert` pair per *handle type*, keyed on the abstract type of the
# class that handle names. Since Clang's single inheritance is reproduced by Julia subtyping,
# the pair keyed on `AbstractStmt` serves every statement carrier, so a class needs an entry
# only for the handle it introduces -- one per handle rather than one per carrier per base.
#
# The keying abstract is read out of the sources rather than derived from the handle's name,
# because the carrier names carry collision suffixes (`Expr_`, `Type_`, `Token`) that no name
# rule recovers. Where several carriers store one handle, the entry keys on the
# closest common ancestor of their abstracts, so it admits every carrier that already reaches
# the handle and nothing else. The ancestor need not be one of the candidates: nothing stores
# `CXType_` under `AbstractType_` alone, because that abstract and `AbstractBuiltinType` are
# siblings under `AbstractType`.

const HC_ROOT = dirname(@__DIR__)
const HC_BINDINGS = joinpath(HC_ROOT, "lib", "18", "LibClangEx.jl")
const HC_SRC = joinpath(HC_ROOT, "src", "clang")
const HC_OUT = joinpath(HC_SRC, "core", "converts.jl")

# Handles no carrier stores and whose class name does not spell its abstract. Each entry is a
# name collision the CX side resolved with a trailing underscore and the Julia side resolved
# some other way, so the two spellings cannot be bridged by a rule.
const HC_ALIASES = Dict("CXDiagnostic_" => "AbstractDiagnostic",
                        "CXEvalResult_" => "AbstractEvalResult",
                        "CXModule_" => "AbstractModule",
                        "CXPrintingPolicy_" => "AbstractPrintingPolicy",
                        "CXSourceLocation_" => "AbstractSourceLocation",
                        "CXTargetInfo_" => "AbstractTargetInfo",
                        "CXToken_" => "AbstractToken")

"Every `CX*` handle the bindings declare, in declaration order."
function hc_handles(path=HC_BINDINGS)
    src = read(path, String)
    return [m[1] for m in eachmatch(r"^const (CX\w+) = Ptr\{CX\w+Impl\}"m, src)]
end

"""
    hc_scan_sources(dir)

Walk the hand-written layer and return `(supers, carriers, homes)`: the supertype of every
abstract type, `(carrier, abstract, handle)` for every carrier of the plain `ptr::CX*` shape,
the file each name was declared in (which groups the emitted table), and `(carrier, handle)`
for every carrier including the few with no supertype.
"""
function hc_scan_sources(dir=HC_SRC)
    supers = Dict{String,String}()
    homes = Dict{String,String}()
    carriers = Tuple{String,String,String}[]
    admits = Tuple{String,String}[]
    for (root, _, files) in walkdir(dir), f in files
        endswith(f, ".jl") || continue
        path = joinpath(root, f)
        rel = relpath(path, dir)
        src = read(path, String)
        for m in eachmatch(r"^abstract type (\w+)(?: <: (\w+))? end"m, src)
            supers[m[1]] = m[2] === nothing ? "Any" : m[2]
            get!(homes, m[1], rel)
        end
        # the carrier's own constructor follows the field, so the body is not just one line
        for m in eachmatch(r"^struct (\w+)(?: <: (\w+))?\n    ptr::(CX\w+)\nend"m, src)
            m[2] === nothing || push!(carriers, (m[1], m[2], m[3]))
            push!(admits, (m[1], m[3]))
            get!(homes, m[1], rel)
        end
    end
    return supers, carriers, homes, admits
end

"""
    hc_section(handle, keyabs, byhandle_carrier, homes)

The file this handle's entry belongs under: the one declaring the carrier for its own class
where there is one, else the one declaring the keying abstract. That is what makes the table
read in the order of the layer it marshals for, rather than in binding-declaration order.
"""
function hc_section(handle, keyabs, byhandle_carrier, homes)
    for c in get(byhandle_carrier, handle, String[])
        haskey(homes, c) && return homes[c]
    end
    return get(homes, keyabs, "core.jl")
end

"`a` and every ancestor of it, nearest first."
function hc_chain(supers, a)
    out = String[]
    cur = a
    while cur != "Any"
        push!(out, cur)
        cur = get(supers, cur, "Any")
    end
    return out
end

"""
    hc_keying_abstract(handle, byhandle, supers, abstracts)

The abstract type standing for the C++ class the handle names, so that its subtypes are
exactly the carriers `handle` may marshal. `nothing` when nothing in the sources claims the
handle -- the caller reports it rather than guessing, since a wrong key would silently widen
the boundary.

Two readings have to agree. The abstracts of the carriers that store the handle give a lower
bound, their closest common ancestor. The handle's own name gives the node the hierarchy was
built around. The name wins whenever it sits at or above that ancestor, because a carrier
storing a handle is evidence about one class while the hierarchy node is the statement about
all of them: only one carrier stores `CXExpr`, so the ancestor alone would key it on
`AbstractExpr_` -- the leaf holding the `Expr_` carrier -- and no other expression could
reach `clang_Expr_*`. Where the name resolves lower instead, or to something that is not an
abstract type at all, the ancestor stands.
"""
function hc_keying_abstract(handle, byhandle, supers, abstracts)
    named = "Abstract" * handle[3:end]
    named in abstracts || (named = get(HC_ALIASES, handle, ""))
    named in abstracts || (named = "")
    cands = unique(get(byhandle, handle, String[]))
    isempty(cands) && return isempty(named) ? nothing : named
    for a in hc_chain(supers, first(cands))
        all(c -> a in hc_chain(supers, c), cands) || continue
        return !isempty(named) && named in hc_chain(supers, a) ? named : a
    end
    return nothing
end

function hc_emit(io, entries)
    println(io, """
    # This file is generated by gen/handle_converts.jl -- do not edit by hand.
    #
    # The marshalling table: how a carrier reaches a ccall that wants a `CX*` handle.
    #
    # Each pair is keyed on an abstract type, so it serves every carrier below it -- the entry
    # for `CXStmt` is what lets an `IfStmt` be passed to a `clang_Stmt_*` binding. That mirrors
    # C++, where a derived pointer converts to a base pointer with no cast written; the
    # reinterpret is the identity because Clang's AST hierarchies are singly inherited, so a
    # base subobject shares its address with the object.
    #
    # A conversion these methods do *not* provide is a fact about the C++ side: `AbstractIfStmt`
    # has no route to `CXWhileStmt`, so a wrapper body naming the wrong binding is a method
    # error rather than a pointer of the wrong type arriving in clang.
    #
    # Bases that are not at offset zero -- `DeclContext` in the Decl hierarchy -- are unreachable
    # by reinterpreting and get their own methods, alongside this table rather than in it.
    #
    # Grouped by the core/ file that declares each class, so the table reads in the order of the
    # layer it marshals for. A handle whose class has no carrier is filed under the abstract's.
    """)
    for section in sort(unique(s for (_, _, s) in entries))
        here = sort([(h, a) for (h, a, s) in entries if s == section])
        println(io, "# ", section)
        for (handle, keyabs) in here
            println(io, hc_method("Base.unsafe_convert", handle, keyabs, "$handle(x.ptr)"))
            println(io, hc_method("Base.cconvert", handle, keyabs, "x"))
        end
        println(io)
    end
end

"""
    hc_method(f, handle, keyabs, body)

`f(::Type{handle}, x::keyabs) = body`, wrapped to the repo's 120-column margin. Clang's
longest class names put the one-line form 20 columns over on its own, so those spill into
the block form rather than being left for a formatter to find.
"""
function hc_method(f, handle, keyabs, body; margin=120)
    oneline = "$f(::Type{$handle}, x::$keyabs) = $body"
    length(oneline) <= margin && return oneline
    pad = " "^(length(f) + 9)  # under `::Type{`, YAS continuation alignment
    return """
    function $f(::Type{$handle},
    $pad x::$keyabs)
        return $body
    end"""
end


function emit_handle_converts()
    handles = hc_handles()
    supers, carriers, homes, admits = hc_scan_sources()
    # A scanner that matches nothing is silent: every handle then falls back to the name rule,
    # which still produces an abstract type and still compiles -- but keys `CXType_` on
    # `AbstractType_` rather than `AbstractType`, so the builtin singletons lose their route.
    # Adding a line to the carrier shape once broke this exact way.
    @assert length(carriers) > 900 "carrier scanner matched $(length(carriers)) carriers; the struct shape has changed"
    @assert length(supers) > 900 "abstract scanner matched $(length(supers)) types; the shape has changed"
    abstracts = Set(keys(supers))
    byhandle = Dict{String,Vector{String}}()
    byhandle_carrier = Dict{String,Vector{String}}()
    for (carrier, abs, h) in carriers
        push!(get!(byhandle, h, String[]), abs)
        push!(get!(byhandle_carrier, h, String[]), carrier)
    end

    entries = Tuple{String,String,String}[]
    unclaimed = String[]
    for h in handles
        keyabs = hc_keying_abstract(h, byhandle, supers, abstracts)
        keyabs === nothing && (push!(unclaimed, h); continue)
        push!(entries, (h, keyabs, hc_section(h, keyabs, byhandle_carrier, homes)))
    end

    @info "handle converts" handles=length(handles) emitted=length(entries) unclaimed=length(unclaimed)
    if !isempty(unclaimed)
        @warn "handles with no keying abstract type -- no carrier can reach these bindings" unclaimed
    end
    open(io -> hc_emit(io, entries), HC_OUT, "w")
    @info "wrote $(relpath(HC_OUT, HC_ROOT))"
    return entries, unclaimed
end

emit_handle_converts()
