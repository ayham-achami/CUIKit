//
//  MinColumnFlowLayouts.swift
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

/// Слой коллекции который стремится разместить максимальное количество ячеейк в строке, но ширину ячейки сделать больше минимальной
public protocol MinColumnFlowLayouts {

    /// отстыпы
    var insets: UIEdgeInsets { get }
    /// минимальная ширина колонки
    var minColumnWidth: CGFloat { get }
    /// максимальная высота ячейки
    var minCellHeight: CGFloat { get }

    /// Рассчет размера ячейки
    func calculateItemSize() -> CGSize
}

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
