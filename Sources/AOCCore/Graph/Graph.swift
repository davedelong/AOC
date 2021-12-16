//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/11/21.
//

import Foundation
import GameplayKit

public struct Graph<ID: Hashable, Value: Equatable> {
    fileprivate typealias Node = _GKNode<ID, Value>
    
    private var graph: GKGraph
    private var nodesByID = Dictionary<ID, Node>()
    
    @discardableResult
    private mutating func mutate<T>(_ mutation: (inout Self, GKGraph) -> T) -> T {
        if !isKnownUniquelyReferenced(&graph) { duplicateGraph() }
        return mutation(&self, graph)
    }
    
    private mutating func duplicateGraph() {
        let g = GKGraph()
        let nodes = (graph.nodes ?? []) as! Array<Node>
        let dupes = nodes.map { Node(id: $0.id, value: $0.value) }
        let dupesByID = Dictionary(uniqueKeysWithValues: dupes.map { ($0.id, $0) })
        
        g.add(dupes)
        
        for node in nodes {
            let connections = (node.connectedNodes as! Array<Node>).map(\.id)
            
            let dupedNode = dupesByID[node.id]
            let dupedConnections = connections.map { dupesByID[$0]! }
            dupedNode?.addConnections(to: dupedConnections, bidirectional: false)
        }
        
        graph = g
        nodesByID = dupesByID
    }
    
    public init() {
        graph = GKGraph()
    }
    
    public var values: Array<Value> { nodesByID.values.map(\.value) }
    
    public subscript(id: ID) -> Value? {
        get { nodesByID[id]?.value }
        set {
            mutate { s, g in
                let node = s.nodesByID[id]
                switch (newValue, node) {
                    case (.none, .none):
                        break
                    case (.none, .some(let n)):
                        g.remove([n])
                        s.nodesByID.removeValue(forKey: n.id)
                    case (.some(let v), .none):
                        let newNode = Node(id: id, value: v)
                        g.add([newNode])
                        s.nodesByID[id] = newNode
                    case (.some(let v), .some(let n)):
                        n.value = v
                }
            }
        }
    }
    
    public mutating func value(with id: ID, default missing: @autoclosure () -> Value) -> Value {
        if let existing = self[id] { return existing }
        return mutate { s, g in
            let newValue = missing()
            let newNode = Node(id: id, value: newValue)
            s.nodesByID[id] = newNode
            g.add([newNode])
            return newValue
        }
    }
    
    public mutating func connect(_ id: ID, to other: ID, bidirectional: Bool = true) {
        mutate { s, _ in
            guard let sNode = s.nodesByID[id] else { return }
            guard let eNode = s.nodesByID[other] else { return }
            sNode.addConnections(to: [eNode], bidirectional: bidirectional)
        }
    }
    
    public mutating func disconnect(_ id: ID, from other: ID, bidirectional: Bool = true) {
        mutate { s, _ in
            guard let sNode = s.nodesByID[id] else { return }
            guard let eNode = s.nodesByID[other] else { return }
            sNode.removeConnections(to: [eNode], bidirectional: bidirectional)
        }
    }
    
    public func connections(from id: ID) -> Array<ID> {
        guard let node = nodesByID[id] else { return [] }
        return (node.connectedNodes as! Array<Node>).map(\.id)
    }
    
    public func path(from start: ID, to end: ID) -> Array<ID> {
        guard let s = nodesByID[start] else { return [] }
        guard let e = nodesByID[end] else { return [] }
        let path = graph.findPath(from: s, to: e) as! Array<Node>
        return path.map(\.id)
    }
    
}

extension Graph: Sequence {
    
    public typealias Element = (id: ID, value: Value)
    
    public struct Iterator: IteratorProtocol {
        fileprivate var base: Dictionary<ID, Node>.Iterator
        
        public mutating func next() -> Element? {
            guard let (id, node) = base.next() else { return nil }
            return (id: id, value: node.value)
        }
    }
    
    public func makeIterator() -> Iterator {
        let i = nodesByID.makeIterator()
        return Iterator(base: i)
    }
    
}

extension Graph: Equatable {
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        if lhs.graph === rhs.graph { return true }
        // not the same graph
        // but maybe they have the same structure?
        
        // they must have the same set of node IDs
        if lhs.nodesByID.keys != rhs.nodesByID.keys { return false }
        
        // the node values must be equal
        for (id, lhsNode) in lhs.nodesByID {
            let rhsNode = rhs.nodesByID[id]! // safe; i've already determined their key sets are equal
            // the node values must be equal
            if lhsNode.value != rhsNode.value { return false }
        }
        
        // finally, the connections between nodes must be equal
        for (id, _) in lhs {
            let lConnections = lhs.connections(from: id)
            let rConnections = rhs.connections(from: id)
            
            if lConnections.count != rConnections.count { return false }
            if Set(lConnections) != Set(rConnections) { return false }
        }
        
        return true
    }
    
}

extension Graph: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        // quick and dirty way to do a hash
        // graphs that have different numbers of nodes will hash to different values
        hasher.combine(values.count)
    }
    
}



internal class _GKNode<ID: Hashable, V: Equatable>: GKGraphNode {
    
    let id: ID
    var value: V
    
    required init(id: ID, value: V) {
        self.id = id
        self.value = value
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
