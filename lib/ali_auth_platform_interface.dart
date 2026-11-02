import 'package:ali_auth_spm/ali_auth_model.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'ali_auth_method_channel.dart'
    if (dart.library.html) "ali_auth_web.dart";

abstract class AliAuthPlatform extends PlatformInterface {
  /// Constructs a AliAuthPlatform.
  AliAuthPlatform() : super(token: _token);

  static final Object _token = Object();

  static AliAuthPlatform _instance = MethodChannelAliAuth();

  /// The default instance of [AliAuthPlatform] to use.
  ///
  /// Defaults to [MethodChannelAliAuth].
  static AliAuthPlatform get instance => _instance;

  Future? get appleLogin => null;

  Future? get checkCellularDataEnable => null;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AliAuthPlatform] when
  /// they register themselves.
  static set instance(AliAuthPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> getSdkVersion() {
    throw UnimplementedError('getSdkVersion() has not been implemented.');
  }

  Stream? onChange({bool type = true}) {
    throw UnimplementedError('onChange() has not been implemented.');
  }

  void resume() {
    throw UnimplementedError('resume() has not been implemented.');
  }

  void dispose() {
    throw UnimplementedError('dispose() has not been implemented.');
  }

  void pause() {
    throw UnimplementedError('pause() has not been implemented.');
  }

  Future<void> openPage(String? pageRoute) {
    throw UnimplementedError('openPage() has not been implemented.');
  }

  Future<void> quitPage() {
    throw UnimplementedError('quitPage() has not been implemented.');
  }

  Future<void> checkEnvAvailable() {
    throw UnimplementedError('checkEnvAvailable() has not been implemented.');
  }

  Future<void> queryCheckBoxIsChecked() {
    throw UnimplementedError(
        'queryCheckBoxIsChecked() has not been implemented.');
  }

  Future<void> setCheckboxIsChecked() {
    throw UnimplementedError(
        'setCheckboxIsChecked() has not been implemented.');
  }

  Future<void> hideLoading() {
    throw UnimplementedError('quitPage() has not been implemented.');
  }

  Future<String> getCurrentCarrierName() {
    throw UnimplementedError('quitPage() has not been implemented.');
  }

  Future login({int timeout = 5000}) {
    throw UnimplementedError('login() has not been implemented.');
  }

  Future initSdk(AliAuthModel? config) {
    throw UnimplementedError('login() has not been implemented.');
  }

  void loginListen(
      {bool type = true,
      required Function onEvent,
      Function? onError,
      isOnlyOne = true}) {
    throw UnimplementedError('loginListen() has not been implemented.');
  }

  /// 返回平台网络类型；未覆写时抛出上游 UnimplementedError，不创建资源。
  Future<String?> getConnection() {
    throw UnimplementedError('getSdkVersion() has not been implemented.');
  }

  /// 将 [isEnable] 交给具体平台设置 SDK 日志；默认实现抛出 UnimplementedError。
  Future<void> setLoggerEnable(bool isEnable) {
    throw UnimplementedError('getSdkVersion() has not been implemented.');
  }

  /// 提交 Web 鉴权；[accessToken] 和 [jwtToken] 来自宿主服务端，不在此处保存。
  ///
  /// [success]、[error] 由具体平台在 SDK 回调时调用；Web 传递原始 JS 对象。
  /// Future 不表示业务回调已完成；默认实现以 UnimplementedError 失败。
  Future<void> checkAuthAvailable(String accessToken, String jwtToken,
      Function(dynamic) success, Function(dynamic) error) async {
    throw UnimplementedError('getSdkVersion() has not been implemented.');
  }

  /// 提交 Web 校验取号；[success]、[error] 接收平台原始结果，由宿主管理业务处理。
  ///
  /// 鉴权前置条件由调用方保证；Future 仅表示提交调用，默认以 UnimplementedError 失败。
  Future<void> getVerifyToken(
      Function(dynamic) success, Function(dynamic) error) async {
    throw UnimplementedError('getSdkVersion() has not been implemented.');
  }
}
