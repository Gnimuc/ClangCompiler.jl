#include "clang-ex/Basic/CXOperatorKinds.h"
#include "clang/Basic/OperatorKinds.h"
#include "llvm/Support/Errc.h"

const char *clang_getOperatorSpelling(CXOverloadedOperatorKind Operator) {
    return clang::getOperatorSpelling(static_cast<clang::OverloadedOperatorKind>(Operator));
}