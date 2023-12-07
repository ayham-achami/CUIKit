//
//  PhoneTextField.swift
//

import UIKit

/// TextField с маской для номера телефона
@IBDesignable
open class PhoneTextField: UITextField {

    // MARK: - Properties

    private var logic = PhoneLogic()
    private var oldPrefix = ""
    /// форматер телефоного номера
    public let formatter = PhoneNumberFormatter()

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
