//
//  CompositionalDisplayItem.swift
//  CUIKit
//
//  Created by Ayham Hylam on 06.09.2021.
//

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
