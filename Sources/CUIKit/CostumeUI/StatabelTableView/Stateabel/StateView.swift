//
//  StateView.swift
//

import UIKit

/// протокол делегации `StateView`
public protocol StateViewDelegate: AnyObject {

    /// вызывается при нажатии на кнопку текущего состояния
    /// - Parameters:
    ///   - stateView: вью состояния
    ///   - case: текущий случае состояния
    func stateView(_ stateView: StateView, didTapActionFor case: ViewState.Case)

    /// вызывается при нажатии на кнопку закрыть
    /// - Parameters:
    ///   - stateView: вью состояния
    ///   - case: текущий случае состояния
    func stateView(_ stateView: StateView, didTapCloseFor case: ViewState.Case)
}

/// вью состояния
public class StateView: UIView, Nibble {

    /// delegate состояния
    public weak var delegate: StateViewDelegate?

    @IBOutlet private weak var loadingView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var loadingLabel: UILabel!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var stateImageView: UIImageView!
    @IBOutlet private weak var actionButton: DesignableButton!
    @IBOutlet private var heightImageViewConstraint: NSLayoutConstraint!

    /// случае состояния
    private var `case`: ViewState.Case = .empty

    /// вызывается при нажатии на кнопку текущего состояния
    /// - Parameter sender: `UIButton`
    @IBAction private func didTapActionButton(_ sender: Any) {
        delegate?.stateView(self, didTapActionFor: `case`)
    }

    @IBAction private func didTapClose(_ sender: Any) {
        delegate?.stateView(self, didTapCloseFor: `case`)
    }
    
    /// вызывается после того, как view и subviews были аллоцированы и инициализированы
    public override func awakeFromNib() {
        super.awakeFromNib()
        loadingView.backgroundColor = .clear
    }

    /// обновить состояние
    /// - Parameter state: новое состояние
    /// - Parameter activityView: вью индикатор загрузки
    public func update(with state: ViewState, activityView: ActivityView) {
        self.loadingView.subviews.forEach { $0.removeFromSuperview() }
        switch state.case {
        case .loading:
            setupLoadingState(state, with: activityView)
        case .empty, .error, .noResult:
            setup(with: state)
        }
        `case` = state.case
    }

    /// настроить состояние загрузки
    /// - Parameter view: вью индикатор загрузки
    private func setupLoadingState(_ state: ViewState, with view: ActivityView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.center = CGPoint(x: loadingView.bounds.midX, y: loadingView.bounds.midY)
        loadingView.addSubview(view)
        NSLayoutConstraint.activate([view.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
                                     view.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor),
                                     view.widthAnchor.constraint(equalToConstant: view.frame.width),
                                     view.heightAnchor.constraint(equalToConstant: view.frame.height)])
        view.startAnimating()
        loadingLabel.text = state.title ?? NSLocalizedString("LoadingTableStateTitle", comment: "Loading")
        loadingLabel.isHidden = false
        loadingView.isHidden = false
        stateImageView.isHidden = true
        titleLabel.isHidden = true
        descriptionLabel.isHidden = true
        actionButton.isHidden = true
    }

    /// настроить вью по состоянию
    /// - Parameter state: новое состояние
    private func setup(with state: ViewState) {
        loadingLabel.isHidden = true
        loadingView.isHidden = true

        stateImageView.isHidden = false
        stateImageView.tintColor = state.imageColor ?? tintColor
        if let size = state.imageSideSize {
            heightImageViewConstraint.constant = size
            heightImageViewConstraint.isActive = true
        } else {
            heightImageViewConstraint.isActive = false
        }
        stateImageView.image = state.image.withRenderingMode(.alwaysTemplate)

        titleLabel.text = state.title ?? ""
        titleLabel.isHidden = state.title?.isEmpty ?? true

        descriptionLabel.text = state.description
        descriptionLabel.isHidden = state.description.isEmpty

        actionButton.tintColor = tintColor
        actionButton.borderColor = tintColor
        actionButton.titleEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        actionButton.setTitle(state.action, for: .normal)
        actionButton.invalidateIntrinsicContentSize()
        actionButton.layoutIfNeeded()
        actionButton.isHidden = state.action.isEmpty

        if let closeImage = state.closeImage {
            closeButton.setImage(closeImage, for: .normal)
        } else if let closeTitle = state.closeTitle {
            closeButton.setTitle(closeTitle, for: .normal)
        }

        closeButton.isHidden = state.closeTitle == nil && state.closeImage == nil
    }
}
