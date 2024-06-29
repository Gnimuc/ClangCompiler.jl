#ifndef LIBCLANGEX_CXVISIBILITY_H
#define LIBCLANGEX_CXVISIBILITY_H

#ifdef __cplusplus
extern "C" {
#endif

typedef enum CXVisibility {
  CXVisibility_HiddenVisibility,
  CXVisibility_ProtectedVisibility,
  CXVisibility_DefaultVisibility
} CXVisibility;

#ifdef __cplusplus
}
#endif
#endif