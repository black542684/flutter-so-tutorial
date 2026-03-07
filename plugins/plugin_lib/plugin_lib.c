#include <jni.h>
#include <string.h>

// 获取消息函数 - 返回"安卓插件调用成功"
JNIEXPORT jstring JNICALL
Java_com_example_load_1so_1plugin_LoadSoPlugin_getMessage(JNIEnv *env, jobject thiz) {
  return (*env)->NewStringUTF(env, "安卓插件调用成功");
}

// 加法函数
JNIEXPORT jint JNICALL
Java_com_example_load_1so_1plugin_LoadSoPlugin_add(JNIEnv *env, jobject thiz, jint a, jint b) {
  return a + b;
}

// 减法函数
JNIEXPORT jint JNICALL
Java_com_example_load_1so_1plugin_LoadSoPlugin_subtract(JNIEnv *env, jobject thiz, jint a, jint b) {
  return a - b;
}

// 乘法函数
JNIEXPORT jint JNICALL
Java_com_example_load_1so_1plugin_LoadSoPlugin_multiply(JNIEnv *env, jobject thiz, jint a, jint b) {
  return a * b;
}

// 除法函数
JNIEXPORT jint JNICALL
Java_com_example_load_1so_1plugin_LoadSoPlugin_divide(JNIEnv *env, jobject thiz, jint a, jint b) {
  return a / b;
}

// 字符串拼接函数
JNIEXPORT jstring JNICALL
Java_com_example_load_1so_1plugin_LoadSoPlugin_concat(JNIEnv *env, jobject thiz, jstring str1, jstring str2) {
  // 获取Java字符串的C字符串指针
  const char *cstr1 = (*env)->GetStringUTFChars(env, str1, NULL);
  const char *cstr2 = (*env)->GetStringUTFChars(env, str2, NULL);
  
  // 拼接字符串
  char result[256];
  strcpy(result, cstr1);
  strcat(result, cstr2);
  
  // 释放字符串资源
  (*env)->ReleaseStringUTFChars(env, str1, cstr1);
  (*env)->ReleaseStringUTFChars(env, str2, cstr2);
  
  // 返回新的Java字符串
  return (*env)->NewStringUTF(env, result);
}

// 数组求和函数
JNIEXPORT jint JNICALL
Java_com_example_load_1so_1plugin_LoadSoPlugin_sumArray(JNIEnv *env, jobject thiz, jintArray arr) {
  // 获取数组元素
  jint *carr = (*env)->GetIntArrayElements(env, arr, NULL);
  jsize length = (*env)->GetArrayLength(env, arr);
  
  // 计算总和
  jint total = 0;
  for (int i = 0; i < length; i++) {
    total += carr[i];
  }
  
  // 释放数组资源
  (*env)->ReleaseIntArrayElements(env, arr, carr, 0);
  return total;
}

// 数组求最大值函数
JNIEXPORT jint JNICALL
Java_com_example_load_1so_1plugin_LoadSoPlugin_maxArray(JNIEnv *env, jobject thiz, jintArray arr) {
  // 获取数组元素
  jint *carr = (*env)->GetIntArrayElements(env, arr, NULL);
  jsize length = (*env)->GetArrayLength(env, arr);
  
  // 处理空数组情况
  if (length <= 0) {
    (*env)->ReleaseIntArrayElements(env, arr, carr, 0);
    return 0;
  }
  
  // 查找最大值
  jint max = carr[0];
  for (int i = 1; i < length; i++) {
    if (carr[i] > max) {
      max = carr[i];
    }
  }
  
  // 释放数组资源
  (*env)->ReleaseIntArrayElements(env, arr, carr, 0);
  return max;
}
