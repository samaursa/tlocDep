cmake_minimum_required(VERSION 2.8)

set(TLOC_DEP_NAME "tlocDep" CACHE STRING "You may change the name based on build configurations")
project(${TLOC_DEP_NAME})

set(TLOC_DEP_VERSION 0.1)

#------------------------------------------------------------------------------
# Grab the build path
string(REPLACE "/" ";" p2list "${PROJECT_BINARY_DIR}")
list(REVERSE p2list)
list(GET p2list 0 TLOC_BUILD_FOLDER_NAME)

#------------------------------------------------------------------------------
# CACHE Variables

set(TLOC_DEP_INSTALL_PATH "${CMAKE_SOURCE_DIR}/INSTALL/${TLOC_BUILD_FOLDER_NAME}" CACHE PATH "Install directory for the dependencies")
set(TLOC_DEP_DISTRIBUTION_BUILD FALSE CACHE BOOL "Distribution builds do not increment version numbers upon builds")

#------------------------------------------------------------------------------
# Set binary build directories

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${TLOC_DEP_INSTALL_PATH}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${TLOC_DEP_INSTALL_PATH}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${TLOC_DEP_INSTALL_PATH}/bin)

#------------------------------------------------------------------------------
# Copy the common file for the engine to find
file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/tlocCommon.cmake 
  DESTINATION ${TLOC_DEP_INSTALL_PATH}
  FILE_PERMISSIONS OWNER_READ
  )

#------------------------------------------------------------------------------
# Start preparing the project

include(tlocCommon.cmake)

add_subdirectory(src)
