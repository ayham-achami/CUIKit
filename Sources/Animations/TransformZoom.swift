//
//  TransformZoom.swift
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

/// Анимация изменения размера
public protocol TransformZoom: ViewAnimation {

    /// Анимация появление через увелечение размера
    ///
    /// - Parameter duration: продолжительность анимации
    func showChangedZoom(withDuration duration: TimeInterval)
    /// Анимация скрытия через уменьшение размера
    ///
    /// - Parameter duration: продолжительность анимации
    func hideChangedZoom(withDuration duration: TimeInterval)
    /// Анимация появление через увелечение размера
    func showChangedZoom()
    /// Анимация скрытия через уменьшение размера
    func hideChangedZoom()
}

// MARK: - UIView + TransformZoom + Default
public extension TransformZoom where Self: UIView {

    /// Анимация появление через увелечение размера
    ///
    /// - Parameters:
    ///   - duration: продолжительность анимации
    ///   - delay: задержка перед анимацией
    func showChangedZoom(withDuration duration: TimeInterval, delay: TimeInterval) {
        UIView.animate(withDuration: 0.3, delay: delay, options: .curveEaseInOut, animations: { [weak self ] in
            guard let self = self else { return }
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.alpha = 0.6
            }, completion: { _ in
                UIView.animate(withDuration: duration / 2) { [weak self] in
                    guard let self = self else { return }
                    self.transform = .identity
                    self.alpha = 1
                }
        })
    }

    /// Анимация появление через увелечение размера
    ///
    /// - Parameter duration: продолжительность анимации
    func showChangedZoom(withDuration duration: TimeInterval) {
        showChangedZoom(withDuration: duration, delay: 0)
    }

    /// Анимация скрытия через уменьшение размера
    ///
    /// - Parameter duration: продолжительность анимации
    func hideChangedZoom(withDuration duration: TimeInterval) {
        UIView.animate(withDuration: duration) { [weak self] in
            guard let self = self else { return }
            self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            self.alpha = 0
        }
    }

    /// Анимация появление через увелечение размера
    func showChangedZoom() {
        transform = .identity
        alpha = 1
    }

    /// Анимация скрытия через уменьшение размера
    func hideChangedZoom() {
        transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        alpha = 0
    }
}

// MARK: - UIView + TransformZoom
extension UIView: TransformZoom {}
