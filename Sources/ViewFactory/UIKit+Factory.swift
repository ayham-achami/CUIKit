//
//  UIKit+ Factory.swift
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

// MARK: - UITableView + CellFactory
public extension UITableView {

    /// возвращает повторно используемый объект ячейки табличного представления
    /// для указанного индикса, и добавляет его в таблицу.
    ///
    /// - Parameters:
    ///   - factory: фабрика ячейки (объект содержащий бизнес логику заполнения ячейки)
    ///   - indexPath: индекс пасс, указывающий местоположение ячейки
    /// - Returns: готовую ячейку для отображения в таблицу
    func dequeueReusableCell(with factory: AnyCellFactory, for indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: factory.identifier, for: indexPath)
        factory.setup(cell)
        return cell
    }

    /// возвращает повторно используемый объект ячейки табличного представления
    /// для указанного индикса, и добавляет его в таблицу.
    ///
    /// - Parameter factory: фабрика создание разных тепов ячейк
    /// - Parameter indexPath: индекс пасс, указывающий местоположение ячейки
    func dequeueReusableCell(with factory: MultiCellTypeFactory, for indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: factory.identifier, for: indexPath)
        factory.setup(cell)
        return cell
    }

    /// возвращает повторно используемый объект заголовок/нижний колонтитул
    /// табличного представления и добавляет его в таблицу.
    ///
    /// note:
    ///     используя идентификатор вью вместе индекс пасс
    ///
    /// - Parameter factory: фабрика ячейки (объект содержащий бизнес логику заполнения ячейки)
    /// - Returns: объект со связанным идентификатором или nil, если на повторное использование такого объекта не существует.
    func dequeueReusableHeaderFooterView(with factory: AnyViewFactory) -> UITableViewHeaderFooterView? {
        let identifier = String(describing: type(of: factory).wrappedViewType)
        guard let header = dequeueReusableHeaderFooterView(withIdentifier: identifier) else { return nil }
        factory.setup(header)
        return header
    }

    /// регистрирует объект фабрики, содержащий бизнес логику заполнения
    /// ячейки. и под идентификатором совпадает с названием ячейки.
    ///
    /// - Parameters:
    ///   - factory: фабрика ячейки (объект содержащий бизнес логику заполнения ячейки)
    ///   - bundle: представление ресурсов, хранящихся на диске.
    func register(factory: AnyCellFactory.Type, bundle: Bundle? = nil) {
        let viewName = String(describing: factory.wrappedViewType)
        let nib = UINib(nibName: viewName, bundle: bundle)
        register(nib, forCellReuseIdentifier: viewName)
    }

    /// регистрирует объект фабрики, содержащий бизнес логику заполнения
    /// ячейки. и под идентификатором совпадает с названием ячейки.
    ///
    /// - Parameters:
    ///   - factory: массив фабрик ячейки (объект содержащий бизнес логику заполнения ячейки)
    ///   - bundle: представление ресурсов, хранящихся на диске.
    func register(factories: [AnyCellFactory.Type], bundle: Bundle? = nil) {
        factories.forEach { register(factory: $0, bundle: bundle) }
    }

    /// регистрирует объект фабрики, содержащий бизнес логику заполнения
    /// ячейки. и под идентификатором совпадает с названием ячейки.
    ///
    /// - Parameter factory: фабрика создание разных тепов ячейк
    /// - Parameter bundle: представление ресурсов, хранящихся на диске.
    func register(factory: MultiCellTypeFactory.Type, bundle: Bundle? = nil) {
         factory.factories.values.forEach { register(factory: $0, bundle: bundle) }
     }

    /// регистрирует объект фабрики заголовок/нижний колонтитул, содержащий бизнес логику заполнения
    /// заголовок/нижний колонтитул. и под идентификатором совпадает с названием заголовок/нижний колонтитул.
    ///
    /// - Parameter factory: фабрика вью
    func registerHeaderFooter(factory: AnyViewFactory.Type) {
        registerHeaderFooter(factory: factory, bundle: nil)
    }

    /// регистрирует объекты фабрик заголовок/нижний колонтитул, содержащий бизнес логику заполнения
    /// заголовок/нижний колонтитул. и под идентификатором совпадает с названием заголовок/нижний колонтитул.
    ///
    /// - Parameter factories: массив фабрик ячейки (объект содержащий бизнес логику заполнения ячейки)
    func registerHeaderFooter(factories: [AnyViewFactory.Type]) {
        registerHeaderFooter(factories: factories, bundle: nil)
    }

    /// регистрирует объект фабрики заголовок/нижний колонтитул, содержащий бизнес логику заполнения
    /// заголовок/нижний колонтитул. и под идентификатором совпадает с названием заголовок/нижний колонтитул.
    ///
    /// - Parameters:
    ///   - factory: фабрика вью
    ///   - bundle: представление ресурсов, хранящихся на диске.
    func registerHeaderFooter(factory: AnyViewFactory.Type, bundle: Bundle?) {
        let id = String(describing: factory.wrappedViewType)
        let nib = UINib(nibName: id, bundle: bundle)
        register(nib, forHeaderFooterViewReuseIdentifier: id)
    }

    /// регистрирует объекты фабрик заголовков/нижний колонтитулов, содержащий бизнес логику заполнения
    /// заголовок/нижний колонтитул. и под идентификатором совпадает с названием заголовок/нижний колонтитул.
    ///
    /// - Parameters:
    ///   - factories: массив фабрик вью
    ///   - bundle: представление ресурсов, хранящихся на диске.
    func registerHeaderFooter(factories: [AnyViewFactory.Type], bundle: Bundle?) {
        factories.forEach { registerHeaderFooter(factory: $0, bundle: bundle) }
    }
}

// MARK: - UICollectionView + CellFactory
public extension UICollectionView {

    /// возвращает многократно используемый объект ячейки, расположенный по его идентификатору
    ///
    /// - Parameters:
    ///   - factory: фабрика ячейки (объект содержащий бизнес логику заполнения ячейки)
    ///   - indexPath: indexpath, указывающий местоположение ячейки
    /// - Returns: готовую ячейку для отображения
    func dequeueReusableCell(with factory: AnyCellFactory, for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: factory.identifier, for: indexPath)
        factory.setup(cell)
        return cell
    }

    /// возвращает многократно используемый объект ячейки, расположенный по его идентификатору
    ///
    /// - Parameter factory: фабрика создание разных тепов ячейк
    /// - Parameter indexPath: indexpath, указывающий местоположение ячейки
    func dequeueReusableCell(with factory: MultiCellTypeFactory, for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: factory.identifier, for: indexPath)
        factory.setup(cell)
        return cell
    }

    /// возвращает многократно используемый объект view, расположенный по его идентификатору
    ///
    /// - Parameters:
    ///   - factory: фабрика вью (объект содержащий бизнес логику заполнения вью)
    ///   - indexPath: indexpath, указывающий местоположение вью
    /// - Returns: готовую вью для отображения
    func dequeueReusableSupplementaryView(with factory: AnyReusableSupplementaryViewFactory,
                                          for indexPath: IndexPath) -> UICollectionReusableView {
        let view = dequeueReusableSupplementaryView(ofKind: type(of: factory).viewKind,
                                                    withReuseIdentifier: factory.reuseIdentifier,
                                                    for: indexPath)
        factory.setup(view)
        return view
    }

    /// регистрирует объект фабрики, содержащий бизнес логику заполнения
    /// ячейки. и под идентификатором совпадает с названием ячейки.
    ///
    /// - Parameters:
    ///   - factory: фабрика ячейки (объект содержащий бизнес логику заполнения ячейки)
    ///   - bundle: представление ресурсов, хранящихся на диске.
    func register(factory: AnyCellFactory.Type, bundle: Bundle? = nil) {
        let viewName = String(describing: factory.wrappedViewType)
        let nib = UINib(nibName: viewName, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: viewName)
    }

    /// регистрирует объеки фабрики, содержащий бизнес логику заполнения
    /// ячейки. и под идентификатором совпадает с названием ячейки.
    ///
    /// - Parameters:
    ///   - factories: массив фабрик ячейки (объект содержащий бизнес логику заполнения ячейки)
    ///   - bundle: представление ресурсов, хранящихся на диске.
    func register(factories: [AnyCellFactory.Type], bundle: Bundle? = nil) {
        factories.forEach { register(factory: $0, bundle: bundle) }
    }

    /// регистрирует объеки фабрики, содержащий бизнес логику заполнения
    /// ячейки. и под идентификатором совпадает с названием ячейки.
    ///
    /// - Parameter factory: фабрика создание разных тепов ячейк
    /// - Parameter bundle: представление ресурсов, хранящихся на диске.
    func register(factory: MultiCellTypeFactory.Type, bundle: Bundle? = nil) {
        factory.factories.values.forEach { register(factory: $0, bundle: bundle) }
    }

    /// регистрирует объект фабрики для использования при создании дополнительных представлений
    ///
    /// - Parameters:
    ///   - factory: фабрика ячейки (объект содержащий бизнес логику заполнения ячейки)
    ///   - elementKind: вид дополнительного представления для создания.
    func register(factory: AnyViewFactory.Type, forSupplementaryViewOfKind elementKind: String, bundle: Bundle? = nil) {
        let viewName = String(describing: factory.wrappedViewType)
        let nib = UINib(nibName: viewName, bundle: bundle)
        register(nib, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: viewName)
    }
}
