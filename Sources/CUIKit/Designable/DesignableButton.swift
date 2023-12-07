//
//  DesignableButton.swift
//

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
