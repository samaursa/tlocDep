cmake_minimum_required(VERSION 2.8)

project(tlocDep)

set(TLOC_DEP_VERSION 0.1)

if(APPLE)
message(STATUS "Setting system to iOS")
  set(CMAKE_SYSTEM_NAME iOS)
  set(CMAKE_OSX_SYSROOT iphoneos)
endif()

if (CMAKE_SIZEOF_VOID_P EQUAL 8)
  set(ARCH_DIR "x64")
else()
  set(ARCH_DIR "x86")
endif()

add_subdirectory(src)

install(EXPORT tlocDep-targets
  DESTINATION ${PROJECT_BINARY_DIR}/lib/
  CONFIGURATIONS Debug;Release;RelWithDebInfo
  )
