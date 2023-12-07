//
//  Animations.swift
//

import UIKit

/// пространство имен анимации
internal struct AnimationNamespace {

    /// название слоев имеющий анимацию
    struct Layers {

        /// слой с импульсной анимацей
        static var ripple: String { "RippleLayer" }
    }
}

/// базовый протокол анимации
public protocol ViewAnimation {}
