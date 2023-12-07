//
//  PinPointView.swift
//

import UIKit

// MARK: - View
@IBDesignable
public class PinPointView: UIView {

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
    @NonNegativeFloat var space: CGFloat {
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

    public override var intrinsicContentSize: CGSize {
        let width = self.sideSize * CGFloat(pointCount) + space * CGFloat(pointCount - 1)
        return CGSize(width: width, height: self.sideSize + 2)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
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
    
    var wrappedValue: T {
        get {
            number
        }
        set {
            number = max(newValue, 0)
        }
    }
    
    init() {
        self.number = 0
    }
}
