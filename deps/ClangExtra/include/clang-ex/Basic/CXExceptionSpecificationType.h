#ifndef LLVM_CLANG_C_EXTRA_CXEXCEPTIONSPECIFICATIONTYPE_H
#define LLVM_CLANG_C_EXTRA_CXEXCEPTIONSPECIFICATIONTYPE_H

LLVM_CLANG_C_EXTERN_C_BEGIN

typedef enum CXExceptionSpecificationType {
  CXExceptionSpecificationType_EST_None,
  CXExceptionSpecificationType_EST_DynamicNone,
  CXExceptionSpecificationType_EST_Dynamic,
  CXExceptionSpecificationType_EST_MSAny,
  CXExceptionSpecificationType_EST_NoThrow,
  CXExceptionSpecificationType_EST_BasicNoexcept,
  CXExceptionSpecificationType_EST_DependentNoexcept,
  CXExceptionSpecificationType_EST_NoexceptFalse,
  CXExceptionSpecificationType_EST_NoexceptTrue,
  CXExceptionSpecificationType_EST_Unevaluated,
  CXExceptionSpecificationType_EST_Uninstantiated,
  CXExceptionSpecificationType_EST_Unparsed
} CXExceptionSpecificationType;

LLVM_CLANG_C_EXTERN_C_END

#endif