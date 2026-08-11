# Run every example and fail if any of them does.
#
# This exists because the examples rotted once already: they called `get_compiler_args`,
# `IRGenerator(src, args)` and `link_process_symbols(cc)` with signatures no version of this
# package still had, and nothing noticed, because nothing ran them. Documentation that is never
# executed is a claim, not a demonstration. (Two of those three names are back, under
# `create_irgenerator`/`create_compiler`, which is the sharper version of the same point: a
# name that reappears with a different shape breaks a stale caller exactly as a deleted one
# does, and only running it says which.)
#
#   julia --project examples/runall.jl
#
# Each example runs in its own process. They create and dispose Clang interpreters, and a
# failure part-way through one would otherwise leave state behind for the next; separate
# processes also mean one crash is reported rather than taking the whole run down.

const EXAMPLES = ["01_hello_cxx.jl",
                  "02_ast_tour.jl",
                  "03_type_safety.jl",
                  "04_record_layout.jl",
                  "05_templates.jl",
                  "06_cross_target.jl",
                  "07_julia_embedding.jl"]

const HERE = @__DIR__
const PROJECT = normpath(joinpath(HERE, ".."))

failures = String[]

for name in EXAMPLES
    path = joinpath(HERE, name)
    isfile(path) || (push!(failures, "$name — missing"); continue)

    printstyled("\n", "="^78, "\n", color=:light_black)
    printstyled("RUN  $name\n", bold=true)
    printstyled("="^78, "\n", color=:light_black)

    out = IOBuffer()
    cmd = `$(Base.julia_cmd()) --project=$PROJECT $path`
    ok = success(pipeline(cmd; stdout=out, stderr=out))
    text = String(take!(out))
    print(text)

    # A segfault or an abort prints none of the usual words, so exit status is the primary
    # signal and these are the backstop for a process that somehow exits 0 after crashing.
    crashed = occursin(r"signal \(\d+\)|Segmentation fault|SIGABRT|EXCEPTION_ACCESS_VIOLATION",
                       text)
    if ok && !crashed
        printstyled("PASS $name\n", color=:green, bold=true)
    else
        printstyled("FAIL $name\n", color=:red, bold=true)
        push!(failures, name)
    end
end

printstyled("\n", "="^78, "\n", color=:light_black)
if isempty(failures)
    printstyled("all $(length(EXAMPLES)) examples passed\n", color=:green, bold=true)
else
    printstyled("$(length(failures)) of $(length(EXAMPLES)) failed: $(join(failures, ", "))\n",
                color=:red, bold=true)
    exit(1)
end
