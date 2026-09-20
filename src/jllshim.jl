module JLLShim

using Preferences
using Clang_jll
using libclangex_jll
using Libdl

import ..ClangCompiler: libclangex

function __init__()
    if !has_preference("ClangCompiler", "libclangex") && !libclangex_jll.is_available()
        error("libclangex_jll $(pkgversion(libclangex_jll)) has no build for LLVM " *
              "$(Base.libllvm_version.major) on this platform. ClangCompiler binds the Clang that " *
              "matches the LLVM of the running Julia, so it needs a libclangex built against it: " *
              "either a libclangex_jll release that has one, or a local build, which " *
              "`julia --project=deps deps/build_local.jl` makes and records in the `libclangex` " *
              "preference.")
    end
    if Clang_jll.libclang_cpp_handle == C_NULL
        global libclang_cpp_handle = Libdl.dlopen(Clang_jll.libclang_cpp_path, RTLD_LAZY | RTLD_DEEPBIND)
        if has_preference("ClangCompiler", "libclangex")
            Libdl.dlopen(libclangex, RTLD_LAZY | RTLD_DEEPBIND)
        else
            global libclangex_handle = Libdl.dlopen(libclangex_jll.libclangex_path, RTLD_LAZY | RTLD_DEEPBIND)
        end
    end
    # Promote every loaded libclang-cpp to the global namespace: the ORC JIT
    # resolves the interpreter's value-capture runtime
    # (__clang_Interpreter_SetValueNoAlloc and friends) through the process
    # symbol table, and a LOCAL/DEEPBIND load hides those symbols from that
    # lookup on Linux. Re-dlopening an already-loaded library by path with
    # RTLD_GLOBAL only promotes it — a no-op where the symbols are already
    # visible.
    if Sys.isunix()
        # a locally-built libclangex links the LLVM_full artifact's
        # libclang-cpp, which only appears in dllist() once libclangex loads
        Libdl.dlopen(libclangex, RTLD_LAZY | RTLD_DEEPBIND)
        for l in Libdl.dllist()
            if occursin("libclang-cpp", basename(l))
                Libdl.dlopen(l, RTLD_LAZY | RTLD_GLOBAL)
            end
        end
    end
end

end
