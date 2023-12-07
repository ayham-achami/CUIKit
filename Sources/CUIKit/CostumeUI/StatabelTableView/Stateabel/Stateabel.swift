//
//  Stateabel.swift
//

import UIKit

/// источник данных состояния
public protocol StateabelDataSource: AnyObject {

    /// вызывается при запросе состояния если возвращать nil то, StateView будет удален
    /// - Parameter stateabelView: объект создающий запрос
    func state<StateabelView>(for stateabelView: StateabelView) -> ViewState? where StateabelView: Stateabel

    /// вызывается при запросе индикатор загрузки, по умолчанию используется `UIActivityIndicatorView`
    /// - Parameter stateabelView: объект создающий запрос
    func loadingView<StateabelView>(for stateabelView: StateabelView) -> ActivityView where StateabelView: Stateabel
}

// MARK: - StateabelDataSource + Default
public extension StateabelDataSource {

    func loadingView<StateabelView>(for stateabelView: StateabelView) -> ActivityView where StateabelView: Stateabel {
        UIActivityIndicatorView(style: .medium)
    }
}

/// делегат состояния
public protocol StateabelDelegate: AnyObject {

    /// вызывается когда нужен tintColor для StateView
    /// - Parameter stateabelView: объект создающий запрос
    /// - Parameter case: текущий случае состояния
    func statetableView<StateabelView>(_ stateabelView: StateabelView, tintColorFor case: ViewState.Case) -> UIColor where StateabelView: Stateabel

    /// вызывается при нажатии на кнопку текущего состояния
    /// - Parameter stateabelView: объект создающий запрос
    /// - Parameter case: текущий случае состояния
    func statetableView<StateabelView>(_ stateabelView: StateabelView, didPerformActionFor case: ViewState.Case) where StateabelView: Stateabel

    /// вызывается при нажатии на кнопку закрыть
    /// - Parameters:
    ///   - stateabelView: объект создающий запрос
    ///   - case: текущий случае состояния
    func closebaleStatetableView<StateabelView>(_ stateabelView: StateabelView, requestCloseFor case: ViewState.Case) where StateabelView: Stateabel
    
    /// вызывается при смене текущего состояния
    /// - Parameter stateabelView: объект создающий запрос
    /// - Parameter case: текущий случае состояния
    func statetableView<StateabelView>(_ stateabelView: StateabelView, didBecomeActiveFor case: ViewState.Case) where StateabelView: Stateabel
}

// MARK: - StateabelDelegate
public extension StateabelDelegate {

    func closebaleStatetableView<StateabelView>(_ stateabelView: StateabelView, requestCloseFor case: ViewState.Case) where StateabelView: Stateabel {}
    
    func statetableView<StateabelView>(_ stateabelView: StateabelView, didBecomeActiveFor case: ViewState.Case) where StateabelView: Stateabel {}
}

/// объект поддерживающий логику состояния
public protocol Stateabel {

    /// актована ли состояние
    var isState: Bool { get }

    /// вью состояние
    var stateView: StateView { get }

    /// источник данных состояния
    var stateDelegate: StateabelDelegate? { get }

    /// делегат состояния
    var stateDataSource: StateabelDataSource? { get }

    /// обновить состояние
    func reloadState()
}

// MARK: - Stateabel + UIScrollView & StateViewDelegate
public extension Stateabel where Self: UIScrollView & StateViewDelegate {

    var stateView: StateView {
        if let stateView = subviews.first(where: { $0 is StateView }) as? StateView {
            return stateView
        } else if let stateView = StateView.fabricateFromFrameworkBundle() {
            stateView.backgroundColor = backgroundColor
            stateView.delegate = self
            return stateView
        } else {
            preconditionFailure("Could't to create StateView")
        }
    }

    var isState: Bool {
        subviews.first(where: { $0 is StateView }) != nil
    }

    func reloadState() {
        guard let dataSource = stateDataSource, let state = dataSource.state(for: self) else {
            UIView.animate(withDuration: 0.5, animations: {
                self.stateView.alpha = 0
            }, completion: { _ in
                self.stateView.removeFromSuperview()
            })
            isScrollEnabled = true
            return
        }
        stateView.frame = bounds
        stateView.alpha = 0
        stateView.attach(to: self)
        if let delegate = stateDelegate {
            stateView.tintColor = delegate.statetableView(self, tintColorFor: state.case)
        }
        stateView.update(with: state, activityView: dataSource.loadingView(for: self))
        stateDelegate?.statetableView(self, didBecomeActiveFor: state.case)
        UIView.animate(withDuration: 0.5) { self.stateView.alpha = 1 }
        isScrollEnabled = false
    }
}

// MARK: - Stateabel + UIViewController & StateViewDelegate
public extension Stateabel where Self: UIViewController & StateViewDelegate {

    var stateView: StateView {
        if let stateView = view.subviews.first(where: { $0 is StateView }) as? StateView {
            return stateView
        } else if let stateView = StateView.fabricateFromFrameworkBundle() {
            stateView.backgroundColor = view.backgroundColor
            stateView.delegate = self
            return stateView
        } else {
            preconditionFailure("Could't to create StateView")
        }
    }

    var isState: Bool {
        view.subviews.first(where: { $0 is StateView }) != nil
    }

    func reloadState() {
        guard let dataSource = stateDataSource, let state = dataSource.state(for: self) else {
            UIView.animate(withDuration: 0.5, animations: {
                self.stateView.alpha = 0
            }, completion: { _ in
                self.stateView.removeFromSuperview()
            })
            return
        }
        stateView.frame = view.bounds
        stateView.alpha = 0
        stateView.attach(to: view)
        view.bringSubviewToFront(stateView)
        if let delegate = stateDelegate {
            stateView.tintColor = delegate.statetableView(self, tintColorFor: state.case)
        }
        stateView.update(with: state, activityView: dataSource.loadingView(for: self))
        stateDelegate?.statetableView(self, didBecomeActiveFor: state.case)
        UIView.animate(withDuration: 0.5) { self.stateView.alpha = 1 }
    }
}

// MARK: - Stateabel + UIViewController & StateabelDelegate
public extension Stateabel where Self: UIViewController & StateabelDelegate {

    var stateDelegate: StateabelDelegate? { self }
}

// MARK: Stateabel + UIViewController & StateabelDataSource
public extension Stateabel where Self: UIViewController & StateabelDataSource {

    var stateDataSource: StateabelDataSource? { self }
}

// MARK: - StateViewDelegate + Stateabel
public extension StateViewDelegate where Self: Stateabel {

    func stateView(_ stateView: StateView, didTapActionFor case: ViewState.Case) {
        stateDelegate?.statetableView(self, didPerformActionFor: `case`)
    }

    func stateView(_ stateView: StateView, didTapCloseFor case: ViewState.Case) {
        stateDelegate?.closebaleStatetableView(self, requestCloseFor: `case`)
    }
}
