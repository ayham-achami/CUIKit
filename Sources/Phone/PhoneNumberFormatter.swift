//
//  PhoneNumberFormatter.swift
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

import Foundation

/// форматирует строку по выбранному паттерну с префиксом если есть
open class PhoneNumberFormatter: Formatter {

    /// возвращает количество цифр в строке
    ///
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

    /// является ли символ символом цифры
    ///
    /// - Parameter ch: проверяемый символ
    /// - Returns: true если символ цифра, иначе false
    public static func isValuableChar(_ ch: Character) -> Bool {
        return ch >= "0" && ch <= "9"
    }

    /// маска для форматирования
    public var pattern = "(###) ###-##-##"
    /// ссылка на TextField для применения префикса
    public weak var textField: PhoneTextField?

    private var _prefix = "+7"
    private let requiredChar: Character = "#"

    /// префикс
    public var prefix: String {
        get {
            return _prefix
        }
        set {
            _prefix = "+\(newValue)"
            set(prefix: _prefix)

        }
    }

    /// фильтрует переданную строку
    ///
    /// - Parameter string: строка для фильтрации
    /// - Returns: новая строка с цифрами
    public func digitOnly(string: String) -> String {
        let regex = try? NSRegularExpression(pattern: "\\D", options: .caseInsensitive)
        return regex?.stringByReplacingMatches(in: string,
                                               options: .reportProgress,
                                               range: NSRange(location: 0, length: string.count),
                                               withTemplate: "") ?? ""
    }

    /// возвращает новую строку с примененной маской
    ///
    /// - Parameter string: строка для применения маски
    /// - Returns: новая строка с премененной маской и префиксом
    public func values(for string: String) -> String {
        let nonPrefix = withoutPrefix(string: string)
        let formattedDigits = stringWithoutFormat(nonPrefix)
        return apply(format: pattern, for: formattedDigits)
    }

    /// возвращает новую строку без префикса
    ///
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

    /// является ли символ символом маски
    ///
    /// - Parameter ch: символ для проверки
    /// - Returns: true если переданный символ является символом маски, иначе false
    private func isRequeredSubtitute(_ ch: Character) -> Bool {
        ch == requiredChar
    }

    // MARK: - Getting Formatted String

    /// Применить выбранный формат к строке
    ///
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

    /// возвращает строку без формата
    ///
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
    ///
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

    /// возвращает текстовое представление для объекта
    ///
    /// - Parameter obj: объект для которого возвращается текстовое представление
    /// - Returns: текстовое представление объекта
    open override func string(for obj: Any?) -> String? {
        guard let string = obj as? String else { return nil }
        return values(for: string)
    }
}

private extension String {

    /// возвращает новую строку без символов, которые были переданы
    ///
    /// - Parameter characters: символы для удаления из строки
    /// - Returns: новая строка без удаленных символов
    func removeCharacters(characters: String) -> String {

        let characterSet = CharacterSet(charactersIn: characters)
        let components = self.components(separatedBy: characterSet)
        let result = components.joined(separator: "")
        return result
    }

    /// возвращает строку без заданного префикса
    ///
    /// - Parameter prefix: префикса
    /// - Returns: строка без заданного префикса
    func without(prefix: String) -> String {

        guard self.hasPrefix(prefix) else { return self }

        let index = self.index(self.startIndex, offsetBy: prefix.count)
        return String(self[index...])
    }
}
