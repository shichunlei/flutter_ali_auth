import UIKit

final class CustomButton: UIButton {
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        CGRect(x: contentRect.minX, y: contentRect.maxY + 8, width: contentRect.width, height: 20)
    }

    override func backgroundRect(forBounds bounds: CGRect) -> CGRect {
        CGRect(x: bounds.minX, y: bounds.minY, width: bounds.width, height: bounds.height)
    }
}
