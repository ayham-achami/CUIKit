//
//  NonNegativeFloat.swift
//

import Foundation

@propertyWrapper
struct NonNegativeFloat<T: FloatingPoint> {

    private var number: T
    
    var wrappedValue: T {
        get {
            number
        }
        set {
            number = max(newValue, 0)
        }
    }
    
    init() {
        self.number = 0
    }
}
