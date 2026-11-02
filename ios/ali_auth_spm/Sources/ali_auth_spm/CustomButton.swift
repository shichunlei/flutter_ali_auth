import UIKit

final class CustomButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHighlight()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureHighlight()
    }

    private func configureHighlight() {
        adjustsImageWhenHighlighted = false
        showsTouchWhenHighlighted = false
        backgroundColor = .clear
    }

    override func setBackgroundImage(_ image: UIImage?, for state: UIControl.State) {
        super.setBackgroundImage(image, for: state)
        if state == .normal, let image {
            super.setBackgroundImage(image, for: .highlighted)
            super.setBackgroundImage(image, for: .selected)
        }
    }

    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        CGRect(x: contentRect.minX, y: contentRect.maxY + 8, width: contentRect.width, height: 20)
    }

    override func backgroundRect(forBounds bounds: CGRect) -> CGRect {
        CGRect(x: bounds.minX, y: bounds.minY, width: bounds.width, height: bounds.height)
    }
}
