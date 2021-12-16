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
    
    public var origin: Position { Position(graphPosition: graph.gridOrigin) }
    public var width: Int { graph.gridWidth }
    public var height: Int { graph.gridHeight }
    public var rect: PointRect { PointRect(origin: origin, width: width, height: height) }
    
    @discardableResult
    private mutating func mutate<T>(_ mutation: (Graph) -> T) -> T {
        if !isKnownUniquelyReferenced(&graph) { duplicateGraph() }
        return mutation(graph)
    }
    
    private mutating func duplicateGraph() {
        let g = GKGridGraph<Node>(fromGridStartingAt: graph.gridOrigin,
                                  width: Int32(graph.gridWidth), height: Int32(graph.gridHeight),
                                  diagonalsAllowed: graph.diagonalsAllowed,
                                  nodeClass: graph.classForGenericArgument(at: 0))
        
        for position in self.rect {
            if let value = self[position] {
                let node = g.node(atGridPosition: position.graphPosition)
                node?.value = value
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
    
    public subscript(position: Position) -> Value? {
        get { graph.node(atGridPosition: position.graphPosition)?.value }
        set {
            mutate {
                let node = $0.node(atGridPosition: position.graphPosition)
                node?.value = newValue
            }
        }
    }
    
    public subscript(x: Int, _ y: Int) -> Value? {
        get { self[Position(x: x, y: y)] }
        set { self[Position(x: x, y: y)] = newValue }
    }
    
    public mutating func value(at position: Position, default missing: @autoclosure () -> Value) -> Value {
        if let existing = self[position] { return existing }
        return mutate {
            let newValue = missing()
            let node = $0.node(atGridPosition: position.graphPosition)
            node?.value = newValue
            return newValue
        }
    }
    
    public func connections(from position: Position) -> Array<Position> {
        guard let node = graph.node(atGridPosition: position.graphPosition) else { return [] }
        return (node.connectedNodes as! Array<Node>).map(\.position)
    }
    
    public func path(from start: Position, to end: Position) -> Array<Position> {
        guard let s = graph.node(atGridPosition: start.graphPosition) else { return [] }
        guard let e = graph.node(atGridPosition: end.graphPosition) else { return [] }
        let path = graph.findPath(from: s, to: e) as! Array<Node>
        return path.map(\.position)
    }
    
}

extension GridGraph: Sequence {
    
    public typealias Element = (position: Position, value: Value)
    
    public struct Iterator: IteratorProtocol {
        fileprivate let graph: Graph
        private var iterator: Array<Position>.Iterator
        fileprivate init(graph: Graph) {
            self.graph = graph
            let xRange = Int(graph.gridOrigin.x) ... (Int(graph.gridOrigin.x) + graph.gridWidth - 1)
            let yRange = Int(graph.gridOrigin.y) ... (Int(graph.gridOrigin.y) + graph.gridHeight - 1)
            self.iterator = Position.all(in: xRange, yRange).makeIterator()
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
        return Iterator(graph: graph)
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
    
    override init(gridPosition: vector_int2) {
        super.init(gridPosition: gridPosition)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
