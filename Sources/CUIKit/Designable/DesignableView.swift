//
//  DesignableView.swift
//

import UIKit

/// UIView, настраивается на storyboard/xib
@IBDesignable
open class DesignableView: UIView, Designable {

    /// является ли элемент круглым
    @IBInspectable
    open var isRounded: Bool = false {
        didSet {
            clipsToBounds = cornerRadius != 0 || isRounded
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
            clipsToBounds = cornerRadius != 0 || isRounded
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
                layer.masksToBounds = false
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

    /// отуступ тени
    @IBInspectable
    open var shadowOffset: CGSize = .zero {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }

    /// Обновляем радиус скругления, могли измениться размеры вью
    override open func layoutSubviews() {
        super.layoutSubviews()
        guard isRounded else { return }
        isRounded = true
    }
}
