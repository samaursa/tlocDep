cmake_minimum_required(VERSION 2.8)

#------------------------------------------------------------------------------
# Start CMake project
set(TLOC_DEP_NAME "tlocDep" CACHE STRING "You may change the name based on build configurations")
project(${TLOC_DEP_NAME})
include(tlocCommon.cmake)

#------------------------------------------------------------------------------
# Over-ride names if not already set by user
tloc_get_leaf_folder_name(${CMAKE_BINARY_DIR} TLOC_BUILD_FOLDER_NAME)
if(${TLOC_DEP_NAME} STREQUAL "tlocDep")
  set(TLOC_DEP_NAME "tlocDep_${TLOC_BUILD_FOLDER_NAME}" CACHE STRING "You may change the name based on build configurations" FORCE)
  project(${TLOC_DEP_NAME})
endif()

set(TLOC_DEP_VERSION 0.1)

#------------------------------------------------------------------------------
# CACHE Variables

set(TLOC_DEP_INSTALL_PATH "${CMAKE_SOURCE_DIR}/INSTALL/${TLOC_BUILD_FOLDER_NAME}" CACHE PATH "Install directory for the dependencies")

#------------------------------------------------------------------------------
# Set binary build directories

foreach (OUTPUTCONFIG ${CMAKE_CONFIGURATION_TYPES})
  string (TOUPPER ${OUTPUTCONFIG} OUTPUTCONFIG)
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${TLOC_DEP_INSTALL_PATH}/lib/${CMAKE_CFG_INTDIR})
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${TLOC_DEP_INSTALL_PATH}/lib/${CMAKE_CFG_INTDIR})
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${TLOC_DEP_INSTALL_PATH}/bin/${CMAKE_CFG_INTDIR})
endforeach (OUTPUTCONFIG ${CMAKE_CONFIGURATION_TYPES})

#------------------------------------------------------------------------------
# Copy the common file for the engine to find
file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/tlocCommon.cmake 
  DESTINATION ${TLOC_DEP_INSTALL_PATH}
  FILE_PERMISSIONS OWNER_READ
  )

#------------------------------------------------------------------------------
# Start preparing the project

add_subdirectory(src)
