//
//  ShadowableImageView.swift
//

import UIKit

/// ImageView с тенью, настраивается на storyboard/xib
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
@IBDesignable
open class ShadowableImageView: UIView, Designable {

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
    
    /// Используемый для определения того, как представление 
    /// размещает свое содержимое при изменении его границ.
    open var imageContentMode: UIView.ContentMode {
        get {
            imageView.contentMode
        }
        set {
            imageView.contentMode = newValue
        }
    }
    
    private let imageView = UIImageView()

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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        NSLayoutConstraint.activate([imageView.topAnchor.constraint(equalTo: topAnchor),
                                     imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
                                     imageView.leftAnchor.constraint(equalTo: leftAnchor),
                                     imageView.rightAnchor.constraint(equalTo: rightAnchor)])
    }
}
