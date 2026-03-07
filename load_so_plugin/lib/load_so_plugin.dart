import 'load_so_plugin_platform_interface.dart';

/// LoadSoPlugin - Flutter插件的主类，提供对原生功能的访问
class LoadSoPlugin {
  /// 获取Android平台版本
  Future<String?> getPlatformVersion() {
    return LoadSoPluginPlatform.instance.getPlatformVersion();
  }

  /// 获取来自SO库的消息
  Future<String> getMessage() {
    return LoadSoPluginPlatform.instance.getMessage();
  }

  /// 加法运算
  Future<int> add(int a, int b) {
    return LoadSoPluginPlatform.instance.add(a, b);
  }

  /// 减法运算
  Future<int> subtract(int a, int b) {
    return LoadSoPluginPlatform.instance.subtract(a, b);
  }

  /// 乘法运算
  Future<int> multiply(int a, int b) {
    return LoadSoPluginPlatform.instance.multiply(a, b);
  }

  /// 除法运算
  Future<int> divide(int a, int b) {
    return LoadSoPluginPlatform.instance.divide(a, b);
  }

  /// 字符串拼接
  Future<String> concat(String str1, String str2) {
    return LoadSoPluginPlatform.instance.concat(str1, str2);
  }

  /// 数组求和
  Future<int> sumArray(List<int> arr) {
    return LoadSoPluginPlatform.instance.sumArray(arr);
  }

  /// 数组求最大值
  Future<int> maxArray(List<int> arr) {
    return LoadSoPluginPlatform.instance.maxArray(arr);
  }
}
