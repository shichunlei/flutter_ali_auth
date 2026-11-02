import 'dart:js_interop';
import 'dart:js_interop_unsafe';

/// 浏览器中由阿里 SDK 脚本提供的原生对象；脚本必须在创建包装器前加载。
///
/// ```dart
/// import 'package:ali_auth_spm/ali_auth_web_api.dart';
/// final server = PhoneNumberServer();
/// final versionPromise = server.getVersion();
/// ```
/// 对象交给 JS 生命周期管理；此声明不加载脚本、不提供销毁或回调转换能力。
@JS('PhoneNumberServer')
@staticInterop
class PhoneNumberServer {
  /// 调用 JS 全局构造器创建 SDK 实例；未加载脚本时传播 JS 异常，不持有 Flutter 资源。
  external factory PhoneNumberServer();
}

/// 与上游 JS SDK 同名的互操作入口；Promise、JS 对象及回调所有权遵循 JS SDK。
extension PhoneNumberServerExtension on PhoneNumberServer {
  /// 返回 SDK 网络状态 Promise；由调用者转为 Future 并处理拒绝。
  external JSPromise<JSString?> getConnection();

  /// 设置 SDK 日志；[isEnable] 为 true 时启用，不保存独立日志状态。
  external void setLoggerEnable(bool isEnable);

  /// 返回 SDK 版本 Promise；同步 JS 异常与 Promise 拒绝交给调用者。
  external JSPromise<JSString?> getVersion();

  /// 提交 [params] 中的凭据和 JS 回调；返回不代表鉴权完成，结果由回调通知。
  external void checkAuthAvailable(JSObject params);

  /// 提交 [params] 中的取号回调；结果由 JS SDK 异步通知，不在互操作层缓存。
  external void getVerifyToken(JSObject params);
}

/// 上游号码认证 Web 包装器；持有一个 JS SDK 对象，保留原始 JS 回调数据。
///
/// ```dart
/// import 'package:ali_auth_spm/ali_auth_web_api.dart';
/// final api = AliAuthPluginWebApi();
/// final version = await api.getVersion();
/// final connection = await api.getConnection();
/// ```
/// SDK 脚本由宿主加载；没有注入构造器、自动日志或 Dart Map 转换。对象由 JS 生命周期
/// 管理，此包装器不注册长期监听或提供额外 dispose，凭据仅用于提交 SDK 调用。
class AliAuthPluginWebApi {
  /// 当前包装器拥有的 JS SDK 实例；在包装器创建时构造，不跨实例共享。
  final PhoneNumberServer _server = PhoneNumberServer();

  /// 等待 SDK 网络状态 Promise 并返回可空字符串；拒绝和互操作异常向上传播。
  Future<String?> getConnection() async {
    final result = await _server.getConnection().toDart;
    return result?.toDart;
  }

  /// 将 [isEnable] 传入 SDK 日志开关；Future 完成表示调用已提交，异常向上传播。
  Future<void> setLoggerEnable(bool isEnable) async {
    _server.setLoggerEnable(isEnable);
  }

  /// 等待 SDK 版本 Promise，返回可空字符串；异常不吞掉，不改变原始结果。
  Future<String?> getVersion() async {
    final result = await _server.getVersion().toDart;
    return result?.toDart;
  }

  /// 提交 [accessToken] 和 [jwtToken] 给 SDK，不记录或持久化凭据。
  ///
  /// [success] 和 [error] 接收 JS SDK 原始对象；调用方自行转换或释放相关闭包引用。
  /// Future 在提交调用后完成，不等候回调；同步互操作异常向上传播。
  Future<void> checkAuthAvailable(
    String accessToken,
    String jwtToken,
    void Function(JSAny? status) success,
    void Function(JSAny? status) error,
  ) async {
    // 将 Dart 回调转换为 JSFunction
    final jsSuccess = success.toJS;
    final jsError = error.toJS;

    final params = _buildParams(
      accessToken: accessToken,
      jwtToken: jwtToken,
      success: jsSuccess,
      error: jsError,
    );
    _server.checkAuthAvailable(params);
  }

  /// 已鉴权后提交取号请求；[success] 和 [error] 接收 SDK 原始 JS 结果。
  ///
  /// Future 不等待业务回调，不注册额外监听；同步互操作异常向上传播。
  Future<void> getVerifyToken(
    void Function(JSAny? status) success,
    void Function(JSAny? status) error,
  ) async {
    final jsSuccess = success.toJS;
    final jsError = error.toJS;

    final params = _buildParams(
      success: jsSuccess,
      error: jsError,
    );
    _server.getVerifyToken(params);
  }

  /// 构建独立 JS 参数对象；[accessToken]、[jwtToken] 为 null 时省略凭据键。
  ///
  /// [success]、[error] 为已有 JS 回调，为 null 时省略相应键；返回对象由本次 SDK 调用
  /// 及 JS 生命周期持有，不写入全局对象或持久化存储，不等待回调。
  JSObject _buildParams({
    String? accessToken,
    String? jwtToken,
    JSFunction? success,
    JSFunction? error,
  }) {
    final obj = JSObject();
    if (accessToken != null) obj['accessToken'] = accessToken.toJS;
    if (jwtToken != null) obj['jwtToken'] = jwtToken.toJS;
    if (success != null) obj['success'] = success;
    if (error != null) obj['error'] = error;
    return obj;
  }
}
