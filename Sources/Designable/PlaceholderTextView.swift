//
//  PlaceholderTextView.swift
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

// MARK: - PlaceholderTextView
@IBDesignable
open class PlaceholderTextView: UITextView {

    @IBInspectable
    open var placeholder: String? {
        get {
            return placeholderLabel.text
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

    @objc
    func textDidChange(_ notification: NSNotification) {
        placeholderLabel.isHidden = !text.isEmpty
        invalidateIntrinsicContentSize()
    }
}
