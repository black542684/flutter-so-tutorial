#include "native_lib.h"
#include <string.h>

// 加法
int add (int a, int b) {
    return a + b;
}

// 减法
int subtract (int a, int b) {
    return a - b;
}

// 乘法
int multiply (int a, int b) {
    return a * b;
}

// 除法
int divide (int a, int b) {
    return a / b;
}

/**
 * 字符串拼接
 * @param dest 目标字符串
 * @param src1 第一个源字符串
 * @param src2 第二个源字符串
 */
void concat(char* dest, const char* src1, const char* src2) {
    strcpy(dest, src1);
    strcat(dest, src2);
}

/**
 * 数组求和
 * @param arr 数组指针
 * @param length 数组长度
 * @return 数组元素的总和
 */
int sum_array(int* arr, int length) {
    int total = 0;
    for (int i = 0; i < length; i++) {
        total += arr[i];
    }
    return total;
}

/**
 * 数组求最大值
 * @param arr 数组指针
 * @param length 数组长度
 * @return 数组元素的最大值
 */
int max_array(int* arr, int length) {
    if (length <= 0) {
        return 0;
    }
    
    int max = arr[0];
    for (int i = 1; i < length; i++) {
        if (arr[i] > max) {
            max = arr[i];
        }
    }
    return max;
}