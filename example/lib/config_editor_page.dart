import 'package:ali_auth_spm/ali_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 动态参数配置页面
/// 用户通过 UI 调整 AliAuthModel 所有参数，点击"应用配置"查看效果
class ConfigEditorPage extends StatefulWidget {
  const ConfigEditorPage({super.key});

  @override
  State<ConfigEditorPage> createState() => _ConfigEditorPageState();
}

class _ConfigEditorPageState extends State<ConfigEditorPage> {
  /// 所有参数统一存储
  late Map<String, dynamic> _config;

  /// 默认配置（AliAuthModel 构造器默认值）
  Map<String, dynamic> get _defaultConfig => {
    // 基本
    'androidSk': '',
    'iosSk': '',
    'isDebug': true,
    'isDelay': false,
    'pageType': PageType.fullPort.index,

    // 一、状态栏
    'statusBarColor': '',
    'lightColor': false,
    'isStatusBarHidden': false,
    'statusBarUIFlag': UIFAG.systemUiFalgFullscreen.index,
    'webViewStatusBarColor': '',

    // 二、导航栏
    'navHidden': false,
    'navColor': '',
    'navText': '',
    'navTextColor': '#000000',
    'navTextSize': 18,
    'navReturnImgPath': '',
    'navReturnHidden': false,
    'navReturnImgWidth': 30,
    'navReturnImgHeight': 30,
    'navReturnScaleType': ScaleType.center.index,
    'customReturnBtn_top': 20,
    'customReturnBtn_right': 0,
    'customReturnBtn_bottom': 0,
    'customReturnBtn_left': 20,
    'customReturnBtn_width': 40,
    'customReturnBtn_height': 40,
    'customReturnBtn_imgPath': '',
    'customReturnBtn_imgScaleType': ScaleType.centerCrop.index,
    'webNavColor': '',
    'webNavTextColor': '',
    'webNavTextSize': 20,
    'webNavReturnImgPath': '',

    // 三、Logo区
    'logoImgPath': '',
    'logoHidden': false,
    'logoWidth': 90,
    'logoHeight': 90,
    'logoOffsetY': -1,
    'logoOffsetY_B': -1,
    'logoScaleType': ScaleType.fitXy.index,

    // 四、Slogan区
    'sloganHidden': false,
    'sloganText': '',
    'sloganTextColor': '',
    'sloganTextSize': 16,
    'sloganOffsetY': -1,
    'sloganOffsetY_B': -1,

    // 五、掩码栏
    'numberColor': '',
    'numberSize': 28,
    'numFieldOffsetY': -1,
    'numFieldOffsetY_B': -1,
    'numberFieldOffsetX': 0,
    'numberLayoutGravity': Gravity.centerHorizntal.index,

    // 六、登录按钮
    'logBtnText': '本机一键登录',
    'logBtnTextColor': '',
    'logBtnTextSize': 16,
    'logBtnWidth': -1,
    'logBtnHeight': 51,
    'logBtnOffsetY': -1,
    'logBtnOffsetY_B': -1,
    'logBtnOffsetX': 0,
    'logBtnMarginLeftAndRight': 28,
    'logBtnLayoutGravity': Gravity.centerHorizntal.index,
    'logBtnBackgroundPath': '',
    'loadingImgPath': '',
    'logBtnToastHidden': false,

    // 七、切换按钮
    'switchAccHidden': false,
    'switchAccText': '切换到其他方式',
    'switchAccTextColor': '',
    'switchAccTextSize': 16,
    'switchOffsetY': -1,
    'switchOffsetY_B': -1,

    // 八、自定义控件
    'isHiddenCustom': false,
    'customThirdView_top': 0,
    'customThirdView_right': 0,
    'customThirdView_bottom': 0,
    'customThirdView_left': 0,
    'customThirdView_width': -1,
    'customThirdView_height': -1,
    'customThirdView_space': 20,
    'customThirdView_size': 16,
    'customThirdView_color': '#026ED2',
    'customThirdView_itemWidth': 50,
    'customThirdView_itemHeight': 50,
    'customThirdView_name1': '支付宝',
    'customThirdView_name2': '淘宝',
    'customThirdView_name3': '微博',
    'customThirdView_path1': 'assets/alipay.png',
    'customThirdView_path2': 'assets/taobao.png',
    'customThirdView_path3': 'assets/sina.png',

    // 九、协议栏
    'protocolOneName': '',
    'protocolOneURL': '',
    'protocolTwoName': '',
    'protocolTwoURL': '',
    'protocolThreeName': '',
    'protocolThreeURL': '',
    'protocolColor': '',
    'protocolCustomColor': '',
    'protocolOwnColor': '',
    'protocolOwnOneColor': '',
    'protocolOwnTwoColor': '',
    'protocolLayoutGravity': Gravity.centerHorizntal.index,
    'privacyState': false,
    'protocolGravity': Gravity.centerHorizntal.index,
    'privacyTextSize': 12,
    'privacyMargin': 28,
    'privacyBefore': '我已阅读并同意',
    'privacyEnd': '',
    'vendorPrivacyPrefix': '《',
    'vendorPrivacySuffix': '》',
    'uncheckedImgPath': '',
    'checkedImgPath': '',
    'checkBoxWidth': 18,
    'checkBoxHeight': 18,
    'checkboxHidden': false,
    'privacyOffsetY': -1,
    'privacyOffsetY_B': 28,
    'privacyOffsetX': -1,
    'privacyOperatorIndex': 0,
    'privacyConectTexts': '和,和,和',

    // 十、弹窗设置
    'dialogWidth': -1,
    'dialogHeight': -1,
    'dialogBottom': false,
    'dialogOffsetX': 0,
    'dialogOffsetY': 0,
    'dialogCornerRadiusArray': '10,10,10,10',
    'dialogAlpha': 1.0,
    'pageBackgroundRadius': 0,
    'tapAuthPageMaskClosePage': false,

    // 十一、全屏属性
    'pageBackgroundPath': 'assets/background_image.jpeg',
    'backgroundImageContentMode': ContentMode.scaleAspectFill.index,
    'backgroundColor': '#000000',
    'bottomNavColor': '',
    'bottomNavBarColor': '',
    'authPageActIn': '',
    'authPageActOut': '',
    'screenOrientation': -1,
    'fullScreen': false,
    'authPageUseDayLight': false,
    'keepAllPageHideNavigationBar': false,
    'closeAuthPageReturnBack': false,
    'autoQuitPage': true,

    // 十二、iOS弹窗
    'alertBarIsHidden': false,
    'alertTitleBarColor': '',
    'alertCloseItemIsHidden': false,
    'alertCloseImagePath': '',
    'alertCloseImageX': 0,
    'alertCloseImageY': 0,
    'alertCloseImageW': 45,
    'alertCloseImageH': 45,
    'alertBlurViewColor': '#000000',
    'alertBlurViewAlpha': 0.5,
    'presentDirection': 0,

    // 十三、二次隐私弹窗
    'privacyAlertIsNeedShow': false,
    'privacyAlertIsNeedAutoLogin': true,
    'privacyAlertWidth': -1,
    'privacyAlertHeight': -1,
    'privacyAlertOffsetX': 40,
    'privacyAlertOffsetY': -1,
    'privacyAlertTitleTextSize': 18,
    'privacyAlertTitleColor': '',
    'privacyAlertTitleBackgroundColor': '',
    'privacyAlertTitleAlignment': Gravity.centerHorizntal.index,
    'privacyAlertTitleOffsetX': 0,
    'privacyAlertTitleOffsetY': 20,
    'privacyAlertTitleContent': '请阅读并同意以下条款',
    'privacyAlertContentTextSize': 16,
    'privacyAlertContentBackgroundColor': '',
    'privacyAlertContentAlignment': 0,
    'privacyAlertContentColor': '',
    'privacyAlertContentBaseColor': '',
    'privacyAlertContentHorizontalMargin': 0,
    'privacyAlertContentVerticalMargin': 10,
    'privacyAlertProtocolNameUseUnderLine': false,
    'privacyAlertBtnText': '同意并登录',
    'privacyAlertBtnTextColor': '',
    'privacyAlertBtnTextSize': 18,
    'privacyAlertBtnWidth': -1,
    'privacyAlertBtnHeigth': -1,
    'privacyAlertBtnBackgroundImgPath': '',
    'privacyAlertBefore': '',
    'privacyAlertEnd': '',
    'privacyAlertCloseBtnShow': true,
    'privacyAlertCloseImagPath': '',
    'privacyAlertCloseScaleType': 0,
    'privacyAlertCloseImgWidth': 0,
    'privacyAlertCloseImgHeight': 0,
    'privacyAlertCornerRadiusArray': '10,10,10,10',
    'privacyAlertAlpha': 1.0,
    'privacyAlertBackgroundColor': '',
    'privacyAlertMaskIsNeedShow': true,
    'privacyAlertMaskAlpha': 0.5,
    'privacyAlertMaskColor': '#000000',
    'tapPrivacyAlertMaskCloseAlert': true,
    'privacyAlertOwnOneColor': '',
    'privacyAlertOwnTwoColor': '',
    'privacyAlertOwnThreeColor': '',
    'privacyAlertOperatorColor': '',
    'privacyAlertEntryAnimation': '',
    'privacyAlertExitAnimation': '',

    // 十四、Toast设置
    'isHideToast': false,
    'toastText': '请先阅读用户协议',
    'toastBackground': '#FF000000',
    'toastColor': '#FFFFFFFF',
    'toastPadding': 9,
    'toastMarginTop': 0,
    'toastMarginBottom': 0,
    'toastPositionMode': 'bottom',
    'toastDelay': 3,
  };

  @override
  void initState() {
    super.initState();
    _config = Map<String, dynamic>.from(_defaultConfig);
  }

  // ==================== 通用控件 ====================

  Widget _buildSectionTitle(String title, int count) {
    return Text('$title ($count项)', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500));
  }

  Widget _buildTextField(String key, String label, {String? hint, bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      child: Row(
        children: [
          SizedBox(width: 140, child: Text(label, style: const TextStyle(fontSize: 13))),
          const SizedBox(width: 4),
          Expanded(
            child: TextField(
              controller: TextEditingController(text: '${_config[key] ?? ''}'),
              keyboardType: isNumber ? TextInputType.number : TextInputType.text,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                border: const OutlineInputBorder(),
                hintText: hint,
              ),
              style: const TextStyle(fontSize: 12),
              onChanged: (v) {
                setState(() {
                  if (isNumber) {
                    if (v.contains('.')) {
                      _config[key] = double.tryParse(v) ?? 0;
                    } else {
                      _config[key] = int.tryParse(v) ?? 0;
                    }
                  } else {
                    _config[key] = v;
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitch(String key, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      child: Row(
        children: [
          SizedBox(width: 140, child: Text(label, style: const TextStyle(fontSize: 13))),
          const Spacer(),
          Switch(
            value: _config[key] == true,
            onChanged: (v) => setState(() => _config[key] = v),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>(String key, String label, List<T> items, String Function(T) labelFn) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      child: Row(
        children: [
          SizedBox(width: 140, child: Text(label, style: const TextStyle(fontSize: 13))),
          const SizedBox(width: 4),
          Expanded(
            child: DropdownButtonFormField<T>(
              initialValue: _config[key] as T,
              isDense: true,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                border: OutlineInputBorder(),
              ),
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(labelFn(e), style: const TextStyle(fontSize: 12)))).toList(),
              onChanged: (v) {
                if (v != null) setState(() => _config[key] = v);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ==================== 构建 AliAuthModel ====================

  AliAuthModel _buildModel() {
    final customThirdView = (_config['customThirdView_name1'] != null && '${_config['customThirdView_name1']}'.isNotEmpty)
        ? CustomThirdView(
      _config['customThirdView_top'],
      _config['customThirdView_right'],
      _config['customThirdView_bottom'],
      _config['customThirdView_left'],
      _config['customThirdView_width'],
      _config['customThirdView_height'],
      _config['customThirdView_space'],
      _config['customThirdView_size'],
      _config['customThirdView_color'],
      _config['customThirdView_itemWidth'],
      _config['customThirdView_itemHeight'],
      [for (int i = 1; i <= 3; i++)
        if ('${_config['customThirdView_name$i'] ?? ''}'.isNotEmpty) '${_config['customThirdView_name$i']}'],
      [for (int i = 1; i <= 3; i++)
        if ('${_config['customThirdView_path$i'] ?? ''}'.isNotEmpty) '${_config['customThirdView_path$i']}'],
    )
        : null;

    final customReturnBtn = ('${_config['customReturnBtn_imgPath'] ?? ''}'.isNotEmpty)
        ? CustomView(
      _config['customReturnBtn_top'],
      _config['customReturnBtn_right'],
      _config['customReturnBtn_bottom'],
      _config['customReturnBtn_left'],
      _config['customReturnBtn_width'],
      _config['customReturnBtn_height'],
      '${_config['customReturnBtn_imgPath']}',
      ScaleType.values[_config['customReturnBtn_imgScaleType'] as int? ?? ScaleType.centerCrop.index],
    )
        : null;

    final privacyConectTexts = '${_config['privacyConectTexts']}'.split(',');

    return AliAuthModel(
      '${_config['androidSk'] ?? ''}',
      '${_config['iosSk'] ?? ''}',
      isDebug: _config['isDebug'] as bool? ?? true,
      isDelay: _config['isDelay'] as bool? ?? false,
      pageType: PageType.values[_config['pageType'] as int? ?? PageType.fullPort.index],
      // 状态栏
      statusBarColor: '${_config['statusBarColor'] ?? ''}'.isEmpty ? null : '${_config['statusBarColor']}',
      lightColor: _config['lightColor'] as bool?,
      isStatusBarHidden: _config['isStatusBarHidden'] as bool?,
      statusBarUIFlag: UIFAG.values[_config['statusBarUIFlag'] as int? ?? UIFAG.systemUiFalgFullscreen.index],
      webViewStatusBarColor: '${_config['webViewStatusBarColor'] ?? ''}'.isEmpty ? null : '${_config['webViewStatusBarColor']}',
      // 导航栏
      navHidden: _config['navHidden'] as bool?,
      navColor: '${_config['navColor'] ?? ''}'.isEmpty ? null : '${_config['navColor']}',
      navText: '${_config['navText'] ?? ''}'.isEmpty ? null : '${_config['navText']}',
      navTextColor: '${_config['navTextColor'] ?? ''}'.isEmpty ? null : '${_config['navTextColor']}',
      navTextSize: _config['navTextSize'] as int?,
      navReturnImgPath: '${_config['navReturnImgPath'] ?? ''}'.isEmpty ? null : '${_config['navReturnImgPath']}',
      navReturnHidden: _config['navReturnHidden'] as bool?,
      navReturnImgWidth: _config['navReturnImgWidth'] as int?,
      navReturnImgHeight: _config['navReturnImgHeight'] as int?,
      customReturnBtn: customReturnBtn,
      navReturnScaleType: ScaleType.values[_config['navReturnScaleType'] as int? ?? ScaleType.center.index],
      webNavColor: '${_config['webNavColor'] ?? ''}'.isEmpty ? null : '${_config['webNavColor']}',
      webNavTextColor: '${_config['webNavTextColor'] ?? ''}'.isEmpty ? null : '${_config['webNavTextColor']}',
      webNavTextSize: _config['webNavTextSize'] as int?,
      webNavReturnImgPath: '${_config['webNavReturnImgPath'] ?? ''}'.isEmpty ? null : '${_config['webNavReturnImgPath']}',
      // Logo
      logoImgPath: '${_config['logoImgPath'] ?? ''}'.isEmpty ? null : '${_config['logoImgPath']}',
      logoHidden: _config['logoHidden'] as bool?,
      logoWidth: _config['logoWidth'] as int?,
      logoHeight: _config['logoHeight'] as int?,
      logoOffsetY: _config['logoOffsetY'] as int?,
      logoOffsetY_B: _config['logoOffsetY_B'] as int?,
      logoScaleType: ScaleType.values[_config['logoScaleType'] as int? ?? ScaleType.fitXy.index],
      // Slogan
      sloganHidden: _config['sloganHidden'] as bool?,
      sloganText: '${_config['sloganText'] ?? ''}'.isEmpty ? null : '${_config['sloganText']}',
      sloganTextColor: '${_config['sloganTextColor'] ?? ''}'.isEmpty ? null : '${_config['sloganTextColor']}',
      sloganTextSize: _config['sloganTextSize'] as int?,
      sloganOffsetY: _config['sloganOffsetY'] as int?,
      sloganOffsetY_B: _config['sloganOffsetY_B'] as int?,
      // 掩码栏
      numberColor: '${_config['numberColor'] ?? ''}'.isEmpty ? null : '${_config['numberColor']}',
      numberSize: _config['numberSize'] as int?,
      numFieldOffsetY: _config['numFieldOffsetY'] as int?,
      numFieldOffsetY_B: _config['numFieldOffsetY_B'] as int?,
      numberFieldOffsetX: _config['numberFieldOffsetX'] as int?,
      numberLayoutGravity: Gravity.values[_config['numberLayoutGravity'] as int? ?? Gravity.centerHorizntal.index],
      // 登录按钮
      logBtnText: '${_config['logBtnText'] ?? ''}'.isEmpty ? null : '${_config['logBtnText']}',
      logBtnTextColor: '${_config['logBtnTextColor'] ?? ''}'.isEmpty ? null : '${_config['logBtnTextColor']}',
      logBtnTextSize: _config['logBtnTextSize'] as int?,
      logBtnWidth: _config['logBtnWidth'] as int?,
      logBtnHeight: _config['logBtnHeight'] as int?,
      logBtnOffsetY: _config['logBtnOffsetY'] as int?,
      logBtnOffsetY_B: _config['logBtnOffsetY_B'] as int?,
      logBtnOffsetX: _config['logBtnOffsetX'] as int?,
      logBtnMarginLeftAndRight: _config['logBtnMarginLeftAndRight'] as int?,
      logBtnLayoutGravity: Gravity.values[_config['logBtnLayoutGravity'] as int? ?? Gravity.centerHorizntal.index],
      logBtnBackgroundPath: '${_config['logBtnBackgroundPath'] ?? ''}'.isEmpty ? null : '${_config['logBtnBackgroundPath']}',
      loadingImgPath: '${_config['loadingImgPath'] ?? ''}'.isEmpty ? null : '${_config['loadingImgPath']}',
      logBtnToastHidden: _config['logBtnToastHidden'] as bool?,
      // 切换按钮
      switchAccHidden: _config['switchAccHidden'] as bool?,
      switchAccText: '${_config['switchAccText'] ?? ''}'.isEmpty ? null : '${_config['switchAccText']}',
      switchAccTextColor: '${_config['switchAccTextColor'] ?? ''}'.isEmpty ? null : '${_config['switchAccTextColor']}',
      switchAccTextSize: _config['switchAccTextSize'] as int?,
      switchOffsetY: _config['switchOffsetY'] as int?,
      switchOffsetY_B: _config['switchOffsetY_B'] as int?,
      // 协议栏
      protocolOneName: '${_config['protocolOneName'] ?? ''}'.isEmpty ? null : '${_config['protocolOneName']}',
      protocolOneURL: '${_config['protocolOneURL'] ?? ''}'.isEmpty ? null : '${_config['protocolOneURL']}',
      protocolTwoName: '${_config['protocolTwoName'] ?? ''}'.isEmpty ? null : '${_config['protocolTwoName']}',
      protocolTwoURL: '${_config['protocolTwoURL'] ?? ''}'.isEmpty ? null : '${_config['protocolTwoURL']}',
      protocolThreeName: '${_config['protocolThreeName'] ?? ''}'.isEmpty ? null : '${_config['protocolThreeName']}',
      protocolThreeURL: '${_config['protocolThreeURL'] ?? ''}'.isEmpty ? null : '${_config['protocolThreeURL']}',
      protocolColor: '${_config['protocolColor'] ?? ''}'.isEmpty ? null : '${_config['protocolColor']}',
      protocolCustomColor: '${_config['protocolCustomColor'] ?? ''}'.isEmpty ? null : '${_config['protocolCustomColor']}',
      protocolOwnColor: '${_config['protocolOwnColor'] ?? ''}'.isEmpty ? null : '${_config['protocolOwnColor']}',
      protocolOwnOneColor: '${_config['protocolOwnOneColor'] ?? ''}'.isEmpty ? null : '${_config['protocolOwnOneColor']}',
      protocolOwnTwoColor: '${_config['protocolOwnTwoColor'] ?? ''}'.isEmpty ? null : '${_config['protocolOwnTwoColor']}',
      protocolLayoutGravity: Gravity.values[_config['protocolLayoutGravity'] as int? ?? Gravity.centerHorizntal.index],
      // 隐私条款
      privacyState: _config['privacyState'] as bool? ?? false,
      protocolGravity: Gravity.values[_config['protocolGravity'] as int? ?? Gravity.centerHorizntal.index],
      privacyTextSize: _config['privacyTextSize'] as int?,
      privacyMargin: _config['privacyMargin'] as int?,
      privacyBefore: '${_config['privacyBefore'] ?? ''}'.isEmpty ? null : '${_config['privacyBefore']}',
      privacyEnd: '${_config['privacyEnd'] ?? ''}'.isEmpty ? null : '${_config['privacyEnd']}',
      vendorPrivacyPrefix: '${_config['vendorPrivacyPrefix'] ?? ''}'.isEmpty ? null : '${_config['vendorPrivacyPrefix']}',
      vendorPrivacySuffix: '${_config['vendorPrivacySuffix'] ?? ''}'.isEmpty ? null : '${_config['vendorPrivacySuffix']}',
      uncheckedImgPath: '${_config['uncheckedImgPath'] ?? ''}'.isEmpty ? null : '${_config['uncheckedImgPath']}',
      checkedImgPath: '${_config['checkedImgPath'] ?? ''}'.isEmpty ? null : '${_config['checkedImgPath']}',
      checkBoxWidth: _config['checkBoxWidth'] as int?,
      checkBoxHeight: _config['checkBoxHeight'] as int?,
      checkboxHidden: _config['checkboxHidden'] as bool?,
      privacyOffsetY: _config['privacyOffsetY'] as int?,
      privacyOffsetY_B: _config['privacyOffsetY_B'] as int?,
      privacyOffsetX: _config['privacyOffsetX'] as int?,
      privacyOperatorIndex: _config['privacyOperatorIndex'] as int?,
      privacyConectTexts: privacyConectTexts,
      // 弹窗
      dialogWidth: _config['dialogWidth'] as int?,
      dialogHeight: _config['dialogHeight'] as int?,
      dialogBottom: _config['dialogBottom'] as bool?,
      dialogOffsetX: _config['dialogOffsetX'] as int?,
      dialogOffsetY: _config['dialogOffsetY'] as int?,
      dialogCornerRadiusArray: '${_config['dialogCornerRadiusArray'] ?? ''}'.split(',').map((e) => int.tryParse(e) ?? 10).toList(),
      dialogAlpha: (_config['dialogAlpha'] as num?)?.toDouble(),
      pageBackgroundRadius: _config['pageBackgroundRadius'] as int?,
      tapAuthPageMaskClosePage: _config['tapAuthPageMaskClosePage'] as bool? ?? false,
      // 全屏
      pageBackgroundPath: '${_config['pageBackgroundPath'] ?? ''}'.isEmpty ? null : '${_config['pageBackgroundPath']}',
      backgroundImageContentMode: ContentMode.values[_config['backgroundImageContentMode'] as int? ?? ContentMode.scaleAspectFill.index],
      backgroundColor: '${_config['backgroundColor'] ?? ''}'.isEmpty ? null : '${_config['backgroundColor']}',
      bottomNavColor: '${_config['bottomNavColor'] ?? ''}'.isEmpty ? null : '${_config['bottomNavColor']}',
      bottomNavBarColor: '${_config['bottomNavBarColor'] ?? ''}'.isEmpty ? null : '${_config['bottomNavBarColor']}',
      authPageActIn: '${_config['authPageActIn'] ?? ''}'.isEmpty ? null : '${_config['authPageActIn']}',
      authPageActOut: '${_config['authPageActOut'] ?? ''}'.isEmpty ? null : '${_config['authPageActOut']}',
      screenOrientation: _config['screenOrientation'] as int?,
      fullScreen: _config['fullScreen'] as bool? ?? false,
      authPageUseDayLight: _config['authPageUseDayLight'] as bool? ?? false,
      keepAllPageHideNavigationBar: _config['keepAllPageHideNavigationBar'] as bool? ?? false,
      closeAuthPageReturnBack: _config['closeAuthPageReturnBack'] as bool? ?? false,
      autoQuitPage: _config['autoQuitPage'] as bool? ?? true,
      // 自定义控件
      isHiddenCustom: _config['isHiddenCustom'] as bool?,
      customThirdView: customThirdView,
      // iOS弹窗
      alertBarIsHidden: _config['alertBarIsHidden'] as bool?,
      alertTitleBarColor: '${_config['alertTitleBarColor'] ?? ''}'.isEmpty ? null : '${_config['alertTitleBarColor']}',
      alertCloseItemIsHidden: _config['alertCloseItemIsHidden'] as bool?,
      alertCloseImagePath: '${_config['alertCloseImagePath'] ?? ''}'.isEmpty ? null : '${_config['alertCloseImagePath']}',
      alertCloseImageX: _config['alertCloseImageX'] as int?,
      alertCloseImageY: _config['alertCloseImageY'] as int?,
      alertCloseImageW: _config['alertCloseImageW'] as int?,
      alertCloseImageH: _config['alertCloseImageH'] as int?,
      alertBlurViewColor: '${_config['alertBlurViewColor'] ?? ''}'.isEmpty ? null : '${_config['alertBlurViewColor']}',
      alertBlurViewAlpha: (_config['alertBlurViewAlpha'] as num?)?.toDouble(),
      presentDirection: PNSPresentationDirection.values[_config['presentDirection'] as int? ?? 0],
      // 二次隐私弹窗
      privacyAlertIsNeedShow: _config['privacyAlertIsNeedShow'] as bool? ?? false,
      privacyAlertIsNeedAutoLogin: _config['privacyAlertIsNeedAutoLogin'] as bool? ?? true,
      privacyAlertWidth: _config['privacyAlertWidth'] as int?,
      privacyAlertHeight: _config['privacyAlertHeight'] as int?,
      privacyAlertOffsetX: _config['privacyAlertOffsetX'] as int?,
      privacyAlertOffsetY: _config['privacyAlertOffsetY'] as int?,
      privacyAlertTitleTextSize: _config['privacyAlertTitleTextSize'] as int?,
      privacyAlertTitleColor: '${_config['privacyAlertTitleColor'] ?? ''}'.isEmpty ? null : '${_config['privacyAlertTitleColor']}',
      privacyAlertTitleBackgroundColor: '${_config['privacyAlertTitleBackgroundColor'] ?? ''}'.isEmpty ? null : '${_config['privacyAlertTitleBackgroundColor']}',
      privacyAlertTitleAlignment: Gravity.values[_config['privacyAlertTitleAlignment'] as int? ?? Gravity.centerHorizntal.index],
      privacyAlertTitleOffsetX: _config['privacyAlertTitleOffsetX'] as int?,
      privacyAlertTitleOffsetY: _config['privacyAlertTitleOffsetY'] as int?,
      privacyAlertTitleContent: '${_config['privacyAlertTitleContent'] ?? ''}'.isEmpty ? null : '${_config['privacyAlertTitleContent']}',
      privacyAlertContentTextSize: _config['privacyAlertContentTextSize'] as int?,
      privacyAlertContentBackgroundColor: '${_config['privacyAlertContentBackgroundColor'] ?? ''}'.isEmpty ? null : '${_config['privacyAlertContentBackgroundColor']}',
      privacyAlertContentAlignment: Gravity.values[_config['privacyAlertContentAlignment'] as int? ?? 0],
      privacyAlertContentColor: '${_config['privacyAlertContentColor'] ?? ''}'.isEmpty ? null : '${_config['privacyAlertContentColor']}',
      privacyAlertContentBaseColor: '${_config['privacyAlertContentBaseColor'] ?? ''}'.isEmpty ? null : '${_config['privacyAlertContentBaseColor']}',
      privacyAlertContentHorizontalMargin: _config['privacyAlertContentHorizontalMargin'] as int?,
      privacyAlertContentVerticalMargin: _config['privacyAlertContentVerticalMargin'] as int?,
      privacyAlertProtocolNameUseUnderLine: _config['privacyAlertProtocolNameUseUnderLine'] as bool? ?? false,
      privacyAlertBtnText: '${_config['privacyAlertBtnText'] ?? ''}'.isEmpty ? null : '${_config['privacyAlertBtnText']}',
      privacyAlertBtnTextColor: '${_config['privacyAlertBtnTextColor'] ?? ''}'.isEmpty ? null : '${_config['privacyAlertBtnTextColor']}',
      privacyAlertBtnTextSize: _config['privacyAlertBtnTextSize'] as int?,
      privacyAlertBtnWidth: _config['privacyAlertBtnWidth'] as int?,
      privacyAlertBtnHeigth: _config['privacyAlertBtnHeigth'] as int?,
      privacyAlertBtnBackgroundImgPath: '${_config['privacyAlertBtnBackgroundImgPath'] ?? ''}'.isEmpty ? null : '${_config['privacyAlertBtnBackgroundImgPath']}',
      privacyAlertBefore: '${_config['privacyAlertBefore'] ?? ''}'.isEmpty ? null : '${_config['privacyAlertBefore']}',
      privacyAlertEnd: '${_config['privacyAlertEnd'] ?? ''}'.isEmpty ? null : '${_config['privacyAlertEnd']}',
      privacyAlertCloseBtnShow: _config['privacyAlertCloseBtnShow'] as bool? ?? true,
      privacyAlertCloseImagPath: '${_config['privacyAlertCloseImagPath'] ?? ''}'.isEmpty ? null : '${_config['privacyAlertCloseImagPath']}',
      privacyAlertCloseScaleType: ScaleType.values[_config['privacyAlertCloseScaleType'] as int? ?? 0],
      privacyAlertCloseImgWidth: _config['privacyAlertCloseImgWidth'] as int?,
      privacyAlertCloseImgHeight: _config['privacyAlertCloseImgHeight'] as int?,
      privacyAlertCornerRadiusArray: '${_config['privacyAlertCornerRadiusArray'] ?? ''}'.split(',').map((e) => int.tryParse(e) ?? 10).toList(),
      privacyAlertAlpha: (_config['privacyAlertAlpha'] as num?)?.toDouble() ?? 1.0,
      privacyAlertBackgroundColor: '${_config['privacyAlertBackgroundColor'] ?? ''}'.isEmpty ? null : '${_config['privacyAlertBackgroundColor']}',
      privacyAlertMaskIsNeedShow: _config['privacyAlertMaskIsNeedShow'] as bool? ?? true,
      privacyAlertMaskAlpha: (_config['privacyAlertMaskAlpha'] as num?)?.toDouble() ?? 0.5,
      privacyAlertMaskColor: '${_config['privacyAlertMaskColor'] ?? ''}'.isEmpty ? null : '${_config['privacyAlertMaskColor']}',
      tapPrivacyAlertMaskCloseAlert: _config['tapPrivacyAlertMaskCloseAlert'] as bool? ?? true,
      privacyAlertOwnOneColor: '${_config['privacyAlertOwnOneColor'] ?? ''}'.isEmpty ? null : '${_config['privacyAlertOwnOneColor']}',
      privacyAlertOwnTwoColor: '${_config['privacyAlertOwnTwoColor'] ?? ''}'.isEmpty ? null : '${_config['privacyAlertOwnTwoColor']}',
      privacyAlertOwnThreeColor: '${_config['privacyAlertOwnThreeColor'] ?? ''}'.isEmpty ? null : '${_config['privacyAlertOwnThreeColor']}',
      privacyAlertOperatorColor: '${_config['privacyAlertOperatorColor'] ?? ''}'.isEmpty ? null : '${_config['privacyAlertOperatorColor']}',
      // Toast
      isHideToast: _config['isHideToast'] as bool? ?? false,
      toastText: '${_config['toastText'] ?? ''}'.isEmpty ? null : '${_config['toastText']}',
      toastBackground: '${_config['toastBackground'] ?? ''}'.isEmpty ? null : '${_config['toastBackground']}',
      toastColor: '${_config['toastColor'] ?? ''}'.isEmpty ? null : '${_config['toastColor']}',
      toastPadding: _config['toastPadding'] as int?,
      toastMarginTop: _config['toastMarginTop'] as int?,
      toastMarginBottom: _config['toastMarginBottom'] as int?,
      toastPositionMode: _toastPositionModeString(_config['toastPositionMode'] as int?),
      toastDelay: _config['toastDelay'] as int?,
    );
  }

  // ==================== 应用 & 重置 ====================

  String _toastPositionModeString(int? value) {
    switch (value) {
      case 0: return 'top';
      case 1: return 'center';
      case 2: return 'bottom';
      default: return 'bottom';
    }
  }

  void _applyConfig() {
    final model = _buildModel();
    if (kDebugMode) {
      print('===== 应用配置 =====');
      model.toJson().forEach((k, v) => print('  $k: $v'));
    }
    AliAuth.loginListen(onEvent: (event) {
      if (kDebugMode) print('onEvent: $event');
    });
    AliAuth.initSdk(model);
  }

  void _resetConfig() {
    setState(() {
      _config = Map<String, dynamic>.from(_defaultConfig);
    });
  }

  // ==================== 分组构建 ====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔧 动态参数配置'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: '重置默认值',
            onPressed: _resetConfig,
          ),
        ],
      ),
      body: Column(
        children: [
          // 顶部固定栏
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.blue.shade50,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildTextField('androidSk', 'Android SK', hint: '必填')),
                    const SizedBox(width: 8),
                    Expanded(child: _buildTextField('iosSk', 'iOS SK', hint: '必填')),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown<int>(
                        'pageType', '页面类型',
                        List.generate(PageType.values.length, (i) => i),
                            (i) => ['全屏竖屏', '全屏横屏', '弹窗竖屏', '弹窗横屏', '底部弹窗', '自定义View', '自定义Xml', '自定义GIF', '自定义视频', '自定义图片'][i],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: _buildSwitch('isDebug', '调试模式')),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: _buildSwitch('isDelay', '延迟登录')),
                    const SizedBox(width: 8),
                    Expanded(child: _buildSwitch('autoQuitPage', '自动关闭页面')),
                  ],
                ),
              ],
            ),
          ),
          // 可滚动分组列表
          Expanded(
            child: ListView(
              children: [
                _buildSection1(),
                _buildSection2(),
                _buildSection3(),
                _buildSection4(),
                _buildSection5(),
                _buildSection6(),
                _buildSection7(),
                _buildSection8(),
                _buildSection9(),
                _buildSection10(),
                _buildSection11(),
                _buildSection12(),
                _buildSection13(),
                _buildSection14(),
              ],
            ),
          ),
          // 底部按钮
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)],
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _applyConfig,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('应用配置'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _resetConfig,
                    icon: const Icon(Icons.restart_alt),
                    label: const Text('重置默认值'),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== 各分组 ====================

  Widget _buildSection(String title, int count, List<Widget> children) {
    return ExpansionTile(
      title: _buildSectionTitle(title, count),
      initiallyExpanded: false,
      childrenPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      children: children,
    );
  }

  // 一、状态栏
  Widget _buildSection1() => _buildSection('一、状态栏', 5, [
    _buildTextField('statusBarColor', '状态栏颜色', hint: '如 #026ED2'),
    _buildSwitch('lightColor', '浅色文字'),
    _buildSwitch('isStatusBarHidden', '隐藏状态栏'),
    _buildDropdown<int>('statusBarUIFlag', '状态栏UIFlag',
      List.generate(UIFAG.values.length, (i) => i),
          (i) => ['LowProfile', 'HideNavigation', 'Fullscreen', 'LayoutStable', 'LayoutHideNav', 'LayoutFullscreen', 'Immersive', 'ImmersiveSticky', 'LightStatusBar', 'LightNavigationBar'][i],
    ),
    _buildTextField('webViewStatusBarColor', '协议页状态栏颜色', hint: '如 #026ED2'),
  ]);

  // 二、导航栏
  Widget _buildSection2() => _buildSection('二、导航栏', 13, [
    _buildSwitch('navHidden', '隐藏导航栏'),
    _buildTextField('navColor', '导航栏颜色', hint: '如 #026ED2'),
    _buildTextField('navText', '标题文字'),
    _buildTextField('navTextColor', '标题颜色', hint: '如 #000000'),
    _buildTextField('navTextSize', '标题字号', isNumber: true),
    _buildTextField('navReturnImgPath', '返回按钮图片路径', hint: '如 assets/return_btn.png'),
    _buildSwitch('navReturnHidden', '隐藏返回按钮'),
    _buildTextField('navReturnImgWidth', '返回按钮宽度', isNumber: true),
    _buildTextField('navReturnImgHeight', '返回按钮高度', isNumber: true),
    _buildDropdown<int>('navReturnScaleType', '返回按钮缩放',
      List.generate(ScaleType.values.length, (i) => i),
          (i) => ['Matrix', 'FitXY', 'FitStart', 'FitCenter', 'FitEnd', 'Center', 'CenterCrop', 'CenterInside'][i],
    ),
    _buildTextField('webNavColor', '协议页导航栏颜色', hint: '如 #FFFFFF'),
    _buildTextField('webNavTextColor', '协议页标题颜色', hint: '如 #000000'),
    _buildTextField('webNavTextSize', '协议页标题字号', isNumber: true),
    _buildTextField('webNavReturnImgPath', '协议页返回按钮路径', hint: '如 assets/return_btn.png'),
    // 自定义返回按钮子项
    const Divider(),
    _buildTextField('customReturnBtn_imgPath', '自定义返回按钮图片'),
    _buildTextField('customReturnBtn_top', '按钮top', isNumber: true),
    _buildTextField('customReturnBtn_left', '按钮left', isNumber: true),
    _buildTextField('customReturnBtn_width', '按钮宽度', isNumber: true),
    _buildTextField('customReturnBtn_height', '按钮高度', isNumber: true),
    _buildDropdown<int>('customReturnBtn_imgScaleType', '按钮缩放',
      List.generate(ScaleType.values.length, (i) => i),
          (i) => ['Matrix', 'FitXY', 'FitStart', 'FitCenter', 'FitEnd', 'Center', 'CenterCrop', 'CenterInside'][i],
    ),
  ]);

  // 三、Logo区
  Widget _buildSection3() => _buildSection('三、Logo区', 8, [
    _buildTextField('logoImgPath', 'Logo图片路径', hint: '如 assets/logo.png'),
    _buildSwitch('logoHidden', '隐藏Logo'),
    _buildTextField('logoWidth', 'Logo宽度', isNumber: true),
    _buildTextField('logoHeight', 'Logo高度', isNumber: true),
    _buildTextField('logoOffsetY', '距顶部偏移', isNumber: true),
    _buildTextField('logoOffsetY_B', '距底部偏移', isNumber: true),
    _buildDropdown<int>('logoScaleType', '缩放模式',
      List.generate(ScaleType.values.length, (i) => i),
          (i) => ['Matrix', 'FitXY', 'FitStart', 'FitCenter', 'FitEnd', 'Center', 'CenterCrop', 'CenterInside'][i],
    ),
  ]);

  // 四、Slogan区
  Widget _buildSection4() => _buildSection('四、Slogan区', 6, [
    _buildSwitch('sloganHidden', '隐藏Slogan'),
    _buildTextField('sloganText', 'Slogan文字'),
    _buildTextField('sloganTextColor', '文字颜色', hint: '如 #ffffff'),
    _buildTextField('sloganTextSize', '文字大小', isNumber: true),
    _buildTextField('sloganOffsetY', '距顶部偏移', isNumber: true),
    _buildTextField('sloganOffsetY_B', '距底部偏移', isNumber: true),
  ]);

  // 五、掩码栏
  Widget _buildSection5() => _buildSection('五、掩码栏', 6, [
    _buildTextField('numberColor', '手机号颜色', hint: '如 #ffffff'),
    _buildTextField('numberSize', '手机号字号', isNumber: true),
    _buildTextField('numFieldOffsetY', '距顶部偏移', isNumber: true),
    _buildTextField('numFieldOffsetY_B', '距底部偏移', isNumber: true),
    _buildTextField('numberFieldOffsetX', 'X轴偏移', isNumber: true),
    _buildDropdown<int>('numberLayoutGravity', '对齐方式',
      [0, 1, 2],
          (i) => ['居中', '左对齐', '右对齐'][i],
    ),
  ]);

  // 六、登录按钮
  Widget _buildSection6() => _buildSection('六、登录按钮', 12, [
    _buildTextField('logBtnText', '按钮文字'),
    _buildTextField('logBtnTextColor', '文字颜色', hint: '如 #FFF000'),
    _buildTextField('logBtnTextSize', '文字大小', isNumber: true),
    _buildTextField('logBtnWidth', '按钮宽度', isNumber: true),
    _buildTextField('logBtnHeight', '按钮高度', isNumber: true),
    _buildTextField('logBtnOffsetY', '距顶部偏移', isNumber: true),
    _buildTextField('logBtnOffsetY_B', '距底部偏移', isNumber: true),
    _buildTextField('logBtnOffsetX', 'X轴偏移', isNumber: true),
    _buildTextField('logBtnMarginLeftAndRight', '左右边距', isNumber: true),
    _buildDropdown<int>('logBtnLayoutGravity', '对齐方式',
      [0, 1, 2],
          (i) => ['居中', '左对齐', '右对齐'][i],
    ),
    _buildTextField('logBtnBackgroundPath', '背景图路径', hint: '逗号分隔三态图片'),
    _buildTextField('loadingImgPath', 'Loading图片路径'),
    _buildSwitch('logBtnToastHidden', '隐藏默认Toast'),
  ]);

  // 七、切换按钮
  Widget _buildSection7() => _buildSection('七、切换按钮', 6, [
    _buildSwitch('switchAccHidden', '隐藏切换按钮'),
    _buildSwitch('switchCheck', '切换时校验协议'),
    _buildTextField('switchAccText', '切换文字'),
    _buildTextField('switchAccTextColor', '文字颜色', hint: '如 #FDFDFD'),
    _buildTextField('switchAccTextSize', '文字大小', isNumber: true),
    _buildTextField('switchOffsetY', '距顶部偏移', isNumber: true),
    _buildTextField('switchOffsetY_B', '距底部偏移', isNumber: true),
  ]);

  // 八、自定义控件
  Widget _buildSection8() => _buildSection('八、自定义控件', 10, [
    _buildSwitch('isHiddenCustom', '隐藏第三方布局'),
    const Divider(),
    const Text('第三方图标按钮', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
    _buildTextField('customThirdView_top', '整体top', isNumber: true),
    _buildTextField('customThirdView_left', '整体left', isNumber: true),
    _buildTextField('customThirdView_width', '整体宽度', isNumber: true),
    _buildTextField('customThirdView_height', '整体高度', isNumber: true),
    _buildTextField('customThirdView_space', '图标间距', isNumber: true),
    _buildTextField('customThirdView_size', '文字大小', isNumber: true),
    _buildTextField('customThirdView_color', '文字颜色', hint: '如 #026ED2'),
    _buildTextField('customThirdView_itemWidth', '图标宽度', isNumber: true),
    _buildTextField('customThirdView_itemHeight', '图标高度', isNumber: true),
    const Divider(),
    const Text('图标1', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
    _buildTextField('customThirdView_name1', '名称'),
    _buildTextField('customThirdView_path1', '图片路径', hint: '如 assets/alipay.png'),
    const Text('图标2', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
    _buildTextField('customThirdView_name2', '名称'),
    _buildTextField('customThirdView_path2', '图片路径', hint: '如 assets/taobao.png'),
    const Text('图标3', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
    _buildTextField('customThirdView_name3', '名称'),
    _buildTextField('customThirdView_path3', '图片路径', hint: '如 assets/sina.png'),
  ]);

  // 九、协议栏
  Widget _buildSection9() => _buildSection('九、协议栏', 18, [
    _buildTextField('protocolOneName', '协议1名称', hint: '如 《用户协议》'),
    _buildTextField('protocolOneURL', '协议1URL'),
    _buildTextField('protocolTwoName', '协议2名称'),
    _buildTextField('protocolTwoURL', '协议2URL'),
    _buildTextField('protocolThreeName', '协议3名称'),
    _buildTextField('protocolThreeURL', '协议3URL'),
    _buildTextField('protocolColor', '基础文字颜色', hint: '如 #bfbfbf'),
    _buildTextField('protocolCustomColor', '协议链接颜色', hint: '如 #026ED2'),
    _buildTextField('protocolOwnColor', '运营商协议颜色', hint: '如 #026ED2'),
    _buildTextField('protocolOwnOneColor', '协议1颜色'),
    _buildTextField('protocolOwnTwoColor', '协议2颜色'),
    _buildDropdown<int>('protocolLayoutGravity', '对齐方式',
      [0, 1, 2],
          (i) => ['居中', '左对齐', '右对齐'][i],
    ),
    _buildSwitch('privacyState', '默认勾选协议'),
    _buildDropdown<int>('protocolGravity', '协议栏对齐',
      [0, 1, 2],
          (i) => ['居中', '左对齐', '右对齐'][i],
    ),
    _buildTextField('privacyTextSize', '协议文字大小', isNumber: true),
    _buildTextField('privacyMargin', '左右边距', isNumber: true),
    _buildTextField('privacyBefore', '前置文案', hint: '如 我已阅读并同意'),
    _buildTextField('privacyEnd', '后置文案'),
    _buildTextField('vendorPrivacyPrefix', '运营商前缀', hint: '如 《'),
    _buildTextField('vendorPrivacySuffix', '运营商后缀', hint: '如 》'),
    _buildTextField('uncheckedImgPath', '未勾选图标路径'),
    _buildTextField('checkedImgPath', '已勾选图标路径'),
    _buildTextField('checkBoxWidth', '复选框宽度', isNumber: true),
    _buildTextField('checkBoxHeight', '复选框高度', isNumber: true),
    _buildSwitch('checkboxHidden', '隐藏复选框'),
    _buildTextField('privacyOffsetY', '协议距顶部偏移', isNumber: true),
    _buildTextField('privacyOffsetY_B', '协议距底部偏移', isNumber: true),
    _buildTextField('privacyOffsetX', '协议X偏移', isNumber: true),
    _buildTextField('privacyOperatorIndex', '运营商协议索引', isNumber: true),
    _buildTextField('privacyConectTexts', '连接符', hint: '逗号分隔，如 ","", "和"'),
  ]);

  // 十、弹窗设置
  Widget _buildSection10() => _buildSection('十、弹窗设置', 9, [
    _buildTextField('dialogWidth', '弹窗宽度', isNumber: true),
    _buildTextField('dialogHeight', '弹窗高度', isNumber: true),
    _buildSwitch('dialogBottom', '底部弹窗'),
    _buildTextField('dialogOffsetX', 'X偏移', isNumber: true),
    _buildTextField('dialogOffsetY', 'Y偏移', isNumber: true),
    _buildTextField('dialogCornerRadiusArray', '圆角', hint: '左上,右上,右下,左下'),
    _buildTextField('dialogAlpha', '蒙层透明度', isNumber: true),
    _buildTextField('pageBackgroundRadius', '背景圆角', isNumber: true),
    _buildSwitch('tapAuthPageMaskClosePage', '点击蒙层关闭'),
  ]);

  // 十一、全屏属性
  Widget _buildSection11() => _buildSection('十一、全屏属性', 10, [
    _buildTextField('pageBackgroundPath', '背景路径', hint: '支持图片/GIF/视频'),
    _buildDropdown<int>('backgroundImageContentMode', '背景内容模式',
      List.generate(ContentMode.values.length, (i) => i),
          (i) => ['ScaleToFill', 'ScaleAspectFit', 'ScaleAspectFill', 'Redraw', 'Center', 'Top', 'Bottom', 'Left', 'Right', 'TopLeft', 'TopRight', 'BottomLeft', 'BottomRight'][i],
    ),
    _buildTextField('backgroundColor', '背景色', hint: '如 #000000'),
    _buildTextField('bottomNavColor', '底部导航颜色'),
    _buildTextField('bottomNavBarColor', '虚拟导航栏颜色'),
    _buildTextField('screenOrientation', '屏幕方向', isNumber: true),
    _buildSwitch('fullScreen', '全屏适配'),
    _buildSwitch('authPageUseDayLight', '跟随深色模式'),
    _buildSwitch('keepAllPageHideNavigationBar', '隐藏底部导航栏'),
    _buildSwitch('closeAuthPageReturnBack', '禁用返回键'),
  ]);

  // 十二、iOS弹窗
  Widget _buildSection12() => _buildSection('十二、iOS弹窗设置', 11, [
    _buildSwitch('alertBarIsHidden', '隐藏Bar'),
    _buildTextField('alertTitleBarColor', 'Bar背景色', hint: '如 #FFFFFF'),
    _buildSwitch('alertCloseItemIsHidden', '隐藏关闭按钮'),
    _buildTextField('alertCloseImagePath', '关闭按钮图片'),
    _buildTextField('alertCloseImageX', '关闭按钮X', isNumber: true),
    _buildTextField('alertCloseImageY', '关闭按钮Y', isNumber: true),
    _buildTextField('alertCloseImageW', '关闭按钮宽度', isNumber: true),
    _buildTextField('alertCloseImageH', '关闭按钮高度', isNumber: true),
    _buildTextField('alertBlurViewColor', '蒙层颜色', hint: '如 #000000'),
    _buildTextField('alertBlurViewAlpha', '蒙层透明度', isNumber: true),
    _buildDropdown<int>('presentDirection', '弹窗方向',
      [0, 1, 2, 3],
          (i) => ['底部', '右侧', '顶部', '左侧'][i],
    ),
  ]);

  // 十三、二次隐私弹窗
  Widget _buildSection13() => _buildSection('十三、二次隐私弹窗', 25, [
    _buildSwitch('privacyAlertIsNeedShow', '启用二次弹窗'),
    _buildSwitch('privacyAlertIsNeedAutoLogin', '自动登录'),
    _buildTextField('privacyAlertTitleContent', '标题文字'),
    _buildTextField('privacyAlertTitleTextSize', '标题字号', isNumber: true),
    _buildTextField('privacyAlertTitleColor', '标题颜色'),
    _buildTextField('privacyAlertTitleBackgroundColor', '标题背景色'),
    _buildDropdown<int>('privacyAlertTitleAlignment', '标题对齐',
      [0, 1, 2],
          (i) => ['居中', '左对齐', '右对齐'][i],
    ),
    _buildTextField('privacyAlertTitleOffsetX', '标题X偏移', isNumber: true),
    _buildTextField('privacyAlertTitleOffsetY', '标题Y偏移', isNumber: true),
    _buildTextField('privacyAlertContentTextSize', '内容字号', isNumber: true),
    _buildTextField('privacyAlertContentColor', '内容颜色'),
    _buildTextField('privacyAlertContentBaseColor', '基础文字颜色'),
    _buildTextField('privacyAlertContentBackgroundColor', '内容背景色'),
    _buildTextField('privacyAlertContentHorizontalMargin', '内容左右边距', isNumber: true),
    _buildTextField('privacyAlertContentVerticalMargin', '内容上下间距', isNumber: true),
    _buildSwitch('privacyAlertProtocolNameUseUnderLine', '协议名称下划线'),
    _buildTextField('privacyAlertWidth', '弹窗宽度', isNumber: true),
    _buildTextField('privacyAlertHeight', '弹窗高度', isNumber: true),
    _buildTextField('privacyAlertOffsetX', '弹窗X偏移', isNumber: true),
    _buildTextField('privacyAlertOffsetY', '弹窗Y偏移', isNumber: true),
    _buildTextField('privacyAlertCornerRadiusArray', '圆角', hint: '左上,右上,右下,左下'),
    _buildTextField('privacyAlertAlpha', '弹窗透明度', isNumber: true),
    _buildTextField('privacyAlertBackgroundColor', '弹窗背景色'),
    _buildTextField('privacyAlertBefore', '前置文案'),
    _buildTextField('privacyAlertEnd', '后置文案'),
    _buildSwitch('privacyAlertMaskIsNeedShow', '显示蒙层'),
    _buildTextField('privacyAlertMaskAlpha', '蒙层透明度', isNumber: true),
    _buildTextField('privacyAlertMaskColor', '蒙层颜色'),
    _buildSwitch('tapPrivacyAlertMaskCloseAlert', '点击蒙层关闭'),
    _buildTextField('privacyAlertBtnText', '按钮文字'),
    _buildTextField('privacyAlertBtnTextColor', '按钮文字颜色'),
    _buildTextField('privacyAlertBtnTextSize', '按钮文字大小', isNumber: true),
    _buildTextField('privacyAlertBtnWidth', '按钮宽度', isNumber: true),
    _buildTextField('privacyAlertBtnHeigth', '按钮高度', isNumber: true),
    _buildTextField('privacyAlertBtnBackgroundImgPath', '按钮背景图'),
    _buildSwitch('privacyAlertCloseBtnShow', '显示关闭按钮'),
    _buildTextField('privacyAlertCloseImagPath', '关闭按钮图片'),
    _buildTextField('privacyAlertCloseImgWidth', '关闭按钮宽度', isNumber: true),
    _buildTextField('privacyAlertCloseImgHeight', '关闭按钮高度', isNumber: true),
    _buildTextField('privacyAlertOwnOneColor', '协议1颜色'),
    _buildTextField('privacyAlertOwnTwoColor', '协议2颜色'),
    _buildTextField('privacyAlertOwnThreeColor', '协议3颜色'),
    _buildTextField('privacyAlertOperatorColor', '运营商协议颜色'),
  ]);

  // 十四、Toast设置
  Widget _buildSection14() => _buildSection('十四、Toast设置', 9, [
    _buildSwitch('isHideToast', '隐藏Toast'),
    _buildTextField('toastText', '提示文字'),
    _buildTextField('toastBackground', '背景色', hint: '如 #FF000000'),
    _buildTextField('toastColor', '文字颜色', hint: '如 #FFFFFFFF'),
    _buildTextField('toastPadding', '内边距', isNumber: true),
    _buildTextField('toastMarginTop', '距顶部距离', isNumber: true),
    _buildTextField('toastMarginBottom', '距底部距离', isNumber: true),
    _buildDropdown<int>('toastPositionMode', '显示位置',
      [0, 1, 2],
          (i) => ['顶部', '居中', '底部'][i],
    ),
    _buildTextField('toastDelay', '显示时长(秒)', isNumber: true),
  ]);
}
