import 'dart:js_interop';

@JS('PhoneNumberServer')
@staticInterop
class PhoneNumberServer {
  external factory PhoneNumberServer();
}

extension PhoneNumberServerApi on PhoneNumberServer {
  external JSString? getConnection();

  external void setLoggerEnable(bool isEnable);

  external JSString? getVersion();

  external void checkAuthAvailable(AliAuthWebParams params);

  external void getVerifyToken(AliAuthWebParams params);
}

@JS()
@anonymous
@staticInterop
class AliAuthWebParams {
  external factory AliAuthWebParams({
    String? accessToken,
    String? jwtToken,
    JSFunction? success,
    JSFunction? error,
  });
}

/// Dart wrapper around Alibaba Cloud's global `PhoneNumberServer` Web SDK.
class AliAuthPluginWebApi {
  AliAuthPluginWebApi({PhoneNumberServer? server})
      : _server = server ?? PhoneNumberServer();

  final PhoneNumberServer _server;

  Future<String?> getConnection() async => _server.getConnection()?.toDart;

  Future<void> setLoggerEnable(bool isEnable) async {
    _server.setLoggerEnable(isEnable);
  }

  Future<String?> getVersion() async => _server.getVersion()?.toDart;

  Future<void> checkAuthAvailable(
    String accessToken,
    String jwtToken,
    void Function(dynamic) success,
    void Function(dynamic) error,
  ) async {
    _server.checkAuthAvailable(AliAuthWebParams(
      accessToken: accessToken,
      jwtToken: jwtToken,
      success: ((JSAny? value) => success(value?.dartify())).toJS,
      error: ((JSAny? value) => error(value?.dartify())).toJS,
    ));
  }

  Future<void> getVerifyToken(
    void Function(dynamic) success,
    void Function(dynamic) error,
  ) async {
    _server.getVerifyToken(AliAuthWebParams(
      success: ((JSAny? value) => success(value?.dartify())).toJS,
      error: ((JSAny? value) => error(value?.dartify())).toJS,
    ));
  }
}
