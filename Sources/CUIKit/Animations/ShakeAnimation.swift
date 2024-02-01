//
//  ShakeAnimation.swift
//

import UIKit

/// Протокол анимация встряхивание
public protocol ShakeAnimation: ViewAnimation {

    /// Анимация встряхивание
    func shakeAnimation()
}

// MARK: - ShakeAnimation + UIView + Default
public extension ShakeAnimation where Self: UIView {

    func shakeAnimation() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x - 8, y: center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: center.x + 8, y: center.y))
        layer.add(animation, forKey: "position")
    }
}

// MARK: - UIView + ShakeAnimation
extension UIView: ShakeAnimation {}
