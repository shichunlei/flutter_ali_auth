@TestOn('browser')
library;

import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:ui_web' as ui;

import 'package:ali_auth_spm/ali_auth_web.dart';
import 'package:ali_auth_spm/ali_auth_web_api.dart';
import 'package:flutter_test/flutter_test.dart';

/// 仅在测试浏览器注入 SDK 全局构造器；生产包装保持上游 API。
@JS('eval')
external JSAny? installSDKTestConstructor(JSString script);

/// 验证上游 Web Promise 和原始 JS 回调语义，不访问真实认证服务。
void main() {
  late JSObject server;
  late AliAuthPluginWebApi api;

  setUp(() {
    server = JSObject();
    globalContext['__aliAuthTestServer'] = server;
    installSDKTestConstructor(
        'globalThis.PhoneNumberServer = function() { return globalThis.__aliAuthTestServer; };'
            .toJS);
    api = AliAuthPluginWebApi();
  });

  tearDown(() {
    globalContext.delete('PhoneNumberServer'.toJS);
    globalContext.delete('__aliAuthTestServer'.toJS);
    ui.BrowserDetection.instance.debugUserAgentOverride = null;
  });

  test('platform version keeps upstream nullable debug override', () async {
    final plugin = AliAuthPluginWeb();
    expect(await plugin.getPlatformVersion(), isNull);
    ui.BrowserDetection.instance.debugUserAgentOverride = 'upstream-test-agent';
    expect(await plugin.getPlatformVersion(), 'upstream-test-agent');
  });

  test('awaits SDK version and connection promises', () async {
    server['getVersion'] = (() => Future.value('2.1.15'.toJS).toJS).toJS;
    server['getConnection'] = (() => Future.value('4G'.toJS).toJS).toJS;
    expect(await api.getVersion(), '2.1.15');
    expect(await api.getConnection(), '4G');
  });

  test('passes credentials and preserves raw SDK callback objects', () async {
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
    expect(response, isA<JSObject>());
    expect((response as JSAny).dartify(), {
      'code': 'success',
      'nested': {'available': true}
    });

    server['getVerifyToken'] = ((JSObject params) {
      (params['error'] as JSFunction)
          .callAsFunction(null, {'code': 'expired'}.jsify());
    }).toJS;
    await api.getVerifyToken(
        (_) => fail('Unexpected token success'), (value) => response = value);
    expect(response, isA<JSObject>());
    expect((response as JSAny).dartify(), {'code': 'expired'});
  });

  test('Web rejects native login explicitly and allows dispose', () async {
    final plugin = AliAuthPluginWeb();
    await expectLater(plugin.login(), throwsUnsupportedError);
    await expectLater(plugin.checkEnvAvailable(), throwsUnsupportedError);
    expect(plugin.dispose, returnsNormally);
  });
}
