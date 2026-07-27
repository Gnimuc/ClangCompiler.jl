# Shared test helpers. Include-guarded by callers:
#     isdefined(@__MODULE__, :strip_jl_comments) || include("util.jl")

# Remove `#`-line and `#= =#`-block comments from Julia source, keeping line
# structure. String literals are not tracked: a `#` inside a string truncates
# that line, which at worst under-collects references — never over-collects.
function strip_jl_comments(src::AbstractString)
    out = IOBuffer()
    depth = 0
    i = firstindex(src)
    while i <= lastindex(src)
        c = src[i]
        if depth > 0
            if c == '=' && i < lastindex(src) && src[nextind(src, i)] == '#'
                depth -= 1
                i = nextind(src, nextind(src, i))
                continue
            elseif c == '#' && i < lastindex(src) && src[nextind(src, i)] == '='
                depth += 1
                i = nextind(src, nextind(src, i))
                continue
            end
            c == '\n' && write(out, c)
            i = nextind(src, i)
            continue
        end
        if c == '#'
            if i < lastindex(src) && src[nextind(src, i)] == '='
                depth = 1
                i = nextind(src, nextind(src, i))
                continue
            end
            j = findnext('\n', src, i)
            j === nothing && break
            write(out, '\n')
            i = nextind(src, j)
            continue
        end
        write(out, c)
        i = nextind(src, i)
    end
    return String(take!(out))
end
