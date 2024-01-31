//
//  PlaceholderTextView.swift
//

import UIKit

// MARK: - PlaceholderTextView
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
@IBDesignable
open class PlaceholderTextView: UITextView {

    @IBInspectable
    open var placeholder: String? {
        get {
            placeholderLabel.text
        }
        set {
            placeholderLabel.text = newValue
        }
    }

    open override var text: String! {
        didSet {
            placeholderLabel.isHidden = !text.isEmpty
            invalidateIntrinsicContentSize()
        }
    }

    open override var font: UIFont? {
        didSet {
            placeholderLabel.font = font
        }
    }

    public var maxHeight: CGFloat = 150

    open override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        if size.height > maxHeight {
            size.height = maxHeight
            isScrollEnabled = true
        } else {
            isScrollEnabled = false
        }
        return size
    }

    open override var textContainerInset: UIEdgeInsets {
        didSet {
            placeholderLabelTopConstraint?.constant = textContainerInset.top
            placeholderLabelLeftConstraint?.constant = textContainerInset.left + 5
            placeholderLabelWidthConstraint?.constant = -textContainerInset.right - textContainerInset.left - 10
        }
    }

    private var placeholderLabelTopConstraint: NSLayoutConstraint?
    private var placeholderLabelLeftConstraint: NSLayoutConstraint?
    private var placeholderLabelWidthConstraint: NSLayoutConstraint?

    fileprivate lazy var placeholderLabel: UILabel = {
        let label = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 2), size: CGSize(width: frame.width, height: 28)))
        label.textColor = .lightGray
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.font = font
        label.textAlignment = textAlignment
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupPlaceholderLabel()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupPlaceholderLabel()
    }

    private func setupPlaceholderLabel() {
        addSubview(placeholderLabel)
        bringSubviewToFront(placeholderLabel)
        placeholderLabelTopConstraint = placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        placeholderLabelLeftConstraint = placeholderLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5)
        placeholderLabelWidthConstraint = placeholderLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -10)
        activateConstraints()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange(_:)),
                                               name: UITextView.textDidChangeNotification,
                                               object: nil)
    }

    private func activateConstraints() {
        guard
            let placeholderLabelTopConstraint,
            let placeholderLabelLeftConstraint,
            let placeholderLabelWidthConstraint
        else { return }
        NSLayoutConstraint.activate([
            placeholderLabelTopConstraint,
            placeholderLabelLeftConstraint,
            placeholderLabelWidthConstraint
        ])
    }

    public func setIsRequired(_ isRequired: Bool) {
        guard var placeholder = placeholder else { return }
        let asterixSuffix = " *"
        if isRequired, !placeholder.hasSuffix(asterixSuffix) {
            placeholder += asterixSuffix
        } else if !isRequired, placeholder.hasSuffix(asterixSuffix) {
            placeholder.removeLast(asterixSuffix.count)
        }
        self.placeholder = placeholder
    }

    @objc func textDidChange(_ notification: NSNotification) {
        placeholderLabel.isHidden = !text.isEmpty
        invalidateIntrinsicContentSize()
    }
}
