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

include(tlocCommon.cmake)

add_subdirectory(src)
