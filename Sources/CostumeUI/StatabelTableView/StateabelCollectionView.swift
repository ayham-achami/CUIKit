//
//  StateabelCollectionView.swift
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

/// `UICollectionView` с поддержкой логики состояния
public class StateabelCollectionView: UICollectionView, Stateabel, StateViewDelegate {

    /// dataSourse состояния и collectionView
    public typealias DataSource = StateabelDataSource & UICollectionViewDataSource
    /// delegate состояния и collectionView
    public typealias Delegate = StateabelDelegate & UICollectionViewDelegate

    /// delegate состояния
    public weak var stateDelegate: StateabelDelegate?
    /// dataSource состояния
    public weak var stateDataSource: StateabelDataSource?

    /// dataSource collectionView
    public override var dataSource: UICollectionViewDataSource? {
        willSet {
            stateDataSource = newValue as? DataSource
        }
    }

    /// delegate collectionView
    public override var delegate: UICollectionViewDelegate? {
        willSet {
            stateDelegate = newValue as? Delegate
        }
    }

    /// обновляем состояние
    public override func layoutSubviews() {
        super.layoutSubviews()
        if isState { reloadState() }
    }

    /// обновление состояния
    public override func reloadData() {
        super.reloadData()
        reloadState()
    }
}
