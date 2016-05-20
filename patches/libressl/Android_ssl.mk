LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

GLOBAL_C_INCLUDES := \
	$(LOCAL_PATH) \
	$(LOCAL_PATH)/.. \
	$(LOCAL_PATH)/../include \
	$(LOCAL_PATH)/../crypto

LOCAL_SRC_FILES = \
bio_ssl.c \
bs_ber.c \
bs_cbb.c \
bs_cbs.c \
d1_both.c \
d1_clnt.c \
d1_enc.c \
d1_lib.c \
d1_meth.c \
d1_pkt.c \
d1_srtp.c \
d1_srvr.c \
pqueue.c \
s23_clnt.c \
s23_lib.c \
s23_pkt.c \
s23_srvr.c \
s3_both.c \
s3_cbc.c \
s3_clnt.c \
s3_lib.c \
s3_pkt.c \
s3_srvr.c \
ssl_algs.c \
ssl_asn1.c \
ssl_cert.c \
ssl_ciph.c \
ssl_err.c \
ssl_err2.c \
ssl_lib.c \
ssl_rsa.c \
ssl_sess.c \
ssl_stat.c \
ssl_txt.c \
t1_clnt.c \
t1_enc.c \
t1_lib.c \
t1_meth.c \
t1_reneg.c \
t1_srvr.c \

LOCAL_MODULE := libSSL

GLOBAL_CFLAGS   := -O3 -DHAVE_CONFIG_H=1

LOCAL_CFLAGS := $(GLOBAL_CFLAGS)

LOCAL_CFLAGS += -DOPENSSL_THREADS -D_REENTRANT -DDSO_DLFCN -DHAVE_DLFCN_H -DL_ENDIAN
# From DEPFLAG=
LOCAL_CFLAGS += -DOPENSSL_NO_CAMELLIA -DOPENSSL_NO_CAPIENG -DOPENSSL_NO_CAST -DOPENSSL_NO_CMS -DOPENSSL_NO_GMP -DOPENSSL_NO_IDEA -DOPENSSL_NO_JPAKE -DOPENSSL_NO_MD2 -DOPENSSL_NO_MDC2 -DOPENSSL_NO_RC5 -DOPENSSL_NO_SHA0 -DOPENSSL_NO_RFC3779 -DOPENSSL_NO_SEED -DOPENSSL_NO_STORE -DOPENSSL_NO_WHIRLPOOL -DOPENSSL_NO_SRP
# Extra
LOCAL_CFLAGS += -DOPENSSL_NO_HW -DOPENSSL_NO_ENGINE -DZLIB -fno-short-enums

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
    LOCAL_CFLAGS += -mfloat-abi=hard -mfpu=neon -march=armv7-a -mhard-float -D_NDK_MATH_NO_SOFTFP=1
endif

LOCAL_CFLAGS += -Wno-implicit-function-declaration -Wno-int-conversion

LOCAL_C_INCLUDES := $(GLOBAL_C_INCLUDES)

#   Suppress stupid compiler warnings
LOCAL_CFLAGS += -Wno-pointer-sign

include $(BUILD_STATIC_LIBRARY)
