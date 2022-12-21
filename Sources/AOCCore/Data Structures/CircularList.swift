//
//  File.swift
//  
//
//  Created by Dave DeLong on 10/13/22.
//

import Foundation

public struct CircularList<Element> {
    
    private var _storage: _CircularStorage<Element>
    
    public var count: Int { _storage.count }
    public var isEmpty: Bool { _storage.isEmpty }
    
    public init() {
        _storage = _CircularStorage()
    }
    
    @_disfavoredOverload
    public init(_ values: Element...) {
        self.init(values)
    }
    
    public init<C: Collection>(_ values: C) where C.Element == Element {
        _storage = _CircularStorage()
        
        var afterIndex: _CircularStorage<Element>.Index?
        for value in values {
            afterIndex = _storage.add(value, after: afterIndex)
        }
    }
    
}

extension CircularList: Equatable where Element: Equatable {
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        if lhs.isEmpty && rhs.isEmpty { return true }
        guard lhs.count == rhs.count else { return false }
        if lhs._storage === rhs._storage { return true }
        
        let lhsFirst = lhs[lhs.startIndex]
        let rhsIndices = rhs.indices(of: lhsFirst)
        guard rhsIndices.count > 0 else { return false } // rhs does not contain this element
        
        let lhsIterator = lhs.makeIterator(startingAt: lhs.startIndex)
        for potentialIndex in rhs.indices {
            let rhsIterator = rhs.makeIterator(startingAt: potentialIndex)
            if lhsIterator == rhsIterator { return true }
        }
        
        return false
    }
    
    public func indices(of element: Element) -> Array<Index> {
        return indices.compactMap { self[$0] == element ? $0 : nil }
    }
    
    public func nextIndex(of element: Element, startingAt index: Index? = nil, searchDirection: SearchDirection = .forward) -> Index? {
        return self.nextIndex(startingAt: index,
                              searchDirection: searchDirection,
                              matching: { $0 == element })
    }
    
}

extension CircularList: Sequence {
    public typealias Iterator = CircularListIterator<Element>
    public typealias Element = Element
    
    public func makeIterator() -> CircularListIterator<Element> {
        return makeIterator(startingAt: startIndex)
    }
    
    public func makeIterator(startingAt index: Index) -> CircularListIterator<Element> {
        return CircularListIterator(storage: _storage, start: index.idx)
    }
    
    public func elements() -> Array<Element> {
        return elements(startingAt: startIndex)
    }
    
    public func elements(startingAt index: Index) -> Array<Element> {
        if isEmpty { return [] }
        
        var all = Array<Element>()
        var current = index
        
        repeat {
            all.append(self[current])
            self.formIndex(after: &current)
        } while current != index
        
        return all
    }
    
}

// extension CircularList2: Collection {
extension CircularList {
    
    public enum SearchDirection: Hashable {
        case forward
        case backward
        
        internal var delta: Int {
            return self == .forward ? 1 : -1
        }
    }
    
    public struct Index: Hashable {
        public static func ==(lhs: Self, rhs: Self) -> Bool { lhs.idx == rhs.idx }
        fileprivate let idx: _CircularStorage<Element>.Index
    }
    
    public var startIndex: Index {
        if _storage.isEmpty { return Index(idx: _storage.nextIndex) }
        return Index(idx: _storage.startIndex)
    }
    
    public var indices: Array<Index> {
        if _storage.isEmpty { return [] }
        var a = Array<Index>()
        var idx = _storage.startIndex
        repeat {
            a.append(Index(idx: idx))
            idx = _storage.index(after: idx)!
        } while idx != _storage.startIndex
        
        return a
    }
    
    public subscript(position: Index) -> Element {
        get {
            guard let val = _storage.value(at: position.idx) else {
                fatalError("Unknown index \(position)")
            }
            return val
        }
        set {
            self.replaceValue(at: position, with: newValue)
        }
    }
    
    public func nextIndex(startingAt index: Index?, searchDirection: SearchDirection, matching predicate: (Element) -> Bool) -> Index? {
        let start = index ?? startIndex
        var current = start
        repeat {
            if predicate(self[current]) { return current }
            formIndex(&current, direction: searchDirection)
        } while current != start
        return nil
    }
    
    public func index(relativeTo i: Index, direction: SearchDirection) -> Index {
        guard let related = _storage.index(i.idx, offsetBy: direction.delta) else {
            fatalError("Unknown index \(i)")
        }
        return Index(idx: related)
    }
    
    public func index(_ i: Index, offsetBy distance: Int) -> Index {
        guard let offseted = _storage.index(i.idx, offsetBy: distance) else {
            fatalError("Unknown index \(i)")
        }
        return Index(idx: offseted)
    }
    
    public func index(before i: Index) -> Index {
        return index(relativeTo: i, direction: .backward)
    }
    
    public func index(after i: Index) -> Index {
        return index(relativeTo: i, direction: .forward)
    }
    
    public func index(_ i: Index, offsetBy distance: Int, limitedBy limit: Index) -> Index? {
        var copy = i
        if self.formIndex(&copy, offsetBy: distance, limitedBy: limit) {
            return copy
        }
        return nil
    }
    
    public func formIndex(_ i: inout Index, direction: SearchDirection) {
        self.formIndex(&i, offsetBy: direction.delta)
    }
    
    public func formIndex(_ i: inout Index, offsetBy distance: Int) {
        i = self.index(i, offsetBy: distance)
    }
    
    public func formIndex(after index: inout Index) {
        index = self.index(after: index)
    }
    
    public func formIndex(before index: inout Index) {
        index = self.index(before: index)
    }
    
    public func formIndex(_ i: inout Index, offsetBy distance: Int, limitedBy limit: Index) -> Bool {
        let delta = distance / Int(distance.magnitude) // either 1 or -1
        var times = distance.magnitude
        var hitLimit = false
        
        var current = i.idx
        repeat {
            guard let o = _storage.index(current, offsetBy: delta) else {
                fatalError("Unknown index \(i)")
            }
            current = o
            
            if current == limit.idx && times > 1 {
                // we're at the limit, but we would still need to apply the delta some more
                hitLimit = true
            }
            
            times -= 1
        } while times > 0 && hitLimit == false
        
        i = Index(idx: current)
        return hitLimit == false
    }
    
    @discardableResult
    public mutating func replaceValue(at index: Index, with value: Element) -> Element {
        if !isKnownUniquelyReferenced(&_storage) { _storage = _storage.duplicate() }
        return _storage.set(value, at: index.idx)
    }
    
    @discardableResult
    public mutating func insert(_ value: Element, before i: Index) -> Index {
        let prior = index(before: i)
        return insert(value, after: prior)
    }
    
    @discardableResult
    public mutating func insert(_ value: Element, after i: Index) -> Index {
        if !isKnownUniquelyReferenced(&_storage) { _storage = _storage.duplicate() }
        let idx = _storage.add(value, after: i.idx)
        return Index(idx: idx)
    }
    
    @discardableResult
    public mutating func removeValue(at index: Index) -> Element {
        if !isKnownUniquelyReferenced(&_storage) { _storage = _storage.duplicate() }
        return _storage.remove(at: index.idx)
    }
    
    public mutating func moveValue(at index: Index, before i: Index) {
        if !isKnownUniquelyReferenced(&_storage) { _storage = _storage.duplicate() }
        _storage.move(from: index.idx, before: i.idx)
    }
    
    public mutating func moveValue(at index: Index, after i: Index) {
        if !isKnownUniquelyReferenced(&_storage) { _storage = _storage.duplicate() }
        _storage.move(from: index.idx, after: i.idx)
    }
    
    public mutating func removeAllValues() {
        _storage = _CircularStorage()
    }
    
    public func dumpStorage() { _storage.dump() }
}

public struct CircularListIterator<Element>: IteratorProtocol {
    
    private let storage: _CircularStorage<Element>
    private let start: _CircularStorage<Element>.Index
    private var _next: _CircularStorage<Element>.Index?
    
    fileprivate init(storage: _CircularStorage<Element>, start: _CircularStorage<Element>.Index) {
        self.storage = storage
        self.start = start
        self._next = start
    }
    
    public mutating func next() -> Element? {
        if let idx = _next, let val = storage.value(at: idx) {
            let n = storage.index(after: idx)
            _next = (n == start) ? nil : n
            return val
        }
        return nil
    }
}

extension CircularListIterator: Equatable where Element: Equatable {
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        var lhsCopy = lhs
        var rhsCopy = rhs
        
        var l: Element?
        var r: Element?
        
        repeat {
            l = lhsCopy.next()
            r = rhsCopy.next()
            
            if l != r { return false }
        } while l != nil && r != nil
        
        return l == nil && r == nil
    }
    
}

private class _CircularStorage<T> {
    typealias Index = Int
    
    struct Node {
        var prev: Index
        var next: Index
        var value: T
    }
    
    var count: Int { nodes.count }
    var isEmpty: Bool { nodes.isEmpty }
    
    private var nodes = Dictionary<Index, Node>()
    private(set) var nextIndex = 1
    private(set) var startIndex = Index.max
    
    init() { }
    
    func duplicate() -> _CircularStorage<T> {
        let copy = _CircularStorage<T>()
        copy.nodes = self.nodes
        copy.nextIndex = self.nextIndex
        copy.startIndex = self.startIndex
        return copy
    }
    
    func dump() {
        print(nodes)
    }
    
    private func makeNextIndex() -> Index {
        defer { nextIndex += 1 }
        if startIndex == Int.max { startIndex = nextIndex }
        return nextIndex
    }
    
    func value(at index: Index) -> T? {
        return nodes[index]?.value
    }
    
    func index(after index: Index) -> Index? {
        return nodes[index]?.next
    }
    
    func index(before index: Index) -> Index? {
        return nodes[index]?.prev
    }
    
    func index(_ index: Index, offsetBy distance: Int) -> Index? {
        guard nodes[index] != nil else { return nil }
        if distance == 0 { return index }
        
        let moveNext = (distance >= 0)
        var magnitude = distance.magnitude
        if magnitude > nodes.count { magnitude %= UInt(nodes.count) }
        
        var current = index
        while magnitude > 0 {
            if moveNext {
                current = nodes[current]!.next
            } else {
                current = nodes[current]!.prev
            }
            magnitude -= 1
        }
        return current
    }
    
    @discardableResult
    func set(_ value: T, at idx: Index) -> T {
        defer { assertLinkIntegrity() }
        
        // if the storage is empty, assume this is the first thing,
        // and all indices should be after this one
        if nodes.isEmpty {
            nextIndex = idx
            startIndex = idx
            add(value, after: nil)
            return value
        } else if let old = nodes[idx]?.value {
            nodes[idx]?.value = value
            return old
        } else {
            fatalError("Unknown index \(idx)")
        }
    }
    
    @discardableResult
    func add(_ value: T, after index: Index?) -> Index {
        defer { assertLinkIntegrity() }
        
        if nodes.isEmpty {
            if let idx = index { fatalError("Unknown index \(idx)") }
            let thisIndex = makeNextIndex()
            nodes[thisIndex] = Node(prev: thisIndex, next: thisIndex, value: value)
            return thisIndex
        }
        
        let idx = index ?? nodes.keys.first!
        guard let nextIndex = nodes[idx]?.next else {
            fatalError("Unknown index \(idx)")
        }
        
        let newNode = Node(prev: idx, next: nextIndex, value: value)
        let thisIndex = makeNextIndex()
        nodes[thisIndex] = newNode
        nodes[idx]!.next = thisIndex
        nodes[nextIndex]!.prev = thisIndex
        return thisIndex
    }
    
    @discardableResult
    func remove(at index: Index) -> T {
        defer { assertLinkIntegrity() }
        
        guard let dead = nodes.removeValue(forKey: index) else {
            fatalError("Unknown index \(index)")
        }
        
        // if this was the last node, then these are no-ops
        nodes[dead.prev]?.next = dead.next
        nodes[dead.next]?.prev = dead.prev
        
        // if we removed the "start" node,
        // then the new start is the next node
        if index == startIndex { startIndex = dead.next }
        
        if nodes.isEmpty { startIndex = Int.max }
        
        return dead.value
    }
    
    func move(from src: Index, before dest: Index) {
        defer { assertLinkIntegrity() }
        
        guard let srcNode = nodes[src] else { fatalError("Unknown index \(src)") }
        guard let destNode = nodes[dest] else { fatalError("Unknown index \(dest)") }
        
        if src == dest {
            // move the node "one left"
            // FROM: a -> b -> SRC -> d
            // TO: a -> SRC -> b -> d
            
            let b = srcNode.prev
            let c = src
            let d = srcNode.next
            let a = nodes[b]!.prev
            
            nodes[a]?.next = c
            nodes[c]?.prev = a
            nodes[c]?.next = b
            nodes[b]?.prev = c
            nodes[b]?.next = d
            nodes[d]?.prev = b
            
        } else {
            // unlink the source node
            let beforeSrc = srcNode.prev
            let afterSrc = srcNode.next
            nodes[beforeSrc]?.next = afterSrc
            nodes[afterSrc]?.prev = beforeSrc
            
            
            let beforeDest = destNode.prev
            nodes[beforeDest]?.next = src
            nodes[src]?.prev = beforeDest
            
            nodes[src]?.next = dest
            nodes[dest]?.prev = src
        }
    }
    
    func move(from src: Index, after dest: Index) {
        defer { assertLinkIntegrity() }
        
        guard let srcNode = nodes[src] else { fatalError("Unknown index \(src)") }
        guard let destNode = nodes[dest] else { fatalError("Unknown index \(dest)") }
        
        if src == dest {
            // move the node "one right"
            // FROM: a -> b -> c -> d
            // TO: a -> c -> b -> d
            let a = srcNode.prev
            let b = src
            let c = srcNode.next
            let d = nodes[c]!.next
            
            nodes[a]?.next = c
            nodes[c]?.prev = a
            nodes[c]?.next = b
            nodes[b]?.prev = c
            nodes[b]?.next = d
            nodes[d]?.prev = b
        } else {
            // unlink the source node
            let beforeSrc = srcNode.prev
            let afterSrc = srcNode.next
            nodes[beforeSrc]?.next = afterSrc
            nodes[afterSrc]?.prev = beforeSrc
            
            
            let afterDest = destNode.next
            nodes[afterDest]?.prev = src
            nodes[src]?.next = afterDest
            
            nodes[src]?.prev = dest
            nodes[dest]?.next = src
        }
    }
    
    private func assertLinkIntegrity() {
        return
        let prevLinks = Set(nodes.values.map(\.prev))
        let nextLinks = Set(nodes.values.map(\.next))
        
        assert(prevLinks.count == nodes.count)
        assert(nextLinks.count == nodes.count)
    }
    
}
