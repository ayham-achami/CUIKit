//
//  CompletionAnimation.swift
//

import UIKit

/// Анимации завершения
public protocol CompletionAnimation: ViewAnimation {

    /// Завершение с эффектом увядания
    /// - Parameter duration: Продолжительность анимации
    func fadeAnimation(duration: TimeInterval)
}

// MARK: - CompletionAnimation + CALayer + Default
public extension CompletionAnimation where Self: CALayer {

    /// Завершение с эффектом увядания
    /// - Parameters:
    ///   - view: Вью создающий анимацию
    ///   - previousClipsToBounds: Предыдущий `ClipsToBounds`
    ///   - duration: Продолжительность анимации
    func fadeAnimation(view: UIView? = nil, previousClipsToBounds: Bool? = nil, duration: TimeInterval) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.removeAllAnimations()
            self.removeFromSuperlayer()
            guard let view = view,
                  let previousClipsToBounds = previousClipsToBounds else { return }
            view.clipsToBounds = previousClipsToBounds
        }

        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fillMode = .both
        fadeAnimation.duration = duration
        fadeAnimation.fromValue = 1
        fadeAnimation.toValue = 0
        fadeAnimation.isRemovedOnCompletion = false
        add(fadeAnimation, forKey: "opacity")
        CATransaction.commit()
    }

    func fadeAnimation(duration: TimeInterval) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.removeAllAnimations()
            self.removeFromSuperlayer()
        }

        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fillMode = .both
        fadeAnimation.duration = duration
        fadeAnimation.fromValue = 1
        fadeAnimation.toValue = 0
        fadeAnimation.isRemovedOnCompletion = false
        add(fadeAnimation, forKey: "opacity")
        CATransaction.commit()
    }
}

// MARK: - CALayer + CompletionAnimation
extension CALayer: CompletionAnimation {}
