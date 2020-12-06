//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/6/20.
//

import Foundation

public struct Predicate<Value> {
    
    public static func && (lhs: Predicate<Value>, rhs: Predicate<Value>) -> Predicate<Value> {
        Predicate { value in lhs(value) && rhs(value) }
    }

    public static func || (lhs: Predicate<Value>, rhs: Predicate<Value>) -> Predicate<Value> {
        Predicate { value in lhs(value) || rhs(value) }
    }

    private let predicate: (Value) -> Bool
    
    public init(_ predicate: @escaping (Value) -> Bool) {
        self.predicate = predicate
    }

    public func callAsFunction(_ value: Value) -> Bool {
        predicate(value)
    }
}

extension Predicate where Value: StringProtocol {

    public static func hasPrefix(_ prefix: String) -> Predicate {
        Predicate { $0.hasPrefix(prefix) }
    }

    public static func matches(_ pattern: Regex) -> Predicate {
        return Predicate(pattern.matches)
    }
}

extension Predicate {

    public static func isWithin<Range: RangeExpression>(_ range: Range) -> Predicate where Range.Bound == Value {
        Predicate(range.contains)
    }
}

extension Predicate where Value: Equatable {

    public static func `is`(_ value: Value) -> Predicate {
        Predicate { $0 == value }
    }

    public static func isWithin(_ values: Value...) -> Predicate {
        Predicate(values.contains)
    }
}
