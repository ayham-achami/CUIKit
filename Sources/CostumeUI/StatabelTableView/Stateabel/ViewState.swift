//
//  ViewState.swift
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

/// протокол причины отсутствия результатов
public protocol AnyNoResultReason {}

/// состояние вью
public struct ViewState {

    /// builder состояние вью
    public final class Builder {

        /// случай состояния
        private var `case`: Case?

        /// заголовок состояния
        private var title: String?

        /// заголовок действия состояния
        private var action: String?

        /// иконку состояния
        private var image: UIImage?

        /// цвет иконки
        private var imageColor: UIColor?

        /// размер иконки
        private var imageSideSize: CGFloat?

        /// описание состояния
        private var description: String?

        /// иконка закрытия
        private var closeImage: UIImage?

        /// название кнопки закрытия
        private var closeTitle: String?

        /// инициализация
        public init() {}

        /// добавить случае состояния, если не добваить по умолчанию используется `ViewState.Case.empty`
        /// - Parameter case: случае состояния
        public func with(case: Case) -> Builder {
            self.case = `case`
            return self
        }

        /// добавить иконку состояние. Если не указать, иконка будет скрыта
        /// - Parameter image: иконка состояния
        public func with(image: UIImage) -> Builder {
            self.image = image
            return self
        }

        /// добавить цвет для иконки состояния. Если не указать, будет использован tint
        /// - Parameter imageColor: цвет иконки
        public func with(imageColor: UIColor) -> Builder {
            self.imageColor = imageColor
            return self
        }

        /// добавить размер для иконки состояния. Если не указать, будет рассчитан автоматически
        /// - Parameter imageSideSize: размер иконки
        public func with(imageSideSize: CGFloat) -> Builder {
            self.imageSideSize = imageSideSize
            return self
        }

        /// добавить заголовок состояния если не добваить, заголовок будет скрыт
        /// - Parameter title: заголовок состояния
        public func with(title: String) -> Builder {
            self.title = title
            return self
        }

        /// добавить действия состояния если не добваить, действия будет скрытое
        /// - Parameter action: действия состояния
        public func with(action: String) -> Builder {
            self.action = action
            return self
        }

        /// добавить описание состояния если не добваить, описание будет скрытое
        /// - Parameter description: описание состояния
        public func with(description: String) -> Builder {
            self.description = description
            return self
        }

        /// добавить кнопку закрыть с иконкой
        /// - Parameter closeImage: иконка закрытия
        public func with(closeImage: UIImage?) -> Builder {
            self.closeImage = closeImage
            return self
        }

        /// добавить кнопку закрыть названием
        /// - Parameter closeTitle: название кнопки закрытия
        public func with(closeTitle: String?) -> Builder {
            self.closeTitle = closeTitle
            return self
        }

        /// создать состояние
        /// - Returns: возвращает состояние view
        public func build() -> ViewState {
            ViewState(case: `case` ?? .empty,
                              title: title,
                              action: action ?? "",
                              image: image ?? UIImage(),
                              imageColor: imageColor,
                              imageSideSize: imageSideSize,
                              description: description ?? "",
                              closeImage: closeImage,
                              closeTitle: closeTitle)
        }
    }

    /// случай состояния
    public enum Case {
        
        /// нет данных, например список пустой
        case empty
        /// при попытке получения данных произошла ошибка
        case error
        /// идет загрузка данных
        case loading
        /// отсутствие данных `AnyNoResultReason` причины отсутствия результатов
        case noResult(AnyNoResultReason?)
    }

    /// случай состояния
    public let `case`: Case

    /// заголовок состояния
    public let title: String?

    /// заголовок действия состояния
    public let action: String

    /// иконку состояния
    public let image: UIImage

    /// цвет иконки
    public let imageColor: UIColor?

    /// размер иконки
    public let imageSideSize: CGFloat?

    /// описание состояния
    public let description: String

    /// иконка закрытия
    public let closeImage: UIImage?

    /// название кнопки закрытия
    public let closeTitle: String?
}
