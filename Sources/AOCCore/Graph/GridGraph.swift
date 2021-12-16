//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/13/21.
//

import Foundation
import GameplayKit

/// A `GridGraph` represents a cartesian coordinate system where every integral coordinate ((0,0), (1,1), etc)
/// is connected automatically to its orthogonal neighbors. All coordinates may also optionally connect to their
/// diagonal neighbors.
public struct GridGraph<Value: Equatable> {
    fileprivate typealias Node = _GKGridNode<Value>
    fileprivate typealias Graph = GKGridGraph<Node>
    
    private var graph: Graph
    private var _defaultTravelCost: Float = 1
    
    public var origin: Position { Position(graphPosition: graph.gridOrigin) }
    public var width: Int { graph.gridWidth }
    public var height: Int { graph.gridHeight }
    public var rect: PointRect { PointRect(origin: origin, width: width, height: height) }
    
    @discardableResult
    private mutating func mutate<T>(_ mutation: (inout Self, Graph) -> T) -> T {
        if !isKnownUniquelyReferenced(&graph) { duplicateGraph() }
        return mutation(&self, graph)
    }
    
    private mutating func duplicateGraph() {
        let g = GKGridGraph<Node>(fromGridStartingAt: graph.gridOrigin,
                                  width: Int32(graph.gridWidth), height: Int32(graph.gridHeight),
                                  diagonalsAllowed: graph.diagonalsAllowed,
                                  nodeClass: graph.classForGenericArgument(at: 0))
        
        for position in self.rect {
            if let oldNode = graph.node(atGridPosition: position.graphPosition),
               let newNode = g.node(atGridPosition: position.graphPosition) {
                newNode.value = oldNode.value
                newNode.entranceCost = oldNode.entranceCost
                newNode.exitCost = oldNode.exitCost
                newNode.defaultTravelCost = oldNode.defaultTravelCost
                newNode.travelCosts = oldNode.travelCosts
            }
        }
        
        graph = g
    }
    
    public init(origin: Position = .zero, width: Int, height: Int, positionsConnectDiagonally: Bool = false) {
        graph = GKGridGraph<Node>(fromGridStartingAt: origin.graphPosition,
                                  width: Int32(width), height: Int32(height),
                                  diagonalsAllowed: positionsConnectDiagonally,
                                  nodeClass: Node.self)
    }
    
    public var defaultTravelCost: Float {
        get { _defaultTravelCost }
        set {
            mutate { s, g in
                s._defaultTravelCost = newValue
                g.nodes?.forEach { ($0 as! Node).defaultTravelCost = newValue }
            }
        }
    }
    
    public subscript(position: Position) -> Value? {
        get { graph.node(atGridPosition: position.graphPosition)?.value }
        set {
            mutate { s, g in
                let node = g.node(atGridPosition: position.graphPosition)
                node?.value = newValue
                // this might be a new node
                node?.defaultTravelCost = s._defaultTravelCost
            }
        }
    }
    
    public subscript(entranceCost position: Position) -> Float {
        get { graph.node(atGridPosition: position.graphPosition)?.entranceCost ?? 0 }
        set {
            mutate { s, g in
                g.node(atGridPosition: position.graphPosition)?.entranceCost = newValue
            }
        }
    }
    
    public subscript(exitCost position: Position) -> Float {
        get { graph.node(atGridPosition: position.graphPosition)?.exitCost ?? 0 }
        set {
            mutate { s, g in
                g.node(atGridPosition: position.graphPosition)?.exitCost = newValue
            }
        }
    }
    
    public subscript(x: Int, _ y: Int) -> Value? {
        get { self[Position(x: x, y: y)] }
        set { self[Position(x: x, y: y)] = newValue }
    }
    
    public mutating func value(at position: Position, default missing: @autoclosure () -> Value) -> Value {
        if let existing = self[position] { return existing }
        return mutate { s, g in
            let newValue = missing()
            let node = g.node(atGridPosition: position.graphPosition)
            node?.value = newValue
            node?.defaultTravelCost = s._defaultTravelCost
            return newValue
        }
    }
    
    public func connections(from position: Position) -> Set<Position> {
        guard let node = graph.node(atGridPosition: position.graphPosition) else { return [] }
        return Set((node.connectedNodes as! Array<Node>).map(\.position))
    }
    
    public func path(from start: Position, to end: Position) -> Array<Position> {
        guard let s = graph.node(atGridPosition: start.graphPosition) else { return [] }
        guard let e = graph.node(atGridPosition: end.graphPosition) else { return [] }
        let path = graph.findPath(from: s, to: e) as! Array<Node>
        return path.map(\.position)
    }
    
    public func cost(of path: Array<Position>) -> Float? {
        switch path.count {
            case 0: return nil
            case 1: return 0
            default:
                return path.adjacentPairs().sum(of: {
                    let a = graph.node(atGridPosition: $0.graphPosition)!
                    let b = graph.node(atGridPosition: $1.graphPosition)!
                    return a.cost(to: b)
                })
        }
    }
    
    public func cost(from start: Position, to end: Position) -> Float? {
        let path = self.path(from: start, to: end)
        return cost(of: path)
    }
    
    public func travelCost(from start: Position, to end: Position) -> Float {
        guard rect.contains(start) else { return 0 }
        guard rect.contains(end) else { return 0 }
        let s = graph.node(atGridPosition: start.graphPosition)!
        let e = graph.node(atGridPosition: end.graphPosition)!
        return s.travelCosts[e.position] ?? _defaultTravelCost
    }
    
    public mutating func setTravelCost(_ cost: Float?, from start: Position, to end: Position, bidirectional: Bool = true) {
        guard rect.contains(start) else { return }
        guard rect.contains(end) else { return }
        mutate { s, g in
            let sNode = g.node(atGridPosition: start.graphPosition)!
            let eNode = g.node(atGridPosition: end.graphPosition)!
            
            sNode.travelCosts[eNode.position] = cost
            if bidirectional {
                eNode.travelCosts[sNode.position] = cost
            }
        }
    }
    
}

extension GridGraph: Sequence {
    
    public typealias Element = (position: Position, value: Value)
    
    public struct Iterator: IteratorProtocol {
        fileprivate let graph: Graph
        private var iterator: PointRect.Iterator
        fileprivate init(graph: Graph, iterator: PointRect.Iterator) {
            self.graph = graph
            self.iterator = iterator
        }
        
        public mutating func next() -> Element? {
            while let next = iterator.next() {
                if let value = graph.node(atGridPosition: next.graphPosition)?.value {
                    return (position: next, value: value)
                }
            }
            return nil
        }
    }
    
    public func makeIterator() -> Iterator {
        return Iterator(graph: graph, iterator: rect.makeIterator())
    }
    
}

extension GridGraph: Equatable {
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        if lhs.graph === rhs.graph { return true }
        // not the same graph
        // but maybe they have the same structure?
        
        // they must have the same size
        guard lhs.rect == rhs.rect else { return false }
        
        //
        for p in lhs.rect {
            let lValue = lhs[p]
            let rValue = rhs[p]
            if lValue != rValue { return false }
        }
        
        return true
    }
    
}

extension GridGraph: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        // quick and dirty way to do a hash
        // graphs that have different sizes will hash to different values
        hasher.combine(rect)
    }
    
}

extension Position {
    
    fileprivate var graphPosition: vector_int2 { .init(x: Int32(x), y: Int32(y)) }
    fileprivate init(graphPosition: vector_int2) {
        self.init(x: Int(graphPosition.x), y: Int(graphPosition.y))
    }
    
}

private class _GKGridNode<Value: Equatable>: GKGridGraphNode {
    var position: Position { Position(graphPosition: gridPosition) }
    var value: Value?
    
    var entranceCost: Float = 0
    var travelCosts: Dictionary<Position, Float> = [:]
    var exitCost: Float = 0
    
    var defaultTravelCost: Float = 1
    
    override init(gridPosition: vector_int2) {
        super.init(gridPosition: gridPosition)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func cost(to node: GKGraphNode) -> Float {
        if node === self { return 0 }
        
        guard let destination = node as? _GKGridNode<Value> else {
            return super.cost(to: node)
        }
        
        // the cost of going from this node to that node is:
        // the cost to leave this node plus...
        // the cost to travel to the other node plus...
        // the cost to enter the other node
        let travelCost = travelCosts[destination.position] ?? defaultTravelCost
        return exitCost + travelCost + destination.entranceCost
    }
}
