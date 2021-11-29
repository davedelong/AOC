//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/5/19.
//

import Foundation

public class Node<T>: Hashable, CustomStringConvertible {
    public static func ==(lhs: Node<T>, rhs: Node<T>) -> Bool { return lhs.id == rhs.id }
    
    private lazy var id: ObjectIdentifier = { ObjectIdentifier(self) }()
    
    public let value: T
    
    public private(set) weak var parent: Node<T>?
    
    public private(set) var children: Set<Node<T>>
    
    public var numberOfParents: Int { return numberOfParents(to: nil) }
    
    public var description: String { return "Node<\(T.self)>(value: \(value))" }
    
    public init(value: T) {
        self.value = value
        self.children = []
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public func addChild(_ node: Node<T>) {
        node.removeFromParent()
        node.parent = self
        children.insert(node)
    }
    
    public func removeFromParent() {
        parent?.children.remove(self)
        self.parent = nil
    }
    
    public func allParents() -> UnfoldSequence<Node<T>, Node<T>> {
        let s = sequence(state: self, next: { state -> Node<T>? in
            if let p = state.parent { state = p }
            return state.parent
        })
        return s
    }
    
    public func firstParentInCommon(with other: Node<T>) -> Node<T>? {
        let myParents = Set(allParents())
        for potentialAncestor in other.allParents() {
            if myParents.contains(potentialAncestor) { return potentialAncestor }
        }
        return nil
    }
    
    public func numberOfParents(to ancestor: Node<T>?) -> Int {
        var c = 0
        var p = parent
        while p != ancestor && p != nil {
            c += 1
            p = p?.parent
        }
        return c
    }
    
}
