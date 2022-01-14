//
//  ShadowableImageView.swift
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

/// ImageView с тенью, настраивается на storyboard/xib
@IBDesignable
open class ShadowableImageView: UIView, Designable {

    private lazy var imageView: UIImageView = {
        UIImageView(frame: bounds)
    }()

    /// Отображаемое изображение
    @IBInspectable
    open var image: UIImage? {
        get {
            imageView.image
        }
        set {
            imageView.image = newValue
        }
    }

    /// является ли элемент круглым
    @IBInspectable
    open var isRounded: Bool = false {
        didSet {
            imageView.clipsToBounds = cornerRadius != 0 || isRounded
            if isRounded {
                imageView.layer.cornerRadius = frame.height * 0.5
            } else {
                imageView.layer.cornerRadius = 0
            }
        }
    }

    /// радиус скругления
    @IBInspectable
    open var cornerRadius: CGFloat = 0 {
        didSet {
            imageView.clipsToBounds = cornerRadius != 0 || isRounded
            if !isRounded {
                imageView.layer.cornerRadius = cornerRadius
            }
        }
    }

    /// толщина линии границы
    @IBInspectable
    open var borderWidth: CGFloat = 0 {
        didSet {
            imageView.layer.borderWidth = borderWidth
        }
    }

    /// цвет линии границы
    @IBInspectable
    open var borderColor: UIColor = .gray {
        didSet {
            imageView.layer.borderColor = borderColor.cgColor
        }
    }

    /// цвет тени
    @IBInspectable
    open var shadowColor: UIColor? {
        didSet {
            if let shadowColor = shadowColor {
                layer.shadowColor = shadowColor.cgColor
                layer.masksToBounds = false
                if isRounded {
                    layer.shadowPath = UIBezierPath.init(ovalIn: imageView.layer.bounds).cgPath
                } else {
                    layer.shadowPath = UIBezierPath(roundedRect: imageView.layer.bounds, cornerRadius: cornerRadius).cgPath
                }
            } else {
                layer.shadowColor = UIColor.clear.cgColor
            }
        }
    }

    /// прозрачность тени
    @IBInspectable
    open var shadowOpacity: Float = 1.0 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }

    /// радиус тени
    @IBInspectable
    open var shadowRadius: CGFloat = 1.0 {
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

    /// Инициализация с frame
    ///
    /// - Parameter frame: frame для инициализации
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    /// Инициализация с coder
    ///
    /// - Parameter aDecoder: coder для инициализации
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    /// Обновляем радиус скругления, могли измениться размеры вью
    override open func layoutSubviews() {
        super.layoutSubviews()
        guard isRounded else { return }
        isRounded = true
    }

    /// настройка `UIImageView`
    private func setup() {
        clipsToBounds = false
        backgroundColor = .clear
        imageView.attach(to: self)
    }
}
