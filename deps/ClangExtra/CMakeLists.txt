cmake_minimum_required(VERSION 3.21)

project(ClangExtra LANGUAGES CXX)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC -fno-rtti")

set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)

# Turn on using VS solution folders
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

find_package(LLVM REQUIRED CONFIG)
message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

find_package(Clang REQUIRED CONFIG)
message(STATUS "Found Clang ${Clang_PACKAGE_VERSION}")
message(STATUS "Using ClangConfig.cmake in: ${Clang_DIR}")

add_library(clangex SHARED)
add_subdirectory(lib)
add_subdirectory(include)

set(CLANG_SRC ${CMAKE_CURRENT_SOURCE_DIR}/upstream)

target_include_directories(clangex PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/lib>
    $<BUILD_INTERFACE:${LLVM_INCLUDE_DIRS}>
    $<BUILD_INTERFACE:${Clang_INCLUDE_DIRS}>
    $<BUILD_INTERFACE:${CLANG_SRC}>
    $<INSTALL_INTERFACE:include>)
    
target_compile_features(clangex PRIVATE cxx_std_17)

# A definition whose signature drifts from its extern-C declaration silently
# becomes a mangled C++ overload, so the extern-C symbol never exists. Requiring
# a previous prototype turns that drift into a compile error. GCC's
# -Wmissing-prototypes is C-only; its C++ spelling is -Wmissing-declarations.
target_compile_options(clangex PRIVATE
    $<$<CXX_COMPILER_ID:Clang,AppleClang>:-Werror=missing-prototypes>
    $<$<CXX_COMPILER_ID:GNU>:-Werror=missing-declarations>)

if (WIN32)
    message(STATUS "Windows detected, adding `_CINDEX_LIB_` definition...")
    target_compile_definitions(clangex PUBLIC "_CINDEX_LIB_")
endif(WIN32)

# `off_t` is 64 bits on Darwin and Linux already; on mingw it is `long` -- 32 bits under LLP64 --
# unless this is set. That matters because it is part of the mangled name of every clang function
# taking one, and this shim is compiled here while clang-cpp arrives prebuilt from a different
# toolchain: if the two disagree, the symbol this shim asks for is not the one that library
# exports and the link fails. Setting it makes the type 64 bits on all three, which is also what
# lets the shim spell `int64_t` at its own boundary with no truncation anywhere.
target_compile_definitions(clangex PUBLIC "_FILE_OFFSET_BITS=64")

# The three definitions LLVMConfig.cmake exports in LLVM_DEFINITIONS. LLVM headers use the
# C99 PRI* format macros ("%" PRIu64 in BitstreamReader.h), and glibc before 2.18 defines
# those in C++ only when __STDC_FORMAT_MACROS is set before <inttypes.h> first arrives --
# the x86_64, i686 and powerpc64le BinaryBuilder sysroots (glibc 2.12/2.17) are that old.
# GCC's own <stdint.h> wrapper supplies the LIMIT/CONSTANT pair in C++11 mode, but it has
# no <inttypes.h> counterpart, so only the FORMAT macro ever goes missing; all three are
# spelled here because they are one contract.
target_compile_definitions(clangex PUBLIC "__STDC_CONSTANT_MACROS" "__STDC_FORMAT_MACROS" "__STDC_LIMIT_MACROS")

target_link_libraries(clangex LINK_PUBLIC LLVM clang-cpp)

include(cmake/install_config.cmake)
