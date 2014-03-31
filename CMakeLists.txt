cmake_minimum_required(VERSION 2.8)

project(tlocDep)

set(TLOC_DEP_VERSION 0.1)

#------------------------------------------------------------------------------
# CACHE Variables

#set(TLOC_ENGINE_PATH ${CMAKE_SOURCE_DIR} CACHE PATH "The root folder of this repository. You do not need to edit this manually")

#------------------------------------------------------------------------------
# Start preparing the project

include(tlocCommon.cmake)

add_subdirectory(src)
