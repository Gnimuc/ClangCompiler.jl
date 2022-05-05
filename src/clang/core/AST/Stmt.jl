"""
    struct Stmt <: AbstractStmt
Hold a pointer to a `clang::Stmt` object.
"""
struct Stmt <: AbstractStmt
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::Stmt) = x.ptr
Base.cconvert(::Type{CXStmt}, x::Stmt) = x

"""
    struct DeclStmt <: AbstractStmt
Hold a pointer to a `clang::DeclStmt` object.
"""
struct DeclStmt <: AbstractStmt
    ptr::CXDeclStmt
end

Base.unsafe_convert(::Type{CXDeclStmt}, x::DeclStmt) = x.ptr
Base.cconvert(::Type{CXDeclStmt}, x::DeclStmt) = x

"""
    struct NullStmt <: AbstractStmt
Hold a pointer to a `clang::NullStmt` object.
"""
struct NullStmt <: AbstractStmt
    ptr::CXNullStmt
end

Base.unsafe_convert(::Type{CXNullStmt}, x::NullStmt) = x.ptr
Base.cconvert(::Type{CXNullStmt}, x::NullStmt) = x

"""
    struct CompoundStmt <: AbstractStmt
Hold a pointer to a `clang::CompoundStmt` object.
"""
struct CompoundStmt <: AbstractStmt
    ptr::CXCompoundStmt
end

Base.unsafe_convert(::Type{CXCompoundStmt}, x::CompoundStmt) = x.ptr
Base.cconvert(::Type{CXCompoundStmt}, x::CompoundStmt) = x

"""
    struct SwitchCase <: AbstractSwitchCase
Hold a pointer to a `clang::SwitchCase` object.
"""
struct SwitchCase <: AbstractSwitchCase
    ptr::CXSwitchCase
end

Base.unsafe_convert(::Type{CXSwitchCase}, x::SwitchCase) = x.ptr
Base.cconvert(::Type{CXSwitchCase}, x::SwitchCase) = x

"""
    struct CaseStmt <: AbstractSwitchCase
Hold a pointer to a `clang::CaseStmt` object.
"""
struct CaseStmt <: AbstractSwitchCase
    ptr::CXCaseStmt
end

Base.unsafe_convert(::Type{CXCaseStmt}, x::CaseStmt) = x.ptr
Base.cconvert(::Type{CXCaseStmt}, x::CaseStmt) = x

"""
    struct DefaultStmt <: AbstractSwitchCase
Hold a pointer to a `clang::DefaultStmt` object.
"""
struct DefaultStmt <: AbstractSwitchCase
    ptr::CXDefaultStmt
end

Base.unsafe_convert(::Type{CXDefaultStmt}, x::DefaultStmt) = x.ptr
Base.cconvert(::Type{CXDefaultStmt}, x::DefaultStmt) = x

"""
    struct ValueStmt <: AbstractValueStmt
Hold a pointer to a `clang::ValueStmt` object.
"""
struct ValueStmt <: AbstractValueStmt
    ptr::CXValueStmt
end

Base.unsafe_convert(::Type{CXValueStmt}, x::ValueStmt) = x.ptr
Base.cconvert(::Type{CXValueStmt}, x::ValueStmt) = x

"""
    struct LabelStmt <: AbstractValueStmt
Hold a pointer to a `clang::LabelStmt` object.
"""
struct LabelStmt <: AbstractValueStmt
    ptr::CXLabelStmt
end

Base.unsafe_convert(::Type{CXLabelStmt}, x::LabelStmt) = x.ptr
Base.cconvert(::Type{CXLabelStmt}, x::LabelStmt) = x

"""
    struct AttributedStmt <: AbstractValueStmt
Hold a pointer to a `clang::AttributedStmt` object.
"""
struct AttributedStmt <: AbstractValueStmt
    ptr::CXAttributedStmt
end

Base.unsafe_convert(::Type{CXAttributedStmt}, x::AttributedStmt) = x.ptr
Base.cconvert(::Type{CXAttributedStmt}, x::AttributedStmt) = x

"""
    struct IfStmt <: AbstractStmt
Hold a pointer to a `clang::IfStmt` object.
"""
struct IfStmt <: AbstractStmt
    ptr::CXIfStmt
end

Base.unsafe_convert(::Type{CXIfStmt}, x::IfStmt) = x.ptr
Base.cconvert(::Type{CXIfStmt}, x::IfStmt) = x

"""
    struct SwitchStmt <: AbstractStmt
Hold a pointer to a `clang::SwitchStmt` object.
"""
struct SwitchStmt <: AbstractStmt
    ptr::CXSwitchStmt
end

Base.unsafe_convert(::Type{CXSwitchStmt}, x::SwitchStmt) = x.ptr
Base.cconvert(::Type{CXSwitchStmt}, x::SwitchStmt) = x

"""
    struct WhileStmt <: AbstractStmt
Hold a pointer to a `clang::WhileStmt` object.
"""
struct WhileStmt <: AbstractStmt
    ptr::CXWhileStmt
end

Base.unsafe_convert(::Type{CXWhileStmt}, x::WhileStmt) = x.ptr
Base.cconvert(::Type{CXWhileStmt}, x::WhileStmt) = x

"""
    struct DoStmt <: AbstractStmt
Hold a pointer to a `clang::DoStmt` object.
"""
struct DoStmt <: AbstractStmt
    ptr::CXDoStmt
end

Base.unsafe_convert(::Type{CXDoStmt}, x::DoStmt) = x.ptr
Base.cconvert(::Type{CXDoStmt}, x::DoStmt) = x

"""
    struct ForStmt <: AbstractStmt
Hold a pointer to a `clang::ForStmt` object.
"""
struct ForStmt <: AbstractStmt
    ptr::CXForStmt
end

Base.unsafe_convert(::Type{CXForStmt}, x::ForStmt) = x.ptr
Base.cconvert(::Type{CXForStmt}, x::ForStmt) = x

"""
    struct GotoStmt <: AbstractStmt
Hold a pointer to a `clang::GotoStmt` object.
"""
struct GotoStmt <: AbstractStmt
    ptr::CXGotoStmt
end

Base.unsafe_convert(::Type{CXGotoStmt}, x::GotoStmt) = x.ptr
Base.cconvert(::Type{CXGotoStmt}, x::GotoStmt) = x

"""
    struct IndirectGotoStmt <: AbstractStmt
Hold a pointer to a `clang::IndirectGotoStmt` object.
"""
struct IndirectGotoStmt <: AbstractStmt
    ptr::CXIndirectGotoStmt
end

Base.unsafe_convert(::Type{CXIndirectGotoStmt}, x::IndirectGotoStmt) = x.ptr
Base.cconvert(::Type{CXIndirectGotoStmt}, x::IndirectGotoStmt) = x

"""
    struct ContinueStmt <: AbstractStmt
Hold a pointer to a `clang::ContinueStmt` object.
"""
struct ContinueStmt <: AbstractStmt
    ptr::CXContinueStmt
end

Base.unsafe_convert(::Type{CXContinueStmt}, x::ContinueStmt) = x.ptr
Base.cconvert(::Type{CXContinueStmt}, x::ContinueStmt) = x

"""
    struct BreakStmt <: AbstractStmt
Hold a pointer to a `clang::BreakStmt` object.
"""
struct BreakStmt <: AbstractStmt
    ptr::CXBreakStmt
end

Base.unsafe_convert(::Type{CXBreakStmt}, x::BreakStmt) = x.ptr
Base.cconvert(::Type{CXBreakStmt}, x::BreakStmt) = x

"""
    struct ReturnStmt <: AbstractStmt
Hold a pointer to a `clang::ReturnStmt` object.
"""
struct ReturnStmt <: AbstractStmt
    ptr::CXReturnStmt
end

Base.unsafe_convert(::Type{CXReturnStmt}, x::ReturnStmt) = x.ptr
Base.cconvert(::Type{CXReturnStmt}, x::ReturnStmt) = x

"""
    struct AsmStmt <: AbstractAsmStmt
Hold a pointer to a `clang::AsmStmt` object.
"""
struct AsmStmt <: AbstractAsmStmt
    ptr::CXAsmStmt
end

Base.unsafe_convert(::Type{CXAsmStmt}, x::AsmStmt) = x.ptr
Base.cconvert(::Type{CXAsmStmt}, x::AsmStmt) = x

"""
    struct GCCAsmStmt <: AbstractAsmStmt
Hold a pointer to a `clang::GCCAsmStmt` object.
"""
struct GCCAsmStmt <: AbstractAsmStmt
    ptr::CXGCCAsmStmt
end

Base.unsafe_convert(::Type{CXGCCAsmStmt}, x::GCCAsmStmt) = x.ptr
Base.cconvert(::Type{CXGCCAsmStmt}, x::GCCAsmStmt) = x

"""
    struct MSAsmStmt <: AbstractAsmStmt
Hold a pointer to a `clang::MSAsmStmt` object.
"""
struct MSAsmStmt <: AbstractAsmStmt
    ptr::CXMSAsmStmt
end

Base.unsafe_convert(::Type{CXMSAsmStmt}, x::MSAsmStmt) = x.ptr
Base.cconvert(::Type{CXMSAsmStmt}, x::MSAsmStmt) = x

"""
    struct SEHExceptStmt <: AbstractStmt
Hold a pointer to a `clang::SEHExceptStmt` object.
"""
struct SEHExceptStmt <: AbstractStmt
    ptr::CXSEHExceptStmt
end

Base.unsafe_convert(::Type{CXSEHExceptStmt}, x::SEHExceptStmt) = x.ptr
Base.cconvert(::Type{CXSEHExceptStmt}, x::SEHExceptStmt) = x

"""
    struct SEHFinallyStmt <: AbstractStmt
Hold a pointer to a `clang::SEHFinallyStmt` object.
"""
struct SEHFinallyStmt <: AbstractStmt
    ptr::CXSEHFinallyStmt
end

Base.unsafe_convert(::Type{CXSEHFinallyStmt}, x::SEHFinallyStmt) = x.ptr
Base.cconvert(::Type{CXSEHFinallyStmt}, x::SEHFinallyStmt) = x

"""
    struct SEHTryStmt <: AbstractStmt
Hold a pointer to a `clang::SEHTryStmt` object.
"""
struct SEHTryStmt <: AbstractStmt
    ptr::CXSEHTryStmt
end

Base.unsafe_convert(::Type{CXSEHTryStmt}, x::SEHTryStmt) = x.ptr
Base.cconvert(::Type{CXSEHTryStmt}, x::SEHTryStmt) = x

"""
    struct SEHLeaveStmt <: AbstractStmt
Hold a pointer to a `clang::SEHLeaveStmt` object.
"""
struct SEHLeaveStmt <: AbstractStmt
    ptr::CXSEHLeaveStmt
end

Base.unsafe_convert(::Type{CXSEHLeaveStmt}, x::SEHLeaveStmt) = x.ptr
Base.cconvert(::Type{CXSEHLeaveStmt}, x::SEHLeaveStmt) = x

"""
    struct CapturedStmt <: AbstractStmt
Hold a pointer to a `clang::CapturedStmt` object.
"""
struct CapturedStmt <: AbstractStmt
    ptr::CXCapturedStmt
end

Base.unsafe_convert(::Type{CXCapturedStmt}, x::CapturedStmt) = x.ptr
Base.cconvert(::Type{CXCapturedStmt}, x::CapturedStmt) = x
