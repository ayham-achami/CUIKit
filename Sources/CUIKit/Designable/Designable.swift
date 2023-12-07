//
//  Designable.swift
//

import UIKit

/// элемент пользовательского интерфейса со свойствами явных границ
public protocol Borderable {

    /// ширина границы
    var borderWidth: CGFloat { get set }
    /// цвет границы
    var borderColor: UIColor { get set }
}

/// элемент пользовательского интерфейса со свойствами тени
public protocol Shadowable {

    /// цвет тени
    var shadowColor: UIColor? { get set }
    /// радиус тени
    var shadowRadius: CGFloat { get set }
    /// плотность тени
    var shadowOpacity: Float { get set }
    /// отступ тени
    var shadowOffset: CGSize { get set }
}

/// элемент пользовательского интерфейса со свойствами округления
public protocol Roundable {

    /// является ли элемент круглым
    var isRounded: Bool { get set }
    /// радиус, используемый при рисовании закругленных углов
    var cornerRadius: CGFloat { get set }
}

/// проектируемый элемент пользовательского интерфейса
public typealias Designable = Borderable & Shadowable & Roundable
