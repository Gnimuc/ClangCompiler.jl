lookup_function(mod::LLVM.Module, func_name::String) = mod.functions[func_name]

lookup_function(ee::LLVM.ExecutionEngine, func_name::String) = ee.functions[func_name]

link(lib::AbstractString) = LLVM.load_library_permanently(lib)

link_crt(ee::LLVM.ExecutionEngine) = LLVM.run_static_constructors!(ee)

function get_buffer(x::String, name="", copy=true)
    data = unsafe_wrap(Vector{UInt8}, x)
    return LLVM.MemoryBuffer(data, name, copy)
end
