# PragmaHandler
"""
    getName(x::AbstractPragmaHandler) -> String
Return the name the handler is registered under, or `""` for the null handler — the one
that runs for any pragma no named handler matched.
"""
function getName(x::AbstractPragmaHandler)
    @check_ptrs x
    return get_string(clang_PragmaHandler_getName(x))
end

"""
    getIfNamespace(x::AbstractPragmaHandler) -> Union{PragmaNamespace,Nothing}
Return `x` as a `PragmaNamespace` when it is one, and `nothing` otherwise. This is Clang's
RTTI-free downcast, and it is how a handler found by [`FindHandler`](@ref) is turned back
into a namespace to walk.
"""
function getIfNamespace(x::AbstractPragmaHandler)
    @check_ptrs x
    p = clang_PragmaHandler_getIfNamespace(x)
    return p == C_NULL ? nothing : PragmaNamespace(p)
end

# EmptyPragmaHandler
"""
    EmptyPragmaHandler(name::AbstractString="") -> EmptyPragmaHandler
Create a handler that does nothing, which is how one specific pragma is silenced rather
than warned about. An empty `name` makes it the null handler of whichever namespace it is
registered in, so it swallows every otherwise-unhandled pragma there — the fine-grained
counterpart of [`IgnorePragmas`](@ref).

This function allocates and one should call `dispose` to release the resources after using
this object — but only while it is not registered: registering transfers ownership. See
[`AddPragmaHandler`](@ref).
"""
function EmptyPragmaHandler(name::AbstractString="")
    h = clang_EmptyPragmaHandler_create(name)
    @assert h != C_NULL "Failed to create EmptyPragmaHandler"
    return EmptyPragmaHandler(h)
end

dispose(x::EmptyPragmaHandler) = clang_EmptyPragmaHandler_dispose(x)

# PragmaNamespace
"""
    PragmaNamespace(name::AbstractString) -> PragmaNamespace
Create a handler that is itself a table of handlers, which is how `#pragma GCC ...` and
`#pragma omp ...` are structured.

This function allocates and one should call `dispose` to release the resources after using
this object; disposing it also destroys every handler it owns. As with
[`EmptyPragmaHandler`](@ref), do not dispose it while it is registered with a preprocessor.
"""
function PragmaNamespace(name::AbstractString)
    ns = clang_PragmaNamespace_create(name)
    @assert ns != C_NULL "Failed to create PragmaNamespace"
    return PragmaNamespace(ns)
end

dispose(x::PragmaNamespace) = clang_PragmaNamespace_dispose(x)

"""
    FindHandler(x::AbstractPragmaNamespace, name::AbstractString; ignore_null::Bool=true) ->
        Union{PragmaHandler,Nothing}
Return the handler registered under `name`, or `nothing`. With `ignore_null = false` a
failed match falls back to the namespace's null handler instead of returning `nothing`.

The result is borrowed from the namespace.
"""
function FindHandler(x::AbstractPragmaNamespace, name::AbstractString;
                     ignore_null::Bool=true)
    @check_ptrs x
    p = clang_PragmaNamespace_FindHandler(x, name, ignore_null)
    return p == C_NULL ? nothing : PragmaHandler(p)
end

"""
    AddPragma(x::AbstractPragmaNamespace, handler::AbstractPragmaHandler)
Register `handler` in `x`.

`x` takes ownership: `handler` must not be disposed until
[`RemovePragmaHandler`](@ref) hands it back. Nothing may be registered under the same name
yet — Clang asserts that.
"""
function AddPragma(x::AbstractPragmaNamespace, handler::AbstractPragmaHandler)
    @check_ptrs x handler
    @assert FindHandler(x, getName(handler)) === nothing "a handler with this name is already registered"
    clang_PragmaNamespace_AddPragma(x, handler)
    return nothing
end

"""
    RemovePragmaHandler(x::AbstractPragmaNamespace, handler::AbstractPragmaHandler)
Unregister `handler`, releasing ownership of it back to the caller. `handler` must
currently be registered in `x`; Clang asserts only that *something* is registered under
its name and would then release that other handler instead, so identity is checked here.
"""
function RemovePragmaHandler(x::AbstractPragmaNamespace, handler::AbstractPragmaHandler)
    @check_ptrs x handler
    found = FindHandler(x, getName(handler))
    @assert found !== nothing && found.ptr == handler.ptr "the handler is not registered in this namespace"
    clang_PragmaNamespace_RemovePragmaHandler(x, handler)
    return nothing
end

function IsEmpty(x::AbstractPragmaNamespace)
    @check_ptrs x
    return clang_PragmaNamespace_IsEmpty(x)
end

# Preprocessor
"""
    AddPragmaHandler(pp::AbstractPreprocessor, handler::AbstractPragmaHandler,
                     namespace::AbstractString="")
Register `handler` with `pp`, under the pragma namespace `namespace` (empty for the top
level; a namespace that does not exist yet is created).

The preprocessor takes ownership: `handler` must not be disposed until
[`RemovePragmaHandler`](@ref) hands it back, and it must not still be registered when the
preprocessor goes away. Nothing may be registered under `handler`'s name in that namespace
yet — Clang asserts that, and the check cannot be made from here because a preprocessor's
root namespace is private with no accessor.
"""
function AddPragmaHandler(pp::AbstractPreprocessor, handler::AbstractPragmaHandler,
                          namespace::AbstractString="")
    @check_ptrs pp handler
    clang_Preprocessor_AddPragmaHandler(pp, namespace, handler)
    return nothing
end

"""
    RemovePragmaHandler(pp::AbstractPreprocessor, handler::AbstractPragmaHandler,
                        namespace::AbstractString="")
Unregister `handler` from `pp`, releasing ownership back to the caller, and drop
`namespace` when it becomes empty.

`handler` must currently be registered under exactly that namespace; Clang asserts both
that the namespace exists and that the handler is in it.
"""
function RemovePragmaHandler(pp::AbstractPreprocessor, handler::AbstractPragmaHandler,
                             namespace::AbstractString="")
    @check_ptrs pp handler
    clang_Preprocessor_RemovePragmaHandler(pp, namespace, handler)
    return nothing
end
