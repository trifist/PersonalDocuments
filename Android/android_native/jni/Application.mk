APP_BUILD_SCRIPT := C:\Users\admin\Desktop\jni\jni\Android.mk （改成Android.mk所在的路径）
APP_PLATFORM := android-19
APP_ABI := all  （all表示所有，可选armeabi-v7a, arm64-v8a, x86, x86_64, mips, mips64。多个以空格分开）
APP_STL := system
APP_STL := stlport_shared  （为了调用stl库而进行的引用）
APP_STL := stlport_static  （为了调用stl库而进行的引用）
APP_OPTIM := debug （debug或release）