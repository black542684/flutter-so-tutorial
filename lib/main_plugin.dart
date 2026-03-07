import 'package:flutter/material.dart';
import 'package:load_so_plugin/load_so_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Android插件示例',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Android插件调用示例'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _plugin = LoadSoPlugin();
  String _result = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initPlugin();
  }

  void _initPlugin() async {
    try {
      final version = await _plugin.getPlatformVersion();
      setState(() {
        _isLoading = false;
        _result = '插件加载成功！平台版本: $version';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _result = '加载插件出错: $e';
      });
    }
  }

  void _testAdd() async {
    if (_isLoading) return;
    final result = await _plugin.add(10, 5);
    setState(() {
      _result = '10 + 5 = $result';
    });
  }

  void _testSubtract() async {
    if (_isLoading) return;
    final result = await _plugin.subtract(10, 5);
    setState(() {
      _result = '10 - 5 = $result';
    });
  }

  void _testMultiply() async {
    if (_isLoading) return;
    final result = await _plugin.multiply(10, 5);
    setState(() {
      _result = '10 × 5 = $result';
    });
  }

  void _testDivide() async {
    if (_isLoading) return;
    final result = await _plugin.divide(10, 5);
    setState(() {
      _result = '10 ÷ 5 = $result';
    });
  }

  void _testConcat() async {
    if (_isLoading) return;
    final result = await _plugin.concat('你好, ', '世界!');
    setState(() {
      _result = '字符串拼接: "$result"';
    });
  }

  void _testSumArray() async {
    if (_isLoading) return;
    final arr = [1, 2, 3, 4, 5];
    final result = await _plugin.sumArray(arr);
    setState(() {
      _result = '数组 $arr 的和 = $result';
    });
  }

  void _testMaxArray() async {
    if (_isLoading) return;
    final arr = [3, 1, 4, 1, 5, 9, 2, 6];
    final result = await _plugin.maxArray(arr);
    setState(() {
      _result = '数组 $arr 的最大值 = $result';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Android插件测试结果:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _result,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _testAdd,
                  child: const Text('测试加法'),
                ),
                ElevatedButton(
                  onPressed: _testSubtract,
                  child: const Text('测试减法'),
                ),
                ElevatedButton(
                  onPressed: _testMultiply,
                  child: const Text('测试乘法'),
                ),
                ElevatedButton(
                  onPressed: _testDivide,
                  child: const Text('测试除法'),
                ),
                ElevatedButton(
                  onPressed: _testConcat,
                  child: const Text('测试字符串拼接'),
                ),
                ElevatedButton(
                  onPressed: _testSumArray,
                  child: const Text('测试数组求和'),
                ),
                ElevatedButton(
                  onPressed: _testMaxArray,
                  child: const Text('测试数组最大值'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
