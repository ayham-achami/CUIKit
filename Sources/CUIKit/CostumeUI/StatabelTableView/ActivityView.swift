//
//  ActivityView.swift
//

import UIKit

/// протокол индикатор загрузки
public protocol ActivityProtocol {

    /// начать анимацию загрузки
    func startAnimating()

    /// остановить анимацию загрузки
    func stopAnimating()
}

/// тип вью индикатор загрузки
public typealias ActivityView = ActivityProtocol & UIView

// MARK: - UIActivityIndicatorView + ActivityProtocol
extension UIActivityIndicatorView: ActivityProtocol {}
