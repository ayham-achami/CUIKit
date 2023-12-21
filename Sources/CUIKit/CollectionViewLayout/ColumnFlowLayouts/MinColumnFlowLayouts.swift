//
//  MinColumnFlowLayouts.swift
//

import UIKit

/// Слой коллекции который стремится разместить максимальное количество ячеейк в строке, но ширину ячейки сделать больше минимальной
public protocol MinColumnFlowLayouts {

    /// Oтступы
    var insets: UIEdgeInsets { get }
    /// Mинимальная ширина колонки
    var minColumnWidth: CGFloat { get }
    /// Mаксимальная высота ячейки
    var minCellHeight: CGFloat { get }

    /// Расчет размера ячейки
    func calculateItemSize() -> CGSize
}

// MARK: - MinColumnFlowLayouts + Default
public extension MinColumnFlowLayouts where Self: UICollectionViewLayout {

    func calculateItemSize() -> CGSize {
        guard let collectionView = collectionView else { return CGSize() }
        let availableWidth = collectionView.bounds.width
        let maxNumColumns = ((availableWidth - insets.left) / (minColumnWidth + insets.left)).rounded(.down)
        let cellWidth = ((availableWidth - insets.left) / maxNumColumns - insets.left).rounded(.down)
        let cellHeight = (minCellHeight * (cellWidth/minColumnWidth)).rounded(.down)
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
