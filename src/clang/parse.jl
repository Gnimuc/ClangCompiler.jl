"""
    get_target(x::Parser)
Return the [`TargetInfo`](@ref) in the [`Parser`](@ref).
"""
get_target(x::Parser) = getTargetInfo(x)

"""
    getSema(x::Parser)
Return the [`Sema`](@ref) in the [`Parser`](@ref).
"""
getSema(x::Parser) = getActions(x)
