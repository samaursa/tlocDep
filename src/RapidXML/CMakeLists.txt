set(RAPID_XML_PATH rapidxml-1.13)

set(
  RAPID_XML_SOURCE
  ${RAPID_XML_SOURCE}/license.txt
  ${RAPID_XML_SOURCE}/rapidxml.hpp
  ${RAPID_XML_SOURCE}/rapidxml_iterators.hpp
  ${RAPID_XML_SOURCE}/rapidxml_print.hpp
  ${RAPID_XML_SOURCE}/rapidxml_utils.hpp
  )

#Copy files
file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/${RAPID_XML_PATH}/ 
  DESTINATION ${TLOC_DEP_INSTALL_PATH}/include/RapidXML 
  FILE_PERMISSIONS OWNER_READ
  FILES_MATCHING PATTERN "*.h" PATTERN "*.hpp" PATTERN "*.cpp")

# Add the source
include_directories(
  ${RAPID_XML_PATH}
  )
