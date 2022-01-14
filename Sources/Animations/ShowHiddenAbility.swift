//
//  ShowHiddenAbility.swift
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

/// протокол возможности скрытия и показа
public protocol ShowHiddenAbility: AnchorTransformable {

    /// показать изменения прозрачность объекта
    func showChangedAlpha()

    /// скрыть изменения прозрачность объекта
    func hideChangedAlpha()

    /// показать изменения трансформ объекта
    func showChangedTransform()

    /// скрыть изменения трансформ объекта
    ///
    /// - Parameter anchor: направление трансфера
    func hideChangedTransform(anchor: TransformAnchor)

    /// показать изменения прозрачность и трансформ объекта
    func showChangedTransformAlpha()

    /// скрыть изменения прозрачность и трансформ объекта
    ///
    /// - Parameter anchor: направление трансфера
    func hideChangedTransformAlpha(anchor: TransformAnchor)
}

// MARK: - ShowHiddenAbility + UIView + Default
public extension ShowHiddenAbility where Self: UIView {

    func showChangedAlpha() {
        alpha = 1
    }

    func hideChangedAlpha() {
        alpha = 0
    }

    func showChangedTransform() {
        transform = .identity
    }

    func hideChangedTransform(anchor: TransformAnchor) {
        transform = transform(for: anchor)
    }

    func showChangedTransformAlpha() {
        transform = .identity
        alpha = 1
    }

    func hideChangedTransformAlpha(anchor: TransformAnchor) {
        transform = transform(for: anchor)
        alpha = 0
    }
}

/// протокол возможности скрытия и показа анимационно
public protocol ShowHideAnimation: AnchorTransformable {

    /// показать изменения прозрачность объекта
    ///
    /// - Parameter duration: общая продолжительность анимации, измеренная в секундах.
    func showAnimateAlpha(withDuration duration: TimeInterval)

    /// скрыть изменения прозрачность объекта
    ///
    /// - Parameter duration: общая продолжительность анимации, измеренная в секундах.
    func hidAnimateAlpha(withDuration duration: TimeInterval)

    /// показать изменения трансформ объекта
    ///
    /// - Parameter duration: общая продолжительность анимации, измеренная в секундах.
    func showAnimateTransform(withDuration duration: TimeInterval)

    /// скрыть изменения трансформ объекта
    ///
    /// - Parameters:
    ///   - duration: общая продолжительность анимации, измеренная в секундах.
    ///   - anchor: направление трансфера
    func hideAnimateTransform(withDuration duration: TimeInterval, using anchor: TransformAnchor)

    /// показать изменения прозрачность и трансформ объекта
    ///
    /// - Parameter duration: общая продолжительность анимации, измеренная в секундах.
    func showAnimateTransformAlpha(withDuration duration: TimeInterval)

    /// скрыть изменения прозрачность и трансформ объекта
    ///
    /// - Parameters:
    ///   - duration: общая продолжительность анимации, измеренная в секундах.
    ///   - anchor: направление трансфера
    func hideAnimateTransformAlpha(withDuration duration: TimeInterval, using anchor: TransformAnchor)
}

// MARK: - ShowHideAnimation + UIView + Default
public extension ShowHideAnimation where Self: UIView {

    func showAnimateAlpha(withDuration duration: TimeInterval) {
        UIView.animate(withDuration: duration) { [weak self] in
            guard let self = self else { return }
            self.alpha = 1
        }
    }

    func hidAnimateAlpha(withDuration duration: TimeInterval) {
        UIView.animate(withDuration: duration) { [weak self] in
            guard let self = self else { return }
            self.alpha = 0
        }
    }

    func showAnimateTransform(withDuration duration: TimeInterval) {
        UIView.animate(withDuration: duration) { [weak self] in
            guard let self = self else { return }
            self.transform = .identity
        }
    }

    func hideAnimateTransform(withDuration duration: TimeInterval, using anchor: TransformAnchor) {
        UIView.animate(withDuration: duration) { [weak self] in
            guard let self = self else { return }
            self.transform = self.transform(for: anchor)
        }
    }

    func showAnimateTransformAlpha(withDuration duration: TimeInterval) {
        UIView.animate(withDuration: duration) { [weak self] in
            guard let self = self else { return }
            self.alpha = 1
            self.transform = .identity
        }
    }

    func hideAnimateTransformAlpha(withDuration duration: TimeInterval, using anchor: TransformAnchor) {
        UIView.animate(withDuration: duration) { [weak self] in
            guard let self = self else { return }
            self.alpha = 0
            self.transform = self.transform(for: anchor)
        }
    }
}

// MARK: - UIView + ShowHiddenAbility
extension UIView: ShowHiddenAbility {}

// MARK: - UIView + ShowHideAnimation
extension UIView: ShowHideAnimation {}
