//
//  UICollectionView+Factorable.swift
//

import UIKit

// MARK: - UICollectionViewCell + Factorable
extension UICollectionViewCell: Factorable {}

// MARK: - UICollectionView + Register
public extension UICollectionView {
    
    /// Зарегистрировать фабрику
    /// - Parameter _:  тип фабрики для регистрация
    func register<Factory>(factory _: Factory.Type) where Factory: UIViewFactory, Factory: Identifiable {
        register(Factory.View.self, forCellWithReuseIdentifier: Factory.identifier)
    }
    
    /// Зарегистрировать NIB-фабрику
    /// - Parameters:
    ///   - _: тип фабрики для регистрации
    ///   - bundle: бандл для поиска фабрики
    func register<Factory>(nibFactory _: Factory.Type, bundle: Bundle? = nil) where Factory: Identifiable {
        let nib = UINib(nibName: Factory.identifier, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: Factory.identifier)
    }
    
    /// Зарегистрировать supplementary фабрику
    /// - Parameter supplementaryFactory: тип фабрики для регистрации
    func register<Factory>(supplementaryFactory: Factory.Type) where Factory: UISupplementaryViewFactory, Factory: Identifiable, Factory: Kindable {
        register(Factory.View.self, forSupplementaryViewOfKind: Factory.kind, withReuseIdentifier: Factory.identifier)
    }
    
    /// Зарегистрировать supplementary NIB-фабрику
    /// - Parameters:
    ///   - nibSupplementaryFactory: тип фабрики для регистрации
    ///   - bundle: бандл для поиска фабрики
    func register<Factory>(nibSupplementaryFactory: Factory.Type, bundle: Bundle? = nil) where Factory: UISupplementaryViewFactory, Factory: Identifiable, Factory: Kindable {
        let nib = UINib(nibName: Factory.identifier, bundle: bundle)
        register(nib, forSupplementaryViewOfKind: Factory.kind, withReuseIdentifier: Factory.identifier)
    }
}

// MARK: - UICollectionView + Reuseable + UIFactory
public extension UICollectionView {
    
    ///  Вернуть ячейку из фабрики
    /// - Parameters:
    ///   - factory: фабрика из которой необходимо вернуть ячейку
    ///   - indexPath: индекс для ячейки
    /// - Returns: возвращаемая ячейка
    func dequeueReusableCell<Factory>(by factory: Factory,
                                      for indexPath: IndexPath) -> UICollectionViewCell where Factory: UIViewFactory, Factory: Identifiable {
        let cell = dequeueReusableCell(withReuseIdentifier: Factory.identifier, for: indexPath)
        guard
            let view = cell as? Factory.View
        else { preconditionFailure("Could't to cast \(String(describing: type(of: cell).self)) to \(String(describing: Factory.View.self))") }
        factory.rendering(view)
        return cell
    }
}

// MARK: - UICollectionView + Reuseable
public extension UICollectionView {
    
    ///  Вернуть ячейку из фабрики
    /// - Parameters:
    ///   - factory: фабрика из которой необходимо вернуть ячейку
    ///   - indexPath: индекс для ячейки
    ///   - model:  модель для ячейки
    /// - Returns: возвращаемая ячейка
    func dequeueReusableCell<Factory>(by _: Factory.Type,
                                      for indexPath: IndexPath,
                                      model: Factory.Model) -> UICollectionViewCell where Factory: UIReusableViewFactory {
        dequeueReusableCell(by: Factory(model), for: indexPath)
    }
    
    ///  Вернуть ячейку из фабрики
    /// - Parameters:
    ///   - factory: фабрика из которой необходимо вернуть ячейку
    ///   - indexPath: индекс для ячейки
    ///   - models:  массив моделей
    /// - Returns: возвращаемая ячейка
    func dequeueReusableCell<Factory>(by _: Factory.Type,
                                      for indexPath: IndexPath,
                                      models: [Factory.Model]) -> UICollectionViewCell where Factory: UIReusableViewFactory {
        dequeueReusableCell(by: Factory.self, for: indexPath, model: models[indexPath.row])
    }
}

// MARK: - UICollectionView + Reuseable + Model
public extension UICollectionView {
    
    ///  Вернуть ячейку из фабрики
    /// - Parameters:
    ///   - factory: фабрика из которой необходимо вернуть ячейку
    ///   - indexPath: индекс для ячейки
    ///   - model:  модель для ячейки
    ///   - delegate: делегат для ячейки
    /// - Returns: возвращаемая ячейка
    func dequeueReusableCell<Factory>(by _: Factory.Type,
                                      for indexPath: IndexPath,
                                      model: Factory.Model,
                                      delegate: Factory.Delegate) -> UICollectionViewCell where Factory: UIDelegableReusableViewFactory {
        dequeueReusableCell(by: Factory(model, delegate), for: indexPath)
    }
    
    ///  Вернуть ячейку из фабрики
    /// - Parameters:
    ///   - factory: фабрика из которой необходимо вернуть ячейку
    ///   - indexPath: индекс для ячейки
    ///   - model:  массив моделей
    ///   - delegate: делегат для ячейки
    /// - Returns: возвращаемая ячейка
    func dequeueReusableCell<Factory>(by _: Factory.Type,
                                      for indexPath: IndexPath,
                                      models: [Factory.Model],
                                      delegate: Factory.Delegate) -> UICollectionViewCell where Factory: UIDelegableReusableViewFactory {
        dequeueReusableCell(by: Factory.self, for: indexPath, model: models[indexPath.row], delegate: delegate)
    }
}

// MARK: - UICollectionView + Reuseable + UIFactory + Supplementary
public extension UICollectionView {
    
    ///  Вернуть supplementary из фабрики
    /// - Parameters:
    ///   - factory: фабрика из которой необходимо вернуть supplementary
    ///   - indexPath: индекс для supplementary
    /// - Returns: возвращаемая ячейка
    func dequeueReusableSupplementaryView<Factory>(by factory: Factory,
                                                   for indexPath: IndexPath) -> UICollectionReusableView where Factory: UIViewFactory, Factory: Identifiable, Factory: Kindable {
        let view = dequeueReusableSupplementaryView(ofKind: Factory.kind, withReuseIdentifier: Factory.identifier, for: indexPath)
        guard
            let factorableView = view as? Factory.View
        else { preconditionFailure("Could't to cast \(String(describing: type(of: view).self)) to \(String(describing: Factory.View.self))") }
        factory.rendering(factorableView)
        return view
    }
}

// MARK: - UICollectionView + Reuseable + Supplementary
public extension UICollectionView {
    
    ///  Вернуть supplementary из фабрики
    /// - Parameters:
    ///   - factory: фабрика из которой необходимо вернуть supplementary
    ///   - indexPath: индекс для supplementary
    ///   - model: модель для supplementary
    /// - Returns: возвращаемая ячейка
    func dequeueReusableSupplementaryView<Factory>(by _: Factory.Type,
                                                   for indexPath: IndexPath,
                                                   model: Factory.Model) -> UICollectionReusableView where Factory: UIReusableSupplementaryViewFactory {
        dequeueReusableSupplementaryView(by: Factory(model), for: indexPath)
    }
    
    ///  Вернуть supplementary из фабрики
    /// - Parameters:
    ///   - factory: фабрика из которой необходимо вернуть supplementary
    ///   - indexPath: индекс для supplementary
    ///   - models: массив моделей для supplementary
    /// - Returns: возвращаемая ячейка
    func dequeueReusableSupplementaryView<Factory>(by _: Factory.Type,
                                                   for indexPath: IndexPath,
                                                   models: [Factory.Model]) -> UICollectionReusableView where Factory: UIReusableSupplementaryViewFactory {
        dequeueReusableSupplementaryView(by: Factory(models[indexPath.row]), for: indexPath)
    }
}

// MARK: - UICollectionView + Reuseable + Supplementary + Model
public extension UICollectionView {
    
    ///  Вернуть supplementary из фабрики
    /// - Parameters:
    ///   - factory: фабрика из которой необходимо вернуть supplementary
    ///   - indexPath: индекс для supplementary
    ///   - model: модель для supplementary
    ///   - delegate:  делегат для supplementary
    /// - Returns: возвращаемая ячейка
    func dequeueReusableSupplementaryView<Factory>(by _: Factory.Type,
                                                   for indexPath: IndexPath,
                                                   model: Factory.Model,
                                                   delegate: Factory.Delegate) -> UICollectionReusableView where Factory: UIDelegableReusableSupplementaryViewFactory {
        dequeueReusableSupplementaryView(by: Factory(model, delegate), for: indexPath)
    }
    
    ///  Вернуть supplementary из фабрики
    /// - Parameters:
    ///   - factory: фабрика из которой необходимо вернуть supplementary
    ///   - indexPath: индекс для supplementary
    ///   - models: массив моделей для supplementary
    ///   - delegate:  делегат для supplementary
    /// - Returns: возвращаемая ячейка
    func dequeueReusableSupplementaryView<Factory>(by _: Factory.Type,
                                                   for indexPath: IndexPath,
                                                   models: [Factory.Model],
                                                   delegate: Factory.Delegate) -> UICollectionReusableView where Factory: UIDelegableReusableSupplementaryViewFactory {
        dequeueReusableSupplementaryView(by: Factory(models[indexPath.row], delegate), for: indexPath)
    }
}
