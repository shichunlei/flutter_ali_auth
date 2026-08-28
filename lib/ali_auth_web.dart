import 'dart:js_interop';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'ali_auth_platform_interface.dart';
import 'ali_auth_web_api.dart';

export 'ali_auth_method_channel.dart';

/// Web implementation of [AliAuthPlatform].
class AliAuthPluginWeb extends AliAuthPlatform {
  AliAuthPluginWeb({AliAuthPluginWebApi? api})
      : _api = api ?? AliAuthPluginWebApi();

  final AliAuthPluginWebApi _api;

  static void registerWith(Registrar registrar) {
    AliAuthPlatform.instance = AliAuthPluginWeb();
  }

  @override
  Future<String?> getPlatformVersion() async => browserUserAgent;

  @override
  Future<String?> getSdkVersion() => _api.getVersion();

  @override
  Future<String?> getConnection() => _api.getConnection();

  @override
  Future<void> setLoggerEnable(bool isEnable) => _api.setLoggerEnable(isEnable);

  @override
  Future<void> checkAuthAvailable(
    String accessToken,
    String jwtToken,
    void Function(dynamic) success,
    void Function(dynamic) error,
  ) =>
      _api.checkAuthAvailable(accessToken, jwtToken, success, error);

  @override
  Future<void> getVerifyToken(
    void Function(dynamic) success,
    void Function(dynamic) error,
  ) =>
      _api.getVerifyToken(success, error);
}

@JS('navigator.userAgent')
external String? get browserUserAgent;
