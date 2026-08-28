import ATAuthSDK
import AuthenticationServices
import Flutter
import UIKit

@objc(AliAuthPlugin)
public final class AliAuthPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    private var configuration: [String: Any] = [:]
    private var model: TXCustomModel?
    private var isChecked = false
    private var isHideToast = false

    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = AliAuthPlugin()
        let methodChannel = FlutterMethodChannel(name: "ali_auth", binaryMessenger: registrar.messenger())
        let eventChannel = FlutterEventChannel(name: "ali_auth/event", binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(instance)
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        requestNetworkPermissionPrompt()
    }

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        guard eventSink == nil else { return nil }
        eventSink = events
        let version = TXCommonHandler.sharedInstance().getVersion()
        showResult(["resultCode": "500004", "msg": version], messageArgument: version)
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        NotificationCenter.default.removeObserver(self)
        eventSink = nil
        return nil
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [String: Any] ?? [:]

        switch call.method {
        case "getPlatformVersion":
            result("iOS \(UIDevice.current.systemVersion)")
        case "getCurrentCarrierName":
            result(TXCommonUtils.getCurrentCarrierName())
        case "initSdk":
            configuration = arguments
            isHideToast = configuration.bool("isHideToast")
            guard eventSink != nil else {
                result(["code": "500001", "msg": "请先对插件进行监听！"])
                return
            }
            initializeSDK(configuration: configuration)
        case "login":
            guard let model else {
                showResult(["resultCode": "500003"])
                return
            }
            isChecked = configuration.bool("privacyState")
            login(with: model, configuration: configuration)
        case "checkEnvAvailable":
            checkEnvironment()
        case "queryCheckBoxIsChecked":
            let checked = TXCommonHandler.sharedInstance().queryCheckBoxIsChecked()
            isChecked = checked
            result(checked)
        case "setCheckboxIsChecked":
            TXCommonHandler.sharedInstance().setCheckboxIsChecked(true)
            isChecked = true
            result(true)
        case "checkCellularDataEnable":
            result([
                "code": "1",
                "msg": "蜂窝网络检测",
                "data": TXCommonUtils.checkDeviceCellularDataEnable()
            ])
        case "preLogin":
            preLogin()
        case "quitPage":
            TXCommonHandler.sharedInstance().cancelLoginVC(animated: true, complete: nil)
        case "hideLoading":
            TXCommonHandler.sharedInstance().hideLoginLoading()
        case "appleLogin":
            startAppleLogin()
        case "openPage":
            openFlutterPage(route: arguments.string("pageRoute", default: "/"))
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private static func requestNetworkPermissionPrompt() {
        guard let url = URL(string: "https://www.baidu.com/") else { return }
        URLSession.shared.dataTask(with: url).resume()
    }

    private func initializeSDK(configuration: [String: Any]) {
        let secret = configuration.string("iosSk")
        guard !secret.isEmpty else {
            showResult(["resultCode": "500000"])
            return
        }

        model = PNSBuildModelUtils.buildModel(
            configuration: configuration,
            target: self,
            selector: #selector(thirdPartyButtonTapped(_:))
        )
        TXCommonHandler.sharedInstance().setAuthSDKInfo(secret) { [weak self] _ in
            guard let self else { return }
            TXCommonHandler.sharedInstance().checkEnvAvailable(with: .loginToken) { [weak self] rawResult in
                guard let self else { return }
                let checkResult = Self.dictionary(rawResult)
                guard Self.code(in: checkResult) == PNSCodeSuccess else {
                    var failure = checkResult
                    failure["token"] = false
                    self.showResult(failure)
                    return
                }

                self.showResult(["resultCode": "600024"])
                TXCommonHandler.sharedInstance().accelerateLoginPage(withTimeout: 5) { [weak self] rawResult in
                    guard let self else { return }
                    let result = Self.dictionary(rawResult)
                    guard Self.code(in: result) == PNSCodeSuccess else {
                        self.showResult(result)
                        return
                    }
                    if !configuration.bool("isDelay"), let model = self.model {
                        self.isChecked = configuration.bool("privacyState")
                        self.login(with: model, configuration: configuration)
                    }
                    self.showResult([
                        "resultCode": "600016",
                        "data": TXCommonUtils.getCurrentCarrierName() ?? ""
                    ])
                }
            }
        }
    }

    private func checkEnvironment() {
        TXCommonHandler.sharedInstance().checkEnvAvailable(with: .loginToken) { [weak self] rawResult in
            guard let self else { return }
            let result = Self.dictionary(rawResult)
            if Self.code(in: result) != PNSCodeSuccess {
                self.showResult(result)
                self.emit([
                    "code": Self.code(in: result),
                    "data": false
                ])
                return
            }
            TXCommonHandler.sharedInstance().accelerateLoginPage(withTimeout: 5, complete: nil)
            self.emit([
                "code": "600024",
                "msg": "终端环境检查⽀持认证",
                "data": true
            ])
        }
    }

    private func preLogin() {
        TXCommonHandler.sharedInstance().checkEnvAvailable(with: .loginToken) { [weak self] rawResult in
            guard let self else { return }
            let result = Self.dictionary(rawResult)
            guard Self.code(in: result) == PNSCodeSuccess else {
                self.showResult(result)
                return
            }
            self.showResult(["resultCode": "600024"])
            TXCommonHandler.sharedInstance().accelerateLoginPage(withTimeout: 5) { [weak self] rawResult in
                guard let self else { return }
                let result = Self.dictionary(rawResult)
                guard Self.code(in: result) == PNSCodeSuccess else {
                    self.showResult(result)
                    return
                }
                self.showResult(["resultCode": "600016"])
            }
        }
    }

    private func login(with model: TXCustomModel, configuration: [String: Any]) {
        guard let controller = AliAuthViewController.current else {
            showResult(["resultCode": "600002"])
            return
        }
        TXCommonHandler.sharedInstance().checkEnvAvailable(with: .loginToken) { [weak self] rawResult in
            guard let self else { return }
            let result = Self.dictionary(rawResult)
            guard Self.code(in: result) == PNSCodeSuccess else {
                self.showResult(result)
                return
            }
            TXCommonHandler.sharedInstance().accelerateLoginPage(withTimeout: 5) { [weak self] rawResult in
                guard let self else { return }
                let result = Self.dictionary(rawResult)
                guard Self.code(in: result) == PNSCodeSuccess else {
                    self.showResult(result)
                    return
                }
                TXCommonHandler.sharedInstance().getLoginToken(
                    withTimeout: 5,
                    controller: controller,
                    model: model
                ) { [weak self] rawResult in
                    guard let self else { return }
                    let result = Self.dictionary(rawResult)
                    let code = Self.code(in: result)
                    _ = AliAuthViewController.current?.view.hitTest(
                        CGPoint(x: controller.view.bounds.width, y: controller.view.bounds.height),
                        with: nil
                    )

                    if code == PNSCodeSuccess {
                        if configuration.bool("autoQuitPage", default: true) {
                            DispatchQueue.main.async {
                                TXCommonHandler.sharedInstance().cancelLoginVC(animated: true, complete: nil)
                            }
                        }
                    } else if code == PNSCodeLoginControllerClickChangeBtn {
                        if self.isChecked || self.isHideToast || !configuration.bool("switchCheck", default: true) {
                            TXCommonHandler.sharedInstance().cancelLoginVC(animated: true, complete: nil)
                        }
                    } else if code == PNSCodeLoginControllerClickCheckBoxBtn {
                        self.isChecked = (result["isChecked"] as? NSNumber)?.boolValue ?? false
                    } else if code == PNSCodeLoginControllerClickCancel || code == PNSCodeCarrierChanged {
                        TXCommonHandler.sharedInstance().cancelLoginVC(animated: true, complete: nil)
                    }
                    self.showResult(result)
                }
            }
        }
    }

    @objc private func thirdPartyButtonTapped(_ sender: UIButton) {
        emit([
            "code": "700005",
            "msg": "点击第三方登录按钮",
            "data": sender.tag
        ])
        if isChecked || isHideToast {
            TXCommonHandler.sharedInstance().cancelLoginVC(animated: true, complete: nil)
        }
    }

    private func emit(_ value: [String: Any]) {
        guard let eventSink else { return }
        var result = value
        result["isChecked"] = isChecked
        eventSink(result)
    }

    private func showResult(_ result: [String: Any], messageArgument: String? = nil) {
        let code = Self.code(in: result)
        let message: String
        if let messageArgument, let format = AliAuthStatus.messages[code] {
            message = String(format: format, messageArgument)
        } else {
            message = AliAuthStatus.messages[code] ?? ""
        }
        emit([
            "code": code,
            "msg": message,
            "data": result["token"] ?? result["data"] ?? ""
        ])
    }

    private static func dictionary(_ value: [AnyHashable: Any]?) -> [String: Any] {
        guard let value else { return [:] }
        return Dictionary(uniqueKeysWithValues: value.compactMap { key, value in
            guard let key = key as? String else { return nil }
            return (key, value)
        })
    }

    private static func code(in result: [String: Any]) -> String {
        guard let value = result["resultCode"] else { return "" }
        return String(describing: value)
    }

    private func openFlutterPage(route: String) {
        let controller = FlutterViewController(
            project: nil,
            initialRoute: route,
            nibName: nil,
            bundle: nil
        )
        controller.modalPresentationStyle = .fullScreen
        AliAuthViewController.current?.present(controller, animated: true)
    }
}

@available(iOS 13.0, *)
extension AliAuthPlugin: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    public func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            emitAppleResult(
                code: 200,
                message: "获取成功",
                user: credential.user,
                familyName: credential.fullName?.familyName ?? "",
                givenName: credential.fullName?.givenName ?? "",
                email: credential.email ?? "",
                identityToken: credential.identityToken,
                authorizationCode: credential.authorizationCode
            )
        } else if let credential = authorization.credential as? ASPasswordCredential {
            emitAppleResult(code: 200, message: "获取成功", user: credential.user)
        } else {
            emitAppleResult(code: 500, message: "授权信息均不符")
        }
    }

    public func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        let message: String
        switch (error as? ASAuthorizationError)?.code {
        case .canceled: message = "用户取消了授权请求"
        case .failed: message = "授权请求失败"
        case .invalidResponse: message = "授权请求响应无效"
        case .notHandled: message = "未能处理授权请求"
        default: message = "授权请求失败未知原因"
        }
        emitAppleResult(code: 500, message: message)
    }

    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        AliAuthViewController.activeWindow ?? UIWindow(frame: UIScreen.main.bounds)
    }

    private func emitAppleResult(
        code: Int,
        message: String,
        user: String = "",
        familyName: String = "",
        givenName: String = "",
        email: String = "",
        identityToken: Data? = nil,
        authorizationCode: Data? = nil
    ) {
        emit([
            "code": code,
            "msg": message,
            "user": user,
            "familyName": familyName,
            "givenName": givenName,
            "email": email,
            "identityTokenStr": identityToken.flatMap { String(data: $0, encoding: .utf8) } ?? "",
            "authorizationCodeStr": authorizationCode.flatMap { String(data: $0, encoding: .utf8) } ?? ""
        ])
    }
}

private extension AliAuthPlugin {
    func startAppleLogin() {
        if #available(iOS 13.0, *) {
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        } else {
            emit([
                "code": 500,
                "msg": "该系统版本不可用Apple登录",
                "user": "",
                "familyName": "",
                "givenName": "",
                "email": "",
                "identityTokenStr": "",
                "authorizationCodeStr": ""
            ])
        }
    }
}
