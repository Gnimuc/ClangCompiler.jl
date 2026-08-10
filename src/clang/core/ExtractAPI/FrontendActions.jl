"""
    struct ExtractAPIAction <: AbstractExtractAPIAction
Hold a pointer to a `clang::ExtractAPIAction` object.

The factory hands back the base `CXFrontendAction` handle, so the field is typed there and
every `FrontendAction` accessor applies unchanged.
"""
struct ExtractAPIAction <: AbstractExtractAPIAction
    ptr::CXFrontendAction
end
