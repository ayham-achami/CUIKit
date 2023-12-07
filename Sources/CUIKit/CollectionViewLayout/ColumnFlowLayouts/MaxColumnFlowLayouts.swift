//
//  MaxColumnFlowLayouts.swift
//

import UIKit

/// Слой коллекции который стремится создать максимальную по размеру ячейки, но количество колонок обязательно больше минимально заданного
public protocol MaxColumnFlowLayouts {

    /// отстыпы
    var insets: UIEdgeInsets { get }
    /// минимальная ширина колонки
    var minColumnWidth: CGFloat { get }
    /// максимальная ширина колонки
    var maxColumnWidth: CGFloat { get }
    /// минимальное количество колонок
    var minColumnCount: Int { get }
    /// максимальная высота ячейки
    var maxCellHeight: CGFloat { get }

    /// Рассчет размера ячейки
    func calculateItemSize() -> CGSize
}

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
