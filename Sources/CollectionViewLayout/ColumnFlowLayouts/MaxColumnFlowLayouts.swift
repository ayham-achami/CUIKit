//
//  MaxColumnFlowLayouts.swift
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
