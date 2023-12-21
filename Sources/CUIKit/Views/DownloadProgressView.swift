//
//  DownloadProgressView.swift
//

import UIKit

// MARK: - DownloadProgressView
open class DownloadProgressView: UIView {

    public enum State {

        case remote
        case downloading(Double)
        case complete
        case error
    }
    
    open var notDownloadedIcon: UIImage? = .init() {
        didSet {
            updateState()
        }
    }

    open var completeIcon: UIImage? = .init() {
        didSet {
            updateState()
        }
    }

    open var errorIcon: UIImage? = .init() {
        didSet {
            updateState()
        }
    }

    open var notDownloadedTintColor: UIColor = .blue {
        didSet {
            updateState()
        }
    }

    open var progressTintColor: UIColor = .blue {
        didSet {
            setNeedsDisplay()
        }
    }

    open var completeTintColor: UIColor = .blue {
        didSet {
            updateState()
        }
    }

    open var errorTintColor: UIColor = .blue {
        didSet {
            updateState()
        }
    }

    open var downloadState: State = .remote {
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

    private let progressCircleLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.lineCap = .round
        layer.lineWidth = 2
        layer.strokeColor = UIColor.green.cgColor
        layer.transform = CATransform3DMakeRotation(-.pi/2, 0, 0, 1)
        return layer
    }()
    
    private let rectStopLayer = CALayer()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        layoutLayers()
    }

    open override func draw(_ rect: CGRect) {
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

#if DEBUG
// MARK: - Preview
@available(iOS 17.0, *)
#Preview(String(describing: DownloadProgressView.self)) {
    let preview = DownloadProgressView(frame: .zero)
    preview.notDownloadedIcon = .init(systemName: "arrow.down")
    preview.completeIcon = .init(systemName: "checkmark")
    preview.errorIcon = .init(systemName: "exclamationmark")
    preview.progressTintColor = .blue
    preview.completeTintColor = .green
    preview.errorTintColor = .red
    preview.notDownloadedTintColor = .brown
    preview.downloadState =
//         .remote
//         .error
//         .complete
        .downloading(0.8)
    preview.translatesAutoresizingMaskIntoConstraints = false
    let vc = UIViewController()
    vc.view.addSubview(preview)
    NSLayoutConstraint.activate([preview.widthAnchor.constraint(equalToConstant: 80),
                                 preview.heightAnchor.constraint(equalToConstant: 80),
                                 preview.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
                                 preview.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor)])
    return vc
}
#endif
