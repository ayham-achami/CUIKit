//
//  CompositionalDisplayItem.swift
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

/// Протокол для создания displayItem для CompositionalLayout
@available(iOS 13.0, *)
public protocol CompositionalDisplayItem {
    
    /// Инициализатор
    init()
    
    /// Возвращает Layout для секции
    /// - Parameter layoutEnvironment: окружение для создания Layout
    func section(for layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection?
}

/// Модель для работы с displayItem у CompositionalLayout
@available(iOS 13.0, *)
public protocol AnyCompositionalModel: UIModel {
    
    /// Тип DisplayItem для работы с данной моделью
    var displayType: CompositionalDisplayItem.Type { get }
}

/// Модель для работы с displayItem у CompositionalLayout
@available(iOS 13.0, *)
public protocol CompositionalModel: AnyCompositionalModel {
    
    // Вовзращает фабрику для индекса
    /// - Parameters:
    ///   - index: индекс
    /// - Returns: фабрика ячейки
    subscript(index: Int) -> AnyCellFactory { get }
}

/// Модель для работы с displayItem у CompositionalLayout с делегацией
@available(iOS 13.0, *)
public protocol DelegationCompositionalModel: AnyCompositionalModel {
    
    // Вовзращает фабрику для индекса
    /// - Parameters:
    ///   - index: индекс
    ///   - delegate: делегат для ячейки
    /// - Returns: фабрика ячейки
    subscript(index: Int, delegate: AnyObject) -> AnyCellFactory { get }
}

/// Функция преобразования индекса в CompositionalModel
@available(iOS 13.0, *)
public typealias CompositionalLayoutSectionConvertor = (Int) -> AnyCompositionalModel?

@available(iOS 13.0, *)
public extension UICollectionViewCompositionalLayout {
    
    /// Инициализатор на основе конвертера и конфигурации
    /// - Parameters:
    ///   - convertor: конвертер
    ///   - configuration: конфигурация
    convenience init(convertor: @escaping CompositionalLayoutSectionConvertor,
                     configuration: UICollectionViewCompositionalLayoutConfiguration) {
        self.init(sectionProvider: { index, environment in
            convertor(index)?.displayType.init().section(for: environment)
        }, configuration: configuration)
    }
    
    /// Инициализатор на основе конвертера
    /// - Parameter convertor: конвертер
    convenience init(convertor: @escaping CompositionalLayoutSectionConvertor) {
        self.init(sectionProvider: { index, environment in
            convertor(index)?.displayType.init().section(for: environment)
        })
    }
}
