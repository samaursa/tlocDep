#------------------------------------------------------------------------------
# Platform

set(TLOC_CURRENT_PLATFORM ${CMAKE_SYSTEM_NAME})
message(STATUS "PLATFORM: ${TLOC_CURRENT_PLATFORM}")

if(${TLOC_CURRENT_PLATFORM} STREQUAL "Windows")
  set(TLOC_PLATFORM_WIN32 1)
elseif(${TLOC_CURRENT_PLATFORM} STREQUAL "Darwin")
  # Assume iOS directly - later we will allow switchin between iOS and OSX
  set(TLOC_PLATFORM_IOS 1)
  set(CMAKE_SYSTEM_NAME iOS)
  set(CMAKE_OSX_SYSROOT iphoneos)
else()
  message("PLATFORM: Unsupported!")
  set(TLOC_PLATFORM_UNSUPPORTED 1)
endif()

if (CMAKE_SIZEOF_VOID_P EQUAL 8)
  message(STATUS "ARCHITECTURE: x64")
  set(ARCH_DIR "x64")
else()
  message(STATUS "ARCHITECTURE: x32")
  set(ARCH_DIR "x86")
endif()

#------------------------------------------------------------------------------
# Compiler

set(TLOC_COMPILER_C11 1)

if(MSVC)
  message(STATUS "COMPILER: MSVC")
  set(TLOC_COMPILER_MSVC 1)
  if(MSVC90 OR MSVC80 OR MSVC71 OR MSVC70 OR MSVC60)
    set(TLOC_COMPILER_C11 0)
  endif()
elseif(CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX)
  message(STATUS "COMPILER: GCC Variant")
  set(TLOC_COMPILER_GCC 1)
elseif(APPLE)
  message(STATUS "COMPILER: XCode")
  set(TLOC_COMPILER_XCODE 1)
  # this is needed to ensure XCode looks for libraries with the following
  # postfixes depending on the current build type (only applicaiton for iOS)
  set(CMAKE_XCODE_EFFECTIVE_PLATFORMS "-iphoneos;-iphonesimulator")
else()
  message("COMPILER: Unsupported!")
  set(TLOC_COMPILER_UNSUPPORTED 1)
endif()

if (TLOC_COMPILER_C11)
  message(STATUS "C++11: Supported")
else()
  message(STATUS "C++11: Not supported")
endif()

#------------------------------------------------------------------------------
# Compiler flags

# ---------- Remove MINSIZEREL ----------
set(CMAKE_CONFIGURATION_TYPES Debug Release RelWithDebInfo CACHE TYPE INTERNAL FORCE )

# ---------- Backup the default flags ----------
set(TLOC_CXX_FLAGS_DEFAULT                  ${CMAKE_CXX_FLAGS})
set(TLOC_CXX_FLAGS_DEBUG_DEFAULT            ${CMAKE_CXX_FLAGS_DEBUG})
set(TLOC_CXX_FLAGS_RELEASE_DEFAULT          ${CMAKE_CXX_FLAGS_RELEASE})
set(TLOC_CXX_FLAGS_RELWITHDEBINFO_DEFAULT   ${CMAKE_CXX_FLAGS_RELWITHDEBINFO})

# default definitions
function(tloc_revert_definitions)
  set(CMAKE_CXX_FLAGS_DEBUG          ${CMAKE_CXX_FLAGS_DEBUG_DEFAULT} PARENT_SCOPE)
  set(CMAKE_CXX_FLAGS_RELEASE        ${CMAKE_CXX_FLAGS_RELEASE_DEFAULT} PARENT_SCOPE)
  set(CMAKE_CXX_FLAGS_RELWITHDEBINFO ${CMAKE_CXX_FLAGS_RELWITHDEBINFO_DEFAULT} PARENT_SCOPE)
endfunction()

# common definitions
function(tloc_add_common_definitions)
  # C++03 is currently supported (support will be dropped soon)
  if (NOT TLOC_COMPILER_C11)
    add_definitions(-DTLOC_CXX03)
  endif()

  # visual studio compiler flags
  if (TLOC_COMPILER_MSVC)
    add_definitions(-D_CRT_SECURE_NO_WARNINGS)
  endif()
endfunction()

#------------------------------------------------------------------------------
# Strict compiler flags required by the engine. This disables RTTI and 
# Exceptions handling
function(tloc_add_definitions_strict)
  tloc_revert_definitions()
  tloc_add_common_definitions()

  # visual studio compiler and linker flags
  if (TLOC_COMPILER_MSVC)
    set(CMAKE_CXX_FLAGS_DEBUG           "-DTLOC_DEBUG /Od /Gm /RTC1 /MTd /GR- /W4 /WX /c /Zi /TP" PARENT_SCOPE)
    set(CMAKE_CXX_FLAGS_RELEASE         "-DTLOC_RELEASE /O2 /Ob2 /Oi /Ot /GL /MT /Gy /GR- /W4 /WX /c /Zi /TP" PARENT_SCOPE)
    set(CMAKE_CXX_FLAGS_RELWITHDEBINFO  "-DTLOC_RELEASE_DEBUGINFO /O2 /Ob2 /Oi /Ot /Gm /MT /Gy /GR- /W4 /WX /c /Zi /TP" PARENT_SCOPE)
    set(CMAKE_EXE_LINKER_FLAGS_RELEASE  "${CMAKE_EXE_LINKER_FLAGS_RELEASE} /LTCG")

    #turn off exceptions for all configurations
    string(REGEX REPLACE "/EHsc" "" CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} )
    string(REGEX REPLACE "/GX" "" CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} )

    # cmake bug (adds /Zm1000 when it is not needed): http://public.kitware.com/Bug/view.php?id=13867
    string(REGEX REPLACE "/Zm1000" "" CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} )

    # The above operations are local, make them parent scope
    set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} PARENT_SCOPE)

  elseif (TLOC_COMPILER_XCODE) # xcode compiler and linker flags
    # Note that -gdwarf-2 generates debug symbols (dsym files in dwarf standard)
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -DTLOC_DEBUG -std=c++11 -stdlib=libc++ -fno-exceptions -fno-rtti -Wno-unused-function -g -Wall -Wno-long-long -pedantic" PARENT_SCOPE)
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -DTLOC_RELEASE -std=c++11 -stdlib=libc++ -fno-exceptions -fno-rtti -Wno-unused-function -Wall -Wno-long-long -pedantic" PARENT_SCOPE)
    set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -std=c++11 -stdlib=libc++ -DTLOC_RELEASE_DEBUGINFO -fno-exceptions -fno-rtti -Wno-unused-function -g -Wall -Wno-long-long -pedantic" PARENT_SCOPE)
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -std=c++11 -stdlib=libc++ -framework Foundation -framework OpenGLES -framework AudioToolbox -framework CoreGraphics -framework QuartzCore -framework UIKit -framework OpenAL -Wall -Wno-long-long -pedantic" PARENT_SCOPE)
  else()
    message(WARNING "Unsupported compiler being used. Default compiler settings will be applied")
  endif()
endfunction()

#------------------------------------------------------------------------------
# Loose compiler flags required by projects working with libraries that require
# RTTI and/or Exceptions to be enabled. 
function(tloc_add_definitions)
  tloc_revert_definitions()
  tloc_add_common_definitions()

  # non-strict definictions includes exceptions, rtti and stl
  add_definitions(
    -DTLOC_ENABLE_CPPUNWIND 
    -DTLOC_ENABLE_CPPRTTI 
    -DTLOC_USING_STL 
    )

  if(TLOC_COMPILER_MSVC)
    set(CMAKE_CXX_FLAGS_DEBUG           "/DTLOC_DEBUG /Od /Gm  /EHsc /RTC1 /MTd /GR /W4 /WX /c /Zi /TP" PARENT_SCOPE)
    set(CMAKE_CXX_FLAGS_RELEASE         "/DTLOC_RELEASE /O2 /Ob2 /Oi /Ot /GL /EHsc /MT /Gy /GR /W4 /WX /c /Zi /TP" PARENT_SCOPE)
    set(CMAKE_CXX_FLAGS_RELWITHDEBINFO  "/DTLOC_RELEASE_DEBUGINFO /O2 /Ob2 /Oi /Ot /Gm /EHsc /MT /Gy /GR /W4 /WX /c /Zi /TP" PARENT_SCOPE)

    #turn off exceptions for all configurations
    string(REGEX REPLACE "/Zm1000" "" CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} )

    # The above operations are local, make them parent scope
    set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} PARENT_SCOPE)

  elseif(TLOC_COMPILER_XCODE)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -x objective-c++")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -DTLOC_DEBUG -std=c++11 -stdlib=libc++ -fno-rtti -Wno-unused-function -g" PARENT_SCOPE)
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -DTLOC_RELEASE -std=c++11 -stdlib=libc++ -fno-rtti -Wno-unused-function" PARENT_SCOPE)
    set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -std=c++11 -stdlib=libc++ -DTLOC_RELEASE_DEBUGINFO -fno-rtti -Wno-unused-function -g" PARENT_SCOPE)
  else()
    message("Configuration not applied because compiler is unsupported (or not detected properly)")
  endif()

endfunction()

#------------------------------------------------------------------------------
# Application type

if(APPLE)
  message(STATUS "APP TYPE: Mac OSX Bundle")
  set(TLOC_APP_TYPE MACOSX_BUNDLE)
else()
  message(STATUS "APP TYPE: None")
  set(TLOC_APP_TYPE "")
endif()

#------------------------------------------------------------------------------
# Common variables that are (should be) global

set(USER_PROJECT_TYPE_LIB "lib")
set(USER_PROJECT_TYPE_EXE "exe")

#------------------------------------------------------------------------------
# MISC

# Solution folders for MSVC
set_property(GLOBAL PROPERTY USE_FOLDERS ON)
