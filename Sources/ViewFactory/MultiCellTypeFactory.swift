//
//  MultiCellTypeFactory.swift
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

/// распознаваемый тип 
public typealias Recognized = AnyHashable

/// распознаваемый объект модели
public protocol RecognizableModel: UIModel {

    /// признак распознавания объект модели
    static var recognize: Recognized { get }
}

// MARK: - RecognizableModel + Default
public extension RecognizableModel {

    static var recognize: Recognized {
        String(reflecting: self)
    }
}

///  протокол реализующий логику создание разных тепов ячейк через фабрику
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
public extension MultiCellTypeFactory {

    /// инициализация
    /// - Parameter models: объекты модели таблицы
    init(_ model: RecognizableModel) {
        self.init(model, delegate: nil)
    }

    var identifier: String {
        guard let factory = Self.factories[type(of: model).recognize] else {
            fatalError("Could't to recognize factory for type \(String(describing: type(of: model).self))")
        }
        return String(describing: factory.wrappedViewType)
    }
}
