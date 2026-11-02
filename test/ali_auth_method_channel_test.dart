import 'package:ali_auth_spm/ali_auth_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:ali_auth_spm/ali_auth_enum.dart';

void main() {
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
