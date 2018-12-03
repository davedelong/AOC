//
//  Collection.swift
//  AOC
//
//  Created by Dave DeLong on 12/1/18.
//  Copyright © 2018 Dave DeLong. All rights reserved.
//

import Foundation

public extension Collection {
    
    public func partition(by goesInFirst: (Element) -> Bool) -> (Array<Element>, Array<Element>) {
        var first = Array<Element>()
        var second = Array<Element>()
        for item in self {
            if goesInFirst(item) {
                first.append(item)
            } else {
                second.append(item)
            }
        }
        return (first, second)
    }
    
    public func count(where predicate: (Element) -> Bool) -> Int {
        var c = 0
        for item in self {
            if predicate(item) {
                c += 1
            }
        }
        return c
    }
    
}

public extension Collection where Element: Numeric {
    
    public func sum() -> Element {
        var s = Element.init(exactly: 0)!
        for item in self {
            s += item
        }
        return s
    }
    
}

public extension Collection where Element: Hashable {
    
    public func countElements() -> CountedSet<Element> {
        return CountedSet(counting: self)
    }
    
}
