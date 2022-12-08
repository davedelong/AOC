//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/5/19.
//

import Foundation

@dynamicMemberLookup
public final class Node<T>: Hashable, CustomStringConvertible, TreeNode {
    public static func ==(lhs: Node<T>, rhs: Node<T>) -> Bool { return lhs.id == rhs.id }
    
    private lazy var id: ObjectIdentifier = { ObjectIdentifier(self) }()
    
    public let value: T
    
    public private(set) weak var parent: Node<T>?
    
    public private(set) var children: Array<Node<T>>
    
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
        children.append(node)
    }
    
    public func removeChild(_ node: Node<T>) {
        assert(node.parent === self)
        children.removeAll(where: { $0 === node })
        node.parent = nil
    }
    
    public func removeFromParent() {
        parent?.removeChild(self)
    }
    
    public var allParents: UnfoldSequence<Node<T>, (Node<T>?, Bool)> {
        return sequence(first: self, next: \.parent)
    }
    
    public func firstParentInCommon(with other: Node<T>) -> Node<T>? {
        let myParents = Set(allParents)
        for potentialAncestor in other.allParents {
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

    public subscript<V>(dynamicMember keyPath: KeyPath<T, V>) -> V {
        return value[keyPath: keyPath]
    }
}
