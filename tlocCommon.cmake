#******************************************************************************
#******************************************************************************
# Useful functions 
#******************************************************************************
#******************************************************************************

#------------------------------------------------------------------------------
# get leaf folder of path

function(tloc_get_leaf_folder_name full_path name_out)
  string(REPLACE "/" ";" p2list "${full_path}")
  list(REVERSE p2list)
  list(GET p2list 0 leaf_folder)
  set(${name_out} ${leaf_folder} PARENT_SCOPE)
endfunction()


#******************************************************************************
#******************************************************************************
# Platform
#******************************************************************************
#******************************************************************************

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
  set(TLOC_ARCHITECTURE "x64")
else()
  message(STATUS "ARCHITECTURE: x32")
  set(ARCH_DIR "x86")
  set(TLOC_ARCHITECTURE "x86")
endif()

# This little macro lets you set any XCode specific property
macro (set_xcode_property TARGET XCODE_PROPERTY XCODE_VALUE)
	set_property (TARGET ${TARGET} PROPERTY XCODE_ATTRIBUTE_${XCODE_PROPERTY} ${XCODE_VALUE})
endmacro (set_xcode_property)

#------------------------------------------------------------------------------
# Set iOS Deployement Target

function(set_deployment_target target_name target_number)
if(TLOC_COMPILER_XCODE)
  set_xcode_property(
    ${target_name} IPHONEOS_DEPLOYMENT_TARGET ${target_number}
  )
endif()
endfunction()

#------------------------------------------------------------------------------
# Set iOS Target Device Family

function(set_target_device_family target_name family_name)
if(TLOC_COMPILER_XCODE)
  set_target_properties(
    ${target_name} PROPERTIES XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY ${family_name}
  )
endif()
endfunction()

#------------------------------------------------------------------------------
# Set Platform Specific Properties

function(set_platform_specific_properties target_name)
  if(TLOC_PLATFORM_IOS)
    set_deployment_target(${target_name} ${IOS_DEPLOYMENT_TARGET})
    set_target_device_family(${target_name} ${IOS_TARGET_DEVICE_FAMILY})
    set_xcode_property(${target_name} CODE_SIGN_IDENTITY ${IOS_CODE_SIGN_IDENTITY})
  endif()
endfunction()

#******************************************************************************
#******************************************************************************
# Compiler
#******************************************************************************
#******************************************************************************

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

#------------------------------------------------------------------------------
# default definitions
function(tloc_revert_definitions)
  set(CMAKE_CXX_FLAGS                ${CMAKE_CXX_FLAGS_DEFAULT} PARENT_SCOPE)
  set(CMAKE_CXX_FLAGS_DEBUG          ${CMAKE_CXX_FLAGS_DEBUG_DEFAULT} PARENT_SCOPE)
  set(CMAKE_CXX_FLAGS_RELEASE        ${CMAKE_CXX_FLAGS_RELEASE_DEFAULT} PARENT_SCOPE)
  set(CMAKE_CXX_FLAGS_RELWITHDEBINFO ${CMAKE_CXX_FLAGS_RELWITHDEBINFO_DEFAULT} PARENT_SCOPE)
endfunction()

#------------------------------------------------------------------------------
# common definitions
function(tloc_add_common_definitions)

  #------------------------------------------------------------------------------
  # C++03 is currently supported (support will be dropped soon)
  if (NOT TLOC_COMPILER_C11)
    add_definitions(-DTLOC_CXX03)
  endif()

  #------------------------------------------------------------------------------
  # visual studio compiler flags
  if (TLOC_COMPILER_MSVC)
    add_definitions(-D_CRT_SECURE_NO_WARNINGS)
    add_definitions(-D_NO_DEBUG_HEAP=1)
  endif()

  #------------------------------------------------------------------------------
  # engine options

  if (OPTIONS_TLOC_ALLOW_STL)
    add_definitions(-DTLOC_USING_STL)
  endif()

  if (NOT OPTIONS_TLOC_ENABLE_EXTERN_TEMPLATE)
    add_definitions(-DTLOC_NO_EXTERN_TEMPLATE)
  endif()

  if (NOT OPTIONS_TLOC_ENABLE_CUSTOM_NEW_DELETE)
    add_definitions(-DTLOC_DISABLE_CUSTOM_NEW_DELETE)
  endif()

  if (OPTIONS_TLOC_ENABLE_MEMORY_TRACKING)
    add_definitions(-DTLOC_ENABLE_MEMORY_TRACKING)
  endif()

endfunction()

#------------------------------------------------------------------------------
# Strict compiler flags required by the engine. This disables RTTI and 
# Exceptions handling
function(tloc_add_definitions_strict)
  tloc_revert_definitions()
  tloc_add_common_definitions()

  #------------------------------------------------------------------------------
  # compiler flags

  set(RT_DEBUG   ${MSVC_RUNTIME_COMPILER_FLAG_DEBUG})
  set(RT_RELEASE ${MSVC_RUNTIME_COMPILER_FLAG_RELEASE})

  set(UNWIND "")
  set(RTTI   "/GR-")
  set(CHECKS "")
  set(WARN_ERR "")

  if (COMPILER_TLOC_COMPILER_ENABLE_CPP_UNWIND)
    set(UNWIND  "/EHsc")
    add_definitions(-DTLOC_ENABLE_CPPUNWIND)
  else()
    add_definitions(-D_HAS_EXCEPTIONS=0)
  endif()

  if (COMPILER_TLOC_COMPILER_ENABLE_RTTI)
    set(RTTI  "/GR")
    add_definitions(-DTLOC_ENABLE_CPPRTTI)
  endif()

  if (COMPILER_TLOC_COMPILER_ENABLE_RUNTIME_CHECKS)
    set(CHECKS "/RTC1")
  endif()
  
  if (COMPILER_TLOC_COMPILER_ENABLE_MULTI_PROCESSOR_COMPILE)
    set(MPC "/MP")
  endif()

  if (COMPILER_TLOC_COMPILER_TREAT_WARN_AS_ERR)
    set(WARN_ERR "/WX")
  endif()

  if (DISTRIBUTION_BUILD)
    set(PDB "/Z7")
    set(MIN_REBUILD "")
  else()
    set(PDB "/Zi")
    if (NOT COMPILER_TLOC_COMPILER_ENABLE_MULTI_PROCESSOR_COMPILE)
      set(MIN_REBUILD "/Gm")
    endif()
  endif()

  #------------------------------------------------------------------------------
  # visual studio compiler and linker flags
  if (TLOC_COMPILER_MSVC)
    set(CMAKE_CXX_FLAGS_DEBUG           "-DTLOC_DEBUG /Od ${MIN_REBUILD} ${CHECKS} ${RT_DEBUG} ${RTTI} ${UNWIND} ${MPC} /W4 ${WARN_ERR} /c ${PDB} /TP" PARENT_SCOPE)
    set(CMAKE_CXX_FLAGS_RELEASE         "-DTLOC_RELEASE /O2 /Ob2 /Oi /Ot /GL ${RT_RELEASE} ${RTTI} ${UNWIND} ${MPC} /Gy /W4 ${WARN_ERR} /c ${PDB} /TP" PARENT_SCOPE)
    set(CMAKE_CXX_FLAGS_RELWITHDEBINFO  "-DTLOC_RELEASE_DEBUGINFO /O2 /Ob2 /Oi /Ot ${MIN_REBUILD} ${RT_RELEASE} ${RTTI} ${UNWIND} ${MPC} /Gy /W4 ${WARN_ERR} /c ${PDB} /TP" PARENT_SCOPE)
    set(CMAKE_EXE_LINKER_FLAGS_RELEASE  "${CMAKE_EXE_LINKER_FLAGS_RELEASE} /LTCG" PARENT_SCOPE)

    set(CMAKE_C_FLAGS_DEBUG           "-DTLOC_DEBUG /Od ${MIN_REBUILD} ${CHECKS} ${RT_DEBUG} ${RTTI} ${UNWIND} ${MPC} /W4 ${WARN_ERR} /c ${PDB} /TC" PARENT_SCOPE)
    set(CMAKE_C_FLAGS_RELEASE         "-DTLOC_RELEASE /O2 /Ob2 /Oi /Ot /GL ${RT_RELEASE} ${RTTI} ${UNWIND} ${MPC} /Gy /W4 ${WARN_ERR} /c ${PDB} /TC" PARENT_SCOPE)
    set(CMAKE_C_FLAGS_RELWITHDEBINFO  "-DTLOC_RELEASE_DEBUGINFO /O2 /Ob2 /Oi /Ot ${MIN_REBUILD} ${RT_RELEASE} ${RTTI} ${UNWIND} ${MPC} /Gy /W4 ${WARN_ERR} /c ${PDB} /TC" PARENT_SCOPE)

    #turn off exceptions for all configurations
    string(REGEX REPLACE "/EHsc" "" CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} )
    string(REGEX REPLACE "/GX" "" CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} )

    # cmake bug (adds /Zm1000 when it is not needed): http://public.kitware.com/Bug/view.php?id=13867
    string(REGEX REPLACE "/Zm1000" "" CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} )

    # The above operations are local, make them parent scope
    set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} PARENT_SCOPE)

  #------------------------------------------------------------------------------
  # xcode compiler and linker flags
  elseif (TLOC_COMPILER_XCODE) 

    set(UNWIND "-fno-exceptions")
    set(RTTI   "-fno-rtti")

    if (COMPILER_TLOC_COMPILER_ENABLE_CPP_UNWIND)
      set(UNWIND  "")
      add_definitions(-DTLOC_ENABLE_CPPUNWIND)
    endif()

    if (COMPILER_TLOC_COMPILER_ENABLE_RTTI)
      set(RTTI  "")
      add_definitions(-DTLOC_ENABLE_CPPRTTI)
    endif()

    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -x objective-c++" PARENT_SCOPE)
    # Note that -gdwarf-2 generates debug symbols (dsym files in dwarf standard)
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -DTLOC_DEBUG -std=c++11 -stdlib=libc++ ${UNWIND} ${RTTI} -Wno-unused-function -g -Wall -Wno-long-long -pedantic" PARENT_SCOPE)
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -DTLOC_RELEASE -std=c++11 -stdlib=libc++ ${UNWIND} ${RTTI} -Wno-unused-function -Wall -Wno-long-long -pedantic" PARENT_SCOPE)
    set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -std=c++11 -stdlib=libc++ -DTLOC_RELEASE_DEBUGINFO ${UNWIND} ${RTTI} -Wno-unused-function -g -Wall -Wno-long-long -pedantic" PARENT_SCOPE)
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

  set(CHECKS "")

  if (COMPILER_TLOC_COMPILER_ENABLE_RUNTIME_CHECKS)
    set(CHECKS "/RTC1")
  endif()

  if (COMPILER_TLOC_COMPILER_ENABLE_MULTI_PROCESSOR_COMPILE)
    set(MPC "/MP")
  endif()

  if (DISTRIBUTION_BUILD)
    set(PDB "/Z7")
    set(MIN_REBUILD "")
  else()
    set(PDB "/Zi")
    if(NOT COMPILER_TLOC_COMPILER_ENABLE_MULTI_PROCESSOR_COMPILE)
      set(MIN_REBUILD "/Gm")
    endif()
  endif()

  #------------------------------------------------------------------------------
  # visual studio compiler and linker flags
  if(TLOC_COMPILER_MSVC)
    set(CMAKE_CXX_FLAGS_DEBUG           "/DTLOC_DEBUG /Od ${MIN_REBUILD} /EHsc ${CHECKS} ${MSVC_RUNTIME_COMPILER_FLAG_DEBUG} ${MPC} /GR /W4 /c ${PDB} /TP" PARENT_SCOPE)
    set(CMAKE_CXX_FLAGS_RELEASE         "/DTLOC_RELEASE /O2 /Ob2 /Oi /Ot /GL /EHsc ${MSVC_RUNTIME_COMPILER_FLAG_RELEASE} ${MPC} /Gy /GR /W4 /c ${PDB} /TP" PARENT_SCOPE)
    set(CMAKE_CXX_FLAGS_RELWITHDEBINFO  "/DTLOC_RELEASE_DEBUGINFO /O2 /Ob2 /Oi /Ot ${MIN_REBUILD} /EHsc ${MSVC_RUNTIME_COMPILER_FLAG_RELEASE} ${MPC} /Gy /GR /W4 /c ${PDB} /TP" PARENT_SCOPE)
    set(CMAKE_EXE_LINKER_FLAGS_RELEASE  "${CMAKE_EXE_LINKER_FLAGS_RELEASE} /LTCG" PARENT_SCOPE)

    #turn off exceptions for all configurations
    string(REGEX REPLACE "/Zm1000" "" CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} )

    # The above operations are local, make them parent scope
    set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} PARENT_SCOPE)

  #------------------------------------------------------------------------------
  # xcode compiler and linker flags
  elseif(TLOC_COMPILER_XCODE)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -x objective-c++" PARENT_SCOPE)
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -DTLOC_DEBUG -std=c++11 -stdlib=libc++ -Wno-unused-function -g" PARENT_SCOPE)
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -DTLOC_RELEASE -std=c++11 -stdlib=libc++ -Wno-unused-function" PARENT_SCOPE)
    set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -std=c++11 -stdlib=libc++ -DTLOC_RELEASE_DEBUGINFO -Wno-unused-function -g" PARENT_SCOPE)
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

set(SOLUTION_PROJECT_TYPE_LIB "lib")
set(SOLUTION_PROJECT_TYPE_EXE "exe")

if(TLOC_COMPILER_MSVC)
  set(COMPILER_TLOC_COMPILER_MSVC_RUNTIME_DLL 6.0 OFF CACHE BOOL "Multithreaded DLL or Multithreaded?")
  if (COMPILER_TLOC_COMPILER_MSVC_RUNTIME_DLL)
    message(STATUS "RUNTIME LIBRARY: Multi-threaded (Debug) DLL")
    set(MSVC_RUNTIME_COMPILER_FLAG_DEBUG    "/MDd")
    set(MSVC_RUNTIME_COMPILER_FLAG_RELEASE  "/MD")
  else()
    message(STATUS "RUNTIME LIBRARY: Multi-threaded (Debug)")
    set(MSVC_RUNTIME_COMPILER_FLAG_DEBUG    "/MTd")
    set(MSVC_RUNTIME_COMPILER_FLAG_RELEASE  "/MT")
  endif()
else()
  set(COMPILER_TLOC_COMPILER_MSVC_RUNTIME_DLL 0)
endif()


if(APPLE)
  set(IOS_DEPLOYMENT_TARGET    7.0 CACHE STRING "This is the lowest OS that you are supporting")
  set(IOS_TARGET_DEVICE_FAMILY "iPhone/iPad" CACHE STRING "Devices to target with the libraries")
  set(IOS_CODE_SIGN_IDENTITY   "iPhone Developer" CACHE STRING "Code signing identity goes here")
  unset(CMAKE_OSX_ARCHITECTURES)
endif()

set(COMPILER_TLOC_COMPILER_ENABLE_RUNTIME_CHECKS OFF CACHE BOOL    "Enables/disables runtime checks (if compile supports it)")
set(COMPILER_TLOC_COMPILER_ENABLE_CPP_UNWIND     OFF CACHE BOOL    "Enables/Disables compiling with exceptions")
set(COMPILER_TLOC_COMPILER_ENABLE_RTTI           OFF CACHE BOOL    "Enables/Disables RTTI")
set(COMPILER_TLOC_COMPILER_ENABLE_MULTI_PROCESSOR_COMPILE ON CACHE BOOL    "Some compilers don't support this option")
set(COMPILER_TLOC_COMPILER_TREAT_WARN_AS_ERR              ON CACHE BOOL    "Some compilers don't support this option")

set(OPTIONS_TLOC_ENABLE_EXTERN_TEMPLATE          ON CACHE BOOL     "Extern template reduces compile times but require more housekeeping.")
set(OPTIONS_TLOC_ENABLE_CUSTOM_NEW_DELETE        ON CACHE BOOL    "Custom new/delete allows the engine to track memory errors.")
set(OPTIONS_TLOC_ALLOW_STL                       OFF CACHE BOOL    "Allow/Disallow the use of stl library")
set(OPTIONS_TLOC_ENABLE_MEMORY_TRACKING          TRUE CACHE BOOL    "Disabling the tracker will increase debugging performance. Tracker is ALWAYS DISABLED in Release.")

set(DISTRIBUTION_BUILD                           FALSE CACHE BOOL  "Distribution builds do not increment version numbers on builds and install relative paths (e.g. for assets)")
set(DISTRIBUTION_FULL_SOURCE                     FALSE CACHE BOOL  "Distribute full source with your build")

#------------------------------------------------------------------------------
# Common Variables Settings

#------------------------------------------------------------------------------
# Common Variables Messages

if(COMPILER_TLOC_COMPILER_ENABLE_CPP_UNWIND)
  message(STATUS "EXCEPTIONS: Enabled")
else()
  message(STATUS "EXCEPTIONS: Disabled")
endif()

if(COMPILER_TLOC_COMPILER_ENABLE_RTTI)
  message(STATUS "RTTI: Enabled")
else()
  message(STATUS "RTTI: Disabled")
endif()

if(COMPILER_TLOC_COMPILER_ENABLE_RTTI)
  message(STATUS "STL: Allowed")
else()
  message(STATUS "STL: Not Allowed")
endif()

if(OPTIONS_TLOC_ENABLE_EXTERN_TEMPLATE)
  message(STATUS "Extern Template: Enabled")
else()
  message(STATUS "Extern Template: Disabled")
endif()

if(OPTIONS_TLOC_ENABLE_CUSTOM_NEW_DELETE)
  message(STATUS "Custom new/delete: Enabled")
else()
  message(STATUS "Custom new/delete: Disabling... FAILED (user currently not allowed to over-ride this feature)")
  set(OPTIONS_TLOC_ENABLE_CUSTOM_NEW_DELETE ON)
endif()

if(OPTIONS_TLOC_ENABLE_MEMORY_TRACKING)
  message(STATUS "Memory Tracking: Enabled")
else()
  message(STATUS "Memory Tracking: Disabled")
endif()

#------------------------------------------------------------------------------
# MISC

# Solution folders for MSVC
set_property(GLOBAL PROPERTY USE_FOLDERS ON)
