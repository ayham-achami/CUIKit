//
//  CompletionAnimation.swift
//
//  The MIT License (MIT)
//
//  Copyright (c) 2019 Community Arch
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

/// Анимации завершения
public protocol CompletionAnimation: ViewAnimation {

    /// завершение с эффектом увядания
    ///
    /// - Parameter duration: продолжительность анимации
    func fadeAnimation(duration: TimeInterval)
}

// MARK: - CompletionAnimation + CALayer + Default
public extension CompletionAnimation where Self: CALayer {

    /// завершение с эффектом увядания
    /// - Parameter view: вью создаюший анимацию
    /// - Parameter previousClipsToBounds: предыдущий `ClipsToBounds`
    /// - Parameter duration: продолжительность анимации
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
