//
//  ShowHiddenAbility.swift
//

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
