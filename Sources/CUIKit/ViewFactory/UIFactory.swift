//
//  UIFactory.swift
//

import UIKit

/// <#Description#>
public protocol Factorable: UIView {}

/// <#Description#>
public protocol Identifiable {
    
    typealias Identifier = String
    
    /// <#Description#>
    static var identifier: Identifier { get }
}

/// <#Description#>
public protocol Kindable {
    
    typealias Kind = String
    
    /// <#Description#>
    static var kind: Kind { get }
}

/// <#Description#>
public protocol UIModelProvider {
    
    associatedtype Model: UIModel
}

/// <#Description#>
public protocol UIViewFactory {
    
    associatedtype View: Factorable
    
    /// <#Description#>
    /// - Parameter view: <#view description#>
    func rendering(_ view: View)
}

/// <#Description#>
public protocol UIDelegableViewFactory: UIViewFactory {
    
    associatedtype Delegate
}

/// <#Description#>
public protocol UIReusableViewFactory: UIViewFactory, UIModelProvider, Identifiable {
    
    /// <#Description#>
    /// - Parameter model: <#model description#>
    init(_ model: Model)
}

// MARK: - UIReusableViewFactory + Default
public extension UIReusableViewFactory {
    
    static var identifier: Identifier {
        String(describing: View.self)
    }
}

/// <#Description#>
public protocol UIDelegableReusableViewFactory: UIDelegableViewFactory, UIModelProvider, Identifiable {
    
    /// <#Description#>
    /// - Parameters:
    ///   - model: <#model description#>
    ///   - delegate: <#delegate description#>
    init(_ model: Model, _ delegate: Delegate)
}

// MARK: - UIDelegableReusableViewFactory + Default
public extension UIDelegableReusableViewFactory {
    
    static var identifier: Identifier {
        String(describing: View.self)
    }
}

/// <#Description#>
public protocol UISupplementaryViewFactory: UIViewFactory {}

/// <#Description#>
public protocol UIReusableSupplementaryViewFactory: UISupplementaryViewFactory, UIModelProvider, Identifiable, Kindable {
    
    /// <#Description#>
    /// - Parameter model: <#model description#>
    init(_ model: Model)
}

// MARK: - UIReusableSupplementaryViewFactory + Default
public extension UIReusableSupplementaryViewFactory {
    
    static var identifier: Identifier {
        String(describing: View.self)
    }
}

/// <#Description#>
public protocol UIDelegableReusableSupplementaryViewFactory: UISupplementaryViewFactory, UIDelegableViewFactory, UIModelProvider, Identifiable, Kindable {
    
    /// <#Description#>
    /// - Parameters:
    ///   - model: <#model description#>
    ///   - delegate: <#delegate description#>
    init(_ model: Model, _ delegate: Delegate)
}

// MARK: - UIDelegableReusableSupplementaryViewFactory + Default
public extension UIDelegableReusableSupplementaryViewFactory {
    
    static var identifier: Identifier {
        String(describing: View.self)
    }
}
