# OperatorKinds
function getOperatorSpelling(op::CXOverloadedOperatorKind)
    return unsafe_string(clang_getOperatorSpelling(op))
end
