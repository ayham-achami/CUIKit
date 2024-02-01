//
//  PhoneNumberFormatter.swift
//

import Foundation

/// Форматирует строку по выбранному паттерну с префиксом если есть
open class PhoneNumberFormatter: Formatter {

    /// Возвращает количество цифр в строке
    /// - Parameter string: строка для проверки
    /// - Returns: количество цифрт в строке
    public static func valuableCharCountIn(string: String) -> Int {
        var count = 0
        string.forEach {
            if PhoneNumberFormatter.isValuableChar($0) {
                count += 1
            }
        }
        return count
    }

    /// Является ли символ символом цифры
    /// - Parameter ch: проверяемый символ
    /// - Returns: true если символ цифра, иначе false
    public static func isValuableChar(_ ch: Character) -> Bool {
        ch >= "0" && ch <= "9"
    }

    /// Маска для форматирования
    public var pattern = "(###) ###-##-##"
    /// Ссылка на TextField для применения префикса
    public weak var textField: PhoneTextField?

    private var _prefix = "+7"
    private let requiredChar: Character = "#"

    /// Префикс
    public var prefix: String {
        get {
            _prefix
        }
        set {
            _prefix = "+\(newValue)"
            set(prefix: _prefix)
        }
    }

    /// Фильтрует переданную строку
    /// - Parameter string: строка для фильтрации
    /// - Returns: новая строка с цифрами
    public func digitOnly(string: String) -> String {
        let regex = try? NSRegularExpression(pattern: "\\D", options: .caseInsensitive)
        return regex?.stringByReplacingMatches(in: string,
                                               options: .reportProgress,
                                               range: NSRange(location: 0, length: string.count),
                                               withTemplate: "") ?? ""
    }

    /// Возвращает новую строку с примененной маской
    /// - Parameter string: строка для применения маски
    /// - Returns: новая строка с премененной маской и префиксом
    public func values(for string: String) -> String {
        let nonPrefix = withoutPrefix(string: string)
        let formattedDigits = stringWithoutFormat(nonPrefix)
        return apply(format: pattern, for: formattedDigits)
    }

    /// Возвращает новую строку без префикса
    /// - Parameter string: строка ввода
    /// - Returns: новую строку без префикса
    public func withoutPrefix(string: String) -> String {
        var nonPrefix = string
        if string.hasPrefix(prefix) {
            nonPrefix = string.without(prefix: prefix)
        } else {
            let trimmedPrefix = prefix.trimmingCharacters(in: .whitespacesAndNewlines)
            nonPrefix = string.without(prefix: trimmedPrefix)
        }
        return nonPrefix
    }

    /// Является ли символ символом маски
    /// - Parameter ch: символ для проверки
    /// - Returns: true если переданный символ является символом маски, иначе false
    private func isRequeredSubtitute(_ ch: Character) -> Bool {
        ch == requiredChar
    }

    /// Применить выбранный формат к строке
    /// - Parameters:
    ///   - format: формат применения
    ///   - formattedString: строка для форматирования
    /// - Returns: возвращает отформатированную строку
    private func apply(format: String, for formattedString: String) -> String {
        var result = ""
        var charIndex = 0
        for char in format {
            if charIndex == formattedString.count { break }
            if isRequeredSubtitute(char) {
                let spIndex = formattedString.index(formattedString.startIndex, offsetBy: charIndex)
                charIndex += 1
                result.append(formattedString[spIndex])
            } else {
                result.append(char)
            }
        }
        return prefix + result
    }

    /// Возвращает строку без формата
    /// - Parameter string: строка с премененной маской
    /// - Returns: новая строка без символов маски
    private func stringWithoutFormat(_ string: String) -> String {
        var removeChars = ""
        pattern.forEach {
            if !isRequeredSubtitute($0) {
                removeChars.append($0)
            }
        }
        let result = string.removeCharacters(characters: removeChars)
        return digitOnly(string: result)
    }

    private func set(prefix: String) {
        let phoneNumber = textField?.phoneNumberWithoutPrefix
        if let textField = textField {
            PhoneLogic.applyFormat(textField, for: prefix.appending(phoneNumber ?? ""))
        }
    }

    /// Возвращает объект по строке
    /// - Parameters:
    ///   - obj: указатель на объект
    ///   - string: строка из которого создается объект
    ///   - error: указатель на возможную ошибку
    /// - Returns: успешно ли прошло конвертирование
    open override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
                                      for string: String,
                                      errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        true
    }

    /// Возвращает текстовое представление для объекта
    /// - Parameter obj: объект для которого возвращается текстовое представление
    /// - Returns: текстовое представление объекта
    open override func string(for obj: Any?) -> String? {
        guard let string = obj as? String else { return nil }
        return values(for: string)
    }
}

// MARK: - String + PhoneNumberFormatter
private extension String {

    /// Возвращает новую строку без символов, которые были переданы
    /// - Parameter characters: символы для удаления из строки
    /// - Returns: новая строка без удаленных символов
    func removeCharacters(characters: String) -> String {
        let characterSet = CharacterSet(charactersIn: characters)
        let components = self.components(separatedBy: characterSet)
        let result = components.joined(separator: "")
        return result
    }

    /// Возвращает строку без заданного префикса
    /// - Parameter prefix: префикса
    /// - Returns: строка без заданного префикса
    func without(prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        let index = self.index(self.startIndex, offsetBy: prefix.count)
        return String(self[index...])
    }
}
