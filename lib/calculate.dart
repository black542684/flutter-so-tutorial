import 'dart:ffi';
import 'package:ffi/ffi.dart';

// 定义函数类型

// 加法: int add(int a, int b)
typedef AddFunc = Int32 Function(Int32 a, Int32 b);
typedef Add = int Function(int a, int b);

// 减法: int subtract(int a, int b)
typedef SubtractFunc = Int32 Function(Int32 a, Int32 b);
typedef Subtract = int Function(int a, int b);

// 乘法: int multiply(int a, int b)
typedef MultiplyFunc = Int32 Function(Int32 a, Int32 b);
typedef Multiply = int Function(int a, int b);

// 除法: int divide(int a, int b)
typedef DivideFunc = Int32 Function(Int32 a, Int32 b);
typedef Divide = int Function(int a, int b);

// 字符串拼接: void concat(char* dest, const char* src1, const char* src2)
typedef ConcatFunc = Void Function(Pointer<Char> dest, Pointer<Char> src1, Pointer<Char> src2);
typedef Concat = void Function(Pointer<Char> dest, Pointer<Char> src1, Pointer<Char> src2);

// 数组求和: int sum_array(int* arr, int length)
typedef SumArrayFunc = Int32 Function(Pointer<Int32> arr, Int32 length);
typedef SumArray = int Function(Pointer<Int32> arr, int length);

// 数组求最大值: int max_array(int* arr, int length)
typedef MaxArrayFunc = Int32 Function(Pointer<Int32> arr, Int32 length);
typedef MaxArray = int Function(Pointer<Int32> arr, int length);

/// Calculate类 - 封装了C语言计算库的FFI调用
class Calculate {
  // 动态库实例
  late final DynamicLibrary _lib;

  // 函数实例
  late final Add _add;
  late final Subtract _subtract;
  late final Multiply _multiply;
  late final Divide _divide;
  late final Concat _concat;
  late final SumArray _sumArray;
  late final MaxArray _maxArray;

  /// 构造函数 - 加载so库并初始化函数
  Calculate() {
    // 加载so库
    _lib = DynamicLibrary.open('libcalculate.so');

    // 查找并绑定函数
    _add = _lib.lookup<NativeFunction<AddFunc>>('add').asFunction();
    _subtract = _lib.lookup<NativeFunction<SubtractFunc>>('subtract').asFunction();
    _multiply = _lib.lookup<NativeFunction<MultiplyFunc>>('multiply').asFunction();
    _divide = _lib.lookup<NativeFunction<DivideFunc>>('divide').asFunction();
    _concat = _lib.lookup<NativeFunction<ConcatFunc>>('concat').asFunction();
    _sumArray = _lib.lookup<NativeFunction<SumArrayFunc>>('sum_array').asFunction();
    _maxArray = _lib.lookup<NativeFunction<MaxArrayFunc>>('max_array').asFunction();
  }

  /// 加法
  int add(int a, int b) => _add(a, b);

  /// 减法
  int subtract(int a, int b) => _subtract(a, b);

  /// 乘法
  int multiply(int a, int b) => _multiply(a, b);

  /// 除法
  int divide(int a, int b) => _divide(a, b);

  /// 字符串拼接
  String concat(String str1, String str2) {
    // 分配内存
    final dest = calloc<Char>(str1.length + str2.length + 1);
    final src1 = str1.toNativeUtf8().cast<Char>();
    final src2 = str2.toNativeUtf8().cast<Char>();

    try {
      // 调用C函数
      _concat(dest, src1, src2);

      // 将结果转换回Dart字符串
      return dest.cast<Utf8>().toDartString();
    } finally {
      // 释放内存
      calloc.free(dest);
      calloc.free(src1);
      calloc.free(src2);
    }
  }

  /// 数组求和
  int sumArray(List<int> arr) {
    // 分配内存
    final nativeArr = calloc<Int32>(arr.length);

    try {
      // 复制数据到native内存
      for (var i = 0; i < arr.length; i++) {
        nativeArr[i] = arr[i];
      }

      // 调用C函数
      return _sumArray(nativeArr, arr.length);
    } finally {
      // 释放内存
      calloc.free(nativeArr);
    }
  }

  /// 数组求最大值
  int maxArray(List<int> arr) {
    // 分配内存
    final nativeArr = calloc<Int32>(arr.length);

    try {
      // 复制数据到native内存
      for (var i = 0; i < arr.length; i++) {
        nativeArr[i] = arr[i];
      }

      // 调用C函数
      return _maxArray(nativeArr, arr.length);
    } finally {
      // 释放内存
      calloc.free(nativeArr);
    }
  }
}
