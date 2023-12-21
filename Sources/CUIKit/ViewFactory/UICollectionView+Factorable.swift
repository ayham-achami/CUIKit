//
//  UICollectionView+Factorable.swift
//

import UIKit

// MARK: - UICollectionViewCell + Factorable
extension UICollectionViewCell: Factorable {}

// MARK: - UICollectionView + Register
public extension UICollectionView {
    
    /// <#Description#>
    /// - Parameter _: <#_ description#>
    func register<Factory>(factory _: Factory.Type) where Factory: UIViewFactory, Factory: Identifiable {
        register(Factory.View.self, forCellWithReuseIdentifier: Factory.identifier)
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - _: <#_ description#>
    ///   - bundle: <#bundle description#>
    func register<Factory>(nibFactory _: Factory.Type, bundle: Bundle? = nil) where Factory: Identifiable {
        let nib = UINib(nibName: Factory.identifier, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: Factory.identifier)
    }
    
    /// <#Description#>
    /// - Parameter supplementaryFactory: <#supplementaryFactory description#>
    func register<Factory>(supplementaryFactory: Factory.Type) where Factory: UISupplementaryViewFactory, Factory: Identifiable, Factory: Kindable {
        register(Factory.View.self, forSupplementaryViewOfKind: Factory.kind, withReuseIdentifier: Factory.identifier)
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - nibSupplementaryFactory: <#nibSupplementaryFactory description#>
    ///   - bundle: <#bundle description#>
    func register<Factory>(nibSupplementaryFactory: Factory.Type, bundle: Bundle? = nil) where Factory: UISupplementaryViewFactory, Factory: Identifiable, Factory: Kindable {
        let nib = UINib(nibName: Factory.identifier, bundle: bundle)
        register(nib, forSupplementaryViewOfKind: Factory.kind, withReuseIdentifier: Factory.identifier)
    }
}

// MARK: - UICollectionView + Reuseable + UIFactory
public extension UICollectionView {
    
    /// <#Description#>
    /// - Parameters:
    ///   - factory: <#factory description#>
    ///   - indexPath: <#indexPath description#>
    /// - Returns: <#description#>
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
    
    /// <#Description#>
    /// - Parameters:
    ///   - _: <#_ description#>
    ///   - indexPath: <#indexPath description#>
    ///   - model: <#model description#>
    /// - Returns: <#description#>
    func dequeueReusableCell<Factory>(by _: Factory.Type,
                                      for indexPath: IndexPath,
                                      model: Factory.Model) -> UICollectionViewCell where Factory: UIReusableViewFactory {
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
                                      models: [Factory.Model]) -> UICollectionViewCell where Factory: UIReusableViewFactory {
        dequeueReusableCell(by: Factory.self, for: indexPath, model: models[indexPath.row])
    }
}

// MARK: - UICollectionView + Reuseable + Model
public extension UICollectionView {
    
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
                                      delegate: Factory.Delegate) -> UICollectionViewCell where Factory: UIDelegableReusableViewFactory {
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
                                      delegate: Factory.Delegate) -> UICollectionViewCell where Factory: UIDelegableReusableViewFactory {
        dequeueReusableCell(by: Factory.self, for: indexPath, model: models[indexPath.row], delegate: delegate)
    }
}

// MARK: - UICollectionView + Reuseable + UIFactory + Supplementary
public extension UICollectionView {
    
    /// <#Description#>
    /// - Parameters:
    ///   - factory: <#factory description#>
    ///   - indexPath: <#indexPath description#>
    /// - Returns: <#description#>
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
    
    /// <#Description#>
    /// - Parameters:
    ///   - _: <#_ description#>
    ///   - indexPath: <#indexPath description#>
    ///   - model: <#model description#>
    /// - Returns: <#description#>
    func dequeueReusableSupplementaryView<Factory>(by _: Factory.Type,
                                                   for indexPath: IndexPath,
                                                   model: Factory.Model) -> UICollectionReusableView where Factory: UIReusableSupplementaryViewFactory {
        dequeueReusableSupplementaryView(by: Factory(model), for: indexPath)
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - _: <#_ description#>
    ///   - indexPath: <#indexPath description#>
    ///   - models: <#models description#>
    /// - Returns: <#description#>
    func dequeueReusableSupplementaryView<Factory>(by _: Factory.Type,
                                                   for indexPath: IndexPath,
                                                   models: [Factory.Model]) -> UICollectionReusableView where Factory: UIReusableSupplementaryViewFactory {
        dequeueReusableSupplementaryView(by: Factory(models[indexPath.row]), for: indexPath)
    }
}

// MARK: - UICollectionView + Reuseable + Supplementary + Model
public extension UICollectionView {
    
    /// <#Description#>
    /// - Parameters:
    ///   - _: <#_ description#>
    ///   - indexPath: <#indexPath description#>
    ///   - model: <#model description#>
    ///   - delegate: <#delegate description#>
    /// - Returns: <#description#>
    func dequeueReusableSupplementaryView<Factory>(by _: Factory.Type,
                                                   for indexPath: IndexPath,
                                                   model: Factory.Model,
                                                   delegate: Factory.Delegate) -> UICollectionReusableView where Factory: UIDelegableReusableSupplementaryViewFactory {
        dequeueReusableSupplementaryView(by: Factory(model, delegate), for: indexPath)
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - _: <#_ description#>
    ///   - indexPath: <#indexPath description#>
    ///   - models: <#models description#>
    ///   - delegate: <#delegate description#>
    /// - Returns: <#description#>
    func dequeueReusableSupplementaryView<Factory>(by _: Factory.Type,
                                                   for indexPath: IndexPath,
                                                   models: [Factory.Model],
                                                   delegate: Factory.Delegate) -> UICollectionReusableView where Factory: UIDelegableReusableSupplementaryViewFactory {
        dequeueReusableSupplementaryView(by: Factory(models[indexPath.row], delegate), for: indexPath)
    }
}
