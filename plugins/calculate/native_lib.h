#ifndef NATIVE_LIB_H
#define NATIVE_LIB_H

// 定义一个函数，用于计算两个整数的和
int add(int a, int b);

// 减法
int subtract(int a, int b);

// 乘法
int multiply(int a, int b);

// 除法
int divide(int a, int b);

// 字符串拼接
void concat(char* dest, const char* src1, const char* src2);

// 数组求和
int sum_array(int* arr, int length);

// 数组求最大值
int max_array(int* arr, int length);

#endif