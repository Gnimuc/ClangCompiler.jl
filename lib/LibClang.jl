function clang_getCString(string)
    ccall((:clang_getCString, libclang), Ptr{Cchar}, (CXString,), string)
end

function clang_disposeString(string)
    ccall((:clang_disposeString, libclang), Cvoid, (CXString,), string)
end

function clang_disposeStringSet(set)
    ccall((:clang_disposeStringSet, libclang), Cvoid, (Ptr{CXStringSet},), set)
end
