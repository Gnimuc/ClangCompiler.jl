"""
    struct Sema <: AbstractSema
Hold a pointer to a `clang::Sema` object.
"""
struct Sema <: AbstractSema
    ptr::CXSema
end

"""
    abstract type AbstractInstantiatingTemplate <: Any
Supertype for `clang::Sema::InstantiatingTemplate` carriers.
"""
abstract type AbstractInstantiatingTemplate end

"""
    struct InstantiatingTemplate <: AbstractInstantiatingTemplate
Hold a pointer to a `clang::Sema::InstantiatingTemplate` object.

The C++ class is an RAII sentinel: constructing it pushes a record onto Sema's
code-synthesis stack and destroying it pops that record, so the handle is an owned heap box
whose `dispose` is what ends the instantiation. Nested sentinels must therefore be disposed
in reverse construction order.
"""
struct InstantiatingTemplate <: AbstractInstantiatingTemplate
    ptr::CXInstantiatingTemplate
end

"""
    abstract type AbstractExpressionEvaluationContextRecord <: Any
Supertype for `clang::Sema::ExpressionEvaluationContextRecord` carriers.
"""
abstract type AbstractExpressionEvaluationContextRecord end

"""
    struct ExpressionEvaluationContextRecord <: AbstractExpressionEvaluationContextRecord
Hold a pointer to a `clang::Sema::ExpressionEvaluationContextRecord` object.

The handle borrows an interior pointer into Sema's expression-evaluation context stack, so
it is invalidated by anything that pushes or pops a context — a parse above all. Read what
you need out of it before parsing, and do not hold it across one. There is no `dispose`.
"""
struct ExpressionEvaluationContextRecord <: AbstractExpressionEvaluationContextRecord
    ptr::CXExpressionEvaluationContextRecord
end

"""
    abstract type AbstractAlignPackInfo <: Any
Supertype for `clang::Sema::AlignPackInfo` carriers.
"""
abstract type AbstractAlignPackInfo end

"""
    struct AlignPackInfo <: AbstractAlignPackInfo
Hold a pointer to a `clang::Sema::AlignPackInfo` object.

The C++ class is the `#pragma pack` / `#pragma align` state of one alignment-stack slot. It
is handed back by value and has no pointer form, so the handle is an owned heap box and
disposal is manual.
"""
struct AlignPackInfo <: AbstractAlignPackInfo
    ptr::CXAlignPackInfo
end

"""
    abstract type AbstractDefaultedFunctionKind <: Any
Supertype for `clang::Sema::DefaultedFunctionKind` carriers.
"""
abstract type AbstractDefaultedFunctionKind end

"""
    struct DefaultedFunctionKind <: AbstractDefaultedFunctionKind
Hold a pointer to a `clang::Sema::DefaultedFunctionKind` object.

The C++ class records which defaultable function a `FunctionDecl` is. It is handed back by
value and has no pointer form, so the handle is an owned heap box and disposal is manual.
"""
struct DefaultedFunctionKind <: AbstractDefaultedFunctionKind
    ptr::CXDefaultedFunctionKind
end

"""
    abstract type AbstractSFINAETrap <: Any
Supertype for `clang::Sema::SFINAETrap` carriers.
"""
abstract type AbstractSFINAETrap end

"""
    struct SFINAETrap <: AbstractSFINAETrap
Hold a pointer to a `clang::Sema::SFINAETrap` object.

The C++ class is an RAII sentinel: constructing it makes Sema a SFINAE context and records
its SFINAE error counter, destroying it restores both, so the handle is an owned heap box
whose `dispose` is what ends the trap. Nested traps must be disposed in reverse
construction order.
"""
struct SFINAETrap <: AbstractSFINAETrap
    ptr::CXSFINAETrap
end
