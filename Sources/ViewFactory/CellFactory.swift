//
//  CellFactory.swift
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

/// любая ячейка
public protocol FactorableCellView: FactorableView {}

// MARK: - UITableViewCell + FactorableCellView
extension UITableViewCell: FactorableCellView {}

// MARK: - UICollectionViewCell + FactorableCellView
extension UICollectionViewCell: FactorableCellView {}

/// протокол реализующий логику создание любой ячейки через фабрику
public protocol AnyCellFactory: AnyViewFactory {

    /// идентификатор ячейки
    var identifier: String { get }
}

/// протокол реализующий логику создание ячейки через фабрику
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
