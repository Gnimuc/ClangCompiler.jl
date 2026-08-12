# =====================================================================================
# 05 — Templates: instantiating C++ generic code with arguments chosen by Julia
# =====================================================================================
#
# A C++ class template is not a class. `template <class T, int N> struct Buffer` is a
# *pattern*: a recipe clang keeps around, unable to say how big it is or where its fields
# sit, because it does not yet know what `T` and `N` are. Only when someone supplies
# arguments does clang run the recipe — substituting into the pattern, laying the result
# out for the target ABI, and recording it as a new declaration, a
# `ClassTemplateSpecializationDecl`.
#
# In a normal build "someone" is always C++ source text. Here it is Julia. We pick `T` and
# `N` in a Julia loop and drive clang's own template machinery to produce the
# instantiation, then read back what clang computed about it.
#
# The two steps are distinct and it is worth keeping them apart in your head:
#
#   1. `CC.specialize` builds the specialization *declaration* and registers it with the
#      template. After this step clang knows the name `Buffer<double, 4>` exists — and
#      nothing else. The record is still incomplete: no fields, no size.
#   2. `Sema::InstantiateClassTemplateSpecialization` runs the substitution that turns that
#      declaration into a *definition*. This is the step that does the real work, and it is
#      Sema's job because substitution needs the full semantic analyser, not just the AST.
#
# Everything printed below is a value clang computed. Section 6 re-derives the same numbers
# a completely different way — by JIT-compiling `sizeof` and running it — as an independent
# check, and section 7 shows the one place where driving instantiation by hand and driving it
# by compiling source must not be mixed.

using ClangCompiler
using ClangCompiler: LLVM
import ClangCompiler as CC

const CPP = """
// The pattern. Nothing here has a size: `data` is an array of `N` elements of `T`, and
// clang has no `T` and no `N` yet. Its fields exist as *dependent* declarations.
template <class T, int N>
struct Buffer {
    T   data[N];   // size depends on both arguments
    int count;     // whose offset therefore depends on both, via sizeof(T)*N and alignof(T)

    // `N` appears in the *body* too. Watch it become a literal in section 7.
    T sum() const { T s = T(); for (int i = 0; i < N; ++i) s += data[i]; return s; }
};
"""

banner(t) = println("\n", "=" ^ 86, "\n  ", t, "\n", "=" ^ 86)

# The LLVM context is needed only to build the constant for a non-type argument: clang stores
# those as `llvm::APSInt`, and this package spells them as LLVM generic values. Both it and the
# interpreter are created out here so the `finally` at the bottom disposes them on every path.
I = CC.create_interpreter(String[])
llctx = LLVM.Context()
try
    CC.parse(I, CPP)

    # `ASTContext` owns every type and declaration and is where new ones get allocated.
    # `Sema` is the semantic analyser — the thing that actually performs substitution.
    ctx = CC.get_ast_context(I)
    sema = CC.get_sema(I)

    # -------------------------------------------------------------------------------
    banner("1. The template, before anything is instantiated")
    # -------------------------------------------------------------------------------
    # A `ClassTemplateDecl` is the pairing of a parameter list with a pattern. Note that
    # `find_decl` hands back the concrete class clang recorded — a `ClassTemplateDecl`, not
    # a base-typed `NamedDecl` — which is what makes the `isa` below meaningful.
    ctd = CC.find_decl(I, "Buffer")
    @assert ctd isa CC.ClassTemplateDecl
    loc = CC.source_location(I, ctd)
    println("ClassTemplateDecl `", CC.getName(ctd), "` at ", loc.file, ":", loc.line, ":", loc.column)

    # The parameter list is the template's signature. Each parameter is itself a
    # declaration, and its *class* is how clang distinguishes the two kinds of argument a
    # caller may supply: a type, or a compile-time value.
    params = CC.getTemplateParameters(ctd)
    println("\n  parameters (", CC.size(params), ", ", CC.getMinRequiredArguments(params),
            " of them required):")
    for i in 0:(CC.size(params) - 1)
        p = CC.resolve(CC.getParam(params, i))
        if p isa CC.TemplateTypeParmDecl
            println("    [", i, "] ", CC.getName(p), " — type parameter  (depth ",
                    CC.getDepth(p), ", index ", CC.getIndex(p), ")")
        elseif p isa CC.NonTypeTemplateParmDecl
            println("    [", i, "] ", CC.getName(p), " — non-type parameter of type `",
                    CC.getAsString(CC.getType(p)), "`  (depth ", CC.getDepth(p), ", index ",
                    CC.getIndex(p), ")")
        end
    end

    # The pattern is a real `CXXRecordDecl` with real `FieldDecl`s — but their types are
    # *dependent*. Printing them is the clearest possible statement of what has not happened
    # yet: clang will show you `T[N]`, because that is genuinely all it knows.
    pattern = CC.getTemplatedDecl(ctd)
    println("\n  pattern `", CC.getName(pattern), "` — fields as written:")
    for f in CC.getFields(pattern)
        println("    ", rpad(CC.getName(f), 6), " : ", CC.getAsString(CC.getType(f)))
    end
    println("\n  (asking for this record's size would be meaningless; a dependent type has none)")

    # -------------------------------------------------------------------------------
    banner("2. Instantiating — the two steps, shown separately")
    # -------------------------------------------------------------------------------
    # `specialize` takes the arguments positionally, in the order the parameters were
    # declared, and accepts exactly the two kinds the parameter list just showed:
    #
    #   * an `AbstractType` — a type argument.  `jlty_to_clty` maps a Julia type onto the
    #     clang builtin type with the same meaning for this target (Float64 -> `double`).
    #   * a Julia `Integer`/`Bool` — a non-type argument, converted to the `APSInt` clang
    #     stores in a `TemplateArgument`.
    #
    # Anything else is rejected: `specialize(..., "4")` raises rather than guessing.
    spec = CC.specialize(ctx, ctd, CC.jlty_to_clty(Float64, ctx), Int32(4))
    @assert spec isa CC.ClassTemplateSpecializationDecl

    println("after specialize:")
    println("  declaration    : ", CC.getAsString(CC.get_decl_type(ctx, spec)))
    println("  template args  : ", CC.size(CC.getTemplateArgs(spec)))
    println("  kind           : ", CC.getSpecializationKind(spec))
    println("  complete?      : ", CC.isCompleteDefinition(spec), "   <- the name exists; the body does not")

    # Step 2. Sema substitutes the arguments into the pattern. The source location is the
    # "point of instantiation" clang would blame in a diagnostic; the template's own
    # location is a fine answer when no C++ source asked for this.
    failed = CC.InstantiateClassTemplateSpecialization(sema, CC.getLocation(ctd), spec)
    @assert !failed "instantiation reported an error"

    println("\nafter InstantiateClassTemplateSpecialization:")
    println("  kind           : ", CC.getSpecializationKind(spec))
    println("  complete?      : ", CC.isCompleteDefinition(spec), "   <- now it has a body")

    # -------------------------------------------------------------------------------
    banner("3. What clang computed — and how it differs per instantiation")
    # -------------------------------------------------------------------------------
    # A specialization decl that merely existed would prove nothing: the interesting claim
    # is that substitution really ran. Field *types* and record *layout* are the proof,
    # because clang can only produce them by substituting and then running the target's ABI
    # layout rules. `T[N]` has become `double[4]`; `count` has an offset that no amount of
    # naming could have supplied.

    """
    Run Sema's substitution on `s`, unless it has already been run.

    The guard is not decoration. `specialize` is memoised, so it happily hands back a
    specialization that is already a definition — and `InstantiateClassTemplateSpecialization`
    is not idempotent: on a record that is already complete it substitutes the pattern in a
    second time and appends a second copy of every member. On a pattern of plain fields that
    leaves a record whose members read `data, count, data, count` (the *size* still reads as
    before, because the layout was computed and cached on the first pass — so the damage is
    not even visible in the numbers). On `Buffer`, whose pattern has a member function, the
    duplicate `sum` is instead diagnosed as a redefinition and the process dies rendering that
    diagnostic, for the same reason described at the end of section 7.

    In a real compile the question never arises, because Sema only reaches instantiation for a
    record that `RequireCompleteType` found incomplete.
    """
    function complete!(s)
        CC.isCompleteDefinition(s) && return s
        CC.InstantiateClassTemplateSpecialization(sema, CC.getLocation(ctd), s) &&
            error("failed to instantiate ", CC.getAsString(CC.get_decl_type(ctx, s)))
        return s
    end

    "Instantiate `Buffer<T, N>` for a `T` and `N` chosen at Julia runtime."
    instantiate(T, N) = complete!(CC.specialize(ctx, ctd, CC.jlty_to_clty(T, ctx), Int32(N)))

    "Print the fields and ABI layout clang derived for one instantiation."
    function report(s)
        layout = CC.get_record_layout(ctx, s)          # clang::ASTRecordLayout
        offsets = CC.field_offsets(ctx, s)             # in *bits*, matching the C++ API
        println("\n  ", CC.getAsString(CC.get_decl_type(ctx, s)))
        println("    sizeof  = ", CC.getSize(layout), " bytes    alignof = ",
                CC.getAlignment(layout), " bytes")
        for (f, off) in zip(CC.getFields(s), offsets)
            println("    +", lpad(Int(off) ÷ 8, 3), "  ", rpad(CC.getName(f), 6), " : ",
                    CC.getAsString(CC.getType(f)))
        end
    end

    # The whole point: this list is Julia data. Nothing in the C++ text mentions `float` or
    # `16`, and no source string is being assembled and re-parsed — the arguments travel
    # into clang as AST nodes.
    choices = [(Float64, 4), (Int32, 4), (UInt8, 3), (Float32, 16), (Int64, 1)]
    specs = [instantiate(T, N) for (T, N) in choices]
    report.(specs)

    println("\n  Same pattern, five different records, and not one of these numbers is a")
    println("  multiplication Julia could have done. `Buffer<unsigned char, 3>` holds 3 bytes")
    println("  of data, yet `count` starts at 4: an `int` has to land on a 4-byte boundary, so")
    println("  a byte of padding follows `data`. `Buffer<double, 4>` has 32 + 4 bytes of")
    println("  members yet reports 40, because a record is rounded up to a whole number of its")
    println("  own alignment. Those are the target's ABI rules, applied by clang, to records")
    println("  that did not exist a moment ago.")

    # -------------------------------------------------------------------------------
    banner("4. Reading the arguments back out")
    # -------------------------------------------------------------------------------
    # A specialization carries the argument list it was built from. `TemplateArgument` is a
    # tagged union, so the kind tells you which accessor is legal — `getAsType` for a type
    # argument, `getAsIntegral` for a value.
    args = CC.getTemplateArgs(specs[1])
    println("Buffer<double, 4> was instantiated with ", CC.size(args), " arguments:")
    for i in 0:(CC.size(args) - 1)
        a = CC.get(args, i)
        kind = CC.getKind(a)
        if kind == CC.LibClangEx.CXTemplateArgument_Type
            println("  [", i, "] ", kind, "  ->  ", CC.getAsString(CC.getAsType(a)))
        elseif kind == CC.LibClangEx.CXTemplateArgument_Integral
            v = LLVM.GenericValue(CC.getAsIntegral(a))
            println("  [", i, "] ", kind, "  ->  ", convert(Int, v), " : ",
                    CC.getAsString(CC.getIntegralType(a)), " (",
                    LLVM.intwidth(v), " bits)")
        end
    end

    # Instantiation is memoised, exactly as it is in a normal compile: the arguments are
    # profiled into a folding set hanging off the template, so asking twice for the same
    # arguments returns the *same declaration*, not a copy. This is why a translation unit
    # that mentions `Buffer<double, 4>` a thousand times has one record, one layout.
    again = CC.specialize(ctx, ctd, CC.jlty_to_clty(Float64, ctx), Int32(4))
    println("\nasking a second time for <double, 4> returns the same decl: ",
            again.ptr == specs[1].ptr)

    # -------------------------------------------------------------------------------
    banner("5. Composition — a specialization used as a template argument")
    # -------------------------------------------------------------------------------
    # A type argument is just a type, and an instantiated specialization is a perfectly good
    # one. Feeding the result of one instantiation back in as the argument of the next is
    # how `vector<vector<int>>` gets built, and it works here for the same reason: we hand
    # clang the `Type` it produced a moment ago.
    inner = instantiate(Float32, 16)                       # already built above; memoised
    inner_ty = CC.getTypePtr(CC.get_decl_type(ctx, inner))  # a `Type`, which is what a type argument is
    outer = complete!(CC.specialize(ctx, ctd, inner_ty, Int32(2)))
    report(outer)
    inner_bytes = CC.getSize(CC.get_record_layout(ctx, inner))
    println("\n    the inner record is ", inner_bytes, " bytes, so `data` here spans ",
            2 * inner_bytes, " bytes")
    println("    before `count` — a layout computed from a layout")

    # -------------------------------------------------------------------------------
    banner("6. Independent check: JIT the same types and compare")
    # -------------------------------------------------------------------------------
    # Everything above was read out of the AST. If the layout code and the reading code
    # shared a mistake, it would look consistent and be wrong. So ask a second, unrelated
    # oracle the same question: compile C++ that computes `sizeof` and `offsetof` for these
    # types, JIT it, and call the machine code from Julia.
    #
    # The type names come from clang itself (`getAsString` on the specialization's type), so
    # the C++ below is spelled the way clang spells it. `extern "C"` matters:
    # `get_function_pointer` looks up an unmangled symbol.
    probe_src = IOBuffer()
    for (i, s) in enumerate(specs)
        name = CC.getAsString(CC.get_decl_type(ctx, s))
        println(probe_src, "using Probe$i = $name;")
        println(probe_src, "extern \"C\" long probe$(i)_size() { return (long)sizeof(Probe$i); }")
        println(probe_src, "extern \"C\" long probe$(i)_off() ",
                "{ return (long)__builtin_offsetof(Probe$i, count); }")
    end
    # ...and one that actually *runs* the generic member function, so the check covers
    # executable code and not just constants the front end folded.
    println(probe_src, """
            extern "C" double probe_sum() {
                Probe1 b{};
                for (int i = 0; i < 4; ++i) b.data[i] = i + 1;
                return b.sum();
            }""")
    # The interpreter keeps everything it has parsed, so `Buffer` is already in scope here —
    # feeding `CPP` in a second time would be a redefinition, not a refresher.
    CC.compile(I, String(take!(probe_src)))

    println(rpad("type", 34), rpad("AST sizeof", 12), rpad("JIT sizeof", 12),
            rpad("AST off", 10), "JIT off")
    println("-" ^ 80)
    agree = true
    for (i, s) in enumerate(specs)
        layout = CC.get_record_layout(ctx, s)
        ast_size = Int(CC.getSize(layout))
        ast_off = Int(CC.field_offsets(ctx, s)[2]) ÷ 8
        jit_size = ccall(CC.get_function_pointer(I, "probe$(i)_size"), Clong, ())
        jit_off = ccall(CC.get_function_pointer(I, "probe$(i)_off"), Clong, ())
        agree &= (ast_size == jit_size) & (ast_off == jit_off)
        println(rpad(CC.getAsString(CC.get_decl_type(ctx, s)), 34), rpad(ast_size, 12),
                rpad(jit_size, 12), rpad(ast_off, 10), jit_off)
    end
    println("-" ^ 80)
    println(agree ? "all rows agree — the AST layout is the layout the machine code uses" :
            "MISMATCH between the AST and the generated code")
    @assert agree

    jit_sum = ccall(CC.get_function_pointer(I, "probe_sum"), Cdouble, ())
    println("\nand Buffer<double, 4>::sum() over {1,2,3,4}, JIT-compiled and called from ",
            "Julia: ", jit_sum, " (expected ", sum(1.0:4.0), ")")
    @assert jit_sum == sum(1.0:4.0)

    # -------------------------------------------------------------------------------
    banner("7. The laziness goes one level further: member function bodies")
    # -------------------------------------------------------------------------------
    # Instantiating a class does *not* instantiate its member functions' bodies. C++ requires
    # this: a class template may have members that would not compile for a given `T`, and as
    # long as nobody calls them the program is still well-formed. So class instantiation
    # produces the method *declarations* — correct signatures, substituted return types — and
    # stops there. A `CXXMethodDecl` is not a field but an ordinary member of the record's
    # `DeclContext`, so walk the record as a context to find it — `getFields` yields only the
    # `FieldDecl`s.
    methods = [d for d in CC.decls_in(CC.castToDeclContext(specs[1])) if d isa CC.CXXMethodDecl]
    sum_fn = only(m for m in methods if CC.getName(m) == "sum")
    println("Buffer<double, 4>::", CC.getName(sum_fn))
    println("  return type : ", CC.getAsString(CC.getReturnType(sum_fn)),
            "        <- `T` was substituted in the signature")
    println("  kind        : ", CC.getTemplateSpecializationKind(sum_fn))
    println("  has a body? : ", CC.hasBody(sum_fn), "      <- but the body was left alone")

    # `InstantiateFunctionDefinition` is the second half. `definition_required=true` is the
    # "somebody actually called this" signal: it tells Sema to diagnose rather than shrug if
    # the body cannot be instantiated for this `T`.
    CC.InstantiateFunctionDefinition(sema, CC.getLocation(ctd), sum_fn, false, true, false)
    println("\nafter InstantiateFunctionDefinition:")
    println("  has a body? : ", CC.hasBody(sum_fn))

    # Substitution reached *inside* the body. The source says `i < N`; in this instantiation
    # there is no `N` any more, only the integer clang put in its place.
    body = CC.getBody(sum_fn)
    literals = [n for n in CC.subtree(body) if n isa CC.IntegerLiteral]
    vals = [convert(Int, LLVM.GenericValue(CC.getValue(n))) for n in literals]
    println("  body        : ", length(CC.subtree(body)), " AST nodes, integer literals ", vals)
    println("                 the `4` is the loop bound `N`, substituted into the body itself")

    # This section used to end with a warning that hand-instantiating a member body and then
    # JIT-compiling source calling that same member killed the process. It did, and the cause
    # was a bug rather than a law: `CC.specialize` built its integral arguments with the wrong
    # signedness (and, for `bool`, the wrong bit width), so the specialization it registered
    # never unified with the one Sema builds for source-written `Buffer<double, 4>`.
    # `TemplateArgument::Profile` folds both into the folding-set key, so the ASTContext held
    # two declarations for one C++ type, and CodeGen was later handed two definitions competing
    # for a single mangled name.
    #
    # Both are taken from the parameter's own declared type now, the two decls are one, and the
    # round trip completes: `specialize` -> instantiate the class -> instantiate the member ->
    # `CC.compile` source that calls it -> execute. Nothing here forbids that ordering any more.

    banner("Recap")
    println("""
      * A class template is a pattern; a `ClassTemplateSpecializationDecl` is what running
        that pattern on concrete arguments produces.
      * `CC.specialize(llvm_ctx, ast_ctx, template_decl, args...)` builds and registers the
        declaration. Type arguments are clang `Type`s (`jlty_to_clty` bridges Julia's);
        non-type arguments are Julia integers and bools.
      * That call alone leaves the record *incomplete*. `Sema` does the substitution:
        `InstantiateClassTemplateSpecialization` is the step that gives it fields and a size,
        and `InstantiateFunctionDefinition` is the further step that gives a member a body.
      * Instantiation is memoised on the argument list, so repeat requests share one decl —
        which is why you must check `isCompleteDefinition` before instantiating. Sema's
        instantiation entry points assume an incomplete input and are not idempotent.
      * A hand-built specialization IS the one Sema builds for the same C++ type — the
        arguments profile identically, so the folding set returns the existing declaration
        rather than a second one. That makes it safe to instantiate a member body and then JIT
        source that calls it; see the note at the end of 7 for the bug that made it unsafe.
      * Because the arguments are ordinary Julia values, the set of instantiations a program
        needs can be computed at runtime — from a config file, a benchmark sweep, a set of
        Julia types — instead of being written out by hand in C++.""")
finally
    # Create -> use -> dispose, in reverse order of creation. The interpreter owns the
    # ASTContext, Sema and the JIT, so every carrier obtained above dangles after this line.
    LLVM.dispose(llctx)
    CC.dispose(I)
end
