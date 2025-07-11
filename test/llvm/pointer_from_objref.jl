using LLVM
using Test

@testset "pointer_from_objref" begin
    @generated function pointer_from_objref_derived(x)
        @dispose ctx=Context() begin
            T_jlvalue = LLVM.StructType(LLVMType[])
            T_pjlvalue = LLVM.PointerType(T_jlvalue, 0)
            T_prjlvalue = convert(LLVMType, Any; allow_boxed=true)
            T_pdjlvalue = LLVM.PointerType(T_jlvalue, 11)  #=AS Drived=#
            rettype = convert(LLVMType, Ptr{Cvoid})
            llvm_f, _ = LLVM.Interop.create_function(rettype, [T_prjlvalue])
            mod = LLVM.parent(llvm_f)
            func = LLVM.Function(mod, "julia.pointer_from_objref", LLVM.FunctionType(T_pjlvalue, [T_pdjlvalue]))

            @dispose builder=IRBuilder() begin
                entry = BasicBlock(llvm_f, "entry")
                position!(builder, entry)
                param = only(parameters(llvm_f))
                param_drived = addrspacecast!(builder, param, T_pdjlvalue)
                ret = call!(builder, func, [param_drived])
                i64 = ptrtoint!(builder, ret, rettype)
                ret!(builder, i64)
            end

            call_function(llvm_f, Ptr{Cvoid}, Tuple{Any}, :x)
        end
    end
    x = Ref(10)
    @test pointer_from_objref_derived(x) == pointer_from_objref(x)
end
