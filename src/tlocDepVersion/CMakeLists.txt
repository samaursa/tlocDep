#-----------------------------------------------------------
# Version project
# - This project requires default compiler settings 

set(CMAKE_CXX_FLAGS                 ${CMAKE_CXX_FLAGS_DEFAULT})
set(CMAKE_CXX_FLAGS_DEBUG           ${CMAKE_CXX_FLAGS_DEBUG_DEFAULT})
set(CMAKE_CXX_FLAGS_RELEASE         ${CMAKE_CXX_FLAGS_RELEASE_DEFAULT})
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO  ${CMAKE_CXX_FLAGS_RELWITHDEBINFO_DEFAULT})

# Generate tlocFilePaths.h file
FILE(WRITE ${CMAKE_SOURCE_DIR}/include/tlocDepVersion/tlocVersionFilePath.h "
#define VERSION_FILE_NAME \"${CMAKE_SOURCE_DIR}/src/tlocDepVersion.h\"
")

include_directories(
  ${CMAKE_SOURCE_DIR}/include/
  )

add_executable(
  tlocDepVersion 
  main.cpp
  )

# Run the generated executable after build
add_custom_target(tlocDepVersionTool ALL
  COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CFG_INTDIR}/tlocDepVersion
   DEPENDS tlocDepVersion
 )
