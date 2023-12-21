//
//  ViewFactory.swift
//

import UIKit

/// люой вью
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public protocol FactorableView {}

// MARK: - UIView + FactorableView
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
extension UIView: FactorableView {}

/// протокол реализующий логику создание лююой вью через фабрику
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public protocol AnyViewFactory {

    /// тип создаваемой вью
    static var wrappedViewType: FactorableView.Type { get }

    /// тип модель вью
    static var wrappedModelType: UIModel.Type { get }

    /// настроить вью на осной бизнес логики
    ///
    /// - Parameter anyView: любой вью `UIView`
    func setup(_ anyView: FactorableView)
}

/// протокол реализующий логику создание вью через фабрику
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public protocol ViewFactory: AnyViewFactory {

    /// тип создаваемой ыью
    associatedtype ViewType: FactorableView

    /// тип модель вью
    associatedtype ModelType: UIModel

    /// инициализация с объектом модели вью
    ///
    /// - Parameter model: объект модели вью
    init(_ model: Self.ModelType)

    /// настроить вью на осной бизнес логики
    ///
    /// - Parameter view: объект вью наследник `UIView`
    func setup(_ view: Self.ViewType)
}

/// протокол реализующий логику создание вью через фабрику и настройки делегата
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public protocol DelegationViewFactory: AnyViewFactory {

    /// тип создаваемой вью
    associatedtype ViewType: FactorableView

    /// тип делегата вью
    associatedtype DelegateType: Any

    /// тип модель вью
    associatedtype ModelType: UIModel

    /// инициализация с объектом модели вью
    ///
    /// - Parameter
    ///   - model: объект модели вью
    ///   - delegate: делегат вью
    init(model: Self.ModelType, delegate: Self.DelegateType)

    /// настроить вью на осной бизнес логики
    ///
    /// - Parameter view: объект вью наследник `UIView`
    func setup(_ view: Self.ViewType)
}

/// тип переиспользуемой вью
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public typealias ReusableSupplementaryViewKind = String

/// протокол реализующий логику создание лююой переиспользуемой вью через фабрику
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public protocol AnyReusableSupplementaryViewFactory: AnyViewFactory {

    /// тип переиспользуемой вью
    static var viewKind: ReusableSupplementaryViewKind { get }

    /// идентификатор переиспользования вью
    var reuseIdentifier: String { get }
}

/// протокол реализующий логику создания переиспользуемой вью через фабрику
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public protocol ReusableSupplementaryViewFactory: AnyReusableSupplementaryViewFactory {

    /// тип создаваемой ыью
    associatedtype ViewType: FactorableView

    /// тип модель вью
    associatedtype ModelType: UIModel

    /// инициализация с объектом модели и тип переиспользуемой вью
    ///
    /// - Parameters:
    ///   - model: объект модели вью
    init(model: Self.ModelType)

    /// настроить вью на осной бизнес логики
    ///
    /// - Parameter view: объект вью наследник `UIView`
    func setup(_ view: Self.ViewType)
}

// MARK: - ReusableSupplementaryViewFactory + Default
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public extension ReusableSupplementaryViewFactory {

    /// обернутый тип вью
    static var wrappedViewType: FactorableView.Type {
        ViewType.self
    }

    /// обернутый тип модели
    static var wrappedModelType: UIModel.Type {
        ModelType.self
    }

    /// идентификатор для переиспользования
    var reuseIdentifier: String {
        String(describing: Self.wrappedViewType)
    }

    /// настроить вью на осной бизнес логики
    ///
    /// - Parameter anyView: любой вью `UIView`
    func setup(_ anyView: FactorableView) {
        guard let view = anyView as? Self.ViewType else {
            fatalError("Given view \(String(describing: type(of: anyView))) is not an instance of \(String(describing: ViewType.self))")
        }
        setup(view)
    }
}

/// протокол реализующий логику создания переиспользуемой вью с делегатом через фабрику
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public protocol DelegationSupplementaryViewFactory: AnyReusableSupplementaryViewFactory {

    /// тип создаваемой вью
    associatedtype ViewType: FactorableView

    /// тип делегата вью
    associatedtype DelegateType: Any

    /// тип модель вью
    associatedtype ModelType: UIModel

    /// инициализация с объектом модели вью
    ///
    /// - Parameter
    ///   - model: объект модели вью
    ///   - delegate: делегат вью
    init(model: Self.ModelType, delegate: Self.DelegateType)

    /// настроить вью на осной бизнес логики
    ///
    /// - Parameter view: объект вью наследник `UIView`
    func setup(_ view: Self.ViewType)
}

// MARK: - DelegationSupplementaryViewFactory + Default
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public extension DelegationSupplementaryViewFactory {

    /// обернутый тип вью
    static var wrappedViewType: FactorableView.Type {
        ViewType.self
    }

    /// обернутый тип делегата
    static var wrappedDelegateType: Any.Type {
        DelegateType.self
    }

    /// обернутый тип модели
    static var wrappedModelType: UIModel.Type {
        ModelType.self
    }

    /// идентификатор для переиспользования
    var reuseIdentifier: String {
        String(describing: Self.wrappedViewType)
    }

    /// настроить вью на осной бизнес логики
    ///
    /// - Parameter anyView: любой вью `UIView`
    func setup(_ anyView: FactorableView) {
        guard let view = anyView as? Self.ViewType else {
            fatalError("Given view \(String(describing: type(of: anyView))) is not an instance of \(String(describing: ViewType.self))")
        }
        setup(view)
    }
}

// MARK: - ViewFactory + Default
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public extension ViewFactory {

    /// обернутый тип вью
    static var wrappedViewType: FactorableView.Type {
        ViewType.self
    }

    /// обернутый тип модели
    static var wrappedModelType: UIModel.Type {
        ModelType.self
    }

    /// настройка на основе view
    ///
    /// - Parameter anyView: view для настройки
    func setup(_ anyView: FactorableView) {
        guard let view = anyView as? Self.ViewType else {
            fatalError("Given view \(String(describing: type(of: anyView))) is not an instance of \(String(describing: ViewType.self))")
        }
        setup(view)
    }
}

// MARK: - DelegationViewFactory + Default
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public extension DelegationViewFactory {

    /// обернутый тип вью
    static var wrappedViewType: FactorableView.Type {
        ViewType.self
    }

    /// обернутый тип модели
    static var wrappedModelType: UIModel.Type {
        ModelType.self
    }

    /// обернутый тип делегата
    static var wrappedDelegateType: Any.Type {
        DelegateType.self
    }

    /// идентификатор
    var identifier: String {
        String(describing: type(of: self).wrappedViewType)
    }

    /// настройка на основе view
    ///
    /// - Parameter anyView: view для настройки
    func setup(_ anyView: FactorableView) {
        guard let view = anyView as? Self.ViewType else {
            fatalError("Given view \(String(describing: type(of: anyView))) is not an instance of \(String(describing: ViewType.self))")
        }
        setup(view)
    }
}
