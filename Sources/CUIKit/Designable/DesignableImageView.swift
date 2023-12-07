//
//  DesignableImageView.swift
//

import UIKit

/// ImageView, настраивается на storyboard/xib
@IBDesignable
open class DesignableImageView: UIImageView, Borderable, Roundable {

    /// является ли элемент круглым
    @IBInspectable
    open var isRounded: Bool = false {
        didSet {
            clipsToBounds = cornerRadius != 0 || isRounded
            if isRounded {
                layer.cornerRadius = frame.height * 0.5
                clipsToBounds = true
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

    /// Обновляем радиус скругления, могли измениться размеры вью
    override open func layoutSubviews() {
        super.layoutSubviews()
        guard isRounded else { return }
        isRounded = true
    }
}
