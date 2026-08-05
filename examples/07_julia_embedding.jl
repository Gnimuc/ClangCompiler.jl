# =================================================================================================
# 07 — Calling Julia from the C++ you just compiled
#
#     julia --project examples/07_julia_embedding.jl
#
# Example 01 went one way: Julia called a C++ function. This one closes the loop. The C++ below
# includes <julia.h> and calls back into the Julia session that is compiling it — reading Julia's
# arrays in place, invoking Julia functions, evaluating Julia code, and asking after Julia
# exceptions (asking, not catching: §5 is about why those are different).
#
# THE DIFFERENCE FROM ORDINARY EMBEDDING, and it is the whole point: normally "embedding Julia"
# means a C++ `main` that calls `jl_init()`, spins up a runtime, drives it, and calls
# `jl_atexit_hook()`. None of that happens here. Julia is *already running* — it is the process
# doing the compiling — and clang's JIT emits this C++ straight into it. So:
#
#   * `jl_init()` is not yours to call: the manual allows it once in a process, and this process
#     spent that one call before your script existed. §1 has the JIT'd code ask
#     `jl_is_initialized()` rather than take that on trust. `jl_atexit_hook()`, its partner, is the
#     teardown of a runtime this file never started, so it is not ours either.
#   * There is one heap and one garbage collector. A `jl_value_t *` in C++ and the Julia object it
#     denotes are the same bytes at the same address, not two copies in sync. The compiled code
#     runs on whichever thread called it, and everything below assumes that is a thread Julia
#     already knows about — which it is, since Julia is the caller.
#   * Which means the GC can see C++'s pointers only if C++ tells it. That is what §4 is about,
#     and it is the part embedders get fatally wrong.
#
# Every row of the tables below is C++'s answer set against Julia's own, computed independently
# rather than pinned; a disagreement raises rather than scrolling past.
# =================================================================================================

import ClangCompiler as CC
using Printf

hdr(t) = @printf("\n== %s %s\n", t, "="^max(0, 88 - length(t)))

function agree(what, from_cxx, from_julia)
    ok = from_cxx isa Real && from_julia isa Real ? from_cxx ≈ from_julia : from_cxx == from_julia
    @printf("   %-26s %-22s %-22s %s\n", what, string(from_cxx), string(from_julia),
            ok ? "ok" : "MISMATCH")
    ok || error("C++ and Julia disagree on $what")
end

# -------------------------------------------------------------------------------------------------
hdr("1. pointing clang at julia.h")
# -------------------------------------------------------------------------------------------------
# The interpreter is hermetic (-nostdinc), so the Julia headers have to be named explicitly. They
# ship inside the Julia installation, next to the binary that is running this script — which is
# also the runtime the compiled code will call into, so header and runtime cannot disagree.
const JULIA_INCLUDE = normpath(joinpath(Sys.BINDIR, "..", "include", "julia"))
@assert isdir(JULIA_INCLUDE) "julia headers not found at $JULIA_INCLUDE"
@printf("   julia.h  : %s\n", joinpath(JULIA_INCLUDE, "julia.h"))
@printf("   runtime  : the process you are reading this in (Julia %s)\n", VERSION)

I = CC.create_interpreter(["-I", JULIA_INCLUDE])

# The banner's first bullet is checkable, so check it instead of asserting it: a `true` from
# `jl_is_initialized`, asked from inside JIT'd code, is the runtime confirming that the one
# `jl_init` a process gets was spent before this script started. `jl_gc_active_impl` then names the
# collector — the devdocs call the stock one non-moving and mostly precise, and §2 and §4 both lean
# on the first half of that.
CC.compile(I, """
    #include <julia.h>
    extern "C" int runtime_is_up()   { return jl_is_initialized(); }
    extern "C" const char *gc_impl() { return jl_gc_active_impl(); }
""")
up = ccall(CC.get_function_pointer(I, "runtime_is_up"), Cint, ()) != 0
up || error("jl_is_initialized() said the runtime is not up, from inside the runtime")
@printf("   asked C++ : jl_is_initialized() -> %s, so the one jl_init is already spent\n", up)
@printf("   collector : %s\n",
        unsafe_string(ccall(CC.get_function_pointer(I, "gc_impl"), Cstring, ())))

# A Julia function defined here, in Main, that the C++ will look up and call by name in §3.
mix(a, b) = a * 1000 + b

# -------------------------------------------------------------------------------------------------
hdr("2. C++ reads Julia's memory in place")
# -------------------------------------------------------------------------------------------------
# `ccall(..., (Any,), v)` passes the `jl_value_t *` itself. No marshalling, no copy: the `double *`
# C++ obtains points into the very array Julia is holding, so a write from C++ is a write Julia
# sees.
#
# On the length. Both macros below are live in julia.h and neither replaced the other, but they
# answer different questions. `jl_array_nrows(a)` is `dimsize[0]` — the FIRST DIMENSION.
# `jl_array_len(a)` expands to `ndims == 1 ? nrows : mem->length`, so for a vector it is the
# length, and for higher rank it is the length of the BACKING BUFFER, which equals the element
# count only while that buffer is exactly sized: reshape a vector that `sizehint!` over-allocated
# and a 2x3 matrix over a 64-slot buffer reports 64. The count that is right for any rank is the
# product of `jl_array_dim(a, d)` over `jl_array_ndims(a)` dimensions, which is what `sum_whole`
# uses. Reach for `nrows` on a matrix instead and you walk one column's worth and call it the
# whole array — the `nrows loop on a matrix` row below is clang doing exactly that, on purpose. It
# is a short read of an in-bounds prefix, not an overrun, which is why it can be run at all.
CC.compile(I, """
    #include <julia.h>

    extern "C" double sum_in_place(jl_value_t *v) {
        jl_array_t *a = (jl_array_t *)v;
        double *p = jl_array_data(a, double);
        double acc = 0.0;
        for (size_t i = 0; i < jl_array_nrows(a); ++i) acc += p[i];   // dimsize[0], not the count
        return acc;
    }

    extern "C" double sum_whole(jl_value_t *v) {
        jl_array_t *a = (jl_array_t *)v;
        double *p = jl_array_data(a, double);
        size_t n = 1;
        for (size_t d = 0; d < jl_array_ndims(a); ++d) n *= jl_array_dim(a, d);
        double acc = 0.0;
        for (size_t i = 0; i < n; ++i) acc += p[i];                   // contiguous, column-major
        return acc;
    }

    extern "C" void scale_in_place(jl_value_t *v, double k) {
        jl_array_t *a = (jl_array_t *)v;
        double *p = jl_array_data(a, double);
        for (size_t i = 0; i < jl_array_nrows(a); ++i) p[i] *= k;
    }
""")

data = [1.0, 2.0, 3.0, 4.0, 5.0]
mat = reshape(Float64.(1:6), 2, 3)          # columns [1,2], [3,4], [5,6]
sum_nrows = CC.get_function_pointer(I, "sum_in_place")
sum_dims = CC.get_function_pointer(I, "sum_whole")
@printf("   %-26s %-22s %-22s\n", "", "C++", "Julia")
agree("sum of the vector", ccall(sum_nrows, Cdouble, (Any,), data), sum(data))
agree("nrows loop on a matrix", ccall(sum_nrows, Cdouble, (Any,), mat), sum(mat[:, 1]))
agree("dim-product loop on it", ccall(sum_dims, Cdouble, (Any,), mat), sum(mat))

before = copy(data)
ccall(CC.get_function_pointer(I, "scale_in_place"), Cvoid, (Any, Cdouble), data, 10.0)
agree("after C++ scaled by 10", data, before .* 10)
println("   the array Julia still owns was mutated by C++; nothing was copied either way")

# -------------------------------------------------------------------------------------------------
hdr("3. C++ calls a Julia function")
# -------------------------------------------------------------------------------------------------
# Three steps, and each is a real Julia operation: look the binding up in a module
# (`jl_get_function`), wrap C values as Julia values (`jl_box_*`), apply (`jl_call1`/`jl_call2`).
# `mix` is the Julia function defined at the top of this file — the lookup goes through the same
# module table the REPL uses, so anything reachable from Main is reachable from here.
#
# Two checks in that C++ are not decoration:
#
#   * `jl_get_function` is `jl_get_global` plus a cast, and a name Main does not have is simply
#     NULL — no exception, no diagnostic, and the same NULL for a typo as for a global that was
#     declared but never assigned. The two rows below are those two cases, indistinguishable. Hand
#     that NULL to `jl_call2` and no documented check stands between it and dispatch, and §5's flag
#     is no help either, since no Julia exception was ever raised. The NULL is yours to notice.
#   * `jl_unbox_float64` is an unchecked reinterpret of the bytes at `r` — hand it an `Int64` 2 and
#     it hands back 1.0e-323 rather than complaining. `jl_typeis` is the question worth asking.
#
# And a third that is §4's subject arriving early: a result stays rooted for as long as anything
# still reads it. `jl_exception_occurred` is not annotated `JL_NOTSAFEPOINT` in julia.h — its
# neighbour `jl_exception_clear` is — so a collection is permitted across it, and `r` is live
# across it in both functions below. `jl_typeis` then dereferences `r`, which settles the matter.
CC.compile(I, """
    #include <julia.h>

    extern "C" double call_julia_mix(double a, double b) {
        jl_function_t *f = jl_get_function(jl_main_module, "mix");
        if (f == NULL) return -2.0;           // never hand NULL to jl_call*: nothing checks it
        jl_value_t *x = NULL, *y = NULL, *r = NULL;
        JL_GC_PUSH4(&f, &x, &y, &r);          // see section 4
        x = jl_box_float64(a);
        y = jl_box_float64(b);
        r = jl_call2(f, x, y);
        bool got = !jl_exception_occurred() && r != NULL && jl_typeis(r, jl_float64_type);
        double out = got ? jl_unbox_float64(r) : -1.0;
        JL_GC_POP();
        return out;
    }

    // The failing lookups, so the paragraph above is measured rather than asserted.
    extern "C" double lookup_missing(const char *name) {
        return jl_get_function(jl_main_module, name) == NULL ? -2.0 : 0.0;
    }

    extern "C" double eval_julia_source(const char *code) {
        jl_value_t *r = NULL;                 // initialised before the push, as it must be
        JL_GC_PUSH1(&r);
        r = jl_eval_string(code);
        bool got = r != NULL && !jl_exception_occurred() && jl_typeis(r, jl_float64_type);
        double out = got ? jl_unbox_float64(r) : -1.0;   // NULL and non-Float64 both short-circuit
        JL_GC_POP();                          // one exit, so exactly one pop
        return out;
    }
""")

call_mix = CC.get_function_pointer(I, "call_julia_mix")
@printf("   %-26s %-22s %-22s\n", "", "via C++", "in Julia")
for (a, b) in ((2.0, 3.0), (7.0, 11.0))
    agree("mix($a, $b)", ccall(call_mix, Cdouble, (Cdouble, Cdouble), a, b), mix(a, b))
end

global unassigned_global::Int               # declared here, never assigned anywhere
lookup = CC.get_function_pointer(I, "lookup_missing")
for (label, name) in (("lookup of a typo", :no_such_julia_function),
                      ("lookup of an unassigned", :unassigned_global))
    agree(label, ccall(lookup, Cdouble, (Cstring,), String(name)), isdefined(Main, name) ? 0.0 : -2.0)
end

# `jl_eval_string` runs the parser and the compiler, from inside JIT'd machine code, in the session
# that is hosting it. There is no sandbox and no second runtime — it evaluates in `jl_main_module`,
# so this is exactly `Main.eval`, down to the toplevel scope the expression sees.
eval_src = CC.get_function_pointer(I, "eval_julia_source")
agree("eval \"sqrt(2.0)\"", ccall(eval_src, Cdouble, (Cstring,), "sqrt(2.0)"), sqrt(2.0))

# -------------------------------------------------------------------------------------------------
hdr("4. rooting: the part that kills embedders")
# -------------------------------------------------------------------------------------------------
# The collector §1 named is the one the devdocs describe as non-moving and mostly precise: an
# address stays that object's address, but it *does* free. It finds live objects by walking roots it
# knows about: Julia stack frames, globals, and — only if you say so — the local variables of C
# code. A `jl_value_t *` sitting in a C++ local is invisible to it.
#
# So this is a use-after-free waiting for the wrong moment:
#
#     jl_value_t *x = jl_box_float64(1.0);   // allocated, unrooted
#     jl_value_t *r = jl_call1(f, x);        // `f` may allocate -> may collect -> `x` may be freed
#
# `JL_GC_PUSH<N>(&a, &b, ...)` declares a local array holding the ADDRESSES of those variables and
# links it onto the current task's `gcstack`; `JL_GC_POP()` unlinks it. Reading that macro in
# julia.h rather than recalling it is what settles the rules worth memorising:
#
#   * push addresses, never values. `JL_GC_ENCODE_PUSH` tags the frame as holding *indirect* roots,
#     so the collector dereferences each slot at every mark and sees whatever the variable holds
#     now — which is exactly why reassigning a pushed variable keeps the new value rooted.
#   * every pushed slot must hold NULL or a real value before the next allocation, because that
#     dereference is unconditional: whatever bytes are in the slot get followed as if they were a
#     root. Pushing is itself not a safepoint, so "NULL-initialise, then push" cannot go wrong.
#   * nothing that can allocate may run between a value appearing and its slot being rooted. That
#     window is empty by construction when you assign into an already-pushed slot; it is equally
#     empty in the `f = jl_get_function(...); if (f == NULL) ...; JL_GC_PUSH4(&f, ...)` above, where
#     only a NULL test separates the two. Pushing after the value exists is fine; pushing after
#     something *allocated* is not.
#   * the frame is an ordinary local array and POP just relinks the task's chain, so a path that
#     returns without popping leaves the task rooting a dead stack frame. One POP on every path —
#     and never two pushes in one scope: the macro names its array `__gc_stkf` every time, so clang
#     answers a second push in the same block with "redefinition of '__gc_stkf'".
#   * and the frame's reach ends with the scope that declared it. After the POP, and in every later
#     call, those slots root nothing — so a `jl_value_t *` parked in a C++ `static` between calls is
#     not rooted at all, the collector having no reason to look at C++ globals. Holding a value
#     across calls means holding it from Julia instead; the manual's recipe is a global `IdDict` in
#     `Main` that you `setindex!` into and later `delete!` from, which it notes works properly only
#     for mutable types. Nothing below needs one, which is why nothing below has one.
#
# Two things are demonstrated below, and which is which matters. `survives_full_gc` shows a rooted
# box coming through a forced full collection intact and still usable. On its own that would prove
# very little: a value nothing reclaimed looks identical to a value that was never at risk, so a
# rooting demo that passes either way is worse than none. `box_outlives_gc` supplies the missing
# half by running the comparison — same box, same forced collection, but the root optionally
# dropped first, with a weak reference (which never roots its target) reporting whether the
# collector took it. Dropping a root is ordinary defined behaviour; what is undefined is *reading*
# an unrooted pointer afterwards, and that stays described here rather than run.
CC.compile(I, """
    #include <julia.h>

    extern "C" double survives_full_gc(double x) {
        jl_function_t *f = jl_get_function(jl_main_module, "mix");
        if (f == NULL) return -2.0;           // before the push, so the push/pop still pair
        jl_value_t *boxed = NULL, *r = NULL;
        JL_GC_PUSH3(&f, &boxed, &r);
        boxed = jl_box_float64(x);

        // A full collection, right here, with `boxed` reachable only from this C++ frame.
        jl_gc_collect(JL_GC_FULL);

        r = jl_call2(f, boxed, boxed);
        bool got = !jl_exception_occurred() && r != NULL && jl_typeis(r, jl_float64_type);
        double out = got ? jl_unbox_float64(r) : -1.0;   // unboxed while still rooted
        JL_GC_POP();
        return out;
    }

    // Is that root load-bearing? `watch` is a weak reference, so it never keeps `boxed` alive. When
    // `keep_root` is false the slot is set to NULL *before* the collection and never read again, so
    // nothing here dereferences a dead pointer — the question is put to the collector, not to the
    // pointer. Julia leaves `watch->value` as `nothing` exactly when the box was reclaimed.
    extern "C" int box_outlives_gc(int keep_root) {
        jl_value_t *boxed = NULL;
        jl_weakref_t *watch = NULL;
        JL_GC_PUSH2(&boxed, &watch);
        boxed = jl_box_float64(1.5);
        watch = jl_gc_new_weakref(boxed);     // allocates, and the box's only STRONG root is `boxed`
        if (!keep_root) boxed = NULL;
        jl_gc_collect(JL_GC_FULL);
        int alive = watch->value != jl_nothing;
        JL_GC_POP();
        return alive;
    }
""")

survives = CC.get_function_pointer(I, "survives_full_gc")
@printf("   %-26s %-22s %-22s\n", "", "rooted, after a full GC", "expected")
for x in (4.0, 9.0)
    agree("mix(x, x) with x = $x", ccall(survives, Cdouble, (Cdouble,), x), mix(x, x))
end

outlives = CC.get_function_pointer(I, "box_outlives_gc")
box_alive(keep) = ccall(outlives, Cint, (Cint,), keep) != 0
println()
@printf("   %-26s %-22s %-22s\n", "same box, full GC forced", "weakref says alive", "expected")
agree("root slot kept", box_alive(true), true)
agree("root slot cleared first", box_alive(false), false)
println("   the second row is what makes the first one evidence: drop the root and the collector")
println("   takes the box, so JL_GC_PUSH is doing the work rather than luck")

# -------------------------------------------------------------------------------------------------
hdr("5. Julia exceptions do not become C++ exceptions")
# -------------------------------------------------------------------------------------------------
# A Julia error raised under `jl_call*` or `jl_eval_string` does not unwind through C++ as a
# `throw`. Both wrap the work in Julia's own setjmp-based JL_TRY/JL_CATCH, so the longjmp lands
# inside them and never crosses your frame: the call returns NULL and sets a pending exception you
# must ask for. A `catch (...)` around it never fires and your locals are destroyed on the ordinary
# path. Ignore the flag and you carry on with a null `jl_value_t *`, which is the same class of
# silent-wrong as the handle mistakes example 03 is about.
#
# That flag is `previous_exception` in the thread-local state — one slot per THREAD, not per call
# and not per task — and it is sticky: it outlives arbitrary intervening C++, and the runtime
# resets it only on the next *successful* embedding call. So clearing it is not about protecting
# the next call, which would clear it for you; it is what makes "did MY call fail?" answerable at
# all, rather than reporting a failure that belongs to something else on this thread.
#
# `jl_typeof_str` names what was raised: the type's bare name, with no module qualification and no
# type parameters (a `Base.RefValue{Int}` comes back as "RefValue"). These four round-trip exactly
# because the exception types involved take no parameters. Those characters belong to the *type*,
# not to the exception object — julia.h declares the error types it exports `JL_GLOBALLY_ROOTED`,
# and the rest are reachable from their modules for the life of the session — which is why the
# pointer can be handed back rather than copied.
CC.compile(I, """
    #include <julia.h>

    extern "C" const char *classify_failure(const char *code) {
        jl_value_t *r = NULL;
        JL_GC_PUSH1(&r);                   // §4's discipline, even though only a NULL test follows
        r = jl_eval_string(code);
        jl_value_t *e = jl_exception_occurred();
        const char *what;
        if (e) {
            // Name it BEFORE clearing. Clearing drops the runtime's own root on `e`, and while
            // `jl_typeof_str` is JL_NOTSAFEPOINT so nothing could collect in between either way,
            // reading a value one line after unrooting it is the habit this file argues against.
            what = jl_typeof_str(e);
            jl_exception_clear();          // so the next check reports the next call, not this one
        } else {
            what = r == NULL ? "null result, no exception" : "ok";
        }
        JL_GC_POP();                       // single exit, so the frame is unlinked exactly once
        return what;
    }
""")

classify = CC.get_function_pointer(I, "classify_failure")
cxx_says(code) = unsafe_string(ccall(classify, Cstring, (Cstring,), code))
# Julia's own answer, computed independently rather than pinned: `nameof(typeof(e))` is the same
# question `jl_typeof_str` asks, which is why the two columns are comparable at all.
julia_says(code) = try
    Main.eval(Meta.parse(code))
    "ok"
catch e
    string(nameof(typeof(e)))
end

@printf("   %-26s %-22s %-22s\n", "julia code evaluated", "C++ saw", "Julia's own name")
for code in ("1 + 1", "error(\"boom\")", "sqrt(-1.0)", "[1,2,3][99]")
    agree(code, cxx_says(code), julia_says(code))
end
println("   each name came from `jl_typeof_str` on the pending exception, not from a C++ catch")

# -------------------------------------------------------------------------------------------------
hdr("6. cleanup")
# -------------------------------------------------------------------------------------------------
# Only the interpreter is ours to release. The Julia runtime keeps running — it was here first,
# and `jl_atexit_hook` is emphatically not ours to call.
CC.dispose(I)
println("   interpreter disposed; the Julia session is untouched and still running\n")
