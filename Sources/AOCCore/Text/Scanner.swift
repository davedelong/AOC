//
//  File.swift
//  
//
//  Created by Dave DeLong on 11/30/22.
//

import Foundation

public struct Scanner<C: Collection> {
    
    private let data: C
    private var current: C.Index
    
    public var location: C.Index { current }
    public var isAtEnd: Bool { location >= data.endIndex }
    
    public init(data: C) {
        self.data = data
        self.current = data.startIndex
    }
    
    @discardableResult
    public mutating func scanElement() -> C.Element? {
        if isAtEnd { return nil }
        let element = data[current]
        current = data.index(after: current)
        return element
    }
    
    public mutating func scan(while matches: (C.Element) -> Bool) -> C.SubSequence {
        let start = current
        while isAtEnd == false && matches(data[current]) {
            current = data.index(after: current)
        }
        return data[start ..< current]
    }
    
    public mutating func scan(count: Int) -> C.SubSequence {
        let start = current
        current = data.index(current, offsetBy: count, limitedBy: data.endIndex) ?? data.endIndex
        return data[start ..< current]
    }
    
}

extension Scanner where C.Element: Equatable {
    
    public mutating func scan(_ element: C.Element) {
        if isAtEnd { fatalError("Cannot scan for \(element) because scanner is at end") }
        if data[current] != element {
            fatalError("Next element is \(data[current]), not \(element)")
        }
        current = data.index(after: current)
    }
    
    public mutating func scan<O: Collection>(_ other: O) where O.Element == C.Element {
        if isAtEnd { fatalError("Cannot scan for \(other) because scanner is at end") }
        for element in other { scan(element) }
    }
    
    @discardableResult
    public mutating func tryScan(_ element: C.Element) -> Bool {
        let start = current
        if scanElement() == element { return true }
        current = start
        return false
    }
    
    @discardableResult
    public mutating func tryScan<O: Collection>(_ other: O) -> Bool where O.Element == C.Element {
        let start = current
        var iterator = other.makeIterator()
        while let next = iterator.next() {
            if scanElement() != next {
                current = start
                return false
            }
        }
        return true
    }
    
    @discardableResult
    public mutating func scanUpTo(_ element: C.Element) -> C.SubSequence {
        let start = current
        while current < data.endIndex {
            if data[current] == element { break }
            current = data.index(after: current)
        }
        
        return data[start ..< current]
    }
    
    @discardableResult
    public mutating func scanUpTo<O: Collection>(_ other: O) -> C.SubSequence where O.Element == C.Element {
        assert(other.isNotEmpty)
        let base = other.makeIterator()
        
        let originalStart = current
        
        while isAtEnd == false {
            var otherIterator = base
            
            let first = otherIterator.next()!
            scanUpTo(first)
            if isAtEnd { break }
            
            // we found the start of a potential sequence
            
            let sequenceStart = current
            
            var matchedEverything = tryScan(first)
            while matchedEverything == true, let next = otherIterator.next() {
                let proposed = self.scanElement()
                if proposed != next {
                    matchedEverything = false
                    break
                }
            }
            
            if matchedEverything {
                current = sequenceStart
                break
            } else if isAtEnd == false {
                current = data.index(after: sequenceStart)
            }
        }
        
        return data[originalStart ..< current]
    }
    
}

extension Scanner where C.Element == Character {
    
    public mutating func scanInt() -> Int? {
        let digits = self.scan(while: \.isNumber)
        return Int(String(digits))
    }
    
}
