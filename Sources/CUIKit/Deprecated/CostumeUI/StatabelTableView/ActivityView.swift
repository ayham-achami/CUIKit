//
//  ActivityView.swift
//

import UIKit

/// протокол индикатор загрузки
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public protocol ActivityProtocol {

    /// начать анимацию загрузки
    func startAnimating()

    /// остановить анимацию загрузки
    func stopAnimating()
}

/// тип вью индикатор загрузки
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public typealias ActivityView = ActivityProtocol & UIView

// MARK: - UIActivityIndicatorView + ActivityProtocol
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
extension UIActivityIndicatorView: ActivityProtocol {}
