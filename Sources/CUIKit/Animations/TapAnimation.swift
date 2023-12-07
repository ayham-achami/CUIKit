//
//  TapAnimation.swift
//

import UIKit

/// Вью с возможностью импульсной анимации
internal final class RippleView: UIView {

    /// цвет волны
    private let animationColor: UIColor
    private let animationDuration = CFTimeInterval(1)
    private lazy var rippleLayerReference: CAShapeLayer = { rippleLayer }()
    private var superViewClipsToBounds: Bool = false

    /// инициализация
    /// - Parameter frame: фарйм вью
    /// - Parameter animationColor: цвет волны
    init(frame: CGRect, animationColor: UIColor) {
        self.animationColor = animationColor
        super.init(frame: frame)
    }

    override init(frame: CGRect) {
        self.animationColor = .black
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        self.animationColor = .black
        super.init(coder: coder)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touches = event?.touches(for: self), let touch = touches.first else { return }
        // Если вью анимации добавить поверх кнопки, то UIControll перестает работать.
        // Для избежания этой проблемы преобразуем нажатие gestureRecognizer'a в action для UIControl
        if let control = superview as? UIControl {
            control.sendActions(for: .touchUpInside)
        } else {
            super.touchesBegan(touches, with: event)
        }

        superViewClipsToBounds = superview?.clipsToBounds ?? true
        superview?.clipsToBounds = true
        let animationCenter = touch.location(in: self)

        layer.insertSublayer(rippleLayerReference, at: 0)
        layer.masksToBounds = true

        rippleLayerReference.fillColor = animationColor.cgColor
        rippleLayerReference.add(rippleAnimate(at: animationCenter, duration: animationDuration), forKey: "path")
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        rippleLayerReference.fadeAnimation(duration: 0.3)
        superview?.clipsToBounds = superViewClipsToBounds
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        rippleLayerReference.fadeAnimation(duration: 0.3)
        superview?.clipsToBounds = superViewClipsToBounds
    }
}

// MARK: - ViewAnimation + View
private extension ViewAnimation where Self: UIView {

    /// слой с импульсной анимацей
    var rippleLayer: CAShapeLayer {
        let rippleLayer = CAShapeLayer()
        rippleLayer.name = AnimationNamespace.Layers.ripple
        return rippleLayer
    }
    
    /// создает возвращает базовой импульсной анимации
    /// - Parameter point: точка запуска анимации
    /// - Parameter duration: продолжительность анимации
    func rippleAnimate(at point: CGPoint, duration: CFTimeInterval) -> CABasicAnimation {
        let startPath = UIBezierPath(arcCenter: point,
                                     radius: 0.1,
                                     startAngle: 0,
                                     endAngle: 2 * .pi,
                                     clockwise: true)

        let endRarius = sqrt(bounds.width * bounds.width + bounds.height * bounds.height)
        let endPath = UIBezierPath(arcCenter: point,
                                     radius: endRarius,
                                     startAngle: 0,
                                     endAngle: 2 * .pi,
                                     clockwise: true)

        let rippleAnimation = CABasicAnimation(keyPath: "path")
        rippleAnimation.fillMode = .forwards
        rippleAnimation.duration = duration
        rippleAnimation.fromValue = startPath.cgPath
        rippleAnimation.toValue = endPath.cgPath
        rippleAnimation.isRemovedOnCompletion = false
        rippleAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        return rippleAnimation
    }
}

/// создает импульсную анимацию 
public protocol RippleInteractionAnimation: ViewAnimation {

    /// Добавить интерактивную анимацию пульсации
    /// - Parameter color: цвет пульсации
    func applyRippleInteraction(with color: UIColor)

    /// Удалить интерактивную анимацию пульсации
    func removeRippleInteraction()
}

// MARK: - RippleInteractionAnimation + UIView + Deafult
public extension RippleInteractionAnimation where Self: UIView {

    func applyRippleInteraction(with color: UIColor) {
        guard !subviews.contains(where: { $0 is RippleView }) else { return }
        let rippleView = RippleView(frame: bounds, animationColor: color)
        rippleView.layer.cornerRadius = layer.cornerRadius
        rippleView.attach(to: self)
        sendSubviewToBack(rippleView)
    }

    func removeRippleInteraction() {
        subviews.filter { $0 is RippleView }.forEach { $0.removeFromSuperview() }
    }
}

// MARK: - UIView + RippleInteractionAnimation
extension UIView: RippleInteractionAnimation {}

/// Анимации нажатия
public protocol TapAnimation: RippleInteractionAnimation {

    /// Анимация пульсации
    ///
    /// - Parameters:
    ///   - point: эпицентр пульсации
    ///   - color: цвет пульсации
    func performRippleAnimation(at point: CGPoint?, color: UIColor, duration: TimeInterval)
}

// MARK: - TapAnimation + UIView + Default
public extension TapAnimation where Self: UIView {

    func performRippleAnimation(at point: CGPoint? = nil, color: UIColor = .black, duration: TimeInterval = 0.6) {
        let sublayers = layer.sublayers ?? []
        guard !sublayers.contains(where: { $0.name == AnimationNamespace.Layers.ripple }) else { return }
        let previousClipsToBounds = clipsToBounds
        clipsToBounds = true
        let animationCenter = point ?? CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let rippleLayer = self.rippleLayer

        layer.insertSublayer(rippleLayer, at: 0)

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            rippleLayer.fadeAnimation(view: self,
                                      previousClipsToBounds: previousClipsToBounds,
                                      duration: duration)
        }
        rippleLayer.fillColor = color.cgColor
        rippleLayer.add(rippleAnimate(at: animationCenter, duration: duration), forKey: "path")
        CATransaction.commit()
    }
}

// MARK: - UIView + TapAnimation
extension UIView: TapAnimation {}
