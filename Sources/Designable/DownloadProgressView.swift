//
//  DownloadProgressView.swift
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

// MARK: - DownloadProgressView
@IBDesignable
public class DownloadProgressView: UIView {

    public enum State {

        case remote
        case downloading(Double)
        case complete
        case error
    }

    @IBInspectable
    public var notDownloadedIcon: UIImage? = .init() {
        didSet {
            updateState()
        }
    }

    @IBInspectable
    public var completeIcon: UIImage? = .init() {
        didSet {
            updateState()
        }
    }

    @IBInspectable
    public var errorIcon: UIImage? = .init() {
        didSet {
            updateState()
        }
    }

    @IBInspectable
    public var notDownloadedTintColor: UIColor = .blue {
        didSet {
            updateState()
        }
    }

    @IBInspectable
    public var progressTintColor: UIColor = .blue {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable
    public var completeTintColor: UIColor = .blue {
        didSet {
            updateState()
        }
    }

    @IBInspectable
    public var errorTintColor: UIColor = .blue {
        didSet {
            updateState()
        }
    }

    public var downloadState: State = .remote {
        didSet {
            updateState()
        }
    }

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let rectStopLayer = CALayer()

    private let progressCircleLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.lineCap = .round
        layer.lineWidth = 2
        layer.strokeColor = UIColor.green.cgColor
        layer.transform = CATransform3DMakeRotation(-.pi/2, 0, 0, 1)
        return layer
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        layoutLayers()
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        rectStopLayer.backgroundColor = progressTintColor.cgColor
        progressCircleLayer.strokeColor = progressTintColor.cgColor
    }
}

// MARK: - Private methods
private extension DownloadProgressView {

    func setup() {
        setupViews()
        setupLayers()
    }

    func setupViews() {
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func setupLayers() {
        layer.addSublayer(rectStopLayer)
        layer.addSublayer(progressCircleLayer)
        progressCircleLayer.strokeStart = 0.0
        progressCircleLayer.strokeEnd = 0.0
        rectStopLayer.opacity = 0
        progressCircleLayer.opacity = 0
    }

    func layoutLayers() {
        rectStopLayer.frame = bounds
        progressCircleLayer.frame = bounds
        let sideSize = min(bounds.height, bounds.width) / 3
        let rectPath = CGRect(x: bounds.midX - sideSize / 2,
                              y: bounds.midY - sideSize / 2,
                              width: sideSize,
                              height: sideSize)
        rectStopLayer.frame = rectPath
        rectStopLayer.cornerRadius = sideSize * 0.2
        progressCircleLayer.path = UIBezierPath(ovalIn: bounds.insetBy(dx: 2, dy: 2)).cgPath
    }

    func updateState() {
        var imageIsHidden = false
        switch downloadState {
        case .remote:
            imageView.image = notDownloadedIcon
            imageView.tintColor = notDownloadedTintColor
            progressCircleLayer.strokeEnd = 0
        case .downloading(let value):
            imageIsHidden = true
            progressCircleLayer.strokeEnd = CGFloat(value)
        case .complete:
            imageView.image = completeIcon
            imageView.tintColor = completeTintColor
            progressCircleLayer.strokeEnd = 1
        case .error:
            imageView.image = errorIcon
            imageView.tintColor = errorTintColor
            progressCircleLayer.strokeEnd = 0
        }
        imageView.isHidden = imageIsHidden
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        progressCircleLayer.opacity = imageIsHidden ? 1 : 0
        rectStopLayer.opacity = imageIsHidden ? 1 : 0
        CATransaction.commit()
    }
}
