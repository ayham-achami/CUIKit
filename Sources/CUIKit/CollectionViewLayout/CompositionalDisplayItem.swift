//
//  CompositionalDisplayItem.swift
//

import UIKit

/// Протокол для создания displayItem для CompositionalLayout
public protocol CompositionalDisplayItem {
    
    /// Инициализатор
    init()
    
    /// Возвращает Layout для секции
    /// - Parameter layoutEnvironment: окружение для создания Layout
    func section(for layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection?
}

/// Модель для работы с displayItem у CompositionalLayout
public protocol AnyCompositionalModel: UIModel {
    
    /// Тип DisplayItem для работы с данной моделью
    var displayType: CompositionalDisplayItem.Type { get }
}

/// Модель для работы с displayItem у CompositionalLayout
public protocol CompositionalModel: AnyCompositionalModel {
    
    // Возвращает фабрику для индекса
    /// - Parameters:
    ///   - index: Индекс
    /// - Returns: Фабрика ячейки
    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    subscript(index: Int) -> AnyCellFactory { get }
    
    // Возвращает фабрику для индекса
    /// - Parameters:
    ///   - index: Индекс
    /// - Returns: Фабрика ячейки
    subscript(index: Int) -> any UIReusableViewFactory { get }
}

/// Модель для работы с displayItem у CompositionalLayout с делегацией
public protocol DelegationCompositionalModel: AnyCompositionalModel {
    
    // Возвращает фабрику для индекса
    /// - Parameters:
    ///   - index: Индекс
    ///   - delegate: Делегат для ячейки
    /// - Returns: Фабрика ячейки
    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    subscript(index: Int, delegate: AnyObject) -> AnyCellFactory { get }
    
    // Возвращает фабрику для индекса
    /// - Parameters:
    ///   - index: Индекс
    ///   - delegate: Делегат для ячейки
    /// - Returns: Фабрика ячейки
    subscript(index: Int, delegate: AnyObject) -> any UIDelegableReusableViewFactory { get }
}

/// Функция преобразования индекса в CompositionalModel
public typealias CompositionalLayoutSectionConvertor = (Int) -> AnyCompositionalModel?

// MARK: - UICollectionViewCompositionalLayout + Init
public extension UICollectionViewCompositionalLayout {
    
    /// Инициализатор на основе конвертера и конфигурации
    /// - Parameters:
    ///   - convertor: Конвертер
    ///   - configuration: Конфигурация
    convenience init(convertor: @escaping CompositionalLayoutSectionConvertor,
                     configuration: UICollectionViewCompositionalLayoutConfiguration) {
        self.init(sectionProvider: { index, environment in
            convertor(index)?.displayType.init().section(for: environment)
        }, configuration: configuration)
    }
    
    /// Инициализатор на основе конвертера
    /// - Parameter convertor: Конвертер
    convenience init(convertor: @escaping CompositionalLayoutSectionConvertor) {
        self.init(sectionProvider: { index, environment in
            convertor(index)?.displayType.init().section(for: environment)
        })
    }
}
