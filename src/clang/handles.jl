# One handle is never another. Three methods, and the whole layer inherits them.
#
# Every `CX<Class>` is a `Ptr` over a phantom, and both of `Ptr`'s conversions are permissive:
# `convert` and `unsafe_convert` bitcast between any two pointer types without looking. That
# single permissiveness was behind every way a wrong handle could reach clang --
#
#   IfStmt(a_while_stmt_handle)       # the default T(::Any) constructor calls convert
#   clang_WhileStmt_getCond(if.ptr)   # a ccall argument calls unsafe_convert
#   Ref{CXWhileStmt}(Base.unsafe_convert(CXWhileStmt, if))          # a Ref cell calls convert
#   v = Vector{CXWhileStmt}(...); v[1] = if.ptr
#
# -- so refusing it once, here, is what closes all of them. Nothing downstream has to
# remember a rule; a carrier's constructor and a ccall's argument list both bottom out in
# these methods, and both now raise on a class mismatch.
#
# What stays open is the pair of spellings that name the target handle type outright:
# `CXWhileStmt(p)`, which is Julia's own `Ptr{T}(::Ptr)` constructor and bitcasts by
# definition, and `reinterpret`. Neither is reachable by accident -- you cannot arrive at
# either without writing the class you are asserting -- and the first is the mechanism the
# marshalling layer is built from: every entry in `converts.jl` is one, and so is
# `unchecked_cast`. Closing them would leave the resolve machinery no way to express the
# widening that single inheritance makes correct. What the three methods below remove is the
# *implicit* crossing, the one no call site had to ask for.
#
# This is not piracy despite extending Base functions on `Ptr`: `A` and `B` are this package's
# own phantoms, so no call in any program that does not use this package can dispatch here.
# `AbstractCXImpl` is what makes it one method rather than 1,050 * 1,050 -- see its docstring
# in the generated bindings for why a `Union` over the phantoms is not a substitute.
#
# `Ptr{Cvoid}` is deliberately outside all of this. It is not a `CX` handle, it is what
# `C_NULL` is, and a null carrier is a legal value throughout the layer -- so those
# conversions keep going to Base and keep working. A deliberate crossing between two real
# handles is a checked cast -- `FunctionDecl(d)`, `IfStmt(s)` -- which names the class it is
# asserting and has clang confirm it.

@noinline function _wrong_handle(want, got)
    throw(ArgumentError("expected a $want, got a $got -- these name different clang classes. " *
                        "Use the checked cast for the class you mean if the crossing is intended."))
end

Base.convert(::Type{Ptr{A}}, p::Ptr{B}) where {A<:AbstractCXImpl,B<:AbstractCXImpl} =
    A === B ? p : _wrong_handle(Ptr{A}, Ptr{B})

Base.unsafe_convert(::Type{Ptr{A}}, p::Ptr{B}) where {A<:AbstractCXImpl,B<:AbstractCXImpl} =
    A === B ? p : _wrong_handle(Ptr{A}, Ptr{B})

# An address is not a handle either. Base converts `Union{Int,UInt}` to any `Ptr`, which is the
# one non-pointer route into the same hole; this out-specialises exactly that method. A wider
# `Integer` here would instead be *ambiguous* with it, and any other integer width already has
# no conversion to a pointer at all.
Base.convert(::Type{Ptr{A}}, n::Union{Int,UInt}) where {A<:AbstractCXImpl} =
    _wrong_handle(Ptr{A}, typeof(n))
