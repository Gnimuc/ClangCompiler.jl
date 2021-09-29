"""
    get_target(x::Parser)
Return the [`TargetInfo`](@ref) in the [`Parser`](@ref).
"""
get_target(x::Parser) = getTargetInfo(x)

"""
    get_sema(x::Parser)
Return the [`Sema`](@ref) in the [`Parser`](@ref).
"""
get_sema(x::Parser) = getActions(x)
