#ifndef LLVM_CLANG_C_EXTRA_CXLAMBDA_H
#define LLVM_CLANG_C_EXTRA_CXLAMBDA_H

LLVM_CLANG_C_EXTERN_C_BEGIN

typedef enum CXLambdaCaptureDefault {
  CXLambdaCaptureDefault_LCD_None,
  CXLambdaCaptureDefault_LCD_ByCopy,
  CXLambdaCaptureDefault_LCD_ByRef
} CXLambdaCaptureDefault;

typedef enum CXLambdaCaptureKind {
  CXLambdaCaptureKind_LCK_This,
  CXLambdaCaptureKind_LCK_StarThis,
  CXLambdaCaptureKind_LCK_ByCopy,
  CXLambdaCaptureKind_LCK_ByRef,
  CXLambdaCaptureKind_LCK_VLAType,
} CXLambdaCaptureKind;

LLVM_CLANG_C_EXTERN_C_END

#endif