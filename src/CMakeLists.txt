set(BOX_2D_PATH     Box2D)
set(CATCH_PATH      CATCH)
set(RAPID_XML_PATH  RapidXML)
set(WIN_SDK_PATH    WinSDK)

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

# ---------- Add strict compiler settings for all projects ----------

tloc_add_definitions_strict()

# ---------- All SDKs that have CMakeLists.txt ----------
set(SDKS_TO_CMAKE 
    ${BOX_2D_PATH} 
    ${CATCH_PATH} 
    ${WIN_SDK_PATH}
    ${RAPID_XML_PATH}
    )

message("")
message(STATUS "-- Adding all SDKs to CMake --")
foreach(SDK ${SDKS_TO_CMAKE})
  message(STATUS "Adding ${SDK} to CMake")
  add_subdirectory(${SDK})
endforeach()
message(STATUS "-- Adding all SDKs to CMake -- done")

# ---------- Add tlocVersion (Note: Does NOT work on iOS currently [will work on OSX when we have OSX builds]) ----------
if(NOT TLOC_PLATFORM_IOS)
  add_subdirectory(tlocDepVersion)
endif()
