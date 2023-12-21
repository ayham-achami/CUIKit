//
//  PhoneTextField.swift
//

import UIKit

/// TextField с маской для номера телефона
open class PhoneTextField: UITextField {

    /// форматер телефоного номера
    public let formatter = PhoneNumberFormatter()

    /// делегат
    open override var delegate: UITextFieldDelegate? {
        get {
            logic.delegate
        }
        set {
            logic.delegate = newValue
        }
    }

    /// префикс телефоного номера
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
    public var pattern: String {
        get {
            formatter.pattern
        }
        set {
            formatter.pattern = newValue
        }
    }

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

    private var oldPrefix = ""
    private var logic = PhoneLogic()
    
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
