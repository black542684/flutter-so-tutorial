package com.example.load_so_plugin

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** LoadSoPlugin - Flutter插件的主类，负责处理Flutter与Android原生层的通信 */
class LoadSoPlugin :
    FlutterPlugin,
    MethodCallHandler {
    // MethodChannel用于Flutter和Android原生层之间的通信
    // 这个本地引用用于向Flutter引擎注册插件，并在Flutter引擎从Activity分离时注销它
    private lateinit var channel: MethodChannel

    // 当插件附加到Flutter引擎时调用
    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "load_so_plugin")
        channel.setMethodCallHandler(this)
    }

    // 处理来自Flutter的方法调用
    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        when (call.method) {
            "getPlatformVersion" -> {
                // 获取Android平台版本
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "getMessage" -> {
                // 获取来自SO库的消息
                result.success(getMessage())
            }
            "add" -> {
                // 加法运算
                val a = call.argument<Int>("a")
                val b = call.argument<Int>("b")
                if (a != null && b != null) {
                    result.success(add(a, b))
                } else {
                    result.error("INVALID_ARGUMENT", "Missing arguments", null)
                }
            }
            "subtract" -> {
                // 减法运算
                val a = call.argument<Int>("a")
                val b = call.argument<Int>("b")
                if (a != null && b != null) {
                    result.success(subtract(a, b))
                } else {
                    result.error("INVALID_ARGUMENT", "Missing arguments", null)
                }
            }
            "multiply" -> {
                // 乘法运算
                val a = call.argument<Int>("a")
                val b = call.argument<Int>("b")
                if (a != null && b != null) {
                    result.success(multiply(a, b))
                } else {
                    result.error("INVALID_ARGUMENT", "Missing arguments", null)
                }
            }
            "divide" -> {
                // 除法运算
                val a = call.argument<Int>("a")
                val b = call.argument<Int>("b")
                if (a != null && b != null) {
                    result.success(divide(a, b))
                } else {
                    result.error("INVALID_ARGUMENT", "Missing arguments", null)
                }
            }
            "concat" -> {
                // 字符串拼接
                val str1 = call.argument<String>("str1")
                val str2 = call.argument<String>("str2")
                if (str1 != null && str2 != null) {
                    result.success(concat(str1, str2))
                } else {
                    result.error("INVALID_ARGUMENT", "Missing arguments", null)
                }
            }
            "sumArray" -> {
                // 数组求和
                val arr = call.argument<List<Int>>("arr")
                if (arr != null) {
                    result.success(sumArray(arr.toIntArray()))
                } else {
                    result.error("INVALID_ARGUMENT", "Missing arguments", null)
                }
            }
            "maxArray" -> {
                // 数组求最大值
                val arr = call.argument<List<Int>>("arr")
                if (arr != null) {
                    result.success(maxArray(arr.toIntArray()))
                } else {
                    result.error("INVALID_ARGUMENT", "Missing arguments", null)
                }
            }
            else -> result.notImplemented()
        }
    }

    // 当插件从Flutter引擎分离时调用
    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    // 初始化块，加载SO库
    init {
        System.loadLibrary("plugin_lib")
    }

    // 声明native方法，这些方法在SO库中实现
    private external fun getMessage(): String
    private external fun add(a: Int, b: Int): Int
    private external fun subtract(a: Int, b: Int): Int
    private external fun multiply(a: Int, b: Int): Int
    private external fun divide(a: Int, b: Int): Int
    private external fun concat(str1: String, str2: String): String
    private external fun sumArray(arr: IntArray): Int
    private external fun maxArray(arr: IntArray): Int
}
