"""
    struct AnalysisAction <: AbstractAnalysisAction
Hold a pointer to a `clang::ento::AnalysisAction` object.

The factory hands back the base `CXFrontendAction` handle, so the field is typed there and
every `FrontendAction` accessor applies unchanged.
"""
struct AnalysisAction <: AbstractAnalysisAction
    ptr::CXFrontendAction
end
