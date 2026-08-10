target_sources(clangex PRIVATE ${CMAKE_CURRENT_LIST_DIR}/CXASTMatchFinder.cpp)
target_sources(clangex PRIVATE ${CMAKE_CURRENT_LIST_DIR}/CXASTMatchers.cpp)
target_sources(clangex PRIVATE ${CMAKE_CURRENT_LIST_DIR}/CXASTMatchersInternal.cpp)

add_subdirectory(Dynamic)
