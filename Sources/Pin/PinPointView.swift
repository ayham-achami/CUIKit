//
//  PinPointView.swift
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

// MARK: - View
@IBDesignable
public class PinPointView: UIView {

    private let pointLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()

    private let filledPointLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 1.6
        return layer
    }()

    private let emptyPointsLayer = CAReplicatorLayer()
    private let filledPointsLayer = CAReplicatorLayer()

    private var completionError: (() -> Void)?

    @IBInspectable
    public var pointCount: Int = 4 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable
    public var sideSize: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable
    @NonNegativeFloat
    var space: CGFloat {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable
    public var fillColor: UIColor = .black {
        didSet {
            filledPointLayer.fillColor = fillColor.cgColor
            filledPointLayer.strokeColor = fillColor.cgColor
        }
    }

    @IBInspectable
    public var strokeEmptyColor: UIColor = .gray {
        didSet {
            pointLayer.strokeColor = strokeEmptyColor.cgColor
        }
    }

    @IBInspectable
    public var errorFillColor: UIColor = .orange

    private var filledPointCount = 0 {
        didSet {
            changeFilledPoint()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }

    public func push() {
        guard filledPointCount < pointCount else { return }
        filledPointCount += 1
    }

    public func pop() {
        guard filledPointCount > 0 else { return }
        filledPointCount -= 1
    }

    public func clear() {
        filledPointCount = 0
    }

    public override var intrinsicContentSize: CGSize {
        let width = self.sideSize * CGFloat(pointCount) + space * CGFloat(pointCount - 1)
        return CGSize(width: width, height: self.sideSize + 2)
    }

    public override func draw(_ rect: CGRect) {

        let pointSideSize = sideSize - 2
        let pointFrame = CGRect(x: 0, y: 0, width: pointSideSize, height: pointSideSize)

        pointLayer.frame = pointFrame
        pointLayer.path = UIBezierPath(ovalIn: pointFrame).cgPath
        pointLayer.strokeColor = strokeEmptyColor.cgColor

        let yRep = rect.midY - sideSize/2
        let repFrame = CGRect(x: 0, y: yRep, width: rect.width, height: pointFrame.height)
        emptyPointsLayer.frame = repFrame
        emptyPointsLayer.instanceCount = pointCount

        filledPointLayer.frame = pointFrame
        filledPointLayer.path = UIBezierPath(ovalIn: pointFrame).cgPath
        filledPointLayer.fillColor = fillColor.cgColor
        filledPointLayer.strokeColor = fillColor.cgColor

        filledPointsLayer.frame = repFrame

        let transformTranslation = CATransform3DMakeTranslation(self.space + sideSize, 0, 0)
        emptyPointsLayer.instanceTransform = transformTranslation
        filledPointsLayer.instanceTransform = transformTranslation
    }

    final public func errorAnimation(completionError: (() -> Void)? = nil) {
        self.completionError = completionError
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x - 8, y: center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: center.x + 8, y: center.y))

        animation.delegate = self
        layer.add(animation, forKey: "position")
        filledPointLayer.fillColor = errorFillColor.cgColor
        filledPointLayer.strokeColor = errorFillColor.cgColor
    }

    final public func fillAll() {
        filledPointCount = pointCount
    }
}

// MARK: - PinPointView + CAAnimationDelegate
extension PinPointView: CAAnimationDelegate {

    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        filledPointLayer.fillColor = fillColor.cgColor
        filledPointLayer.strokeColor = fillColor.cgColor
        filledPointCount = 0
        completionError?()
    }
}

// MARK: - Private methods
private extension PinPointView {

    func setupLayers() {
        emptyPointsLayer.addSublayer(pointLayer)
        layer.addSublayer(emptyPointsLayer)
        filledPointsLayer.addSublayer(filledPointLayer)
        changeFilledPoint()
        layer.addSublayer(filledPointsLayer)
    }

    func changeFilledPoint() {
        guard filledPointCount > 0 else {
            filledPointsLayer.isHidden = true
            return
        }
        if filledPointsLayer.isHidden {
            filledPointsLayer.isHidden = false
        }
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        filledPointsLayer.instanceCount = filledPointCount
        CATransaction.commit()
    }
}

// MARK: - NonNegativeFloat

@propertyWrapper
struct NonNegativeFloat<T: FloatingPoint> {

    private var number: T
    init() { self.number = 0 }
    var wrappedValue: T {
        get { number }
        set { number = max(newValue, 0) }
    }
}
