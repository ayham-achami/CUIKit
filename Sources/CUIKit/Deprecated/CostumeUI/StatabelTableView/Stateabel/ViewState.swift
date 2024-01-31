//
//  ViewState.swift
//

import UIKit

/// Протокол причины отсутствия результатов
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public protocol AnyNoResultReason {}

/// Состояние вью
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public struct ViewState {

    /// Builder состояние вью
    public final class Builder {

        /// Случай состояния
        private var `case`: Case?

        /// Заголовок состояния
        private var title: String?

        /// Заголовок действия состояния
        private var action: String?

        /// Иконку состояния
        private var image: UIImage?

        /// Цвет иконки
        private var imageColor: UIColor?

        /// Размер иконки
        private var imageSideSize: CGFloat?

        /// Описание состояния
        private var description: String?

        /// Иконка закрытия
        private var closeImage: UIImage?

        /// Название кнопки закрытия
        private var closeTitle: String?

        /// Инициализация
        public init() {}

        /// Добавить случае состояния, если не добавить по умолчанию используется `ViewState.Case.empty`
        /// - Parameter case: Случае состояния
        public func with(case: Case) -> Builder {
            self.case = `case`
            return self
        }

        /// Добавить иконку состояние. Если не указать, иконка будет скрыта
        /// - Parameter image: Иконка состояния
        public func with(image: UIImage) -> Builder {
            self.image = image
            return self
        }

        /// Добавить цвет для иконки состояния. Если не указать, будет использован tint
        /// - Parameter imageColor: Цвет иконки
        public func with(imageColor: UIColor) -> Builder {
            self.imageColor = imageColor
            return self
        }

        /// Добавить размер для иконки состояния. Если не указать, будет рассчитан автоматически
        /// - Parameter imageSideSize: Размер иконки
        public func with(imageSideSize: CGFloat) -> Builder {
            self.imageSideSize = imageSideSize
            return self
        }

        /// Добавить заголовок состояния если не добавить, заголовок будет скрыт
        /// - Parameter title: Заголовок состояния
        public func with(title: String) -> Builder {
            self.title = title
            return self
        }

        /// Добавить действия состояния если не добавить, действия будет скрытое
        /// - Parameter action: Действия состояния
        public func with(action: String) -> Builder {
            self.action = action
            return self
        }

        /// Добавить описание состояния если не добавить, описание будет скрытое
        /// - Parameter description: Описание состояния
        public func with(description: String) -> Builder {
            self.description = description
            return self
        }

        /// Добавить кнопку закрыть с иконкой
        /// - Parameter closeImage: Иконка закрытия
        public func with(closeImage: UIImage?) -> Builder {
            self.closeImage = closeImage
            return self
        }

        /// Добавить кнопку закрыть названием
        /// - Parameter closeTitle: Название кнопки закрытия
        public func with(closeTitle: String?) -> Builder {
            self.closeTitle = closeTitle
            return self
        }

        /// Создать состояние
        /// - Returns: Возвращает состояние view
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

    /// Случай состояния
    public enum Case {
        
        /// Нет данных, например список пустой
        case empty
        /// При попытке получения данных произошла ошибка
        case error
        /// Идет загрузка данных
        case loading
        /// Отсутствие данных `AnyNoResultReason` причины отсутствия результатов
        case noResult(AnyNoResultReason?)
    }

    /// Случай состояния
    public let `case`: Case

    /// Заголовок состояния
    public let title: String?

    /// Заголовок действия состояния
    public let action: String

    /// Иконку состояния
    public let image: UIImage

    /// Цвет иконки
    public let imageColor: UIColor?

    /// Размер иконки
    public let imageSideSize: CGFloat?

    /// Описание состояния
    public let description: String

    /// Иконка закрытия
    public let closeImage: UIImage?

    /// Название кнопки закрытия
    public let closeTitle: String?
}
