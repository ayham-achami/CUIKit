//
//  TransformAnchor.swift
//

import UIKit

/// Направление трансфера
public enum TransformAnchor {
    
    /// - topAnchor: Вверх
    case topAnchor
    /// - bottomAnchor: Вниз
    case bottomAnchor
    /// - leftAnchor: Влева
    case leftAnchor
    /// - rightAnchor: Вправа
    case rightAnchor
}

/// Протокол трансфер объекта
public protocol AnchorTransformable: ViewAnimation {

    /// Возвращает нужный сдвиг по нужному направлению
    /// - Parameter anchor: Направление трансфера
    /// - Returns: Нужный сдвиг
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
