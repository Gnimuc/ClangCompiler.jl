IncrementalCompilerBuilder() = IncrementalCompilerBuilder(clang_IncrementalCompilerBuilder_create())

dispose(x::IncrementalCompilerBuilder) = clang_IncrementalCompilerBuilder_dispose(x)

function SetCompilerArgs(x::AbstractIncrementalCompilerBuilder, args::AbstractVector{<:String})
    @check_ptrs x
    return clang_IncrementalCompilerBuilder_SetCompilerArgs(x, args, length(args))
end

function CreateCpp(x::AbstractIncrementalCompilerBuilder)
    @check_ptrs x
    return CompilerInstance(clang_IncrementalCompilerBuilder_CreateCpp(x))
end

function SetOffloadArch(x::AbstractIncrementalCompilerBuilder, arch::AbstractString)
    @check_ptrs x
    return clang_IncrementalCompilerBuilder_SetOffloadArch(x, arch)
end

function SetCudaSDK(x::AbstractIncrementalCompilerBuilder, path::AbstractString)
    @check_ptrs x
    return clang_IncrementalCompilerBuilder_SetCudaSDK(x, path)
end

"""
    CreateCudaHost(x::AbstractIncrementalCompilerBuilder) -> CompilerInstance
Create a compiler instance configured for CUDA host compilation. The result holds a NULL
pointer on failure. This function allocates and one should call `dispose` to release the
resources after using this object (creating an `Interpreter` from it transfers ownership
instead).
"""
function CreateCudaHost(x::AbstractIncrementalCompilerBuilder)
    @check_ptrs x
    return CompilerInstance(clang_IncrementalCompilerBuilder_CreateCudaHost(x))
end

"""
    CreateCudaDevice(x::AbstractIncrementalCompilerBuilder) -> CompilerInstance
Create a compiler instance configured for CUDA device compilation. The result holds a NULL
pointer on failure. This function allocates and one should call `dispose` to release the
resources after using this object (creating an `Interpreter` from it transfers ownership
instead).
"""
function CreateCudaDevice(x::AbstractIncrementalCompilerBuilder)
    @check_ptrs x
    return CompilerInstance(clang_IncrementalCompilerBuilder_CreateCudaDevice(x))
end
function Interpreter(x::AbstractCompilerInstance)
    @check_ptrs x
    return Interpreter(clang_Interpreter_create(x))
end

function createWithCUDA(ci::AbstractCompilerInstance, dci::AbstractCompilerInstance)
    @check_ptrs ci dci
    return Interpreter(clang_Interpreter_createWithCUDA(ci, dci))
end

dispose(x::Interpreter) = clang_Interpreter_dispose(x)

function getCompilerInstance(x::AbstractInterpreter)
    @check_ptrs x
    return CompilerInstance(clang_Interpreter_getCompilerInstance(x))
end

function getExecutionEngine(x::AbstractInterpreter)
    @check_ptrs x
    return LLVM.LLJIT(clang_Interpreter_getExecutionEngine(x))
end

"""
    undo(x::AbstractInterpreter, n::Integer=1) -> String
Discard the last `n` increments and return the empty string.

Undoing more increments than were parsed is a failure the caller has to detect rather than a
precondition this layer can check — the count clang tracks is not exposed — so the returned
string carries clang's message in that case instead of the process aborting.
"""
function undo(x::AbstractInterpreter, n::Integer=1)
    @check_ptrs x
    return get_string(clang_Interpreter_Undo(x, n))
end

function getSymbolAddress(x::AbstractInterpreter, name::AbstractString)
    @check_ptrs x
    return clang_Interpreter_getSymbolAddress(x, name)
end

function getSymbolAddressFromLinkerName(x::AbstractInterpreter, name::AbstractString)
    @check_ptrs x
    return clang_Interpreter_getSymbolAddressFromLinkerName(x, name)
end

"""
    getSymbolAddress(x::AbstractInterpreter, d::AbstractNamedDecl) -> UInt64
Return the JIT address of `d`, resolved through the mangled name codegen itself recorded for
it rather than one recomputed here.

`0` means the symbol does not exist yet: a declaration has no address until the increment
defining it has been executed. Constructors and destructors have several emitted bodies and
so are rejected by clang's `GlobalDecl` — use the `CXCXXCtorType`/`CXCXXDtorType` methods
below for those.
"""
function getSymbolAddress(x::AbstractInterpreter, d::AbstractNamedDecl)
    @check_ptrs x d
    @assert !isCXXConstructorDecl(d) && !isCXXDestructorDecl(d) "a constructor or destructor has several mangled bodies; pass its CXCXXCtorType/CXCXXDtorType"
    return clang_Interpreter_getSymbolAddressFromDecl(x, d)
end

"""
    getSymbolAddress(x::AbstractInterpreter, d::AbstractCXXConstructorDecl, kind::CXCXXCtorType) -> UInt64
Return the JIT address of the constructor body `kind` selects. `0` when it has not been
emitted yet.
"""
function getSymbolAddress(x::AbstractInterpreter, d::AbstractCXXConstructorDecl, kind::CXCXXCtorType)
    @check_ptrs x d
    return clang_Interpreter_getSymbolAddressFromCtorDecl(x, d, kind)
end

"""
    getSymbolAddress(x::AbstractInterpreter, d::AbstractCXXDestructorDecl, kind::CXCXXDtorType) -> UInt64
Return the JIT address of the destructor body `kind` selects. `0` when it has not been
emitted yet.
"""
function getSymbolAddress(x::AbstractInterpreter, d::AbstractCXXDestructorDecl, kind::CXCXXDtorType)
    @check_ptrs x d
    return clang_Interpreter_getSymbolAddressFromDtorDecl(x, d, kind)
end

function getCodeGen(x::AbstractInterpreter)
    @check_ptrs x
    return CodeGenerator(clang_Interpreter_getCodeGen(x))
end

function getParser(x::AbstractInterpreter)
    @check_ptrs x
    return Parser(clang_Interpreter_getParser(x))
end

function Parse(x::AbstractInterpreter, code::AbstractString)
    @check_ptrs x
    return PartialTranslationUnit(clang_Interpreter_Parse(x, code))
end

"""
    Execute(x::AbstractInterpreter, ptu::PartialTranslationUnit) -> String
Run the increment `ptu` names and return the empty string; on failure, return clang's error
message rather than only logging it.

Execution moves the increment's IR module into the JIT, so
[`getModule`](@ref) on the same `ptu` answers `NULL` afterwards.
"""
function Execute(x::AbstractInterpreter, ptu::PartialTranslationUnit)
    @check_ptrs x ptu
    return get_string(clang_Interpreter_Execute(x, ptu))
end

"""
    ParseAndExecute(x::AbstractInterpreter, code::AbstractString) -> Value
Parse and run `code`, returning the `Value` it evaluated to.

A failure is reported through the value: the returned `Value` holds nothing and
[`ParseAndExecuteChecked`](@ref) is the form that hands back clang's message.
"""
function ParseAndExecute(x::AbstractInterpreter, code::AbstractString)
    @check_ptrs x
    v = create_value()
    get_string(clang_Interpreter_ParseAndExecute(x, code, v))
    return v
end

"""
    ParseAndExecuteChecked(x::AbstractInterpreter, code::AbstractString) -> (Value, String)
Parse and run `code`, returning both the resulting `Value` and clang's error message — empty
when the input ran.
"""
function ParseAndExecuteChecked(x::AbstractInterpreter, code::AbstractString)
    @check_ptrs x
    v = create_value()
    err = get_string(clang_Interpreter_ParseAndExecute(x, code, v))
    return v, err
end

"""
    CompileDtorCall(x::AbstractInterpreter, rd::AbstractCXXRecordDecl) -> UInt64
Compile the destructor call for the record and return its executor address. Records whose
destructor is irrelevant (trivial) yield 0, as do failures (logged to stderr).
"""
function CompileDtorCall(x::AbstractInterpreter, rd::AbstractCXXRecordDecl)
    @check_ptrs x rd
    return clang_Interpreter_CompileDtorCall(x, rd)
end

"""
    LoadDynamicLibrary(x::AbstractInterpreter, name::AbstractString) -> String
Load a shared library into the JIT's search path and return the empty string; on failure,
return the dynamic loader's message.
"""
function LoadDynamicLibrary(x::AbstractInterpreter, name::AbstractString)
    @check_ptrs x
    return get_string(clang_Interpreter_LoadDynamicLibrary(x, name))
end

"""
    getASTContext(x::AbstractInterpreter) -> ASTContext
Return the interpreter's `ASTContext`, borrowed — never `dispose` it through this carrier.

This is the same context [`getASTContext`](@ref) reaches through the compiler instance, which
is what clang's own body does; it is here so the context can be had without naming the
instance.
"""
function getASTContext(x::AbstractInterpreter)
    @check_ptrs x
    return ASTContext(clang_Interpreter_getASTContext(x))
end
