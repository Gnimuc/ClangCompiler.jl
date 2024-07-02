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

if (WIN32)
    message(STATUS "Windows detected, adding `_CINDEX_LIB_` definition...")
    target_compile_definitions(clangex PUBLIC "_CINDEX_LIB_")
endif(WIN32)

target_link_libraries(clangex LINK_PUBLIC LLVM clang-cpp)

include(cmake/install_config.cmake)
