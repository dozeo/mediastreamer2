if(WIN32)
	set(LIB_EXT "")
	#set(LIB_EXT ".lib")
else()
	if(BUILD_SHARED_LIBS)
		set(LIB_EXT ".so")
	else()
		set(LIB_EXT ".a")
	endif()
endif()

## libspeex
if(NOT TARGET libspeex)
	find_library(SPEEX_LIBRARY
		NAMES speex${LIB_EXT} Speex${LIB_EXT} libspeex${LIB_EXT}
		PATHS /usr/lib /usr/local/lib /opt/lib ${SPEEX_ROOT_DIR}/lib
		)
	message(STATUS "SPEEX_LIBRARY: ${SPEEX_LIBRARY}")
	mark_as_advanced(SPEEX_LIBRARY)

	find_path(SPEEX_INCLUDE
		NAMES speex/speex.h speex.h
		PATHS /usr/include /usr/local/include /opt/local/include ${SPEEX_ROOT_DIR}/include
		)
	message(STATUS "SPEEX_INCLUDE: ${SPEEX_INCLUDE}")
	mark_as_advanced(SPEEX_INCLUDE)

	add_library(libspeex STATIC IMPORTED GLOBAL)
	set_target_properties(libspeex PROPERTIES
		IMPORTED_LOCATION "${SPEEX_LIBRARY}"
		INTERFACE_INCLUDE_DIRECTORIES "${SPEEX_INCLUDE}"
		INTERFACE_DEFINITIONS "${SPEEX_DEFINITIONS}"
		)
else()
	message(STATUS "libspeex already exists as a target")
endif()

## libspeexdsp
if(NOT TARGET libspeexdsp)
	find_library(SPEEXDSP_LIBRARY 
		NAMES speexdsp${LIB_EXT} libspeexdsp${LIB_EXT} speexdsp${LIB_EXT} Speexdsp${LIB_EXT} libspeexdsp${LIB_EXT}
		PATHS /usr/lib /usr/local/lib /opt/lib ${SPEEX_ROOT_DIR}/lib
		)
	message(STATUS "SPEEXDSP_LIBRARY: ${SPEEXDSP_LIBRARY}")
	mark_as_advanced(SPEEXDSP_LIBRARY)

	find_path(SPEEXDSP_INCLUDE
		NAMES speex/speex_resampler.h speex_resampler.h
		PATHS /usr/include /usr/local/include /opt/local/include ${SPEEX_ROOT_DIR}/include
		)
	message(STATUS "SPEEXDSP_INCLUDE: ${SPEEXDSP_INCLUDE}")
	mark_as_advanced(SPEEXDSP_INCLUDE)

	add_library(libspeexdsp STATIC IMPORTED GLOBAL)
	set_target_properties(libspeexdsp PROPERTIES
		IMPORTED_LOCATION "${SPEEXDSP_LIBRARY}"
		INTERFACE_INCLUDE_DIRECTORIES "${SPEEXDSP_INCLUDE}"
		INTERFACE_DEFINITIONS "${SPEEX_DEFINITIONS}"
		)
else()
	message(STATUS "libspeexdsp already exists as a target")
endif()
