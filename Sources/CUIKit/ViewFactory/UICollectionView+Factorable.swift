//
//  UICollectionView+Factorable.swift
//

import UIKit

extension UICollectionViewCell: Factorable {}

public extension UICollectionView {
    
    func register<Factory>(factory _: Factory.Type) where Factory: UIViewFactory, Factory: Identifiable {
        register(Factory.View.self, forCellWithReuseIdentifier: Factory.identifier)
    }
    
    func register<Factory>(nibFactory _: Factory.Type, bundle: Bundle? = nil) where Factory: Identifiable {
        let nib = UINib(nibName: Factory.identifier, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: Factory.identifier)
    }
 
    func register<Factory>(supplementaryFactory: Factory.Type) where Factory: UISupplementaryViewFactory, Factory: Identifiable, Factory: Kindable {
        register(Factory.View.self, forSupplementaryViewOfKind: Factory.kind, withReuseIdentifier: Factory.identifier)
    }
    
    func register<Factory>(nibSupplementaryFactory: Factory.Type, bundle: Bundle? = nil) where Factory: UISupplementaryViewFactory, Factory: Identifiable, Factory: Kindable {
        let nib = UINib(nibName: Factory.identifier, bundle: bundle)
        register(nib, forSupplementaryViewOfKind: Factory.kind, withReuseIdentifier: Factory.identifier)
    }
}

public extension UICollectionView {
    
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

public extension UICollectionView {
    
    func dequeueReusableCell<Factory>(by _: Factory.Type,
                                      for indexPath: IndexPath,
                                      model: Factory.Model) -> UICollectionViewCell where Factory: UIReusableViewFactory {
        dequeueReusableCell(by: Factory(model), for: indexPath)
    }
    
    func dequeueReusableCell<Factory>(by _: Factory.Type,
                                      for indexPath: IndexPath,
                                      models: [Factory.Model]) -> UICollectionViewCell where Factory: UIReusableViewFactory {
        dequeueReusableCell(by: Factory.self, for: indexPath, model: models[indexPath.row])
    }
}

public extension UICollectionView {
    
    func dequeueReusableCell<Factory>(by _: Factory.Type,
                                      for indexPath: IndexPath,
                                      model: Factory.Model,
                                      delegate: Factory.Delegate) -> UICollectionViewCell where Factory: UIDelegableReusableViewFactory {
        dequeueReusableCell(by: Factory(model, delegate), for: indexPath)
    }

    func dequeueReusableCell<Factory>(by _: Factory.Type,
                                      for indexPath: IndexPath,
                                      models: [Factory.Model],
                                      delegate: Factory.Delegate) -> UICollectionViewCell where Factory: UIDelegableReusableViewFactory {
        dequeueReusableCell(by: Factory.self, for: indexPath, model: models[indexPath.row], delegate: delegate)
    }
}

public extension UICollectionView {
    
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

public extension UICollectionView {
    
    func dequeueReusableSupplementaryView<Factory>(by _: Factory.Type,
                                                   for indexPath: IndexPath,
                                                   model: Factory.Model) -> UICollectionReusableView where Factory: UIReusableSupplementaryViewFactory {
        dequeueReusableSupplementaryView(by: Factory(model), for: indexPath)
    }
    
    func dequeueReusableSupplementaryView<Factory>(by _: Factory.Type,
                                                   for indexPath: IndexPath,
                                                   models: [Factory.Model]) -> UICollectionReusableView where Factory: UIReusableSupplementaryViewFactory {
        dequeueReusableSupplementaryView(by: Factory(models[indexPath.row]), for: indexPath)
    }
}

public extension UICollectionView {
    
    func dequeueReusableSupplementaryView<Factory>(by _: Factory.Type,
                                                   for indexPath: IndexPath,
                                                   model: Factory.Model,
                                                   delegate: Factory.Delegate) -> UICollectionReusableView where Factory: UIDelegableReusableSupplementaryViewFactory {
        dequeueReusableSupplementaryView(by: Factory(model, delegate), for: indexPath)
    }
    
    func dequeueReusableSupplementaryView<Factory>(by _: Factory.Type,
                                                   for indexPath: IndexPath,
                                                   models: [Factory.Model],
                                                   delegate: Factory.Delegate) -> UICollectionReusableView where Factory: UIDelegableReusableSupplementaryViewFactory {
        dequeueReusableSupplementaryView(by: Factory(models[indexPath.row], delegate), for: indexPath)
    }
}
