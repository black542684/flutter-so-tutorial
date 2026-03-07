import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'load_so_plugin_method_channel.dart';

/// LoadSoPluginPlatform - 插件平台接口的抽象类
/// 定义了所有平台实现必须实现的方法
abstract class LoadSoPluginPlatform extends PlatformInterface {
  /// 构造LoadSoPluginPlatform
  LoadSoPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  /// 默认实例为MethodChannelLoadSoPlugin
  static LoadSoPluginPlatform _instance = MethodChannelLoadSoPlugin();

  /// 获取LoadSoPluginPlatform的默认实例
  ///
  /// 默认为[MethodChannelLoadSoPlugin]
  static LoadSoPluginPlatform get instance => _instance;

  /// 平台特定的实现应该设置这个属性
  /// 使用它们自己的平台特定类（继承自LoadSoPluginPlatform）
  /// 当它们注册自己时
  static set instance(LoadSoPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// 获取平台版本
  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  /// 获取来自SO库的消息
  Future<String> getMessage() {
    throw UnimplementedError('getMessage() has not been implemented.');
  }

  /// 加法运算
  Future<int> add(int a, int b) {
    throw UnimplementedError('add() has not been implemented.');
  }

  /// 减法运算
  Future<int> subtract(int a, int b) {
    throw UnimplementedError('subtract() has not been implemented.');
  }

  /// 乘法运算
  Future<int> multiply(int a, int b) {
    throw UnimplementedError('multiply() has not been implemented.');
  }

  /// 除法运算
  Future<int> divide(int a, int b) {
    throw UnimplementedError('divide() has not been implemented.');
  }

  /// 字符串拼接
  Future<String> concat(String str1, String str2) {
    throw UnimplementedError('concat() has not been implemented.');
  }

  /// 数组求和
  Future<int> sumArray(List<int> arr) {
    throw UnimplementedError('sumArray() has not been implemented.');
  }

  /// 数组求最大值
  Future<int> maxArray(List<int> arr) {
    throw UnimplementedError('maxArray() has not been implemented.');
  }
}
