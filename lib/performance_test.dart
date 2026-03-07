import 'package:flutter/material.dart';
import 'calculate.dart';
import 'package:load_so_plugin/load_so_plugin.dart';
import 'dart:math';

class PerformanceTestPage extends StatefulWidget {
  const PerformanceTestPage({super.key});

  @override
  State<PerformanceTestPage> createState() => _PerformanceTestPageState();
}

class _PerformanceTestPageState extends State<PerformanceTestPage> {
  final _plugin = LoadSoPlugin();
  late Calculate _calculate;
  bool _isInitialized = false;
  String _initError = '';

  List<TestResult> _results = [];
  bool _isRunning = false;
  int _iterations = 100000;

  @override
  void initState() {
    super.initState();
    _initCalculate();
  }

  void _initCalculate() {
    try {
      _calculate = Calculate();
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      setState(() {
        _initError = '初始化失败: $e';
      });
    }
  }

  Future<void> _runDartTest() async {
    if (_isRunning) return;
    setState(() {
      _isRunning = true;
      // _results = [];
    });

    try {
      final stopwatch = Stopwatch()..start();
      int result = 0;

      for (int i = 0; i < _iterations; i++) {
        result += (i * 2 + 1) % 100;
      }

      final elapsed = stopwatch.elapsedMilliseconds;

      setState(() {
        _isRunning = false;
        _results.add(TestResult(
          name: 'Dart纯计算',
          time: elapsed,
          result: result,
          iterations: _iterations,
        ));
      });
    } catch (e) {
      setState(() {
        _isRunning = false;
        _results.add(TestResult(
          name: 'Dart纯计算',
          time: -1,
          result: 0,
          iterations: _iterations,
        ));
      });
    }
  }

  Future<void> _runFFITest() async {
    if (!_isInitialized) {
      setState(() {
        _initError = '请先初始化FFI库';
      });
      return;
    }

    if (_isRunning) return;
    setState(() {
      _isRunning = true;
      // _results = [];
    });

    try {
      final stopwatch = Stopwatch()..start();
      int result = 0;

      for (int i = 0; i < _iterations; i++) {
        result += _calculate.add(i * 2, 1) % 100;
      }

      final elapsed = stopwatch.elapsedMilliseconds;

      setState(() {
        _results.add(TestResult(
          name: 'FFI调用C函数',
          time: elapsed,
          result: result,
          iterations: _iterations,
        ));
        _isRunning = false;
      });
    } catch (e) {
      setState(() {
        _results.add(TestResult(
          name: 'FFI调用C函数',
          time: -1,
          result: 0,
          iterations: _iterations,
        ));
        _isRunning = false;
      });
    }
  }

  Future<void> _runPluginTest() async {
    if (_isRunning) return;
    setState(() {
      _isRunning = true;
      // _results = [];
    });

    final stopwatch = Stopwatch()..start();
    int result = 0;

    for (int i = 0; i < _iterations; i++) {
      final addResult = await _plugin.add(i * 2, 1);
      result = (result + addResult) % 100;
    }

    final elapsed = stopwatch.elapsedMilliseconds;

    setState(() {
      _results.add(TestResult(
        name: 'Android插件方式',
        time: elapsed,
        result: result,
        iterations: _iterations,
      ));
      _isRunning = false;
    });
  }

  Future<void> _runAllTests() async {
    if (_isRunning) return;
    setState(() {
      _isRunning = true;
      _results = [];
    });

    await _runDartTest();
    await _runFFITest();
    await _runPluginTest();

    setState(() {
      _isRunning = false;
    });
  }

  void _clearResults() {
    setState(() {
      _results = [];
    });
  }

  String _getSpeedupFactor() {
    if (_results.length < 2) return 'N/A';

    final dartTime = _results.firstWhere((r) => r.name.contains('Dart')).time;
    final fastestTime = _results.map((r) => r.time).reduce(min);
    final speedup = (dartTime / fastestTime).toStringAsFixed(2);
    return '${speedup}x';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('性能对比测试'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _clearResults,
            tooltip: '清空结果',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSettingsCard(),
            const SizedBox(height: 16),
            _buildControlButtons(),
            const SizedBox(height: 16),
            _buildResultsCard(),
          ],
        ),
      ),
    );
  }

  // 构建测试设置卡片
  Widget _buildSettingsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '测试设置',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('迭代次数：'),
                const SizedBox(width: 8),
                Expanded(
                  child: Slider(
                    value: _iterations.toDouble(),
                    min: 1000,
                    max: 1000000,
                    divisions: 100,
                    label: '${_iterations}',
                    onChanged: (value) {
                      setState(() {
                        _iterations = value.toInt();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '当前设置：$_iterations 次运算',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  // 构建测试控制按钮卡片
  Widget _buildControlButtons() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '测试控制',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: _isRunning ? null : _runDartTest,
                  icon: const Icon(Icons.calculate),
                  label: Text('Dart纯计算'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _isRunning ? null : _runFFITest,
                  icon: const Icon(Icons.memory),
                  label: Text('FFI调用'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _isRunning ? null : _runPluginTest,
                  icon: const Icon(Icons.extension),
                  label: Text('插件方式'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isRunning ? null : _runAllTests,
                icon: const Icon(Icons.play_arrow),
                label: Text('运行全部测试'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 构建测试结果卡片
  Widget _buildResultsCard() {
    if (_results.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  '点击上方按钮开始测试',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '测试结果',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (_results.length >= 3)
                  Chip(
                    label: Text('性能提升: ${_getSpeedupFactor()}'),
                    backgroundColor: Colors.green.shade100,
                    avatar: const CircleAvatar(
                      child: Icon(Icons.speed, size: 20),
                      backgroundColor: Colors.green,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            ..._results.map((result) => _buildResultItem(result)),
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(TestResult result) {
    final isFastest = result.time == _results.map((r) => r.time).reduce(min);
    final isSlowest = result.time == _results.map((r) => r.time).reduce(max);

    Color getCardColor() {
      if (isFastest) return Colors.green.shade50;
      if (isSlowest) return Colors.red.shade50;
      return Colors.white;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: getCardColor(),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isFastest
              ? Colors.green
              : isSlowest
                  ? Colors.red
                  : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  result.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    if (isFastest)
                      const Chip(
                        label: Text('最快'),
                        backgroundColor: Colors.green,
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                    if (isSlowest)
                      const Chip(
                        label: Text('最慢'),
                        backgroundColor: Colors.red,
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('耗时：'),
                const SizedBox(width: 8),
                Text(
                  '${result.time}ms',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isFastest
                        ? Colors.green
                        : isSlowest
                            ? Colors.red
                            : Colors.black87,
                  ),
                ),
                const SizedBox(width: 16),
                const Text('迭代：'),
                const SizedBox(width: 8),
                Text(
                  '${result.iterations}次',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('结果：'),
                const SizedBox(width: 8),
                Text(
                  '${result.result}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('平均耗时：'),
                const SizedBox(width: 8),
                Text(
                  '${(result.time / result.iterations * 1000).toStringAsFixed(3)}μs',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TestResult {
  final String name;
  final int time;
  final int result;
  final int iterations;

  TestResult({
    required this.name,
    required this.time,
    required this.result,
    required this.iterations,
  });
}
