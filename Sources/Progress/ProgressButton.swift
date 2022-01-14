//
//  ProgressButton.swift
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

/// UIButton, c круглым индикатором прогресса, настраивается на storyboard/xib
@IBDesignable
open class ProgressButton: DesignableButton {

    // MARK: - Public properties

    /// цвет линии прогресса
    @IBInspectable
    open var progressColor: UIColor = .green {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }

    /// цвет незаполненной линии
    @IBInspectable
    open var trackColor: UIColor = .gray {
        didSet {
            trackLayer.strokeColor = trackColor.cgColor
        }
    }

    /// толщина линии прогресса
    @IBInspectable
    open var progressLineWidth: CGFloat = 3 {
        didSet {
            progressLayer.lineWidth = progressLineWidth
        }
    }

    /// толщина незаполненной линии
    @IBInspectable
    open var trackLineWidth: CGFloat = 3 {
        didSet {
            trackLayer.lineWidth = trackLineWidth
        }
    }

    /// прогресс заполнения
    open var progress: CGFloat = 0 {
        didSet {
            animateProgress(from: progressLayer.strokeEnd, to: progress)
        }
    }

    /// длительность анимации заполнения
    public var progressAnimationDuration: TimeInterval = 0.3

    // MARK: - Private properties

    /// слой незаполненной линии
    private var progressLayer = CAShapeLayer()
    /// слой заполненной линии
    private var trackLayer = CAShapeLayer()

    // MARK: - Public methods

    /// Инициализация с frame
    ///
    /// - Parameter frame: frame для инициализации
    override public init(frame: CGRect) {
        super.init(frame: frame)
        makeCircularPath()
    }

    /// Инициализация с coder
    ///
    /// - Parameter frame: coder для инициализации
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeCircularPath()
    }

    // MARK: - Private methods

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
    ///
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
