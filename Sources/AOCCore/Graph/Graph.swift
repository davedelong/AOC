//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/11/21.
//

import Foundation
import GameplayKit

/// A directed, cyclic graph structure
///
/// Nodes are identified and located by an `ID`, and every node holds a `Value`.
///
/// In additions, nodes can have *costs* associated with them:
/// - A cost to *enter* the node. The default value is `0` for all nodes
/// - A cost to *exit* the node. The default value is `0` for all nodes
/// - A cost to *travel* from one node to another. The default value is `1` for all nodes
public struct Graph<ID: Hashable, Value: Equatable> {
    fileprivate typealias Node = _GKNode<ID, Value>
    
    private var graph: GKGraph
    private var nodesByID = Dictionary<ID, Node>()
    private var _defaultTravelCost: Float = 1
    
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
            dupedNode?.entranceCost = node.entranceCost
            dupedNode?.travelCosts = node.travelCosts
            dupedNode?.defaultTravelCost = node.defaultTravelCost
            dupedNode?.exitCost = node.exitCost
        }
        
        graph = g
        nodesByID = dupesByID
    }
    
    public init() {
        graph = GKGraph()
    }
    
    public var values: Array<Value> { nodesByID.values.map(\.value) }
    
    public var defaultTravelCost: Float {
        get { _defaultTravelCost }
        set {
            mutate { s, _ in
                s._defaultTravelCost = newValue
                s.nodesByID.values.forEach { $0.defaultTravelCost = newValue }
            }
        }
    }
    
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
                        s.nodesByID.values.forEach { other in
                            other.travelCosts.removeValue(forKey: n.id)
                        }
                        
                    case (.some(let v), .none):
                        let newNode = Node(id: id, value: v)
                        newNode.defaultTravelCost = s._defaultTravelCost
                        g.add([newNode])
                        s.nodesByID[id] = newNode
                        
                    case (.some(let v), .some(let n)):
                        n.value = v
                }
            }
        }
    }
    
    public subscript(entranceCost id: ID) -> Float? {
        get { nodesByID[id]?.entranceCost }
        set {
            mutate { s, g in
                s.nodesByID[id]?.entranceCost = newValue ?? 0
            }
        }
    }
    
    public subscript(exitCost id: ID) -> Float? {
        get { nodesByID[id]?.exitCost }
        set {
            mutate { s, g in
                s.nodesByID[id]?.exitCost = newValue ?? 0
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
    
    public func connections(from id: ID) -> Set<ID> {
        guard let node = nodesByID[id] else { return [] }
        return Set((node.connectedNodes as! Array<Node>).map(\.id))
    }
    
    public func path(from start: ID, to end: ID) -> Array<ID> {
        guard let s = nodesByID[start] else { return [] }
        guard let e = nodesByID[end] else { return [] }
        let path = graph.findPath(from: s, to: e) as! Array<Node>
        return path.map(\.id)
    }
    
    public func cost(of path: Array<ID>) -> Float? {
        switch path.count {
            case 0: return nil
            case 1: return 0
            default:
                return path.adjacentPairs().sum(of: {
                    nodesByID[$0]!.cost(to: nodesByID[$1]!)
                })
        }
    }
    
    public func cost(from start: ID, to end: ID) -> Float? {
        let path = self.path(from: start, to: end)
        return cost(of: path)
    }
    
    public func travelCost(from start: ID, to end: ID) -> Float {
        guard let s = nodesByID[start] else { return 0 }
        guard let e = nodesByID[end] else { return 0 }
        return s.travelCosts[e.id] ?? 0
    }
    
    public mutating func setTravelCost(_ cost: Float?, from start: ID, to end: ID, bidirectional: Bool = true) {
        guard nodesByID.keys.contains(start) else { return }
        guard nodesByID.keys.contains(end) else { return }
        mutate { s, g in
            let sNode = s.nodesByID[start]!
            let eNode = s.nodesByID[end]!
            
            sNode.travelCosts[eNode.id] = cost
            if bidirectional {
                eNode.travelCosts[sNode.id] = cost
            }
        }
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
        
        // the node values and costs must be equal
        for (id, lhsNode) in lhs.nodesByID {
            let rhsNode = rhs.nodesByID[id]! // safe; i've already determined their key sets are equal
            // the node values must be equal
            if lhsNode.value != rhsNode.value { return false }
            if lhsNode.entranceCost != rhsNode.entranceCost { return false }
            if lhsNode.travelCosts != rhsNode.travelCosts { return false }
            if lhsNode.defaultTravelCost != rhsNode.defaultTravelCost { return false }
            if lhsNode.exitCost != rhsNode.exitCost { return false }
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

extension Graph where ID == Value {
    public mutating func add(_ id: ID) {
        self[id] = id
    }
    
    public mutating func remove(_ id: ID) {
        self[id] = nil
    }
}


internal class _GKNode<ID: Hashable, V: Equatable>: GKGraphNode {
    let id: ID
    var value: V
    
    var entranceCost: Float = 0
    var travelCosts: Dictionary<ID, Float> = [:]
    var exitCost: Float = 0
    
    var defaultTravelCost: Float = 0
    
    required init(id: ID, value: V) {
        self.id = id
        self.value = value
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func cost(to node: GKGraphNode) -> Float {
        if node === self { return 0 }
        
        guard let destination = node as? _GKNode<ID, V> else {
            return super.cost(to: node)
        }
        
        // the cost of going from this node to that node is:
        // the cost to leave this node plus...
        // the cost to travel to the other node plus...
        // the cost to enter the other node
        let travelCost = travelCosts[destination.id] ?? defaultTravelCost
        return exitCost + travelCost + destination.entranceCost
    }
}
