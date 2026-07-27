# FrontendAction
# `clang::FrontendAction` is abstract: every carrier reaching these wrappers is a
# concrete action built by one of the CodeGen factories (`LLVMOnlyAction`,
# `EmitObjAction`, ...) and released through `dispose(::AbstractCodeGenAction)`.

"""
    getCompilerInstance(x::AbstractFrontendAction) -> CompilerInstance
Return the compiler instance the action runs from.

The action must already have one, set by `setCompilerInstance` or by a `BeginSourceFile`
run. `clang::FrontendAction::getCompilerInstance` asserts on a private member that no
accessor publishes, so this precondition is documented rather than checked here
(MARSHALLING.md §13). The instance is borrowed: the action never owns it.
"""
function getCompilerInstance(x::AbstractFrontendAction)
    @check_ptrs x
    return CompilerInstance(clang_FrontendAction_getCompilerInstance(x))
end

"""
    setCompilerInstance(x::AbstractFrontendAction, ci::CompilerInstance)
Register `ci` as the compiler instance the action runs from.

This is not an adoption: the action stores the raw pointer and never frees it, so `ci`
still needs its own `dispose`. It differs from `setInvocation`/`setPreprocessor`, which
rewrap their argument in a fresh `shared_ptr`, and from `setASTConsumer`, which rewraps
it in a `unique_ptr` — after those the argument's own `dispose` is a double free.
"""
function setCompilerInstance(x::AbstractFrontendAction, ci::CompilerInstance)
    @check_ptrs x ci
    return clang_FrontendAction_setCompilerInstance(x, ci)
end

"""
    isCurrentInputEmpty(x::AbstractFrontendAction) -> Bool
Return whether the action has no current input, which is the case outside a
`BeginSourceFile`/`EndSourceFile` pair. This is the gate `isCurrentFileAST` and
`getCurrentFileOrBufferName` assert on.
"""
function isCurrentInputEmpty(x::AbstractFrontendAction)
    @check_ptrs x
    return clang_FrontendAction_isCurrentInputEmpty(x)
end

"""
    isCurrentFileAST(x::AbstractFrontendAction) -> Bool
Return whether the current input is a serialized AST file. The action must have a
current input.
"""
function isCurrentFileAST(x::AbstractFrontendAction)
    @check_ptrs x
    @assert !isCurrentInputEmpty(x) "the action must have a current input"
    return clang_FrontendAction_isCurrentFileAST(x)
end

"""
    getCurrentFileOrBufferName(x::AbstractFrontendAction) -> String
Return the current input's file name, or its buffer identifier when the input is a
memory buffer. The action must have a current input.
"""
function getCurrentFileOrBufferName(x::AbstractFrontendAction)
    @check_ptrs x
    @assert !isCurrentInputEmpty(x) "the action must have a current input"
    return get_string(clang_FrontendAction_getCurrentFileOrBufferName(x))
end

"""
    isModelParsingAction(x::AbstractFrontendAction) -> Bool
Return whether the action is invoked on a model file, that is an incomplete translation
unit relying on type information from another one.
"""
function isModelParsingAction(x::AbstractFrontendAction)
    @check_ptrs x
    return clang_FrontendAction_isModelParsingAction(x)
end

"""
    usesPreprocessorOnly(x::AbstractFrontendAction) -> Bool
Return whether the action only uses the preprocessor. Such an action gets no AST context
and is invalid for AST file inputs.
"""
function usesPreprocessorOnly(x::AbstractFrontendAction)
    @check_ptrs x
    return clang_FrontendAction_usesPreprocessorOnly(x)
end

"""
    getTranslationUnitKind(x::AbstractFrontendAction) -> CXTranslationUnitKind
Return the kind of translation unit an AST-based action handles.
"""
function getTranslationUnitKind(x::AbstractFrontendAction)
    @check_ptrs x
    return clang_FrontendAction_getTranslationUnitKind(x)
end

"""
    hasPCHSupport(x::AbstractFrontendAction) -> Bool
Return whether the action supports use with PCH files.
"""
function hasPCHSupport(x::AbstractFrontendAction)
    @check_ptrs x
    return clang_FrontendAction_hasPCHSupport(x)
end

"""
    hasASTFileSupport(x::AbstractFrontendAction) -> Bool
Return whether the action supports use with AST files.
"""
function hasASTFileSupport(x::AbstractFrontendAction)
    @check_ptrs x
    return clang_FrontendAction_hasASTFileSupport(x)
end

"""
    hasIRSupport(x::AbstractFrontendAction) -> Bool
Return whether the action supports use with IR files.
"""
function hasIRSupport(x::AbstractFrontendAction)
    @check_ptrs x
    return clang_FrontendAction_hasIRSupport(x)
end

"""
    hasCodeCompletionSupport(x::AbstractFrontendAction) -> Bool
Return whether the action supports use with code completion.
"""
function hasCodeCompletionSupport(x::AbstractFrontendAction)
    @check_ptrs x
    return clang_FrontendAction_hasCodeCompletionSupport(x)
end
