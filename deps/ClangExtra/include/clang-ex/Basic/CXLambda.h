#ifndef LIBCLANGEX_CXLAMBDA_H
#define LIBCLANGEX_CXLAMBDA_H

#ifdef __cplusplus
extern "C" {
#endif

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

#ifdef __cplusplus
}
#endif
#endif