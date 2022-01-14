//
//  DesignableButton.swift
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

/// UIButton, настраивается на storyboard/xib
@IBDesignable
open class DesignableButton: UIButton, Designable {

    /// является ли элемент круглым
    @IBInspectable
    open var isRounded: Bool = false {
        didSet {
            if isRounded {
                layer.cornerRadius = frame.height * 0.5
            } else {
                layer.cornerRadius = 0
            }
        }
    }

    /// радиус скругления
    @IBInspectable
    open var cornerRadius: CGFloat = 0 {
        didSet {
            if !isRounded {
                layer.cornerRadius = cornerRadius
            }
        }
    }

    /// толщина линии границы
    @IBInspectable
    open var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    /// цвет линии границы
    @IBInspectable
    open var borderColor: UIColor = .gray {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    /// цвет тени
    @IBInspectable
    open var shadowColor: UIColor? {
        didSet {
            if let shadowColor = shadowColor {
                layer.shadowColor = shadowColor.cgColor
                clipsToBounds = false
                if isRounded {
                    layer.shadowPath = UIBezierPath.init(ovalIn: layer.bounds).cgPath
                } else {
                    layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: cornerRadius).cgPath
                }
            } else {
                layer.shadowColor = UIColor.clear.cgColor
            }
        }
    }

    /// прозрачность тени
    @IBInspectable
    open var shadowOpacity: Float = 0.0 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }

    /// радиус тени
    @IBInspectable
    open var shadowRadius: CGFloat = 0.0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }

    /// отступ тени
    @IBInspectable
    open var shadowOffset: CGSize = .zero {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }

    /// количество строк
    @IBInspectable
    open var numberOfLines: Int = 1 {
        didSet {
            titleLabel?.numberOfLines = numberOfLines
        }
    }

    /// иконка кнопки
    @IBInspectable
    open var icon: UIImage? {
        willSet {
            setImage(newValue?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }

    /// цвет текста у заголовка
    @IBInspectable
    open var titleColor: UIColor? {
        didSet {
            guard let titleColor = titleColor else { return }
            titleLabel?.textColor = titleColor
        }
    }

    /// Обновляем радиус скругления, могли измениться размеры вью
    override open func layoutSubviews() {
        super.layoutSubviews()
        guard isRounded else { return }
        isRounded = true
    }
}
