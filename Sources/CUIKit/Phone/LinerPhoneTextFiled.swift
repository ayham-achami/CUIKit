//
//  LinerPhoneTextFiled.swift
//

import UIKit

/// Текстовое поле с подчеркиванием
@IBDesignable
open class LinerPhoneTextFiled: PhoneTextField {

    private struct Constants {

        let errorPadding = CGFloat(12)
        let underlineHeight = CGFloat(1)
        let erroHeight = CGFloat(23)
        let animationDuration = 0.3
        let errorHideTransform = CGAffineTransform(translationX: 0, y: -23)
        let underlineLayerTopPadding = CGFloat(4)
    }

    /// состояние ошибки
    @IBInspectable
    var isError: Bool = false {
        didSet {
            updateErrorState(isError: isError, animate: true)
        }
    }

    /// текст ошибки
    @IBInspectable
    var error: String? {
        get {
            errorLabel.text
        }
        set {
            errorLabel.text = newValue
        }
    }

    /// цвет текста при ошибке
    @IBInspectable
    var errorColor: UIColor {
        get {
            errorLabel.textColor
        }
        set {
            errorLabel.textColor = newValue
        }
    }

    private lazy var underlineLayer: CALayer = {
        let layer = CALayer()
        let origin = CGPoint(x: 0, y: frame.height + constants.underlineLayerTopPadding)
        let size = CGSize(width: frame.width, height: constants.underlineHeight)
        layer.frame = CGRect(origin: origin, size: size)
        layer.backgroundColor = tintColor.cgColor
        return layer
    }()

    private lazy var errorLabel: UILabel = {
        let origin = CGPoint(x: 0, y: frame.height + constants.errorPadding)
        let size = CGSize(width: frame.width, height: constants.underlineHeight)
        let label = UILabel(frame: CGRect(origin: origin, size: size))
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = textAlignment
        label.numberOfLines = 0
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()

    private let constants = Constants()

    /// Инициализация с frame
    ///
    /// - Parameter frame: frame для инициализации
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    /// Инициализация с coder
    ///
    /// - Parameter aDecoder: coder
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        clipsToBounds = false
        borderStyle = .none
        layer.addSublayer(underlineLayer)

        sendSubviewToBack(errorLabel)
        errorLabel.attach(to: self)
        updateErrorState(isError: false, animate: false)
    }

    private func updateErrorState(isError: Bool, animate: Bool) {
        if isError {
            if animate {
                shakeAnimation()
                errorLabel.showAnimateTransformAlpha(withDuration: constants.animationDuration)
            } else {
                errorLabel.alpha = 1
                errorLabel.transform = .identity
            }
        } else {
            if animate {
                errorLabel.alpha = 0.5
                errorLabel.hideAnimateTransformAlpha(withDuration: constants.animationDuration, using: .topAnchor)
            } else {
                errorLabel.alpha = 0
                errorLabel.transform = constants.errorHideTransform
            }
        }
    }
}
