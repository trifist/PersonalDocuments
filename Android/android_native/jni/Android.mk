LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE    := hello	（模块名称，最终会命名成libXXX.so）
LOCAL_SRC_FILES := hello.cpp （涉及到的源文件，多个以空格分开）
include $(BUILD_SHARED_LIBRARY)