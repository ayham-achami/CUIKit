//
//  UITableView+Factorable.swift
//

import UIKit

// MARK: - UITableViewCell + Factorable
extension UITableViewCell: Factorable {}

// MARK: - UICollectionView + Register
public extension UITableView {
    
    /// <#Description#>
    /// - Parameter _: <#_ description#>
    func register<Factory>(factory _: Factory.Type) where Factory: UIViewFactory, Factory: Identifiable {
        register(Factory.View.self, forCellReuseIdentifier: Factory.identifier)
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - _: <#_ description#>
    ///   - bundle: <#bundle description#>
    func register<Factory>(nibFactory _: Factory.Type, bundle: Bundle? = nil) where Factory: Identifiable {
        let nib = UINib(nibName: Factory.identifier, bundle: bundle)
        register(nib, forCellReuseIdentifier: Factory.identifier)
    }
    
    /// <#Description#>
    /// - Parameter _: <#_ description#>
    func register<Factory>(headerFooterfactory _: Factory.Type) where Factory: UIViewFactory, Factory: Identifiable {
        register(Factory.View.self, forHeaderFooterViewReuseIdentifier: Factory.identifier)
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - _: <#_ description#>
    ///   - bundle: <#bundle description#>
    func register<Factory>(nibHeaderFooterfactory _: Factory.Type, bundle: Bundle? = nil) where Factory: UIViewFactory, Factory: Identifiable {
        let nib = UINib(nibName: Factory.identifier, bundle: bundle)
        register(nib, forHeaderFooterViewReuseIdentifier: Factory.identifier)
    }
}

// MARK: - UITableView + Reuseable + UIFactory
public extension UITableView {
    
    /// <#Description#>
    /// - Parameters:
    ///   - factory: <#factory description#>
    ///   - indexPath: <#indexPath description#>
    /// - Returns: <#description#>
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
    
    /// <#Description#>
    /// - Parameters:
    ///   - _: <#_ description#>
    ///   - indexPath: <#indexPath description#>
    ///   - model: <#model description#>
    /// - Returns: <#description#>
    func dequeueReusableCell<Factory>(by _: Factory.Type,
                                      for indexPath: IndexPath,
                                      model: Factory.Model) -> UITableViewCell where Factory: UIReusableViewFactory {
        dequeueReusableCell(by: Factory(model), for: indexPath)
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - _: <#_ description#>
    ///   - indexPath: <#indexPath description#>
    ///   - models: <#models description#>
    /// - Returns: <#description#>
    func dequeueReusableCell<Factory>(by _: Factory.Type,
                                      for indexPath: IndexPath,
                                      models: [Factory.Model]) -> UITableViewCell where Factory: UIReusableViewFactory {
        dequeueReusableCell(by: Factory.self, for: indexPath, model: models[indexPath.row])
    }
}

// MARK: - UITableView + Reuseable + Model
public extension UITableView {
    
    /// <#Description#>
    /// - Parameters:
    ///   - _: <#_ description#>
    ///   - indexPath: <#indexPath description#>
    ///   - model: <#model description#>
    ///   - delegate: <#delegate description#>
    /// - Returns: <#description#>
    func dequeueReusableCell<Factory>(by _: Factory.Type,
                                      for indexPath: IndexPath,
                                      model: Factory.Model,
                                      delegate: Factory.Delegate) -> UITableViewCell where Factory: UIDelegableReusableViewFactory {
        dequeueReusableCell(by: Factory(model, delegate), for: indexPath)
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - _: <#_ description#>
    ///   - indexPath: <#indexPath description#>
    ///   - models: <#models description#>
    ///   - delegate: <#delegate description#>
    /// - Returns: <#description#>
    func dequeueReusableCell<Factory>(by _: Factory.Type,
                                      for indexPath: IndexPath,
                                      models: [Factory.Model],
                                      delegate: Factory.Delegate) -> UITableViewCell where Factory: UIDelegableReusableViewFactory {
        dequeueReusableCell(by: Factory.self, for: indexPath, model: models[indexPath.row], delegate: delegate)
    }
}

// MARK: - UITableView + Reuseable + UIFactory + Supplementary
public extension UITableView {
    
    /// <#Description#>
    /// - Parameters:
    ///   - factory: <#factory description#>
    ///   - indexPath: <#indexPath description#>
    /// - Returns: <#description#>
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
    
    /// <#Description#>
    /// - Parameters:
    ///   - _: <#_ description#>
    ///   - indexPath: <#indexPath description#>
    ///   - model: <#model description#>
    /// - Returns: <#description#>
    func dequeueReusableHeaderFooterView<Factory>(by _: Factory.Type,
                                                  for indexPath: IndexPath,
                                                  model: Factory.Model) -> UITableViewHeaderFooterView? where Factory: UIReusableViewFactory {
        dequeueReusableHeaderFooterView(by: Factory(model), for: indexPath)
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - _: <#_ description#>
    ///   - indexPath: <#indexPath description#>
    ///   - models: <#models description#>
    /// - Returns: <#description#>
    func dequeueReusableHeaderFooterView<Factory>(by _: Factory.Type,
                                                  for indexPath: IndexPath,
                                                  models: [Factory.Model]) -> UITableViewHeaderFooterView? where Factory: UIReusableViewFactory {
        dequeueReusableHeaderFooterView(by: Factory.self, for: indexPath, model: models[indexPath.row])
    }
}

// MARK: - UITableView + Reuseable + Model
public extension UITableView {
    
    /// <#Description#>
    /// - Parameters:
    ///   - _: <#_ description#>
    ///   - indexPath: <#indexPath description#>
    ///   - model: <#model description#>
    ///   - delegate: <#delegate description#>
    /// - Returns: <#description#>
    func dequeueReusableHeaderFooterView<Factory>(by _: Factory.Type,
                                                  for indexPath: IndexPath,
                                                  model: Factory.Model,
                                                  delegate: Factory.Delegate) -> UITableViewHeaderFooterView? where Factory: UIDelegableReusableViewFactory {
        dequeueReusableHeaderFooterView(by: Factory(model, delegate), for: indexPath)
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - _: <#_ description#>
    ///   - indexPath: <#indexPath description#>
    ///   - models: <#models description#>
    ///   - delegate: <#delegate description#>
    /// - Returns: <#description#>
    func dequeueReusableHeaderFooterView<Factory>(by _: Factory.Type,
                                                  for indexPath: IndexPath,
                                                  models: [Factory.Model],
                                                  delegate: Factory.Delegate) -> UITableViewHeaderFooterView? where Factory: UIDelegableReusableViewFactory {
        dequeueReusableHeaderFooterView(by: Factory.self, for: indexPath, model: models[indexPath.row], delegate: delegate)
    }
}
