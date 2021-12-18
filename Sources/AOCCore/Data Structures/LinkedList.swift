//
//  File.swift
//  
//
//  Created by Dave DeLong on 11/14/19.
//

import Foundation

public struct LinkedListIterator<Value>: IteratorProtocol {
    fileprivate let list: LinkedList<Value>
    private var current: LinkedList<Value>.Node?
    private let mutationCount: Int
    
    init(_ list: LinkedList<Value>) {
        self.list = list
        self.current = list.head
        self.mutationCount = list.mutationCounter
    }
    
    public mutating func next() -> Value? {
        guard mutationCount == list.mutationCounter else {
            fatalError("LinkedList mutated during iteration. This is illegal")
        }
        let v = current?.value
        current = current?.next
        return v
    }
}

public class LinkedList<Element>: Sequence, ExpressibleByArrayLiteral {
    
    public class Node {
        public var value: Element
        public fileprivate(set) weak var prev: Node?
        public fileprivate(set) var next: Node?
        fileprivate init(_ value: Element) {
            self.value = value
        }
    }
    
    public private(set) var head: Node?
    public private(set) var tail: Node?
    fileprivate var mutationCounter = 0
    
    public private(set) var count: Int = 0
    public var underestimatedCount: Int { return count }
    
    public init() { }
    
    required public convenience init(arrayLiteral elements: Element...) {
        self.init()
        elements.forEach(self.append)
    }
    
    public convenience init<C: Collection>(_ collection: C) where C.Element == Element {
        self.init()
        for item in collection {
            append(item)
        }
    }
    
    public var isEmpty: Bool { return count == 0 }
    public var first: Element? { return head?.value }
    public var last: Element? { return tail?.value }
    
    private func node(at index: Int) -> Node? {
        var current = head
        var offset = 0
        while offset < index && current != nil {
            current = current?.next
            offset += 1
        }
        return current
    }
    
    // copying
    
    public func copy() -> LinkedList<Element> {
        let c = LinkedList<Element>()
        for item in self {
            c.append(item)
        }
        return c
    }
    
    // additions
    
    public func append(_ value: Element) {
        let node = Node(value)
        tail?.next = node
        node.prev = tail
        tail = node
        if head == nil { head = node }
    }
    
    public func insert(_ value: Element, at index: Int) {
        let node = Node(value)
        
        if index <= 0 {
            node.next = head
            head?.prev = node
            head = node
            if tail == nil { tail = node }
        } else if index >= count {
            tail?.next = node
            node.prev = tail
            tail = node
            if head == nil { head = node }
        } else if let predecessor = self.node(at: index - 1) {
            let successor = predecessor.next
            
            node.next = successor
            node.prev = predecessor
            
            predecessor.next = node
            successor?.prev = node
        } else {
            fatalError("Unable to insert value at index \(index)")
        }
        count += 1
        mutationCounter += 1
    }
    
    @discardableResult
    public func insert(_ value: Element, after prior: Node) -> Node {
        let node = Node(value)
        
        let next = prior.next
        prior.next = node
        node.prev = prior
        
        node.next = next
        next?.prev = node
        
        if next == nil {
            tail = node
        }
        count += 1
        mutationCounter += 1
        
        return node
    }
    
    public func delete(_ node: Node) {
        let prior = node.prev
        let after = node.next
        
        prior?.next = after
        after?.prev = prior
        
        if prior == nil {
            head = after
        }
        if after == nil {
            tail = prior
        }
        count -= 1
        mutationCounter += 1
    }
    
    // subtractions
    
    public func removeAll() {
        head = nil
        tail = nil
        count = 0
        mutationCounter += 1
    }
    
    public func popFirst() -> Element? {
        guard count > 0 else { return nil }
        return removeFirst()
    }
    
    public func popLast() -> Element? {
        guard count > 0 else { return nil }
        return removeLast()
    }
    
    public func removeFirst() -> Element {
        return remove(at: 0)
    }
    
    public func removeLast() -> Element {
        return remove(at: count - 1)
    }
    
    public func firstIndex(where predicate: (Element) -> Bool) -> Int? {
        var current = head
        var index = 0
        while let this = current {
            if predicate(this.value) == true {
                return index
            }
            current = this.next
            index += 1
        }
        return nil
    }
    
    public func remove(at index: Int) -> Element {
        guard index >= 0 && index < count else { fatalError("Cannot retrieve node at index \(index)") }
        let n: Node
        if index == 0 {
            n = head!
        } else if index == count - 1 {
            n = tail!
        } else {
            n = node(at: index)!
        }
                
        let value = n.value
        
        let prev = n.prev
        let next = n.next
        
        prev?.next = next
        next?.prev = prev
        
        if n === head { head = next }
        if n === tail { tail = prev }
        
        count -= 1
        mutationCounter += 1
        return value
    }
    
    public func append<S: Sequence>(contentsOf sequence: S) where S.Element == Element {
        for i in sequence {
            self.append(i)
        }
    }
    
    // iteration
    
    public func makeIterator() -> LinkedListIterator<Element> {
        return LinkedListIterator(self)
    }
    
}

extension LinkedList: Equatable where Element: Equatable {
    
    public static func ==(lhs: LinkedList, rhs: LinkedList) -> Bool {
        if lhs === rhs { return true }
        guard lhs.count == rhs.count else { return false }
        var l = lhs.makeIterator()
        var r = rhs.makeIterator()
        
        while let nextL = l.next(), let nextR = r.next() {
            guard nextL == nextR else { return false }
        }
        
        return true
    }
    
}

extension LinkedList: Hashable where Element: Equatable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(count)
    }
    
}
