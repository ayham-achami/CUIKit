//
//  TransformAnchor.swift
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

/// направление трансфера
public enum TransformAnchor {
    /// - topAnchor: вверх
    case topAnchor
    /// - bottomAnchor: вниз
    case bottomAnchor
    /// - leftAnchor: влева
    case leftAnchor
    /// - rightAnchor: вправа
    case rightAnchor
}

/// протокол трансфер объекта
public protocol AnchorTransformable: ViewAnimation {

    /// возвращает нужный сдвиг по нужному направлению
    ///
    /// - Parameter anchor: направление трансфера
    /// - Returns: нужный сдвиг
    func transform(for anchor: TransformAnchor) -> CGAffineTransform
}

// MARK: - UIView + AnchorTransformable + Default
public extension AnchorTransformable where Self: UIView {

    func transform(for anchor: TransformAnchor) -> CGAffineTransform {
        switch anchor {
        case .topAnchor:
            return CGAffineTransform(translationX: 0, y: -frame.height)
        case .bottomAnchor:
            return CGAffineTransform(translationX: 0, y: frame.height)
        case .leftAnchor:
            return CGAffineTransform(translationX: -frame.width, y: 0)
        case .rightAnchor:
            return CGAffineTransform(translationX: frame.width, y: 0)
        }
    }
}
