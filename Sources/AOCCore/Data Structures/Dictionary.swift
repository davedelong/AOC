//
//  Dictionary.swift
//  AOC
//
//  Created by Dave DeLong on 12/2/18.
//  Copyright © 2018 Dave DeLong. All rights reserved.
//

import Foundation

public typealias Bucket<K: Hashable, V: Hashable> = Dictionary<K, Set<V>>

public func Bucketize<C1: Collection, C2: Collection>(_ elements: C1, in keys: (C1.Element) -> C2) -> Bucket<C2.Element, C1.Element>
    where C1.Element: Hashable, C2.Element: Hashable
{
    
    var b = Bucket<C2.Element, C1.Element>()
    
    for element in elements {
        let bucketKeys = keys(element)
        for key in bucketKeys {
            var bucketContents = b.removeValue(forKey: key) ?? Set()
            bucketContents.insert(element)
            b[key] = bucketContents
        }
    }
    
    return b
}

public extension Dictionary {
    
    @discardableResult
    mutating func removeValues<C: Collection>(forKeys keysToRemove: C) -> Dictionary<Key, Value> where C.Element == Key {
        var final = Dictionary<Key, Value>()
        for key in keysToRemove {
            if let value = removeValue(forKey: key) {
                final[key] = value
            }
        }
        return final
    }
    
    mutating func removeKeys(where predicate: (Key) -> Bool) {
        for key in keys {
            if predicate(key) == true {
                removeValue(forKey: key)
            }
        }
    }
    
    func map<NewKey: Hashable, NewValue>(_ mapper: (Element) -> (NewKey, NewValue)) -> Dictionary<NewKey, NewValue> {
        var final = Dictionary<NewKey, NewValue>()
        for item in self {
            let (k, v) = mapper(item)
            final[k] = v
        }
        return final
    }
    
    subscript(key: Key, inserting value: @autoclosure () -> Value) -> Value {
        mutating get {
            if let e = self[key] { return e }
            let newValue = value()
            self[key] = newValue
            return newValue
        }
    }
    
}
