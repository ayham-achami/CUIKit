//
//  PhoneLogic.swift
//

import UIKit

/// Логика связанная с телефонным номером
open class PhoneLogic: NSObject {

    /// Метод отвечающий за логику редактирования TextField
    /// - Parameters:
    ///   - textField: редактируемый PhoneTextField
    ///   - range: позиция редактирования
    ///   - string: новая строка
    public static func logicTextField(_ textField: PhoneTextField, shouldChangeCharactersIn range: NSRange, replacement string: String) {
        let prefixLength = textField.formatter.prefix.count
        guard prefixLength > 0 && range.location < prefixLength else { return }
        let caretPosition = pushCaretPosition(textField, range: range)
        let newString = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
        applyFormat(textField, for: newString)
        popCaretPosition(textField, range: range, caretPosition: caretPosition)
    }

    /// Применить форматирования для строки и поставить ее в TextField.text
    /// - Parameters:
    ///   - textField: textField для замены текстового поля
    ///   - text: строка для форматирования
    public static func applyFormat(_ textField: PhoneTextField, for text: String) {
        textField.text = textField.formatter.values(for: text)
    }

    /// Подменяет префикс А с префиксом В
    /// под условием что, номер телефона начинается с префикс А
    /// иначе возвращается номер телефона без изменения
    /// - Parameters:
    ///   - prefixA: префикс А например 8
    ///   - prefixB: префикс В например +7
    ///   - phone: номер телефона начинающий с префиксом А например 8 (926) 000-00-00
    /// - Returns: номер телефона начинается с префикс В например +7 (926) 000-00-00
    public static func replace(_ prefixA: String, with prefixB: String, in phone: String) -> String {
        guard phone.lowercased().hasPrefix(prefixA.lowercased()) else { return phone }
        return prefixB + String(phone.dropFirst(prefixA.count))
    }

    /// Является ли номер телефона российский номер телефона
    /// - Parameter phoneNumber: номер телефона
    /// - Returns: true если номер телефона является российским
    public static func isRussian(_ phoneNumber: String) -> Bool {
        phoneNumber.hasPrefix("+7") || phoneNumber.hasPrefix("8")
    }

    private static func pushCaretPosition(_ textField: UITextField, range: NSRange) -> Int {
        guard let text = textField.text else { return 0 }
        let index = text.index(text.startIndex, offsetBy: range.location + range.length)
        let subString = String(text[index...])
        return PhoneNumberFormatter.valuableCharCountIn(string: subString)
    }

    private static func popCaretPosition(_ textField: UITextField, range: NSRange, caretPosition: Int) {
        guard let text = textField.text else { return }
        var start = text.count
        if caretPosition > 0 {
            var lasts = caretPosition
            for index in (0..<start).reversed() {
                let chIndex = text.index(text.startIndex, offsetBy: index)
                if PhoneNumberFormatter.isValuableChar(text[chIndex]) {
                    lasts -= 1
                }
                if lasts <= 0 {
                    start = index
                    break
                }
            }
        }
        selectTextFor(input: textField, at: NSRange(location: start, length: 0))
    }

    private static func selectTextFor(input: UITextField, at range: NSRange) {
        guard let start = input.position(from: input.beginningOfDocument, offset: range.location) else { return }
        guard let end = input.position(from: start, offset: range.length) else { return }
        input.selectedTextRange = input.textRange(from: start, to: end)
    }
    
    weak var delegate: UITextFieldDelegate?
}

// MARK: - PhoneLogic + UITextFieldDelegate
extension PhoneLogic: UITextFieldDelegate {

    /// Должны ли символы быть заменены
    /// - Parameters:
    ///   - textField: textField для замены текстового поля
    ///   - range: range для замены текста
    ///   - string: строка для замены текста
    /// - Returns: флаг указываешь должена ли быть заменена
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textField = textField as? PhoneTextField else { return false }
        PhoneLogic.logicTextField(textField, shouldChangeCharactersIn: range, replacement: string)
        if let delegate = delegate,
            delegate.responds(to: #selector(UITextFieldDelegate.textField(_:shouldChangeCharactersIn:replacementString:))) {
            _ = delegate.textField!(textField, shouldChangeCharactersIn: range, replacementString: string)
        }
        return false
    }

    /// Должно ли textField быть отчищен
    /// - Parameter textField: textField для очистки
    /// - Returns: флаг указываешь должен ли быть очищен
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if let delegate = delegate,
            delegate.responds(to: #selector(UITextFieldDelegate.textFieldShouldClear(_:))) {
            return delegate.textFieldShouldClear!(textField)
        }
        guard let textField = textField as? PhoneTextField else { return true }
        if !textField.formatter.prefix.isEmpty {
            textField.setFormatted(text: "")
            return false
        } else {
            return true
        }
    }

    /// Должно ли начаться редактирования для textField
    /// - Parameter textField: textField для редактирования
    /// - Returns: флаг указываешь должно ли начаться редактирование
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let delegate = delegate,
            delegate.responds(to: #selector(UITextFieldDelegate.textFieldShouldBeginEditing(_:))) {
            return delegate.textFieldShouldBeginEditing!(textField)
        }
        return true
    }

    /// Началось редактирование
    /// - Parameter textField: textField в котором началось редактирование
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if let delegate = delegate,
            delegate.responds(to: #selector(UITextFieldDelegate.textFieldDidBeginEditing(_:))) {
            delegate.textFieldDidBeginEditing!(textField)
        }
    }

    /// Должно ли закончиться редактирования для textField
    /// - Parameter textField: textField
    /// - Returns: флаг указываешь должно ли закончиться редактирование
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let delegate = delegate,
            delegate.responds(to: #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:))) {
            return delegate.textFieldShouldEndEditing!(textField)
        }
        return true
    }

    /// Закончилось редактирование
    /// - Parameter textField: textField в котором закончилось редактирование
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if let delegate = delegate,
            delegate.responds(to: #selector(UITextFieldDelegate.textFieldDidEndEditing(_:))) {
            delegate.textFieldDidEndEditing!(textField)
        }
    }

    /// Должен ли textField обработать нажатие кнопки return
    /// - Parameter textField: textField для обработки
    /// - Returns: флаг указываешь должно ли быть обработано нажати е
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let delegate = delegate,
            delegate.responds(to: #selector(UITextFieldDelegate.textFieldShouldReturn(_:))) {
            return delegate.textFieldShouldReturn!(textField)
        }
        return true
    }
}
