//
//  StateabelCollectionView.swift
//

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
