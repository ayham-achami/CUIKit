//
//  ColumnFlowLayout.swift
//

import UIKit

/// Layout умеющий вычислять количество ячеек на основе размера экрана
open class ColumnFlowLayout: UICollectionViewFlowLayout {

    /// минимальная ширина колонки
    private let minColumnWidth: CGFloat
    /// высота ячейки
    private let cellHeight: CGFloat
    /// отступы
    private var insets: UIEdgeInsets

    /// набор удаленных индексов
    private var deletingIndexPaths = [IndexPath]()
    /// набор добавленных индексов
    private var insertingIndexPaths = [IndexPath]()

    /// Стандартная инициализация
    /// - Parameters:
    ///   - minColumnWidth: минимальная ширина колонки
    ///   - cellHeight: высота ячейки
    ///   - edgeInsets: отстыпы
    public init(minColumnWidth: CGFloat, cellHeight: CGFloat, edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 16, bottom: 0.0, right: 16)) {
        self.minColumnWidth = minColumnWidth
        self.cellHeight = cellHeight
        self.insets = edgeInsets
        super.init()
    }

    /// Инициализация с кодером
    /// - Parameter coder: кодер
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Overrides

    /// Подготовка размеров ячеек и отступов collectionView
    override open func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }

        if insets.top == 0.0 {
            insets.top = minimumInteritemSpacing
        }

        let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).width - (insets.left + insets.right)
        let maxNumColumns = Int(availableWidth / minColumnWidth)
        let cellWidth = (availableWidth / CGFloat(maxNumColumns)).rounded(.down)

        self.itemSize = CGSize(width: cellWidth, height: cellHeight)
        self.sectionInset = insets
        self.sectionInsetReference = .fromSafeArea
    }

    /// Финальный layout атрибутов для исчезающего элемента
    /// - Parameter itemIndexPath: indexPath
    /// - Returns: возвращает атрибуты для исчезающей ячейки
    override open func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath) else { return nil }
        if !deletingIndexPaths.isEmpty {
            if deletingIndexPaths.contains(itemIndexPath) {
                attributes.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                attributes.alpha = 0.0
                attributes.zIndex = 0
            }
        }
        return attributes
    }

    /// Начальный layout атрибутов для появляющегося элемента
    /// - Parameter itemIndexPath: indexPath
    /// - Returns: возвращает атрибуты для появляющейся ячейки
    override open func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath) else { return nil }
        if insertingIndexPaths.contains(itemIndexPath) {
            attributes.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            attributes.alpha = 0.0
            attributes.zIndex = 0
        }
        return attributes
    }
    
    /// Подготовка для обновления ячеек коллекции
    /// - Parameter updateItems: массив ячеек коллекции, которые надо обновить
    override open func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        for update in updateItems {
            switch update.updateAction {
            case .delete:
                guard let indexPath = update.indexPathBeforeUpdate else { return }
                deletingIndexPaths.append(indexPath)
            case .insert:
                guard let indexPath = update.indexPathAfterUpdate else { return }
                insertingIndexPaths.append(indexPath)
            default:
                break
            }
        }
    }
    
    /// Завершить обновление CollectionView
    override open func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        deletingIndexPaths.removeAll()
        insertingIndexPaths.removeAll()
    }
}
