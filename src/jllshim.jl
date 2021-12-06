module JLLShim
    using Clang_jll
    using libclangex_jll
    using Libdl

    function __init__()
        if Clang_jll.libclang_cpp_handle == C_NULL
            global libclang_cpp_handle = Libdl.dlopen(Clang_jll.libclang_cpp_path, RTLD_LAZY | RTLD_DEEPBIND)
            global libclangex_handle = Libdl.dlopen(libclangex_jll.libclangex_path, RTLD_LAZY | RTLD_DEEPBIND) 
        end
    end
end