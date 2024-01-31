//
//  Nibble.swift
//

import UIKit

@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public extension UIView {

    /// Прикрепить к View
    ///
    /// - Parameter view: родительская View
    func attach(to view: UIView, edgeInsets: UIEdgeInsets = .zero, isAutoresizingMask: Bool = false) {
        translatesAutoresizingMaskIntoConstraints = isAutoresizingMask
        view.addSubview(self)
        NSLayoutConstraint.activate([topAnchor.constraint(equalTo: view.topAnchor, constant: edgeInsets.top),
                                     bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -edgeInsets.bottom),
                                     leftAnchor.constraint(equalTo: view.leftAnchor, constant: edgeInsets.left),
                                     rightAnchor.constraint(equalTo: view.rightAnchor, constant: -edgeInsets.right)])
    }
}

/// Загрузка с через nib
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public protocol Nibble: AnyObject {

    /// Загрузка опредленного типа view через nib из бандла основного приложения
    ///
    /// - Returns: загруженная view
    static func fabricateFromAppBundle() -> Self?
    
    /// Загрузка опредленного типа view через nib из локального ресурса
    ///
    /// - Returns: загруженная view
    static func fabricateFromFrameworkBundle() -> Self?
    
    /// Загрузка view через nib
    ///
    /// - Returns: загруженная view
    @discardableResult
    func nibIntervene<View>() -> View? where View: UIView
}

// MARK: - Nibble + UIView
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public extension Nibble where Self: UIView {

    static func fabricateFromAppBundle() -> Self? {
        let nibName = String(describing: Self.self)
        let bundle = Bundle(for: Self.self)
        return bundle.loadNibNamed(nibName, owner: nil, options: nil)?.first as? Self
    }

    static func fabricateFromFrameworkBundle() -> Self? {
        let nibName = String(describing: Self.self)
        #if SPM
        let bundle = Bundle.module
        #else
        let frameworkBundle = Bundle(for: Self.self)
        let bundleName = "CUIKit"
        guard let bundleURL = frameworkBundle.url(forResource: bundleName, withExtension: "bundle") else {
            preconditionFailure("Could not create a path to the CUIKit framework bundle")
        }
        guard let bundle = Bundle(url: bundleURL) else {
            preconditionFailure("Could not load the CUIKit framework bundle")
        }
        #endif
        return bundle.loadNibNamed(nibName, owner: nil, options: nil)?.first as? Self
    }
    
    @discardableResult
    func nibIntervene<View>() -> View? where View: UIView {
        #if SPM
        let bundle = Bundle.module
        #else
        let bundle = Bundle(for: View.self)
        #endif
        guard let view = bundle.loadNibNamed(String(describing: View.self),
                                             owner: self,
                                             options: nil)?.first as? View else { return nil }
        view.attach(to: self)
        return view
    }
}
