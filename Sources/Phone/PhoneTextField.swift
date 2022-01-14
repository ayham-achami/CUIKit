//
//  PhoneTextField.swift
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

/// TextField с маской для номера телефона
@IBDesignable
open class PhoneTextField: UITextField {

    // MARK: - Properties

    private var logic = PhoneLogic()
    private var oldPrefix = ""
    /// форматер телефоного номера
    public let formatter = PhoneNumberFormatter()

    // MARK: - Init

    /// Инициализация с frame
    ///
    /// - Parameter frame: frame для инициализации
    public override init(frame: CGRect) {
        super.init(frame: frame)
        logicInitialization()
    }

    /// Инициализация с coder
    ///
    /// - Parameter coder: coder для инициализации
     public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        logicInitialization()
    }

    // MARK: - Delegates

    /// делегат
    open override var delegate: UITextFieldDelegate? {
        get {
            logic.delegate
        }
        set {
            logic.delegate = newValue
        }
    }

    // MARK: - IBInspectable

    /// префикс телефоного номера
    @IBInspectable
    public var prefix: String {
        get {
            formatter.prefix
        }
        set {
            oldPrefix = formatter.prefix
            formatter.prefix = newValue
        }
    }

    /// шаблон телефоного номера
    @IBInspectable
    public var pattern: String {
        get {
            formatter.pattern
        }
        set {
            formatter.pattern = newValue
        }
    }

    // MARK: - Additional Text Setter
    /// телефонный номер
    public var phoneNumber: String {
        guard let text = self.text else { return "" }
        return formatter.digitOnly(string: text)
    }

    /// телефонный номер без префикса
    public var phoneNumberWithoutPrefix: String {
        guard let text = self.text else { return "" }
        return formatter.digitOnly(string: text.replacingOccurrences(of: oldPrefix, with: ""))
    }

    /// применения формата для строки
    ///
    /// - Parameter text: строка для которой применяется формат
    public func setFormatted(text: String) {
        PhoneLogic.applyFormat(self, for: text)
    }

    /// очиска телефона
    public func clear() {
        PhoneLogic.applyFormat(self, for: "")
    }

    private func logicInitialization() {
        formatter.textField = self
        super.delegate = logic
        self.keyboardType = .phonePad
        self.autocorrectionType = .yes
        self.textContentType = .telephoneNumber
    }
}
