import ATAuthSDK
import Flutter
import QuartzCore
import UIKit

enum PNSBuildModelUtils {
    static func buildModel(
        configuration: [String: Any],
        target: AnyObject,
        selector: Selector
    ) -> TXCustomModel {
        let style = PNSBuildModelStyle(rawValue: configuration.int("pageType")) ?? .portrait
        let model = TXCustomModel()
        applyModelValues(configuration, to: model)

        var backgroundView: PNSBackgroundView?
        if style == .gifBackground || style == .videoBackground,
           let url = assetURL(configuration.string("pageBackgroundPath")) {
            let view = PNSBackgroundView()
            if style == .gifBackground { view.gifURL = url } else { view.videoURL = url }
            view.show()
            backgroundView = view
        }

        configureAnimations(model, style: style)
        configureNavigation(model, configuration: configuration, style: style)
        configurePrimaryControls(model, configuration: configuration)
        configureCustomViews(
            model,
            configuration: configuration,
            style: style,
            backgroundView: backgroundView,
            target: target,
            selector: selector
        )
        configurePrivacy(model, configuration: configuration)
        configureDialog(model, configuration: configuration, style: style)
        configurePrivacyAlert(model, configuration: configuration)
        model.supportedInterfaceOrientations = .portrait
        return model
    }

    private static func applyModelValues(_ configuration: [String: Any], to model: TXCustomModel) {
        for (key, rawValue) in configuration where !(rawValue is NSNull) {
            let modelKey = AliAuthStatus.modelKeys[key] ?? key
            let setter = NSSelectorFromString("set\(modelKey.prefix(1).uppercased())\(modelKey.dropFirst()):")
            guard model.responds(to: setter) else { continue }

            if let array = rawValue as? [Any] {
                var converted = array
                if key == "privacyAlertCornerRadiusArray", array.count == 4 {
                    converted = [array[0], array[3], array[2], array[1]]
                } else if key.contains("Path") {
                    converted = array.compactMap { ($0 as? String).flatMap(assetImage) }
                } else if key.contains("Color") {
                    converted = array.compactMap { value -> UIColor? in
                        guard let value = value as? String else { return nil }
                        return UIColor.aliAuth(hex: value)
                    }
                }
                model.setValue(converted, forKey: modelKey)
                continue
            }

            if key.contains("Path"), let path = rawValue as? String {
                guard !path.contains(","), let image = assetImage(path) else { continue }
                model.setValue(key == "privacyAlertBtnBackgroundImgPath" ? [image, image] : image, forKey: modelKey)
            } else if key.contains("Color") {
                if key == "lightColor" {
                    let lightBackground = configuration.bool(key)
                    if #available(iOS 13.0, *) {
                        model.setValue(lightBackground ? UIStatusBarStyle.darkContent.rawValue : UIStatusBarStyle.lightContent.rawValue, forKey: modelKey)
                    } else {
                        model.setValue(lightBackground ? UIStatusBarStyle.default.rawValue : UIStatusBarStyle.lightContent.rawValue, forKey: modelKey)
                    }
                } else {
                    model.setValue(UIColor.aliAuth(hex: configuration.string(key, default: "#23effe")), forKey: modelKey)
                }
            } else if key.contains("Size") {
                model.setValue(UIFont.systemFont(ofSize: configuration.cgFloat(key, default: 17)), forKey: modelKey)
            } else {
                model.setValue(rawValue, forKey: modelKey)
            }
        }
    }

    private static func configureAnimations(_ model: TXCustomModel, style: PNSBuildModelStyle) {
        if style == .alertFade {
            let entry = CABasicAnimation(keyPath: "transform.scale")
            entry.fromValue = 1.03
            entry.toValue = 1
            entry.duration = 0.25
            entry.timingFunction = CAMediaTimingFunction(name: .linear)
            model.entryAnimation = entry

            let exit = CABasicAnimation(keyPath: "opacity")
            exit.fromValue = 1
            exit.toValue = 0
            exit.duration = 0.25
            exit.timingFunction = CAMediaTimingFunction(name: .linear)
            model.exitAnimation = exit
        } else if style == .alertDropDown {
            let width = UIScreen.main.bounds.width * 0.8
            let height = width / 0.618
            let frame = CGRect(
                x: (UIScreen.main.bounds.width - width) * 0.5,
                y: (UIScreen.main.bounds.height - height) * 0.5,
                width: width,
                height: height
            )
            model.contentViewFrameBlock = { _, _, _ in frame }

            let animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
            animation.values = [-frame.maxY, 20, -10, 0]
            animation.keyTimes = [0, 0.5, 0.75, 1]
            animation.timingFunctions = [
                CAMediaTimingFunction(name: .easeOut),
                CAMediaTimingFunction(name: .linear),
                CAMediaTimingFunction(name: .easeOut)
            ]
            animation.duration = 0.25
            model.entryAnimation = animation
        }
    }

    private static func configureNavigation(
        _ model: TXCustomModel,
        configuration: [String: Any],
        style: PNSBuildModelStyle
    ) {
        let title = NSAttributedString(
            string: configuration.string("navText", default: "一键登录授权页面"),
            attributes: [
                .foregroundColor: UIColor.aliAuth(hex: configuration.string("navTextColor", default: "#000000")),
                .font: UIFont.systemFont(ofSize: configuration.cgFloat("navTextSize", default: 20))
            ]
        )
        if [.alertPortrait, .alertLandscape, .sheetPortrait].contains(style) {
            model.alertTitle = title
        } else {
            model.navTitle = title
        }

        guard model.navIsHidden, !model.hideNavBackItem else { return }
        let custom = configuration.dictionary("customReturnBtn")
        let customImage = custom.flatMap { assetImage($0.string("imgPath")) }
        if let image = customImage
            ?? (model.value(forKey: "navBackImage") as? UIImage)
            ?? bundledImage("icon_close_light") {
            model.navBackImage = image
        }
        model.navBackButtonFrameBlock = { _, _, frame in
            var frame = frame
            if let custom, customImage != nil {
                frame.origin.y = custom.cgFloat("top", default: 5)
                frame.origin.x = custom.cgFloat("left", default: 15)
                frame.size.width = custom.cgFloat("width", default: 40)
                frame.size.height = custom.cgFloat("height", default: 40)
            } else {
                frame.origin.y = configuration.cgFloat("navReturnOffsetY", default: 5)
                frame.origin.x = configuration.cgFloat("navReturnOffsetX", default: 15)
                frame.size.width = configuration.cgFloat("navReturnImgWidth", default: 40)
                frame.size.height = configuration.cgFloat("navReturnImgHeight", default: 40)
            }
            return frame
        }
    }

    private static func configurePrimaryControls(_ model: TXCustomModel, configuration: [String: Any]) {
        if !model.logoIsHidden, model.value(forKey: "logoImage") is UIImage {
            model.logoFrameBlock = { screenSize, superViewSize, _ in
                let width = configuration.cgFloat("logoWidth", default: 80)
                return CGRect(
                    x: (superViewSize.width - width) * 0.5,
                    y: configuration.cgFloat("logoOffsetY", default: screenSize.height > screenSize.width ? 30 : 15),
                    width: width,
                    height: configuration.cgFloat("logoHeight", default: 80)
                )
            }
        }

        if !model.sloganIsHidden {
            model.sloganText = NSAttributedString(
                string: configuration.string("sloganText", default: "思预云欢迎您使用一键登录"),
                attributes: [
                    .foregroundColor: UIColor.aliAuth(hex: configuration.string("sloganTextColor", default: "#555555")),
                    .font: UIFont.systemFont(ofSize: configuration.cgFloat("sloganTextSize", default: 19))
                ]
            )
            model.sloganFrameBlock = { screenSize, _, frame in
                guard screenSize.height > screenSize.width else { return .zero }
                var frame = frame
                frame.origin.y = configuration.cgFloat("sloganOffsetY", default: 120)
                return frame
            }
        }

        model.numberFrameBlock = { screenSize, _, frame in
            var frame = frame
            frame.origin.y = screenSize.height > screenSize.width
                ? configuration.cgFloat("numFieldOffsetY", default: 165)
                : 110
            return frame
        }

        model.loginBtnText = NSAttributedString(
            string: configuration.string("logBtnText", default: "一键登录"),
            attributes: [
                .foregroundColor: UIColor.aliAuth(hex: configuration.string("logBtnTextColor", default: "#ff00ff")),
                .font: UIFont.systemFont(ofSize: configuration.cgFloat("logBtnTextSize", default: 23))
            ]
        )
        let paths = configuration.string("logBtnBackgroundPath", default: ",").components(separatedBy: ",")
        if paths.count == 3 {
            let customImages = paths.compactMap(assetImage)
            if customImages.count == 3 {
                model.loginBtnBgImgs = customImages
            } else if let click = bundledImage("button_click"), let unclick = bundledImage("button_unclick") {
                model.loginBtnBgImgs = [click, unclick, click]
            }
        }
        model.loginBtnFrameBlock = { screenSize, superViewSize, frame in
            var frame = frame
            guard screenSize.height > screenSize.width else {
                frame.origin.y = 160
                return frame
            }
            let width = configuration.cgFloat("logBtnWidth", default: 300)
            frame.size = CGSize(width: width, height: configuration.cgFloat("logBtnHeight", default: 40))
            frame.origin = CGPoint(
                x: (superViewSize.width - width) * 0.5,
                y: configuration.cgFloat("logBtnOffsetY", default: 220)
            )
            return frame
        }

        if !model.changeBtnIsHidden {
            model.changeBtnTitle = NSAttributedString(
                string: configuration.string("switchAccText", default: "切换到其他方式"),
                attributes: [
                    .foregroundColor: UIColor.aliAuth(hex: configuration.string("switchAccTextColor", default: "#555555")),
                    .font: UIFont.systemFont(ofSize: configuration.cgFloat("switchAccTextSize", default: 18))
                ]
            )
            model.changeBtnFrameBlock = { screenSize, superViewSize, frame in
                guard screenSize.height > screenSize.width else { return .zero }
                return CGRect(
                    x: 10,
                    y: configuration.cgFloat("switchOffsetY", default: frame.origin.y),
                    width: superViewSize.width - 20,
                    height: 30
                )
            }
        }
    }

    private static func configureCustomViews(
        _ model: TXCustomModel,
        configuration: [String: Any],
        style: PNSBuildModelStyle,
        backgroundView: PNSBackgroundView?,
        target: AnyObject,
        selector: Selector
    ) {
        guard let custom = configuration.dictionary("customThirdView"),
              let paths = custom.array("viewItemPath") as? [String],
              !paths.isEmpty else { return }
        let names = custom.array("viewItemName") as? [String] ?? []
        let width = custom.cgFloat("itemWidth", default: 70)
        let height = custom.cgFloat("itemHeight", default: 70)
        let offsetY = custom.cgFloat("top", default: 20)
        let spacing = custom.cgFloat("space", default: 30)
        let buttons = paths.enumerated().map { index, path -> CustomButton in
            let button = CustomButton(frame: CGRect(x: 0, y: 0, width: width, height: height))
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.font = .systemFont(ofSize: custom.cgFloat("size", default: 17))
            button.tag = index
            button.setTitle(index < names.count ? names[index] : "", for: .normal)
            button.setTitleColor(.aliAuth(hex: custom.string("color", default: "#3C4E5F")), for: .normal)
            button.setBackgroundImage(assetImage(path), for: .normal)
            button.addTarget(target, action: selector, for: .touchUpInside)
            return button
        }

        model.customViewBlock = { container in
            if let backgroundView { container.addSubview(backgroundView) }
            buttons.forEach(container.addSubview)
        }
        model.customViewLayoutBlock = { screenSize, contentFrame, navFrame, _, _, _, _, _, _, _ in
            if let backgroundView {
                backgroundView.frame = CGRect(
                    x: 0,
                    y: -navFrame.maxY,
                    width: contentFrame.width,
                    height: contentFrame.height
                )
            }
            let contentWidth: CGFloat = [.alertPortrait, .alertLandscape].contains(style)
                ? configuration.cgFloat("dialogWidth")
                : screenSize.width
            let totalWidth = width * CGFloat(buttons.count) + spacing * CGFloat(max(0, buttons.count - 1))
            for (index, button) in buttons.enumerated() {
                button.frame.origin = CGPoint(
                    x: (contentWidth - totalWidth) * 0.5 + (spacing + width) * CGFloat(index),
                    y: offsetY
                )
            }
        }
    }

    private static func configurePrivacy(_ model: TXCustomModel, configuration: [String: Any]) {
        if !model.checkBoxIsHidden,
           let unchecked = assetImage(configuration.string("uncheckedImgPath")),
           let checked = assetImage(configuration.string("checkedImgPath")) {
            model.checkBoxImages = [unchecked, checked]
        }
        model.privacyOne = [configuration.string("protocolOneName"), configuration.string("protocolOneURL")]
        model.privacyTwo = [configuration.string("protocolTwoName"), configuration.string("protocolTwoURL")]
        model.privacyThree = [configuration.string("protocolThreeName"), configuration.string("protocolThreeURL")]
        model.expandAuthPageCheckedScope = true
        model.privacyFrameBlock = { _, _, frame in
            var frame = frame
            let y = configuration.cgFloat("privacyOffsetY", default: -1)
            let x = configuration.cgFloat("privacyOffsetX", default: -1)
            if y > -1 { frame.origin.y = y }
            if x > -1 { frame.origin.x = x }
            return frame
        }
    }

    private static func configureDialog(
        _ model: TXCustomModel,
        configuration: [String: Any],
        style: PNSBuildModelStyle
    ) {
        guard [.alertPortrait, .alertLandscape, .sheetPortrait].contains(style) else { return }
        if model.value(forKey: "alertCloseImage") == nil,
           let image = bundledImage("icon_close_light") {
            model.alertCloseImage = image
        }
        model.alertCloseItemFrameBlock = { screenSize, _, frame in
            guard screenSize.width <= screenSize.height else { return .zero }
            return CGRect(
                x: configuration.cgFloat("alertCloseImageX", default: 5),
                y: configuration.cgFloat("alertCloseImageY", default: 5),
                width: configuration.cgFloat("alertCloseImageW", default: 30),
                height: configuration.cgFloat("alertCloseImageH", default: 30)
            )
        }

        if style == .alertPortrait {
            let screen = UIScreen.main.bounds.size
            let ratio = max(screen.width, screen.height) / 667
            model.contentViewFrameBlock = { screenSize, _, _ in
                if screenSize.width > screenSize.height {
                    let x = ratio * 80
                    let width = configuration.cgFloat("dialogWidth", default: screenSize.width - x * 2)
                    let y = (screenSize.height - width * 0.5) * 0.5
                    return CGRect(
                        x: x,
                        y: y,
                        width: width,
                        height: configuration.cgFloat("dialogHeight", default: screenSize.height - 2 * y)
                    )
                }
                let width = configuration.cgFloat("dialogWidth", default: screenSize.width / 2)
                let height = configuration.cgFloat("dialogHeight", default: screenSize.height / 2)
                return CGRect(
                    x: configuration.cgFloat("dialogOffsetX", default: (screen.width - width) / 2),
                    y: configuration.cgFloat("dialogOffsetY", default: (screen.height - height) / 2),
                    width: width,
                    height: height
                )
            }
        } else if style == .sheetPortrait {
            model.contentViewFrameBlock = { _, superViewSize, frame in
                var frame = frame
                frame.size = CGSize(
                    width: superViewSize.width,
                    height: configuration.cgFloat("dialogHeight", default: 460)
                )
                frame.origin = CGPoint(x: 0, y: superViewSize.height - frame.height)
                return frame
            }
        }
    }

    private static func configurePrivacyAlert(_ model: TXCustomModel, configuration: [String: Any]) {
        model.privacyAlertTitleFrameBlock = { _, _, frame in
            CGRect(
                x: 0,
                y: configuration.cgFloat("privacyAlertTitleOffsetY", default: 20),
                width: frame.width,
                height: frame.height
            )
        }
        model.privacyAlertFrameBlock = { _, _, frame in
            CGRect(
                x: configuration.cgFloat("privacyAlertOffsetX", default: 40),
                y: configuration.cgFloat("privacyAlertOffsetY", default: frame.origin.y),
                width: configuration.cgFloat("privacyAlertWidth", default: frame.width - 80),
                height: configuration.cgFloat("privacyAlertHeight", default: 200)
            )
        }
        model.privacyAlertButtonFrameBlock = { _, _, frame in
            CGRect(
                x: frame.origin.x,
                y: frame.origin.y,
                width: configuration.cgFloat("privacyAlertBtnWidth", default: frame.width),
                height: configuration.cgFloat("privacyAlertBtnHeigth", default: 50)
            )
        }
        if model.privacyAlertIsNeedShow {
            model.privacyAlertPrivacyContentFrameBlock = { _, _, frame in
                let margin = configuration.cgFloat("privacyAlertContentHorizontalMargin")
                return CGRect(
                    x: margin,
                    y: frame.origin.y + 10,
                    width: frame.width - margin * 2,
                    height: frame.height
                )
            }
        }
    }

    private static func bundledImage(_ name: String) -> UIImage? {
        #if SWIFT_PACKAGE
        return UIImage(named: name, in: .module, compatibleWith: nil) ?? UIImage(named: name)
        #else
        return UIImage(named: name)
        #endif
    }

    private static func assetURL(_ key: String) -> URL? {
        guard !key.isEmpty else { return nil }
        let lookupKey: String
        if let flutterController = AliAuthViewController.current as? FlutterViewController {
            lookupKey = flutterController.lookupKey(forAsset: key)
        } else {
            lookupKey = FlutterDartProject.lookupKey(forAsset: key)
        }
        guard let path = Bundle.main.path(forResource: lookupKey, ofType: nil) else { return nil }
        return URL(fileURLWithPath: path)
    }

    private static func assetImage(_ key: String) -> UIImage? {
        assetURL(key).flatMap { UIImage(contentsOfFile: $0.path) }
    }
}
