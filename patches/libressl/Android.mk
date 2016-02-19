LOCAL_PATH := $(call my-dir)

subdirs := $(addprefix $(LOCAL_PATH)/,$(addsuffix /Android.mk, \
		crypto \
		ssl \
	))

#   Suppress stupid compiler warnings
LOCAL_CFLAGS += -Wno-pointer-sign

include $(subdirs)
