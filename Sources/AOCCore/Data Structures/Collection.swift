//
//  Collection.swift
//  AOC
//
//  Created by Dave DeLong on 12/1/18.
//  Copyright © 2018 Dave DeLong. All rights reserved.
//

import Foundation

public extension Collection {
    
    var isNotEmpty: Bool { return isEmpty == false }
    
    func removingFirst(while matches: (Element) -> Bool) -> SubSequence {
        var index = startIndex
        while index < endIndex && matches(self[index]) {
            index = self.index(after: index)
        }
        return self[index...]
    }
    
    func combinations(choose k: Int? = nil) -> AnySequence<[Element]> {
        guard isNotEmpty else { return AnySequence([]) }
        
        if let k = k {
            return AnySequence(self.combinations(ofCount: k))
        } else {
            var s = AnySequence(self.combinations(ofCount: 1))
            if count >= 2 {
                for count in 2 ... self.count {
                    let combo = self.combinations(ofCount: count)
                    s = AnySequence(chain(s, combo))
                }
            }
            return s
        }
    }
    
    func partition(by goesInFirst: (Element) -> Bool) -> (Array<Element>, Array<Element>) {
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
    
    func count(where predicate: (Element) -> Bool) -> Int {
        var c = 0
        for item in self {
            if predicate(item) {
                c += 1
            }
        }
        return c
    }
    
    func groupedBy<T: Hashable>(_ keyer: (Element) -> T?) -> Dictionary<T, Array<Element>> {
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
    
    func keyedBy<T: Hashable>(_ keyer: (Element) -> T?) -> Dictionary<T, Element> {
        var d = Dictionary<T, Element>()
        for item in self {
            if let key = keyer(item) {
                d[key] = item
            }
        }
        return d
    }
    
    func any(satisfy: (Element) -> Bool) -> Bool {
        return contains(where: satisfy)
    }
    
    func pairs() -> Array<Pair<Element>> {
        var p = Array<Pair<Element>>()
        var i = makeIterator()
        while let a = i.next(), let b = i.next() {
            p.append(Pair(a, b))
        }
        return p
    }
    
    func triples() -> Array<(Element, Element, Element)> {
        let a = self
        let b = self.dropFirst()
        let ab = zip(a, b)
        
        let c = self.dropFirst(2)
        let abc = zip(ab, c)
        return abc.map { ($0.0, $0.1, $1) }
    }
    
    func split(on isBoundary: (Element) -> Bool, includeEmpty: Bool = true) -> Array<SubSequence> {
        return split(omittingEmptySubsequences: !includeEmpty, whereSeparator: isBoundary)
    }
    
    func partition(where matches: (Element) -> Bool) -> Array<SubSequence> {
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
    
    func consecutivePairs() -> Array<(Element, Element)> {
        return Array(zip(self, dropFirst()))
    }
    
}

public extension Sequence where Element: Numeric {
    
    var sum: Element {
        return reduce(0, +)
    }
    
    var product: Element {
        return reduce(1, *)
    }
    
}

public extension Collection where Element: BinaryInteger {
    
    var average: Double {
        guard count > 0 else { return .nan }
        return Double(sum) / Double(count)
    }
    
}

public extension Sequence {
    
    func sum<N: Numeric>(of element: (Element) -> N) -> N {
        var f: N = 0
        for i in self {
            f += element(i)
        }
        return f
    }
    
    func product<N: Numeric>(of element: (Element) -> N) -> N {
        var f: N = 1
        for i in self {
            f *= element(i)
        }
        return f
    }
    
    func min<N: Comparable>(of element: (Element) -> N) -> N {
        var final: N?
        for i in self {
            let v = element(i)
            if let m = final {
                final = Swift.min(m, v)
            } else {
                final = v
            }
        }
        return final!
    }
    
    func max<N: Comparable>(of element: (Element) -> N) -> N {
        var final: N?
        for i in self {
            let v = element(i)
            if let m = final {
                final = Swift.max(m, v)
            } else {
                final = v
            }
        }
        return final!
    }
    
    func range<N: Comparable>(of element: (Element) -> N) -> ClosedRange<N> {
        var r: ClosedRange<N>?
        
        for i in self {
            let value = element(i)
            if let range = r {
                if value < range.lowerBound { r = value ... range.upperBound }
                if value > range.upperBound { r = range.lowerBound ... value }
            } else {
                r = value ... value
            }
        }
        
        return r!
    }
}

public extension Collection where Element: Comparable {
    
    func extremes() -> (Element, Element) {
        var minElement = self[startIndex]
        var maxElement = self[startIndex]
        
        for element in dropFirst() {
            minElement = Swift.min(minElement, element)
            maxElement = Swift.max(maxElement, element)
        }
        
        return (minElement, maxElement)
    }
    
    func range() -> ClosedRange<Element> {
        let (min, max) = extremes()
        return min...max
    }
    
}

public extension Collection where Element: Equatable {
    
    func count(of element: Element) -> Int {
        return self.count(where: { $0 == element })
    }
    
    func consecutivelyEqualSubsequences() -> Array<SubSequence> {
        guard isNotEmpty else { return [] }
        
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
    
    func split<C: Collection>(on boundary: C) -> Array<SubSequence> where C.Element == Element {
        var final = Array<SubSequence>()
        
        var subStart = startIndex
        var subEnd = startIndex
        
        let b = Array(boundary)
        var boundaryIndex = b.startIndex
        for (index, element) in zip(indices, self) {
            
            if element == b[boundaryIndex] {
                boundaryIndex = b.index(after: boundaryIndex)
                if boundaryIndex == b.endIndex {
                    final.append(self[subStart...subEnd])
                    boundaryIndex = b.startIndex
                    subStart = self.index(after: index)
                    subEnd = subStart
                }
            } else {
                subEnd = index
                boundaryIndex = b.startIndex
            }
            
        }
        
        if subStart < endIndex {
            final.append(self[subStart...])
        }
        
        return final
    }
}

public extension Collection where Element: Hashable {
    
    func countElements() -> CountedSet<Element> {
        return CountedSet(counting: self)
    }
    
    func mappingTo<T>(_ value: (Element) -> T) -> Dictionary<Element, T> {
        var final = Dictionary<Element, T>()
        for item in self {
            final[item] = value(item)
        }
        return final
    }
    
}

public extension Collection where Element: Collection {
    
    func flatten() -> Array<Element.Element> {
        flatMap { $0 }
    }
}

public extension BidirectionalCollection {
    
    func removingLast(while matches: (Element) -> Bool) -> SubSequence {
        var index = self.index(before: endIndex)
        while index >= startIndex && matches(self[index]) {
            index = self.index(before: index)
        }
        return self[...index]
    }
    
    func trimming(_ matches: (Element) -> Bool) -> SubSequence {
        return removingFirst(while: matches).removingLast(while: matches)
    }
}

public enum RoundingDirection {
    case up
    case down
}

public extension RandomAccessCollection {
    
    func at(_ index: Index) -> Element? {
        if index < startIndex || index >= endIndex { return nil }
        return self[index]
    }
    
    
    func chunks(of size: Int) -> ChunkedCollection<Self> {
        return ChunkedCollection(self, size: size)
    }
    
    func median(rounding direction: RoundingDirection = .down) -> Element {
        let span = Double(distance(from: startIndex, to: endIndex))
        let half = span / 2
        let medianDistance: Int
        switch direction {
            case .up: medianDistance = Int(ceil(half))
            case .down: medianDistance = Int(floor(half))
        }
        let medianIndex = index(startIndex, offsetBy: medianDistance)
        return self[medianIndex]
    }
    
}

public extension RandomAccessCollection where Element: RandomAccessCollection {
    
    subscript(vertical index: Element.Index) -> LazyMapCollection<Self, Element.Element> {
        return lazy.map { $0[index] }
    }
}

public extension Array {
    
    init(count: Int, elementProducer: () -> Element) {
        self.init()
        self.reserveCapacity(count)
        for _ in 0 ..< count {
            self.append(elementProducer())
        }
    }
    
    mutating func pluck<C: Collection>(_ indices: C) -> Array<Element> where C.Element == Index {
        let sorted = indices.sorted(by: >)
        var final = Array<Element>()
        for index in sorted {
            final.append(self.remove(at: index))
        }
        return final
    }
    
    mutating func popFirst() -> Element? {
        if isEmpty { return nil }
        return removeFirst()
    }
    
}

extension ArraySlice {
    
    public mutating func popFirst() -> Element {
        return removeFirst()
    }
    
    public mutating func popFirst(_ k: Int) -> Array<Element> {
        var a = Array<Element>()
        while a.count < k {
            a.append(popFirst())
        }
        return a
    }
    
}

public extension MutableCollection {
    
    mutating func mapInPlace(_ mapper: (Element) -> Element) {
        var index = startIndex
        while index != endIndex {
            self[index] = mapper(self[index])
            index = self.index(after: index)
        }
    }
}


public struct ChunkedCollection<Base: Collection>: Collection {
    private let base: Base
    private let chunkSize: Int
    
    public init(_ base: Base, size: Int) {
        self.base = base
        chunkSize = size
    }
    
    public typealias Index = Base.Index
    
    public var startIndex: Index {
        return base.startIndex
    }
    
    public var endIndex: Index {
        return base.endIndex
    }
    
    public func index(after index: Index) -> Index {
        return base.index(index, offsetBy: chunkSize, limitedBy: base.endIndex) ?? base.endIndex
    }
    
    public subscript(index: Index) -> Base.SubSequence {
        return base[index..<self.index(after: index)]
    }
}
