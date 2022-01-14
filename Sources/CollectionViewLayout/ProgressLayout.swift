//
//  ProgressLayout.swift
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

/// Атрибуты для ячейки с прогрессом
open class ProgressAttributes: UICollectionViewLayoutAttributes {

    /// Состояние ячейки с прогрессом
    public enum State: Equatable {

        /// Обычное стеснение
        case normal

        /// Загружается с прогрессом
        case downloading(Progress)

        public static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.normal, normal):
                return true
            default:
                return false
            }
        }
    }

    /// Текущее состояние прогресса
    open var state: State = .normal
    
    /// id
    open var id: Int?

    /// Инициализация с состоянием
    /// - Parameter state: текущее состояние
    public convenience init(state: State, id: Int? = nil) {
        self.init()
        self.state = state
        self.id = id
    }
}

/// ProgressAttributes + NSCopy
extension ProgressAttributes {

    /// Возвращает копию текущего объекта
    /// - Parameter zone: This parameter is ignored. Memory zones are no longer used by Objective-C
    override open func copy(with zone: NSZone? = nil) -> Any {
        if let copy = super.copy(with: zone) as? ProgressAttributes {
            copy.state = self.state
            copy.id = self.id
            return copy
        }
        return super.copy(with: zone)
    }

    /// Метод для сравнения объектов
    /// - Parameter object: сравниваемый объект.
    override open func isEqual(_ object: Any?) -> Bool {
        let attrs = object as? ProgressAttributes
        if attrs?.state != state || attrs?.id != id {
            return false
        }
        return super.isEqual(object)
    }
}

/// Источник данных для ячейки с прогрессом
public protocol ProgressDataSource: AnyObject {

    /// Набор атрибутов загрузки
    /// - Parameters:
    ///   - collectionView: Коллекция запрашивая данных
    ///   - indexPath: Aтрибутов загрузки
    func collectionView(_ collectionView: UICollectionView, loadingAttributesForitemAt indexPath: IndexPath) -> ProgressAttributes
}

/// Коллекция ячеек с прогрессом
open class ProgressCollectionView: UICollectionView {

    /// Ссылка на источник данных
    public weak var progressDataSource: ProgressDataSource?

    /// Источник данных
    override open var dataSource: UICollectionViewDataSource? {
        willSet {
            progressDataSource = newValue as? ProgressDataSource
        }
    }

    /// Обновить состояние прогресса
    public func reloadProgressState() {
        collectionViewLayout.invalidateLayout()
    }
}

/// Лайаут ячеек с прогрессом
open class ProgressLayout: UICollectionViewFlowLayout {

    /// Тип атрибутов
    override open class var layoutAttributesClass: AnyClass { ProgressAttributes.self }

    /// Возвращает атрибуты для зоны
    /// - Parameter rect: необходимая зона
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        super.layoutAttributesForElements(in: rect)?
            .compactMap { $0.copy() as? ProgressAttributes }
            .compactMap(prepareAttributes)
    }

    /// Подготовка атрибутов
    /// - Parameter attributes: атрибуты которые насыщаются данными
    private func prepareAttributes(attributes: ProgressAttributes) -> ProgressAttributes {
        guard let collectionView = collectionView, let dataSource = collectionView.dataSource as? ProgressDataSource else { return attributes }
        let dataSourceAttributes = dataSource.collectionView(collectionView, loadingAttributesForitemAt: attributes.indexPath)
        attributes.state = dataSourceAttributes.state
        attributes.id = dataSourceAttributes.id
        return attributes
    }
}

/// CompositionalLayout ячеек с прогрессом
@available(iOS 13.0, *)
open class ProgressCompositionLayout: UICollectionViewCompositionalLayout {

    /// Тип атрибутов
    override open class var layoutAttributesClass: AnyClass { ProgressAttributes.self }

    /// Возвращает атрибуты для зоны
    /// - Parameter rect: необходимая зона
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        super.layoutAttributesForElements(in: rect)?
            .compactMap { $0.copy() as? ProgressAttributes }
            .compactMap(prepareAttributes)
    }

    /// Подготовка атрибутов
    /// - Parameter attributes: атрибуты которые насыщаются данными
    private func prepareAttributes(attributes: ProgressAttributes) -> ProgressAttributes {
        guard let collectionView = collectionView, let dataSource = collectionView.dataSource as? ProgressDataSource else { return attributes }
        let dataSourceAttributes = dataSource.collectionView(collectionView, loadingAttributesForitemAt: attributes.indexPath)
        attributes.state = dataSourceAttributes.state
        attributes.id = dataSourceAttributes.id
        return attributes
    }
}

/// Протокол для вью загрузки
public protocol ProgressView: UIView {

    /// Прогресс загрузки
    var progress: Double { get }

    /// Установка прогресса
    /// - Parameters:
    ///   - progress: прогресс
    ///   - animation: нужна ли анимация
    func setLoading(progress: Double, animation: Bool)
}

/// Ячейка с прогрессом загрузки
public protocol ProgressCell {

    /// Вью индикации загрузки
    var progressView: ProgressView { get }

    /// Вью к которое надо добавить прогресс
    var attachedView: UIView {  get }

    /// Реализация обработки атрибутов
    /// - Parameter layoutAttributes: атрибуты для ячейки
    func applyProgress(_ layoutAttributes: ProgressAttributes)
}

public extension ProgressCell where Self: UICollectionViewCell {

    var attachedView: UIView { self }

    func applyProgress(_ layoutAttributes: ProgressAttributes) {
        switch layoutAttributes.state {
        case .normal:
            attachedView.subviews.first(where: { $0 is ProgressView })?.removeFromSuperview()
        case .downloading(let progress):
            let progressView: ProgressView
            if let currrentProgressView = attachedView.subviews.first(where: { $0 is ProgressView }) as? ProgressView {
                progressView = currrentProgressView
            } else {
                progressView = self.progressView
                attachedView.addSubview(progressView)
            }
            progressView.setLoading(progress: progress.fractionCompleted, animation: true)
        }
    }
}
