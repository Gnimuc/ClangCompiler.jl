using ClangCompiler
using ClangCompiler.LLVM
using ClangCompiler.LibClang
using ClangCompiler.LibClangEx
using ClangCompiler.JLLEnvs

src = joinpath(@__DIR__, "main.cpp")

args = JLLEnvs.get_default_args()
push!(args, "-nostdinc", "-nostdinc++", "-std=c++11")

instance = clang_CompilerInstance_create(C_NULL)

clang_CompilerInstance_createDiagnostics(instance, C_NULL, true)
@assert clang_CompilerInstance_hasDiagnostics(instance) == true
diag = clang_CompilerInstance_getDiagnostics(instance)

invok = clang_CompilerInvocation_createFromCommandLine(src, args, length(args), diag, C_NULL)
clang_CompilerInstance_setInvocation(instance, invok)
clang_CompilerInstance_setTarget(instance)

clang_CompilerInstance_createFileManager(instance)
@assert clang_CompilerInstance_hasFileManager(instance) == true

file_mgr = clang_CompilerInstance_getFileManager(instance)
clang_CompilerInstance_createSourceManager(instance, file_mgr)
@assert clang_CompilerInstance_hasSourceManager(instance) == true
src_mgr = clang_CompilerInstance_getSourceManager(instance)

clang_FileManager_PrintStats(file_mgr)

file_ref = clang_FileManager_getFileRef(file_mgr, src, true, true)
file_entry = clang_FileEntryRef_getFileEntry(file_ref)

@assert !clang_FileEntry_isNamedPipe(file_entry)
clang_SourceManager_createAndSetMainFileID(src_mgr, file_entry)

clang_FileEntryRef_dispose(file_ref)
@assert clang_SourceManager_getMainFileID_HashValue(src_mgr) == 1
clang_FileManager_PrintStats(file_mgr)

clang_CompilerInstance_createPreprocessor(instance)

clang_CompilerInstance_createASTContext(instance)

# llvm_ctx = LLVM.Context()
llvm_ctx = GlobalContext()

cg = clang_CreateLLVMCodeGen(instance, llvm_ctx.ref, "test")

clang_CompilerInstance_setCodeGenerator(instance, cg)

clang_CompilerInstance_createSema(instance)

sema = clang_CompilerInstance_getSema(instance)

clang_ParseAST(sema, false, false)

m = clang_CodeGenerator_getLLVMModule(cg)

LLVM.API.LLVMGetNamedFunction(m, "mycppfunction")

clang_CompilerInstance_dispose(instance)
clang_disposeIndex(idx)
