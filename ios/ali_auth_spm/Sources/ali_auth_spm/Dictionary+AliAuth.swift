import Foundation
import UIKit

extension Dictionary where Key == String, Value == Any {
    func string(_ key: String, default defaultValue: String = "") -> String {
        guard let value = self[key], !(value is NSNull) else { return defaultValue }
        return value as? String ?? String(describing: value)
    }

    func bool(_ key: String, default defaultValue: Bool = false) -> Bool {
        guard let value = self[key], !(value is NSNull) else { return defaultValue }
        if let value = value as? Bool { return value }
        if let value = value as? NSNumber { return value.boolValue }
        if let value = value as? String { return (value as NSString).boolValue }
        return defaultValue
    }

    func int(_ key: String, default defaultValue: Int = 0) -> Int {
        guard let value = self[key], !(value is NSNull) else { return defaultValue }
        if let value = value as? NSNumber { return value.intValue }
        if let value = value as? String, let result = Int(value) { return result }
        return defaultValue
    }

    func cgFloat(_ key: String, default defaultValue: CGFloat = 0) -> CGFloat {
        guard let value = self[key], !(value is NSNull) else { return defaultValue }
        if let value = value as? NSNumber { return CGFloat(value.doubleValue) }
        if let value = value as? String, let result = Double(value) { return CGFloat(result) }
        return defaultValue
    }

    func dictionary(_ key: String) -> [String: Any]? {
        self[key] as? [String: Any]
    }

    func array(_ key: String) -> [Any]? {
        self[key] as? [Any]
    }
}

extension UIColor {
    static func aliAuth(hex value: String, alpha: CGFloat = 1) -> UIColor {
        var text = value.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if text.hasPrefix("0X") { text.removeFirst(2) }
        if text.hasPrefix("#") { text.removeFirst() }

        if text.count == 8, let number = UInt64(text, radix: 16) {
            return UIColor(
                red: CGFloat((number >> 16) & 0xff) / 255,
                green: CGFloat((number >> 8) & 0xff) / 255,
                blue: CGFloat(number & 0xff) / 255,
                alpha: CGFloat((number >> 24) & 0xff) / 255
            )
        }
        guard text.count == 6, let number = UInt64(text, radix: 16) else { return .black }
        return UIColor(
            red: CGFloat((number >> 16) & 0xff) / 255,
            green: CGFloat((number >> 8) & 0xff) / 255,
            blue: CGFloat(number & 0xff) / 255,
            alpha: alpha
        )
    }
}

enum AliAuthViewController {
    static var activeWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            let scenes = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .filter { $0.activationState == .foregroundActive }
            return scenes.flatMap(\.windows).first(where: \.isKeyWindow)
                ?? scenes.flatMap(\.windows).first
        }
        return UIApplication.shared.delegate?.window ?? nil
    }

    static var current: UIViewController? {
        var controller = activeWindow?.rootViewController
        while let current = controller {
            if let presented = current.presentedViewController {
                controller = presented
            } else if let navigation = current as? UINavigationController,
                      let top = navigation.topViewController {
                controller = top
            } else if let tab = current as? UITabBarController,
                      let selected = tab.selectedViewController {
                controller = selected
            } else {
                return current
            }
        }
        return nil
    }
}
