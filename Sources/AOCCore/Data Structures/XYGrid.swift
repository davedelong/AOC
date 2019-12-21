//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/14/19.
//

import Foundation
import GameplayKit

public struct XYGrid<T> {
    
    public private(set) var grid = Dictionary<XY, T>()
    
    public init() { }
    
    public subscript(key: XY) -> T? {
        get { return grid[key] }
        set { grid[key] = newValue }
    }
    
    public var positions: Dictionary<XY, T>.Keys { return grid.keys }
    public var values: Dictionary<XY, T>.Values { return grid.values }
    
    public func draw(using renderer: (T?) -> String) {
        
        let xRange = grid.keys.map { $0.x }.range()
        let yRange = grid.keys.map { $0.y }.range()
        
        for y in yRange {
            for x in xRange {
                let xy = XY(x: x, y: y)
                let s = renderer(grid[xy])
                print(s, terminator: "")
            }
            print("")
        }
        
    }
    
    public func convertToGridGraph(_ canEnterPosition: (T) -> Bool) -> GKGridGraph<GridNode<T>> {
        
        let xRange = grid.keys.map { $0.x }.range()
        let yRange = grid.keys.map { $0.y }.range()
        
        let g: GKGridGraph<GridNode<T>> = GKGridGraph(fromGridStartingAt: vector_int2(x: Int32(xRange.lowerBound), y: Int32(yRange.lowerBound)),
                                                      width: Int32(xRange.count),
                                                      height: Int32(yRange.count),
                                                      diagonalsAllowed: false,
                                                      nodeClass: GridNode<T>.self)
        
        for x in xRange {
            for y in yRange {
                let node = g.node(atGridPosition: vector_int2(x: Int32(x), y: Int32(y)))!
                node.value = self[XY(x: x, y: y)]!
                
                if canEnterPosition(node.value!) == false {
                    let connections = node.connectedNodes
                    node.removeConnections(to: connections, bidirectional: true)
                }
            }
        }
        
        return g
    }
    
}

public class GridNode<T>: GKGridGraphNode {
    
    public var value: T?
    
    public override var description: String {
        return "Node<\(T.self)>(\(String(describing: value)))"
    }
    
    public override init(gridPosition: vector_int2) {
        super.init(gridPosition: gridPosition)
    }
    
    public init(_ value: T, position: vector_int2) {
        self.value = value
        super.init(gridPosition: position)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
