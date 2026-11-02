@TestOn('browser')
library;

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:ali_auth_spm/ali_auth_web.dart';
import 'package:ali_auth_spm/ali_auth_web_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late JSObject server;
  late AliAuthPluginWebApi api;

  setUp(() {
    server = JSObject();
    api = AliAuthPluginWebApi(server: server as PhoneNumberServer);
  });

  test('awaits SDK version and connection promises', () async {
    server['getVersion'] = (() => Future.value('2.1.15'.toJS).toJS).toJS;
    server['getConnection'] = (() => Future.value('4G'.toJS).toJS).toJS;
    expect(await api.getVersion(), '2.1.15');
    expect(await api.getConnection(), '4G');
  });

  test('passes credentials and converts SDK callback objects to Dart',
      () async {
    server['checkAuthAvailable'] = ((JSObject params) {
      expect(params['accessToken']?.dartify(), 'access');
      expect(params['jwtToken']?.dartify(), 'jwt');
      (params['success'] as JSFunction).callAsFunction(
        null,
        {
          'code': 'success',
          'nested': {'available': true}
        }.jsify(),
      );
    }).toJS;
    dynamic response;
    await api.checkAuthAvailable('access', 'jwt', (value) => response = value,
        (_) => fail('Unexpected authentication error'));
    expect(response, {
      'code': 'success',
      'nested': {'available': true}
    });

    server['getVerifyToken'] = ((JSObject params) {
      (params['error'] as JSFunction)
          .callAsFunction(null, {'code': 'expired'}.jsify());
    }).toJS;
    await api.getVerifyToken(
        (_) => fail('Unexpected token success'), (value) => response = value);
    expect(response, {'code': 'expired'});
  });

  test('Web rejects native login explicitly and allows dispose', () async {
    final plugin = AliAuthPluginWeb(api: api);
    await expectLater(plugin.login(), throwsUnsupportedError);
    await expectLater(plugin.checkEnvAvailable(), throwsUnsupportedError);
    expect(plugin.dispose, returnsNormally);
  });
}
