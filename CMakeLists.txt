cmake_minimum_required(VERSION 2.8)

project(mediastreamer2)

set(MEDIASTREAMER2_VERSION_MAJOR 2)
set(MEDIASTREAMER2_VERSION_MINOR 9)
set(MEDIASTREAMER2_VERSION_MICRO 0)

set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH};${CMAKE_CURRENT_SOURCE_DIR}")

option(BUILD_SHARED_LIBS "Build shared mediastreamer2 library" ON)
option(MS2_TEST2 "just testing" ON)
option(ENABLED_SPEEX "Build with libspeex" ON)

include(speex_library.cmake)

if(NOT TARGET ortp)
	add_subdirectory(vendor/ortp)
endif()

# simplify output directories on platforms with multiple configurations
foreach(OUTPUTCONFIG ${CMAKE_CONFIGURATION_TYPES})
	string(TOUPPER ${OUTPUTCONFIG} OUTPUTCONFIG)
	set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/bin)
	set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/lib)
	set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/lib)
endforeach(OUTPUTCONFIG CMAKE_CONFIGURATION_TYPES)

set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

list(APPEND srcs
#	"src/dxfilter.cpp"
	"src/base/eventqueue.c"
	"src/base/mscommon.c"
	"src/base/msfilter.c"
	"src/base/msqueue.c"
	"src/base/mssndcard.c"
	"src/base/msticker.c"
	"src/base/mswebcam.c"
	"src/base/mtu.c"
	"src/filter-template.c"
#	"src/audiofilters/aac-eld.c"
	"src/audiofilters/alaw.c"
#	"src/audiofilters/aqsnd.c"
#	"src/audiofilters/arts.c"
	"src/audiofilters/audiomixer.c"
	"src/audiofilters/chanadapt.c"
	"src/audiofilters/dtmfgen.c"
	"src/audiofilters/equalizer.c"
#	"src/audiofilters/g726.c"
	"src/audiofilters/genericplc.c"
#	"src/audiofilters/gsm.c"
	"src/audiofilters/l16.c"
	"src/audiofilters/msconf.c"
	"src/audiofilters/msfileplayer.c"
	"src/audiofilters/msfilerec.c"
	"src/audiofilters/msg722.c"
	"src/utils/g722_encode.c"
	"src/utils/g722_decode.c"
	"src/utils/dsptools.c"
	"src/utils/kiss_fft.c"
	"src/utils/kiss_fft.h"
	"src/utils/kiss_fftr.c"
	"src/utils/kiss_fftr.h"
	"src/audiofilters/msvolume.c"
	"src/audiofilters/tonedetector.c"
	"src/audiofilters/ulaw.c"
	"src/audiofilters/waveheader.h"
#	"src/audiofilters/webrtc_aec.c" # mobile?
	"src/voip/bitratecontrol.c"
	"src/voip/bitratedriver.c"
#	"src/voip/ice.c" # not compiling on win32 msvc
	"src/voip/layouts.c"
#	"src/voip/layouts.h"
#	"src/voip/msvideo_neon.h"
	"src/voip/msvoip.c"
	"src/voip/nowebcam.h"
#	"src/voip/private.h"
	"src/voip/qosanalyzer.c"
	"src/voip/qualityindicator.c"
#	"src/voip/rfc2429.h"
	"src/voip/rfc3984.c"
	"src/voip/ringstream.c"
#	"src/voip/scaler.c" # android?
#	"src/voip/scaler.h"
#	"src/voip/scaler_arm.S"
	"src/otherfilters/itc.c"
	"src/otherfilters/join.c"
	"src/otherfilters/msrtp.c"
	"src/otherfilters/tee.c"
	"src/otherfilters/void.c"
	)

list(APPEND hdrs
	"src/voipdescs.h")

if(ENABLED_ICE)
	list(APPEND srcs
		"src/voip/audioconference.c"
		"src/voip/audiostream.c"
		"src/voip/ice.c"
		"src/voip/mediastream.c"
		)
endif()

if(ENABLED_VIDEO)
	list(APPEND srcs
		"src/voip/msvideo.c"
		"src/voip/msvideo_neon.c"
		"src/voip/videostream.c"
		)
endif()

if(ENABLED_PORTAUDIO)
	list(APPEND srcs "src/audiofilters/pasnd.c")
endif()

if(ENABLED_SPEEX)
	list(APPEND srcs
		"src/audiofilters/msresample.c"
		"src/audiofilters/msspeex.c"
		"src/audiofilters/speexec.c"
		)
endif()

if(WIN32)
	if(ENABLED_SPEEX)
		list(APPEND srcs
#			"src/audiofilters/winsnd.c"
			"src/audiofilters/winsnd2.c"
			)
	else()
		if (DIRECTSOUND)
			list(APPEND srcs "src/audiofilters/winsndds.cpp")
		else()
			list(APPEND srcs "src/audiofilters/winsnd3.c")
		endif()
	endif()
endif()

if(APPLE)
	list(APPEND srcs
		"src/audiofilters/macsnd.c")
endif()

if(linux)
	list(APPEND srcs
		"src/audiofilters/alsa.c"
		"src/audiofilters/oss.c"
		"src/audiofilters/pulseaudio.c"
		)
endif()


#find_package(Speex REQUIRED)
#if(SPEEX_FOUND)
#	message(STATUS "Found:  ${SPEEX_FOUND}")
#	list(APPEND inc_dirs ${SPEEX_INCLUDE_DIRS})
#	list(APPEND libs ${SPEEX_LIBRARIES} speexdsp)
#else()
#	if(TARGET libspeex)
#		list(APPEND libs libspeex libspeexdsp)
#	else()
#		if (ENABLED_SPEEX)
#			message(STATUS "Speex is enabled but cannot be found... disabling")
#			unset(ENABLED_SPEEX)
#		endif()
#	endif()
#endif()

list(APPEND inc_dirs
	"${CMAKE_CURRENT_SOURCE_DIR}/src"
	"${CMAKE_CURRENT_SOURCE_DIR}/src/utils"
	"${CMAKE_CURRENT_SOURCE_DIR}/include"
	"${CMAKE_CURRENT_BINARY_DIR}")

list(APPEND interface_inc_dirs
	"${CMAKE_CURRENT_SOURCE_DIR}/include")

list(APPEND definitions
	"MS2_INTERNAL"
	"__STDC_LIMIT_MACROS")

if(MSVC)
	list(APPEND definitions
		"_CRT_SECURE_NO_WARNINGS")
endif()

if(BUILD_SHARED_LIBS)
	set(LIBTYPE SHARED)
else()
endif()

add_library(mediastreamer2 ${LIBTYPE} ${srcs} ${hdrs} ${public_hdrs})
set_target_properties(mediastreamer2 PROPERTIES
	PUBLIC_HEADERS "${public_hdrs}"
	INCLUDE_DIRECTORIES "${inc_dirs}"
	COMPILE_DEFINITIONS "${definitions}"
	INTERFACE_COMPILE_DEFINITIONS "${interface_definitions}"
	INTERFACE_INCLUDE_DIRECTORIES "${interface_inc_dirs}"
	SOVERSION ${MEDIASTREAMER2_VERSION_MAJOR}
	VERSION ${MEDIASTREAMER2_VERSION_MAJOR}
	)
target_link_libraries(mediastreamer2 ${system_libs} ortp libspeex libspeexdsp)

