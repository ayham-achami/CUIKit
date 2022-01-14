//
//  СircleProgressView.swift
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

/// Вью с круглым индикатором загрузки в центре
open class СircleProgressView: UIView, ProgressView {

    /// Текущий прогресс
    public var progress = Double(0.0) {
        didSet {
            setLoading(progress: progress, animation: false)
        }
    }
    /// Время анимации
    public let duration: TimeInterval
    /// Цвет прогресса
    public let progressColor: UIColor
    /// Прямая или обратная анимация
    public let isReversing: Bool
    /// Во сколько раз уменьшить вью прогресса
    public let downscale: CGFloat
    /// Толщина линии
    public let lineWidth: CGFloat
    /// Ссылка на внутренний слой
    public private(set) var innerLayer = CAShapeLayer()
    /// Слой на внешний слой
    public private(set) var outerLayer = CAShapeLayer()

    /// инициализация с кодером
    /// - Parameter coder: кодер
    required public init?(coder: NSCoder) {
        self.duration = 0.3
        self.progressColor = UIColor.black.withAlphaComponent(0.3)
        self.isReversing = false
        self.downscale = 4
        self.lineWidth = 3.0
        super.init(coder: coder)
        setupLayers()
    }

    /// инициализация
    /// - Parameters:
    ///   - frame: Фрейм
    ///   - progressAnimationDuration: Время анимации
    ///   - progressColor: Цвет прогресса
    public init(_ frame: CGRect, _ duration: TimeInterval, _ outerColor: UIColor, _ isReversing: Bool = false, downscale: CGFloat = 4, lineWidth: CGFloat = 3.0) {
        self.duration = duration
        self.progressColor = outerColor
        self.isReversing = isReversing
        self.downscale = downscale
        self.lineWidth = lineWidth
        super.init(frame: frame)
        setupLayers()
    }

    /// установка слоев
    private func setupLayers() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let trackPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2),
                                     radius: frame.size.width / downscale - (lineWidth / 2 ),
                                     startAngle: -0.5 * .pi,
                                     endAngle: -2.5 * .pi,
                                     clockwise: false)

        outerLayer.path = isReversing ? trackPath.reversing().cgPath : trackPath.cgPath
        outerLayer.fillColor = UIColor.clear.cgColor
        outerLayer.lineWidth = lineWidth
        outerLayer.strokeColor = progressColor.cgColor
        outerLayer.strokeEnd = 1.0
        layer.addSublayer(outerLayer)

        let progresPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2),
                                       radius: frame.size.width / (downscale * 2),
                                       startAngle: -0.5 * .pi,
                                       endAngle: 1.5 * .pi,
                                       clockwise: true)

        innerLayer.path = isReversing ? progresPath.reversing().cgPath : progresPath.cgPath
        innerLayer.fillColor = UIColor.clear.cgColor
        innerLayer.lineWidth = (frame.size.width) / downscale
        innerLayer.strokeEnd = isReversing ? 1.0 : 0.0
        innerLayer.strokeColor = progressColor.cgColor
        layer.addSublayer(innerLayer)
    }

    /// установка прогресса
    /// - Parameters:
    ///   - progress: прогресс
    ///   - animation: нужна ли анимация
    public func setLoading(progress: Double, animation: Bool) {
        if animation {
            let previusValue = innerLayer.strokeEnd

            innerLayer.strokeEnd = isReversing ? CGFloat(1 - progress) : CGFloat(progress)
            let innerAnimation = CABasicAnimation(keyPath: "strokeEnd")
            innerAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            innerAnimation.fromValue = previusValue
            innerAnimation.duration = duration
            innerLayer.add(innerAnimation, forKey: "strokeEnd")

            outerLayer.strokeEnd = isReversing ? CGFloat(progress) : CGFloat(1 - progress)
            let outerAnimation = CABasicAnimation(keyPath: "strokeEnd")
            outerAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            outerAnimation.fromValue = 1 - previusValue
            outerAnimation.duration = duration
            outerLayer.add(outerAnimation, forKey: "strokeEnd")
        } else {
            innerLayer.strokeEnd = isReversing ? CGFloat(1 - progress) : CGFloat(progress)
            outerLayer.strokeEnd = isReversing ? CGFloat(progress) : CGFloat(1 - progress)
        }
    }
}
