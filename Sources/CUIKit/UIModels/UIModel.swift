//
//  UIModel.swift
//

import Foundation

/// Основой протокол любого объекта UI модели
public protocol UIModel {}

// MARK: - Bool + UIModel
extension Bool: UIModel {}

// MARK: - Int + UIModel
extension Int: UIModel {}

// MARK: - Double + UIModel
extension Double: UIModel {}

// MARK: - Float + UIModel
extension Float: UIModel {}

// MARK: - String + UIModel
extension String: UIModel {}

// MARK: - Set + UIModel
extension Set: UIModel {}

// MARK: - Array + UIModel
extension Array: UIModel {}

// MARK: - Dictionary + UIModel
extension Dictionary: UIModel {}
