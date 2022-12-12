//
//  Nibble.swift
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
public protocol Nibble: AnyObject {

    /// Загрузка view через nib
    ///
    /// - Returns: загруженная view
    @discardableResult
    func nibIntervene<View>() -> View? where View: UIView

    /// Загрузка опредленного типа view через nib из бандла основного приложения
    ///
    /// - Returns: загруженная view
    static func fabricateFromAppBundle() -> Self?
    
    /// Загрузка опредленного типа view через nib из локального ресурса
    ///
    /// - Returns: загруженная view
    static func fabricateFromFrameworkBundle() -> Self?
}

// MARK: - Nibble + UIView
public extension Nibble where Self: UIView {

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
}
