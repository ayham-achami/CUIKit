//
//  UIFactory.swift
//

import UIKit

/// View порожденная из фабрики
public protocol Factorable: UIView {}

/// Протокол с идентификатором
public protocol Identifiable {
    
    typealias Identifier = String
    
    /// Идентификатор объекта
    static var identifier: Identifier { get }
}

/// Протокол с типом
public protocol Kindable {
    
    typealias Kind = String
    
    /// тип объекта
    static var kind: Kind { get }
}

/// Провайдер ui-моделей
public protocol UIModelProvider {
    
    associatedtype Model: UIModel
}

/// Фабрика UIView
public protocol UIViewFactory {
    
    associatedtype View: Factorable
    
    /// Метод для отрисовки view
    /// - Parameter view: вью для отрисовки
    func rendering(_ view: View)
}

/// Фабрика UIView с делеагтом
public protocol UIDelegableViewFactory: UIViewFactory {
    
    associatedtype Delegate
}

/// Фабрика UIView с реюзом
public protocol UIReusableViewFactory: UIViewFactory, UIModelProvider, Identifiable {
    
    /// Инициализатор с моделью
    /// - Parameter model: модель для View
    init(_ model: Model)
}

// MARK: - UIReusableViewFactory + Default
public extension UIReusableViewFactory {
    
    static var identifier: Identifier {
        String(describing: View.self)
    }
}

/// /// Фабрика UIView с реюзом и делегатом
public protocol UIDelegableReusableViewFactory: UIDelegableViewFactory, UIModelProvider, Identifiable {
    
    /// Инициализатор с моделью и делегатом
    /// - Parameters:
    ///   - model: модель для View
    ///   - delegate: делегат для View
    init(_ model: Model, _ delegate: Delegate)
}

// MARK: - UIDelegableReusableViewFactory + Default
public extension UIDelegableReusableViewFactory {
    
    static var identifier: Identifier {
        String(describing: View.self)
    }
}

/// UISupplementaryViewFactory + UIViewFactory
public protocol UISupplementaryViewFactory: UIViewFactory {}

/// Фабирка для Supplementary c реюзом
public protocol UIReusableSupplementaryViewFactory: UISupplementaryViewFactory, UIModelProvider, Identifiable, Kindable {
    
    /// Инициализатор с моделью
    /// - Parameter model: модель для View
    init(_ model: Model)
}

// MARK: - UIReusableSupplementaryViewFactory + Default
public extension UIReusableSupplementaryViewFactory {
    
    static var identifier: Identifier {
        String(describing: View.self)
    }
}

/// Фабирка для Supplementary c реюзом и делегатом
public protocol UIDelegableReusableSupplementaryViewFactory: UISupplementaryViewFactory, UIDelegableViewFactory, UIModelProvider, Identifiable, Kindable {
    
    /// Инициализатор с моделью и делегатом
    /// - Parameters:
    ///   - model: модель для View
    ///   - delegate: делегат для View
    init(_ model: Model, _ delegate: Delegate)
}

// MARK: - UIDelegableReusableSupplementaryViewFactory + Default
public extension UIDelegableReusableSupplementaryViewFactory {
    
    static var identifier: Identifier {
        String(describing: View.self)
    }
}
