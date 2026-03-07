import 'package:flutter/material.dart';
import 'calculate.dart';
import 'package:load_so_plugin/load_so_plugin.dart';
import 'performance_test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SO加载示例',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flutter SO加载示例'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Flutter FFI 示例'),
            Tab(text: 'Flutter Android插件示例'),
            Tab(text: '性能对比测试'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          FFIExamplePage(),
          PluginExamplePage(),
          PerformanceTestPage(),
        ],
      ),
    );
  }
}

class FFIExamplePage extends StatefulWidget {
  const FFIExamplePage({super.key});

  @override
  State<FFIExamplePage> createState() => _FFIExamplePageState();
}

class _FFIExamplePageState extends State<FFIExamplePage> {
  late Calculate _calculate;
  String _result = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initCalculate();
  }

  void _initCalculate() {
    try {
      _calculate = Calculate();
      setState(() {
        _isLoading = false;
        _result = '原生库加载成功！';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _result = '加载原生库出错: $e';
      });
    }
  }

  void _testAdd() {
    if (_isLoading) return;
    final result = _calculate.add(10, 5);
    setState(() {
      _result = '10 + 5 = $result';
    });
  }

  void _testSubtract() {
    if (_isLoading) return;
    final result = _calculate.subtract(10, 5);
    setState(() {
      _result = '10 - 5 = $result';
    });
  }

  void _testMultiply() {
    if (_isLoading) return;
    final result = _calculate.multiply(10, 5);
    setState(() {
      _result = '10 × 5 = $result';
    });
  }

  void _testDivide() {
    if (_isLoading) return;
    final result = _calculate.divide(10, 5);
    setState(() {
      _result = '10 ÷ 5 = $result';
    });
  }

  void _testConcat() {
    if (_isLoading) return;
    final result = _calculate.concat('你好, ', '世界!');
    setState(() {
      _result = '字符串拼接: "$result"';
    });
  }

  void _testSumArray() {
    if (_isLoading) return;
    final arr = [1, 2, 3, 4, 5];
    final result = _calculate.sumArray(arr);
    setState(() {
      _result = '数组 $arr 的和 = $result';
    });
  }

  void _testMaxArray() {
    if (_isLoading) return;
    final arr = [3, 1, 4, 1, 5, 9, 2, 6];
    final result = _calculate.maxArray(arr);
    setState(() {
      _result = '数组 $arr 的最大值 = $result';
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildTestPage('FFI测试结果', _result, _isLoading, [
      _testAdd,
      _testSubtract,
      _testMultiply,
      _testDivide,
      _testConcat,
      _testSumArray,
      _testMaxArray,
    ], [
      '测试加法',
      '测试减法',
      '测试乘法',
      '测试除法',
      '测试字符串拼接',
      '测试数组求和',
      '测试数组最大值',
    ]);
  }
}

class PluginExamplePage extends StatefulWidget {
  const PluginExamplePage({super.key});

  @override
  State<PluginExamplePage> createState() => _PluginExamplePageState();
}

class _PluginExamplePageState extends State<PluginExamplePage> {
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
      final message = await _plugin.getMessage();
      setState(() {
        _isLoading = false;
        _result = message;
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
    return _buildTestPage('Android插件测试结果', _result, _isLoading, [
      _testAdd,
      _testSubtract,
      _testMultiply,
      _testDivide,
      _testConcat,
      _testSumArray,
      _testMaxArray,
    ], [
      '测试加法',
      '测试减法',
      '测试乘法',
      '测试除法',
      '测试字符串拼接',
      '测试数组求和',
      '测试数组最大值',
    ]);
  }
}

Widget _buildTestPage(
  String title,
  String result,
  bool isLoading,
  List<VoidCallback> callbacks,
  List<String> buttonLabels,
) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
            result,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 40),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: List.generate(
            callbacks.length,
            (index) => ElevatedButton(
              onPressed: isLoading ? null : callbacks[index],
              child: Text(buttonLabels[index]),
            ),
          ),
        ),
      ],
    ),
  );
}
