import 'package:ali_auth_spm/ali_auth_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:ali_auth_spm/ali_auth_enum.dart';
import 'dart:convert';
import 'dart:io';

/// 检查 SDK 配置的精确序列化及平台通道编码，不调用真实认证服务。
void main() {
  test('complete emitted key set matches pinned upstream 712747d', () {
    final baseline = jsonDecode(
        File('test/fixtures/upstream_1_4_0_config_keys.json')
            .readAsStringSync()) as Map<String, dynamic>;
    final expected = (baseline['keys'] as List<dynamic>).cast<String>().toSet();
    expect(AliAuthModel('android', 'ios').toJson().keys.toSet(), expected);
  });
  test('upstream controls the emitted configuration keys', () {
    const ignored = {
      'privacyOffsetX',
      'protocolOwnThreeColor',
      'privacyAlertOperatorColor'
    };
    final json = AliAuthModel('android', 'ios',
            privacyOffsetX: 24,
            protocolOwnThreeColor: '#ff123456',
            privacyAlertOperatorColor: '#ff234567')
        .toJson();
    expect(json.keys.toSet().intersection(ignored), isEmpty);
    expect(json, AliAuthModel('android', 'ios').toJson());
    expect(() => const StandardMessageCodec().encodeMessage(json),
        returnsNormally);
  });
  test('serializes HarmonyOS secret without changing positional secrets', () {
    final model = AliAuthModel(null, null, ohosSk: 'ohos-secret');

    expect(model.androidSk, isNull);
    expect(model.iosSk, isNull);
    expect(model.toJson()['ohosSk'], 'ohos-secret');

    final legacyModel = AliAuthModel('android-secret', 'ios-secret');
    expect(legacyModel.toJson()['androidSk'], 'android-secret');
    expect(legacyModel.toJson()['iosSk'], 'ios-secret');
    expect(legacyModel.toJson()['ohosSk'], isNull);
  });
  test('new UI settings and direction remain platform-channel encodable', () {
    final model = AliAuthModel(
      'android',
      'ios',
      authPageCrossFade: true,
      logBtnTextBold: true,
      logBtnBackgroundColor: '#123456',
      logBtnCornerRadius: 12,
      switchAccButtonWidth: 240,
      switchAccButtonHeight: 48,
      presentDirection: PNSPresentationDirection.presentationDirectionRight,
    );
    final json = model.toJson();
    expect(() => const StandardMessageCodec().encodeMessage(json),
        returnsNormally);
    expect(json['authPageCrossFade'], isTrue);
    expect(json['logBtnTextBold'], isTrue);
    expect(json['logBtnBackgroundColor'], '#123456');
    expect(json['logBtnCornerRadius'], 12);
    expect(json['switchAccButtonWidth'], 240);
    expect(json['switchAccButtonHeight'], 48);
    expect(json['presentDirection'],
        PNSPresentationDirection.presentationDirectionRight.index);
  });
}
