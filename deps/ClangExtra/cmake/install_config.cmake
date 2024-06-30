# Install CompilationDatabase
set_target_properties(clangex PROPERTIES EXPORT_COMPILE_COMMANDS true)
set(ccmds_json ${CMAKE_CURRENT_BINARY_DIR}/compile_commands.json)
if(EXISTS ${ccmds_json})
    message(STATUS "Found CompilationDatabase File: " ${ccmds_json})
    install(FILES ${ccmds_json} DESTINATION share)
endif()

# Install Binaries
install(TARGETS clangex
        EXPORT ClangExtraTargets
        RUNTIME DESTINATION lib
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib/static
        INCLUDES DESTINATION include/clang-ex)

install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/include/clang-ex/ DESTINATION include/clang-ex
        FILES_MATCHING PATTERN "*.h")

# Install CMake targets
install(EXPORT ClangExtraTargets
        NAMESPACE ClangExtra::
        FILE ClangExtraConfig.cmake
        DESTINATION lib/cmake/ClangExtra)