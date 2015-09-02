/* API declaration export attribute */
#define AL_API  __attribute__((visibility("default")))
#define ALC_API __attribute__((visibility("default")))

/* Define to the library version */
#define ALSOFT_VERSION "1.15.1"

#define RESTRICT __restrict

/* Define any available alignment declaration */
#define ALIGN(x) __attribute__((aligned(x)))

/* Define if we have the OpenSL backend */
#define HAVE_OPENSL

/* Define if we have the stat function */
#define HAVE_STAT

/* Define if we have the strtof function */
#define HAVE_STRTOF

/* Define if we have the __int64 type */
#define HAVE___INT64

/* Define to the size of a long int type */
#define SIZEOF_LONG 4

/* Define to the size of a long long int type */
#define SIZEOF_LONG_LONG 8

/* Define if we have C11 _Static_assert support */
#define HAVE_C11_STATIC_ASSERT

/* Define if we have GCC's destructor attribute */
#define HAVE_GCC_DESTRUCTOR

/* Define if we have GCC's format attribute */
#define HAVE_GCC_FORMAT

/* Define if we have stdint.h */
#define HAVE_STDINT_H

/* Define if we have stdbool.h */
#define HAVE_STDBOOL_H

/* Define if we have float.h */
#define HAVE_FLOAT_H

/* Define if we have fenv.h */
#define HAVE_FENV_H

/* Define if we have pthread_setschedparam() */
#define HAVE_PTHREAD_SETSCHEDPARAM

// patches

#define SL_RESULT_READONLY							(SL_RESULT_CONTROL_LOST+1)
#define SL_RESULT_ENGINEOPTION_UNSUPPORTED	(SL_RESULT_CONTROL_LOST+2)
#define SL_RESULT_SOURCE_SINK_INCOMPATIBLE	(SL_RESULT_CONTROL_LOST+3)

#define SL_BYTEORDER_NATIVE						SL_BYTEORDER_LITTLEENDIAN
