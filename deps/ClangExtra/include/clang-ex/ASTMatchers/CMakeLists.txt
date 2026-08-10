target_sources(clangex PRIVATE ${CMAKE_CURRENT_LIST_DIR}/CXASTMatchFinder.h)
target_sources(clangex PRIVATE ${CMAKE_CURRENT_LIST_DIR}/CXASTMatchers.h)
target_sources(clangex PRIVATE ${CMAKE_CURRENT_LIST_DIR}/CXASTMatchersInternal.h)

add_subdirectory(Dynamic)
