cmake_minimum_required(VERSION 2.8)

project("libModPlug")

if(MSVC)
	add_definitions(
		-D_CRT_SECURE_NO_WARNINGS
		-DHAVE_CONFIG_H
		-DMODPLUG_BUILD
		-DMODPLUG_STATIC
		-DMODPLUG_NO_FILESAVE
		-DMODPLUG_BASIC_SUPPORT
	)
	set(CMAKE_CXX_FLAGS "/EHsc /RTCc /RTC1 /MTd /Zp16 /GS /Qpar /MP /wd4244")
endif(MSVC)

include_directories(
	.
	../../src/libmodplug
	../../src/libmodplug/src
	../../src/libmodplug/src/libmodplug
)

if(APPLE)
    add_definitions(
        -DHAVE_CONFIG_H
        -DMODPLUG_BUILD
        -DMODPLUG_STATIC
        -DMODPLUG_NO_FILESAVE
        -DMODPLUG_BASIC_SUPPORT
    )
endif(APPLE)

set(SRC_FILES
	../../src/libmodplug/src/fastmix.cpp
	../../src/libmodplug/src/load_669.cpp
	../../src/libmodplug/src/load_amf.cpp
	../../src/libmodplug/src/load_ams.cpp
	../../src/libmodplug/src/load_dbm.cpp
	../../src/libmodplug/src/load_dmf.cpp
	../../src/libmodplug/src/load_dsm.cpp
	../../src/libmodplug/src/load_far.cpp
	../../src/libmodplug/src/load_it.cpp
	../../src/libmodplug/src/load_j2b.cpp
	../../src/libmodplug/src/load_mdl.cpp
	../../src/libmodplug/src/load_med.cpp
	../../src/libmodplug/src/load_mid.cpp
	../../src/libmodplug/src/load_mod.cpp
	../../src/libmodplug/src/load_mt2.cpp
	../../src/libmodplug/src/load_mtm.cpp
	../../src/libmodplug/src/load_okt.cpp
	../../src/libmodplug/src/load_pat.cpp
	../../src/libmodplug/src/load_psm.cpp
	../../src/libmodplug/src/load_ptm.cpp
	../../src/libmodplug/src/load_s3m.cpp
	../../src/libmodplug/src/load_stm.cpp
	../../src/libmodplug/src/load_ult.cpp
	../../src/libmodplug/src/load_umx.cpp
	../../src/libmodplug/src/load_wav.cpp
	../../src/libmodplug/src/load_xm.cpp
	../../src/libmodplug/src/mmcmp.cpp
	../../src/libmodplug/src/modplug.cpp
	../../src/libmodplug/src/snd_dsp.cpp
	../../src/libmodplug/src/snd_flt.cpp
	../../src/libmodplug/src/snd_fx.cpp
	../../src/libmodplug/src/sndfile.cpp
	../../src/libmodplug/src/sndmix.cpp
)

set(HEADER_FILES
	../../src/libmodplug/config.h
	../../src/libmodplug/src/load_pat.h
	../../src/libmodplug/src/modplug.h
	../../src/libmodplug/src/tables.h
)

add_library(libModPlug ${SRC_FILES} ${HEADER_FILES}
	)
