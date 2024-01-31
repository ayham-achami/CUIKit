//
//  StateabelTableView.swift
//

import UIKit

/// `UITableView` с поддержкой логику состояния
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public class StateabelTableView: UITableView, Stateabel, StateViewDelegate {

    /// dataSourse состояния и tableView
    public typealias DataSource = StateabelDataSource & UITableViewDataSource
    /// delegate состояния и tableView
    public typealias Delegate = StateabelDelegate & UITableViewDelegate

    /// dataSourse состояния
    public weak var stateDelegate: StateabelDelegate?
    /// delegate состояния
    public weak var stateDataSource: StateabelDataSource?

    /// delegate tableView
    public override var dataSource: UITableViewDataSource? {
        willSet {
            stateDataSource = newValue as? DataSource
        }
    }

    /// delegate tableView
    public override var delegate: UITableViewDelegate? {
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
