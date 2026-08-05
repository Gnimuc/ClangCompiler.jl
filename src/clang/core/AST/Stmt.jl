"""
    struct Stmt <: AbstractStmt
Hold a pointer to a `clang::Stmt` object.
"""
struct Stmt <: AbstractStmt
    ptr::CXStmt
end

"""
    struct DeclStmt <: AbstractDeclStmt
Hold a pointer to a `clang::DeclStmt` object.
"""
struct DeclStmt <: AbstractDeclStmt
    ptr::CXDeclStmt
end

"""
    struct NullStmt <: AbstractNullStmt
Hold a pointer to a `clang::NullStmt` object.
"""
struct NullStmt <: AbstractNullStmt
    ptr::CXNullStmt
end

"""
    struct CompoundStmt <: AbstractCompoundStmt
Hold a pointer to a `clang::CompoundStmt` object.
"""
struct CompoundStmt <: AbstractCompoundStmt
    ptr::CXCompoundStmt
end

"""
    struct SwitchCase <: AbstractSwitchCase
Hold a pointer to a `clang::SwitchCase` object.
"""
struct SwitchCase <: AbstractSwitchCase
    ptr::CXSwitchCase
end

"""
    struct CaseStmt <: AbstractCaseStmt
Hold a pointer to a `clang::CaseStmt` object.
"""
struct CaseStmt <: AbstractCaseStmt
    ptr::CXCaseStmt
end

"""
    struct DefaultStmt <: AbstractDefaultStmt
Hold a pointer to a `clang::DefaultStmt` object.
"""
struct DefaultStmt <: AbstractDefaultStmt
    ptr::CXDefaultStmt
end

"""
    struct ValueStmt <: AbstractValueStmt
Hold a pointer to a `clang::ValueStmt` object.
"""
struct ValueStmt <: AbstractValueStmt
    ptr::CXValueStmt
end

"""
    struct LabelStmt <: AbstractLabelStmt
Hold a pointer to a `clang::LabelStmt` object.
"""
struct LabelStmt <: AbstractLabelStmt
    ptr::CXLabelStmt
end

"""
    struct AttributedStmt <: AbstractAttributedStmt
Hold a pointer to a `clang::AttributedStmt` object.
"""
struct AttributedStmt <: AbstractAttributedStmt
    ptr::CXAttributedStmt
end

"""
    struct IfStmt <: AbstractIfStmt
Hold a pointer to a `clang::IfStmt` object.
"""
struct IfStmt <: AbstractIfStmt
    ptr::CXIfStmt
end

"""
    struct SwitchStmt <: AbstractSwitchStmt
Hold a pointer to a `clang::SwitchStmt` object.
"""
struct SwitchStmt <: AbstractSwitchStmt
    ptr::CXSwitchStmt
end

"""
    struct WhileStmt <: AbstractWhileStmt
Hold a pointer to a `clang::WhileStmt` object.
"""
struct WhileStmt <: AbstractWhileStmt
    ptr::CXWhileStmt
end

"""
    struct DoStmt <: AbstractDoStmt
Hold a pointer to a `clang::DoStmt` object.
"""
struct DoStmt <: AbstractDoStmt
    ptr::CXDoStmt
end

"""
    struct ForStmt <: AbstractForStmt
Hold a pointer to a `clang::ForStmt` object.
"""
struct ForStmt <: AbstractForStmt
    ptr::CXForStmt
end

"""
    struct GotoStmt <: AbstractGotoStmt
Hold a pointer to a `clang::GotoStmt` object.
"""
struct GotoStmt <: AbstractGotoStmt
    ptr::CXGotoStmt
end

"""
    struct IndirectGotoStmt <: AbstractIndirectGotoStmt
Hold a pointer to a `clang::IndirectGotoStmt` object.
"""
struct IndirectGotoStmt <: AbstractIndirectGotoStmt
    ptr::CXIndirectGotoStmt
end

"""
    struct ContinueStmt <: AbstractContinueStmt
Hold a pointer to a `clang::ContinueStmt` object.
"""
struct ContinueStmt <: AbstractContinueStmt
    ptr::CXContinueStmt
end

"""
    struct BreakStmt <: AbstractBreakStmt
Hold a pointer to a `clang::BreakStmt` object.
"""
struct BreakStmt <: AbstractBreakStmt
    ptr::CXBreakStmt
end

"""
    struct ReturnStmt <: AbstractReturnStmt
Hold a pointer to a `clang::ReturnStmt` object.
"""
struct ReturnStmt <: AbstractReturnStmt
    ptr::CXReturnStmt
end

"""
    struct AsmStmt <: AbstractAsmStmt
Hold a pointer to a `clang::AsmStmt` object.
"""
struct AsmStmt <: AbstractAsmStmt
    ptr::CXAsmStmt
end

"""
    struct GCCAsmStmt <: AbstractGCCAsmStmt
Hold a pointer to a `clang::GCCAsmStmt` object.
"""
struct GCCAsmStmt <: AbstractGCCAsmStmt
    ptr::CXGCCAsmStmt
end

"""
    struct MSAsmStmt <: AbstractMSAsmStmt
Hold a pointer to a `clang::MSAsmStmt` object.
"""
struct MSAsmStmt <: AbstractMSAsmStmt
    ptr::CXMSAsmStmt
end

"""
    struct SEHExceptStmt <: AbstractSEHExceptStmt
Hold a pointer to a `clang::SEHExceptStmt` object.
"""
struct SEHExceptStmt <: AbstractSEHExceptStmt
    ptr::CXSEHExceptStmt
end

"""
    struct SEHFinallyStmt <: AbstractSEHFinallyStmt
Hold a pointer to a `clang::SEHFinallyStmt` object.
"""
struct SEHFinallyStmt <: AbstractSEHFinallyStmt
    ptr::CXSEHFinallyStmt
end

"""
    struct SEHTryStmt <: AbstractSEHTryStmt
Hold a pointer to a `clang::SEHTryStmt` object.
"""
struct SEHTryStmt <: AbstractSEHTryStmt
    ptr::CXSEHTryStmt
end

"""
    struct SEHLeaveStmt <: AbstractSEHLeaveStmt
Hold a pointer to a `clang::SEHLeaveStmt` object.
"""
struct SEHLeaveStmt <: AbstractSEHLeaveStmt
    ptr::CXSEHLeaveStmt
end

"""
    struct CapturedStmt <: AbstractCapturedStmt
Hold a pointer to a `clang::CapturedStmt` object.
"""
struct CapturedStmt <: AbstractCapturedStmt
    ptr::CXCapturedStmt
end

"""
    struct CapturedStmtCapture <: AbstractCapturedStmtCapture
Hold a pointer to a `clang::CapturedStmt::Capture` object.
"""
struct CapturedStmtCapture <: AbstractCapturedStmtCapture
    ptr::CXCapturedStmtCapture
end

"""
    struct GCCAsmStmtAsmStringPiece <: AbstractGCCAsmStmtAsmStringPiece
Hold a pointer to a `clang::GCCAsmStmt::AsmStringPiece` object.
"""
struct GCCAsmStmtAsmStringPiece <: AbstractGCCAsmStmtAsmStringPiece
    ptr::CXGCCAsmStmtAsmStringPiece
end
