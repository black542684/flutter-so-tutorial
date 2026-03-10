import 'package:flutter_test/flutter_test.dart';
import 'package:load_so_plugin/load_so_plugin.dart';
import 'package:load_so_plugin/load_so_plugin_platform_interface.dart';
import 'package:load_so_plugin/load_so_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockLoadSoPluginPlatform
    implements LoadSoPluginPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final LoadSoPluginPlatform initialPlatform = LoadSoPluginPlatform.instance;

  test('$MethodChannelLoadSoPlugin is the default instance', () {
    expect(initialPlatform, isA<MethodChannelLoadSoPlugin>());
  });

  test('getPlatformVersion', () async {
    LoadSoPlugin loadSoPlugin = LoadSoPlugin();
    MockLoadSoPluginPlatform fakePlatform = MockLoadSoPluginPlatform();
    LoadSoPluginPlatform.instance = fakePlatform;

    expect(await loadSoPlugin.getPlatformVersion(), '42');
  });
}
