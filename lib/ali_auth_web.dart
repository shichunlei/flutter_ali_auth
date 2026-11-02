import 'dart:js_interop';
import 'dart:ui_web' as ui;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'ali_auth_web_api.dart';
import 'ali_auth_platform_interface.dart';
import 'ali_auth_model.dart';
export 'ali_auth_method_channel.dart';

/// 上游 Web 平台实现；只支持号码校验，原生一键登录接口按上游抛出 UnsupportedError。
///
/// ```dart
/// import 'package:ali_auth_spm/ali_auth_web.dart';
/// final plugin = AliAuthPluginWeb(); // 宿主需先加载 PhoneNumberServer SDK 脚本。
/// final version = await plugin.getSdkVersion();
/// plugin.dispose(); // 上游 Web dispose 为空实现。
/// ```
/// 包装器拥有一个 JS SDK 门面；结果保留原始 JS 数据，不创建 Flutter 页面或原生监听。
/// 正常应用由 Flutter 自动调用 registerWith，不应重复注册平台单例。
class AliAuthPluginWeb extends AliAuthPlatform {
  /// 创建 Web 平台实例并初始化 JS 门面；SDK 全局对象未加载时传播 JS 异常。
  AliAuthPluginWeb();

  /// 本实例持有的上游 JS 门面，可按上游公开字段契约替换；不跨平台实例共享。
  AliAuthPluginWebApi aliAuthPluginWebApi = AliAuthPluginWebApi();

  /// 由 Flutter 使用 [registrar] 注册本平台单例；参数由框架提供，本实现不持有它。
  ///
  /// 创建 SDK 门面并替换 AliAuthPlatform.instance；重复调用会替换前一实例。
  static void registerWith(Registrar registrar) {
    AliAuthPlatform.instance = AliAuthPluginWeb();
  }

  /// 返回上游 BrowserDetection 的可空 debugUserAgentOverride；不自行读取 navigator.userAgent。
  @override
  Future<String?> getPlatformVersion() async {
    final version = ui.BrowserDetection.instance.debugUserAgentOverride;
    return version;
  }

  /// 等待 SDK 版本 Promise；返回可空字符串，异常向上传播。
  @override
  Future<String?> getSdkVersion() async {
    return await aliAuthPluginWebApi.getVersion();
  }

  /// 等待 SDK 网络状态 Promise；返回可空字符串，异常向上传播。
  @override
  Future<String?> getConnection() async {
    return await aliAuthPluginWebApi.getConnection();
  }

  /// 将 [isEnable] 交给 SDK 日志开关，Future 完成表示调用已提交，不维护额外状态。
  @override
  Future<void> setLoggerEnable(bool isEnable) async {
    return await aliAuthPluginWebApi.setLoggerEnable(isEnable);
  }

  /// [accessToken] 和 [jwtToken] 直接提交 SDK；[success]、[error] 接收原始 JS 对象。
  /// Future 保持上游提交语义，不等待业务回调，不记录凭据或隐式转为 Dart Map。
  @override
  Future<void> checkAuthAvailable(String accessToken, String jwtToken,
      Function(dynamic) success, Function(dynamic) error) async {
    aliAuthPluginWebApi.checkAuthAvailable(accessToken, jwtToken,
        (JSAny? status) => success(status), (JSAny? status) => error(status));
  }

  /// 提交已鉴权后的校验请求；[success]、[error] 接收原始 JS 对象。
  /// Future 不等待业务回调，宿主自行管理结果转换，异常语义保持上游实现。
  @override
  Future<void> getVerifyToken(
      Function(dynamic) success, Function(dynamic) error) async {
    aliAuthPluginWebApi.getVerifyToken(
        (JSAny? status) => success(status), (JSAny? status) => error(status));
  }

  // ========== Web 不支持的接口（一键登录仅限移动端） ==========

  /// Web 不支持原生初始化；[config]（包括 null）不会被读取，Future 以 UnsupportedError 失败。
  @override
  Future<dynamic> initSdk(AliAuthModel? config) async {
    throw UnsupportedError(
        'initSdk 仅支持 Android/iOS 平台，Web 端请使用 checkAuthAvailable + getVerifyToken 进行号码校验');
  }

  /// Web 不支持一键登录；[timeout] 单位 ms、默认 5000，在抛出 UnsupportedError 前不会消费。
  @override
  Future<dynamic> login({int timeout = 5000}) async {
    throw UnsupportedError('login 仅支持 Android/iOS 平台，Web 端不支持一键登录');
  }

  /// Web 不创建原生授权页；返回以 UnsupportedError 失败的 Future。
  @override
  Future<void> quitPage() async {
    throw UnsupportedError('quitPage 仅支持 Android/iOS 平台');
  }

  /// Web 不持有原生 loading；返回以 UnsupportedError 失败的 Future。
  @override
  Future<void> hideLoading() async {
    throw UnsupportedError('hideLoading 仅支持 Android/iOS 平台');
  }

  /// Web 不提供原生运营商查询；返回以 UnsupportedError 失败的 Future。
  @override
  Future<String> getCurrentCarrierName() async {
    throw UnsupportedError(
        'getCurrentCarrierName 仅支持 Android/iOS 平台，Web 端无运营商信息');
  }

  /// Web 不导航到原生协议页；[pageRoute]（可为 null）不被消费，Future 以 UnsupportedError 失败。
  @override
  Future<void> openPage(String? pageRoute) async {
    throw UnsupportedError('openPage 仅支持 Android/iOS 平台');
  }

  /// Web 不提供原生蜂窝数据检测；访问后 Future 以 UnsupportedError 失败。
  @override
  Future<dynamic> get checkCellularDataEnable async {
    throw UnsupportedError('checkCellularDataEnable 仅支持 Android/iOS 平台');
  }

  /// Web 不提供原生 Apple 登录；访问后 Future 以 UnsupportedError 失败。
  @override
  Future<dynamic> get appleLogin async {
    throw UnsupportedError('appleLogin 仅支持 iOS 平台');
  }

  /// Web 不创建原生事件流；[type] 默认 true、不被消费，同步抛出 UnsupportedError。
  @override
  Stream<dynamic>? onChange({bool type = true}) {
    throw UnsupportedError('onChange 仅支持 Android/iOS 平台');
  }

  /// Web 不注册原生监听；[type] 默认 true，[onEvent] 必填，[onError] 可空，
  /// [isOnlyOne] 默认 true；所有参数均不被消费，回调不会执行，同步抛出 UnsupportedError。
  @override
  void loginListen(
      {bool type = true,
      required Function onEvent,
      Function? onError,
      isOnlyOne = true}) {
    throw UnsupportedError('loginListen 仅支持 Android/iOS 平台');
  }

  /// Web 没有原生事件订阅可暂停；同步抛出 UnsupportedError。
  @override
  void pause() {
    throw UnsupportedError('pause 仅支持 Android/iOS 平台');
  }

  /// Web 没有原生事件订阅可恢复；同步抛出 UnsupportedError。
  @override
  void resume() {
    throw UnsupportedError('resume 仅支持 Android/iOS 平台');
  }

  /// 保持上游 Web 空释放语义：不执行注销、关闭 SDK 或清空平台单例，不返回异步任务。
  @override
  void dispose() {
    // Web 端无需清理，空实现
  }

  /// Web 不执行原生取号环境检测；返回以 UnsupportedError 失败的 Future。
  @override
  Future<void> checkEnvAvailable() async {
    throw UnsupportedError('checkEnvAvailable 仅支持 Android/iOS 平台');
  }

  /// Web 无原生协议勾选状态；返回以 UnsupportedError 失败的 Future。
  @override
  Future<void> queryCheckBoxIsChecked() async {
    throw UnsupportedError('queryCheckBoxIsChecked 仅支持 Android/iOS 平台');
  }

  /// Web 不修改原生协议勾选状态；返回以 UnsupportedError 失败的 Future。
  @override
  Future<void> setCheckboxIsChecked() async {
    throw UnsupportedError('setCheckboxIsChecked 仅支持 Android/iOS 平台');
  }
}
