import UIKit
import XCTest
import ATAuthSDK
import ObjectiveC
@testable import ali_auth_spm

/// 对照 CodeGather 712747d 的实际 OC 入口验证 Swift 行为；不向 SDK 请求认证。
class RunnerTests: XCTestCase {
  /// OC 允许每个状态独立使用自定义/默认图片，但默认资源不齐时要求三态自定义图完整。
  func testBackgroundImagesUseUpstreamPerStateFallback() throws {
    let normal = UIImage()
    let pressed = UIImage()
    let fallback = UIImage()
    let disabled = UIImage()
    let mixed = try XCTUnwrap(PNSBuildModelUtils.loginButtonBackgrounds(
      customImages: [normal, nil, pressed], defaultClick: fallback, defaultUnclick: disabled))
    XCTAssertTrue(mixed[0] === normal)
    XCTAssertTrue(mixed[1] === disabled)
    XCTAssertTrue(mixed[2] === pressed)
    XCTAssertNil(PNSBuildModelUtils.loginButtonBackgrounds(
      customImages: [normal, nil, pressed], defaultClick: fallback, defaultUnclick: nil))
    XCTAssertNotNil(PNSBuildModelUtils.loginButtonBackgrounds(
      customImages: [normal, disabled, pressed], defaultClick: nil, defaultUnclick: nil))
  }
  /// 上游未消费基础/链接协议色，运营商专属色仍通过既有别名生效。
  func testProtocolColorsFollowUpstreamRuntimeEntry() {
    let defaults = PNSBuildModelUtils.buildModel(configuration: [:], target: self,
      selector: NSSelectorFromString("unused"))
    let model = PNSBuildModelUtils.buildModel(configuration: [
      "protocolColor": "#ff666666", "protocolCustomColor": "#ff0063BF", "protocolOwnColor": "#FF026ED2"
    ], target: self, selector: NSSelectorFromString("unused"))
    XCTAssertEqual(model.privacyColors, defaults.privacyColors)
    XCTAssertEqual(model.privacyOperatorColor, UIColor.aliAuth(hex: "#FF026ED2"))
  }

  /// 上游仅声明并传输背景色/圆角，不在 iOS 合成按钮图片；粗体仍按上游执行。
  func testButtonStylesDoNotInventUpstreamCapabilities() throws {
    let defaults = PNSBuildModelUtils.buildModel(configuration: [:], target: self,
      selector: NSSelectorFromString("unused"))
    let model = PNSBuildModelUtils.buildModel(configuration: [
      "logBtnBackgroundColor": "#ff123456", "logBtnCornerRadius": 12, "logBtnTextBold": true
    ], target: self, selector: NSSelectorFromString("unused"))
    XCTAssertEqual(model.loginBtnBgImgs, defaults.loginBtnBgImgs)
    let font = try XCTUnwrap(model.loginBtnText.attribute(.font, at: 0, effectiveRange: nil) as? UIFont)
    XCTAssertEqual(font, UIFont.systemFont(ofSize: 23, weight: .semibold))
  }

  /// 上游先设置通用淡入淡出，再由特殊页面样式覆盖相应动画。
  func testAnimationPrecedenceMatchesObjectiveC() {
    for (style, path, duration) in [(0, "opacity", 0.26), (5, "transform.scale", 0.25),
                                     (6, "transform.translation.y", 0.25)] {
      let model = PNSBuildModelUtils.buildModel(configuration: ["pageType": style, "authPageCrossFade": true],
        target: self, selector: NSSelectorFromString("unused"))
      XCTAssertEqual((model.entryAnimation as? CAPropertyAnimation)?.keyPath, path)
      XCTAssertEqual(model.entryAnimation?.duration ?? 0, duration, accuracy: 0.001)
      XCTAssertEqual((model.exitAnimation as? CAPropertyAnimation)?.keyPath, "opacity")
    }
  }

  /// 协议回调保留上游底部、边距、显式 X/Y 的处理顺序，不注入安全区或原生距离属性。
  func testPrivacyLayoutMatchesUpstreamFormula() throws {
    let model = PNSBuildModelUtils.buildModel(configuration: [
      "privacyOffsetY_B": 28, "privacyMargin": 28, "privacyOffsetY": -1
    ], target: self, selector: NSSelectorFromString("unused"))
    let layout = try XCTUnwrap(model.privacyFrameBlock)
    let result = layout(CGSize(width: 375, height: 812), CGSize(width: 375, height: 724),
      CGRect(x: 30, y: 600, width: 315, height: 48))
    XCTAssertEqual(result, CGRect(x: 28, y: 648, width: 319, height: 48))
    let defaults = TXCustomModel()
    XCTAssertEqual(model.privacyLRPadding, defaults.privacyLRPadding)
    XCTAssertEqual(model.privacyBottomOffetY, defaults.privacyBottomOffetY)
  }

  /// 显式顶部偏移优先于底部位置；重复布局不叠加偏移。
  func testTopOffsetPrecedenceAndRepeatedLayout() throws {
    let model = PNSBuildModelUtils.buildModel(configuration: [
      "privacyOffsetX": 12, "privacyOffsetY": 70, "privacyOffsetY_B": 28
    ], target: self, selector: NSSelectorFromString("unused"))
    let layout = try XCTUnwrap(model.privacyFrameBlock)
    let size = CGSize(width: 375, height: 600)
    let first = layout(size, size, CGRect(x: 18, y: 520, width: 300, height: 48))
    XCTAssertEqual(first.origin, CGPoint(x: 12, y: 70))
    XCTAssertEqual(layout(size, size, first).origin, first.origin)
  }

  /// 宿主 iOS 配置不传底部定位后，真实 SDK 排版的协议和勾选框应处于屏幕内。
  func testHostIOSProfileUsesVisibleSDKDefaultPrivacyPosition() throws {
    for size in [CGSize(width: 375, height: 667), CGSize(width: 390, height: 844)] {
      for navHidden in [false, true] {
        let model = PNSBuildModelUtils.buildModel(configuration: [
          "privacyMargin": 28, "privacyOffsetY_B": NSNull(), "privacyOffsetY": -1,
          "checkBoxHeight": 18, "privacyTextSize": 12, "checkboxHidden": false,
          "privacyBefore": "我已阅读并同意", "privacyEnd": "", "protocolGravity": 1,
          "navHidden": navHidden, "isDebug": true,
          "protocolOneName": String(repeating: "用户协议", count: 8),
          "protocolOneURL": "https://example.com/terms"
        ], target: self, selector: NSSelectorFromString("unused"))
        let view = try makeSDKLoginView(model: model, size: size)
        let text = try XCTUnwrap(view.subviews.compactMap { $0 as? UITextView }.first)
        let checkbox = try XCTUnwrap(view.subviews.compactMap { $0 as? UIButton }.first {
          $0.frame.width == 18 && $0.frame.height == 18
        })
        XCTAssertFalse(text.isHidden)
        XCTAssertFalse(checkbox.isHidden)
        XCTAssertGreaterThan(text.frame.height, model.privacyFont.lineHeight)
        XCTAssertGreaterThanOrEqual(text.frame.minY, 0)
        let safeBottom = AliAuthViewController.activeWindow?.safeAreaInsets.bottom ?? 0
        XCTAssertLessThanOrEqual(text.frame.maxY, size.height - safeBottom)
        XCTAssertLessThanOrEqual(checkbox.frame.maxY, size.height - safeBottom)
      }
    }
  }
  /// 创建不请求认证、不读取 SIM 卡的 SDK 原生视图，并执行真实的导航栏与协议排版。
  ///
  /// [model] 为待验证配置，[size] 为 pt 单位的屏幕尺寸；返回的视图由调用者持有。
  /// 运行时入口仅用于当前随插件固定版本的 SDK 测试，绝不进入生产实现。
  /// SDK 变更内部签名时通过 XCTest 解包失败提示维护，禁止把测试反射作为业务依赖。
  private func makeSDKLoginView(model: TXCustomModel, size: CGSize) throws -> UIView {
    let cls: AnyClass = try XCTUnwrap(NSClassFromString("PNSLoginView"))
    let allocated = try XCTUnwrap((cls as AnyObject).perform(NSSelectorFromString("alloc")))
      .takeRetainedValue()
    let initializer = NSSelectorFromString("initWithDelegate:model:phoneNumber:carrierType:")
    let initializeMethod = try XCTUnwrap(class_getInstanceMethod(cls, initializer))
    let encoding = String(cString: try XCTUnwrap(method_getTypeEncoding(initializeMethod)))
    guard encoding == "@48@0:8@16@24@32@40" else {
      XCTFail("SDK initializer signature changed: \(encoding)")
      throw NSError(domain: "AliAuthSDKTest", code: 1)
    }
    typealias Initializer = @convention(c) (AnyObject, Selector, AnyObject?, AnyObject, NSString, NSString) -> Unmanaged<AnyObject>
    let initialize = unsafeBitCast(method_getImplementation(initializeMethod), to: Initializer.self)
    let view = try XCTUnwrap(initialize(allocated, initializer, nil, model, "155****1234", "CM")
      .takeUnretainedValue() as? UIView)
    view.frame = CGRect(origin: .zero, size: size)
    let layoutSelector = NSSelectorFromString("setLayoutSubviewsWithScreenSize:")
    let layoutMethod = try XCTUnwrap(class_getInstanceMethod(cls, layoutSelector))
    typealias Layout = @convention(c) (AnyObject, Selector, CGSize) -> Void
    let layout = unsafeBitCast(method_getImplementation(layoutMethod), to: Layout.self)
    layout(view, layoutSelector, size)
    return view
  }

}
