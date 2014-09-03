set(FREETYPE_PATH   freetype-2.5.3)

# Compiler definitions for building the library
add_definitions(-DFT2_BUILD_LIBRARY)

# Specify library include directories
include_directories("${FREETYPE_PATH}/include")

set(BASE_SRCS
  ${FREETYPE_PATH}/src/autofit/autofit.c
  ${FREETYPE_PATH}/src/base/ftadvanc.c
  ${FREETYPE_PATH}/src/base/ftbbox.c
  ${FREETYPE_PATH}/src/base/ftbitmap.c
  ${FREETYPE_PATH}/src/base/ftcalc.c
  ${FREETYPE_PATH}/src/base/ftcid.c
  ${FREETYPE_PATH}/src/base/ftdbgmem.c
  ${FREETYPE_PATH}/src/base/ftdebug.c
  ${FREETYPE_PATH}/src/base/ftfstype.c
  ${FREETYPE_PATH}/src/base/ftgasp.c
  ${FREETYPE_PATH}/src/base/ftgloadr.c
  ${FREETYPE_PATH}/src/base/ftglyph.c
  ${FREETYPE_PATH}/src/base/ftgxval.c
  ${FREETYPE_PATH}/src/base/ftinit.c
  ${FREETYPE_PATH}/src/base/ftlcdfil.c
  ${FREETYPE_PATH}/src/base/ftmm.c
  ${FREETYPE_PATH}/src/base/ftobjs.c
  ${FREETYPE_PATH}/src/base/ftotval.c
  ${FREETYPE_PATH}/src/base/ftoutln.c
  ${FREETYPE_PATH}/src/base/ftpatent.c
  ${FREETYPE_PATH}/src/base/ftpfr.c
  ${FREETYPE_PATH}/src/base/ftrfork.c
  ${FREETYPE_PATH}/src/base/ftsnames.c
  ${FREETYPE_PATH}/src/base/ftstream.c
  ${FREETYPE_PATH}/src/base/ftstroke.c
  ${FREETYPE_PATH}/src/base/ftsynth.c
  ${FREETYPE_PATH}/src/base/ftsystem.c
  ${FREETYPE_PATH}/src/base/fttrigon.c
  ${FREETYPE_PATH}/src/base/fttype1.c
  ${FREETYPE_PATH}/src/base/ftutil.c
  ${FREETYPE_PATH}/src/base/ftwinfnt.c
  ${FREETYPE_PATH}/src/base/ftxf86.c
  ${FREETYPE_PATH}/src/bdf/bdf.c
  ${FREETYPE_PATH}/src/bzip2/ftbzip2.c
  ${FREETYPE_PATH}/src/cache/ftcache.c
  ${FREETYPE_PATH}/src/cff/cff.c
  ${FREETYPE_PATH}/src/cid/type1cid.c
  ${FREETYPE_PATH}/src/gzip/ftgzip.c
  ${FREETYPE_PATH}/src/lzw/ftlzw.c
  ${FREETYPE_PATH}/src/pcf/pcf.c
  ${FREETYPE_PATH}/src/pfr/pfr.c
  ${FREETYPE_PATH}/src/psaux/psaux.c
  ${FREETYPE_PATH}/src/pshinter/pshinter.c
  ${FREETYPE_PATH}/src/psnames/psmodule.c
  ${FREETYPE_PATH}/src/raster/raster.c
  ${FREETYPE_PATH}/src/sfnt/sfnt.c
  ${FREETYPE_PATH}/src/smooth/smooth.c
  ${FREETYPE_PATH}/src/truetype/truetype.c
  ${FREETYPE_PATH}/src/type1/type1.c
  ${FREETYPE_PATH}/src/type42/type42.c
  ${FREETYPE_PATH}/src/winfonts/winfnt.c
)

#Copy files
file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/${FREETYPE_PATH}/include/ DESTINATION ${TLOC_DEP_INSTALL_PATH}/include/FreeType FILES_MATCHING PATTERN "*.h" PATTERN "*.hpp" PATTERN "*.cpp")

include_directories(${FREETYPE_PATH}/src/truetype)
include_directories(${FREETYPE_PATH}/src/sfnt)
include_directories(${FREETYPE_PATH}/src/autofit)
include_directories(${FREETYPE_PATH}/src/smooth)
include_directories(${FREETYPE_PATH}/src/raster)
include_directories(${FREETYPE_PATH}/src/psaux)
include_directories(${FREETYPE_PATH}/src/psnames)

add_library(
  FreeType STATIC 
  ${BASE_SRCS}
)

set_platform_specific_properties(FreeType)
