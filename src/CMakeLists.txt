set(BOX_2D_PATH   Box2D)
set(CATCH_PATH    CATCH)
set(WIN_SDK_PATH  WinSDK)

# Add other SDKs that need extraction here
set(SDKS_TO_EXTRACT 
    ${WIN_SDK_PATH})

message("")
message(STATUS "-- Extracting all SDKs --")
foreach(SDK ${SDKS_TO_EXTRACT})
  message(STATUS "Extracting \"${SDK}\"")
  execute_process(
    COMMAND ${CMAKE_COMMAND} -E tar xzf ${CMAKE_CURRENT_SOURCE_DIR}/${SDK}/${SDK}.tar.gz
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${SDK}/
    )
  message(STATUS "Extracting \"${SDK}\" - done")
endforeach()
message(STATUS "-- Extracting all SDKs -- done") 

# ---------- Remove MINSIZEREL ----------
set(CMAKE_CONFIGURATION_TYPES Debug Release RelWithDebInfo CACHE TYPE INTERNAL FORCE )

# ---------- Backup the default flags ----------
SET(CMAKE_CXX_FLAGS_DEFAULT                 ${CMAKE_CXX_FLAGS})
set(CMAKE_CXX_FLAGS_DEBUG_DEFAULT           ${CMAKE_CXX_FLAGS_DEBUG})
set(CMAKE_CXX_FLAGS_RELEASE_DEFAULT         ${CMAKE_CXX_FLAGS_RELEASE})
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO_DEFAULT  ${CMAKE_CXX_FLAGS_RELWITHDEBINFO})

# ---------- COMPILER FLAGS ----------
if(MSVC)
  set(CMAKE_CXX_FLAGS_DEBUG           "/Od /Gm /RTC1 /MTd /GR- /W4 /WX /c /Zi /TP")
  set(CMAKE_CXX_FLAGS_RELEASE         "/O2 /Ob2 /Oi /Ot /GL /MT /Gy /GR- /W4 /WX /c /Zi /TP")
  set(CMAKE_CXX_FLAGS_RELWITHDEBINFO  "/O2 /Ob2 /Oi /Ot /Gm /MT /Gy /GR- /W4 /WX /c /Zi /TP")

  #turn off exceptions for all configurations
  string(REGEX REPLACE "/EHsc" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
elseif(APPLE)
  set(CMAKE_CXX_FLAGS_DEBUG "-fno-exceptions -fno-rtti -Wno-unused-function")
  set(CMAKE_CXX_FLAGS_RELEASE "-fno-exceptions -fno-rtti -Wno-unused-function")
  set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-fno-exceptions -fno-rtti -Wno-unused-function")
endif()

# Should be windows only - double check and put it in if(WIN32)
if(WIN32)
  add_definitions(-D_CRT_SECURE_NO_WARNINGS)
endif()

# ---------- All SDKs that have CMakeLists.txt ----------
set(SDKS_TO_CMAKE 
    ${BOX_2D_PATH} 
    ${CATCH_PATH} 
    ${WIN_SDK_PATH}
    )

message("")
message(STATUS "-- Adding all SDKs to CMake --")
foreach(SDK ${SDKS_TO_CMAKE})
  message(STATUS "Adding ${SDK} to CMake")
  add_subdirectory(${SDK})
endforeach()
message(STATUS "-- Adding all SDKs to CMake -- done")

# ---------- Add tlocVersion (Note: Does NOT work on iOS currently [will work on OSX when we have OSX builds]) ----------
if(NOT APPLE)
  add_subdirectory(tlocDepVersion)
endif()
