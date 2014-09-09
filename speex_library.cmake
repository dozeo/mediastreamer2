
if(TARGET libspeex)
	set(SPEEX_FOUND TRUE)
endif()

list(APPEND CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH};${CMAKE_CURRENT_LIST_DIR}")

if(WIN32)
	set(LIB_EXT ".lib")
else()
	set(LIB_EXT ".so")
endif()

find_library(SPEEX_LIBRARY
	NAMES speex${LIB_EXT} Speex${LIB_EXT} libspeex${LIB_EXT}
	PATHS /usr/lib /usr/local/lib /opt/lib
	)
message(STATUS "SPEEX_LIBRARY: ${SPEEX_LIBRARY}")

find_path(SPEEX_INCLUDE
	NAMES speex/speex.h speex.h
	PATHS /usr/include /usr/local/include /opt/local/include
	)
message(STATUS "SPEEX_INCLUDE: ${SPEEX_INCLUDE}")


add_library(libspeex STATIC IMPORTED GLOBAL)
set_target_properties(libspeex PROPERTIES
	IMPORTED_LOCATION "${SPEEX_LIBRARY}"
	INTERFACE_INCLUDE_DIRECTORIES "${SPEEX_INCLUDE}"
	INTERFACE_DEFINITIONS "${SPEEX_DEFINITIONS}"
	)

find_library(SPEEXDSP_LIBRARY 
	NAMES speexdsp${LIB_EXT} libspeexdsp${LIB_EXT} speexdsp${LIB_EXT} Speexdsp${LIB_EXT} libspeexdsp${LIB_EXT}
	PATHS /usr/lib /usr/local/lib /opt/lib
	)
message(STATUS "Speex dsp: ${SPEEXDSP_LIBRARY}")

add_library(libspeexdsp STATIC IMPORTED GLOBAL)
set_target_properties(libspeexdsp PROPERTIES
	IMPORTED_LOCATION "${SPEEXDSP_LIBRARY}"
	INTERFACE_INCLUDE_DIRECTORIES "${SPEEX_INCLUDE_DIRS}"
	INTERFACE_DEFINITIONS "${SPEEX_DEFINITIONS}"
	)

