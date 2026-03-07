import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'load_so_plugin_platform_interface.dart';

/// MethodChannelLoadSoPlugin - 使用MethodChannel实现的LoadSoPluginPlatform
/// 负责通过MethodChannel与原生平台进行通信
class MethodChannelLoadSoPlugin extends LoadSoPluginPlatform {
  /// 用于与原生平台交互的MethodChannel
  @visibleForTesting
  final methodChannel = const MethodChannel('load_so_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<String> getMessage() async {
    final message = await methodChannel.invokeMethod<String>('getMessage');
    return message!;
  }

  @override
  Future<int> add(int a, int b) async {
    final result = await methodChannel.invokeMethod<int>('add', {
      'a': a,
      'b': b,
    });
    return result!;
  }

  @override
  Future<int> subtract(int a, int b) async {
    final result = await methodChannel.invokeMethod<int>('subtract', {
      'a': a,
      'b': b,
    });
    return result!;
  }

  @override
  Future<int> multiply(int a, int b) async {
    final result = await methodChannel.invokeMethod<int>('multiply', {
      'a': a,
      'b': b,
    });
    return result!;
  }

  @override
  Future<int> divide(int a, int b) async {
    final result = await methodChannel.invokeMethod<int>('divide', {
      'a': a,
      'b': b,
    });
    return result!;
  }

  @override
  Future<String> concat(String str1, String str2) async {
    final result = await methodChannel.invokeMethod<String>('concat', {
      'str1': str1,
      'str2': str2,
    });
    return result!;
  }

  @override
  Future<int> sumArray(List<int> arr) async {
    final result = await methodChannel.invokeMethod<int>('sumArray', {
      'arr': arr,
    });
    return result!;
  }

  @override
  Future<int> maxArray(List<int> arr) async {
    final result = await methodChannel.invokeMethod<int>('maxArray', {
      'arr': arr,
    });
    return result!;
  }
}
