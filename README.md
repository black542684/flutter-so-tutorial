# Flutter SO库加载示例

一个展示Flutter中两种SO库加载方式的示例项目：FFI直接加载和Android插件加载。

## 项目简介

本项目演示了在Flutter应用中加载和使用原生C/C++动态库（.so文件）的两种不同方式：

1. **FFI方式**：Dart代码直接通过FFI调用C函数
2. **Android插件方式**：Dart通过MethodChannel调用Kotlin，再由Kotlin调用JNI函数

## 功能特性

- ✅ 支持多种数学运算（加、减、乘、除）
- ✅ 支持字符串拼接
- ✅ 支持数组操作（求和、求最大值）
- ✅ 提供两种SO加载方式的对比示例
- ✅ 使用Tab切换界面，方便对比两种方式
- ✅ 完整的中文注释，便于学习理解

## 项目结构

```
load_so/
├── android/                          # Android原生代码
│   └── app/src/main/jniLibs/     # FFI方式使用的SO库
│       ├── arm64-v8a/
│       ├── armeabi-v7a/
│       ├── x86/
│       └── x86_64/
├── plugins/                          # 插件和原生库源码
│   ├── calculate/                     # FFI方式使用的C代码
│   │   ├── native_lib.c
│   │   └── native_lib.h
│   └── plugin_lib/                   # Android插件方式使用的C代码
│       └── plugin_lib.c
├── load_so_plugin/                   # Flutter插件
│   ├── android/
│   │   └── src/main/
│   │       ├── jniLibs/             # 插件使用的SO库
│   │       └── kotlin/.../LoadSoPlugin.kt
│   └── lib/                        # 插件Dart代码
│       ├── load_so_plugin.dart
│       ├── load_so_plugin_platform_interface.dart
│       └── load_so_plugin_method_channel.dart
└── lib/                             # Flutter应用代码
    ├── main.dart                     # 主应用（包含Tabs切换）
    └── calculate.dart                 # FFI方式调用封装
```

## 两种SO加载方式对比

### FFI方式

**优点：**
- 代码简单，直接Dart→C调用
- 性能更好，没有中间层开销
- 适合纯计算型任务
- 跨平台（Android、iOS、Linux等）

**缺点：**
- 只能调用C函数，不能直接调用Java/Kotlin API
- 复杂的Android系统功能（权限、通知等）难以处理
- 错误处理相对简单

**实现方式：**
```dart
// Dart代码
import 'dart:ffi';
import 'package:ffi/ffi.dart';

class Calculate {
  late final DynamicLibrary _lib;
  late final Add _add;

  Calculate() {
    _lib = DynamicLibrary.open('libcalculate.so');
    _add = _lib.lookup<NativeFunction<AddFunc>>('add').asFunction();
  }

  int add(int a, int b) => _add(a, b);
}
```

### Android插件方式

**优点：**
- 可以充分利用Android原生API
- 适合需要复杂原生交互的场景
- 更好的错误处理和日志
- 可以处理权限、生命周期等Android特有功能

**缺点：**
- 多了一层Kotlin/Java中间层，性能略差
- 代码量更多，需要维护Dart和Kotlin两套代码
- 调试相对复杂
- 仅限Android平台

**实现方式：**
```kotlin
// Kotlin代码
class LoadSoPlugin : FlutterPlugin, MethodCallHandler {
  init {
    System.loadLibrary("plugin_lib")
  }

  private external fun add(a: Int, b: Int): Int

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "add" -> {
        val a = call.argument<Int>("a")
        val b = call.argument<Int>("b")
        result.success(add(a!!, b!!))
      }
      // ...
    }
  }
}
```

```dart
// Dart代码
class LoadSoPlugin {
  static const MethodChannel _channel = MethodChannel('load_so_plugin');

  static Future<int> add(int a, int b) async {
    final result = await _channel.invokeMethod<int>('add', {
      'a': a,
      'b': b,
    });
    return result!;
  }
}
```

## 运行项目

### 前置要求

- Flutter SDK (3.9.2或更高版本)
- Android SDK
- Android NDK (用于编译SO库)

### 安装依赖

```bash
flutter pub get
```

### 运行应用

```bash
# 连接Android设备或启动模拟器
flutter run
```

### 编译SO库（如需修改C代码）

#### FFI方式SO库

项目已包含预编译的SO库，如需重新编译：

```bash
# 使用Android Studio的CMake或手动使用NDK编译
# SO库位于 android/app/src/main/jniLibs/
```

#### Android插件方式SO库

如需重新编译了plugin_lib：

```bash
# 使用NDK编译（示例命令，需根据实际NDK路径调整）
$NDK_HOME/toolchains/llvm/prebuilt/windows-x86_64/bin/aarch64-linux-android21-clang.cmd \
  -shared -fPIC plugins/plugin_lib/plugin_lib.c \
  -o plugins/plugin_lib/build/arm64-v8a/libplugin_lib.so

# 复制到插件目录
Copy-Item plugins/plugin_lib/build/arm64-v8a/libplugin_lib.so \
  load_so_plugin/android/src/main/jniLibs/arm64-v8a/
```

## 技术细节

### JNI函数命名规则

Android插件方式使用的JNI函数必须遵循特定的命名规则：

```c
// 格式：Java_包名_类名_方法名
// 包名中的点(.)替换为下划线(_)
JNIEXPORT jstring JNICALL
Java_com_example_load_1so_1plugin_LoadSoPlugin_getMessage(JNIEnv *env, jobject thiz) {
  return (*env)->NewStringUTF(env, "安卓插件调用成功");
}
```

### 支持的CPU架构

项目为以下架构编译了SO库：
- `arm64-v8a` - 64位ARM设备（大多数现代Android设备）
- `armeabi-v7a` - 32位ARM设备（较老的Android设备）
- `x86_64` - 64位x86模拟器
- `x86` - 32位x86模拟器

### 依赖项

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  ffi: ^2.2.0                    # FFI支持
  load_so_plugin:                    # 本地插件
    path: ./load_so_plugin
```

## 学习要点

1. **FFI基础**：了解如何使用Dart FFI调用C函数
2. **JNI编程**：学习如何编写JNI函数供Kotlin调用
3. **Flutter插件开发**：掌握Flutter插件的基本结构和通信机制
4. **MethodChannel**：理解Flutter与原生平台的异步通信
5. **SO库管理**：学会如何编译、打包和分发多架构SO库

## 常见问题

### Q: 为什么需要编译多个架构的SO库？

A: Android设备使用不同的CPU架构，为了确保应用在所有设备上都能运行，需要为每个架构编译对应的SO库。

### Q: FFI和插件方式如何选择？

A:
- 使用FFI：纯计算任务、需要跨平台、追求性能
- 使用插件：需要调用Android系统API、处理权限、需要复杂原生交互

### Q: 如何调试SO库中的问题？

A:
- FFI方式：使用`print`输出日志，通过`adb logcat`查看
- 插件方式：在Kotlin代码中使用`Log.d()`，或直接在C代码中使用`__android_log_print`

## 参考资源

- [Flutter FFI官方文档](https://docs.flutter.dev/development/platform-integration/c-interop)
- [Flutter插件开发指南](https://docs.flutter.dev/development/platform-integration/platform-channels)
- [Android JNI开发指南](https://developer.android.com/training/articles/perf-jni)

## 许可证

本项目仅供学习参考使用。
