import 'dart:js_interop';

/// 上游保留的浏览器 JS 工具映射；不改变参数类型或添加隐式转换。
/// 调用 JSON.stringify 编码 [obj]；同步返回 JS 字符串，互操作异常向调用方传播。
@JS('JSON.stringify')
external String stringify(Object? obj);

/// 将 [obj] 原样交给浏览器 console.log；调用者负责避免输出凭据及业务隐私。
@JS('console.log')
external void log(Object? obj);

/// 将 [obj] 原样交给浏览器 alert，具有浏览器模态弹窗副作用；无异步结果。
@JS('alert')
external void alert(Object? obj);

// 注意：新版 Dart 会自动将 JS 的 Promise 对象转换为 Dart 的 Future，
// 因此无需再自定义 PromiseJsImpl、ThenableJsImpl 等包装类。
// 如果原代码中有以下场景：
//   - 调用返回 Promise 的 JS 函数，可直接声明为返回 Future<T>。
//   - 手动创建 Promise，可通过 JS 的 Promise 构造函数 callAsConstructor 实现（通常不必要）。
//   - 将 Dart 函数作为回调传递给 JS，使用 .toJS 扩展方法转换。

// 示例：假设 JS 端有一个返回 Promise 的函数
// @JS('someAsyncFunction')
// external Future<String> someAsyncFunction();

// 示例：将 Dart 回调转换为 JS 函数
// void someJsFunction(JSFunction callback) { ... }
// final jsCallback = (String msg) { print(msg); }.toJS;
// someJsFunction(jsCallback);
