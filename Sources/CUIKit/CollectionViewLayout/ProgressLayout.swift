//
//  ProgressLayout.swift
//

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

    /// Метод для сравнение объектов
    /// - Parameter object: сравниваемый объект.
    override open func isEqual(_ object: Any?) -> Bool {
        let attributes = object as? ProgressAttributes
        if attributes?.state != state || attributes?.id != id {
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
    ///   - indexPath: Атрибуты загрузки
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
    /// - Parameter rect: Необходимая зона
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        super.layoutAttributesForElements(in: rect)?
            .compactMap { $0.copy() as? ProgressAttributes }
            .compactMap(prepareAttributes)
    }

    /// Подготовка атрибутов
    /// - Parameter attributes: Атрибуты которые насыщаются данными
    private func prepareAttributes(attributes: ProgressAttributes) -> ProgressAttributes {
        guard let collectionView = collectionView, let dataSource = collectionView.dataSource as? ProgressDataSource else { return attributes }
        let dataSourceAttributes = dataSource.collectionView(collectionView, loadingAttributesForitemAt: attributes.indexPath)
        attributes.state = dataSourceAttributes.state
        attributes.id = dataSourceAttributes.id
        return attributes
    }
}

/// CompositionalLayout ячеек с прогрессом
open class ProgressCompositionLayout: UICollectionViewCompositionalLayout {

    /// Тип атрибутов
    override open class var layoutAttributesClass: AnyClass { ProgressAttributes.self }

    /// Возвращает атрибуты для зоны
    /// - Parameter rect: Необходимая зона
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        super.layoutAttributesForElements(in: rect)?
            .compactMap { $0.copy() as? ProgressAttributes }
            .compactMap(prepareAttributes)
    }

    /// Подготовка атрибутов
    /// - Parameter attributes: Атрибуты которые насыщаются данными
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

// MARK: - ProgressCell + UICollectionViewCell
public extension ProgressCell where Self: UICollectionViewCell {

    var attachedView: UIView { self }

    func applyProgress(_ layoutAttributes: ProgressAttributes) {
        switch layoutAttributes.state {
        case .normal:
            attachedView.subviews.first(where: { $0 is ProgressView })?.removeFromSuperview()
        case .downloading(let progress):
            let progressView: ProgressView
            if let currentProgressView = attachedView.subviews.first(where: { $0 is ProgressView }) as? ProgressView {
                progressView = currentProgressView
            } else {
                progressView = self.progressView
                attachedView.addSubview(progressView)
            }
            progressView.setLoading(progress: progress.fractionCompleted, animation: true)
        }
    }
}
