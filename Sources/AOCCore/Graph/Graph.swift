//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/11/21.
//

import Foundation
import GameplayKit

public protocol GraphNode: Equatable {
    associatedtype ID: Hashable
    var id: ID { get }
}

extension Int: GraphNode {
    public var id: Int { self }
}
extension String: GraphNode {
    public var id: String { self }
}
extension Double: GraphNode {
    public var id: Double { self }
}

public class Graph<Node: GraphNode> {
    private let graph: GKGraph
    private var gkNodes = Dictionary<Node.ID, _GKNode<Node>>()
    
    public init() {
        self.graph = GKGraph()
    }
    
    public var nodes: Array<Node> {
        return (graph.nodes as! Array<_GKNode<Node>>).map(\.node)
    }
    
    public func add(_ node: Node) {
        guard gkNodes[node.id] == nil else { return }
        let n = _GKNode(node)
        gkNodes[node.id] = n
        graph.add([n])
    }
    
    public func remove(_ node: Node) {
        if let n = gkNodes.removeValue(forKey: node.id) {
            graph.remove([n])
        }
    }
    
    public func node(with id: Node.ID) -> Node? {
        return gkNodes[id]?.node
    }
    
    public func node(with id: Node.ID, default missing: @autoclosure () -> Node) -> Node {
        if let existing = gkNodes[id] {
            return existing.node
        } else {
            let newNode = missing()
            assert(newNode.id == id)
            add(newNode)
            return newNode
        }
    }
    
    public func connect(node: Node, to other: Node, bidirectional: Bool = true) {
        guard let s = gkNodes[node.id], let e = gkNodes[other.id] else { return }
        s.addConnections(to: [e], bidirectional: bidirectional)
    }
    
    public func disconnect(node: Node, from other: Node, bidirectional: Bool = true) {
        guard let s = gkNodes[node.id], let e = gkNodes[other.id] else { return }
        s.removeConnections(to: [e], bidirectional: bidirectional)
    }
    
    public func connections(from node: Node) -> Array<Node> {
        guard let n = gkNodes[node.id] else { return [] }
        let connections = n.connectedNodes as! Array<_GKNode<Node>>
        return connections.map(\.node)
    }
    
    public func path(from start: Node, to end: Node) -> Array<Node> {
        guard let s = gkNodes[start.id], let e = gkNodes[end.id] else { return [] }
        let path = graph.findPath(from: s, to: e) as! Array<_GKNode<Node>>
        return path.map(\.node)
    }
    
}

private class _GKNode<N: GraphNode>: GKGraphNode {
    let node: N
    
    init(_ node: N) {
        self.node = node
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
