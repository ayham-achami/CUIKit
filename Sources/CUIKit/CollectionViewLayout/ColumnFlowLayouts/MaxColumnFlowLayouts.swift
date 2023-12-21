//
//  MaxColumnFlowLayouts.swift
//

import UIKit

/// Слой коллекции который стремится создать максимальную по размеру ячейки, но количество колонок обязательно больше минимально заданного
public protocol MaxColumnFlowLayouts {

    /// Отступы
    var insets: UIEdgeInsets { get }
    /// Минимальная ширина колонки
    var minColumnWidth: CGFloat { get }
    /// Максимальная ширина колонки
    var maxColumnWidth: CGFloat { get }
    /// Минимальное количество колонок
    var minColumnCount: Int { get }
    /// Максимальная высота ячейки
    var maxCellHeight: CGFloat { get }

    /// Расчет размера ячейки
    func calculateItemSize() -> CGSize
}

// MARK: - MaxColumnFlowLayouts + Default
public extension MaxColumnFlowLayouts where Self: UICollectionViewLayout {

    func calculateItemSize() -> CGSize {
        guard let collectionView = collectionView else { return .zero }
        let availableWidth = collectionView.bounds.width
        let step = CGFloat(insets.left > 0 ? -insets.left : -10)
        for currentWidth in stride(from: maxColumnWidth, through: minColumnWidth, by: step) {
            let maxNumColumns = ((availableWidth - insets.left) / (currentWidth + insets.left)).rounded(.up)
            guard maxNumColumns >= CGFloat(minColumnCount) else { continue }
            let cellWidth = ((availableWidth - insets.left) / maxNumColumns - insets.left).rounded(.up)
            let cellHeight = (maxCellHeight * (cellWidth/maxColumnWidth)).rounded(.up)
            return CGSize(width: cellWidth, height: cellHeight)
        }
        return .zero
    }
}
