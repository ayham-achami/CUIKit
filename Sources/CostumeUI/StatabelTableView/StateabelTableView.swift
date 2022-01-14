//
//  StateabelTableView.swift
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

/// `UITableView` с поддержкой логику состояния
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
