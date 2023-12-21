//
//  FeedbackGenerator.swift
//

import UIKit

/// Класс для генерации откликов на действия пользователя
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public final class FeedbackGenerator {

    /// Генерирует отклик для успешной операции
    public static func generateSuccess() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    /// Генерирует отклик для ошибки
    public static func generateError() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }

    /// Генерирует отклик для предупреждения
    public static func generateWarning() {
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }

    /// Генерирует стандартный отклик, например при нажатии на кнопку
    public static func generateCommon() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
}
