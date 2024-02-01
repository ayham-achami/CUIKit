//
//  ProgressButton.swift
//

import UIKit

/// UIButton, c круглым индикатором прогресса, настраивается на storyboard/xib
open class ProgressButton: UIButton {

    /// Цвет линии прогресса
    open var progressColor: UIColor = .green {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }

    /// Цвет незаполненной линии
    open var trackColor: UIColor = .gray {
        didSet {
            trackLayer.strokeColor = trackColor.cgColor
        }
    }

    /// Толщина линии прогресса
    open var progressLineWidth: CGFloat = 3 {
        didSet {
            progressLayer.lineWidth = progressLineWidth
        }
    }

    /// Толщина незаполненной линии
    open var trackLineWidth: CGFloat = 3 {
        didSet {
            trackLayer.lineWidth = trackLineWidth
        }
    }

    /// Прогресс заполнения
    open var progress: CGFloat = 0 {
        didSet {
            animateProgress(from: progressLayer.strokeEnd, to: progress)
        }
    }

    /// Длительность анимации заполнения
    public var progressAnimationDuration: TimeInterval = 0.3

    /// Слой незаполненной линии
    private var progressLayer = CAShapeLayer()
    /// Слой заполненной линии
    private var trackLayer = CAShapeLayer()

    /// Инициализация с frame
    /// - Parameter frame: frame для инициализации
    override public init(frame: CGRect) {
        super.init(frame: frame)
        makeCircularPath()
    }

    /// Инициализация с coder
    /// - Parameter frame: coder для инициализации
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeCircularPath()
    }

    /// Отрисовка слоев
    private func makeCircularPath() {
        backgroundColor = UIColor.clear
        layer.cornerRadius = self.frame.size.width / 2
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2),
                                      radius: (frame.size.width - 1.5) / 2,
                                      startAngle: 0.5 * .pi,
                                      endAngle: 2.5 * .pi,
                                      clockwise: true)

        trackLayer.path = circlePath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = trackLineWidth
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.strokeEnd = 1.0
        layer.addSublayer(trackLayer)

        progressLayer.path = circlePath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = progressLineWidth
        progressLayer.strokeEnd = progress
        progressLayer.strokeColor = progressColor.cgColor
        layer.addSublayer(progressLayer)
    }

    /// Анимирования прогресса
    /// - Parameters:
    ///   - startValue: начальное значение полосы прогресса
    ///   - endValue: конечное значение полосы прогресса
    private func animateProgress(from startValue: CGFloat, to endValue: CGFloat) {
        progressLayer.strokeEnd = endValue
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.fromValue = startValue
        animation.duration = progressAnimationDuration
        progressLayer.add(animation, forKey: "strokeEnd")
    }
}
