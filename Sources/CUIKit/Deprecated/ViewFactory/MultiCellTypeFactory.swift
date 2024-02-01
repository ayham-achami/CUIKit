//
//  MultiCellTypeFactory.swift
//

import UIKit

/// распознаваемый тип
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public typealias Recognized = AnyHashable

/// распознаваемый объект модели
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public protocol RecognizableModel: UIModel {

    /// признак распознавания объект модели
    static var recognize: Recognized { get }
}

// MARK: - RecognizableModel + Default
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public extension RecognizableModel {

    static var recognize: Recognized {
        String(reflecting: self)
    }
}

///  протокол реализующий логику создание разных тепов ячейк через фабрику
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public protocol MultiCellTypeFactory {

    /// массив поддерживаемых фабрик
    static var factories: [Recognized: AnyCellFactory.Type] { get }

    /// объекты модели таблицы
    var model: RecognizableModel { get }

    /// идентификатор фабрики
    var identifier: String { get }

    /// инициализация
    /// - Parameter models: объекты модели таблицы
    /// - Parameter delegate: делегат ячейки (если нужен)
    init(_ model: RecognizableModel, delegate: AnyObject?)

    /// настроить ячейку на основой бизнес логики
    /// - Parameter cell: ячейка может быть `UITableViewCell` или `UICollectionViewCell`
    /// - Parameter indexPath: индекс пас ячейки
    func setup(_ cell: FactorableView)
}

// MARK: - MultiCellTypeFactory + Default
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public extension MultiCellTypeFactory {

    var identifier: String {
        guard let factory = Self.factories[type(of: model).recognize] else {
            fatalError("Could't to recognize factory for type \(String(describing: type(of: model).self))")
        }
        return String(describing: factory.wrappedViewType)
    }
    
    /// инициализация
    /// - Parameter models: объекты модели таблицы
    init(_ model: RecognizableModel) {
        self.init(model, delegate: nil)
    }
}
