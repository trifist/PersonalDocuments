//
// Created by admin on 2018/1/30.
//
#include <jni.h>
#include <android/log.h>
#include <string.h>

#ifndef _Included_com_jni_HelloWorld // 1
#define _Included_com_jni_HelloWorld

#ifdef __cplusplus // 2
extern "C" {
#endif // 2
JNIEXPORT jstring JNICALL Java_com_iflytek_jnitest_LibTest_getStr(JNIEnv *, jobject);
#ifdef __cplusplus // 3
}
#endif // 3
#endif // 1

JNIEXPORT jstring JNICALL Java_com_iflytek_jnitest_LibTest_getStr(JNIEnv * env,jobject obj) {
    return env->NewStringUTF("jni jni jni");
}
