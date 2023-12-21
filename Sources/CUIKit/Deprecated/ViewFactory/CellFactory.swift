//
//  CellFactory.swift
//

import UIKit

/// любая ячейка
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public protocol FactorableCellView: FactorableView {}

// MARK: - UITableViewCell + FactorableCellView
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
extension UITableViewCell: FactorableCellView {}

// MARK: - UICollectionViewCell + FactorableCellView
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
extension UICollectionViewCell: FactorableCellView {}

/// протокол реализующий логику создание любой ячейки через фабрику
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public protocol AnyCellFactory: AnyViewFactory {

    /// идентификатор ячейки
    var identifier: String { get }
}

/// протокол реализующий логику создание ячейки через фабрику
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public protocol CellFactory: AnyCellFactory {

    /// тип создаваемой ячейки
    associatedtype CellType: FactorableCellView

    /// тип модель ячейки
    associatedtype ModelType: UIModel

    /// инициализация с объектом модели ячейки
    ///
    /// - Parameter model: объект модели ячейки
    init(model: Self.ModelType)

    /// настроить ячейку на основой бизнес логики
    ///
    /// - Parameter cell: ячейка может быть `UITableViewCell` или `UICollectionViewCell`
    func setup(_ cell: Self.CellType)
}

/// протокол реализующий логику создание ячейки через фабрику и настройки делегата
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public protocol DelegationCellFactory: AnyCellFactory {

    /// тип создаваемой ячейки
    associatedtype CellType: FactorableCellView

    /// тип делегата ячейки
    associatedtype DelegateType: Any

    /// тип модель ячейки
    associatedtype ModelType: UIModel

    /// инициализация с объектом модели ячейки и делегат
    ///
    /// - Parameters:
    ///   - model: объект модели ячейки
    ///   - delegate: делегат ячейки
    init(model: Self.ModelType, delegate: Self.DelegateType)

    /// настроить ячейку на основой бизнес логики
    ///
    /// - Parameter cell: ячейка может быть `UITableViewCell` или `UICollectionViewCell`
    func setup(_ cell: Self.CellType)
}

// MARK: - CellFactory + Default
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public extension CellFactory {

    /// обернутый тип ячейки
    static var wrappedViewType: FactorableView.Type {
        CellType.self
    }

    /// обернутый тип модели
    static var wrappedModelType: UIModel.Type {
        ModelType.self
    }

    /// идентификатор
    var identifier: String {
        String(describing: type(of: self).wrappedViewType)
    }

    /// настройка на основе view
    ///
    /// - Parameter anyView: view для настройки
    func setup(_ anyView: FactorableView) {
        guard let cell = anyView as? Self.CellType else {
            fatalError("Given view \(String(describing: type(of: anyView))) is not an instance of \(String(describing: CellType.self))")
        }
        setup(cell)
    }
}

// MARK: - DelegationCellFactory + Default
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public extension DelegationCellFactory {

    /// обернутый тип ячейки
    static var wrappedViewType: FactorableView.Type {
        CellType.self
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
        guard let cell = anyView as? Self.CellType else {
            fatalError("Given view \(String(describing: type(of: anyView))) is not an instance of \(String(describing: CellType.self))")
        }
        setup(cell)
    }
}

/// протокол реализующий логику создание заголовок/нижний колонтитул через фабрику
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public protocol HeaderFooterFactory: AnyViewFactory {

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

// MARK: - HeaderFooterFactory + Default
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public extension HeaderFooterFactory {

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
