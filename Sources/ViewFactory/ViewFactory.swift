//
//  ViewFactory.swift
//
//  The MIT License (MIT)
//
//  Copyright (c) 2019 Community Arch
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

/// люой вью
public protocol FactorableView {}

// MARK: - UIView + FactorableView
extension UIView: FactorableView {}

/// протокол реализующий логику создание лююой вью через фабрику
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
public typealias ReusableSupplementaryViewKind = String

/// протокол реализующий логику создание лююой переиспользуемой вью через фабрику
public protocol AnyReusableSupplementaryViewFactory: AnyViewFactory {

    /// тип переиспользуемой вью
    static var viewKind: ReusableSupplementaryViewKind { get }

    /// идентификатор переиспользования вью
    var reuseIdentifier: String { get }
}

/// протокол реализующий логику создания переиспользуемой вью через фабрику
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
