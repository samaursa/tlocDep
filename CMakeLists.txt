cmake_minimum_required(VERSION 2.8)

project(tlocDep)

set(TLOC_DEP_VERSION 0.1)

if (CMAKE_SIZEOF_VOID_P EQUAL 8)
  set(ARCH_DIR "x64")
else()
  set(ARCH_DIR "x86")
endif()

add_subdirectory(src)
