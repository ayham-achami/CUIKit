//
//  TransformZoom.swift
//

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
