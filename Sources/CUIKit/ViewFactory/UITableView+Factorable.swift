//
//  UITableView+Factorable.swift
//

import UIKit

// MARK: - UITableViewCell + Factorable
extension UITableViewCell: Factorable {}

// MARK: - UICollectionView + Register
public extension UITableView {
    
    /// Зарегистрировать фабрику
    /// - Parameter _:  тип фабрики для регистрации
    func register<Factory>(factory _: Factory.Type) where Factory: UIViewFactory, Factory: Identifiable {
        register(Factory.View.self, forCellReuseIdentifier: Factory.identifier)
    }
    
    /// Зарегистрировать NIB-фабрику
    /// - Parameters:
    ///   - _: тип фабрики для регистрации
    ///   - bundle: бандл для поиска фабрики
    func register<Factory>(nibFactory _: Factory.Type, bundle: Bundle? = nil) where Factory: Identifiable {
        let nib = UINib(nibName: Factory.identifier, bundle: bundle)
        register(nib, forCellReuseIdentifier: Factory.identifier)
    }
    
    /// Зарегистрировать фабрику для хедера или футера
    /// - Parameter headerFooterFactory: тип фабрики для регистрации
    func register<Factory>(headerFooterFactory _: Factory.Type) where Factory: UIViewFactory, Factory: Identifiable {
        register(Factory.View.self, forHeaderFooterViewReuseIdentifier: Factory.identifier)
    }
    
    /// Зарегистрировать фабрику для хедера или футера
    /// - Parameters:
    ///   - nibHeaderFooterFactory: тип фабрики для регистрации
    ///   - bundle: бандл для поиска фабрики
    func register<Factory>(nibHeaderFooterFactory _: Factory.Type, bundle: Bundle? = nil) where Factory: UIViewFactory, Factory: Identifiable {
        let nib = UINib(nibName: Factory.identifier, bundle: bundle)
        register(nib, forHeaderFooterViewReuseIdentifier: Factory.identifier)
    }
}

// MARK: - UITableView + Reuseable + UIFactory
public extension UITableView {
    
    ///  Вернуть ячейку из фабрики
    /// - Parameters:
    ///   - factory: фабрика из которой необходимо вернуть ячейку
    ///   - indexPath: индекс для ячейки
    /// - Returns: возвращаемая ячейка
    func dequeueReusableCell<Factory>(by factory: Factory,
                                      for indexPath: IndexPath) -> UITableViewCell where Factory: UIViewFactory, Factory: Identifiable {
        let cell = dequeueReusableCell(withIdentifier: Factory.identifier, for: indexPath)
        guard
            let view = cell as? Factory.View
        else { preconditionFailure("Could't to cast \(String(describing: type(of: cell).self)) to \(String(describing: Factory.View.self))") }
        factory.rendering(view)
        return cell
    }
}

// MARK: - UITableView + Reuseable
public extension UITableView {
    
    ///  Вернуть ячейку из фабрики
    /// - Parameters:
    ///   - factory: фабрика из которой необходимо вернуть ячейку
    ///   - indexPath: индекс для ячейки
    ///   - model:  модель для ячейки
    /// - Returns: возвращаемая ячейка
    func dequeueReusableCell<Factory>(by _: Factory.Type,
                                      for indexPath: IndexPath,
                                      model: Factory.Model) -> UITableViewCell where Factory: UIReusableViewFactory {
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
                                      models: [Factory.Model]) -> UITableViewCell where Factory: UIReusableViewFactory {
        dequeueReusableCell(by: Factory.self, for: indexPath, model: models[indexPath.row])
    }
}

// MARK: - UITableView + Reuseable + Model
public extension UITableView {
    
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
                                      delegate: Factory.Delegate) -> UITableViewCell where Factory: UIDelegableReusableViewFactory {
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
                                      delegate: Factory.Delegate) -> UITableViewCell where Factory: UIDelegableReusableViewFactory {
        dequeueReusableCell(by: Factory.self, for: indexPath, model: models[indexPath.row], delegate: delegate)
    }
}

// MARK: - UITableView + Reuseable + UIFactory + HeaderFooter
public extension UITableView {
    
    ///  Вернуть хедер или футер из фабрики
    /// - Parameters:
    ///   - factory: фабрика из которой необходимо вернуть хедер или футер
    ///   - indexPath: индекс для хедера или футера
    /// - Returns: возвращаемая ячейка
    func dequeueReusableHeaderFooterView<Factory>(by factory: Factory,
                                                  for indexPath: IndexPath) -> UITableViewHeaderFooterView? where Factory: UIViewFactory, Factory: Identifiable {
        let view = dequeueReusableHeaderFooterView(withIdentifier: Factory.identifier)
        guard
            let factorableView = view as? Factory.View
        else { preconditionFailure("Could't to cast \(String(describing: type(of: view).self)) to \(String(describing: Factory.View.self))") }
        factory.rendering(factorableView)
        return view
    }
}

// MARK: - UITableView + Reuseable
public extension UITableView {
    
    /// Вернуть хедер или футер из фабрики
    /// - Parameters:
    ///   - factory: фабрика из которой необходимо вернуть хедер или футер
    ///   - indexPath: индекс для хедера или футера
    ///   - model: модель для хедера или футера
    /// - Returns: возвращаемая ячейка
    func dequeueReusableHeaderFooterView<Factory>(by _: Factory.Type,
                                                  for indexPath: IndexPath,
                                                  model: Factory.Model) -> UITableViewHeaderFooterView? where Factory: UIReusableViewFactory {
        dequeueReusableHeaderFooterView(by: Factory(model), for: indexPath)
    }
    
    ///  Вернуть хедер или футер из фабрики
    /// - Parameters:
    ///   - factory: фабрика из которой необходимо вернуть хедер или футер
    ///   - indexPath: индекс для хедера или футера
    ///   - model: модель для хедера или футера
    /// - Returns: возвращаемая ячейка
    func dequeueReusableHeaderFooterView<Factory>(by _: Factory.Type,
                                                  for indexPath: IndexPath,
                                                  models: [Factory.Model]) -> UITableViewHeaderFooterView? where Factory: UIReusableViewFactory {
        dequeueReusableHeaderFooterView(by: Factory.self, for: indexPath, model: models[indexPath.row])
    }
}

// MARK: - UITableView + Reuseable + Model
public extension UITableView {
    
    ///  Вернуть хедер или футер из фабрики
    /// - Parameters:
    ///   - factory: фабрика из которой необходимо вернуть хедер или футер
    ///   - indexPath: индекс для хедера или футера
    ///   - model: модель для хедера или футера
    ///   - delegate:  делегат для хедера или футера
    /// - Returns: возвращаемая ячейка
    func dequeueReusableHeaderFooterView<Factory>(by _: Factory.Type,
                                                  for indexPath: IndexPath,
                                                  model: Factory.Model,
                                                  delegate: Factory.Delegate) -> UITableViewHeaderFooterView? where Factory: UIDelegableReusableViewFactory {
        dequeueReusableHeaderFooterView(by: Factory(model, delegate), for: indexPath)
    }
    
    ///  Вернуть хедер или футер из фабрики
    /// - Parameters:
    ///   - factory: фабрика из которой необходимо вернуть хедер или футер
    ///   - indexPath: индекс для хедера или футера
    ///   - models: массив моделей для хедера или футера
    ///   - delegate:  делегат для хедера или футера
    /// - Returns: возвращаемая ячейка
    func dequeueReusableHeaderFooterView<Factory>(by _: Factory.Type,
                                                  for indexPath: IndexPath,
                                                  models: [Factory.Model],
                                                  delegate: Factory.Delegate) -> UITableViewHeaderFooterView? where Factory: UIDelegableReusableViewFactory {
        dequeueReusableHeaderFooterView(by: Factory.self, for: indexPath, model: models[indexPath.row], delegate: delegate)
    }
}
