//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/6/20.
//

import Foundation

@dynamicMemberLookup
public struct Validator<Value> {

    public init() {
        self.predicate = Predicate { _ in true }
    }

    fileprivate let predicate: Predicate<Value>
    fileprivate init(predicate: Predicate<Value>) {
        self.predicate = predicate
    }

    public func validate(_ value: Value) -> Bool {
        predicate(value)
    }

    public subscript<Property>(dynamicMember keyPath: KeyPath<Value, Property>) -> Builder<Value, Property> {
        Builder(base: self, keyPath: keyPath)
    }
}


@dynamicMemberLookup
public struct Builder<Base, Property> {

    fileprivate let base: Validator<Base>
    fileprivate let keyPath: KeyPath<Base, Property>

    public func callAsFunction(_ predicate: Predicate<Property>) -> Validator<Base> {
        let new = Predicate<Base> { predicate($0[keyPath: keyPath]) }
        return Validator(predicate: base.predicate && new)
    }

    public func callAsFunction(_ predicate: @escaping (Property) -> Bool) -> Validator<Base> {
        let new = Predicate<Base> { predicate($0[keyPath: keyPath]) }
        return Validator(predicate: base.predicate && new)
    }

    public subscript<Other>(dynamicMember keyPath2: KeyPath<Property, Other>) -> Builder<Base, Other> {
        Builder<Base, Other>(base: base,
                             keyPath: keyPath.appending(path: keyPath2))
    }
}
    
extension Builder where Property: Equatable {
    
    public static func == (lhs: Builder<Base, Property>, rhs: Property) -> Validator<Base> {
        return lhs({ $0 == rhs })
    }
    
    public static func != (lhs: Builder<Base, Property>, rhs: Property) -> Validator<Base> {
        return lhs({ $0 != rhs })
    }
    
    
    public static func ~= <C: Collection> (lhs: Builder<Base, Property>, rhs: C) -> Validator<Base> where C.Element == Property {
        return lhs({ rhs.contains($0) })
    }
    
}

extension Builder where Property: Comparable {
    
    public static func < (lhs: Builder<Base, Property>, rhs: Property) -> Validator<Base> {
        return lhs({ $0 < rhs })
    }
    
    public static func <= (lhs: Builder<Base, Property>, rhs: Property) -> Validator<Base> {
        return lhs({ $0 <= rhs })
    }
    
    public static func > (lhs: Builder<Base, Property>, rhs: Property) -> Validator<Base> {
        return lhs({ $0 > rhs })
    }
    
    public static func >= (lhs: Builder<Base, Property>, rhs: Property) -> Validator<Base> {
        return lhs({ $0 >= rhs })
    }
    
    public static func ~= <R: RangeExpression> (lhs: Builder<Base, Property>, rhs: R) -> Validator<Base> where R.Bound == Property {
        return lhs({ rhs ~= $0 })
    }
    
}

extension Builder where Property: StringProtocol {
    
    public static func ~= (lhs: Builder<Base, Property>, rhs: Regex) -> Validator<Base> {
        return lhs({ rhs.matches($0) })
    }
    
}
