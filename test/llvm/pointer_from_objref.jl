using LLVM, LLVM.IR, LLVM.Build
using LLVM.Interop: generate_llvmcall, current_module
using Test

@testset "pointer_from_objref" begin
    # `generate_llvmcall` with an explicit `Tuple{Any}` rather than `@llvmgenerated`, which
    # would bind a `Type` argument to its value instead of passing the boxed object.
    @generated function pointer_from_objref_derived(x)
        generate_llvmcall(Ptr{Cvoid}, Tuple{Any}, :x) do builder, param
            T_pjlvalue = LLVM.PointerType()
            T_pdjlvalue = LLVM.PointerType(11) #=AS Derived=#
            ft = LLVM.FunctionType(T_pjlvalue, [T_pdjlvalue])
            func = LLVM.Function(current_module(builder), "julia.pointer_from_objref", ft)

            param_derived = addrspacecast!(builder, param, T_pdjlvalue)
            ret = call!(builder, ft, func, [param_derived])
            ptrtoint!(builder, ret, convert(LLVMType, Ptr{Cvoid}))
        end
    end
    x = Ref(10)
    @test pointer_from_objref_derived(x) == pointer_from_objref(x)
end
