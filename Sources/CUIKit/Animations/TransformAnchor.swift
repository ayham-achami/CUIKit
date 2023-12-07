//
//  TransformAnchor.swift
//

import UIKit

/// направление трансфера
public enum TransformAnchor {
    /// - topAnchor: вверх
    case topAnchor
    /// - bottomAnchor: вниз
    case bottomAnchor
    /// - leftAnchor: влева
    case leftAnchor
    /// - rightAnchor: вправа
    case rightAnchor
}

/// протокол трансфер объекта
public protocol AnchorTransformable: ViewAnimation {

    /// возвращает нужный сдвиг по нужному направлению
    ///
    /// - Parameter anchor: направление трансфера
    /// - Returns: нужный сдвиг
    func transform(for anchor: TransformAnchor) -> CGAffineTransform
}

// MARK: - UIView + AnchorTransformable + Default
public extension AnchorTransformable where Self: UIView {

    func transform(for anchor: TransformAnchor) -> CGAffineTransform {
        switch anchor {
        case .topAnchor:
            return CGAffineTransform(translationX: 0, y: -frame.height)
        case .bottomAnchor:
            return CGAffineTransform(translationX: 0, y: frame.height)
        case .leftAnchor:
            return CGAffineTransform(translationX: -frame.width, y: 0)
        case .rightAnchor:
            return CGAffineTransform(translationX: frame.width, y: 0)
        }
    }
}
