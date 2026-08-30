# TEMPORARY diagnostic for the Windows CI hang: the test job's `using ClangCompiler`
# produced no output for almost six hours (job 97280293560). Every stage below announces
# itself BEFORE running, so whichever one hangs is named by the last line in the log, and
# the workflow step's own timeout turns the hang into a fast, attributable failure.
using Libdl

stage(msg) = (println(stderr, "== probe: ", msg); flush(stderr))

stage("using Preferences, Clang_jll, libclangex_jll")
using Preferences, Clang_jll, libclangex_jll

stage("using LLVM")
using LLVM

stage("dlopen libclang-cpp: " * Clang_jll.libclang_cpp_path)
Libdl.dlopen(Clang_jll.libclang_cpp_path, RTLD_LAZY | RTLD_DEEPBIND)

libclangex = load_preference(Base.UUID("06fc9500-c033-43bc-8ca2-e20da63309d9"), "libclangex", nothing)
stage("dlopen libclangex: " * repr(libclangex))
libclangex === nothing || Libdl.dlopen(libclangex, RTLD_LAZY | RTLD_DEEPBIND)

stage("using ClangCompiler")
using ClangCompiler

stage("create_interpreter + parse + dispose smoke")
I = ClangCompiler.create_interpreter(String[])
ClangCompiler.parse(I, "int probe_load = 1;")
ClangCompiler.dispose(I)

stage("runtime DLLs actually loaded")
for l in Libdl.dllist()
    occursin(r"winpthread|stdc\+\+|libgcc|clang"i, basename(l)) && println(stderr, "   ", l)
end

stage("all stages passed")
