using ..ClangCompiler: libclangex
using ..ClangCompiler: CXString, CXStringSet
using LLVM.API: LLVMModuleRef, LLVMOpaqueModule
using LLVM.API: LLVMOpaqueContext, LLVMContextRef
using LLVM.API: LLVMMemoryBufferRef, LLVMGenericValueRef
using LLVM.API: LLVMTypeRef, LLVMOrcLLJITRef

const time_t = Clong
