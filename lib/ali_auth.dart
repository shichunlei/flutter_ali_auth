import 'dart:async';
import 'ali_auth_model.dart';
import 'ali_auth_platform_interface.dart';

export 'ali_auth_enum.dart';
export 'ali_auth_model.dart';

/// 阿里云认证的上游静态入口；将配置和事件交由平台插件，宿主负责注销监听。
///
/// ```dart
/// import 'package:ali_auth_spm/ali_auth.dart';
///
/// Future<void> startAuth() async {
///   AliAuth.loginListen(onEvent: (dynamic event) {});
///   await AliAuth.initSdk(AliAuthModel('android-secret', 'ios-secret'));
/// }
///
/// Future<void> stopAuth() async {
///   await AliAuth.quitPage();
///   AliAuth.dispose();
/// }
/// ```
class AliAuth {
  /// 初始化监听
  static Stream<dynamic>? onChange({bool type = true}) {
    return AliAuthPlatform.instance.onChange(type: type);
  }

  /// 获取设备版本信息
  static Future<String?> get platformVersion async {
    return AliAuthPlatform.instance.getPlatformVersion();
  }

  /// 获取SDK版本号
  static Future<String?> get sdkVersion async {
    return AliAuthPlatform.instance.getSdkVersion();
  }

  /// 初始化SDK sk 必须
  /// isDialog 是否使用Dialog 弹窗登录 非必须 默认值false 非Dialog登录
  /// debug 是否开启调试模式 非必须 默认true 开启
  /// 使用一键登录传入 SERVICE_TYPE_LOGIN 2  使用号码校验传入 SERVICE_TYPE_AUTH  1 默认值 2
  static Future<dynamic> initSdk(AliAuthModel? config) async {
    return AliAuthPlatform.instance.initSdk(config);
  }

  /// 一键登录
  static Future<dynamic> login({int timeout = 5000}) async {
    return AliAuthPlatform.instance.login(timeout: timeout);
  }

  /// 强制关闭一键登录授权页面
  static Future<void> quitPage() async {
    return AliAuthPlatform.instance.quitPage();
  }

  /// 强制关闭Loading
  static Future<void> hideLoading() async {
    return AliAuthPlatform.instance.hideLoading();
  }

  /// 强制关闭一键登录授权页面
  static Future<String> getCurrentCarrierName() async {
    return AliAuthPlatform.instance.getCurrentCarrierName();
  }

  /// pageRoute
  static Future<void> openPage(String? pageRoute) async {
    return AliAuthPlatform.instance.openPage(pageRoute);
  }

  static Future<dynamic> get checkCellularDataEnable async {
    return AliAuthPlatform.instance.checkCellularDataEnable;
  }

  /// 苹果登录iOS专用
  static Future<dynamic> get appleLogin async {
    return AliAuthPlatform.instance.appleLogin;
  }

  /// 数据监听
  static void loginListen(
      {bool type = true,
      required Function onEvent,
      Function? onError,
      isOnlyOne = true}) async {
    return AliAuthPlatform.instance.loginListen(
        type: type, onEvent: onEvent, onError: onError, isOnlyOne: isOnlyOne);
  }

  /// 暂停
  static void pause() {
    return AliAuthPlatform.instance.pause();
  }

  /// 恢复
  static void resume() {
    return AliAuthPlatform.instance.resume();
  }

  /// 销毁监听
  static void dispose() {
    return AliAuthPlatform.instance.dispose();
  }

  /// Web 鉴权；[accessToken] 与 [jwtToken] 由宿主服务端签发，不记录或持久化。
  ///
  /// [success]、[error] 在 JS SDK 回调时接收原始 JS 对象，不隐式转换为 Dart Map。
  /// 返回的 Future 只表示请求已交给 JS SDK，不等待业务回调；同步互操作失败向上传播。
  static Future<void> checkAuthAvailable(String accessToken, String jwtToken,
      {required Function(dynamic) success,
      required Function(dynamic) error}) async {
    await AliAuthPlatform.instance
        .checkAuthAvailable(accessToken, jwtToken, success, error);
  }

  /// Web 取号校验；调用前应由宿主完成鉴权。
  ///
  /// [success]、[error] 接收 SDK 的原始 JS 结果，回调由宿主负责后续转换和业务处理。
  /// Future 仅表示已提交调用，不等待结果；JS 互操作失败向上传播，不注册额外监听。
  static Future<void> getVerifyToken(
      {required Function(dynamic) success,
      required Function(dynamic) error}) async {
    await AliAuthPlatform.instance.getVerifyToken(success, error);
  }
}
