#pragma once

#define CONFIG_VP8_DECODER			0
#define CONFIG_VP9_DECODER			1
#define CONFIG_VP10_DECODER		0
#define CONFIG_VP9					1
#define CONFIG_VP9_POSTPROC		1

#define CONFIG_ENCODERS				0
#define CONFIG_VP9_ENCODER			0

#if defined(_MSC_VER)
#	define CONFIG_OS_SUPPORT		1
#	define INLINE __inline
#	define WIN32						1
#endif // _MSC_VER
