//
//  Animations.swift
//

import UIKit

/// Пространство имен анимации
internal struct AnimationNamespace {

    /// Название слоев имеющий анимацию
    struct Layers {

        /// Слой с импульсной анимаций
        static var ripple: String { "RippleLayer" }
    }
}

/// Базовый протокол анимации
public protocol ViewAnimation {}
