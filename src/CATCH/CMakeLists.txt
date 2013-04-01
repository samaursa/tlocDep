set(CATCH_PATH    philsquared-Catch-1840929)

#Copy files
file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/${CATCH_PATH}/include/. DESTINATION ${CMAKE_SOURCE_DIR}/include/CATCH/ FILES_MATCHING PATTERN "*.h" PATTERN "*.hpp" PATTERN "*.cpp")
