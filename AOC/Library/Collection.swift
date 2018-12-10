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
    
    public func groupedBy<T: Hashable>(_ keyer: (Element) -> T?) -> Dictionary<T, Array<Element>> {
        var d = Dictionary<T, Array<Element>>()
        for item in self {
            if let key = keyer(item) {
                var items = d.removeValue(forKey: key) ?? []
                items.append(item)
                d[key] = items
            }
        }
        return d
    }
    
    public func keyedBy<T: Hashable>(_ keyer: (Element) -> T?) -> Dictionary<T, Element> {
        var d = Dictionary<T, Element>()
        for item in self {
            if let key = keyer(item) {
                d[key] = item
            }
        }
        return d
    }
    
    public func any(satisfy: (Element) -> Bool) -> Bool {
        for item in self {
            if satisfy(item) == true { return true }
        }
        return false
    }
    
    public func pairs() -> Array<Pair<Element>> {
        var p = Array<Pair<Element>>()
        var i = makeIterator()
        while let a = i.next(), let b = i.next() {
            p.append(Pair(a, b))
        }
        return p
    }
    
    public func triples() -> Array<(Element, Element, Element)> {
        let a = self
        let b = self.dropFirst()
        let ab = zip(a, b)
        
        let c = self.dropFirst(2)
        let abc = zip(ab, c)
        return abc.map { ($0.0, $0.1, $1) }
    }
    
    public func partition(where matches: (Element) -> Bool) -> Array<SubSequence> {
        var final = Array<SubSequence>()
        var rangeStart = startIndex
        var current = index(after: startIndex)
        while current < endIndex {
            let element = self[current]
            if matches(element) {
                final.append(self[rangeStart ..< current])
                rangeStart = current
            }
            current = index(after: current)
        }
        if rangeStart < endIndex {
            final.append(self[rangeStart..<endIndex])
        }
        return final
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
    
    public func product() -> Element {
        var s = Element.init(exactly: 1)!
        for item in self {
            s *= item
        }
        return s
    }
    
}

public extension Collection where Element: Comparable {
    
    public func extremes() -> (Element, Element) {
        var minElement = self[startIndex]
        var maxElement = self[startIndex]
        
        for element in dropFirst() {
            minElement = Swift.min(minElement, element)
            maxElement = Swift.max(maxElement, element)
        }
        
        return (minElement, maxElement)
    }
    
}

public extension Collection where Element: Equatable {
    
    public func consecutivelyEqualSubsequences() -> Array<SubSequence> {
        guard isEmpty == false else { return [] }
        
        var rangeStart = startIndex
        var rangeItem = self[startIndex]
        var index = self.index(after: startIndex)
        
        var subSequences = Array<SubSequence>()
        while index < endIndex {
            let item = self[index]
            
            if item != rangeItem {
                subSequences.append(self[rangeStart..<index])
                rangeStart = index
                rangeItem = item
            }
            
            index = self.index(after: index)
        }
        subSequences.append(self[rangeStart..<endIndex])
        
        return subSequences
    }
    
}

public extension Collection where Element: Hashable {
    
    public func countElements() -> CountedSet<Element> {
        return CountedSet(counting: self)
    }
    
    public func mappingTo<T>(_ value: (Element) -> T) -> Dictionary<Element, T> {
        var final = Dictionary<Element, T>()
        for item in self {
            final[item] = value(item)
        }
        return final
    }
    
}

public extension RandomAccessCollection {
    
    public func at(_ index: Index) -> Element? {
        if index < startIndex || index >= endIndex { return nil }
        return self[index]
    }
    
}

public extension Array {
    
    public init(count: Int, elementProducer: () -> Element) {
        self.init()
        self.reserveCapacity(count)
        for _ in 0 ..< count {
            self.append(elementProducer())
        }
    }
    
}
